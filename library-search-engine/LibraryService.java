package com.library;



import java.util.List;

public class LibraryService {

BookDAO dao = new BookDAO();

public void displayBooks(List<Book> books){

if(books.isEmpty()){
System.out.println("No books found");
return;
}

for(Book b:books){

System.out.println("---------------");
System.out.println("ID: "+b.getId());
System.out.println("Title: "+b.getTitle());
System.out.println("Author: "+b.getAuthor());
System.out.println("Publisher: "+b.getPublisher());
System.out.println("Year: "+b.getYear());
}
}

public void addBook(String title,String author,String publisher,int year){

Book book=new Book(title,author,publisher,year);

dao.addBook(book);

System.out.println("Book Added Successfully");
}

public void searchTitle(String title){
displayBooks(dao.searchByTitle(title));
}

public void searchAuthor(String author){
displayBooks(dao.searchByAuthor(author));
}

public void searchYear(int year){
displayBooks(dao.searchByYear(year));
}

public void deleteBook(int id){
dao.deleteBook(id);
System.out.println("Book deleted");
}

public void updateBook(int id,String title){
dao.updateBook(id,title);
System.out.println("Book updated");
}
}