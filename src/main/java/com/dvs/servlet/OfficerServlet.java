package com.dvs.servlet;

import com.dvs.dao.*;
import com.dvs.model.*;
import javax.servlet.*;
import javax.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * OfficerServlet — handles all /officer/* requests.
 * Routes: dashboard, candidates, voters, voting-control, counting, results, report
 * Author: Dharshan Sathish Kumar | Reg: 3122255002029
 */
public class OfficerServlet extends HttpServlet {

    private final UserDAO      userDAO      = new UserDAO();
    private final ElectionDAO  electionDAO  = new ElectionDAO();
    private final CandidateDAO candidateDAO = new CandidateDAO();
    private final VoteDAO      voteDAO      = new VoteDAO();
    private final AuditLogDAO  auditDAO     = new AuditLogDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isOfficer(req, resp)) return;

        String path = getPath(req);
        switch (path) {
            case "/dashboard"       -> officerDashboard(req, resp);
            case "/candidates"      -> officerCandidates(req, resp);
            case "/candidates/add"  -> showCandidateForm(req, resp, null);
            case "/candidates/edit" -> showCandidateForm(req, resp, req.getParameter("id"));
            case "/voters"          -> officerVoters(req, resp);
            case "/voting"          -> officerVoting(req, resp);
            case "/counting"        -> officerCounting(req, resp);
            case "/results"         -> officerResults(req, resp);
            case "/report"          -> officerReport(req, resp);
            default -> resp.sendRedirect(req.getContextPath() + "/officer/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isOfficer(req, resp)) return;

        String path = getPath(req);
        switch (path) {
            case "/candidates/save"   -> saveCandidate(req, resp);
            case "/candidates/delete" -> deleteCandidate(req, resp);
            case "/voting/status"     -> changeStatus(req, resp);
            case "/results/declare"   -> declareResults(req, resp);
            default -> resp.sendRedirect(req.getContextPath() + "/officer/dashboard");
        }
    }

    // ------------------------------------------------------------------
    // HANDLERS
    // ------------------------------------------------------------------

    private void officerDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Election election = electionDAO.findActive();
            List<User> voters = userDAO.findByRole("voter");
            long voted = voters.stream().filter(User::isHasVoted).count();
            int pct = voters.isEmpty() ? 0 : (int)(voted * 100 / voters.size());

            req.setAttribute("election",   election);
            req.setAttribute("voters",     voters);
            req.setAttribute("voted",      voted);
            req.setAttribute("pct",        pct);
            req.setAttribute("candidates", election != null ? candidateDAO.findByElection(election.getId()) : List.of());
            req.setAttribute("activeNav",  "dashboard");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/officer/dashboard.jsp").forward(req, resp);
    }

    private void officerCandidates(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Election election = electionDAO.findActive();
            req.setAttribute("election",   election);
            req.setAttribute("candidates", election != null ? candidateDAO.findByElection(election.getId()) : List.of());
            req.setAttribute("activeNav",  "candidates");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/officer/candidates.jsp").forward(req, resp);
    }

    private void showCandidateForm(HttpServletRequest req, HttpServletResponse resp, String idStr)
            throws ServletException, IOException {
        try {
            Election election = electionDAO.findActive();
            req.setAttribute("election", election);
            if (idStr != null && !idStr.isBlank()) {
                req.setAttribute("candidate", candidateDAO.findById(Integer.parseInt(idStr)));
            }
            req.setAttribute("activeNav", "candidates");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/officer/candidate-form.jsp").forward(req, resp);
    }

    private void saveCandidate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            String idStr       = req.getParameter("id");
            String name        = req.getParameter("fullName");
            String party       = req.getParameter("party");
            String symbol      = req.getParameter("symbol");
            String constit     = req.getParameter("constituency");
            int    ballotNum   = Integer.parseInt(req.getParameter("ballotNumber"));
            Election election  = electionDAO.findActive();
            User sessionUser   = (User) req.getSession().getAttribute("user");

            if (idStr == null || idStr.isBlank()) {
                Candidate c = new Candidate();
                c.setElectionId(election.getId());
                c.setFullName(name); c.setParty(party);
                c.setSymbol(symbol.isBlank() ? "🏛️" : symbol);
                c.setConstituency(constit); c.setBallotNumber(ballotNum);
                candidateDAO.insert(c);
                auditDAO.log("CANDIDATE_ADDED", "Candidate \"" + name + "\" added.", sessionUser.getId());
            } else {
                Candidate c = candidateDAO.findById(Integer.parseInt(idStr));
                c.setFullName(name); c.setParty(party);
                c.setSymbol(symbol.isBlank() ? c.getSymbol() : symbol);
                c.setConstituency(constit); c.setBallotNumber(ballotNum);
                candidateDAO.update(c);
                auditDAO.log("CANDIDATE_UPDATED", "Candidate \"" + name + "\" updated.", sessionUser.getId());
            }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/officer/candidates");
    }

    private void deleteCandidate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Candidate c = candidateDAO.findById(id);
            candidateDAO.delete(id);
            User sessionUser = (User) req.getSession().getAttribute("user");
            auditDAO.log("CANDIDATE_DELETED", "Candidate \"" + (c != null ? c.getFullName() : id) + "\" deleted.", sessionUser.getId());
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/officer/candidates");
    }

    private void officerVoters(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("voters",    userDAO.findByRole("voter"));
            req.setAttribute("activeNav", "voters");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/officer/voters.jsp").forward(req, resp);
    }

    private void officerVoting(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("election",   electionDAO.findActive());
            req.setAttribute("activeNav",  "voting");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/officer/voting-control.jsp").forward(req, resp);
    }

    private void changeStatus(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            String statusStr = req.getParameter("status");
            Election election = electionDAO.findActive();
            if (election != null) {
                Election.Status newStatus = Election.Status.valueOf(statusStr);
                electionDAO.updateStatus(election.getId(), newStatus);
                User sessionUser = (User) req.getSession().getAttribute("user");
                auditDAO.log("STATUS_CHANGED", "Election status changed to \"" + statusStr + "\".", sessionUser.getId());
            }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/officer/voting");
    }

    private void officerCounting(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Election election = electionDAO.findActive();
            List<Candidate> results = election != null
                    ? candidateDAO.findWithVoteCounts(election.getId()) : List.of();
            req.setAttribute("election",   election);
            req.setAttribute("results",    results);
            req.setAttribute("totalVotes", election != null ? voteDAO.getTotalVotes(election.getId()) : 0);
            req.setAttribute("activeNav",  "counting");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/officer/counting.jsp").forward(req, resp);
    }

    private void officerResults(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Election election = electionDAO.findActive();
            List<Candidate> results = election != null
                    ? candidateDAO.findWithVoteCounts(election.getId()) : List.of();
            req.setAttribute("election",   election);
            req.setAttribute("results",    results);
            req.setAttribute("totalVotes", election != null ? voteDAO.getTotalVotes(election.getId()) : 0);
            req.setAttribute("winner",     results.isEmpty() ? null : results.get(0));
            req.setAttribute("activeNav",  "results");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/officer/results.jsp").forward(req, resp);
    }

    private void declareResults(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            Election election = electionDAO.findActive();
            if (election != null) {
                electionDAO.updateStatus(election.getId(), Election.Status.declared);
                User sessionUser = (User) req.getSession().getAttribute("user");
                auditDAO.log("RESULTS_DECLARED", "Election results officially declared.", sessionUser.getId());
            }
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/officer/results");
    }

    private void officerReport(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Election election = electionDAO.findActive();
            List<Candidate> results = election != null
                    ? candidateDAO.findWithVoteCounts(election.getId()) : List.of();
            req.setAttribute("election",   election);
            req.setAttribute("results",    results);
            req.setAttribute("voters",     userDAO.findByRole("voter"));
            req.setAttribute("voted",      userDAO.countVoted());
            req.setAttribute("activeNav",  "report");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/officer/report.jsp").forward(req, resp);
    }

    // ------------------------------------------------------------------
    // HELPERS
    // ------------------------------------------------------------------

    private boolean isOfficer(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null || user.getRole() != User.Role.officer) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    private String getPath(HttpServletRequest req) {
        String pi = req.getPathInfo();
        return pi == null ? "/" : pi;
    }
}


