#!/bin/bash
#
# This script installs and configures Twistlock
#

# Silence tput errors when script is run by process not attached to a terminal
tput_silent() {
    tput "$@" 2>/dev/null
}

if [ "$(id -u)" != "0" ]; then
	echo "$(tput_silent setaf 1)This script must be run as root $(tput_silent sgr0)"
	exit 1
fi

# Global initialization
# Working folder is the folder where Twistlock scripts and images reside
working_folder=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
config_file=$working_folder"/twistlock.cfg"
syslog_mount="/dev/log"
if [ -e "${config_file}" ]; then
	source ${config_file}
else
	echo "Configuration file $config_file must be present"
	exit
fi

console_bundle=twistlock_console.tar.gz
defender_bundle_linux_docker=twistlock_defender.tar.gz
defender_bundle_linux_server=twistlock_defender_server.tar.gz

console_service=twistlock-console.service
defender_service=twistlock-defender.service
server_defender_service=twistlock-defender-server.service

onebox_component=onebox
console_component=console
defender_component_docker=defender
defender_component_linux_server=defender-server
defender_component_pcf=defender-pcf

# docker's security opt operator, to be used in '--security-opt label${security_opt_operator}role:ROLE'.
# Different docker versions has different values ('=' vs ':')
security_opt_operator="="

# Global flags
# Debug log level
debug_log_level="false"
# Location of Twistlock install logs
install_log="twistlock-install.log"
console_container_name=twistlock_console

# Silence tput errors when script is run by process not attached to a terminal
tput_silent() {
	tput "$@" 2>/dev/null
}

print_debug() {
	debug=$1
	if [[ $debug_log_level == "true" ]]; then
		echo "$(tput_silent setaf 7)$debug.$(tput_silent sgr0)"
	fi
	echo $debug >> $install_log
}

# checks whether the given path is a docker socket or not
is_valid_docker_socket() {
	socketPath=$1
	if [ ! -S $socketPath ]; then
		return 1
	fi
	docker -H unix://$socketPath info >> /dev/null 2>&1
	return $?
}

# Try to get Docker version using format flag. For older versions it may fail because format flag doesnt exist (self parse it)
set_docker_version() {
	docker_version=$($docker version --format '{{.Server.Version}}' 2>/dev/null)
	if [[ $? != 0 ]]; then
		docker_version=$($docker version | grep -i -A1 '^server' | grep -i 'version:' | awk '{print $NF; exit}' | tr -d '[:alpha:]-,')
	fi
}

docker_socket_folder=$(dirname $DOCKER_SOCKET)
new_docker_socket="$docker_socket_folder/docker.tw.sock"

# Sets the docker command to variable 'docker' after stopping the defender. Regardless of local socket mode, the socket should be at the original path
set_docker_command_on_defender_stop() {
	is_valid_docker_socket ${new_docker_socket}
	if [[ $? == 0 ]]; then
		exit_now "Failed to set valid docker socket, docker socket shouldn't be at ${new_docker_socket}"
	fi

	is_valid_docker_socket ${DOCKER_SOCKET}
	exit_on_failure $? "Failed to find valid docker socket"

	if [[ $? == 0 ]]; then
		docker="docker -H unix://${DOCKER_SOCKET}"
		print_debug "setting docker command after Defender stop to $docker"
		return
	fi
}

# Sets the docker command to variable 'docker' by testing naively the possible docker sockets
set_docker_command() {
	is_valid_docker_socket $new_docker_socket
	if [[ $? == 0 ]]; then
		docker="docker -H unix://$new_docker_socket"
		print_debug "setting initial docker command to $docker"
		return
	fi

	is_valid_docker_socket ${DOCKER_SOCKET}
	if [[ $? == 0 ]]; then
		docker="docker -H unix://${DOCKER_SOCKET}"
		print_debug "setting initial docker command to $docker"
		return
	fi

	exit_now "Failed to find valid docker socket"
}

# Default os distribution
host_os_distribution=${HOST_OS_DISTRIBUTION:-`grep DISTRIB_ID /etc/*-release | awk -F '=' '{print $2}'`}

# SELinux mode specifies the SELinux enforcement mode
selinux_enabled=

defender_image=""
console_image=""

print_info() {
	info=$1
	echo "$(tput_silent setaf 2)$info.$(tput_silent sgr0)"
	echo $info >> $install_log
}

print_error() {
	error=$1
	echo "$(tput_silent setaf 1)$error.$(tput_silent sgr0)"
	echo $error >> $install_log
}

print_warning() {
	warning=$1
	echo "$(tput_silent setaf 3)$warning.$(tput_silent sgr0)"
	echo $warning >> $install_log
}

approve_disclaimer() {
	echo "
Dear Customer,

Please review the license terms included in the provided twistlock-license.txt file.

If you agree to the terms listed in the file please type 'agree' to continue, otherwise please press Ctrl-C to
abort the installation.
"
	read agree

	if [ "$agree" != "agree" ]; then
		echo "The terms were denied. Exiting..."
		exit 1;
	else
		echo "Thanks for agreeing! Continuing the installation..."
	fi
}

remove_container() {
	container_name=$1
	remove_image=$2

	# Find container lines in docker ps output
	container=$($docker ps -a --format "{{ .Names }}" | grep ${container_name})
	print_debug "Removing container $container"

	# Check if container is running
	running=$($docker inspect --format="{{ .State.Running }}" $container 2> /dev/null)

	if [ $? -eq 1 ]; then
		print_debug "Container $container does not exist"
		return
	fi

	if [ "$running" == "true" ]; then
		print_debug "Container $container is running, stopping it"
		$docker stop $container >> $install_log 2>&1
	fi

	# If the removed container was defender in local socket mode, then he restored the docker socket when stopping to $DOCKER_SOCKET
	if [[ $container_name == "twistlock_defender" ]]; then
		set_docker_command_on_defender_stop
	fi

	if [[ "$remove_image" == "true" ]]; then
		image=$($docker inspect --format="{{ .Image }}" $container 2> /dev/null)
	fi

	$docker rm -f -v $container >> $install_log 2>&1

	if [[ "$remove_image" == "true" ]]; then
		print_debug "Removing container $container image $image"
		$docker rmi $image
	fi
}

# validate a container is up and not restarting with a retry mechanism with up to three attempts
validate_container_up() {
	container=$1
	local retries=$2
	print_debug "Verifying container $container is up"

	# Check if container is running
	running=$($docker inspect --format="{{ .State.Running }}" $container 2> /dev/null)
	if [ $? -eq 1 ]; then
		exit_now "Container ${container} does not exist. Deployment failed"
	fi

	local n=0
	until [[ ${n} -ge ${retries} ]]; do
		running=$($docker inspect --format="{{ .State.Running }}" $container 2> /dev/null)
		if [ "$running" == "true" ]; then
			break
		fi
		error_msg="Container ${container} is not running; ${running}"
		print_warning "${error_msg}. Retrying..."
		sleep 1

		n=$[${n}+1]
	done
	if [ ${n} -ge ${retries} ]; then
		exit_now "${error_msg}. Deployment failed"
	fi

	restart_count=$($docker inspect --format="{{ .RestartCount }}" $container 2> /dev/null)
	if [ "${restart_count}" != "0" ]; then
		exit_now "Container ${container} has restarted multiple times (${restart_count}); Deployment failed"
	fi
}

install_console() {
	console_address=$1
	drop_db=$2

	set_data_folder_permissions

	print_info "Initializing Twistlock environment"
	if [[ ${HIGH_AVAILABILITY_ENABLED} == "true" && "${HIGH_AVAILABILITY_STATE}" == "PRIMARY" ]]; then
		# Reconfigure (make the install node primary on replication set re-install or update) to ensure customers reinstall the secondary consoles and that
		# all active consoles have the same product version
		print_info "Reconfiguring HA replication set"
		${docker} exec -ti ${console_container_name} mongo --ssl --sslAllowInvalidHostnames --sslCAFile /var/lib/twistlock/certificates/ca.pem --sslPEMKeyFile /var/lib/twistlock/certificates/client.pem --sslPEMKeyPassword $(cat /var/lib/twistlock/certificates/service-parameter) -port ${HIGH_AVAILABILITY_PORT} \
			--eval 'config = rs.conf(); config.members = [ rs.conf().members.find(function(m) { return m._id == rs.status().members.find(function(m) { return m.self; })._id }) ]; rs.reconfig(config, {force: true})' >> $install_log 2>&1
	fi

	remove_container ${console_container_name}

	if [[ ${HIGH_AVAILABILITY_ENABLED} == "true" && "${HIGH_AVAILABILITY_STATE}" != "PRIMARY" ]]; then
		print_debug "Removing data from secondary node"
		rm -rf ${DATA_FOLDER}/db  >> $install_log 2>&1
	fi

	additional_env=""
	additional_ports=""
	additional_parameters=""

	print_debug "Current version $docker_version"
	if [[ $READ_ONLY_FS != "false" ]]; then
		# https://blog.docker.com/2015/02/docker-1-5-ipv6-support-read-only-containers-stats-named-dockerfiles-and-more/
		print_debug "Setting Console container to readonly"
		additional_parameters+=" --read-only=true "
	else
		print_warning "Console container file-system is not read-only"
	fi

	# Mount external data to /var/lib/twistlock/
	db_folder="${DATA_FOLDER}/db"
	if [[ $drop_db == "true" ]]; then
		print_debug "Dropping Twistlock database"
		rm -rf $db_folder
		exit_on_failure $? "Failed to delete database folder $db_folder"
	fi

	print_debug "Installing database under $db_folder"
	mkdir -p $db_folder
	exit_on_failure $? "Failed to create database folder $db_folder"
	print_info "Installing Twistlock Console ($CONSOLE_CN)"

	local_ips=$(get_local_ip)
	san=$local_ips
	print_debug "SAN: $san"
	print_debug "Console CN: $CONSOLE_CN"

	if [[ $DATA_RECOVERY_ENABLED == "true" ]]; then
		print_debug "Data recovery is enabled"
		set_data_recovery_folder_permissions
		# Mount data recovery volume and database folder
		additional_parameters+=" -v ${DATA_RECOVERY_VOLUME}:/var/lib/twistlock-backup "

	fi

	if [[ -n ${selinux_enabled} ]]; then
		additional_parameters+=" --security-opt label${security_opt_operator}${SELINUX_LABEL} "
	fi

	if [[ ${HIGH_AVAILABILITY_ENABLED} == "true" ]]; then
		additional_ports+=" -p ${HIGH_AVAILABILITY_PORT}:${HIGH_AVAILABILITY_PORT} "
		additional_env+=" -e HIGH_AVAILABILITY_PORT=${HIGH_AVAILABILITY_PORT} -e HIGH_AVAILABILITY_STATE=${HIGH_AVAILABILITY_STATE} "
		# hostname is required to support replication set functionality (the initial connection must be set to a valid hostname or IP)
		additional_parameters+=" --hostname=${HOSTNAME} "
	fi

	# Set pids limit to 1000 so attackers won't be able to launch a fork bomb with a single command inside the container
	if [[ $(version_higher_equal $docker_version 1.12) == 1 ]]; then
		# Mongo starts a thread per connection, enable multiple simulations connections to support high load
		additional_parameters+=" --pids-limit 1000 "
	fi

	docker_action=""
	if [[ ${SYSTEMD_ENABLED} == "true" ]]; then
		print_debug "Systemd enabled. creating container"
		docker_action="create"
	else
		docker_action="run"
		additional_parameters+=" --restart=always -d "
	fi

	if [[ ! -z ${MANAGEMENT_PORT_HTTP} ]]; then
		print_debug "http is enabled $MANAGEMENT_PORT_HTTP"
		additional_ports+=" -p ${MANAGEMENT_PORT_HTTP}:${MANAGEMENT_PORT_HTTP} "
	else
		print_debug "http is disabled"
	fi

	# Create folders that are shared between the defender and console (required to ensure defender does not modify
	# the folder permissions when it starts)
	mkdir -p ${DATA_FOLDER}/certificates && mkdir -p ${DATA_FOLDER}/log
	chown -R ${twistlock_user} ${DATA_FOLDER} && chmod 0700 -R ${DATA_FOLDER}
	migrate_password_file


	if [[ -e ${syslog_mount} ]]; then
		additional_parameters+=" -v ${syslog_mount}:${syslog_mount} "
	fi

	# All console containers resides on the same network
	$docker ${docker_action} \
	  $(get_userns_flag) \
	  --name ${console_container_name} \
	  --user ${twistlock_user} \
	  -p $MANAGEMENT_PORT_HTTPS:${MANAGEMENT_PORT_HTTPS} \
	  -p $COMMUNICATION_PORT:${COMMUNICATION_PORT} \
	   ${additional_ports} \
	  -e CONSOLE_CN=${CONSOLE_CN} \
	  -e CONSOLE_SAN="${san}" \
	  -e LOG_PROD=true \
	  -e DATA_RECOVERY_ENABLED=${DATA_RECOVERY_ENABLED} \
	  -e COMMUNICATION_PORT=${COMMUNICATION_PORT} \
	  -e MANAGEMENT_PORT_HTTPS=${MANAGEMENT_PORT_HTTPS} \
	  -e MANAGEMENT_PORT_HTTP=${MANAGEMENT_PORT_HTTP} \
	  -e HIGH_AVAILABILITY_ENABLED=${HIGH_AVAILABILITY_ENABLED} \
	  -e SCAP_ENABLED=${SCAP_ENABLED} \
	  -v ${DATA_FOLDER}:/var/lib/twistlock \
	  $additional_env \
	  $additional_parameters \
	  --cpu-shares 900 \
	   -m 4096m \
	  $console_image >> $install_log 2>&1

	exit_on_failure "$?" "Failed to run Twistlock Console"

	local retries=1
	if [[ ${SYSTEMD_ENABLED} == "true" ]]; then
		print_debug "Starting Twistlock Console using systemd"
		install_systemd_service ${console_service}
		retries=3
	fi
	validate_container_up "${console_container_name}" ${retries}
	print_info "Twistlock Console installed successfully"
}

# Copy twistlock scripts to data folder
copy_scripts () {
	local scripts_folder="${DATA_FOLDER}/scripts"
	print_debug "Copying Twistlock configuration and scripts to ${scripts_folder}"
	mkdir -p ${scripts_folder}
	if [ -e "${scripts_folder}/twistlock.cfg" ]; then
		print_info "Previous Twistlock configuration detected, preserving configuration under: ${scripts_folder}/twistlock.cfg.old"
		mv "${scripts_folder}/twistlock.cfg" "${scripts_folder}/twistlock.cfg.old"
	fi
	cp ${working_folder}/twistlock.* ${scripts_folder}
	# Make twistlock script executable
	chmod a+x ${scripts_folder}/twistlock.sh
	# Ensure that cfg file is still readable by console (if defender is installed on the same machine as console, and console run as user)
	chown ${twistlock_user} ${scripts_folder}/twistlock.cfg && chmod u+r ${scripts_folder}/twistlock.cfg
}


# Get all local ips of the current host
get_local_ip() {
	ip=""
	# In some distributions, grep is not compiled with -P support.
	# grep: support for the -P option is not compiled into this --disable-perl-regexp binary
	# For those cases, use pcregrep
	if command_exists pcregrep; then
		ip=$(ip -f inet addr show | pcregrep -o 'inet \K[\d.]+')
	else
		ip=$(ip -f inet addr show | grep -Po 'inet \K[\d.]+')
	fi
	ip_result="IP:"
	ip_result+=$(echo $ip | sed 's/ /,IP:/g')
	echo ${ip_result}
}

# Uninstall all Twistlock containers
uninstall_twistlock() {
	print_info "Uninstalling Twistlock"
	if [[ ${SYSTEMD_ENABLED} == "true" ]]; then
		uninstall_systemd_service ${defender_service}
		uninstall_systemd_service ${console_service}
	fi
	remove_container "twistlock_defender" "false"
	remove_container "twistlock_console" "false"

	# Find all images that contains the term twistlock/private
	# Take unique values from IMAGE ID column (column 3 in `docker images`)
	twistlock_images=$($docker images | grep twistlock/private | awk '{print $3}' | sort | uniq)

	for image in $twistlock_images
	do
		print_info "Removing image $image"
		$docker rmi -f $image
	done

	print_info "Removing Twistlock data folder: ${DATA_FOLDER}"
	rm -rf ${DATA_FOLDER}
}


# Check if the OS enables conntrack
check_conntrack_support() {
	print_debug "Checking if the OS enables conntrack"
	# Check if os is CentOS 6.* or RHEL 6.*
	release_version=`cat /etc/*-release | grep ' 6.'`

	if [[ ${release_version,,} == *"centos"* || ${release_version,,} == *"red hat"* ]]; then
		print_warning "WARNING: on CentOS/RHEL 6.X please verify nf_conntrack_netlink module is loaded. Please find more information under the following link: http://support.twistlock.com/customer/portal/articles/2317557-conntrack-configuration-on-rhel-6-x";
	fi
}

get_systemd_unit_path() {
	if [ -d "/lib/systemd/" ]; then
		# Ubuntu, CentOS, Red Hat and Amazon Linux use this path
		echo "/lib/systemd/system"
	elif [ -d "/usr/lib/systemd/" ]; then
		# SUSE Linux uses this path
		echo "/usr/lib/systemd/system"
	fi

}

install_systemd_service() {
	local service=$1
	local unitpath=$(get_systemd_unit_path)
	print_info "Installing systemd service ${service}"
	cp "${DATA_FOLDER}/scripts/${service}" "$unitpath" >> ${install_log} 2>&1
	exit_on_failure "$?" "Failed to copy systemd service unit file"
	chmod 0644 "$unitpath/${service}" >> ${install_log} 2>&1
	exit_on_failure "$?" "Failed to set file permissions for ${service}"
	systemctl daemon-reload >> ${install_log} 2>&1
	if [[ $? != 0 ]]; then
		# systemctl daemon-reload connectivity might fail for sporadic reasons
		# see here: https://github.com/systemd/systemd/issues/3353
		sleep 1
		systemctl daemon-reload >> ${install_log} 2>&1
		exit_on_failure "$?" "Failed to reload systemctl daemon"
	fi
	systemctl enable ${service} >> ${install_log} 2>&1
	exit_on_failure "$?" "Failed to enable ${service}"
	systemctl restart ${service} >> ${install_log} 2>&1
	exit_on_failure "$?" "Failed to start ${service}"
	systemctl is-active ${service} >> ${install_log} 2>&1
	exit_on_failure "$?" "Service ${service} is not running. Deployment failed"
}

uninstall_systemd_service() {
	local service=$1
	local unitpath=$(get_systemd_unit_path)

	if [[ ! -e "$unitpath/${service}" ]]; then
		print_info "Service ${service} does not exist"
		return
	fi

	print_info "Uninstalling systemd service ${service}"
	systemctl stop ${service} >> $install_log 2>&1
	exit_on_failure "$?" "Failed to stop ${service}"
	systemctl disable ${service} >> $install_log 2>&1
	exit_on_failure "$?" "Failed to disable ${service}"
	rm "$unitpath/${service}" >> $install_log 2>&1
	exit_on_failure "$?" "Failed to remove systemd service unit file"
	systemctl daemon-reload >> $install_log 2>&1
	exit_on_failure "$?" "Failed to reload systemctl daemon"
}

install_defender() {
	if command_exists systemctl; then
		systemctl is-enabled ${server_defender_service} >/dev/null 2>&1
		if [[ $? == 0 ]]; then
			exit_now "Defender for Linux Server is already installed. Please decommission in order to continue"
		fi
	fi

	copy_local_certificates

	set_data_folder_permissions

	console_address=$1

	# Enable registry scans
	registry_enabled=$2

	# Legacy - Perform software upgrade (support older defenders, should be removed in 1.5 #1728)
	upgrade=$3

	print_info "Installing Defender"
	print_debug "Defender CN        : $DEFENDER_CN"
	print_debug "Console  addresss  : $console_address"
	print_debug "Registry enabled   : $registry_enabled"
	print_debug "Upgrade            : $upgrade"

	# Remove previous installations
	if [[ $SKIP_DELETE == "true" || "$upgrade" == "true" ]]; then
		# Avoid deleting container images to enable running two defender instances simultaneously
		print_warning "Skipping deletion of old containers"
	else
		remove_container "twistlock_defender"
	fi

	# Additional environment variables for conditional parameters
	additional_env=""
	if [ -z "$console_address" ]; then
		console_address="$CONSOLE_CN"
		print_debug "Console address not provided, assuming onebox mode (IP: $console_address)"
	fi

	WS_ADDRESS=wss://$console_address:$COMMUNICATION_PORT

	# Additional mount points required for performing host CIS scan
	# Explicitly add folder only if exists to avoid failures due to read only host filesystem
	additional_mounts=""

	additional_mounts+=" -v /etc/passwd:/etc/passwd:ro "

	additional_mounts+=" -v $docker_socket_folder:$docker_socket_folder "
	# Ensure /run is mounted for iptabales xtables.lock file
	if [ "$docker_socket_folder" != "/run" ]; then
		additional_mounts+=" -v /run:/run "
	fi

	# Ensure systemd socket is mounted to the defender
	# Skip mount if docker is mounted from its default place (/var/run)
	if [[ -e "/var/run/systemd/private" ]] && [[ "${docker_socket_folder}" != "/var/run" ]] && [[ "${docker_socket_folder}" != "/run" ]]; then
		additional_mounts+=" -v /var/run/systemd/private:/var/run/systemd/private "
	fi

	# Add audit daemon log dir to monitor seccomp audits
	# Skip mount if docker seccomp security option is invalid or if audit log file doesn't exists
	if [[ -e "/var/log/audit/audit.log" ]] && [[ $(${docker} info | grep "seccomp") ]]; then
		additional_mounts+=" -v /var/log/audit:/var/log/audit "
	fi

	additional_env+=" -e DOCKER_CLIENT_ADDRESS=$DOCKER_SOCKET "

	additional_parameters=""
	if [[ -n ${selinux_enabled} ]]; then
		additional_parameters+=" --security-opt label${security_opt_operator}${SELINUX_LABEL} "
	fi

	print_debug "admin address $console_address"

	check_conntrack_support

	# Mount docker internal network namespace folder
	if [ -e "/var/run/docker/netns" ]; then
		additional_mounts+=" -v /var/run/docker/netns:/var/run/docker/netns:ro "
	fi

	if [[ $(version_higher_equal $docker_version 1.10) == 1 ]]; then
		# Set seccomp unconfined profile for docker version higher or equals than 1.10
		# Seccomp default profile: https://docs.docker.com/engine/security/seccomp/
		# Docker default profile blocks setns, which is required for file system monitoring
		additional_parameters+=" --security-opt seccomp${security_opt_operator}unconfined "
	fi

	# Disabling app-armor (if enabled) is required for accessing /proc interfaces
	# https://github.com/docker/docker/issues/7276#issuecomment-68812214
	# Keep legacy condition in case apparmor does not appear in docker-info security options
	if [[ "${host_os_distribution}" == "Ubuntu" &&  $(apparmor_status 2>/dev/null | grep loaded)  ]] || [[ $(${docker} info 2>/dev/null | grep apparmor)  ]]; then
		additional_parameters+=" --security-opt apparmor${security_opt_operator}unconfined "
	fi

	# Set pids limit to 1000 so attackers won't be able to launch a fork bomb with a single command inside the container
	if [[ $(version_higher_equal ${docker_version} 1.12) == 1 ]]; then
		additional_parameters+=" --pids-limit 1000 "
	fi

	container_name="twistlock_defender${DOCKER_TWISTLOCK_TAG}"

	docker_action=""
	if [[ "${SYSTEMD_ENABLED}" == "true" ]]; then
		print_debug "Systemd enabled. Creating container"
		docker_action="create"
		echo "DEFENDER=${container_name}" > ${DATA_FOLDER}/scripts/systemd.conf
	else
		docker_action="run"
		additional_parameters+=" --restart=always -d "
	fi

	if [[ $READ_ONLY_FS != "false" ]]; then
		# https://blog.docker.com/2015/02/docker-1-5-ipv6-support-read-only-containers-stats-named-dockerfiles-and-more/
		print_debug "Setting Defender container to readonly"
		additional_parameters+=" --read-only=true "
	else
		print_warning "Defender container file-system is not read-only"
	fi

	migrate_password_file
	# --pid host
	# --cap-add audit_control
	# --pid=host is needed so defender will be able to read the host's /proc directory
	# NET_ADMIN - Required for process monitoring
	# SYS_ADMIN - Required for filesystem monitoring
	# SYS_PTRACE - Required for local audit monitoring and for reading some of /proc files
	# (see https://github.com/docker/docker/issues/6607 and https://github.com/docker/docker/issues/7276)
	# AUDIT_CONTROL - $docker ${docker_required for system calls monitoring
	# Remark: Defender is the only container that has a name combined from container name and TAG
	$docker ${docker_action} \
		$(get_userns_flag) \
		--name=${container_name} \
		--net=host \
		--pid=host \
		--cap-add=NET_ADMIN \
		--cap-add=SYS_ADMIN \
		--cap-add=SYS_PTRACE \
		--cap-add AUDIT_CONTROL \
		-e WS_ADDRESS=$WS_ADDRESS \
		-e HOSTNAME=$DEFENDER_CN \
		-e LOG_PROD=true \
		-e DEFENDER_LISTENER_TYPE=${DEFENDER_LISTENER_TYPE} \
		-e REGISTRY_SCAN_ENABLED=$registry_enabled \
		-e DATA_FOLDER=${DATA_FOLDER} \
		-e HTTP_PROXY=$HTTP_PROXY \
		-e NO_PROXY=$NO_PROXY \
		-e SYSTEMD_ENABLED=$SYSTEMD_ENABLED \
		 $additional_env \
		 $additional_mounts \
		-v ${DATA_FOLDER}:/var/lib/twistlock \
		-v ${syslog_mount}:${syslog_mount} \
		$additional_parameters \
		--cpu-shares 900 \
		-m 512m \
		$defender_image >> $install_log 2>&1

	exit_on_failure "$?" "Failed to run Twistlock Defender"

	local retries=1
	if [[ ${SYSTEMD_ENABLED} == "true" ]]; then
		print_debug "Starting Twistlock Defender using systemd"
		install_systemd_service ${defender_service}
		retries=3
	fi

	validate_container_up "twistlock_defender$DOCKER_TWISTLOCK_TAG" ${retries}
	print_info "Twistlock Defender installed successfully"
}

install_server_defender() {
	local install_folder=$1
	local console_address=$2

	if [ -z "${install_folder}" ]; then
		exit_now "No install folder was provided"
	fi

	if [ -z "${console_address}" ]; then
		exit_now "No console address was provided"
	fi

	print_info "Installing Linux Server Defender to ${install_folder}"

	print_debug "Install folder: ${install_folder}"
	print_debug "Console addresss: ${console_address}"
	print_debug "WS port: ${COMMUNICATION_PORT}"

	set_server_defender_install_folder_permissions "${install_folder}"
	mkdir -p "${DATA_FOLDER}/data"
	mkdir -p "${DATA_FOLDER}/log"
	set_data_folder_permissions
	copy_local_certificates

	# Unpack archive
	tar zxf "${defender_bundle_linux_server}" -C "${install_folder}"
	exit_on_failure $? "Failed extracting ${defender_bundle_linux_server}"

	# Move and prepare the service unit file
	mv "${install_folder}/${server_defender_service}" ${DATA_FOLDER}/scripts/ >> $install_log 2>&1
	exit_on_failure $? "Failed to move Twistlock Defender service unit file"

	# Create systemd environment file
	cat <<-EOF > ${DATA_FOLDER}/scripts/systemd.conf
	WS_ADDRESS=wss://${console_address}:${COMMUNICATION_PORT}
	HOSTNAME=${DEFENDER_CN}
	LOG_PROD=true
	DATA_FOLDER=${DATA_FOLDER}
	INSTALL_FOLDER=${install_folder}
	HTTP_PROXY=${HTTP_PROXY}
	NO_PROXY=${NO_PROXY}
	EOF

	# Replace placeholders in service file (these cannot use the values from the env file)
	pushd "${DATA_FOLDER}/scripts" >/dev/null
	sed -e "s#__DATA_FOLDER__#${DATA_FOLDER}#g" \
		-e "s#__INSTALL_FOLDER__#${install_folder}#g" \
		-i ${server_defender_service}

	mv "${install_folder}/version.txt" "${DATA_FOLDER}/data"
	mv "${install_folder}/GeoLite2-Country.mmdb" "${DATA_FOLDER}/data"

	print_debug "Starting Twistlock Linux Server Defender using systemd"
	install_systemd_service ${server_defender_service}
	popd >/dev/null

	print_info "Twistlock Linux Server Defender installed successfully"
}

uninstall_server_defender() {
	local install_folder=$1
	local data_folder=$2

	if [ -z "${install_folder}" ]; then
		exit_now "No install folder was provided"
	fi
	if [ -z "${data_folder}" ]; then
		exit_now "No data folder was provided"
	fi

	print_info "Uninstalling Twistlock Linux Server Defender"
	uninstall_systemd_service ${server_defender_service}

	print_info "Removing Twistlock install folder: ${install_folder}"
	rm -rf ${install_folder}

	print_info "Removing Twistlock data folder: ${data_folder}"
	rm -rf ${data_folder}

	print_info "Defender for Linux Server uninstalled successfully"
}

version_higher_equal() {
	ver=`echo -ne "$1\n$2" |sort -Vr |head -n1`
	if [ "$2" == "$1" ]; then
		echo 1
	elif [ "$1" == "$ver" ]; then
		echo 1
	else
		echo -1
	fi
}

# Copy local certificate files (if exists)
copy_local_certificates() {
	cert_dir=${DATA_FOLDER}/certificates
	print_debug "Certificate dir: ${cert_dir}"
	mkdir -m 600 -p "${cert_dir}"

	local console_exists=false
	if [ -n "${docker}" ]; then
		console_exists=$(${docker} ps -aq -f name=twistlock_console)
	fi

	for cert in ./*.pem; do
		print_debug "Copying local certificate $cert"
		# If console is running on the same machine, use twistlock user permissions
		if [ ${console_exists} ]; then
			chown ${twistlock_user} ${cert} >> $install_log 2>&1
			chmod u+rw ${cert} >> $install_log 2>&1
		fi
		mv "${cert}" "${cert_dir}" >> $install_log 2>&1
	done

	if [ -f "service-parameter" ]; then
		# If console is running on the same machine, use twistlock user permissions
		if [ ${console_exists} ]; then
			chown ${twistlock_user} service-parameter && chmod u+rw service-parameter
		fi
		mv service-parameter ${cert_dir}/service-parameter
	fi
}
# Sets twistlock data folder permissions
set_data_folder_permissions() {
	print_debug "Setting root only permissions to data folder: ${DATA_FOLDER}"
	mkdir -p "${DATA_FOLDER}"
	chmod o-rwx -R "${DATA_FOLDER}"
}

# Sets server defender install folder permissions
set_server_defender_install_folder_permissions() {
	local install_folder=$1

	print_debug "Setting root only permissions to install folder: ${install_folder}"
	mkdir -p ${install_folder}
	chown -R ${twistlock_user} ${install_folder}
	chmod o-rwx -R ${install_folder}
}

# Sets twistlock data recovery folder permissions
set_data_recovery_folder_permissions() {
	print_debug "Setting user permissions to data recovery folder: ${DATA_RECOVERY_VOLUME}"
	mkdir -p ${DATA_RECOVERY_VOLUME}
	chown -R ${twistlock_user} ${DATA_RECOVERY_VOLUME} && chmod u+rwx -R ${DATA_RECOVERY_VOLUME}
}

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

# gets the default userns flag (userns=host)
get_userns_flag() {
	if [[ $(is_userns_enabled) == "true" ]]; then
		echo " --userns=host "
	fi
	echo ""
}

# checks whether the user namespace feature is enabled
is_userns_enabled() {
	if [[ $(ps aux | grep -q "\-\-userns-remap") ]] || [[ $(${docker} info | grep  "userns") ]]; then
			echo "true";
	else
		echo "false"
	fi
}

# checks whether the user namespace feature is enabled and prints a debug messages if needed
check_userns_enabled() {
	if [[ $(is_userns_enabled) == "true" && $(version_higher_equal $docker_version 1.11) == -1 ]]; then
		print_error "Running Twistlock with userns support requires docker version > 1.10";
	fi
}

# Load images from tarcd
load_images() {
	component=$1
	print_info "Loading $component images"
	# Add selinux security options for generated containers
	if [[ -n ${selinux_enabled} ]]; then
		additional_run_parameters+=" --security-opt label${security_opt_operator}${SELINUX_LABEL} "
	fi

	if [[ $component == "" || $component == "${onebox_component}" || $component == "${console_component}" ]]; then

		console_local_images=${working_folder}"/${console_bundle}"
		# Skip if image is loaded
		if [[ "$($docker images | awk '{print $1":"$2}' | grep $console_image 2> /dev/null)" == "" ]]; then
			if [[ ! -e ${console_local_images} ]]; then
				exit_now "Failed to find $console_image offline image (${console_bundle})"
			fi

			$docker load < ${console_local_images}
		else
			print_info "Image $console_image already loaded"
		fi

		print_debug "Pulling Twistlock data from data container"
		remove_container "twistlock_data"
		# Copy required installation files to local folder
		$docker create --name twistlock_data -ti ${additional_run_parameters} --entrypoint=/bin/sh "twistlock/private:console${DOCKER_TWISTLOCK_TAG}" >> $install_log 2>&1
		exit_on_failure $? "Failed to start Twistlock data container"
		$docker cp twistlock_data:/images/${defender_bundle_linux_docker} ${working_folder}/ >> $install_log 2>&1
		exit_on_failure $? "Failed to copy Twistlock Defender image"
		$docker cp twistlock_data:/data/twistlock-console.service ${DATA_FOLDER}/scripts/ >> $install_log 2>&1
		exit_on_failure $? "Failed to copy Twistlock Console service unit file"

		if [[ ${HIGH_AVAILABILITY_ENABLED} == "true" ]]; then
			print_debug "Copying Twistlock Console image to data folder"
			image_folder="${DATA_FOLDER}/images"
			mkdir -p ${image_folder}
			cp ${console_local_images} ${image_folder}/${console_bundle}
			exit_on_failure "$?" "Failed to copy Twistlock Console image"
		fi
		if [ "$SCAP_ENABLED" == "true" ]; then
			print_debug "Copying local openSCAP util from console"
			$docker cp twistlock_data:/data/openscap.tar.gz ${working_folder}/openscap.tar.gz
			exit_on_failure "$?" "Failed to copy Twistlock openSCAP utility"
		fi

		remove_container "twistlock_data"
	fi

	if [[ $component == "" || $component == "${onebox_component}" || $component == "${defender_component_docker}" ]]; then
		# Skip if image is loaded
		if [[ "$($docker images | awk '{print $1":"$2}' | grep $defender_image 2> /dev/null)" == "" ]]; then

			defender_local_images=${working_folder}"/${defender_bundle_linux_docker}"
			if [[ ! -e ${defender_local_images} ]]; then
				exit_now "Failed to find $defender_image offline image (${defender_bundle_linux_docker})"
			fi

			$docker load < ${defender_local_images}
		else
			print_info "Image $defender_image already loaded"
		fi
		print_debug "Copying Twistlock Defender data to utils folder"
		mkdir -p ${DATA_FOLDER}/utils
		$docker create --name twistlock_data -ti ${additional_run_parameters} --entrypoint=/bin/sh "twistlock/private:defender${DOCKER_TWISTLOCK_TAG}" >> $install_log 2>&1
		$docker cp twistlock_data:/data/twistlock-defender.service ${DATA_FOLDER}/scripts/ >> $install_log 2>&1
		exit_on_failure $? "Failed to copy Twistlock Defender service unit file"
		remove_container "twistlock_data"

		if [ "$SCAP_ENABLED" == "true" ]; then
			mkdir -p ${DATA_FOLDER}/utils/openscap
			exit_on_failure $? "Failed to create folder ${DATA_FOLDER}/utils/openscap"
			print_debug "Extracting openscap.tar.gz"
			tar -zxf ${working_folder}/openscap.tar.gz -C ${DATA_FOLDER}/utils/openscap/
			exit_on_failure $? "Failed extracting openscap.tar.gz"

			# Apply execute permissions to openscap scripts and binaries
			chmod 0600 -R ${DATA_FOLDER}/utils/openscap/
			chmod 0700 ${DATA_FOLDER}/utils/openscap/oscap.sh ${DATA_FOLDER}/utils/openscap/usr/libexec/openscap/* ${DATA_FOLDER}/utils/openscap/usr/bin/*
		fi
	fi
}

# Checks the selinux mode of the docker daemon (Enforcing or not), and copies the policy
# If selinux_enabled is already provided as a parameter, then it is assumed that it's correct and uses it.
set_selinux_configurations() {
	# Check if selinux is enabled by inspecting docker daemon arguments and docker info
	if [[ $(ps aux | grep docker | grep "selinux-enabled") ]] || [[ $(${docker} info 2> /dev/null | grep "selinux") ]]; then
		print_debug "Docker engine is running with SELinux enabled"
		selinux_enabled="true"
	else
		print_debug "Docker engine is running with SELinux disabled"
		return;
	fi
}

upstart_docker_config="/etc/default/docker"
# Default docker configuration in RHEL
docker_sysconfig="/etc/sysconfig/docker"

exit_on_failure() {
	rc=$1
	message=$2
	if [[ $rc != 0 ]]; then
		# Also print the last line
		logs=$(tail --lines=2 $install_log)
		print_error "$logs"
		print_error "$message"
		exit $rc;
	fi
}

# stop the program and exit with the given message
exit_now() {
	local message=$1
	print_error "${message}"
	exit 1
}

convert_kb_to_gb() {
let "kb_in_gb = 1024*1024"

# rounding to the closest integer
echo "$((($1 + ($kb_in_gb/2))/($kb_in_gb)))"
}

check_sys_requirements() {
	target=$1
	print_info "Performing system checks for $target mode.."
	int_re='^[0-9]+$'
	print_debug "Checking hardware requirements.."
	case $target in
		"${onebox_component}")
		# Minimal system requirements to run onebox, derived from registry scan requirements:
			let "min_storage_size_in_1kb_blocks = 18*1024*1024"
			let "min_ram_size_in_1kb_blocks     = 1024*1024 + 256*1024"
			let "min_cpu_count                  = 2"
			let "cpu_count = 1 +$(cat /proc/cpuinfo | grep "processor"| grep ":" | tail -1 | awk '{print $3}')"

			if [ "$min_cpu_count" -gt "$cpu_count" ]; then
				print_warning "The $target mode requires $min_cpu_count CPUs; The host has only $cpu_count"
			fi
		;;
		"${console_component}" )
		# Minimal system requirements to run console:
			let "min_storage_size_in_1kb_blocks = 10*1024*1024"
			let "min_ram_size_in_1kb_blocks     = 1024*1024"
		;;
		"${defender_component_docker}"|"${defender_component_linux_server}" )
		# Minimal system requirements to run defender:
			let "min_storage_size_in_1kb_blocks = 8*1024*1024"
			let "min_ram_size_in_1kb_blocks     = 256*1024"
		;;
	esac

	# Get the available free disk space of the installation folder's volume
	storage_capacity=$(df ${DATA_FOLDER} | tail -1 | awk '{print $4}')

	# Some older df version add a wrong line break, so in such cases we skip the test
	if ! [[ $storage_capacity =~ $int_re ]]; then
		print_warning "'df' returned an invalid output"
		print_debug "$(df ${DATA_FOLDER} | tail -1 | awk '{print "df output:", $0; print "capacity:", $4}')"
	fi

	if [[ $storage_capacity =~ $int_re ]] && [ "$storage_capacity" -lt "$min_storage_size_in_1kb_blocks" ]; then
		required_storage_gb=$(convert_kb_to_gb $min_storage_size_in_1kb_blocks)
		actual_storage_gb=$(convert_kb_to_gb $storage_capacity)
		deficit_gb=$(($required_storage_gb - $actual_storage_gb))

		if [ "$deficit_gb" -gt "0" ]; then
			print_warning "Low host storage space; Required: $required_storage_gb[GB], actual: $actual_storage_gb[GB]"
			let "low_storage_bound_console_gb = 20"
			if [[ "$target" != "${defender_component_docker}" ]] && [[ "$target" != "${defender_component_linux_server}" ]] && [[ "$hard_block" != "false" ]] && [[ "$actual_storage_gb" -le "$low_storage_bound_console_gb" ]]; then
				exit_now "Blocked Twistlock $target installation; Low storage (less than $low_storage_bound_console_gb[GB]); To bypass rerun with -y"
			fi
		fi
	fi

	ram_capacity=$(cat /proc/meminfo | grep "MemTotal:" | awk '{print $2}')
	if [ "$ram_capacity" -lt "$min_ram_size_in_1kb_blocks" ]; then
		required_ram_gb=$(convert_kb_to_gb $min_ram_size_in_1kb_blocks)
		actual_ram_gb=$(convert_kb_to_gb $ram_capacity)
		deficit_gb=$(($required_ram_gb - $actual_ram_gb))

		if [ "$deficit_gb" -gt "0" ]; then
			print_warning "Low host RAM capacity; Required: $required_ram_gb[GB], actual: $actual_ram_gb[GB]"
		fi
	fi

	if [ "${target}" == "${defender_component_linux_server}" ]; then
		return
	fi

	print_debug "Checking docker version"
	let "min_docker_ver_major=1"
	let "min_docker_ver_minor=6"

	docker_major=$(echo ${docker_version} | sed -e 's/\./\n/g' | sed -n 1p)
	docker_minor=$(echo ${docker_version} | sed -e 's/\./\n/g' | sed -n 2p)

	if [ "$min_docker_ver_major" -gt "$docker_major" ]; then
		print_warning "Twistlock supports Docker version $min_docker_ver_major.$min_docker_ver_minor and higher; The current Docker version is ${docker_version}"
	elif [ "$min_docker_ver_major" == "$docker_major" ] && [ "$min_docker_ver_minor" -gt "$docker_minor" ]; then
		print_warning "Twistlock supports Docker version $min_docker_ver_major.$min_docker_ver_minor and higher; The current Docker version is ${docker_version}"
	fi
}

# migrates the legacy password file (REMARK: remove in release 2.1)
migrate_password_file() {
	mv ${DATA_FOLDER}/certificates/secret_key ${DATA_FOLDER}/certificates/secret_key/service-parameter  >> /dev/null 2>&1
}

merge_configuration_files() {
	local old_configuration="${DATA_FOLDER}/scripts/twistlock.cfg"
	if [ ! -e "${old_configuration}" ]; then
		exit_now "Failed to find old configuration file ${old_configuration}"
	fi

	print_info "Using previously user-defined settings in ${old_configuration}"
	while IFS='' read -r line || [[ -n "$line" ]]; do
		if [[ ${line} == "" || "${line:0:1}" == "#" ]]; then
			continue
		fi
		tokens=$(echo $line | tr "=" "\n")
		var=$(echo $tokens | awk '{print $1}')

		# Skip Twistlock version
		if [ "${var}" == "DOCKER_TWISTLOCK_TAG" ]; then
			continue
		fi

		sed -i "s~^${var}=.*$~${line}~g" ${config_file}
	done < "${DATA_FOLDER}/scripts/twistlock.cfg"
	source ${config_file}
}


echo "$(tput_silent setaf 3)
  _____          _     _   _            _
 |_   _|_      _(_)___| |_| | ___   ___| | __
   | | \ \ /\ / / / __| __| |/ _ \ / __| |/ /
   | |  \ V  V /| \__ \ |_| | (_) | (__|   <
   |_|   \_/\_/ |_|___/\__|_|\___/ \___|_|\_\\

$(tput_silent sgr0)"

show_help() {
	echo "
Usage: sudo twistlock.sh [OPTIONS] [COMPONENT]

Twistlock.sh installs and configures Twistlock in your environment.

OPTIONS:
  -f                            Drops existing database
  -h                            Shows help
  -j                            Merge previous Twistlock configuration file (default to override)
  -s                            Agrees to the EULA
  -u                            Uninstalls Twistlock (removes all Twistlock containers and images)
  -y                            Bypasses installation blocks even when system requirements are not met
  -z                            Outputs debug logs


COMPONENT:
  onebox                        Installs all Twistlock components (Console and Defender) on a single host

"
}

args="$@"
# Internals:
# -a    [console_address]       Console server address for communication with Twistlock defender
# -n                            Install all containers on separate networks (default false)
# -p                            Generate server certs files locally
# -t                            Override twistlock.cfg image tag
# -x                            Path to docker client
# -o                            Docker client options (e.g., -H). Must be provided after client option
OPTIND=1
unset name
optspec="h?a:ksdb:fgjo:ruzw:t:x:i:e:y-:"
while getopts "${optspec}" opt; do
	case "${opt}" in
	    -)
	        case "${OPTARG}" in
	            install-folder)
	                # Use indirect parameter expansion to get the value of a positional parameter, e.g.,
	                # if OPTIND=3 then ${!OPTIND} evaluates to the value of $3
	                install_folder="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
	                ;;
	            install-data-folder)
	                install_data_folder="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
	                ;;
	            ws-port)
	                ws_port="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
	                ;;
	            *)
	                if [ "${OPTERR}" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
	                    echo "Unknown option --${OPTARG}" >&2
	                fi
	                ;;
	        esac
	        ;;
		h)  show_help
		exit
		;;
		e)  custom=$OPTARG
		;;
		a)  console_address=$OPTARG
		;;
		s)  skip_eula=true
		;;
		g)  upgrade="true"
		;;
		f)  drop="true"
		;;
		r)  registry_enabled="true"
		;;
		t)  tag=$OPTARG
		;;
		i)  host_os_distribution=$OPTARG
		;;
		u)  uninstall="true"
		;;
		z)  debug_log_level="true"
		;;
		x)  docker=$OPTARG
		;;
		o)  docker+="${OPTARG//\"}"
		# Additional client options (remove " to enable specifying multiple parameters)
		;;
		y)  hard_block="false"
		# When hard_block is set to 'false' we won't stop installation upon low storage
		;;
		j) merge_previous_cfg="true"
	esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

# Merge with previous config file if exists
if [ "$merge_previous_cfg" == "true" ]; then
	merge_configuration_files
fi

# Run console as root or as service user
# Remark: Use configuration parameters only after previous configuration merge
if [[ ${RUN_CONSOLE_AS_ROOT} == "true" ]]; then
	twistlock_user=root
else
	twistlock_user=2674
fi

# Override config values if given as arguments
if [[ -n "${install_data_folder}" ]]; then
	DATA_FOLDER=${install_data_folder}
fi

if [[ -n "${ws_port}" ]]; then
	COMMUNICATION_PORT=${ws_port}
fi

if [ -z $DEFENDER_CN ]; then
	DEFENDER_CN=$(hostname --fqdn 2>/dev/null)
	if [[ $? == 1 ]]; then
		DEFENDER_CN=$(hostname)
	fi
fi

component=$BASH_ARGV
print_debug "$component - $args (config: $config_file)"
print_debug "Using Docker command: $docker"


# Check if last parameter is argument (-u)
if [[ ${component} == -* ]] && [[ ${uninstall} == "true" ]]; then
	argument="true"
	component=""
fi

# Exit if no component is specified
if ([[ -z "${custom}" ]] && \
	[ "${component}" != "${onebox_component}" ] && \
	[ "${component}" != "${defender_component_docker}" ] && \
	[ "${component}" != "${defender_component_linux_server}" ] && \
	[ "${component}" != "${defender_component_pcf}" ] && \
	[ "${component}" != "${console_component}" ] && \
	[[ "${argument}" != "true" ]] \
	);then
	show_help
	exit
fi

# Create Twistlock scripts folder if not exists
mkdir -p ${DATA_FOLDER}/scripts

if [[ "${component}" == "${defender_component_linux_server}" ]]; then
	if [[ -z "${install_folder}" ]]; then
		install_folder="/opt/twistlock"
	fi

	if [[  "${uninstall}" == "true" ]]; then
		uninstall_server_defender "${install_folder}" "${DATA_FOLDER}"
		exit
	fi

	print_debug "Checking host system requirements"
	check_sys_requirements "${component}"

	copy_scripts

	install_server_defender "${install_folder}" "${console_address}"
	exit
fi

if [[ "${component}" == "${defender_component_pcf}" ]]; then
	DATA_FOLDER=${PCF_DATA_DIR}
	if [ -d ${DATA_FOLDER} ]; then
		mkdir ${DATA_FOLDER}
	fi
	install_folder=${PCF_BINARY_DIR}
	twistlock_user=root

	# Unpack archive
	print_debug "Extracting the defender to ${install_folder}"
	tar zxf "${defender_bundle_linux_server}" -C "${install_folder}" defender
	exit_on_failure $? "Failed extracting ${defender_bundle_linux_server}"

	set_server_defender_install_folder_permissions "${install_folder}"
	set_data_folder_permissions
	copy_local_certificates

	export WS_ADDRESS=wss://${console_address}:${COMMUNICATION_PORT}
	export LOG_PROD=true
	export DATA_FOLDER=${DATA_FOLDER}

	if [[ ${working_folder} == *.twistlock ]]; then
		# Cleanup working folder data because the defender execution will be blocked
		rm "${working_folder}"/*
	fi

	print_info "Starting PCF defender"
	${PCF_BINARY_DIR}/defender pcf 2>&1 >> ${PCF_LOG_DIR}/defender.stdout.log

	exit
fi

set_docker_command
set_docker_version

if [[ $(version_higher_equal $docker_version 1.7) != 1 ]]; then
	print_error "Twistlock requires Docker version 1.8 or higher"
	exit 1;
fi
# Legacy security options operator (<= 1.10)
if [[ $(version_higher_equal ${docker_version} 1.11) == -1 ]] ; then
	security_opt_operator=":"
fi

if [ "$tag" ]; then
	print_debug "Using Twistlock image tag - $tag"
	DOCKER_TWISTLOCK_TAG=$tag
fi

defender_image="twistlock/private:defender${DOCKER_TWISTLOCK_TAG}"
console_image="twistlock/private:console${DOCKER_TWISTLOCK_TAG}"

if [ "$uninstall" == "true" ]; then
	uninstall_twistlock
	exit
fi

if [ "$skip_eula" != true ]; then
	approve_disclaimer
fi

set_data_folder_permissions

print_debug "Checking host system requirements"
check_sys_requirements $component

set_selinux_configurations

load_images $component

check_userns_enabled

copy_scripts

if [ "$component" == "${console_component}" ]; then
	if [[ $(${docker} ps | grep 'defender') ]]; then
		exit_now "In a onebox configuration, Defender and Console must be upgraded together"
	fi
	install_console "$console_address" "$drop"
fi

if [ "$component" == "${onebox_component}" ]; then
	install_console "$console_address" "$drop"
	# Always install registry scan capabilities in onebox
	# 127.0.0.1 is used instead of hostname since there are problems reaching localhost hostname inside defender
	install_defender "127.0.0.1" "true" "$upgrade"

	print_info "Installation completed successfully"
fi

if [ "$component" == "${defender_component_docker}" ]; then
	if [ -z "$console_address" ]; then
		print_error "Console address parameter must be provided"
		exit
	fi

	install_defender "$console_address" "$registry_enabled" "$upgrade"
	exit
fi

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

exit 0
