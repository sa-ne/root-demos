package org.jnd.microservices.apigateway;

import org.keycloak.adapters.KeycloakConfigResolver;
import org.keycloak.adapters.springboot.KeycloakSpringBootConfigResolver;
import org.keycloak.adapters.springsecurity.KeycloakConfiguration;
import org.keycloak.adapters.springsecurity.authentication.KeycloakAuthenticationProvider;
import org.keycloak.adapters.springsecurity.config.KeycloakWebSecurityConfigurerAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.authority.mapping.SimpleAuthorityMapper;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.security.web.authentication.session.RegisterSessionAuthenticationStrategy;
import org.springframework.security.web.authentication.session.SessionAuthenticationStrategy;


@KeycloakConfiguration
public class SecurityConfig extends KeycloakWebSecurityConfigurerAdapter {
    /**
     * Registers the KeycloakAuthenticationProvider with the authentication manager.
     */
    @Autowired
    public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {

        KeycloakAuthenticationProvider keycloakAuthenticationProvider
                = keycloakAuthenticationProvider();
        keycloakAuthenticationProvider.setGrantedAuthoritiesMapper(
                new SimpleAuthorityMapper());

        auth.authenticationProvider(keycloakAuthenticationProvider());
    }


    /**
     * Defines the session authentication strategy.
     */
    @Bean
    @Override
    protected SessionAuthenticationStrategy sessionAuthenticationStrategy() {
        return new RegisterSessionAuthenticationStrategy(new SessionRegistryImpl());
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        super.configure(http);

        //to do a HTTP POST, we must turn off Cross-Site Request Forgery protection, which is on by default
        http.csrf().disable();

        // exclude OPTIONS requests from authorization checks
        http.cors();

        //allow anything through
        //http.authorizeRequests().antMatchers("/").permitAll();

        //must present a valid access token
        //http.authorizeRequests().anyRequest().authenticated();

        // must present a valid access token and have appropriate role
        // analysed in order.
        // if no pattern match for uri and role then denied
        http.authorizeRequests().
                antMatchers(HttpMethod.GET,"/health").permitAll().
                antMatchers(HttpMethod.GET, "/api/products/**").hasRole("product").
                antMatchers(HttpMethod.GET,"/api/products/type/**").hasRole("product").
                antMatchers(HttpMethod.POST,"/api/session").hasRole("user").
                antMatchers(HttpMethod.POST,"/api/login").hasRole("user").
                antMatchers(HttpMethod.DELETE,"/api/logout").hasRole("user").
                antMatchers(HttpMethod.DELETE,"/api/basket/**").hasRole("basket").
                antMatchers(HttpMethod.PUT,"/api/basket/**").hasRole("basket").
                antMatchers(HttpMethod.GET,"/api/basket/**").hasRole("basket").
                antMatchers("/**").denyAll();
    }

    @Bean
    public KeycloakConfigResolver KeycloakConfigResolver() {
        return new KeycloakSpringBootConfigResolver();
    }
}

