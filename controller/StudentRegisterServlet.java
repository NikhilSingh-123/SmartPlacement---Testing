package com.smartplacement.controller;

import com.smartplacement.dao.StudentDAO;
import com.smartplacement.model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/StudentRegisterServlet")
public class StudentRegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            Student s = new Student();
            s.setName(request.getParameter("name"));
            s.setEmail(request.getParameter("email"));
            s.setPassword(request.getParameter("password"));
            s.setBranch(request.getParameter("branch"));
            s.setCgpa(Double.parseDouble(request.getParameter("cgpa")));
            s.setContactNumber(request.getParameter("contact"));
            s.setCollegeName(request.getParameter("collegeName"));

            StudentDAO dao = new StudentDAO();
            if (dao.registerStudent(s)) {
                // Redirect to student login page
                response.sendRedirect(request.getContextPath() + "/login.jsp?msg=registered&role=student");
            } else {
                response.sendRedirect(request.getContextPath() + "/student/register.jsp?error=invalid");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/student/register.jsp?error=invalid");
        }
    }
}
