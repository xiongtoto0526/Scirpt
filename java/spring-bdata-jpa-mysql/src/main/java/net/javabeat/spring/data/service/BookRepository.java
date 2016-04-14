package net.javabeat.spring.data.service;

import org.springframework.data.jpa.repository.JpaRepository;

import net.javabeat.spring.data.domain.Book;

public interface BookRepository extends JpaRepository<Book,Long> {

/* 只要继承了JpaRepository，以下方法将自动生成，无需再写接口。
 原因：JpaRepository继承自crudRepository, 其所有自实现的方法在此均可直接使用
*/
	
//	T findOne(ID primaryKey)
//	Iterable findAll()
//	Long count()
//	void delete(T entity)
//	boolean exists(ID primaryKey)
// ...
	
}
