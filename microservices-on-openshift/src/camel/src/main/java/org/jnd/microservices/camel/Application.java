package org.jnd.microservices.camel;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;


@ComponentScan
@SpringBootApplication(scanBasePackages={"org.jnd.microservices.camel"})
@RestController
@Configuration
@EnableAutoConfiguration
public class Application extends SpringBootServletInitializer {


	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}


	@RequestMapping(value = "/health", method = RequestMethod.GET)
	public String ping() {
		return "OK";
	}

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home() {
		return "OK";
	}

}
