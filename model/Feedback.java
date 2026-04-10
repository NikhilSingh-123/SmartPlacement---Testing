package com.smartplacement.model;

import java.sql.Timestamp;

public class Feedback {
    private int id;
    private int studentId;
    private String subject;
    private String message;
    private Timestamp submitDate;
    
    // UI Helper
    private String studentName;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public Timestamp getSubmitDate() { return submitDate; }
    public void setSubmitDate(Timestamp submitDate) { this.submitDate = submitDate; }
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
}
