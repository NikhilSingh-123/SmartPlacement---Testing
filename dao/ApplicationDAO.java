package com.smartplacement.dao;

import com.smartplacement.model.Application;
import com.smartplacement.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    // ------------------------------------------------------------------ //
    //  FETCH
    // ------------------------------------------------------------------ //

    public Application getApplicationById(int id) {
        String sql = "SELECT * FROM application WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return extractApp(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Fetch a specific application by student+drive combination.
     * Used by shortlist/reject lookups when we only have studentId + driveId.
     */
    public Application getApplicationByStudentAndDrive(int studentId, int driveId) {
        String sql = "SELECT * FROM application WHERE student_id = ? AND drive_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, driveId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return extractApp(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Application> getApplicationsByStudent(int studentId) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, c.company_name, jd.job_role, jd.salary_package, jd.location " +
                     "FROM application a " +
                     "JOIN job_drive jd ON a.drive_id = jd.id " +
                     "JOIN company c ON jd.company_id = c.id " +
                     "WHERE a.student_id = ? ORDER BY a.apply_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Application app = extractApp(rs);
                app.setCompanyName(rs.getString("company_name"));
                app.setJobRole(rs.getString("job_role"));
                app.setSalaryPackage(rs.getString("salary_package"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Application> getApplicationsByCompany(int companyId) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, s.name as student_name, s.branch as student_branch, " +
                     "s.cgpa as student_cgpa, s.email as student_email, s.resume_path, " +
                     "jd.job_role, jd.salary_package " +
                     "FROM application a " +
                     "JOIN job_drive jd ON a.drive_id = jd.id " +
                     "JOIN students s ON a.student_id = s.id " +
                     "WHERE jd.company_id = ? ORDER BY a.apply_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, companyId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Application app = extractApp(rs);
                app.setStudentName(rs.getString("student_name"));
                app.setBranch(rs.getString("student_branch"));
                app.setStudentCgpa(rs.getDouble("student_cgpa"));
                app.setStudentEmail(rs.getString("student_email"));
                app.setJobRole(rs.getString("job_role"));
                app.setSalaryPackage(rs.getString("salary_package"));
                app.setStudentResume(rs.getString("resume_path"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Application> getApplicationsByDrive(int driveId) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, s.name as student_name, s.branch as student_branch, " +
                     "s.cgpa as student_cgpa, s.email as student_email, s.resume_path " +
                     "FROM application a " +
                     "JOIN students s ON a.student_id = s.id " +
                     "WHERE a.drive_id = ? ORDER BY s.cgpa DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, driveId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Application app = extractApp(rs);
                app.setStudentName(rs.getString("student_name"));
                app.setBranch(rs.getString("student_branch"));
                app.setStudentCgpa(rs.getDouble("student_cgpa"));
                app.setStudentEmail(rs.getString("student_email"));
                app.setStudentResume(rs.getString("resume_path"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Application> getSuccessfulPlacements() {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, s.name as student_name, s.branch, " +
                     "c.company_name, jd.job_role, jd.salary_package " +
                     "FROM application a " +
                     "JOIN students s ON a.student_id = s.id " +
                     "JOIN job_drive jd ON a.drive_id = jd.id " +
                     "JOIN company c ON jd.company_id = c.id " +
                     "WHERE a.status = 'SELECTED' ORDER BY a.apply_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Application app = new Application();
                app.setId(rs.getInt("id"));
                app.setStudentName(rs.getString("student_name"));
                app.setBranch(rs.getString("branch"));
                app.setCompanyName(rs.getString("company_name"));
                app.setJobRole(rs.getString("job_role"));
                app.setSalaryPackage(rs.getString("salary_package"));
                app.setStatus("SELECTED");
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ------------------------------------------------------------------ //
    //  INSERT / UPDATE
    // ------------------------------------------------------------------ //

    public boolean applyForJob(int studentId, int driveId) {
        String sql = "INSERT INTO application (student_id, drive_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, driveId);
            return stmt.executeUpdate() > 0;
        } catch (SQLIntegrityConstraintViolationException e) {
            return false; // already applied
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int applicationId, String status) {
        String sql = "UPDATE application SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, applicationId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ------------------------------------------------------------------ //
    //  PRIVATE HELPERS
    // ------------------------------------------------------------------ //

    private Application extractApp(ResultSet rs) throws SQLException {
        Application app = new Application();
        app.setId(rs.getInt("id"));
        app.setStudentId(rs.getInt("student_id"));
        app.setDriveId(rs.getInt("drive_id"));
        app.setStatus(rs.getString("status"));
        app.setApplyDate(rs.getTimestamp("apply_date"));
        return app;
    }
}
