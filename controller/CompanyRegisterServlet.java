package com.smartplacement.controller;

import com.smartplacement.dao.CompanyDAO;
import com.smartplacement.model.Company;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/CompanyRegisterServlet")
public class CompanyRegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String companyName = request.getParameter("companyName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String website = request.getParameter("website");
        String description = request.getParameter("description");
        String contact = request.getParameter("contact");

        if (companyName == null || companyName.trim().isEmpty() || email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/company/register.jsp?error=missing");
            return;
        }
        
        // Validation
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            response.sendRedirect(request.getContextPath() + "/company/register.jsp?error=invalid_email");
            return;
        }
        
        if (password.length() < 6) {
            response.sendRedirect(request.getContextPath() + "/company/register.jsp?error=weak_password");
            return;
        }
        
        if (contact == null || contact.trim().isEmpty() || !contact.matches("^[0-9+()\\\\s-]{8,15}$")) {
            response.sendRedirect(request.getContextPath() + "/company/register.jsp?error=invalid_contact");
            return;
        }

        Company c = new Company();
        c.setCompanyName(companyName);
        c.setEmail(email);
        c.setPassword(password);
        c.setWebsite(website);
        c.setDescription(description);
        c.setContactNumber(contact);

        try {
            java.sql.Connection conn = com.smartplacement.util.DBConnection.getConnection();
            String sql = "INSERT INTO company (company_name, email, password, contact_number, status) VALUES (?, ?, ?, ?, 'ACTIVE')";
            java.sql.PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, companyName);
            stmt.setString(2, email);
            stmt.setString(3, password);
            stmt.setString(4, contact);
            
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                response.sendRedirect(request.getContextPath() + "/company/login.jsp?msg=registered");
            } else {
                response.sendRedirect(request.getContextPath() + "/company/register.jsp?error=internal");
            }
            stmt.close();
            conn.close();
        } catch (java.sql.SQLIntegrityConstraintViolationException e) {
            // Handle duplicate email
            response.sendRedirect(request.getContextPath() + "/company/register.jsp?error=duplicate");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/company/register.jsp?error=internal");
        }
    }
}
