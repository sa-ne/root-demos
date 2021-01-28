package org.jnd.microservices.basket.proxies;

import org.jnd.microservices.model.Product;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.List;


@Component("ProductRepositoryProxy")
public class ProductRepositoryProxy {

    @Value( "${inventory.host}" )
    String inventory_host;

    private Log log = LogFactory.getLog(ProductRepositoryProxy.class);

    private RestTemplate restTemplate = new RestTemplate();

    public ResponseEntity<Product> getProduct(String id, HttpHeaders headers) {

        log.debug("ProductRepositoryProxy get Product id : "+id);

        ResponseEntity<Product> exchange =
                this.restTemplate.exchange(
                        "http://"+inventory_host+"/products/{id}",
                        HttpMethod.GET,
                        new HttpEntity<byte[]>(headers),
                        new ParameterizedTypeReference<Product>() {},
                        id);

        Product resp = exchange.getBody();
        log.debug("Product Response : "+resp);

        if (exchange == null)
            throw new RuntimeException();

        return exchange;
    }

    public ResponseEntity<List> getAllProducts(HttpHeaders headers) {

        ResponseEntity<List> exchange =
                this.restTemplate.exchange(
                        "http://"+inventory_host+"/products/all",
                        HttpMethod.GET,
                        new HttpEntity<byte[]>(headers),
                        new ParameterizedTypeReference<List>() {});

        log.debug("Producta Response : "+exchange.getBody());

        if (exchange == null)
            throw new RuntimeException();

        return exchange;
    }

    public ResponseEntity<List> getProductsofType(String type, HttpHeaders headers) {

        ResponseEntity<List> exchange =
                this.restTemplate.exchange(
                        "http://"+inventory_host+"/products/type/{type}",
                        HttpMethod.GET,
                        new HttpEntity<byte[]>(headers),
                        new ParameterizedTypeReference<List>() {},
                        type);


        log.debug("Product Response : "+exchange.getBody());

        if (exchange == null)
            throw new RuntimeException();

        return exchange;
    }

    public ResponseEntity<List> getProductTypes(HttpHeaders headers) {

        ResponseEntity<List> exchange =
                this.restTemplate.exchange(
                        "http://"+inventory_host+"/products/types",
                        HttpMethod.GET,
                        new HttpEntity<byte[]>(headers),
                        new ParameterizedTypeReference<List>() {});

        log.debug("Product types response : "+exchange.getBody());

        if (exchange == null)
            throw new RuntimeException();

        return exchange;
    }

}
