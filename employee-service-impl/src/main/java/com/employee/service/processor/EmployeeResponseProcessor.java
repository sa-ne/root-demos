package com.employee.service.processor;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;

import org.apache.camel.Exchange;
import org.apache.camel.Processor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.employee.service.types.v1.CreateEmployeeRequest;
import com.employee.service.types.v1.CreateEmployeeResponse;

public class EmployeeResponseProcessor implements Processor {

	 private static final Logger LOGGER = LoggerFactory.getLogger(EmployeeResponseProcessor.class);
	 private static long counter = 0;
	 private static Map < Long, CreateEmployeeRequest > employees = new HashMap();
	 
	@Override
	public void process(Exchange exchange) throws Exception {
		  CreateEmployeeRequest request = exchange.getIn().getBody(CreateEmployeeRequest.class);
		  employees.put(counter, request);
		  synchronized(this) {
		   counter++;
		  }
		  
		  CreateEmployeeResponse response = new CreateEmployeeResponse();
		  response.setEmployeeID(BigInteger.valueOf(counter));
		 
		  LOGGER.debug("===============   Employee stored in map ID: " + counter);
		 
		  exchange.getIn().setBody(response);

	}

}
