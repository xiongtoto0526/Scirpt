package net.javabeat.spring.data.service;

import java.util.List;

import javax.persistence.NamedQuery;

import org.springframework.data.repository.Repository;

import net.javabeat.spring.data.domain.Book;


// 需要在实体中使用@NamedQuery，定义具体的query实现
public interface BookNamedQueryRepositoryExample extends Repository<Book, Long> {
	// Query will be used from Named query defined at Entity class
	List<Book> findByPrice(long price);
}
