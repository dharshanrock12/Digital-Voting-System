<%-- admin/report.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../header.jsp">
  <jsp:param name="pageTitle" value="System Report" />
  <jsp:param name="activeNav" value="report" />
</jsp:include>

<%
    int voters = (Integer) request.getAttribute("voters");
    int voted  = (Integer) request.getAttribute("voted");
    int pct    = voters > 0 ? (voted * 100 / voters) : 0;
%>

<div class="page-header flex-between">
  <div>
    <h2>System Report</h2>
    <p>Generated on: <strong><jsp:expression>new java.util.Date()</jsp:expression></strong></p>
  </div>
  <button class="btn btn-ghost" onclick="window.print()">🖨️ Print Report</button>
</div>

<div class="card mb-4">
  <h3 style="margin-bottom:1rem;">📊 Summary Statistics</h3>
  <div class="stats-grid">
    <div class="stat-card"><div class="stat-icon blue">👥</div>
      <div><div class="stat-value">${users.size()}</div><div class="stat-label">Total Users</div></div></div>
    <div class="stat-card"><div class="stat-icon green">✅</div>
      <div><div class="stat-value">${voted}</div><div class="stat-label">Votes Cast</div></div></div>
    <div class="stat-card"><div class="stat-icon orange">👤</div>
      <div><div class="stat-value">${voters}</div><div class="stat-label">Registered Voters</div></div></div>
    <div class="stat-card"><div class="stat-icon red">📊</div>
      <div><div class="stat-value"><%=pct%>%</div><div class="stat-label">Turnout</div></div></div>
  </div>
</div>

<div class="card mb-4">
  <h3 style="margin-bottom:1rem;">📋 Elections</h3>
  <div class="table-wrapper">
    <table class="data-table">
      <thead><tr><th>Title</th><th>Start</th><th>End</th><th>Status</th><th>Candidates</th><th>Votes</th></tr></thead>
      <tbody>
        <c:forEach var="e" items="${elections}">
          <tr>
            <td><c:out value="${e.title}" /></td>
            <td><c:out value="${e.formattedStartDate}" /></td>
            <td><c:out value="${e.formattedEndDate}" /></td>
            <td><span class="badge badge-blue"><c:out value="${e.statusLabel}" /></span></td>
            <td>${e.candidateCount}</td>
            <td>${e.voteCount}</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<div class="card">
  <h3 style="margin-bottom:1rem;">📝 Recent Audit Trail</h3>
  <div class="audit-list">
    <c:forEach var="log" items="${logs}">
      <div class="audit-item">
        <div class="audit-dot" style="background:var(--primary)"></div>
        <div class="audit-time"><c:out value="${log.formattedAt}" /></div>
        <div><span class="badge badge-blue"><c:out value="${log.action}" /></span></div>
        <div class="audit-msg" style="flex:2">
          <span class="audit-user"><c:out value="${log.performedByName != null ? log.performedByName : 'System'}" /></span>
          — <c:out value="${log.message}" />
        </div>
      </div>
    </c:forEach>
  </div>
</div>

<jsp:include page="../footer.jsp" />



