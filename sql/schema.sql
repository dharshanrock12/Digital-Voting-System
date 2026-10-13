-- ============================================================
-- Digital Voting System — MySQL Database Schema
-- Author: Dharshan Sathish Kumar | Reg: 3122255002029
-- Run this script in MySQL before starting the application.
-- ============================================================

CREATE DATABASE IF NOT EXISTS dvs_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE dvs_db;

-- -------------------------------------------------------
-- TABLE: users
-- Stores Admin, Election Officer, and Voter accounts
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    full_name       VARCHAR(100)  NOT NULL,
    username        VARCHAR(50)   NOT NULL UNIQUE,
    password_hash   VARCHAR(255)  NOT NULL,
    role            ENUM('admin','officer','voter') NOT NULL,
    voter_id        VARCHAR(30)   NULL UNIQUE,
    constituency    VARCHAR(100)  NULL,
    has_voted       TINYINT(1)    NOT NULL DEFAULT 0,
    is_active       TINYINT(1)    NOT NULL DEFAULT 1,
    created_at      TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- -------------------------------------------------------
-- TABLE: elections
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS elections (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    title           VARCHAR(200)  NOT NULL,
    description     TEXT,
    start_date      DATE          NOT NULL,
    end_date        DATE          NOT NULL,
    status          ENUM('open','closed','counting','declared') NOT NULL DEFAULT 'closed',
    created_by      INT           NOT NULL,
    created_at      TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- -------------------------------------------------------
-- TABLE: candidates
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS candidates (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    election_id     INT           NOT NULL,
    full_name       VARCHAR(100)  NOT NULL,
    party           VARCHAR(150)  NOT NULL,
    symbol          VARCHAR(10)   DEFAULT '🏛️',
    constituency    VARCHAR(100)  NOT NULL,
    ballot_number   INT           NOT NULL,
    created_at      TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (election_id) REFERENCES elections(id) ON DELETE CASCADE,
    UNIQUE KEY uq_election_constituency_number (election_id, constituency, ballot_number)
);

-- -------------------------------------------------------
-- TABLE: votes
-- Each row = one anonymous vote (no voter link stored)
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS votes (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    election_id     INT           NOT NULL,
    candidate_id    INT           NOT NULL,
    voted_at        TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (election_id)  REFERENCES elections(id)  ON DELETE CASCADE,
    FOREIGN KEY (candidate_id) REFERENCES candidates(id) ON DELETE CASCADE
);

-- -------------------------------------------------------
-- TABLE: audit_log
-- Full audit trail of all system events
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS audit_log (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    action          VARCHAR(100)  NOT NULL,
    message         TEXT          NOT NULL,
    performed_by    INT           NULL,
    performed_at    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (performed_by) REFERENCES users(id) ON DELETE SET NULL
);

-- -------------------------------------------------------
-- TABLE: results
-- Stores final declared results
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS results (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    election_id     INT           NOT NULL UNIQUE,
    winner_id       INT           NOT NULL,
    declared_by     INT           NOT NULL,
    declared_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (election_id) REFERENCES elections(id),
    FOREIGN KEY (winner_id)   REFERENCES candidates(id),
    FOREIGN KEY (declared_by) REFERENCES users(id)
);

-- ============================================================
-- SEED DATA
-- ============================================================

-- Default Admin (password: admin123)
INSERT INTO users (full_name, username, password_hash, role)
VALUES ('Admin User', 'admin',
        '$2a$12$KIXkrT.dGzmYkSSfPQ.mGOZnnIiDLjIa9iKHPAhq16nE29C2B8JLW',
        'admin')
ON DUPLICATE KEY UPDATE id=id;

-- Default Election Officer (password: officer123)
INSERT INTO users (full_name, username, password_hash, role)
VALUES ('Election Officer', 'officer',
        '$2a$12$dHZKVgBh7HgCVFluIVXMm.vBGxQVW.9m5Z/mF1PF30aw2L4OHIzZC',
        'officer')
ON DUPLICATE KEY UPDATE id=id;

-- Sample Voters (password: voter123)
INSERT INTO users (full_name, username, password_hash, role, voter_id, constituency)
VALUES
  ('Arjun Kumar',  'voter1', '$2a$12$5qUdv7mL3xMQHPJsmK5NaOIHBq5VBbBVs0VHQZ1gj0M4Q0AJpDNXu', 'voter', 'ECI-001', 'Ward-1'),
  ('Priya Sharma', 'voter2', '$2a$12$5qUdv7mL3xMQHPJsmK5NaOIHBq5VBbBVs0VHQZ1gj0M4Q0AJpDNXu', 'voter', 'ECI-002', 'Ward-1'),
  ('Ravi Verma',   'voter3', '$2a$12$5qUdv7mL3xMQHPJsmK5NaOIHBq5VBbBVs0VHQZ1gj0M4Q0AJpDNXu', 'voter', 'ECI-003', 'Ward-2')
ON DUPLICATE KEY UPDATE id=id;

-- Sample Election (created_by = admin id=1)
INSERT INTO elections (title, description, start_date, end_date, status, created_by)
VALUES ('General Assembly Election 2026',
        'Annual general election for all constituencies.',
        '2026-10-01', '2026-10-31', 'open', 1)
ON DUPLICATE KEY UPDATE id=id;

-- Sample Candidates for election_id = 1
INSERT INTO candidates (election_id, full_name, party, symbol, constituency, ballot_number)
VALUES
  (1, 'Vikram Singh',  'National Progress Party', '🌟', 'Ward-1', 1),
  (1, 'Meera Pillai',  'People''s Alliance',      '🌸', 'Ward-1', 2),
  (1, 'Suresh Nair',   'Democratic Front',        '⚡', 'Ward-1', 3),
  (1, 'Anita Desai',   'Green Future Party',      '🌿', 'Ward-2', 1),
  (1, 'Rajesh Gupta',  'National Progress Party', '🌟', 'Ward-2', 2)
ON DUPLICATE KEY UPDATE id=id;

-- Initial audit entry
INSERT INTO audit_log (action, message, performed_by)
VALUES ('SYSTEM_INIT', 'Digital Voting System database initialized.', NULL);
