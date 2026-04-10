package com.smartplacement.dao;

import com.smartplacement.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SavedJobsDAO {

    public boolean saveJob(int studentId, int driveId) {
        String sql = "INSERT INTO saved_jobs (student_id, drive_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, driveId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            return false;
        }
    }

    public boolean removeSavedJob(int studentId, int driveId) {
        String sql = "DELETE FROM saved_jobs WHERE student_id = ? AND drive_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, driveId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            return false;
        }
    }

    public List<Integer> getSavedJobIds(int studentId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT drive_id FROM saved_jobs WHERE student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt("drive_id"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ids;
    }
}
