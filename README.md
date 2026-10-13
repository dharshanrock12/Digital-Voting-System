# 🗳️ Digital Voting System (DVS)

> **Author:** Dharshan Sathish Kumar  
> **Register Number:** 3122255002029  
> **Project:** Software Engineering & Project Planning (PSEP)

A fully functional **Digital Voting System** built with **Java 17 + MySQL + Apache Tomcat** following the Waterfall SDLC model.

---

## 📋 Tech Stack (as per SPP)

| Component        | Technology                       |
|------------------|----------------------------------|
| Language         | Java 17 (JDK 17)                 |
| Web Framework    | Jakarta Servlets + JSP (EE 10)   |
| Database         | MySQL 8                          |
| Web Server       | Apache Tomcat 10+                |
| Build Tool       | Apache Maven 3.9+                |
| CSS              | Vanilla CSS (Dark Theme)         |
| IDE              | Eclipse / IntelliJ IDEA          |
| OS               | Windows / Linux                  |

---

## 🏗️ Project Structure

```
Digital-Voting-System/
├── pom.xml                              ← Maven build file
├── sql/
│   └── schema.sql                       ← MySQL schema + seed data
├── src/main/
│   ├── java/com/dvs/
│   │   ├── model/                       ← POJOs
│   │   │   ├── User.java
│   │   │   ├── Election.java
│   │   │   ├── Candidate.java
│   │   │   └── AuditLog.java
│   │   ├── dao/                         ← Database Access Objects
│   │   │   ├── UserDAO.java
│   │   │   ├── ElectionDAO.java
│   │   │   ├── CandidateDAO.java
│   │   │   ├── VoteDAO.java
│   │   │   └── AuditLogDAO.java
│   │   ├── servlet/                     ← Jakarta Servlets (Controllers)
│   │   │   ├── LoginServlet.java        → /login
│   │   │   ├── LogoutServlet.java       → /logout
│   │   │   ├── AdminServlet.java        → /admin/*
│   │   │   ├── OfficerServlet.java      → /officer/*
│   │   │   └── VoterServlet.java        → /voter/*
│   │   └── util/
│   │       └── DBConnection.java        ← JDBC connection helper
│   ├── resources/
│   │   └── db.properties               ← DB credentials (edit this)
│   └── webapp/
│       ├── index.jsp                    ← Redirects to /login
│       ├── css/style.css               ← Global dark-theme stylesheet
│       ├── js/app.js                   ← Client-side JS
│       └── WEB-INF/
│           ├── web.xml                  ← Deployment descriptor
│           └── views/
│               ├── login.jsp
│               ├── header.jsp           ← Shared sidebar/header
│               ├── footer.jsp           ← Shared footer
│               ├── error.jsp
│               ├── admin/              ← Admin views
│               │   ├── dashboard.jsp
│               │   ├── users.jsp
│               │   ├── user-form.jsp
│               │   ├── elections.jsp
│               │   ├── audit.jsp
│               │   └── report.jsp
│               ├── officer/            ← Election Officer views
│               │   ├── dashboard.jsp
│               │   ├── candidates.jsp
│               │   ├── candidate-form.jsp
│               │   ├── voters.jsp
│               │   ├── voting-control.jsp
│               │   ├── counting.jsp
│               │   ├── results.jsp
│               │   └── report.jsp
│               └── voter/              ← Voter views
│                   ├── dashboard.jsp
│                   ├── ballot.jsp
│                   └── results.jsp
```

---

## ⚙️ Setup Instructions

### Prerequisites

- ✅ JDK 17 installed
- ✅ Apache Tomcat 10+ installed
- ✅ MySQL 8 running
- ✅ Maven 3.9+ installed (or use Eclipse/IntelliJ's built-in Maven)

---

### Step 1 — Set Up MySQL Database

Open MySQL Workbench (or MySQL CLI) and run:

```sql
source path/to/sql/schema.sql
```

Or copy and paste the contents of [`sql/schema.sql`](sql/schema.sql) into MySQL Workbench and execute.

This creates the `dvs_db` database with all tables and inserts demo seed data.

---

### Step 2 — Configure Database Connection

Edit [`src/main/resources/db.properties`](src/main/resources/db.properties):

```properties
db.url=jdbc:mysql://localhost:3306/dvs_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
db.username=root
db.password=YOUR_MYSQL_PASSWORD_HERE
db.driver=com.mysql.cj.jdbc.Driver
```

---

### Step 3 — Build the WAR

```bash
mvn clean package
```

This produces `target/digital-voting-system.war`.

---

### Step 4 — Deploy to Tomcat

1. Copy `target/digital-voting-system.war` → `<TOMCAT_HOME>/webapps/`
2. Start Tomcat: `<TOMCAT_HOME>/bin/startup.bat` (Windows)
3. Open browser: **http://localhost:8080/digital-voting-system**

> Or in **Eclipse**: Right-click project → Run As → Run on Server → select Tomcat 10.

---

### Step 5 — Import in Eclipse / IntelliJ IDEA

**Eclipse:**
1. File → Import → Existing Maven Projects
2. Browse to project root → Finish
3. Right-click project → Properties → Project Facets → Enable Dynamic Web Module (6.0) + Java (17)
4. Add Tomcat server → Run on Server

**IntelliJ IDEA:**
1. File → Open → select `pom.xml`
2. Open as Project
3. Run → Edit Configurations → Add Tomcat Server → Local
4. Deployment tab → Add artifact → `digital-voting-system:war`
5. Run

---

## 🔐 Default Login Credentials

| Role             | Username  | Password    |
|------------------|-----------|-------------|
| Administrator    | `admin`   | `admin123`  |
| Election Officer | `officer` | `officer123`|
| Voter 1          | `voter1`  | `voter123`  |
| Voter 2          | `voter2`  | `voter123`  |
| Voter 3          | `voter3`  | `voter123`  |

> **Passwords are BCrypt-hashed in the database** — plain-text is never stored.

---

## 🗺️ URL Routes

| URL                            | Description                  | Access    |
|--------------------------------|------------------------------|-----------|
| `/login`                       | Role selection & login        | Public    |
| `/logout`                      | Logout                        | All       |
| `/admin/dashboard`             | Admin overview                | Admin     |
| `/admin/users`                 | Manage users                  | Admin     |
| `/admin/elections`             | View elections                | Admin     |
| `/admin/audit`                 | Audit log                     | Admin     |
| `/admin/report`                | System report                 | Admin     |
| `/officer/dashboard`           | Officer overview              | Officer   |
| `/officer/candidates`          | Manage ballot candidates      | Officer   |
| `/officer/voters`              | View voter list               | Officer   |
| `/officer/voting`              | Open/close voting session     | Officer   |
| `/officer/counting`            | Vote counting                 | Officer   |
| `/officer/results`             | Declare results               | Officer   |
| `/officer/report`              | Election report               | Officer   |
| `/voter/dashboard`             | Voter home                    | Voter     |
| `/voter/ballot`                | View ballot & cast vote       | Voter     |
| `/voter/results`               | View declared results         | Voter     |

---

## ✅ Functional Requirements Coverage

| SPP Requirement                     | Status |
|-------------------------------------|--------|
| Admin Login                         | ✅     |
| Election Officer Login              | ✅     |
| Voter Login                         | ✅     |
| Manage Users (CRUD)                 | ✅     |
| Manage Election Officers            | ✅     |
| Add/Update/Delete Candidates        | ✅     |
| Open / Close Voting                 | ✅     |
| Voter Authentication                | ✅     |
| Vote Casting (with dupe prevention) | ✅     |
| Vote Counting                       | ✅     |
| Declare Results                     | ✅     |
| View Election Results               | ✅     |
| Generate Reports                    | ✅     |
| Audit Log                           | ✅     |
| Encrypted Passwords (BCrypt)        | ✅     |
| Role-based Access Control           | ✅     |
| Database (MySQL)                    | ✅     |

---

## 🔒 Security Features

- **BCrypt password hashing** (cost factor 12) — no plain-text storage
- **Anonymous votes** — votes table has no voter ID column; only the `has_voted` flag is set on the user
- **Duplicate vote prevention** — enforced both in servlet logic and DB flag
- **Role-based access control** — each servlet checks session role before serving content
- **Session timeout** — 30-minute idle timeout configured in `web.xml`
- **JSTL `<c:out>`** — all user data output is HTML-escaped to prevent XSS

---

## 📊 Database Schema

```
users ──────────┐
                │ (created_by)
elections ──────┤
                │ (election_id)
candidates ─────┤
                │ (election_id, candidate_id)
votes ──────────┘
audit_log  (performed_by → users)
results    (election_id, winner_id, declared_by)
```

---

*Digital Voting System — PSEP Project | Dharshan Sathish Kumar | 3122255002029*