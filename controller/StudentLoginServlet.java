package com.smartplacement.controller;

import com.smartplacement.model.Student;
import com.smartplacement.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/StudentLoginServlet")
public class StudentLoginServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // STEP 1: PRINT DEBUG
        System.out.println("Email: " + email);
        System.out.println("Password: " + password);
        
        HttpSession session = request.getSession();
        
        try (Connection conn = DBConnection.getConnection()) {
            // STEP 3: FIX SQL QUERY (Exact match)
            String sql = "SELECT * FROM students WHERE email=? AND password=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            
            ResultSet rs = ps.executeQuery();
            
            // STEP 4: FIX SERVLET LOGIC
            if (rs.next()) {
                // Build full Student object for session
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setName(rs.getString("name"));
                student.setEmail(rs.getString("email"));
                student.setBranch(rs.getString("branch"));
                student.setCgpa(rs.getDouble("cgpa"));
                student.setContactNumber(rs.getString("contact_number"));
                student.setProfilePhoto(rs.getString("profile_photo"));
                student.setCoverPhoto(rs.getString("cover_photo"));
                student.setStatus(rs.getString("status"));
                student.setCollegeName(rs.getString("college_name"));
                session.setAttribute("student", student);
                session.setAttribute("role", "student");

                System.out.println("LOGIN SUCCESS");

                response.sendRedirect(request.getContextPath() + "/studentDashboard");
                return;
            } else {
                System.out.println("LOGIN FAILED");

                response.sendRedirect(request.getContextPath() + "/student/login.jsp?error=invalid");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendRedirect(request.getContextPath() + "/student/login.jsp?error=server");
            }
        }
    }
}
