package com.dvs.model;

import java.time.LocalDateTime;

/**
 * Candidate — represents a candidate on the ballot.
 * Author: Dharshan Sathish Kumar | Reg: 3122255002029
 */
public class Candidate {

    private int           id;
    private int           electionId;
    private String        fullName;
    private String        party;
    private String        symbol;
    private String        constituency;
    private int           ballotNumber;
    private LocalDateTime createdAt;

    // Computed (from vote counting query)
    private int           voteCount;
    private double        votePercentage;
    private int           rank;

    public Candidate() {}

    // ---- Getters & Setters ----
    public int           getId()                     { return id; }
    public void          setId(int id)               { this.id = id; }

    public int           getElectionId()             { return electionId; }
    public void          setElectionId(int v)        { this.electionId = v; }

    public String        getFullName()               { return fullName; }
    public void          setFullName(String v)       { this.fullName = v; }

    public String        getParty()                  { return party; }
    public void          setParty(String v)          { this.party = v; }

    public String        getSymbol()                 { return symbol; }
    public void          setSymbol(String v)         { this.symbol = v; }

    public String        getConstituency()           { return constituency; }
    public void          setConstituency(String v)   { this.constituency = v; }

    public int           getBallotNumber()           { return ballotNumber; }
    public void          setBallotNumber(int v)      { this.ballotNumber = v; }

    public LocalDateTime getCreatedAt()              { return createdAt; }
    public void          setCreatedAt(LocalDateTime v) { this.createdAt = v; }

    public int           getVoteCount()              { return voteCount; }
    public void          setVoteCount(int v)         { this.voteCount = v; }

    public double        getVotePercentage()         { return votePercentage; }
    public void          setVotePercentage(double v) { this.votePercentage = v; }

    public int           getRank()                   { return rank; }
    public void          setRank(int v)              { this.rank = v; }

    /** Returns the display name with symbol. */
    public String getDisplayName() {
        return (symbol != null ? symbol + " " : "") + fullName;
    }

    /** Returns vote percentage formatted to 1 decimal place (for JSPs). */
    public String getFormattedPercentage() {
        return String.format("%.1f", votePercentage);
    }

    /** Returns vote percentage rounded to nearest integer (for progress bars in JSPs). */
    public int getPercentageRounded() {
        return (int) Math.round(votePercentage);
    }
}
