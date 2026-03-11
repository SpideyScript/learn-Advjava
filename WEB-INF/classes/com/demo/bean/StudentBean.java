package com.demo.bean;

import java.io.Serializable;

public class StudentBean implements Serializable {

    private String name;
    private int age;

    public StudentBean() {
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public int getAge() {
        return age;
    }
}