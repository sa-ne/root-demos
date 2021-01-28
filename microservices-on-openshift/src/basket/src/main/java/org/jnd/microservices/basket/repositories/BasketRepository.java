package org.jnd.microservices.basket.repositories;

import org.jnd.microservices.model.Basket;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * Created by justin on 13/10/2015.
 */
@Component("BasketRepository")
public class BasketRepository {

    private static final Logger log = LoggerFactory.getLogger(BasketRepository.class);

    private HashMap<Integer, Basket> baskets = new HashMap<Integer, Basket>();
    private HashMap<String, Integer> lookups = new HashMap<String, Integer>();

    public Basket get(Integer basketId)   {
        log.debug("BasketRepository get by id :"+basketId);
        Basket basket = baskets.get(basketId);
        log.debug("BasketRepository get by id :"+basket+" basket : "+basket);
        return basket;
    }

    public Basket get(String username)   {
        log.debug("BasketRepository get by username :"+username);
        Integer basketId = lookups.get(username);
        log.debug("BasketRepository get by username :"+username+" basketid : "+basketId);
        Basket basket = baskets.get(basketId);
        log.debug("BasketRepository get by username :"+username+" basket : "+basket);
        return basket;
    }

    public void add(Basket basket)   {
        log.debug("BasketRepository add basket : "+basket);
        lookups.put(basket.getUserId(), basket.getId());
        baskets.put(basket.getId(), basket);
    }

    public void remove(Basket basket)   {
        lookups.remove(basket.getUserId());
        baskets.remove(basket.getId());
    }

    public void clear()   {
        lookups.clear();
        baskets.clear();
    }

    public Set<Map.Entry<Integer, Basket>> entrySet()  {
        return baskets.entrySet();
    }

    public Integer size()   {
        return baskets.size();
    }
}
