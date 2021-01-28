package org.jnd.microservices.basket.controller;

import org.jnd.microservices.basket.repositories.BasketRepository;
import org.jnd.microservices.model.Basket;
import org.jnd.microservices.model.Product;
import org.jnd.microservices.model.User;
import org.jnd.microservices.basket.proxies.ProductRepositoryProxy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@CrossOrigin
@RestController
@RequestMapping("/basket")
public class BasketController {

    private static final Logger log = LoggerFactory.getLogger(BasketController.class);

    @Autowired
    private ProductRepositoryProxy productRepositoryProxy;

    @Autowired
    private BasketRepository basketRepository;

    @RequestMapping(value = "/create", method = RequestMethod.POST)
    ResponseEntity<?> create(@RequestBody User user, @RequestHeader HttpHeaders headers) {

        log.debug("Basket Create for basket : "+user);
        Basket basket = null;

        basket = basketRepository.get(user.getUsername());
        log.debug("Basket exists ? Basket : "+basket);

        //basket does not exist : create it
        if (basket == null) {
            int basketId = basketRepository.size() + 1;
            basket = new Basket(basketId);
            basket.setUserId(user.getUsername());
            log.debug("Basket Create for basket : "+user.getUsername());
            log.debug("Basket Create #"+basketId);
            log.debug("Basket Create :"+basket);
            basketRepository.add(basket);
            basket = basketRepository.get(basketId);
        }

        user.setBasketId(basket.getId());
        basket = calculateTotal(basket);
        log.debug("Returning basket with basket data :"+user);
        return new ResponseEntity<>(user, null, HttpStatus.CREATED);
    }

    @RequestMapping(value = "/remove/{basketId}", method = RequestMethod.DELETE)
    ResponseEntity<?> delete(@RequestBody Basket basket, @RequestHeader HttpHeaders headers)    {

        log.debug("Remove Basket : "+basket);
        basketRepository.remove(basket);
        return new ResponseEntity<>("DELETED", null, HttpStatus.OK);
    }

    @RequestMapping(value = "/clearall", method = RequestMethod.DELETE)
    ResponseEntity<?> clearall(@RequestHeader HttpHeaders headers)    {

        log.debug("Clearing all Baskets");
        basketRepository.clear();
        return new ResponseEntity<>("CLEAR", null, HttpStatus.OK);
    }

    @RequestMapping(value = "/{basketId}/add/{productId}", method = RequestMethod.PUT)
    ResponseEntity<Basket> add(@PathVariable int basketId, @PathVariable String productId, @RequestHeader HttpHeaders headers) {

        log.debug("Basket #"+basketId+" Add Product#"+productId);

        ResponseEntity<Product> response = productRepositoryProxy.getProduct(productId,headers);
        Product product = response.getBody();

        Basket basket = basketRepository.get(basketId);

        if (basket.getProducts() != null) {
            int basketIndex = basket.getProducts().size();
            product.setBasketIndex(basketIndex);
            basket.getProducts().add(product);
        }
        else    {
            basket.setProducts(new ArrayList<>());
            product.setBasketIndex(0);
            basket.getProducts().add(product);
        }

        basket = calculateTotal(basket);
        return new ResponseEntity<>(basket, null, HttpStatus.OK);
    }

    @RequestMapping(value = "/{basketId}/remove/{productIndex}", method = RequestMethod.DELETE)
    ResponseEntity<Basket> remove(@PathVariable int basketId, @PathVariable int productIndex, @RequestHeader HttpHeaders headers) {

        log.debug("Basket #"+basketId+" remove product at index "+productIndex);

        Basket basket = basketRepository.get(basketId);
        if (basket.getProducts() != null) {
            basket.getProducts().remove(productIndex);

            //reset the indexes
            int index = 0;
            for (Product p : basket.getProducts())  {
                p.setBasketIndex(index);
                index = index +1;
            }

        }
        basket = calculateTotal(basket);
        return new ResponseEntity<>(basket, null, HttpStatus.OK);
    }

    @RequestMapping(value = "/{basketId}/empty", method = RequestMethod.DELETE)
    ResponseEntity<Basket> empty(@PathVariable int basketId, @RequestHeader HttpHeaders headers) {

        log.debug("Basket #"+basketId+" Emptying");

        Basket basket = basketRepository.get(basketId);
        if (basket.getProducts() != null) {
            basket.getProducts().clear();
        }
        basket = basketRepository.get(basketId);
        basket = calculateTotal(basket);
        return new ResponseEntity<>(basket, null, HttpStatus.OK);
    }

    @RequestMapping(value = "/get/{basketId}", method = RequestMethod.GET)
    ResponseEntity<Basket>  get(@PathVariable int basketId, @RequestHeader HttpHeaders headers) {

        log.debug("Get basket : "+basketId);

        Basket basket = basketRepository.get(basketId);
        basket = calculateTotal(basket);
        return new ResponseEntity<>(basket, null, HttpStatus.OK);
    }


    @RequestMapping(value = "/list", method = RequestMethod.GET)
    ResponseEntity<Object>  list(@RequestHeader HttpHeaders headers) {

        log.debug("List baskets");

        Object[] baskets = basketRepository.entrySet().toArray();

        return new ResponseEntity<>(baskets, null, HttpStatus.OK);
    }

    @RequestMapping(value = "/inventory", method = RequestMethod.GET)
    ResponseEntity<Object> getInventory(HttpHeaders headers) {


        log.debug("Basket inventory #");

        ResponseEntity<List> response = productRepositoryProxy.getAllProducts(headers);
        log.debug("Basket inventory : "+response.getBody());

        return new ResponseEntity<>(response.getBody(), null, HttpStatus.OK);
    }


    private Basket calculateTotal(Basket basket)    {

        float total = 0.0f;
        for (Product p : basket.getProducts())  {
            total = total + p.getPrice();
        }

        basket.setTotal(total);
        log.debug("Basket total : " + basket.getTotal());
        return basket;
    }

}
