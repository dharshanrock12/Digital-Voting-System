package com.dvs.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * AuditLog — immutable audit trail entry.
 * Author: Dharshan Sathish Kumar | Reg: 3122255002029
 */
public class AuditLog {

    private int           id;
    private String        action;
    private String        message;
    private Integer       performedBy;   // nullable (SYSTEM events)
    private String        performedByName; // joined display name
    private LocalDateTime performedAt;

    public AuditLog() {}

    public AuditLog(String action, String message, Integer performedBy) {
        this.action      = action;
        this.message     = message;
        this.performedBy = performedBy;
        this.performedAt = LocalDateTime.now();
    }

    // ---- Getters & Setters ----
    public int           getId()                         { return id; }
    public void          setId(int id)                   { this.id = id; }

    public String        getAction()                     { return action; }
    public void          setAction(String v)             { this.action = v; }

    public String        getMessage()                    { return message; }
    public void          setMessage(String v)            { this.message = v; }

    public Integer       getPerformedBy()                { return performedBy; }
    public void          setPerformedBy(Integer v)       { this.performedBy = v; }

    public String        getPerformedByName()            { return performedByName; }
    public void          setPerformedByName(String v)    { this.performedByName = v; }

    public LocalDateTime getPerformedAt()                { return performedAt; }
    public void          setPerformedAt(LocalDateTime v) { this.performedAt = v; }

    /** Returns formatted date string for use in JSPs (avoids JSTL 1.2 / LocalDateTime incompatibility). */
    public String getFormattedAt() {
        if (performedAt == null) return "";
        return performedAt.format(DateTimeFormatter.ofPattern("dd-MMM-yyyy HH:mm"));
    }
}
