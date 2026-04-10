package com.smartplacement.dao;

import com.smartplacement.util.DBConnection;
import com.smartplacement.model.JobDrive;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SavedJobDAO {

    public boolean saveJob(int studentId, int driveId) {
        String sql = "INSERT INTO saved_jobs (student_id, drive_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, driveId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            // Already saved or other error
        }
        return false;
    }

    public boolean removeSavedJob(int studentId, int driveId) {
        String sql = "DELETE FROM saved_jobs WHERE student_id = ? AND drive_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, driveId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<JobDrive> getSavedJobsByStudent(int studentId) {
        List<JobDrive> list = new ArrayList<>();
        String sql = "SELECT jd.*, c.company_name FROM job_drive jd " +
                     "JOIN company c ON jd.company_id = c.id " +
                     "JOIN saved_jobs sj ON jd.id = sj.drive_id " +
                     "WHERE sj.student_id = ? ORDER BY jd.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                JobDrive d = new JobDrive();
                d.setId(rs.getInt("id"));
                d.setCompanyId(rs.getInt("company_id"));
                d.setJobRole(rs.getString("job_role"));
                d.setDescription(rs.getString("description"));
                d.setEligibilityCgpa(rs.getDouble("eligibility_cgpa"));
                d.setSalaryPackage(rs.getString("salary_package"));
                d.setDriveDate(rs.getDate("drive_date"));
                d.setLastDate(rs.getDate("last_date"));
                d.setLocation(rs.getString("location"));
                d.setCompanyName(rs.getString("company_name"));
                list.add(d);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean isJobSaved(int studentId, int driveId) {
        String sql = "SELECT 1 FROM saved_jobs WHERE student_id = ? AND drive_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, driveId);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
