package com.dvs.model;

import java.time.LocalDateTime;

/**
 * User — represents Admin, Election Officer, or Voter.
 * Author: Dharshan Sathish Kumar | Reg: 3122255002029
 */
public class User {

    public enum Role { admin, officer, voter }

    private int           id;
    private String        fullName;
    private String        username;
    private String        passwordHash;
    private Role          role;
    private String        voterId;        // voters only
    private String        constituency;   // voters only
    private boolean       hasVoted;       // voters only
    private boolean       active;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // ---- Constructors ----
    public User() {}

    public User(int id, String fullName, String username, String passwordHash,
                Role role, String voterId, String constituency,
                boolean hasVoted, boolean active) {
        this.id           = id;
        this.fullName     = fullName;
        this.username     = username;
        this.passwordHash = passwordHash;
        this.role         = role;
        this.voterId      = voterId;
        this.constituency = constituency;
        this.hasVoted     = hasVoted;
        this.active       = active;
    }

    // ---- Getters & Setters ----
    public int           getId()           { return id; }
    public void          setId(int id)     { this.id = id; }

    public String        getFullName()              { return fullName; }
    public void          setFullName(String v)      { this.fullName = v; }

    public String        getUsername()              { return username; }
    public void          setUsername(String v)      { this.username = v; }

    public String        getPasswordHash()          { return passwordHash; }
    public void          setPasswordHash(String v)  { this.passwordHash = v; }

    public Role          getRole()                  { return role; }
    public void          setRole(Role v)            { this.role = v; }

    public String        getVoterId()               { return voterId; }
    public void          setVoterId(String v)       { this.voterId = v; }

    public String        getConstituency()          { return constituency; }
    public void          setConstituency(String v)  { this.constituency = v; }

    public boolean       isHasVoted()               { return hasVoted; }
    public void          setHasVoted(boolean v)     { this.hasVoted = v; }

    public boolean       isActive()                 { return active; }
    public void          setActive(boolean v)       { this.active = v; }

    public LocalDateTime getCreatedAt()             { return createdAt; }
    public void          setCreatedAt(LocalDateTime v) { this.createdAt = v; }

    public LocalDateTime getUpdatedAt()             { return updatedAt; }
    public void          setUpdatedAt(LocalDateTime v) { this.updatedAt = v; }

    /** Returns the first two initials of the full name (for avatar display). */
    public String getInitials() {
        if (fullName == null || fullName.isBlank()) return "?";
        String[] parts = fullName.trim().split("\\s+");
        StringBuilder sb = new StringBuilder();
        for (String p : parts) if (!p.isEmpty()) sb.append(p.charAt(0));
        return sb.toString().toUpperCase().substring(0, Math.min(2, sb.length()));
    }

    @Override
    public String toString() {
        return "User{id=" + id + ", username='" + username + "', role=" + role + "}";
    }
}
