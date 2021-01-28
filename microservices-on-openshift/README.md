# Microservices On Openshift


## The Application 

A basic shopping application for a store called "Amazin".

Composed of three microservices, written in Java, using Spring-Boot (https://projects.spring.io/spring-boot/) , deployed as executable jar files, and exposing RESTful endpoints. The 3 services are :
1. User : manages user logon
   * this services can be found in ```src/user```
2. Inventory : provides data to users about what's available to buy, this comes in three versions (controlled by spring.active.profiles)
   * this services can be found in ```src/inventory```, this service in three versions (controlled by spring.active.profiles)
        1. Food only (v1)
        2. Food and clothes (v2)
        3. Food clothes and gadgets (v3)
    
3. Basket : provides basket fuctionality 
   * this services can be found in ```src/basket``` 
    
And a frontend web application written in :
   * Angular 5 : https://angular.io/
   * Bootstrap 3 : https://getbootstrap.com/docs/3.3/
   * this app can be found in ```src/web```

All this can be built and deployed using Jenkins CICD pipelines using :
   * Openshift : https://www.openshift.com/
   * Jenkins : https://jenkins.io/
   * Pipelines scripts to do that are included here : ```deploy/<service-name>/cicd``` 
 
The microservives have been configured to support Open-tracing
   * http://opentracing.io/
    
And in particular integrate with an open-tracing dashboard application called Jaeger
   * http://www.jaegertracing.io/  
    
Istio, see below, provides the base infrastructure to make tracing possible, but small changes are required to the configuration of the micro services to make them traceable.


# Istio

https://istio.io/

This provides a high configurable network layer in which the microservices reside, enabling to control how the interest. Tis allow for :
   * Routing
   * Content-based routing
   * Load balancing
   * Security Policy enforcement
   * Monitoring
   * Tools to deal with application instability like Circuit Breaking
   
justind@motabilityoperations.co.uk