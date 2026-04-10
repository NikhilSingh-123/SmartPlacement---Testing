package com.smartplacement.controller;

import com.smartplacement.dao.AnalyticsDAO;
import com.smartplacement.dao.CompanyDAO;
import com.smartplacement.dao.JobDriveDAO;
import com.smartplacement.model.Admin;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet("/adminDashboard")
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("userObj");
        String role = (String) session.getAttribute("role");

        if (userObj == null || !"admin".equals(role) || !(userObj instanceof Admin)) {
            session.setAttribute("error", "Access Denied. Please login as Admin.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            AnalyticsDAO dao = new AnalyticsDAO();
            CompanyDAO cDao = new CompanyDAO();
            JobDriveDAO jDao = new JobDriveDAO();

            int[] placementStats = dao.getPlacementStats();
            Map<String, Integer> statusStats = dao.getApplicationStatusStats();
            Map<String, Integer> branchStats = dao.getBranchWisePlacement();
            int totalCompanies = cDao.getAllCompanies().size();
            int totalDrives = jDao.getAllDrives().size();

            request.setAttribute("placementStats", placementStats);
            request.setAttribute("statusStats", statusStats);
            request.setAttribute("branchStats", branchStats);
            request.setAttribute("totalCompanies", totalCompanies);
            request.setAttribute("totalDrives", totalDrives);

            // Debugging
            System.out.println("Admin Access - Companies: " + totalCompanies + ", Drives: " + totalDrives);

            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("CRITICAL ERROR: Failed to load admin dashboard");
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading dashboard: " + e.getMessage());
        }
    }
}
