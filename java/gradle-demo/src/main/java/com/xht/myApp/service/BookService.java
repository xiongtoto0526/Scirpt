package com.xht.myApp.service;

import java.util.List;

import com.xht.myApp.domain.Book;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;


public interface BookService {
	public List<Book> findAll();
	public void saveBook(Book book);
	
	@Cacheable ("books")
	public Book findOne(long id);
	public void delete(long id);
	public List<Book> findByName(String name);
	public List<Book> findByNameAndAuthor(String name, String author);
	public List<Book> findByPrice(long price);
	List<Book> findByPriceRange(long price1, long price2);
	List<Book> findByNameMatch(String name);
	List<Book> findByNamedParam(String name, String author, long price);
	public Page<Book> findAllByPage(PageRequest request);
	public void insert(Book book) ;
	public void batchInsert(List<Book> books) ;

}
