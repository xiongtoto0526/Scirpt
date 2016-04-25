package com.xht.myApp.repository;

import com.xht.myApp.domain.Book;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.CrudRepository;

import java.util.List;


public interface BookRepository extends JpaRepository<Book,Long> ,JpaSpecificationExecutor {

/* 只要继承了JpaRepository，以下方法将自动生成，无需再写接口。
 原因：JpaRepository继承自crudRepository, 其所有自实现的方法在此均可直接使用
*/
	
//	T findOne(ID primaryKey)
//	Iterable findAll()
//	Long count()
//	void delete(T entity)
//	boolean exists(ID primaryKey)
// ...
    List<NOName> findById(long id);
}
