package com.smartplacement.controller;

import com.smartplacement.model.Student;
import com.smartplacement.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.UUID;

@WebServlet("/FileUploadServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class FileUploadServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uploadType = request.getParameter("uploadType");
        HttpSession session = request.getSession();
        
        Part filePart = request.getPart("file");
        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect(request.getHeader("Referer"));
            return;
        }

        String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);
        String relativePath = "";
        
        if ("profile".equals(uploadType)) {
            relativePath = "uploads/profiles/" + fileName;
        } else if ("cover".equals(uploadType)) {
            relativePath = "uploads/covers/" + fileName;
        } else if ("logo".equals(uploadType)) {
            relativePath = "uploads/logos/" + fileName;
        }

        String savePath = getServletContext().getRealPath("/") + relativePath;
        File fileSaveDir = new File(savePath).getParentFile();
        if (!fileSaveDir.exists()) {
            fileSaveDir.mkdirs();
        }

        filePart.write(savePath);

        try (Connection conn = DBConnection.getConnection()) {
            if ("profile".equals(uploadType) || "cover".equals(uploadType)) {
                Student student = (Student) session.getAttribute("userObj");
                if (student == null) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    return;
                }
                String column = "profile".equals(uploadType) ? "profile_photo" : "cover_photo";
                String sql = "UPDATE students SET " + column + " = ? WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, relativePath);
                ps.setInt(2, student.getId());
                ps.executeUpdate();
                
                // Update session object
                if ("profile".equals(uploadType)) student.setProfilePhoto(relativePath);
                else student.setCoverPhoto(relativePath);
                
            } else if ("logo".equals(uploadType)) {
                // For admin adding company logo or company setting their own logo
                String companyId = request.getParameter("companyId");
                if (companyId != null) {
                    String sql = "UPDATE company SET logo = ? WHERE id = ?";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setString(1, relativePath);
                    ps.setInt(2, Integer.parseInt(companyId));
                    ps.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getHeader("Referer"));
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}
