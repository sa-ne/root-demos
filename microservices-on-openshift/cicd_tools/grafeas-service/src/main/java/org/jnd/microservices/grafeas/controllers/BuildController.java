package org.jnd.microservices.grafeas.controllers;

import org.jnd.microservices.grafeas.model.Build;
import org.jnd.microservices.grafeas.proxies.GrafeasProxy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin
@RestController
@RequestMapping("/build")
public class BuildController {

    private static final Logger log = LoggerFactory.getLogger(BuildController.class);

    @Autowired
    private GrafeasProxy proxy;

    @RequestMapping(value = "/new", method = RequestMethod.POST, produces = "application/json")
    ResponseEntity<?> create(@RequestBody Build build, @RequestHeader HttpHeaders headers) {

        log.debug("New Build");

        //get basket's basket data
        ResponseEntity<Build> responseEntity = proxy.newBuild(build);



        return responseEntity;
    }

}
