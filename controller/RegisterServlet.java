package com.smartplacement.controller;

import com.smartplacement.dao.CompanyDAO;
import com.smartplacement.dao.StudentDAO;
import com.smartplacement.model.Company;
import com.smartplacement.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = request.getParameter("role");
        HttpSession session = request.getSession();

        try {
            if ("student".equalsIgnoreCase(role)) {
                Student s = new Student();
                s.setName(request.getParameter("name"));
                s.setEmail(request.getParameter("email"));
                s.setPassword(request.getParameter("password"));
                s.setBranch(request.getParameter("branch"));
                s.setCgpa(Double.parseDouble(request.getParameter("cgpa")));
                s.setContactNumber(request.getParameter("contact"));

                StudentDAO dao = new StudentDAO();
                if (dao.registerStudent(s)) {
                    session.setAttribute("msg", "Student Registered Successfully");
                } else {
                    session.setAttribute("error", "Registration Failed");
                }
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                
            } else if ("company".equalsIgnoreCase(role)) {
                Company c = new Company();
                c.setCompanyName(request.getParameter("companyName"));
                c.setEmail(request.getParameter("email"));
                c.setPassword(request.getParameter("password"));
                c.setWebsite(request.getParameter("website"));
                c.setDescription(request.getParameter("description"));
                c.setContactNumber(request.getParameter("contact"));

                CompanyDAO dao = new CompanyDAO();
                if (dao.registerCompany(c)) {
                    session.setAttribute("msg", "Company Registered Successfully");
                } else {
                    session.setAttribute("error", "Registration Failed");
                }
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}
