package org.jnd.microservices.quarkus.org.jnd.microservices;

import io.quarkus.test.junit.QuarkusTest;
import io.restassured.response.Response;

import org.jboss.logging.Logger;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.Matchers.*;
import static org.hamcrest.MatcherAssert.assertThat;

import java.io.IOException;


import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@QuarkusTest
public class QuarkusTests {

  private static final Logger log = Logger.getLogger(QuarkusTests.class.getName());

  @Test
  public void livenessTest() {
    Response response = given().when().get("/health/live").then().statusCode(200).extract().response();

    try {
      ObjectMapper mapper = new ObjectMapper();
      JsonNode node = mapper.readTree(response.asString());
      log.info(response.asString());
      log.info("Status : "+node.get("status"));
      assertThat(node.get("checks").get(0).get("name").asText(), equalToIgnoringCase("ServiceA Health"));
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  @Test
  public void readinessTest() {
    Response response = given().when().get("/health/ready").then().statusCode(200).extract().response();

    try {
      ObjectMapper mapper = new ObjectMapper();
      JsonNode node = mapper.readTree(response.asString());
      log.info(response.asString());
      log.info("Status : "+node.get("status"));
      assertThat(node.get("checks").get(0).get("name").asText(), equalToIgnoringCase("ServiceA Health"));
    } catch (IOException e) {
      e.printStackTrace();
    }
  }


  @Test
  public void testHealthEndpoint() {
    given().when().get("/servicea/health").then().statusCode(200).body(is("OK"));
  }



  // @Test
  // public void testServiceb() {
  //   given().when().get("/servicea/echo/data_from_service_a").then().statusCode(200).body(is("From Service B : data_from_service_a"));
  // }

 

}