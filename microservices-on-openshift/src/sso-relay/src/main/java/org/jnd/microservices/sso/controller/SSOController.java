package org.jnd.microservices.sso.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import java.util.Enumeration;


@CrossOrigin
@RestController
@RequestMapping("/api")
public class SSOController {

    private static final Logger log = LoggerFactory.getLogger(SSOController.class);

    @Value( "${sso.server}" )
    String sso_server;

    @Value( "${sso.realm}" )
    String realm;

    @Value( "${sso.client_id}" )
    String client_id;

    @Value( "${sso.client_secret}" )
    String client_secret;

    @Value( "${sso.redirect_uri}" )
    String redirect_uri;

    @Value( "${sso.grant_type}" )
    String grant_type;

    @RequestMapping(value = "/handle-oauth", method = RequestMethod.GET, produces = "application/json")
    public ResponseEntity<String> login(@RequestHeader HttpHeaders headers, @RequestParam(name = "code") String code) {

        log.info("handle-oauth");
        log.info("code : "+code);
        log.info("sso_server : "+sso_server);

        String sso_uri = sso_server+"auth/realms/"+realm+"/protocol/openid-connect/token";
        log.info("sso_uri : "+sso_uri);

        String post_body = "grant_type="+grant_type+"&redirect_uri="+redirect_uri+"&client_id="+client_id+"&client_secret="+client_secret+"&code="+code;
        log.info("post_body : "+post_body);

        for (String key : headers.keySet()) {
            log.info(key+" : "+headers.get(key));
        }
        HttpHeaders outheaders = new HttpHeaders();
        outheaders.add(HttpHeaders.CONTENT_TYPE, "application/x-www-form-urlencoded");
        HttpEntity<String> request = new HttpEntity<>(post_body, outheaders);
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> exchange = null;
        try {
            exchange =
                    restTemplate.exchange(
                            sso_uri,
                            HttpMethod.POST,
                            request,
                            String.class);
        }
        catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<String>("Error", null, HttpStatus.SERVICE_UNAVAILABLE);
        }

        String response = exchange.getBody();

        return new ResponseEntity<String>(response, null, HttpStatus.OK);
    }



    @RequestMapping(value = "/health", method = RequestMethod.GET)
    public String ping() {
        return "OK";
    }


}
