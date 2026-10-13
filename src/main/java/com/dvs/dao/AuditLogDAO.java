package com.dvs.dao;

import com.dvs.model.AuditLog;
import com.dvs.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * AuditLogDAO — insert and retrieve system audit log entries.
 * Author: Dharshan Sathish Kumar | Reg: 3122255002029
 */
public class AuditLogDAO {

    /**
     * Insert a new audit log entry.
     *
     * @param action      Short action code (e.g. "LOGIN", "VOTE_CAST")
     * @param message     Human-readable description
     * @param performedBy User ID of the actor, or null for SYSTEM events
     */
    public void log(String action, String message, Integer performedBy) throws SQLException {
        String sql = "INSERT INTO audit_log (action, message, performed_by) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, action);
            ps.setString(2, message);
            if (performedBy != null) ps.setInt(3, performedBy);
            else                     ps.setNull(3, Types.INTEGER);
            ps.executeUpdate();
        }
    }

    /**
     * Return the most recent audit entries, newest first.
     *
     * @param limit maximum number of entries to return
     */
    public List<AuditLog> findRecent(int limit) throws SQLException {
        List<AuditLog> list = new ArrayList<>();
        String sql = """
                SELECT al.*, u.full_name AS performed_by_name
                FROM   audit_log al
                LEFT JOIN users u ON u.id = al.performed_by
                ORDER BY al.performed_at DESC
                LIMIT ?
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                AuditLog a = new AuditLog();
                a.setId(rs.getInt("id"));
                a.setAction(rs.getString("action"));
                a.setMessage(rs.getString("message"));
                int pb = rs.getInt("performed_by");
                a.setPerformedBy(rs.wasNull() ? null : pb);
                a.setPerformedByName(rs.getString("performed_by_name"));
                Timestamp ts = rs.getTimestamp("performed_at");
                if (ts != null) a.setPerformedAt(ts.toLocalDateTime());
                list.add(a);
            }
        }
        return list;
    }

    /** Total number of entries in the audit log. */
    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM audit_log";
        try (Connection conn = DBConnection.getConnection();
             Statement  st   = conn.createStatement();
             ResultSet  rs   = st.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}
