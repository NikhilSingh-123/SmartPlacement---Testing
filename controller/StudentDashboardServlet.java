package com.smartplacement.controller;

import com.smartplacement.dao.AnalyticsDAO;
import com.smartplacement.dao.JobDriveDAO;
import com.smartplacement.model.JobDrive;
import com.smartplacement.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/studentDashboard")
public class StudentDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object studentObj = session.getAttribute("student");
        String role = (String) session.getAttribute("role");

        if (studentObj == null || !"student".equals(role) || !(studentObj instanceof Student)) {
            session.setAttribute("error", "Access Denied. Please login as a student.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Student student = (Student) studentObj;

        try {
            JobDriveDAO driveDao = new JobDriveDAO();
            AnalyticsDAO analyticsDao = new AnalyticsDAO();
            
            List<JobDrive> drives = driveDao.getDrivesForStudent(student.getId());
            Map<String, Integer> stats = analyticsDao.getStudentStatusStats(student.getId());

            request.setAttribute("drives", drives);
            request.setAttribute("stats", stats);
            
            // Debugging
            System.out.println("Student ID: " + student.getId() + " - Drives count: " + (drives != null ? drives.size() : "null"));
            
            request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("CRITICAL ERROR: Failed to load student dashboard");
            e.printStackTrace(); // Log the full stack trace in catalina.out
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading dashboard: " + e.getMessage());
        }
    }
}
