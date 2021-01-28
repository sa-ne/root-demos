package org.jnd.microservices.quarkus.product.repository;

import org.jnd.microservices.quarkus.product.model.Product;

import org.jboss.logging.Logger;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class RepositoryBase implements ProductRepository {

    private static final Logger log = Logger.getLogger(RepositoryBase.class.getName());

    private ConcurrentHashMap<String, Product> products = new ConcurrentHashMap<>();
    private ArrayList<String> types = new ArrayList<>();

    public Map<String, Product> getProducts() {
        return products;
    }

    public List<String> getTypes() {
        return types;
    }

}
