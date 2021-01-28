# Kaniko : Building container Images from within a Container

## Initial Source

https://medium.com/developers-writing/reducing-build-time-on-openshift-using-kaniko-909d4bf0a874

Before the Kaniko pod can run there are two things that must happen.

   * A Persistent Volume must be created an populated with a docker config file with a servicesccount token that has privileges (builder) to push to the openshift registry.
   * A persentent Volume must be created to contain a Docker file and it's resources that are to be built.

These persistent volumes need to be setup in a way that all the appripriatefiles are availablw when the Kaniko pod starts.

So we set the PVs up with a RHEL instance to provide shell access to those PVs.
