package com.smartplacement.dao;

import com.smartplacement.model.Company;
import com.smartplacement.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CompanyDAO {

    public boolean registerCompany(Company company) {
        String sql = "INSERT INTO company (company_name, email, password, website, description, contact_number, logo) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, company.getCompanyName());
            stmt.setString(2, company.getEmail());
            stmt.setString(3, company.getPassword());
            stmt.setString(4, company.getWebsite());
            stmt.setString(5, company.getDescription());
            stmt.setString(6, company.getContactNumber());
            stmt.setString(7, company.getLogo());
            return stmt.executeUpdate() > 0;
        } catch (SQLIntegrityConstraintViolationException e) {
            System.err.println("Duplicate email registration attempt: " + company.getEmail());
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Company loginCompany(String email, String password) {
        String sql = "SELECT * FROM company WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Company c = new Company();
                c.setId(rs.getInt("id"));
                c.setCompanyName(rs.getString("company_name"));
                c.setEmail(rs.getString("email"));
                c.setWebsite(rs.getString("website"));
                c.setDescription(rs.getString("description"));
                c.setContactNumber(rs.getString("contact_number"));
                c.setStatus(rs.getString("status"));
                c.setLogo(rs.getString("logo"));
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Company> getAllCompanies() {
        List<Company> list = new ArrayList<>();
        String sql = "SELECT * FROM company";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Company c = new Company();
                c.setId(rs.getInt("id"));
                c.setCompanyName(rs.getString("company_name"));
                c.setEmail(rs.getString("email"));
                c.setWebsite(rs.getString("website"));
                c.setStatus(rs.getString("status"));
                c.setLogo(rs.getString("logo"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public boolean deleteCompany(int id) {
        String sql = "DELETE FROM company WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
