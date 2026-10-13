package com.dvs.dao;

import com.dvs.model.Candidate;
import com.dvs.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CandidateDAO — handles all database operations for the candidates table.
 * Author: Dharshan Sathish Kumar | Reg: 3122255002029
 */
public class CandidateDAO {

    // ------------------------------------------------------------------
    // READ
    // ------------------------------------------------------------------

    /** Find a candidate by primary key. */
    public Candidate findById(int id) throws SQLException {
        String sql = "SELECT * FROM candidates WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        }
    }

    /** Return all candidates for a given election. */
    public List<Candidate> findByElection(int electionId) throws SQLException {
        List<Candidate> list = new ArrayList<>();
        String sql = "SELECT * FROM candidates WHERE election_id = ? ORDER BY constituency, ballot_number";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, electionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Return candidates for a specific election AND constituency. */
    public List<Candidate> findByElectionAndConstituency(int electionId, String constituency) throws SQLException {
        List<Candidate> list = new ArrayList<>();
        String sql = "SELECT * FROM candidates WHERE election_id = ? AND constituency = ? ORDER BY ballot_number";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, electionId);
            ps.setString(2, constituency);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /**
     * Return candidates with their vote counts (for counting/results).
     * Results are ordered by vote count descending.
     */
    public List<Candidate> findWithVoteCounts(int electionId) throws SQLException {
        List<Candidate> list = new ArrayList<>();
        String sql = """
                SELECT c.*, COUNT(v.id) AS vote_count
                FROM candidates c
                LEFT JOIN votes v ON v.candidate_id = c.id AND v.election_id = c.election_id
                WHERE c.election_id = ?
                GROUP BY c.id
                ORDER BY vote_count DESC
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, electionId);
            ResultSet rs = ps.executeQuery();

            int totalVotes = getTotalVotes(electionId);
            int rank = 1;
            while (rs.next()) {
                Candidate c = mapRow(rs);
                int vc = rs.getInt("vote_count");
                c.setVoteCount(vc);
                c.setVotePercentage(totalVotes > 0 ? (vc * 100.0 / totalVotes) : 0);
                c.setRank(rank++);
                list.add(c);
            }
        }
        return list;
    }

    private int getTotalVotes(int electionId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM votes WHERE election_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, electionId);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ------------------------------------------------------------------
    // WRITE
    // ------------------------------------------------------------------

    /** Insert a new candidate and return generated id. */
    public int insert(Candidate c) throws SQLException {
        String sql = """
                INSERT INTO candidates (election_id, full_name, party, symbol, constituency, ballot_number)
                VALUES (?, ?, ?, ?, ?, ?)
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, c.getElectionId());
            ps.setString(2, c.getFullName());
            ps.setString(3, c.getParty());
            ps.setString(4, c.getSymbol());
            ps.setString(5, c.getConstituency());
            ps.setInt(6, c.getBallotNumber());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            return keys.next() ? keys.getInt(1) : -1;
        }
    }

    /** Update a candidate's details. */
    public void update(Candidate c) throws SQLException {
        String sql = """
                UPDATE candidates
                SET full_name=?, party=?, symbol=?, constituency=?, ballot_number=?
                WHERE id=?
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getFullName());
            ps.setString(2, c.getParty());
            ps.setString(3, c.getSymbol());
            ps.setString(4, c.getConstituency());
            ps.setInt(5, c.getBallotNumber());
            ps.setInt(6, c.getId());
            ps.executeUpdate();
        }
    }

    /** Delete a candidate by id. */
    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM candidates WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    // ------------------------------------------------------------------
    // PRIVATE HELPERS
    // ------------------------------------------------------------------

    private Candidate mapRow(ResultSet rs) throws SQLException {
        Candidate c = new Candidate();
        c.setId(rs.getInt("id"));
        c.setElectionId(rs.getInt("election_id"));
        c.setFullName(rs.getString("full_name"));
        c.setParty(rs.getString("party"));
        c.setSymbol(rs.getString("symbol"));
        c.setConstituency(rs.getString("constituency"));
        c.setBallotNumber(rs.getInt("ballot_number"));
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) c.setCreatedAt(ca.toLocalDateTime());
        return c;
    }
}
