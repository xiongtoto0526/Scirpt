package net.javabeat.spring.data.service;

import java.util.List;

import org.springframework.data.repository.Repository;

import net.javabeat.spring.data.domain.Book;

public interface BookNamedQueryRepositoryExample extends Repository<Book, Long> {
	// Query will be used from Named query defined at Entity class
	List<Book> findByPrice(long price);
}
