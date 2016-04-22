 package com.xht.myApp.service;

 import com.xht.myApp.Application;
 import com.xht.myApp.MyApplicationTests;
 import com.xht.myApp.domain.Book;
 import org.junit.Test;
 import org.junit.runner.RunWith;
 import org.springframework.beans.factory.annotation.Autowired;
 import org.springframework.boot.test.SpringApplicationConfiguration;
 import org.springframework.test.context.ActiveProfiles;
 import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

 import static org.hamcrest.Matchers.is;
 import static org.junit.Assert.assertThat;

//import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

 @RunWith(SpringJUnit4ClassRunner.class)
 @SpringApplicationConfiguration(Application.class)
 @ActiveProfiles("dev")
 public class MyServiceTests {

 	@SuppressWarnings("SpringJavaAutowiringInspection")
 	@Autowired
    BookService bookService;


 	@Test
 	public void findsAll() {
 		Book b = bookService.findAll().get(0);
 		assertThat(b.getName(), is("xxx"));
 	}

 }
