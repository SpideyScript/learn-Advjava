package com.example;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class App {

    public static void main(String[] args) {

        SessionFactory factory = new Configuration()
                .configure()
                .addAnnotatedClass(User.class)
                .addAnnotatedClass(Book.class)
                .addAnnotatedClass(Issue.class)
                .buildSessionFactory();

        Session session = factory.openSession();

        try {

            // CREATE
            session.beginTransaction();

            User user = new User("Anshu");
            Book book = new Book("Java Programming", "James Gosling");

            session.save(user);
            session.save(book);

            Issue issue = new Issue("2026-03-14", user, book);
            session.save(issue);

            session.getTransaction().commit();

            // READ
            session.beginTransaction();

            User u = session.get(User.class, 1);
            System.out.println("User: " + u.getName());

            session.getTransaction().commit();

            // UPDATE
            session.beginTransaction();

            Book b = session.get(Book.class, 1);
            b.setTitle("Advanced Java");

            session.update(b);

            session.getTransaction().commit();

            // DELETE
            session.beginTransaction();

            Issue i = session.get(Issue.class, 1);
            session.delete(i);

            session.getTransaction().commit();

        } finally {
            session.close();
            factory.close();
        }
    }
}