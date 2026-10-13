package com.dvs.servlet;

import com.dvs.dao.UserDAO;
import com.dvs.model.User;
import javax.servlet.*;
import javax.servlet.http.*;

import java.io.IOException;

/**
 * LoginServlet — handles GET (show form) and POST (authenticate).
 * Mapped to /login
 * Author: Dharshan Sathish Kumar | Reg: 3122255002029
 */
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    /** Show the login page. */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // If already logged in, redirect to dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            redirectToDashboard((User) session.getAttribute("user"), resp);
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    /** Process login form submission. */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String role     = req.getParameter("role");

        if (username == null || password == null || role == null
                || username.isBlank() || password.isBlank() || role.isBlank()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        try {
            User user = userDAO.authenticate(username.trim(), password, role.trim());
            if (user == null) {
                req.setAttribute("error", "Invalid credentials or account inactive.");
                req.setAttribute("selectedRole", role);
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return;
            }
            // Create session
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            redirectToDashboard(user, resp);

        } catch (Exception e) {
            req.setAttribute("error", "System error. Please try again. (" + e.getMessage() + ")");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }

    private void redirectToDashboard(User user, HttpServletResponse resp) throws IOException {
        String ctx = resp.encodeRedirectURL("");
        switch (user.getRole()) {
            case admin   -> resp.sendRedirect("admin/dashboard");
            case officer -> resp.sendRedirect("officer/dashboard");
            case voter   -> resp.sendRedirect("voter/dashboard");
        }
    }
}


