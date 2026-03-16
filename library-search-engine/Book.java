package com.library;

import javax.persistence.*;

@Entity
@Table(name="books")
public class Book {

@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
private int id;

private String title;
private String author;
private String publisher;
private int year;

public Book(){}

public Book(String title,String author,String publisher,int year){
this.title=title;
this.author=author;
this.publisher=publisher;
this.year=year;
}

public int getId(){ return id; }

public String getTitle(){ return title; }
public void setTitle(String title){ this.title=title; }

public String getAuthor(){ return author; }
public void setAuthor(String author){ this.author=author; }

public String getPublisher(){ return publisher; }
public void setPublisher(String publisher){ this.publisher=publisher; }

public int getYear(){ return year; }
public void setYear(int year){ this.year=year; }
}