package com.dvs.servlet;

import com.dvs.model.User;
import javax.servlet.*;
import javax.servlet.http.*;

import java.io.IOException;

/**
 * LogoutServlet — invalidates the session and redirects to login.
 * Mapped to /logout
 * Author: Dharshan Sathish Kumar | Reg: 3122255002029
 */
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) session.invalidate();
        resp.sendRedirect(req.getContextPath() + "/login");
    }
}


