package e2e;

import org.assertj.core.api.BDDAssertions;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.web.client.RestTemplate;

@RunWith(SpringRunner.class)
@SpringBootTest(classes = E2eTests.class,
		webEnvironment = SpringBootTest.WebEnvironment.NONE)
@EnableAutoConfiguration
public class E2eTests {

	Logger logger = LoggerFactory.getLogger(E2eTests.class);

	// The app is running in CF but the tests are executed from Concourse worker,
	// so the test will deduce the url to greeting-ui: it will assume the same host
	// as fortune-service, and simply replace "fortune-service" with "greeting-ui" in the url

	@Value("${application.url}") String applicationUrl;

	RestTemplate restTemplate = new RestTemplate();

	@Test
	public void should_return_a_prediction() {

		String predictUrl = this.applicationUrl + "/predict";

		logger.info("Making request to " + predictUrl);

		ResponseEntity<String> response = this.restTemplate
				.getForEntity(predictUrl, String.class);

		BDDAssertions.then(response.getStatusCodeValue()).isEqualTo(200);

	}

}