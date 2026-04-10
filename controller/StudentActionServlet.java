package com.smartplacement.controller;

import com.smartplacement.dao.ApplicationDAO;
import com.smartplacement.dao.StudentDAO;
import com.smartplacement.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/studentAction")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class StudentActionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Student student = (Student) session.getAttribute("userObj");

        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        StudentDAO sDao = new StudentDAO();

        if ("updateProfile".equals(action)) {
            student.setName(request.getParameter("name"));
            student.setContactNumber(request.getParameter("contact"));
            student.setBranch(request.getParameter("branch"));
            student.setCgpa(Double.parseDouble(request.getParameter("cgpa")));

            if (sDao.updateProfile(student)) {
                session.setAttribute("succMsg", "Profile updated successfully!");
            } else {
                session.setAttribute("errorMsg", "Failed to update profile.");
            }
            response.sendRedirect(request.getContextPath() + "/student/profile.jsp");

        } else if ("uploadResume".equals(action)) {
            Part part = request.getPart("resume");
            if (part != null && part.getSize() > 0) {
                String fileName = "resume_" + student.getId() + "_" + System.currentTimeMillis() + ".pdf";
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();

                part.write(uploadPath + File.separator + fileName);
                
                if (sDao.updateResumePath(student.getId(), "uploads/" + fileName)) {
                    student.setResumePath("uploads/" + fileName);
                    session.setAttribute("succMsg", "Resume uploaded successfully!");
                } else {
                    session.setAttribute("errorMsg", "Failed to save resume path.");
                }
            }
            response.sendRedirect("student/profile.jsp");
        } else if ("markNotificationsRead".equals(action)) {
            new com.smartplacement.dao.NotificationDAO().markAsRead(student.getId());
            response.sendRedirect(request.getContextPath() + "/student/notifications.jsp");
        } else if ("submitFeedback".equals(action)) {
            String subject = request.getParameter("subject");
            String message = request.getParameter("message");
            com.smartplacement.model.Feedback feedback = new com.smartplacement.model.Feedback();
            feedback.setStudentId(student.getId());
            feedback.setSubject(subject);
            feedback.setMessage(message);
            
            if (new com.smartplacement.dao.FeedbackDAO().submitFeedback(feedback)) {
                session.setAttribute("succMsg", "Thank you for your feedback!");
            } else {
                session.setAttribute("errorMsg", "Failed to submit feedback.");
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Student student = (Student) session.getAttribute("userObj");

        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if ("applyJob".equals(action)) {
            int driveId = Integer.parseInt(request.getParameter("driveId"));
            ApplicationDAO appDao = new ApplicationDAO();
            if (appDao.applyForJob(student.getId(), driveId)) {
                session.setAttribute("succMsg", "Applied successfully!");
            } else {
                session.setAttribute("errorMsg", "You have already applied or an error occurred.");
            }
            response.sendRedirect("student/jobs.jsp");
        } else if ("saveJob".equals(action)) {
            int driveId = Integer.parseInt(request.getParameter("driveId"));
            if (new com.smartplacement.dao.SavedJobDAO().saveJob(student.getId(), driveId)) {
                session.setAttribute("succMsg", "Job bookmarked.");
            }
            response.sendRedirect("student/jobs.jsp");
        } else if ("removeSavedJob".equals(action)) {
            int driveId = Integer.parseInt(request.getParameter("driveId"));
            new com.smartplacement.dao.SavedJobDAO().removeSavedJob(student.getId(), driveId);
            response.sendRedirect(request.getContextPath() + "/student/saved_jobs.jsp");
        }
    }
}
