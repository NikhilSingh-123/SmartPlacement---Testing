package com.smartplacement.dao;

import com.smartplacement.model.JobDrive;
import com.smartplacement.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JobDriveDAO {

    public boolean addJobDrive(JobDrive drive) {
        String sql = "INSERT INTO job_drive (company_id, job_role, description, eligibility_cgpa, " +
                     "eligible_branches, last_date, drive_date, salary_package, location) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, drive.getCompanyId());
            stmt.setString(2, drive.getJobRole());
            stmt.setString(3, drive.getDescription());
            stmt.setDouble(4, drive.getEligibilityCgpa());
            stmt.setString(5, drive.getEligibleBranches());
            stmt.setDate(6, drive.getLastDate());
            stmt.setDate(7, drive.getDriveDate());
            stmt.setString(8, drive.getSalaryPackage());
            stmt.setString(9, drive.getLocation());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public JobDrive getDriveById(int driveId) {
        String sql = "SELECT jd.*, c.company_name, c.logo as company_logo FROM job_drive jd " +
                     "JOIN company c ON jd.company_id = c.id WHERE jd.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, driveId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                JobDrive d = extractDrive(rs);
                d.setCompanyName(rs.getString("company_name"));
                d.setCompanyLogo(rs.getString("company_logo"));
                return d;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<JobDrive> getDrivesByCompany(int companyId) {
        List<JobDrive> list = new ArrayList<>();
        String sql = "SELECT jd.*, c.company_name, c.logo as company_logo FROM job_drive jd " +
                     "JOIN company c ON jd.company_id = c.id WHERE jd.company_id = ? ORDER BY jd.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, companyId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                JobDrive d = extractDrive(rs);
                d.setCompanyName(rs.getString("company_name"));
                d.setCompanyLogo(rs.getString("company_logo"));
                list.add(d);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<JobDrive> getDrivesForStudent(int studentId) {
        List<JobDrive> list = new ArrayList<>();
        String sql = "SELECT jd.*, c.company_name, c.logo as company_logo, " +
                     "(SELECT COUNT(*) FROM application WHERE student_id = ? AND drive_id = jd.id) as applied " +
                     "FROM job_drive jd JOIN company c ON jd.company_id = c.id ORDER BY jd.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                JobDrive d = extractDrive(rs);
                d.setCompanyName(rs.getString("company_name"));
                d.setCompanyLogo(rs.getString("company_logo"));
                d.setApplied(rs.getInt("applied") > 0);
                list.add(d);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<JobDrive> searchDrives(int studentId, String keyword, String branch, String minPackage) {
        List<JobDrive> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT jd.*, c.company_name, c.logo as company_logo, " +
            "(SELECT COUNT(*) FROM application WHERE student_id = ? AND drive_id = jd.id) as applied " +
            "FROM job_drive jd JOIN company c ON jd.company_id = c.id WHERE 1=1");

        if (keyword != null && !keyword.isEmpty())
            sql.append(" AND (jd.job_role LIKE ? OR c.company_name LIKE ? OR jd.location LIKE ?)");
        if (branch != null && !branch.isEmpty())
            sql.append(" AND jd.eligible_branches LIKE ?");

        sql.append(" ORDER BY jd.id DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            stmt.setInt(idx++, studentId);
            if (keyword != null && !keyword.isEmpty()) {
                String k = "%" + keyword + "%";
                stmt.setString(idx++, k);
                stmt.setString(idx++, k);
                stmt.setString(idx++, k);
            }
            if (branch != null && !branch.isEmpty())
                stmt.setString(idx++, "%" + branch + "%");

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                JobDrive d = extractDrive(rs);
                d.setCompanyName(rs.getString("company_name"));
                d.setCompanyLogo(rs.getString("company_logo"));
                d.setApplied(rs.getInt("applied") > 0);
                list.add(d);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<JobDrive> getAllDrives() {
        List<JobDrive> list = new ArrayList<>();
        String sql = "SELECT jd.*, c.company_name FROM job_drive jd " +
                     "JOIN company c ON jd.company_id = c.id ORDER BY jd.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                JobDrive d = extractDrive(rs);
                d.setCompanyName(rs.getString("company_name"));
                list.add(d);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateDrive(JobDrive drive) {
        String sql = "UPDATE job_drive SET job_role=?, description=?, eligibility_cgpa=?, " +
                     "eligible_branches=?, last_date=?, drive_date=?, salary_package=?, location=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, drive.getJobRole());
            stmt.setString(2, drive.getDescription());
            stmt.setDouble(3, drive.getEligibilityCgpa());
            stmt.setString(4, drive.getEligibleBranches());
            stmt.setDate(5, drive.getLastDate());
            stmt.setDate(6, drive.getDriveDate());
            stmt.setString(7, drive.getSalaryPackage());
            stmt.setString(8, drive.getLocation());
            stmt.setInt(9, drive.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteDrive(int driveId) {
        String sql = "DELETE FROM job_drive WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, driveId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private JobDrive extractDrive(ResultSet rs) throws SQLException {
        JobDrive d = new JobDrive();
        d.setId(rs.getInt("id"));
        d.setCompanyId(rs.getInt("company_id"));
        d.setJobRole(rs.getString("job_role"));
        d.setDescription(rs.getString("description"));
        d.setEligibilityCgpa(rs.getDouble("eligibility_cgpa"));
        d.setEligibleBranches(rs.getString("eligible_branches"));
        d.setLastDate(rs.getDate("last_date"));
        d.setDriveDate(rs.getDate("drive_date"));
        d.setSalaryPackage(rs.getString("salary_package"));
        d.setLocation(rs.getString("location"));
        return d;
    }
}
