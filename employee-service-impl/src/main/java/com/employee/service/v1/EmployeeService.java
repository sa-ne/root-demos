package com.employee.service.v1;

import java.net.MalformedURLException;
import java.net.URL;
import javax.xml.namespace.QName;
import javax.xml.ws.WebEndpoint;
import javax.xml.ws.WebServiceClient;
import javax.xml.ws.WebServiceFeature;
import javax.xml.ws.Service;

/**
 * This class was generated by Apache CXF 3.4.2
 * 2021-01-28T15:40:16.010-05:00
 * Generated source version: 3.4.2
 *
 */
@WebServiceClient(name = "EmployeeService",
                  wsdlLocation = "file:/Users/samueltauil/Development/root-demos/employee-service-impl/src/main/resources/wsdl/employee-service.wsdl",
                  targetNamespace = "http://service.employee.com/v1")
public class EmployeeService extends Service {

    public final static URL WSDL_LOCATION;

    public final static QName SERVICE = new QName("http://service.employee.com/v1", "EmployeeService");
    public final static QName EmployeeServicePort = new QName("http://service.employee.com/v1", "EmployeeServicePort");
    static {
        URL url = null;
        try {
            url = new URL("file:/Users/samueltauil/Development/root-demos/employee-service-impl/src/main/resources/wsdl/employee-service.wsdl");
        } catch (MalformedURLException e) {
            java.util.logging.Logger.getLogger(EmployeeService.class.getName())
                .log(java.util.logging.Level.INFO,
                     "Can not initialize the default wsdl from {0}", "file:/Users/samueltauil/Development/root-demos/employee-service-impl/src/main/resources/wsdl/employee-service.wsdl");
        }
        WSDL_LOCATION = url;
    }

    public EmployeeService(URL wsdlLocation) {
        super(wsdlLocation, SERVICE);
    }

    public EmployeeService(URL wsdlLocation, QName serviceName) {
        super(wsdlLocation, serviceName);
    }

    public EmployeeService() {
        super(WSDL_LOCATION, SERVICE);
    }

    public EmployeeService(WebServiceFeature ... features) {
        super(WSDL_LOCATION, SERVICE, features);
    }

    public EmployeeService(URL wsdlLocation, WebServiceFeature ... features) {
        super(wsdlLocation, SERVICE, features);
    }

    public EmployeeService(URL wsdlLocation, QName serviceName, WebServiceFeature ... features) {
        super(wsdlLocation, serviceName, features);
    }




    /**
     *
     * @return
     *     returns EmployeeServicePort
     */
    @WebEndpoint(name = "EmployeeServicePort")
    public EmployeeServicePort getEmployeeServicePort() {
        return super.getPort(EmployeeServicePort, EmployeeServicePort.class);
    }

    /**
     *
     * @param features
     *     A list of {@link javax.xml.ws.WebServiceFeature} to configure on the proxy.  Supported features not in the <code>features</code> parameter will have their default values.
     * @return
     *     returns EmployeeServicePort
     */
    @WebEndpoint(name = "EmployeeServicePort")
    public EmployeeServicePort getEmployeeServicePort(WebServiceFeature... features) {
        return super.getPort(EmployeeServicePort, EmployeeServicePort.class, features);
    }

}
