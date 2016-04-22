package com.xht.myApp.repository;

import java.util.List;

import com.xht.myApp.domain.Book;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.Repository;




public interface BookOwnRepository extends Repository<Book,Long>{
	@Query(value="select author from Book b where b.author=?1")
	List<Book> findByName(String name);
	
//	 <T> Page<T> findAll(Pageable pageable);

	// 根据命名来查找，name,author 是列名称， and, or,是关键字
	// 详细的关键字可参考：http://blog.sina.com.cn/s/blog_667ac0360102ecsf.html
	List<Book> findByNameAndAuthor(String name, String author);
}
