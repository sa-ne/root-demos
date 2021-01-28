package org.jnd.microservices.user.controller;

import org.jnd.microservices.model.User;
import org.jnd.microservices.user.proxies.BasketRepositoryProxy;
import org.jnd.microservices.user.repositories.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin
@RestController
@RequestMapping("/user")
public class UserController {

    private static final Logger log = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BasketRepositoryProxy basketRepositoryProxy;

    private static int nextId = 0;

    @RequestMapping(value = "/login", method = RequestMethod.POST, produces = "application/json")
    ResponseEntity<?> create(@RequestBody User user, @RequestHeader HttpHeaders headers) {

        log.debug("User login");

        //check to see whether basket exists
        if (userRepository.containsKey(user.getUsername())) {
            //this basket exists : retreive
            user = userRepository.get(user.getUsername());
            log.debug("User exists : " +user);
        }
        else    {
            //this basket does not exist : create
            nextId = nextId + 1;
            user.setId(nextId);
            log.debug("User Create : " +user);
            userRepository.put(user.getUsername(), user);
        }

        //get basket's basket data
        ResponseEntity<User> responseEntity = basketRepositoryProxy.getBasket(user, headers);


        return responseEntity;
    }

    @RequestMapping(value = "/{userId}", method = RequestMethod.GET)
    ResponseEntity<?> get(@PathVariable int userId, @RequestHeader HttpHeaders headers) {

        log.debug("Get User : " + userId);

        User user = userRepository.get(Integer.toString(userId));
        log.debug("Get User : " + user);
        return new ResponseEntity<>(user, null, HttpStatus.CREATED);
    }

    @RequestMapping(value = "/logout/{userId}", method = RequestMethod.DELETE)
    ResponseEntity<?> logout(@PathVariable int userId, @RequestHeader HttpHeaders headers) {
        log.debug("Logout User : " + userId);
        userRepository.remove(Integer.toString(userId));
        return new ResponseEntity<>("LOOGGED OUT", null, HttpStatus.OK);
    }

    @RequestMapping(value = "/health", method = RequestMethod.GET)
    public String ping() {
        basketRepositoryProxy.getBasketHealth();
        return "OK";
    }
}
