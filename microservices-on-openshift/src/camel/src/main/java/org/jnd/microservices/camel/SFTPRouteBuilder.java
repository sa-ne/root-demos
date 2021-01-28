package org.jnd.microservices.camel;

import org.apache.camel.builder.RouteBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class SFTPRouteBuilder extends RouteBuilder {

    @Value("${sftp.host:not_found}")
    private String host = null;
    @Value("${sftp.port:not_found}")
    private String port = null;
    @Value("${sftp.path:not_found}")
    private String path = null;
    @Value("${sftp.username:not_found}")
    private String username = null;
    @Value("${sftp.passphrase:not_found}")
    private String passphrase = null;

    @Value("${sftp.keyfile:not_found}")
    private String keyfile = null;


    @Override
    public void configure() throws Exception {

        System.out.println("Using Key File : "+keyfile);

        from("file://files")
                .routeId("fileExport")
                .to("sftp://"+ host +":"+ port + path + "?username="+ username +"&privateKeyPassphrase="+ passphrase +
                        "&privateKeyFile="+ keyfile +"&connectTimeout=10000&preferredAuthentications=publickey&jschLoggingLevel=debug&delete=true")
                .startupOrder(1);

    }

}
