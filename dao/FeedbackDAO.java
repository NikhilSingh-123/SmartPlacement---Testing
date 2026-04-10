package com.smartplacement.dao;

import com.smartplacement.model.Feedback;
import com.smartplacement.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {
    
    public boolean submitFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedback (student_id, subject, message) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, feedback.getStudentId());
            stmt.setString(2, feedback.getSubject());
            stmt.setString(3, feedback.getMessage());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Feedback> getAllFeedback() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, s.name FROM feedback f JOIN students s ON f.student_id = s.id ORDER BY f.id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Feedback f = new Feedback();
                f.setId(rs.getInt("id"));
                f.setStudentId(rs.getInt("student_id"));
                f.setSubject(rs.getString("subject"));
                f.setMessage(rs.getString("message"));
                f.setSubmitDate(rs.getTimestamp("submit_date"));
                f.setStudentName(rs.getString("name"));
                list.add(f);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
