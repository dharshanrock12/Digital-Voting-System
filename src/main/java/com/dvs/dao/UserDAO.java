package com.dvs.dao;

import com.dvs.model.User;
import com.dvs.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * UserDAO — handles all database operations for the users table.
 * Author: Dharshan Sathish Kumar | Reg: 3122255002029
 */
public class UserDAO {

    // ------------------------------------------------------------------
    // READ
    // ------------------------------------------------------------------

    /** Authenticate user by username + plain password + expected role. */
    public User authenticate(String username, String plainPassword, String role) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ? AND role = ? AND is_active = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, role);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String storedHash = rs.getString("password_hash");
                if (BCrypt.checkpw(plainPassword, storedHash)) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    /** Find a user by primary key. */
    public User findById(int id) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        }
    }

    /** Return all users. */
    public List<User> findAll() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY role, full_name";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Return all users with a specific role. */
    public List<User> findByRole(String role) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ? ORDER BY full_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Check whether a username is already taken (optionally excluding a user id). */
    public boolean usernameExists(String username, int excludeId) throws SQLException {
        String sql = "SELECT id FROM users WHERE username = ? AND id <> ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, excludeId);
            return ps.executeQuery().next();
        }
    }

    /** Count voters who have already voted. */
    public int countVoted() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'voter' AND has_voted = 1";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /** Count total registered voters. */
    public int countVoters() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'voter'";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ------------------------------------------------------------------
    // WRITE
    // ------------------------------------------------------------------

    /** Insert a new user and return generated id. */
    public int insert(User u) throws SQLException {
        String sql = """
                INSERT INTO users (full_name, username, password_hash, role,
                                   voter_id, constituency, has_voted, is_active)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, u.getFullName());
            ps.setString(2, u.getUsername());
            ps.setString(3, BCrypt.hashpw(u.getPasswordHash(), BCrypt.gensalt(12)));
            ps.setString(4, u.getRole().name());
            ps.setString(5, u.getVoterId());
            ps.setString(6, u.getConstituency());
            ps.setBoolean(7, u.isHasVoted());
            ps.setBoolean(8, u.isActive());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            return keys.next() ? keys.getInt(1) : -1;
        }
    }

    /** Update user fields (password only changed if newPassword != null). */
    public void update(User u, String newPlainPassword) throws SQLException {
        boolean changePassword = (newPlainPassword != null && !newPlainPassword.isBlank());
        String sql = changePassword
                ? "UPDATE users SET full_name=?, username=?, password_hash=?, role=?, voter_id=?, constituency=?, is_active=? WHERE id=?"
                : "UPDATE users SET full_name=?, username=?, role=?, voter_id=?, constituency=?, is_active=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getFullName());
            ps.setString(2, u.getUsername());
            if (changePassword) {
                ps.setString(3, BCrypt.hashpw(newPlainPassword, BCrypt.gensalt(12)));
                ps.setString(4, u.getRole().name());
                ps.setString(5, u.getVoterId());
                ps.setString(6, u.getConstituency());
                ps.setBoolean(7, u.isActive());
                ps.setInt(8, u.getId());
            } else {
                ps.setString(3, u.getRole().name());
                ps.setString(4, u.getVoterId());
                ps.setString(5, u.getConstituency());
                ps.setBoolean(6, u.isActive());
                ps.setInt(7, u.getId());
            }
            ps.executeUpdate();
        }
    }

    /** Mark a voter as having voted. */
    public void markVoted(int userId) throws SQLException {
        String sql = "UPDATE users SET has_voted = 1 WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    /** Delete a user by id. */
    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    // ------------------------------------------------------------------
    // PRIVATE HELPERS
    // ------------------------------------------------------------------

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setFullName(rs.getString("full_name"));
        u.setUsername(rs.getString("username"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setRole(User.Role.valueOf(rs.getString("role")));
        u.setVoterId(rs.getString("voter_id"));
        u.setConstituency(rs.getString("constituency"));
        u.setHasVoted(rs.getBoolean("has_voted"));
        u.setActive(rs.getBoolean("is_active"));
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) u.setCreatedAt(ca.toLocalDateTime());
        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) u.setUpdatedAt(ua.toLocalDateTime());
        return u;
    }
}
