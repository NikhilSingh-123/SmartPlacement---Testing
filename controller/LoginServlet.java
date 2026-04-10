package com.smartplacement.controller;

import com.smartplacement.dao.AdminDAO;
import com.smartplacement.dao.StudentDAO;
import com.smartplacement.model.Admin;
import com.smartplacement.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = request.getParameter("role");
        String email = request.getParameter("email"); // or username for admin
        String password = request.getParameter("password");
        
        HttpSession session = request.getSession();
        
        try {
            if ("student".equalsIgnoreCase(role)) {
                StudentDAO dao = new StudentDAO();
                Student s = dao.loginStudent(email, password);
                if (s != null) {
                    session.setAttribute("userObj", s);
                    session.setAttribute("student", s); // Fix for dashboard consistency
                    session.setAttribute("role", "student");
                    response.sendRedirect(request.getContextPath() + "/studentDashboard");
                } else {
                    session.setAttribute("error", "Invalid Email or Password");
                    response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid");
                }
            } else if ("company".equalsIgnoreCase(role)) {
                com.smartplacement.dao.CompanyDAO dao = new com.smartplacement.dao.CompanyDAO();
                com.smartplacement.model.Company c = dao.loginCompany(email, password);
                if (c != null) {
                    session.setAttribute("userObj", c);
                    session.setAttribute("company", c);
                    session.setAttribute("role", "company");
                    response.sendRedirect(request.getContextPath() + "/companyDashboard");
                } else {
                    session.setAttribute("error", "Invalid Email or Password");
                    response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid");
                }
            } else if ("admin".equalsIgnoreCase(role)) {
                AdminDAO dao = new AdminDAO();
                Admin a = dao.loginAdmin(email, password);
                if (a != null) {
                    session.setAttribute("userObj", a);
                    session.setAttribute("role", "admin");
                    response.sendRedirect(request.getContextPath() + "/adminDashboard");
                } else {
                    session.setAttribute("error", "Invalid Username or Password");
                    response.sendRedirect(request.getContextPath() + "/index.jsp?error=invalid");
                }
            } else {
                session.setAttribute("error", "Please select a valid role.");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}
