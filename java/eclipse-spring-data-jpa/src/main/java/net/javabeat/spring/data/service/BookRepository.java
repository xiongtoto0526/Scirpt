package net.javabeat.spring.data.service;

import org.springframework.data.jpa.repository.JpaRepository;

import net.javabeat.spring.data.domain.Book;

public interface BookRepository extends JpaRepository<Book,Long> {

}
