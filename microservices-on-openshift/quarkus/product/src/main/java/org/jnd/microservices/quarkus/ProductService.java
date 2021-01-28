package org.jnd.microservices.quarkus;

import javax.enterprise.event.Observes;
import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import java.util.ArrayList;
import java.util.Collection;

import org.jboss.logging.Logger;

import java.util.List;

import javax.ws.rs.core.UriInfo;
import javax.ws.rs.core.Request;

import org.jnd.microservices.quarkus.product.model.Product;

import org.jnd.microservices.quarkus.product.repository.ProductRepository;

import io.quarkus.runtime.StartupEvent;
import io.quarkus.runtime.configuration.ProfileManager;

@Path("/products")
public class ProductService {

    private static final Logger log = Logger.getLogger(ProductService.class.getName());

    void onStart(@Observes StartupEvent ev) {
        log.info("The application is starting with profile : " + ProfileManager.getActiveProfile());
    }

    @Inject
    ProductRepository repository;

    @GET
    @Path("")
    @Produces(MediaType.TEXT_PLAIN)
    public String ok() {
        return "OK";
    }

    @GET
    @Path("/health")
    @Produces(MediaType.TEXT_PLAIN)
    public String health() {
        return "OK";
    }

    @GET
    @Path("/all")
    @Produces(MediaType.APPLICATION_JSON)
    public Product[] all(@Context UriInfo uriInfo, @Context Request req) {

        log.info(req.getMethod() + " " + uriInfo.getRequestUri());

        Collection<Product> products = repository.getProducts().values();
        log.debug(products);
        return products.toArray(new Product[products.size()]);
    }

    @GET
    @Path("/types")
    @Produces(MediaType.APPLICATION_JSON)
    public String[] getTypes(@Context UriInfo uriInfo, @Context Request req) {

        log.info("Product get types");
        log.info(req.getMethod()+" "+uriInfo.getRequestUri());

        List<String> types = repository.getTypes();

        return types.toArray(new String[types.size()]);
    }

    @GET
    @Path("/type/{type}")
    @Produces(MediaType.APPLICATION_JSON)
    public Product[] getProductsOfType(@PathParam("type") String type, @Context UriInfo uriInfo, @Context Request req) {

        log.debug("Product get of type :"+type);
        log.info(req.getMethod()+" "+uriInfo.getRequestUri());

        ArrayList<Product> products = new ArrayList<Product>();
        for (Product p : repository.getProducts().values()){
            if (p.getType().toString().equalsIgnoreCase(type))   {
                products.add(p);
            }
        }

        return products.toArray(new Product[products.size()]);
    }

    @GET
    @Path("/{productId}")
    @Produces(MediaType.APPLICATION_JSON)
    public Product get(@PathParam("productId") Integer productId, @Context UriInfo uriInfo, @Context Request req) {

        log.debug("Product get : "+productId);
        log.info(req.getMethod()+" "+uriInfo.getRequestUri());

        Product product = repository.getProducts().get(Integer.toString(productId));

        return product;
    }

}