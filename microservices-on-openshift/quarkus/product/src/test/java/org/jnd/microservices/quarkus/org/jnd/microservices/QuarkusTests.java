package org.jnd.microservices.quarkus.org.jnd.microservices;

import io.quarkus.test.junit.QuarkusTest;
import io.restassured.response.Response;

import org.jboss.logging.Logger;
import org.junit.jupiter.api.Test;
import org.jnd.microservices.quarkus.product.model.Product;

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
      assertThat(node.get("checks").get(0).get("name").asText(), equalToIgnoringCase("Product Health"));
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
      assertThat(node.get("checks").get(0).get("name").asText(), equalToIgnoringCase("Product Health"));
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  @Test
  public void testRootEndpoint() {
    given().when().get("/products/").then().statusCode(200).body(is("OK"));
  }

  @Test
  public void testHealthEndpoint() {
    given().when().get("/products/health").then().statusCode(200).body(is("OK"));
  }

  @Test
  public void testProductsAllEndpoint() {
    given().when().get("/products/all").then().statusCode(200).body("$.size()", is(18));
  }

  @Test
  public void testProductsAllDataEndpoint() {
    Response response = given().when().get("/products/all").then().statusCode(200).extract().response();

    log.info(response.asString());

    try {
      ObjectMapper mapper = new ObjectMapper();
      JsonNode node = mapper.readTree(response.asString());
      Product[] products = mapper.readValue(response.asString(), Product[].class);
      log.info(node.get(0));
      log.info(products[0]);
      assertThat(products[0].getName(), is("socks"));
      assertThat(products[1].getName(), is("jacket"));

    } catch (IOException e) {
      e.printStackTrace();
    }
            
  } 

  @Test
  public void testProductTypesDataEndpoint() {
    Response response = given().when().get("/products/types").then().statusCode(200).extract().response();

    log.info(response.asString());

    try {
      ObjectMapper mapper = new ObjectMapper();
      JsonNode node = mapper.readTree(response.asString());
      String[] types = mapper.readValue(response.asString(), String[].class);
      log.info(node.get(0));
      log.info(types[0]);
      assertThat(types[0], is("food"));
    } catch (IOException e) {
      e.printStackTrace();
    }
            
  } 

  @Test
  public void testProductsOfTypeEndpoint() {
    Response response = given().when().get("/products/type/clothes").then().statusCode(200).extract().response();

    log.info(response.asString());

    try {
      ObjectMapper mapper = new ObjectMapper();
      JsonNode node = mapper.readTree(response.asString());
      Product[] products = mapper.readValue(response.asString(), Product[].class);
      log.info(node.get(0));
      log.info(products[0]);
      assertThat(products[0].getName(), is("socks"));
      assertThat(products[1].getName(), is("jacket"));

    } catch (IOException e) {
      e.printStackTrace();
    }
            
  } 

  @Test
  public void testGetProductEndpoint() {
    Response response = given().when().get("/products/1").then().statusCode(200).extract().response();

    log.info(response.asString());

    try {
      ObjectMapper mapper = new ObjectMapper();
      JsonNode node = mapper.readTree(response.asString());
      Product product = mapper.readValue(response.asString(), Product.class);
      log.info(node);
      log.info(product);
      assertThat(product.getName(), is("marmalade"));

    } catch (IOException e) {
      e.printStackTrace();
    }          
  }
 
  @Test
  public void configTest1() {
    Response response = given().when().get("/config/1").then().statusCode(200).extract().response();
    log.info(response.asString());
    assertThat(response.asString(), is("This is Config Data 1"));         
  }

  // @Test
  // public void configTest2() {
  //   Response response = given().when().get("/config/2").then().statusCode(200).extract().response();
  //   log.info(response.asString());
  //   assertThat(response.asString(), is("This is Config Data 2"));         
  // }
}