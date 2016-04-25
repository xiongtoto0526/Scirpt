package com.xht.myApp.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import java.io.Serializable;

@Entity
@NamedQuery(name = "Book.findByPrice", query = "select name,author,price from Book b where b.price=?1")
public class Book implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    long id;
    @Column(name = "name")
    String name;
    @Column(name = "author")
    String author;
    @Column(name = "price")
    long price;

//    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME,pattern = "yyyy-MM-dd HH:mm:ss")

    //	@Type(type="yes_no")  // 使用注解方式,标注type,入库时将使用Yes/NO入库.
    //	@Column(columnDefinition = "default 'N'") // 使用注解方式,标注type列的默认值.
    //	private boolean isValid = false;


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
