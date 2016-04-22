package com.xht.myApp.service;

import com.xht.myApp.Application;
import com.xht.myApp.domain.Book;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;

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

    @SuppressWarnings("SpringJavaAutowiringInspection")

    @Resource(name = "maleStudent")
    StudentService studentService;

    @Test
    public void testBeanInject() {
        studentService.sayHi();
    }

    @Test
    public void findsAll2() {
        Book b = bookService.findAll().get(0);
        assertThat(b.getName(), is("xxx"));
    }

}
