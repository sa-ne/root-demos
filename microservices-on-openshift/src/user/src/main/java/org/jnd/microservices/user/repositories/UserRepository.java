package org.jnd.microservices.user.repositories;

import org.jnd.microservices.model.User;
import org.springframework.stereotype.Component;

import java.util.HashMap;

/**
 * Created by justin on 13/10/2015.
 */
@Component("UserRepository")
public class UserRepository extends HashMap<String, User>{

}
