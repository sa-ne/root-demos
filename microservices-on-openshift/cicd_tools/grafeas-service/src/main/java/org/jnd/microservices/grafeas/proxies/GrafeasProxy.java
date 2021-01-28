package org.jnd.microservices.grafeas.proxies;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.jnd.microservices.grafeas.controllers.BuildController;
import org.jnd.microservices.grafeas.model.Build;
import org.jnd.microservices.grafeas.model.Project;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component("GrafeasProxy")
public class GrafeasProxy {

    private static final Logger log = LoggerFactory.getLogger(GrafeasProxy.class);

    private RestTemplate restTemplate = new RestTemplate();;

    @Value("${grafeas.host:not_found}")
    private String grafeas = null;

    public ResponseEntity<String> createProject (Project project) throws JsonProcessingException {

//    curl -v -X POST https://grafeas-cicd.apps.ocp.datr.eu/v1beta1/projects \
//            -H "Content-Type: application/json" \
//            --data '{"name":"projects/provider_example"}'

        log.info("new project");

        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Type", "application/json");

        //HttpEntity<String> request = new HttpEntity<>("{\"name\":\"projects/provider_example2\"}", headers);

        ObjectMapper mapper = new ObjectMapper();

        log.info("Project : "+mapper.writeValueAsString(project));

        HttpEntity<Project> request = new HttpEntity<>(project, headers);

        ResponseEntity<String> exchange =
                this.restTemplate.exchange(
                        grafeas+"/v1alpha1/projects",
                        HttpMethod.POST,
                        request,
                        new ParameterizedTypeReference<String>() {});

        return exchange;
    }

    public ResponseEntity<Build> newBuild(Build build) {

        log.debug("new build");

        ResponseEntity<Build> exchange =
                this.restTemplate.exchange(
                        grafeas+"/basket/{basketid}/add/{productid}",
                        HttpMethod.PUT,
                        null,
                        new ParameterizedTypeReference<Build>() {});

        return exchange;
    }
}
