package com.library;

import java.util.Scanner;

public class LibraryApp {

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);

        LibraryService service = new LibraryService();

        while (true) {

            System.out.println("\n==== LIBRARY SYSTEM ====");
            System.out.println("1 Search Book by Title");
            System.out.println("2 Search Book by Author");
            System.out.println("3 Search Book by Year");
            System.out.println("4 Add Book");
            System.out.println("5 Update Book");
            System.out.println("6 Delete Book");
            System.out.println("7 Exit");

            int choice = sc.nextInt();
            sc.nextLine();

            switch (choice) {

                case 1:
                    System.out.println("Enter title:");
                    service.searchTitle(sc.nextLine());
                    break;

                case 2:
                    System.out.println("Enter author:");
                    service.searchAuthor(sc.nextLine());
                    break;

                case 3:
                    System.out.println("Enter year:");
                    service.searchYear(sc.nextInt());
                    break;

                case 4:

                    System.out.println("Title:");
                    String title = sc.nextLine();

                    System.out.println("Author:");
                    String author = sc.nextLine();

                    System.out.println("Publisher:");
                    String publisher = sc.nextLine();

                    System.out.println("Year:");
                    int year = sc.nextInt();

                    service.addBook(title, author, publisher, year);
                    break;

                case 5:

                    System.out.println("Enter book ID:");
                    int id = sc.nextInt();
                    sc.nextLine();

                    System.out.println("New Title:");
                    String newTitle = sc.nextLine();

                    service.updateBook(id, newTitle);
                    break;

                case 6:

                    System.out.println("Enter book ID:");
                    service.deleteBook(sc.nextInt());
                    break;

                case 7:
                    System.exit(0);

                default:
                    System.out.println("Invalid choice");
            }
        }
    }
}