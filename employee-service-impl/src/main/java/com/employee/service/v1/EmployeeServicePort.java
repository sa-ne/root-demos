package com.employee.service.v1;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;
import javax.xml.bind.annotation.XmlSeeAlso;

/**
 * This class was generated by Apache CXF 3.4.2
 * 2021-01-29T16:10:25.447-05:00
 * Generated source version: 3.4.2
 *
 */
@WebService(targetNamespace = "http://service.employee.com/v1", name = "EmployeeServicePort")
@XmlSeeAlso({com.employee.service.types.v1.ObjectFactory.class})
@SOAPBinding(parameterStyle = SOAPBinding.ParameterStyle.BARE)
public interface EmployeeServicePort {

    @WebMethod(action = "createEmployee")
    @WebResult(name = "createEmployeeResponse", targetNamespace = "http://service.employee.com/types/v1", partName = "createEmployeeResponse")
    public com.employee.service.types.v1.CreateEmployeeResponse createEmployee(

        @WebParam(partName = "createEmployeeRequest", name = "createEmployeeRequest", targetNamespace = "http://service.employee.com/types/v1")
        com.employee.service.types.v1.CreateEmployeeRequest createEmployeeRequest
    ) throws CreateEmployeeFault;
}
