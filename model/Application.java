package com.smartplacement.model;

import java.sql.Timestamp;

public class Application {
    private int id;
    private int studentId;
    private int driveId;
    private String status;
    private Timestamp applyDate;

    // UI display / join helper fields
    private String studentName;
    private String companyName;
    private String jobRole;
    private String studentResume;
    private String branch;
    private String salaryPackage;
    private double studentCgpa;
    private String studentEmail;

    // ------------------------------------------------------------------ //
    //  Getters & Setters
    // ------------------------------------------------------------------ //
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getDriveId() { return driveId; }
    public void setDriveId(int driveId) { this.driveId = driveId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getApplyDate() { return applyDate; }
    public void setApplyDate(Timestamp applyDate) { this.applyDate = applyDate; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getJobRole() { return jobRole; }
    public void setJobRole(String jobRole) { this.jobRole = jobRole; }

    public String getStudentResume() { return studentResume; }
    public void setStudentResume(String studentResume) { this.studentResume = studentResume; }

    public String getBranch() { return branch; }
    public void setBranch(String branch) { this.branch = branch; }

    public String getSalaryPackage() { return salaryPackage; }
    public void setSalaryPackage(String salaryPackage) { this.salaryPackage = salaryPackage; }

    public double getStudentCgpa() { return studentCgpa; }
    public void setStudentCgpa(double studentCgpa) { this.studentCgpa = studentCgpa; }

    public String getStudentEmail() { return studentEmail; }
    public void setStudentEmail(String studentEmail) { this.studentEmail = studentEmail; }
}
