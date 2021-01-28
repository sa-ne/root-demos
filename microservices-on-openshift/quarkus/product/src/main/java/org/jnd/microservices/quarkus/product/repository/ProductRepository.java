package org.jnd.microservices.quarkus.product.repository;

import org.jnd.microservices.quarkus.product.model.Product;

import java.util.List;
import java.util.Map;

import javax.enterprise.context.ApplicationScoped;

@ApplicationScoped
public interface ProductRepository {

    Map<String, Product> getProducts();
    List<String> getTypes();
}
