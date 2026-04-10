package com.smartplacement.controller;

import com.smartplacement.model.Company;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/CompanyLoginServlet")
public class CompanyLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        HttpSession session = request.getSession();
        
        try {
            java.sql.Connection conn = com.smartplacement.util.DBConnection.getConnection();
            String sql = "SELECT * FROM company WHERE email=? AND password=?";
            java.sql.PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password);
            java.sql.ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                System.out.println("Login success - redirecting to dashboard");
                Company company = new Company();
                company.setId(rs.getInt("id"));
                company.setCompanyName(rs.getString("company_name"));
                company.setEmail(rs.getString("email"));
                
                session.setAttribute("company", company);
                session.setAttribute("userObj", company); // compatibility
                session.setAttribute("role", "company");
                
                response.sendRedirect(request.getContextPath() + "/companyDashboard");
            } else {
                System.out.println("Login failed - invalid credentials for: " + email);
                session.setAttribute("error", "Invalid Email or Password");
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid");
            }
        } catch (Exception e) {
            System.err.println("CRITICAL ERROR: Company Login Failure");
            e.printStackTrace();
            session.setAttribute("error", "An internal error occurred. Please try again.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
}
