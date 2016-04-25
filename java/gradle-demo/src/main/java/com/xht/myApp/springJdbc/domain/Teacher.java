package com.xht.myApp.springJdbc.domain;

/**
 * Created by xionghaitao on 16/4/25.
 */
public class Teacher {

    private String id;
    private String name;
    private Float score;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Float getScore() {
        return score;
    }

    public void setScore(Float score) {
        this.score = score;
    }
}
