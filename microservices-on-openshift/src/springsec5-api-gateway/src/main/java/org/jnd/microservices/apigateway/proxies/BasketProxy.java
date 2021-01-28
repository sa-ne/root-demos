package org.jnd.microservices.apigateway.proxies;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jnd.microservices.model.Basket;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;


@Component("BasketProxy")
public class BasketProxy {

    @Value( "${basket.host}" )
    String basket_host;

    private Log log = LogFactory.getLog(BasketProxy.class);

    private RestTemplate restTemplate = new RestTemplate();;

    public ResponseEntity<Basket> addToBasket(int basketid, int productid, HttpHeaders headers) {

        log.debug(">> addToBasket basketid : "+basketid+" productid : "+productid);

        ResponseEntity<Basket> exchange =
                this.restTemplate.exchange(
                        "http://"+basket_host+"/basket/{basketid}/add/{productid}",
                        HttpMethod.PUT,
                        new HttpEntity<byte[]>(headers),
                        new ParameterizedTypeReference<Basket>() {},
                        basketid, productid);

        return exchange;
    }

    public ResponseEntity<Basket> removefromBasket(int basketid, int productindex, HttpHeaders headers) {

        log.debug(">> removefromBasket basketid : "+basketid+" productindex : "+productindex);

        ResponseEntity<Basket> exchange =
                this.restTemplate.exchange(
                        "http://"+basket_host+"/basket/{basketid}/remove/{productindex}",
                        HttpMethod.DELETE,
                        new HttpEntity<byte[]>(headers),
                        new ParameterizedTypeReference<Basket>() {},
                        basketid, productindex);

        return exchange;
    }

    public ResponseEntity<Basket> getBasket(int basketid, HttpHeaders headers) {

        ResponseEntity<Basket> exchange =
                this.restTemplate.exchange(
                        "http://"+basket_host+"/basket/get/"+basketid,
                        HttpMethod.GET,
                        new HttpEntity<byte[]>(headers),
                        new ParameterizedTypeReference<Basket>() {},
                        basketid);

        log.debug("basket response : "+(Basket)exchange.getBody());

        if (exchange.getBody() == null)
            throw new RuntimeException();

        return exchange;
    }

    public ResponseEntity<Basket> emptyBasket(int basketid, HttpHeaders headers) {

        log.debug(">> emptyBasket basketid : "+basketid);

        ResponseEntity<Basket> exchange =
                this.restTemplate.exchange(
                        "http://"+basket_host+"/basket/{basketid}/empty",
                        HttpMethod.DELETE,
                        new HttpEntity<byte[]>(headers),
                        new ParameterizedTypeReference<Basket>() {},
                        basketid);

        return exchange;
    }
}
