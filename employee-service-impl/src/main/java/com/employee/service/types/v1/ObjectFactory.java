
package com.employee.service.types.v1;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the com.employee.service.types.v1 package. 
 * &lt;p&gt;An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _CreateEmployeeRequest_QNAME = new QName("http://service.employee.com/types/v1", "createEmployeeRequest");
    private final static QName _CreateEmployeeResponse_QNAME = new QName("http://service.employee.com/types/v1", "createEmployeeResponse");
    private final static QName _CreateEmployeeFault_QNAME = new QName("http://service.employee.com/types/v1", "createEmployeeFault");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: com.employee.service.types.v1
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link CreateEmployeeRequest }
     * 
     */
    public CreateEmployeeRequest createCreateEmployeeRequest() {
        return new CreateEmployeeRequest();
    }

    /**
     * Create an instance of {@link CreateEmployeeResponse }
     * 
     */
    public CreateEmployeeResponse createCreateEmployeeResponse() {
        return new CreateEmployeeResponse();
    }

    /**
     * Create an instance of {@link CreateEmployeeFault }
     * 
     */
    public CreateEmployeeFault createCreateEmployeeFault() {
        return new CreateEmployeeFault();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link CreateEmployeeRequest }{@code >}
     * 
     * @param value
     *     Java instance representing xml element's value.
     * @return
     *     the new instance of {@link JAXBElement }{@code <}{@link CreateEmployeeRequest }{@code >}
     */
    @XmlElementDecl(namespace = "http://service.employee.com/types/v1", name = "createEmployeeRequest")
    public JAXBElement<CreateEmployeeRequest> createCreateEmployeeRequest(CreateEmployeeRequest value) {
        return new JAXBElement<CreateEmployeeRequest>(_CreateEmployeeRequest_QNAME, CreateEmployeeRequest.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link CreateEmployeeResponse }{@code >}
     * 
     * @param value
     *     Java instance representing xml element's value.
     * @return
     *     the new instance of {@link JAXBElement }{@code <}{@link CreateEmployeeResponse }{@code >}
     */
    @XmlElementDecl(namespace = "http://service.employee.com/types/v1", name = "createEmployeeResponse")
    public JAXBElement<CreateEmployeeResponse> createCreateEmployeeResponse(CreateEmployeeResponse value) {
        return new JAXBElement<CreateEmployeeResponse>(_CreateEmployeeResponse_QNAME, CreateEmployeeResponse.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link CreateEmployeeFault }{@code >}
     * 
     * @param value
     *     Java instance representing xml element's value.
     * @return
     *     the new instance of {@link JAXBElement }{@code <}{@link CreateEmployeeFault }{@code >}
     */
    @XmlElementDecl(namespace = "http://service.employee.com/types/v1", name = "createEmployeeFault")
    public JAXBElement<CreateEmployeeFault> createCreateEmployeeFault(CreateEmployeeFault value) {
        return new JAXBElement<CreateEmployeeFault>(_CreateEmployeeFault_QNAME, CreateEmployeeFault.class, null, value);
    }

}
