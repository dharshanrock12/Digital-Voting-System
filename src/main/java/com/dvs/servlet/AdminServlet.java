package com.dvs.servlet;

import com.dvs.dao.*;
import com.dvs.model.*;
import javax.servlet.*;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 * AdminServlet — handles all /admin/* requests.
 * Routes: dashboard, users, elections, audit, report
 * Author: Dharshan Sathish Kumar | Reg: 3122255002029
 */
public class AdminServlet extends HttpServlet {

    private final UserDAO     userDAO     = new UserDAO();
    private final ElectionDAO electionDAO = new ElectionDAO();
    private final CandidateDAO candidateDAO = new CandidateDAO();
    private final AuditLogDAO auditDAO    = new AuditLogDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req, resp)) return;

        String path = getPath(req);
        switch (path) {
            case "/dashboard" -> adminDashboard(req, resp);
            case "/users"     -> adminUsers(req, resp);
            case "/users/add" -> req.getRequestDispatcher("/WEB-INF/views/admin/user-form.jsp").forward(req, resp);
            case "/users/edit"-> adminEditUser(req, resp);
            case "/elections" -> adminElections(req, resp);
            case "/audit"     -> adminAudit(req, resp);
            case "/report"    -> adminReport(req, resp);
            default           -> resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req, resp)) return;

        String path = getPath(req);
        switch (path) {
            case "/users/save"   -> adminSaveUser(req, resp);
            case "/users/delete" -> adminDeleteUser(req, resp);
            default -> resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    // ------------------------------------------------------------------
    // HANDLERS
    // ------------------------------------------------------------------

    private void adminDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<User>     users     = userDAO.findAll();
            List<Election> elections = electionDAO.findAll();
            List<AuditLog> recentLog = auditDAO.findRecent(8);
            int voted   = userDAO.countVoted();
            int voters  = userDAO.countVoters();

            req.setAttribute("users",     users);
            req.setAttribute("elections", elections);
            req.setAttribute("recentLog", recentLog);
            req.setAttribute("voted",     voted);
            req.setAttribute("voters",    voters);
            req.setAttribute("pct",       voters > 0 ? (voted * 100 / voters) : 0);
            req.setAttribute("activeNav", "dashboard");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }

    private void adminUsers(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("users",     userDAO.findAll());
            req.setAttribute("activeNav", "users");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
    }

    private void adminEditUser(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("editUser",  userDAO.findById(id));
            req.setAttribute("activeNav", "users");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/user-form.jsp").forward(req, resp);
    }

    private void adminSaveUser(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            String idStr    = req.getParameter("id");
            String name     = req.getParameter("fullName");
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            String role     = req.getParameter("role");
            String voterId  = req.getParameter("voterId");
            String constit  = req.getParameter("constituency");
            boolean active  = "on".equals(req.getParameter("active"));
            User sessionUser = (User) req.getSession().getAttribute("user");

            if (idStr == null || idStr.isBlank()) {
                // Insert
                User u = new User();
                u.setFullName(name); u.setUsername(username);
                u.setPasswordHash(password);
                u.setRole(User.Role.valueOf(role));
                u.setVoterId(voterId); u.setConstituency(constit);
                u.setActive(active); u.setHasVoted(false);
                userDAO.insert(u);
                auditDAO.log("USER_CREATED", "User \"" + name + "\" created.", sessionUser.getId());
            } else {
                // Update
                int id = Integer.parseInt(idStr);
                User u = userDAO.findById(id);
                u.setFullName(name); u.setUsername(username);
                u.setRole(User.Role.valueOf(role));
                u.setVoterId(voterId); u.setConstituency(constit);
                u.setActive(active);
                userDAO.update(u, password.isBlank() ? null : password);
                auditDAO.log("USER_UPDATED", "User \"" + name + "\" updated.", sessionUser.getId());
            }
        } catch (Exception e) {
            // on error just redirect
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    private void adminDeleteUser(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            User u = userDAO.findById(id);
            userDAO.delete(id);
            User sessionUser = (User) req.getSession().getAttribute("user");
            auditDAO.log("USER_DELETED", "User \"" + (u != null ? u.getFullName() : id) + "\" deleted.", sessionUser.getId());
        } catch (Exception ignored) {}
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    private void adminElections(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("elections", electionDAO.findAll());
            req.setAttribute("activeNav", "elections");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/elections.jsp").forward(req, resp);
    }

    private void adminAudit(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("logs",      auditDAO.findRecent(200));
            req.setAttribute("activeNav", "audit");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/audit.jsp").forward(req, resp);
    }

    private void adminReport(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("users",     userDAO.findAll());
            req.setAttribute("elections", electionDAO.findAll());
            req.setAttribute("voted",     userDAO.countVoted());
            req.setAttribute("voters",    userDAO.countVoters());
            req.setAttribute("logs",      auditDAO.findRecent(10));
            req.setAttribute("activeNav", "report");
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/report.jsp").forward(req, resp);
    }

    // ------------------------------------------------------------------
    // HELPERS
    // ------------------------------------------------------------------

    private boolean isAdmin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null || user.getRole() != User.Role.admin) {
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


