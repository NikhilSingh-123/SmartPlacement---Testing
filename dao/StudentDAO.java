package com.smartplacement.dao;

import com.smartplacement.model.Student;
import com.smartplacement.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    // ------------------------------------------------------------------ //
    //  REGISTRATION & AUTH
    // ------------------------------------------------------------------ //

    public boolean registerStudent(Student student) {
        String sql = "INSERT INTO students (name, email, password, branch, cgpa, contact_number, college_name) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, student.getName());
            stmt.setString(2, student.getEmail());
            stmt.setString(3, student.getPassword());
            stmt.setString(4, student.getBranch());
            stmt.setDouble(5, student.getCgpa());
            stmt.setString(6, student.getContactNumber());
            stmt.setString(7, student.getCollegeName());
            return stmt.executeUpdate() > 0;
        } catch (SQLIntegrityConstraintViolationException e) {
            // duplicate email
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Student loginStudent(String email, String password) {
        String sql = "SELECT * FROM students WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ------------------------------------------------------------------ //
    //  FETCH METHODS
    // ------------------------------------------------------------------ //

    public Student getStudentById(int id) {
        String sql = "SELECT * FROM students WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM students ORDER BY name";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Returns students who applied to a specific drive.
     * Joins application + students tables.
     */
    public List<Student> getStudentsByDrive(int driveId) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT s.*, a.status as app_status FROM students s " +
                     "JOIN application a ON s.id = a.student_id " +
                     "WHERE a.drive_id = ? ORDER BY s.cgpa DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, driveId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Student s = mapRow(rs);
                s.setStatus(rs.getString("app_status")); // override with app status
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Returns all students who applied to any drive posted by a company.
     */
    public List<Student> getStudentsByCompany(int companyId) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT DISTINCT s.*, a.status as app_status FROM students s " +
                     "JOIN application a ON s.id = a.student_id " +
                     "JOIN job_drive jd ON a.drive_id = jd.id " +
                     "WHERE jd.company_id = ? ORDER BY s.cgpa DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, companyId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Student s = mapRow(rs);
                s.setStatus(rs.getString("app_status"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ------------------------------------------------------------------ //
    //  UPDATE METHODS
    // ------------------------------------------------------------------ //

    public boolean updateProfile(Student student) {
        String sql = "UPDATE students SET name=?, branch=?, cgpa=?, contact_number=?, college_name=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, student.getName());
            stmt.setString(2, student.getBranch());
            stmt.setDouble(3, student.getCgpa());
            stmt.setString(4, student.getContactNumber());
            stmt.setString(5, student.getCollegeName());
            stmt.setInt(6, student.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePhotos(int studentId, String profile, String cover) {
        String sql = "UPDATE students SET profile_photo = ?, cover_photo = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, profile);
            stmt.setString(2, cover);
            stmt.setInt(3, studentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateResumePath(int studentId, String path) {
        String sql = "UPDATE students SET resume_path = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, path);
            stmt.setInt(2, studentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update student placement status (SELECTED / REJECTED / SHORTLISTED).
     * Used by Admin and Company servlets to reflect results immediately.
     */
    public boolean updateStatus(int studentId, String status) {
        String sql = "UPDATE students SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, studentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ------------------------------------------------------------------ //
    //  SEARCH
    // ------------------------------------------------------------------ //

    public List<Student> searchStudents(String query) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM students WHERE name LIKE ? OR email LIKE ? OR branch LIKE ? ORDER BY cgpa DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String like = "%" + query + "%";
            stmt.setString(1, like);
            stmt.setString(2, like);
            stmt.setString(3, like);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ------------------------------------------------------------------ //
    //  PRIVATE HELPERS
    // ------------------------------------------------------------------ //

    private Student mapRow(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setId(rs.getInt("id"));
        s.setName(rs.getString("name"));
        s.setEmail(rs.getString("email"));
        s.setBranch(rs.getString("branch"));
        s.setCgpa(rs.getDouble("cgpa"));
        s.setResumePath(rs.getString("resume_path"));
        s.setContactNumber(rs.getString("contact_number"));
        s.setStatus(rs.getString("status"));
        s.setProfilePhoto(rs.getString("profile_photo"));
        s.setCoverPhoto(rs.getString("cover_photo"));
        s.setCollegeName(rs.getString("college_name"));
        return s;
    }
}
