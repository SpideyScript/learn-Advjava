package com.library;


import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class BookDAO {

public void addBook(Book book){

Session session = HibernateUtil.getSessionFactory().openSession();
Transaction tx = session.beginTransaction();

session.save(book);

tx.commit();
session.close();
}

public List<Book> searchByTitle(String title){

Session session = HibernateUtil.getSessionFactory().openSession();

String hql = "FROM Book WHERE title LIKE :title";

Query<Book> query = session.createQuery(hql,Book.class);
query.setParameter("title","%"+title+"%");

List<Book> list = query.list();
session.close();

return list;
}

public List<Book> searchByAuthor(String author){

Session session = HibernateUtil.getSessionFactory().openSession();

String hql="FROM Book WHERE author LIKE :author";

Query<Book> query = session.createQuery(hql,Book.class);
query.setParameter("author","%"+author+"%");

List<Book> list=query.list();

session.close();

return list;
}

public List<Book> searchByYear(int year){

Session session = HibernateUtil.getSessionFactory().openSession();

String hql="FROM Book WHERE year = :year";

Query<Book> query = session.createQuery(hql,Book.class);
query.setParameter("year",year);

List<Book> list=query.list();

session.close();

return list;
}

public void deleteBook(int id){

Session session = HibernateUtil.getSessionFactory().openSession();
Transaction tx = session.beginTransaction();

String hql="DELETE FROM Book WHERE id = :id";

Query query = session.createQuery(hql);
query.setParameter("id",id);
query.executeUpdate();

tx.commit();
session.close();
}

public void updateBook(int id,String newTitle){

Session session = HibernateUtil.getSessionFactory().openSession();
Transaction tx = session.beginTransaction();

String hql="UPDATE Book SET title = :title WHERE id = :id";

Query query = session.createQuery(hql);
query.setParameter("title",newTitle);
query.setParameter("id",id);

query.executeUpdate();

tx.commit();
session.close();
}
}