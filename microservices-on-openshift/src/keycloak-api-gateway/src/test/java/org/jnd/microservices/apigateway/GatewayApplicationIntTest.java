package org.jnd.microservices.apigateway;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jnd.microservices.model.Basket;
import org.jnd.microservices.model.Product;
import org.jnd.microservices.model.User;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import java.util.ArrayList;
import java.util.List;

import static junit.framework.TestCase.assertNull;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment= SpringBootTest.WebEnvironment.RANDOM_PORT, classes = GatewayApplication.class)
@AutoConfigureMockMvc
@TestPropertySource(locations = "classpath:application-test.yml")
@ActiveProfiles("test")
public class GatewayApplicationIntTest {

	private Log log = LogFactory.getLog(GatewayApplicationIntTest.class);

	@Autowired
	private MockMvc mvc;

	@Test
	public void loginTest200()
			throws Exception {

		ObjectMapper mapper = new ObjectMapper();

		User user = new User("justin1", "password");
		MvcResult result = mvc.perform(post("/api/login")
				.content(mapper.writeValueAsString(user))
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isCreated())
				.andExpect(content()
						.contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andReturn();


		String json = result.getResponse().getContentAsString();
		log.debug("result : " + json);

		user = mapper.readValue(json, User.class);
		assertNotNull(user);
		assertTrue(user.getId() > 0);
		assertTrue(user.getBasketId() > 0);
	}

	@Test
	public void logoutTest200() throws Exception {

		ObjectMapper mapper = new ObjectMapper();

		User user = new User("justin1", "password");
		MvcResult result = mvc.perform(post("/api/login")
				.content(mapper.writeValueAsString(user))
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isCreated())
				.andExpect(content()
						.contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andReturn();


		String json = result.getResponse().getContentAsString();
		log.debug("result : " + json);

		user = mapper.readValue(json, User.class);
		assertNotNull(user);
		assertTrue(user.getId() > 0);
		assertTrue(user.getBasketId() > 0);

		result = mvc.perform(delete("/api/logout/"+user.getId())
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andReturn();

		String resp = result.getResponse().getContentAsString();
		log.debug("result : " + json);
		assertNotNull(resp);
		assertTrue(resp.equals("LOGGED OUT"));
	}

	@Test
	public void getAllProductsTest200()
			throws Exception {

		MvcResult result = mvc.perform(get("/api/products/all")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andExpect(content()
						.contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andReturn();

		String json = result.getResponse().getContentAsString();
		log.debug("result : " + json);
		ObjectMapper mapper = new ObjectMapper();
		ArrayList types = mapper.readValue(json, ArrayList.class);
		assertNotNull(types);
	}

	@Test
	public void getProductTest200()
			throws Exception {

		MvcResult result = mvc.perform(get("/api/products/1")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andExpect(content()
						.contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andReturn();

		String json = result.getResponse().getContentAsString();
		log.debug("result : " + json);
		ObjectMapper mapper = new ObjectMapper();
		Product product = mapper.readValue(json, Product.class);
		assertNotNull(product);
	}

	@Test
	public void getAllFoodTest200()
			throws Exception {

		MvcResult result = mvc.perform(get("/api/products/type/food")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andExpect(content()
						.contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andReturn();

		String json = result.getResponse().getContentAsString();
		log.debug("result : " + json);
		ObjectMapper mapper = new ObjectMapper();
		ArrayList<Product> products;
		products = mapper.readValue(json, new TypeReference<ArrayList<Product>>() {});
		assertNotNull(products);
		assertTrue(products.size() > 1);
		assertTrue((Product)products.get(0) instanceof Product);
		Product p = (Product)products.get(0);
		assertNotNull(p);
	}

	@Test
	public void getProductTypesTest200()
			throws Exception {

		MvcResult result = mvc.perform(get("/api/products/types")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andExpect(content()
						.contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andReturn();

		String json = result.getResponse().getContentAsString();
		log.debug("result : " + json);
		ObjectMapper mapper = new ObjectMapper();
		List types = mapper.readValue(json, List.class);
		assertNotNull(types);
	}

	@Test
	public void getBasketTest200() throws Exception {

		ObjectMapper mapper = new ObjectMapper();
		String uuid = String.valueOf(System.currentTimeMillis())+"get";

		User user = new User(uuid, "password");
		MvcResult result = mvc.perform(post("/api/login")
				.content(mapper.writeValueAsString(user))
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isCreated())
				.andExpect(content()
						.contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andReturn();

		String json = result.getResponse().getContentAsString();
		log.debug("result : " + json);
		user = mapper.readValue(json, User.class);
		assertNotNull(user);
		assertTrue(user.getId() > 0);
		assertTrue(user.getBasketId() > 0);

		result = mvc.perform(get("/api/basket/get/"+user.getBasketId())
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andExpect(content()
						.contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andReturn();

		json = result.getResponse().getContentAsString();
		log.debug("result : " + json);
		Basket basket = mapper.readValue(json, Basket.class);
		assertNotNull(basket);
		assertTrue(basket.getId() == user.getBasketId());


		result = mvc.perform(delete("/api/logout/"+user.getId())
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andReturn();

		String resp = result.getResponse().getContentAsString();
		log.debug("result : " + json);
		assertNotNull(resp);
		assertTrue(resp.equals("LOGGED OUT"));
	}

	@Test
	public void addToBasketTest200() throws Exception {

		ObjectMapper mapper = new ObjectMapper();

		String uuid = String.valueOf(System.currentTimeMillis())+"add";

		//Login and get a basket
		User user = new User(uuid, "password");
		MvcResult result = mvc.perform(post("/api/login")
				.content(mapper.writeValueAsString(user))
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isCreated())
				.andExpect(content()
						.contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andReturn();

		String json = result.getResponse().getContentAsString();
		log.debug("result : " + json);
		user = mapper.readValue(json, User.class);
		assertNotNull(user);
		assertTrue(user.getId() > 0);
		assertTrue(user.getBasketId() > 0);

		//Add to Basket
		result = mvc.perform(put("/api/basket/"+user.getBasketId()+"/add/"+1)
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andExpect(content()
						.contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andReturn();

		json = result.getResponse().getContentAsString();
		log.debug("result : " + json);
		Basket basket = mapper.readValue(json, new TypeReference<Basket>() {});
		assertNotNull(basket);
		assertNotNull(basket.getProducts().get(0));
		assertTrue(basket.getId() == user.getBasketId());

		//cleanup by logging out
		result = mvc.perform(delete("/api/logout/"+user.getId())
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andReturn();

		String resp = result.getResponse().getContentAsString();
		log.debug("result : " + json);
		assertNotNull(resp);
		assertTrue(resp.equals("LOGGED OUT"));
	}

	@Test
	public void removeFromBasketTest200() throws Exception {

		ObjectMapper mapper = new ObjectMapper();
		String uuid = String.valueOf(System.currentTimeMillis())+"rem";
		//Login and get a basket
		User user = new User(uuid, "password");
		MvcResult result = mvc.perform(post("/api/login")
				.content(mapper.writeValueAsString(user))
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isCreated())
				.andExpect(content()
						.contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andReturn();

		String json = result.getResponse().getContentAsString();
		log.debug("result : " + json);
		user = mapper.readValue(json, User.class);
		assertNotNull(user);
		assertTrue(user.getId() > 0);
		assertTrue(user.getBasketId() > 0);

		//Add to Basket
		result = mvc.perform(put("/api/basket/"+user.getBasketId()+"/add/"+1)
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andExpect(content()
						.contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andReturn();

		json = result.getResponse().getContentAsString();
		log.debug("result : " + json);
		Basket basket = mapper.readValue(json, new TypeReference<Basket>() {});
		assertNotNull(basket);
		assertNotNull(basket.getProducts().get(0));
		assertTrue(basket.getId() == user.getBasketId());
		assertTrue(basket.getProducts().size() == 1);

		//Add to Basket
		result = mvc.perform(delete("/api/basket/"+user.getBasketId()+"/remove/"+0)
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andExpect(content()
						.contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andReturn();

		json = result.getResponse().getContentAsString();
		log.debug("result : " + json);
		basket = mapper.readValue(json, new TypeReference<Basket>() {});
		assertNotNull(basket);
		assertTrue(basket.getId() == user.getBasketId());
		assertTrue(basket.getProducts().size() == 0);

		//cleanup by logging out
		result = mvc.perform(delete("/api/logout/"+user.getId())
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())
				.andReturn();

		String resp = result.getResponse().getContentAsString();
		log.debug("result : " + json);
		assertNotNull(resp);
		assertTrue(resp.equals("LOGGED OUT"));
	}
}
