 package com.xht.myApp;

 import org.junit.Before;
 import org.junit.Test;
 import org.junit.runner.RunWith;
 import org.springframework.beans.factory.annotation.Autowired;
 import org.springframework.boot.SpringApplication;
 import org.springframework.boot.autoconfigure.SpringBootApplication;
 import org.springframework.boot.test.SpringApplicationConfiguration;
 import org.springframework.cache.annotation.EnableCaching;
 import org.springframework.context.annotation.Configuration;
 import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
 import org.springframework.test.context.ActiveProfiles;
 import org.springframework.test.context.TestPropertySource;
 import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
 import org.springframework.test.context.web.WebAppConfiguration;
 import org.springframework.test.web.servlet.MockMvc;
 import org.springframework.test.web.servlet.setup.MockMvcBuilders;
 import org.springframework.transaction.annotation.EnableTransactionManagement;
 import org.springframework.web.context.WebApplicationContext;

 @RunWith(SpringJUnit4ClassRunner.class)
 @SpringApplicationConfiguration(classes = Application.class)
 @WebAppConfiguration
 @ActiveProfiles("test")
 public class MyApplicationTests {
 	@Autowired
 	private WebApplicationContext context;

 	private MockMvc mvc;

 	@Before
 	public void setUp() {
 		this.mvc = MockMvcBuilders.webAppContextSetup(this.context).build();
 	}

// 	@Test
 	public void contextLoads() {
 	}
 }
