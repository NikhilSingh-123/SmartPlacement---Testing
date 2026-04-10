package com.smartplacement.model;

import java.sql.Date;

public class JobDrive {
    private int id;
    private int companyId;
    private String jobRole;
    private String description;
    private double eligibilityCgpa;
    private String eligibleBranches;
    private Date lastDate;
    private Date driveDate;
    private String salaryPackage;
    private String location;
    
    // Additional field for UI convenience
    private String companyName;
    private String companyLogo;
    private boolean applied;

    public boolean isApplied() { return applied; }
    public void setApplied(boolean applied) { this.applied = applied; }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getCompanyId() { return companyId; }
    public void setCompanyId(int companyId) { this.companyId = companyId; }
    public String getJobRole() { return jobRole; }
    public void setJobRole(String jobRole) { this.jobRole = jobRole; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public double getEligibilityCgpa() { return eligibilityCgpa; }
    public void setEligibilityCgpa(double eligibilityCgpa) { this.eligibilityCgpa = eligibilityCgpa; }
    public String getEligibleBranches() { return eligibleBranches; }
    public void setEligibleBranches(String eligibleBranches) { this.eligibleBranches = eligibleBranches; }
    public Date getLastDate() { return lastDate; }
    public void setLastDate(Date lastDate) { this.lastDate = lastDate; }
    public Date getDriveDate() { return driveDate; }
    public void setDriveDate(Date driveDate) { this.driveDate = driveDate; }
    public String getSalaryPackage() { return salaryPackage; }
    public void setSalaryPackage(String salaryPackage) { this.salaryPackage = salaryPackage; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
    public String getCompanyLogo() { return companyLogo; }
    public void setCompanyLogo(String companyLogo) { this.companyLogo = companyLogo; }
}
