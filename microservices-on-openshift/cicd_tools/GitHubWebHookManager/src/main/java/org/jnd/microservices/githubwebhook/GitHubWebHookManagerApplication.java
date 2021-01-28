package org.jnd.microservices.githubwebhook;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.annotation.RestController;

@ComponentScan
@SpringBootApplication(scanBasePackages={"org.jnd"})
@RestController
@Configuration
@EnableAutoConfiguration
public class GitHubWebHookManagerApplication {

	public static void main(String[] args) {
		SpringApplication.run(GitHubWebHookManagerApplication.class, args);
	}
}
