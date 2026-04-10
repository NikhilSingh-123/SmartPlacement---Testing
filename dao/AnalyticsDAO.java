package com.smartplacement.dao;

import com.smartplacement.util.DBConnection;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

public class AnalyticsDAO {

    public int[] getPlacementStats() {
        int[] stats = new int[2];
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            ResultSet rsTotal = stmt.executeQuery("SELECT COUNT(*) FROM students");
            if (rsTotal.next()) stats[1] = rsTotal.getInt(1);
            ResultSet rsPlaced = stmt.executeQuery("SELECT COUNT(DISTINCT student_id) FROM application WHERE status = 'SELECTED'");
            if (rsPlaced.next()) stats[0] = rsPlaced.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    public Map<String, Integer> getApplicationStatusStats() {
        Map<String, Integer> stats = new HashMap<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT status, COUNT(*) FROM application GROUP BY status")) {
            while (rs.next()) {
                stats.put(rs.getString(1), rs.getInt(2));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    public Map<String, Integer> getBranchWisePlacement() {
        Map<String, Integer> stats = new HashMap<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT s.branch, COUNT(DISTINCT a.student_id) FROM students s JOIN application a ON s.id = a.student_id WHERE a.status = 'SELECTED' GROUP BY s.branch")) {
            while (rs.next()) {
                stats.put(rs.getString(1), rs.getInt(2));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    public Map<String, Integer> getMonthlyDriveActivity() {
        Map<String, Integer> stats = new HashMap<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT DATE_FORMAT(drive_date, '%b %Y') as month, COUNT(*) FROM job_drive GROUP BY month ORDER BY MIN(drive_date) ASC LIMIT 12")) {
            while (rs.next()) {
                stats.put(rs.getString(1), rs.getInt(2));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    // --- Student Specific Stats ---
    public Map<String, Integer> getStudentStatusStats(int studentId) {
        Map<String, Integer> stats = new HashMap<>();
        try (Connection conn = DBConnection.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement("SELECT status, COUNT(*) FROM application WHERE student_id = ? GROUP BY status")) {
            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                stats.put(rs.getString(1), rs.getInt(2));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    public double getAverageCGPAByBranch(String branch) {
        double avg = 0;
        try (Connection conn = DBConnection.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement("SELECT AVG(cgpa) FROM students WHERE branch = ?")) {
            pstmt.setString(1, branch);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) avg = rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return avg;
    }

    // --- Company Specific Stats ---
    public Map<String, Integer> getCompanyFunnelStats(int companyId) {
        Map<String, Integer> stats = new HashMap<>();
        try (Connection conn = DBConnection.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(
                 "SELECT a.status, COUNT(*) FROM application a " +
                 "JOIN job_drive j ON a.drive_id = j.id " +
                 "WHERE j.company_id = ? GROUP BY a.status")) {
            pstmt.setInt(1, companyId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                stats.put(rs.getString(1), rs.getInt(2));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    public Map<String, Integer> getCompanyBranchStats(int companyId) {
        Map<String, Integer> stats = new HashMap<>();
        try (Connection conn = DBConnection.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(
                 "SELECT s.branch, COUNT(*) FROM application a " +
                 "JOIN students s ON a.student_id = s.id " +
                 "JOIN job_drive j ON a.drive_id = j.id " +
                 "WHERE j.company_id = ? GROUP BY s.branch")) {
            pstmt.setInt(1, companyId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                stats.put(rs.getString(1), rs.getInt(2));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }
}
