package org.jnd.microservices.quarkus;

import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;
import org.jboss.resteasy.annotations.jaxrs.PathParam;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;


@Path("/serviceb")
@RegisterRestClient
public interface ServiceBClient {

    @GET
    @Path("/echo/{data}")
    @Produces("application/json")
    String echo(@PathParam String data);
}