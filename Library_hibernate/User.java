package com.example;

import javax.persistence.*;
@Entity
@Table(name="users")
public class User {

   @Id
   @GeneratedValue(strategy = GenerationType.IDENTITY)
   @Column(name="user_id")
   private int id;

   private String name;

   public User(){}

   public User(String name){
       this.name=name;
   }

   public int getId(){
       return id;
   }

   public String getName(){
       return name;
   }

   public void setName(String name){
       this.name=name;
   }
}