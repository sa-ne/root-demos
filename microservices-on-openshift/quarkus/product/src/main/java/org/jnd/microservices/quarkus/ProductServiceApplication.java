
package org.jnd.microservices.quarkus;

import org.eclipse.microprofile.openapi.annotations.OpenAPIDefinition;
import org.eclipse.microprofile.openapi.annotations.info.Info;
import org.eclipse.microprofile.openapi.annotations.tags.Tag;
import org.eclipse.microprofile.openapi.annotations.info.Contact;
import org.eclipse.microprofile.openapi.annotations.info.License;

import javax.ws.rs.core.Application;

@OpenAPIDefinition(
    tags = {
            @Tag(name="app", description="product"),
            @Tag(name="architecture", description="quarkus")
    },
    info = @Info(
        title="Product API",
        version = "1.0.1",
        contact = @Contact(
            name = "Product API Support",
            url = "http://amazin.com/contact",
            email = "techsupport@amazin.com"),
        license = @License(
            name = "Apache 2.0",
            url = "http://www.apache.org/licenses/LICENSE-2.0.html"))
)
public class ProductServiceApplication extends Application {
}