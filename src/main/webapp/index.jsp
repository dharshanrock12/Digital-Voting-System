<%-- index.jsp — redirect root to /login --%>
<%@ page contentType="text/html; charset=UTF-8" %>
<% response.sendRedirect(request.getContextPath() + "/login"); %>
