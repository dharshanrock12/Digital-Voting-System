package com.dvs.servlet;

import com.dvs.dao.*;
import com.dvs.model.*;
import javax.servlet.*;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 * VoterServlet — handles all /voter/* requests.
 * Routes: dashboard, ballot, cast-vote, results
 * Author: Dharshan Sathish Kumar | Reg: 3122255002029
 */
public class VoterServlet extends HttpServlet {

    private final UserDAO      userDAO      = new UserDAO();
    private final ElectionDAO  electionDAO  = new ElectionDAO();
    private final CandidateDAO candidateDAO = new CandidateDAO();
    private final VoteDAO      voteDAO      = new VoteDAO();
    private final AuditLogDAO  auditDAO     = new AuditLogDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isVoter(req, resp)) return;

        String path = getPath(req);
        switch (path) {
            case "/dashboard" -> voterDashboard(req, resp);
            case "/ballot"    -> voterBallot(req, resp);
            case "/results"   -> voterResults(req, resp);
            default -> resp.sendRedirect(req.getContextPath() + "/voter/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isVoter(req, resp)) return;

        String path = getPath(req);
        if ("/cast".equals(path)) {
            castVote(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/voter/dashboard");
        }
    }

    // ------------------------------------------------------------------
    // HANDLERS
    // ------------------------------------------------------------------

    private void voterDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Election election = electionDAO.findActive();
            req.setAttribute("election",  election);
            req.setAttribute("activeNav", "dashboard");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/voter/dashboard.jsp").forward(req, resp);
    }

    private void voterBallot(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User voter = (User) req.getSession().getAttribute("user");

        // Guard: already voted
        if (voter.isHasVoted()) {
            req.setAttribute("alreadyVoted", true);
            req.getRequestDispatcher("/WEB-INF/views/voter/ballot.jsp").forward(req, resp);
            return;
        }

        try {
            Election election = electionDAO.findActive();
            if (election == null || election.getStatus() != Election.Status.open) {
                req.setAttribute("votingClosed", true);
                req.setAttribute("election", election);
            } else {
                List<Candidate> candidates = candidateDAO
                        .findByElectionAndConstituency(election.getId(), voter.getConstituency());
                req.setAttribute("election",   election);
                req.setAttribute("candidates", candidates);
            }
            req.setAttribute("activeNav", "ballot");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/voter/ballot.jsp").forward(req, resp);
    }

    private void castVote(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        User voter = (User) req.getSession().getAttribute("user");

        // Duplicate vote guard
        try {
            User fresh = userDAO.findById(voter.getId());
            if (fresh == null || fresh.isHasVoted()) {
                resp.sendRedirect(req.getContextPath() + "/voter/ballot?err=duplicate");
                return;
            }

            Election election = electionDAO.findActive();
            if (election == null || election.getStatus() != Election.Status.open) {
                resp.sendRedirect(req.getContextPath() + "/voter/ballot?err=closed");
                return;
            }

            int candidateId = Integer.parseInt(req.getParameter("candidateId"));
            Candidate candidate = candidateDAO.findById(candidateId);

            if (candidate == null || candidate.getElectionId() != election.getId()) {
                resp.sendRedirect(req.getContextPath() + "/voter/ballot?err=invalid");
                return;
            }

            // Record the vote (anonymous — no voter link in votes table)
            voteDAO.castVote(election.getId(), candidateId);

            // Mark voter as having voted
            userDAO.markVoted(voter.getId());

            // Update session
            fresh.setHasVoted(true);
            req.getSession().setAttribute("user", fresh);

            auditDAO.log("VOTE_CAST", "Vote cast for election #" + election.getId() + ".", voter.getId());

            resp.sendRedirect(req.getContextPath() + "/voter/dashboard?voted=1");

        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/voter/ballot?err=system");
        }
    }

    private void voterResults(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Election election = electionDAO.findActive();
            List<Candidate> results = null;
            int totalVotes = 0;

            if (election != null && election.getStatus() == Election.Status.declared) {
                results    = candidateDAO.findWithVoteCounts(election.getId());
                totalVotes = voteDAO.getTotalVotes(election.getId());
            }

            req.setAttribute("election",   election);
            req.setAttribute("results",    results);
            req.setAttribute("totalVotes", totalVotes);
            req.setAttribute("winner",     (results != null && !results.isEmpty()) ? results.get(0) : null);
            req.setAttribute("activeNav",  "results");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/voter/results.jsp").forward(req, resp);
    }

    // ------------------------------------------------------------------
    // HELPERS
    // ------------------------------------------------------------------

    private boolean isVoter(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null || user.getRole() != User.Role.voter) {
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


