package com.dvs.dao;

import com.dvs.util.DBConnection;

import java.sql.*;

/**
 * VoteDAO — handles vote casting and counting.
 * Author: Dharshan Sathish Kumar | Reg: 3122255002029
 */
public class VoteDAO {

    /**
     * Cast a vote for the given candidate in the given election.
     * Returns true if the vote was recorded successfully.
     */
    public boolean castVote(int electionId, int candidateId) throws SQLException {
        String sql = "INSERT INTO votes (election_id, candidate_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, electionId);
            ps.setInt(2, candidateId);
            return ps.executeUpdate() == 1;
        }
    }

    /** Return total votes cast for an election. */
    public int getTotalVotes(int electionId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM votes WHERE election_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, electionId);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}
