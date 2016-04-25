package com.xht.myApp.service;

import com.xht.myApp.Application;
import com.xht.myApp.domain.Book;
import com.xht.myApp.repository.BookRepository;
import com.xht.myApp.repository.NOName;
import com.xht.myApp.utils.CustomerSpec;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;

import java.util.Arrays;
import java.util.List;

import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;

//import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(Application.class)
@ActiveProfiles("dev")
@SuppressWarnings("SpringJavaAutowiringInspection")

public class MyServiceTests {

    @Autowired
    BookService bookService;

    @Autowired
    BookRepository bookRepository;

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

    @Test
    public void findbyIdProjectionTest() {
//        NOName b = bookService.findById(2);
//        System.out.println(b.getAuthor());
    }

    @Test
    public void specQueryTest() {
        String[] names = {"Spring Book", "Hibernat in Action"};
        List<Book> bookList = bookRepository.findAll(CustomerSpec.customerIsInList(Arrays.asList(names)));
        assertThat(bookList.size(), is(2));
    }
}
