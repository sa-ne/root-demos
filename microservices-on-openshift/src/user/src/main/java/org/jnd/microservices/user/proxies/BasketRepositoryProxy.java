package org.jnd.microservices.user.proxies;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jnd.microservices.model.User;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;


@Component("BasketRepositoryProxy")
public class BasketRepositoryProxy {

    @Value( "${basket.host}" )
    String basket_host;

    private Log log = LogFactory.getLog(BasketRepositoryProxy.class);

    private RestTemplate restTemplate = new RestTemplate();;

    public ResponseEntity<User> getBasket(User user, HttpHeaders headers) {

        log.debug("BasketRepositoryProxy getBasket for basket : "+user);
        log.debug("BasketRepositoryProxy getBasket for URL : "+"http://"+basket_host+"/basket/create");


        HttpEntity<User> request = new HttpEntity<>(user, headers);

        ResponseEntity<User> exchange =
                this.restTemplate.exchange(
                        "http://"+basket_host+"/basket/create",
                        HttpMethod.POST,
                        request,
                        User.class);

        user = exchange.getBody();
        log.debug("Basket Response : "+user);

        if (user == null)
            throw new RuntimeException();

        return exchange;
    }

    public String getBasketHealth() {

        log.debug("BasketRepositoryProxy getBasketHealth for URL : "+"http://"+basket_host+"/basket/health");

        String response = this.restTemplate.getForObject("http://"+basket_host+"/basket/health", String.class);

        log.debug("Basket Health Response : "+response);

        return response;
    }
}
