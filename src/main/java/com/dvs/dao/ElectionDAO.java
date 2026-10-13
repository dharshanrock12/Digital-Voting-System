package com.dvs.dao;

import com.dvs.model.Election;
import com.dvs.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ElectionDAO — handles all database operations for the elections table.
 * Author: Dharshan Sathish Kumar | Reg: 3122255002029
 */
public class ElectionDAO {

    // ------------------------------------------------------------------
    // READ
    // ------------------------------------------------------------------

    /** Find election by primary key (with candidate + vote counts). */
    public Election findById(int id) throws SQLException {
        String sql = """
                SELECT e.*,
                       (SELECT COUNT(*) FROM candidates c WHERE c.election_id = e.id) AS candidate_count,
                       (SELECT COUNT(*) FROM votes     v WHERE v.election_id = e.id) AS vote_count
                FROM elections e WHERE e.id = ?
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        }
    }

    /** Return all elections with counts. */
    public List<Election> findAll() throws SQLException {
        List<Election> list = new ArrayList<>();
        String sql = """
                SELECT e.*,
                       (SELECT COUNT(*) FROM candidates c WHERE c.election_id = e.id) AS candidate_count,
                       (SELECT COUNT(*) FROM votes     v WHERE v.election_id = e.id) AS vote_count
                FROM elections e ORDER BY e.id DESC
                """;
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Return the active/latest election. */
    public Election findActive() throws SQLException {
        List<Election> all = findAll();
        return all.isEmpty() ? null : all.get(0);
    }

    // ------------------------------------------------------------------
    // WRITE
    // ------------------------------------------------------------------

    /** Insert a new election and return generated id. */
    public int insert(Election e) throws SQLException {
        String sql = """
                INSERT INTO elections (title, description, start_date, end_date, status, created_by)
                VALUES (?, ?, ?, ?, ?, ?)
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, e.getTitle());
            ps.setString(2, e.getDescription());
            ps.setDate(3, Date.valueOf(e.getStartDate()));
            ps.setDate(4, Date.valueOf(e.getEndDate()));
            ps.setString(5, e.getStatus().name());
            ps.setInt(6, e.getCreatedBy());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            return keys.next() ? keys.getInt(1) : -1;
        }
    }

    /** Update election details. */
    public void update(Election e) throws SQLException {
        String sql = """
                UPDATE elections SET title=?, description=?, start_date=?, end_date=? WHERE id=?
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, e.getTitle());
            ps.setString(2, e.getDescription());
            ps.setDate(3, Date.valueOf(e.getStartDate()));
            ps.setDate(4, Date.valueOf(e.getEndDate()));
            ps.setInt(5, e.getId());
            ps.executeUpdate();
        }
    }

    /** Change the election status (open / closed / counting / declared). */
    public void updateStatus(int electionId, Election.Status status) throws SQLException {
        String sql = "UPDATE elections SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setInt(2, electionId);
            ps.executeUpdate();
        }
    }

    // ------------------------------------------------------------------
    // PRIVATE HELPERS
    // ------------------------------------------------------------------

    private Election mapRow(ResultSet rs) throws SQLException {
        Election e = new Election();
        e.setId(rs.getInt("id"));
        e.setTitle(rs.getString("title"));
        e.setDescription(rs.getString("description"));
        Date sd = rs.getDate("start_date");
        if (sd != null) e.setStartDate(sd.toLocalDate());
        Date ed = rs.getDate("end_date");
        if (ed != null) e.setEndDate(ed.toLocalDate());
        e.setStatus(Election.Status.valueOf(rs.getString("status")));
        e.setCreatedBy(rs.getInt("created_by"));
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) e.setCreatedAt(ca.toLocalDateTime());
        Timestamp ua = rs.getTimestamp("updated_at");
        if (ua != null) e.setUpdatedAt(ua.toLocalDateTime());
        try { e.setCandidateCount(rs.getInt("candidate_count")); } catch (SQLException ignored) {}
        try { e.setVoteCount(rs.getInt("vote_count")); } catch (SQLException ignored) {}
        return e;
    }
}
