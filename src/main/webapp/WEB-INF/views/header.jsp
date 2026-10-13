<%-- header.jsp — shared nav/sidebar fragment included by all dashboard views --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.dvs.model.User __u = (com.dvs.model.User) session.getAttribute("user");
    String __role = (__u != null) ? __u.getRole().name() : "";
    pageContext.setAttribute("sessionUser", __u);
    pageContext.setAttribute("userRole", __role);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>${param.pageTitle} | Digital Voting System</title>
  <meta name="description" content="Digital Voting System — Secure, Transparent, Efficient" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
</head>
<body>
<div class="shell">
  <!-- ===== SIDEBAR ===== -->
  <aside class="sidebar">
    <div class="sidebar-brand">
      <div class="sidebar-brand-logo">🗳️</div>
      <div>
        <div class="sidebar-brand-text">DVS</div>
        <div class="sidebar-brand-sub">Digital Voting System</div>
      </div>
    </div>

    <div class="sidebar-user">
      <div class="sidebar-user-avatar" style="background:${sessionUser != null ? '#3b82f6' : '#666'}">
        <c:if test="${sessionUser != null}">${sessionUser.initials}</c:if>
      </div>
      <div>
        <div class="sidebar-user-name"><c:out value="${sessionUser.fullName}" /></div>
        <span class="sidebar-user-role role-${userRole}">
          <c:choose>
            <c:when test="${userRole == 'admin'}">Administrator</c:when>
            <c:when test="${userRole == 'officer'}">Election Officer</c:when>
            <c:otherwise>Voter</c:otherwise>
          </c:choose>
        </span>
      </div>
    </div>

    <nav class="sidebar-nav">
      <!-- Admin nav -->
      <c:if test="${userRole == 'admin'}">
        <a class="nav-item ${param.activeNav == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
          <span class="nav-icon">📊</span> Dashboard
        </a>
        <div class="sidebar-section-label">Management</div>
        <a class="nav-item ${param.activeNav == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users">
          <span class="nav-icon">👥</span> Manage Users
        </a>
        <a class="nav-item ${param.activeNav == 'elections' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/elections">
          <span class="nav-icon">📋</span> Elections
        </a>
        <div class="sidebar-section-label">Reports</div>
        <a class="nav-item ${param.activeNav == 'audit' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/audit">
          <span class="nav-icon">📝</span> Audit Log
        </a>
        <a class="nav-item ${param.activeNav == 'report' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/report">
          <span class="nav-icon">📈</span> System Report
        </a>
      </c:if>

      <!-- Officer nav -->
      <c:if test="${userRole == 'officer'}">
        <a class="nav-item ${param.activeNav == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/officer/dashboard">
          <span class="nav-icon">📊</span> Dashboard
        </a>
        <div class="sidebar-section-label">Election</div>
        <a class="nav-item ${param.activeNav == 'candidates' ? 'active' : ''}" href="${pageContext.request.contextPath}/officer/candidates">
          <span class="nav-icon">👤</span> Candidates
        </a>
        <a class="nav-item ${param.activeNav == 'voters' ? 'active' : ''}" href="${pageContext.request.contextPath}/officer/voters">
          <span class="nav-icon">📋</span> Voter List
        </a>
        <a class="nav-item ${param.activeNav == 'voting' ? 'active' : ''}" href="${pageContext.request.contextPath}/officer/voting">
          <span class="nav-icon">⚙️</span> Voting Control
        </a>
        <div class="sidebar-section-label">Results</div>
        <a class="nav-item ${param.activeNav == 'counting' ? 'active' : ''}" href="${pageContext.request.contextPath}/officer/counting">
          <span class="nav-icon">🔢</span> Vote Counting
        </a>
        <a class="nav-item ${param.activeNav == 'results' ? 'active' : ''}" href="${pageContext.request.contextPath}/officer/results">
          <span class="nav-icon">🏆</span> Declare Results
        </a>
        <a class="nav-item ${param.activeNav == 'report' ? 'active' : ''}" href="${pageContext.request.contextPath}/officer/report">
          <span class="nav-icon">📈</span> Report
        </a>
      </c:if>

      <!-- Voter nav -->
      <c:if test="${userRole == 'voter'}">
        <a class="nav-item ${param.activeNav == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/voter/dashboard">
          <span class="nav-icon">🏠</span> Home
        </a>
        <a class="nav-item ${param.activeNav == 'ballot' ? 'active' : ''}" href="${pageContext.request.contextPath}/voter/ballot">
          <span class="nav-icon">🗳️</span> Cast Vote
        </a>
        <a class="nav-item ${param.activeNav == 'results' ? 'active' : ''}" href="${pageContext.request.contextPath}/voter/results">
          <span class="nav-icon">🏆</span> Results
        </a>
      </c:if>
    </nav>

    <div class="sidebar-footer">
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost w-full btn-sm">🚪 Logout</a>
    </div>
  </aside>

  <!-- ===== MAIN CONTENT ===== -->
  <div class="main-content">
    <header class="topbar">
      <div class="topbar-title"><c:out value="${param.pageTitle}" /></div>
      <div class="topbar-actions">
        <span style="font-size:0.78rem;color:var(--text-3);" id="current-time"></span>
      </div>
    </header>
    <div class="page-content">


