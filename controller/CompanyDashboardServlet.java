package com.smartplacement.controller;

import com.smartplacement.dao.AnalyticsDAO;
import com.smartplacement.dao.JobDriveDAO;
import com.smartplacement.model.Company;
import com.smartplacement.model.JobDrive;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/companyDashboard")
public class CompanyDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("userObj");
        String role = (String) session.getAttribute("role");

        if (userObj == null || !"company".equals(role) || !(userObj instanceof Company)) {
            session.setAttribute("error", "Access Denied. Please login as a company.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Company company = (Company) userObj;

        try {
            JobDriveDAO driveDao = new JobDriveDAO();
            AnalyticsDAO analyticsDao = new AnalyticsDAO();
            
            List<JobDrive> myDrives = driveDao.getDrivesByCompany(company.getId());
            Map<String, Integer> funnel = analyticsDao.getCompanyFunnelStats(company.getId());

            request.setAttribute("myDrives", myDrives);
            request.setAttribute("funnel", funnel);
            
            // Debugging
            System.out.println("Company Dashboard - ID: " + company.getId() + ", Drives count: " + (myDrives != null ? myDrives.size() : "null"));
            
            request.getRequestDispatcher("/company/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("CRITICAL ERROR: Failed to load company dashboard");
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading dashboard: " + e.getMessage());
        }
    }
}
