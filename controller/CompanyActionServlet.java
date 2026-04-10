package com.smartplacement.controller;

import com.smartplacement.dao.ApplicationDAO;
import com.smartplacement.dao.CompanyDAO;
import com.smartplacement.dao.JobDriveDAO;
import com.smartplacement.dao.NotificationDAO;
import com.smartplacement.dao.StudentDAO;
import com.smartplacement.model.Application;
import com.smartplacement.model.Company;
import com.smartplacement.model.JobDrive;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/companyAction")
public class CompanyActionServlet extends HttpServlet {

    // ------------------------------------------------------------------ //
    //  POST: addDrive, updateStatus
    // ------------------------------------------------------------------ //
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Company company = (Company) session.getAttribute("userObj");

        if (company == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if ("addDrive".equals(action)) {
            try {
                JobDrive d = new JobDrive();
                d.setCompanyId(company.getId());
                d.setJobRole(request.getParameter("jobRole").trim());
                d.setDescription(request.getParameter("description").trim());
                d.setEligibilityCgpa(Double.parseDouble(request.getParameter("cgpa")));
                d.setEligibleBranches(request.getParameter("branches").trim());
                d.setLastDate(Date.valueOf(request.getParameter("lastDate")));
                d.setDriveDate(Date.valueOf(request.getParameter("driveDate")));
                d.setSalaryPackage(request.getParameter("salary").trim());
                d.setLocation(request.getParameter("location").trim());

                JobDriveDAO jDao = new JobDriveDAO();
                if (jDao.addJobDrive(d)) {
                    session.setAttribute("msg", "Job Drive posted successfully! Eligible students have been notified.");
                } else {
                    session.setAttribute("error", "Failed to post Job Drive. Please try again.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Invalid data: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/company/manage_drives.jsp");

        } else if ("updateStatus".equals(action)) {
            try {
                int appId = Integer.parseInt(request.getParameter("appId"));
                String status = request.getParameter("status");

                ApplicationDAO appDao = new ApplicationDAO();
                Application app = appDao.getApplicationById(appId);

                if (appDao.updateStatus(appId, status)) {
                    // Notify the student
                    if (app != null) {
                        new NotificationDAO().addNotification(app.getStudentId(),
                            "Your application status has been updated to: " + status +
                            " by " + company.getCompanyName());
                    }
                    session.setAttribute("msg", "Status updated to " + status + " successfully.");
                } else {
                    session.setAttribute("error", "Failed to update status.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Error updating status.");
            }
            response.sendRedirect(request.getContextPath() + "/company/applications.jsp");
        }
    }

    // ------------------------------------------------------------------ //
    //  GET: deleteDrive, shortlist, reject, select, publishResults
    // ------------------------------------------------------------------ //
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Company company = (Company) session.getAttribute("userObj");

        if (company == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if ("deleteDrive".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                JobDriveDAO jDao = new JobDriveDAO();
                if (jDao.deleteDrive(id)) {
                    session.setAttribute("msg", "Drive removed successfully.");
                } else {
                    session.setAttribute("error", "Failed to remove drive.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Invalid drive ID.");
            }
            response.sendRedirect(request.getContextPath() + "/company/manage_drives.jsp");

        } else if ("shortlist".equals(action)) {
            updateApplicationStatus(request, response, session, company, "SHORTLISTED",
                                    "/company/applications.jsp");

        } else if ("reject".equals(action)) {
            updateApplicationStatus(request, response, session, company, "REJECTED",
                                    "/company/applications.jsp");

        } else if ("select".equals(action)) {
            updateApplicationStatus(request, response, session, company, "SELECTED",
                                    "/company/results.jsp");

        } else if ("publishResults".equals(action)) {
            // Mark all SHORTLISTED applications of this company as SELECTED
            try {
                ApplicationDAO appDao = new ApplicationDAO();
                List<Application> apps = appDao.getApplicationsByCompany(company.getId());
                NotificationDAO nDao = new NotificationDAO();
                int count = 0;
                for (Application app : apps) {
                    if ("SHORTLISTED".equalsIgnoreCase(app.getStatus())) {
                        if (appDao.updateStatus(app.getId(), "SELECTED")) {
                            nDao.addNotification(app.getStudentId(),
                                "🎉 Congratulations! You have been SELECTED by " + company.getCompanyName() + "!");
                            count++;
                        }
                    }
                }
                session.setAttribute("msg", "Results published! " + count + " student(s) have been selected and notified.");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Failed to publish results.");
            }
            response.sendRedirect(request.getContextPath() + "/company/results.jsp");

        } else {
            response.sendRedirect(request.getContextPath() + "/companyDashboard");
        }
    }

    // ------------------------------------------------------------------ //
    //  HELPER: update application status by studentId + driveId
    // ------------------------------------------------------------------ //
    private void updateApplicationStatus(HttpServletRequest request, HttpServletResponse response,
                                         HttpSession session, Company company,
                                         String newStatus, String redirect) throws IOException {
        try {
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            String driveIdParam = request.getParameter("driveId");

            ApplicationDAO appDao = new ApplicationDAO();
            NotificationDAO nDao = new NotificationDAO();
            boolean updated = false;

            if (driveIdParam != null && !driveIdParam.isEmpty()) {
                int driveId = Integer.parseInt(driveIdParam);
                Application app = appDao.getApplicationByStudentAndDrive(studentId, driveId);
                if (app != null) {
                    updated = appDao.updateStatus(app.getId(), newStatus);
                    if (updated) {
                        String msg = buildNotificationMessage(newStatus, company.getCompanyName());
                        nDao.addNotification(studentId, msg);
                    }
                }
            } else {
                // Update all applications of this student in company drives
                List<Application> apps = appDao.getApplicationsByStudent(studentId);
                for (Application app : apps) {
                    if (appDao.updateStatus(app.getId(), newStatus)) {
                        updated = true;
                        nDao.addNotification(studentId,
                            buildNotificationMessage(newStatus, company.getCompanyName()));
                    }
                }
            }

            if (updated) {
                session.setAttribute("msg", "Candidate status updated to " + newStatus + ".");
            } else {
                session.setAttribute("error", "Could not find or update the application.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + redirect);
    }

    private String buildNotificationMessage(String status, String companyName) {
        switch (status) {
            case "SHORTLISTED": return "You have been Shortlisted by " + companyName + ". Watch for further updates!";
            case "SELECTED":    return "🎉 Congratulations! You have been Selected by " + companyName + "!";
            case "REJECTED":    return "Thank you for applying to " + companyName + ". Unfortunately, you were not selected this time.";
            default:            return "Your application status has been updated to " + status + " by " + companyName + ".";
        }
    }
}
