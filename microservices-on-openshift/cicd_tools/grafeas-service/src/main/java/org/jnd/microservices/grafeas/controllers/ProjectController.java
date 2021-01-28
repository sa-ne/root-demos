package org.jnd.microservices.grafeas.controllers;

import com.fasterxml.jackson.core.JsonProcessingException;
import org.jnd.microservices.grafeas.model.Build;
import org.jnd.microservices.grafeas.model.Project;
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
@RequestMapping("/project")
public class ProjectController {

    private static final Logger log = LoggerFactory.getLogger(BuildController.class);

    @Autowired
    private GrafeasProxy proxy;

    @RequestMapping(value = "/create", method = RequestMethod.POST, produces = "application/json")
    ResponseEntity<?> create(@RequestBody Project project, @RequestHeader HttpHeaders headers) {

        log.debug("New Project");

        ResponseEntity<?> responseEntity = null;
        try {
            responseEntity = proxy.createProject(project);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }


        return new ResponseEntity<>(responseEntity.toString(), null, HttpStatus.CREATED);
    }
}
