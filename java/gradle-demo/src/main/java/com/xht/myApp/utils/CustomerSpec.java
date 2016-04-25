package com.xht.myApp.utils;

import com.xht.myApp.domain.Book;
import org.springframework.data.jpa.domain.Specification;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Created by xionghaitao on 16/4/25.
 */
public class CustomerSpec {


    public static Specification<Book> customerIsInList(List<String> names) {
        return new Specification<Book>() {
            public Predicate toPredicate (Root<Book> root, CriteriaQuery<?> query, CriteriaBuilder cb){
                List<Predicate> list = new ArrayList<Predicate>();

//                list.add(cb.like(root.get("name").as(String.class), "%"+name+"%"));
//                list.add(cb.equal(root.get("name").as(String.class), names[0]));
                list.add(root.get("name").in(names));
                Predicate[] p = new Predicate[list.size()];
                return cb.or(list.toArray(p));
            }
        } ;
    }




}
