package org.jnd.microservices.grafeas;

import io.grafeas.ApiException;
import io.grafeas.api.GrafeasApi;
import io.grafeas.model.*;
import org.apache.commons.lang3.RandomStringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.threeten.bp.OffsetDateTime;

import java.util.*;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment= SpringBootTest.WebEnvironment.RANDOM_PORT, classes = GrafeasApplication.class)
@AutoConfigureMockMvc
@TestPropertySource(locations = "classpath:application-test.properties")
@ActiveProfiles("test")
public class GrafeasApplicationTests {

	private static final Logger log = LoggerFactory.getLogger(GrafeasApplicationTests.class);

	@Value("${grafeas.host:not_found}")
	private String grafeas = null;

	@Autowired
	private MockMvc mvc;

	@Test
	public void contextLoads() {
	}

	@Test
	public void ProjectCreate200()
			throws Exception {

		String tstProjName = "project_"+randomString();


		MvcResult result = mvc.perform(post("/project/create")
				.content("{\"name\":\"projects/"+tstProjName+"\"}\"")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isCreated())
				.andExpect(content()
						.contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andReturn();


		String json = result.getResponse().getContentAsString();
		log.debug("result : " + json);
	}


	@Test
	public void BuildTests()
			throws Exception {

		String tstProjName = "project_"+randomString();

		MvcResult result = mvc.perform(post("/project/create")
				.content("{\"name\":\"projects/"+tstProjName+"\"}\"")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isCreated())
				.andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andReturn();

		String json = result.getResponse().getContentAsString();
		log.info("Project Create result : " + json);
		log.info("Grafeas Server : " + grafeas);
		GrafeasApi apiInstance = new GrafeasApi();
		apiInstance.getApiClient().setBasePath(grafeas);

		String notename = "projects/"+tstProjName+"/notes/build_"+randomString();

		ApiNote note = new ApiNote(); // ApiNote |
		note.setName(notename);
		note.setCreateTime(OffsetDateTime.now());
		note.setKind(ApiNoteKind.BUILD_DETAILS);
		ApiBuildType build = new ApiBuildType();
		build.setBuilderVersion("1.0");
		ApiBuildSignature abs = new ApiBuildSignature();
		abs.setKeyId("my_key");
		abs.setKeyType(BuildSignatureKeyType.PKIX_PEM);
		abs.setPublicKey("QWEQWwrewterertytrey");
		abs.setSignature("sha256:werwerewrewrwerwetetret");
		build.setSignature(abs);
		note.setBuildType(build);

		try {
			note = apiInstance.createNote("projects/"+tstProjName, note);
			System.out.println(note.getName());
		} catch (ApiException e) {
			System.err.println("Exception when calling GrafeasApi#createNote");
			e.printStackTrace();
		}


		ApiOccurrence occ = new ApiOccurrence();
		occ.setName(notename+"/build1");
		occ.setNoteName(notename);
		occ.setCreateTime(OffsetDateTime.now());
		occ.setKind(ApiNoteKind.BUILD_DETAILS);
		occ.setResourceUrl("https://gcr.io/project/image@sha256:foo");
		ApiBuildDetails abd = new ApiBuildDetails();

		ApiBuildProvenance prov = new ApiBuildProvenance();
		abd.setProvenance(prov);
		occ.setBuildDetails(abd);
		prov.setBuilderVersion("1.0.1");

		prov.setProjectId("OLA");
		Map<String, String> options = new HashMap<>();
		options.put("skipTests", "false");
		prov.setBuildOptions(options);
		prov.setFinishTime(OffsetDateTime.now());
		prov.setCreator("Id of committer");
		prov.setId("Id from Jenkins");
		prov.setTriggerId("Id of committer");

		List artifacts = new ArrayList();
		ApiArtifact aa = new ApiArtifact();
		aa.setName("user.jar");
		aa.setChecksum("sha256:ertertertertert");
		artifacts.add(aa);
		prov.setBuiltArtifacts(artifacts);

		List buildCommands = new ArrayList();
		ApiCommand com = new ApiCommand();
		com.args(Collections.singletonList("mvn package"));
		buildCommands.add(com);
		prov.setCommands(buildCommands);

		prov.setId("1234");
		prov.setLogsBucket("s3://my_app/logs");

		try {
			occ = apiInstance.createOccurrence("projects/"+tstProjName, occ);
			System.out.println(occ.getName());
		} catch (ApiException e) {
			System.err.println("Exception when calling GrafeasApi#createNote");
			e.printStackTrace();
		}

	}


	@Test
	public void DiscoveryTests()
			throws Exception {

		String tstProjName = "project_"+randomString();

		MvcResult result = mvc.perform(post("/project/create")
				.content("{\"name\":\"projects/"+tstProjName+"\"}\"")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isCreated())
				.andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andReturn();

		String json = result.getResponse().getContentAsString();
		log.info("Project Create result : " + json);
		log.info("Grafeas Server : " + grafeas);
		GrafeasApi apiInstance = new GrafeasApi();
		apiInstance.getApiClient().setBasePath(grafeas);

		String notename = "projects/"+tstProjName+"/notes/discovery_"+randomString();

		ApiNote note = new ApiNote(); // ApiNote |
		note.setName(notename);
		note.setCreateTime(OffsetDateTime.now());
		note.setKind(ApiNoteKind.DISCOVERY);
		ApiDiscovery ad = new ApiDiscovery();
		note.setDiscovery(ad);
		ApiNoteKind ank = ApiNoteKind.fromValue("Unit Testing");
		ad.setAnalysisKind(ank);

		try {
			note = apiInstance.createNote("projects/"+tstProjName, note);
			System.out.println(note.getName());
		} catch (ApiException e) {
			System.err.println("Exception when calling GrafeasApi#createNote");
			e.printStackTrace();
		}

		ApiOccurrence occ = new ApiOccurrence();
		occ.setName(notename+"/discovery1");
		occ.setNoteName(notename);
		occ.setCreateTime(OffsetDateTime.now());
		occ.setKind(ApiNoteKind.DISCOVERY);
		occ.setResourceUrl("https://gcr.io/project/image@sha256:foo");
		DiscoveryDiscoveredDetails ddd = new DiscoveryDiscoveredDetails();
		occ.setDiscoveredDetails(ddd);
		LongrunningOperation lo = new LongrunningOperation();
		ddd.setOperation(lo);
		ProtobufAny pa = new ProtobufAny();
		pa.setValue("Test Results".getBytes());
		//lo.response(pa);

		try {
			occ = apiInstance.createOccurrence("projects/"+tstProjName, occ);
			System.out.println(occ.getName());
		} catch (ApiException e) {
			System.err.println("Exception when calling GrafeasApi#createNote");
			e.printStackTrace();
		}

	}

	@Test
	public void AttestationTests()
			throws Exception {

		String tstProjName = "project_" + randomString();

		MvcResult result = mvc.perform(post("/project/create")
				.content("{\"name\":\"projects/" + tstProjName + "\"}\"")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isCreated())
				.andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andReturn();

		String json = result.getResponse().getContentAsString();
		log.info("Project Create result : " + json);
		log.info("Grafeas Server : " + grafeas);
		GrafeasApi apiInstance = new GrafeasApi();
		apiInstance.getApiClient().setBasePath(grafeas);

		String notename = "projects/" + tstProjName + "/notes/attestation_" + randomString();

		ApiNote note = new ApiNote();
		note.setName(notename);
		note.setCreateTime(OffsetDateTime.now());
		note.setKind(ApiNoteKind.ATTESTATION_AUTHORITY);

		try {
			note = apiInstance.createNote("projects/"+tstProjName, note);
			System.out.println(note.getName());
		} catch (ApiException e) {
			System.err.println("Exception when calling GrafeasApi#createNote");
			e.printStackTrace();
		}

		ApiOccurrence occ = new ApiOccurrence();
		occ.setName(notename+"/attestation1");
		occ.setNoteName(notename);
		occ.setCreateTime(OffsetDateTime.now());
		occ.setKind(ApiNoteKind.ATTESTATION_AUTHORITY);
		AttestationAuthorityAttestationDetails aaad = new AttestationAuthorityAttestationDetails();
		ApiPgpSignedAttestation apsa = new ApiPgpSignedAttestation();
		aaad.setPgpSignedAttestation(apsa);

	}
	public String randomString() {
		String generatedString = RandomStringUtils.randomAlphabetic(5);
		return generatedString;
	}
}
