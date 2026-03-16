package com.example;

import javax.persistence.*;

@Entity
@Table(name="issues")
public class Issue {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="issue_id")
    private int issueId;

    @ManyToOne
    @JoinColumn(name="user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name="book_id")
    private Book book;

    @Column(name="issue_date")
    private String issueDate;

    public Issue(){}

    public Issue(String issueDate,User user,Book book){
        this.issueDate=issueDate;
        this.user=user;
        this.book=book;
    }

    public int getIssueId(){
        return issueId;
    }

    public String getIssueDate(){
        return issueDate;
    }
}