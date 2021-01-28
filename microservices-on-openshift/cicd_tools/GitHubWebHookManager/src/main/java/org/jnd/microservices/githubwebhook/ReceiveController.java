package org.jnd.microservices.githubwebhook;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin
@RestController
@RequestMapping("/receive")
public class ReceiveController {

    private Log log = LogFactory.getLog(ReceiveController.class);

    @RequestMapping(value = "/postreceive", method = RequestMethod.POST, produces = "application/json")
    ResponseEntity<String> postreceive(@RequestBody Object githubmessage, @RequestHeader HttpHeaders headers) {

        log.info("postreceive received");
        ObjectMapper mapper = new ObjectMapper();
        mapper.enable(SerializationFeature.INDENT_OUTPUT);

        try {
            log.info("message : "+mapper.writeValueAsString(githubmessage));
            JSONObject obj = new JSONObject(mapper.writeValueAsString(githubmessage));
            JSONArray commits = obj.getJSONArray("commits");
            for (int i = 0; i < commits.length(); i++) {
                JSONObject commit = commits.getJSONObject(i);
                JSONArray modified = commit.getJSONArray("modified");
                for (int j = 0; j < modified.length(); j++) {
                    log.info("modified : "+modified.getString(j));
                }
            }

        } catch (JsonProcessingException e) {
            e.printStackTrace();
        } catch (JSONException e) {
            e.printStackTrace();
        }


        return new ResponseEntity<>("OK", null, HttpStatus.OK);
    }
}
