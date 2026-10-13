package com.dvs.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Election — represents a single election event.
 * Author: Dharshan Sathish Kumar | Reg: 3122255002029
 */
public class Election {

    public enum Status { open, closed, counting, declared }

    private int           id;
    private String        title;
    private String        description;
    private LocalDate     startDate;
    private LocalDate     endDate;
    private Status        status;
    private int           createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // candidate count (joined from query)
    private int candidateCount;
    // total vote count (joined from query)
    private int voteCount;

    public Election() {}

    // ---- Getters & Setters ----
    public int           getId()                    { return id; }
    public void          setId(int id)              { this.id = id; }

    public String        getTitle()                 { return title; }
    public void          setTitle(String v)         { this.title = v; }

    public String        getDescription()           { return description; }
    public void          setDescription(String v)   { this.description = v; }

    public LocalDate     getStartDate()             { return startDate; }
    public void          setStartDate(LocalDate v)  { this.startDate = v; }

    public LocalDate     getEndDate()               { return endDate; }
    public void          setEndDate(LocalDate v)    { this.endDate = v; }

    public Status        getStatus()                { return status; }
    public void          setStatus(Status v)        { this.status = v; }

    public int           getCreatedBy()             { return createdBy; }
    public void          setCreatedBy(int v)        { this.createdBy = v; }

    public LocalDateTime getCreatedAt()             { return createdAt; }
    public void          setCreatedAt(LocalDateTime v) { this.createdAt = v; }

    public LocalDateTime getUpdatedAt()             { return updatedAt; }
    public void          setUpdatedAt(LocalDateTime v) { this.updatedAt = v; }

    public int           getCandidateCount()        { return candidateCount; }
    public void          setCandidateCount(int v)   { this.candidateCount = v; }

    public int           getVoteCount()             { return voteCount; }
    public void          setVoteCount(int v)        { this.voteCount = v; }

    public String        getStatusLabel() {
        return switch (status) {
            case open      -> "Open";
            case closed    -> "Closed";
            case counting  -> "Counting";
            case declared  -> "Declared";
        };
    }

    /** Formatted start date string for JSPs (avoids JSTL 1.2/LocalDate issue). */
    public String getFormattedStartDate() {
        return startDate != null ? startDate.format(DateTimeFormatter.ofPattern("dd MMM yyyy")) : "";
    }

    /** Formatted end date string for JSPs (avoids JSTL 1.2/LocalDate issue). */
    public String getFormattedEndDate() {
        return endDate != null ? endDate.format(DateTimeFormatter.ofPattern("dd MMM yyyy")) : "";
    }
}
