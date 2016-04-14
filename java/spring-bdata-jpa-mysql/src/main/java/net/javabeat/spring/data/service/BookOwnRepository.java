package net.javabeat.spring.data.service;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.Repository;

import net.javabeat.spring.data.domain.Book;



public interface BookOwnRepository extends Repository<Book,Long>{
	@Query(value="select author from Book b where b.author=?1")
	List<Book> findByName(String name);
	
	
	// 根据命名来查找，name,author 是列名称， and, or,是关键字
	// 详细的关键字可参考：http://blog.sina.com.cn/s/blog_667ac0360102ecsf.html
	List<Book> findByNameAndAuthor(String name, String author);
}
