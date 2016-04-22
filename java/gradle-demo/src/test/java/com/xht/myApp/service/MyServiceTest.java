// package net.javabeat.spring.data.service;

// import java.util.List;

// import net.javabeat.spring.data.Application;
// import net.javabeat.spring.data.ExcelApplicationTests;
// import net.javabeat.spring.data.domain.ShareItem;
// import net.javabeat.spring.data.domain.SharedItem;
// import org.junit.Test;
// import org.junit.runner.RunWith;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.boot.test.SpringApplicationConfiguration;
// import org.springframework.data.domain.Page;
// import org.springframework.data.domain.PageRequest;
// import org.springframework.stereotype.Controller;
// import org.springframework.test.context.ActiveProfiles;
// import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
// import org.springframework.transaction.annotation.Transactional;
// //import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;


// import static org.hamcrest.Matchers.is;
// import static org.junit.Assert.assertThat;

// @RunWith(SpringJUnit4ClassRunner.class)
// @SpringApplicationConfiguration(Application.class)
// @ActiveProfiles("dev")
// public class SharedItemServiceTests {

// 	@SuppressWarnings("SpringJavaAutowiringInspection")
// 	@Autowired
// 	SharedItemService sharedItemService;


// 	@Test
// 	public void findsAll() {
// 		SharedItem s = sharedItemService.findAll().get(0);
// 		assertThat(s.getTemplateId(), is("1000"));

// 	}

// }
