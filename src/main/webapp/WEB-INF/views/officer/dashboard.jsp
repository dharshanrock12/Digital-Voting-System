<%-- officer/dashboard.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../header.jsp">
  <jsp:param name="pageTitle" value="Officer Dashboard" />
  <jsp:param name="activeNav" value="dashboard" />
</jsp:include>

<div class="page-header">
  <h2>Election Officer Dashboard</h2>
  <p>Monitor and manage the election process.</p>
</div>

<c:if test="${not empty election}">
  <div class="election-banner ${election.status}">
    <span class="banner-icon">
      <c:choose>
        <c:when test="${election.status == 'open'}">🟢</c:when>
        <c:when test="${election.status == 'closed'}">🔴</c:when>
        <c:when test="${election.status == 'counting'}">🔢</c:when>
        <c:otherwise>🏆</c:otherwise>
      </c:choose>
    </span>
    <div class="banner-text">
      <div class="banner-title">Voting is <c:out value="${election.statusLabel}" /></div>
      <div class="banner-desc"><c:out value="${election.title}" /></div>
    </div>
  </div>
</c:if>

<div class="stats-grid">
  <div class="stat-card"><div class="stat-icon blue">👤</div>
    <div><div class="stat-value">${voters.size()}</div><div class="stat-label">Registered Voters</div></div></div>
  <div class="stat-card"><div class="stat-icon green">✅</div>
    <div><div class="stat-value">${voted}</div><div class="stat-label">Voted</div></div></div>
  <div class="stat-card"><div class="stat-icon orange">⏳</div>
    <div><div class="stat-value">${voters.size() - voted}</div><div class="stat-label">Yet to Vote</div></div></div>
  <div class="stat-card"><div class="stat-icon purple">🎯</div>
    <div><div class="stat-value">${candidates.size()}</div><div class="stat-label">Candidates</div></div></div>
  <div class="stat-card"><div class="stat-icon red">📊</div>
    <div><div class="stat-value">${pct}%</div><div class="stat-label">Turnout</div></div></div>
</div>

<div class="card mb-4">
  <div class="card-header">
    <h3 class="card-title">Voter Turnout</h3>
    <span class="badge badge-blue">${pct}%</span>
  </div>
  <div class="progress-bar-wrap">
    <div class="progress-bar" style="width:${pct}%"></div>
  </div>
  <p style="margin-top:8px;font-size:0.82rem;color:var(--text-2);">${voted} of ${voters.size()} voters have cast their ballot.</p>
</div>

<c:if test="${not empty election}">
<div class="card">
  <div class="card-header">
    <h3 class="card-title">📋 Active Election Details</h3>
    <span class="badge badge-blue"><c:out value="${election.statusLabel}" /></span>
  </div>
  <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(160px,1fr));gap:1rem;font-size:0.87rem;">
    <div><div class="form-label">Title</div><div style="font-weight:600"><c:out value="${election.title}" /></div></div>
    <div><div class="form-label">Start Date</div><div><c:out value="${election.formattedStartDate}" /></div></div>
    <div><div class="form-label">End Date</div><div><c:out value="${election.formattedEndDate}" /></div></div>
    <div><div class="form-label">Description</div><div style="color:var(--text-2)"><c:out value="${election.description}" /></div></div>
  </div>
</div>
</c:if>

<jsp:include page="../footer.jsp" />



