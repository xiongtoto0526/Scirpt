package net.javabeat.spring.data.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.tomcat.jni.File;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import net.javabeat.spring.data.domain.Book;
import net.javabeat.spring.data.service.BookService;

@RestController
@RequestMapping(value = "/books")
public class BooksController {
	@Autowired
	private BookService bookService;

	@Autowired
	private net.javabeat.spring.data.service.ExcelService excelService;
	
	@RequestMapping(value = "/add/{id}/{name}/{author}/{price}")
	public Book addBook(@PathVariable int id, @PathVariable String name, @PathVariable String author,
			@PathVariable long price) {
		Book book = new Book();
		book.setId(id);
		book.setName(name);
		book.setAuthor(author);
		book.setPrice(price);
		bookService.saveBook(book);
		return book;
	}
	@RequestMapping(value = "/delete/{id}")
	public void deleteBook(@PathVariable int id) {
		Book book = new Book();
		book.setId(id);
		bookService.delete(id);
	}
	@RequestMapping(value = "/")
	public List<Book> getBooks() {
		return bookService.findAll();
	}
	@RequestMapping(value = "/{id}")
	public Book getBook(@PathVariable int id) {
		Book book = bookService.findOne(id);
		return book;
	}
	@RequestMapping(value = "/search/name/{name}")
	public List<Book> getBookByName(@PathVariable String name) {
		List<Book> books = bookService.findByName(name);
		return books;
	}
	@RequestMapping(value = "/search/name/match/{name}")
	public List<Book> getBookByNameMatch(@PathVariable String name) {
		List<Book> books = bookService.findByNameMatch(name);
		return books;
	}
	@RequestMapping(value = "/search/param/{name}/{author}/{price}")
	public List<Book> getBookByNamedParam(@PathVariable String name, @PathVariable String author, @PathVariable long price) {
		List<Book> books = bookService.findByNamedParam(name, author, price);
		return books;
	}
	
	@RequestMapping(value = "/search/price/{price}")
	public List<Book> getBookByPrice(@PathVariable int price) {
		List<Book> books = bookService.findByPrice(price);
		return books;
	}
	@RequestMapping(value = "/search/price/{price1}/{price2}")
	public List<Book> getBookByPriceRange(@PathVariable int price1, @PathVariable int price2) {
		List<Book> books = bookService.findByPriceRange(price1, price2);
		return books;
	}
	@RequestMapping(value = "/search/{name}/{author}")
	public List<Book> getBookByNameAndAuthor(@PathVariable String name, @PathVariable String author) {
		List<Book> books = bookService.findByNameAndAuthor(name, author);
		return books;
	}
	
	@RequestMapping(value = "/find/page/test")
	public String findByPage() {
		bookService.findAllByPage(null);
		return "page ok";
	}
	
	@RequestMapping(value = "/insert/test")
	public String insert() {
		Book book = new Book();
		book.setId(100);
		book.setName("xht");
		book.setAuthor("han-han");
		book.setPrice(100);
		bookService.insert(book);
		return "insert ok";
	}
	
	@RequestMapping(value = "/batchInsert/test")
	public String batchInsert() {
		List<Book> books = new ArrayList<Book>();
		for (int i = 101; i < 107; i++) {
			Book book = new Book();
			book.setId(i);
			book.setName("xht"+i);
			book.setAuthor("han-han"+i);
			book.setPrice(i);
			books.add(book);
		}
		bookService.batchInsert(books);
		return "batch insert ok";
	}
	
	@RequestMapping(value = "/excelinsert/test")
	public String excelinsert() throws IOException {
		java.io.File excelFile = new java.io.File("student_info.xls");
		excelService.readExcel(excelFile);
		return "excel insert ok";
	}
	
}
