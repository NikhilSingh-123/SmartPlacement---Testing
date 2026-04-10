package com.smartplacement.controller;

import com.smartplacement.dao.ApplicationDAO;
import com.smartplacement.dao.CompanyDAO;
import com.smartplacement.dao.JobDriveDAO;
import com.smartplacement.dao.NotificationDAO;
import com.smartplacement.dao.StudentDAO;
import com.smartplacement.model.Company;
import com.smartplacement.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/adminAction")
@javax.servlet.annotation.MultipartConfig
public class AdminActionServlet extends HttpServlet {

    // ------------------------------------------------------------------ //
    //  POST: addCompany
    // ------------------------------------------------------------------ //
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("userObj") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("addCompany".equals(action)) {
            try {
                Company c = new Company();
                c.setCompanyName(request.getParameter("companyName").trim());
                c.setEmail(request.getParameter("email").trim());
                c.setPassword(request.getParameter("email").trim());
                c.setWebsite(request.getParameter("website") != null ? request.getParameter("website").trim() : "");
                c.setDescription(request.getParameter("description") != null ? request.getParameter("description").trim() : "");
                c.setContactNumber(request.getParameter("contactPerson") != null ? request.getParameter("contactPerson").trim() : "");

                // Handle Logo Upload
                Part filePart = request.getPart("logo");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);
                    String relativePath = "uploads/logos/" + fileName;
                    String savePath = getServletContext().getRealPath("/") + relativePath;
                    
                    File fileSaveDir = new File(savePath).getParentFile();
                    if (!fileSaveDir.exists()) fileSaveDir.mkdirs();
                    
                    filePart.write(savePath);
                    c.setLogo(relativePath);
                }

                CompanyDAO cDao = new CompanyDAO();
                if (cDao.registerCompany(c)) {
                    session.setAttribute("msg", "Company '" + c.getCompanyName() + "' added successfully.");
                } else {
                    session.setAttribute("error", "Failed to add company. Email may already exist.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Error adding company: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/admin/manage_companies.jsp");
        }
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "default.png";
    }

    // ------------------------------------------------------------------ //
    //  GET: deleteCompany, deleteDrive, updateStudentStatus
    // ------------------------------------------------------------------ //
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if (session.getAttribute("userObj") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if ("deleteCompany".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                CompanyDAO cDao = new CompanyDAO();
                if (cDao.deleteCompany(id)) {
                    session.setAttribute("msg", "Company removed from system.");
                } else {
                    session.setAttribute("error", "Failed to remove company.");
                }
            } catch (Exception e) {
                session.setAttribute("error", "Invalid company ID.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/manage_companies.jsp");

        } else if ("deleteDrive".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                JobDriveDAO jDao = new JobDriveDAO();
                if (jDao.deleteDrive(id)) {
                    session.setAttribute("msg", "Drive removed successfully.");
                } else {
                    session.setAttribute("error", "Failed to remove drive.");
                }
            } catch (Exception e) {
                session.setAttribute("error", "Invalid drive ID.");
            }
            response.sendRedirect(request.getContextPath() + "/admin/manage_drives.jsp");

        } else if ("updateStudentStatus".equals(action)) {
            try {
                int studentId  = Integer.parseInt(request.getParameter("id"));
                String status  = request.getParameter("status");

                // Validate allowed status values
                if (!status.equals("SELECTED") && !status.equals("REJECTED") &&
                    !status.equals("SHORTLISTED") && !status.equals("APPLIED")) {
                    session.setAttribute("error", "Invalid status value.");
                    response.sendRedirect(request.getContextPath() + "/admin/applications.jsp");
                    return;
                }

                StudentDAO sDao   = new StudentDAO();
                ApplicationDAO aDao = new ApplicationDAO();
                Student student   = sDao.getStudentById(studentId);

                // Update all pending applications for this student to the new status
                boolean updated = false;
                for (var app : aDao.getApplicationsByStudent(studentId)) {
                    if (aDao.updateStatus(app.getId(), status)) updated = true;
                }

                // Also update the student's own status field for quick display
                sDao.updateStatus(studentId, status);

                if (updated) {
                    // Notify student
                    String name = student != null ? student.getName() : "Student";
                    new NotificationDAO().addNotification(studentId,
                        "Admin has updated your placement status to: " + status);
                    session.setAttribute("msg", name + "'s status updated to " + status + ".");
                } else {
                    session.setAttribute("error", "No applications found for this student to update.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("error", "Error updating status: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/admin/applications.jsp");

        } else {
            response.sendRedirect(request.getContextPath() + "/adminDashboard");
        }
    }
}
