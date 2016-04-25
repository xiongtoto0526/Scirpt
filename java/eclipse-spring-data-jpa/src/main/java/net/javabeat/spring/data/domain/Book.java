package net.javabeat.spring.data.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQuery;

@Entity
@NamedQuery(name="Book.findByPrice",query="select name,author,price from Book b where b.price=?1")
public class Book implements Serializable{
	private static final long serialVersionUID = 1L;
	@Id
	long id;
	@Column(name="name")
	String name;
	@Column(name="author")
	String author;
	@Column(name="price")
	long price;	
	public String getAuthor() {
		return author;
	}
	public void setAuthor(String author) {
		this.author = author;
	}
	public long getPrice() {
		return price;
	}
	public void setPrice(long price) {
		this.price = price;
	}	
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}	
}
