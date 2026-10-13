<%-- admin/dashboard.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../header.jsp">
  <jsp:param name="pageTitle" value="Admin Dashboard" />
  <jsp:param name="activeNav" value="dashboard" />
</jsp:include>

<div class="page-header">
  <h2>Admin Dashboard</h2>
  <p>Overview of the Digital Voting System operations.</p>
</div>

<c:if test="${not empty error}">
  <div class="flash flash-error"><c:out value="${error}" /></div>
</c:if>

<!-- Election Status Banner -->
<c:if test="${not empty elections}">
  <c:set var="elStatus" value="${elections[0].status}" />
  <div class="election-banner ${elStatus}">
    <span class="banner-icon">
      <c:choose>
        <c:when test="${elStatus == 'open'}">🟢</c:when>
        <c:when test="${elStatus == 'closed'}">🔴</c:when>
        <c:when test="${elStatus == 'counting'}">🔢</c:when>
        <c:otherwise>🏆</c:otherwise>
      </c:choose>
    </span>
    <div class="banner-text">
      <div class="banner-title">Voting is <c:out value="${elections[0].statusLabel}" /></div>
      <div class="banner-desc"><c:out value="${elections[0].title}" /></div>
    </div>
  </div>
</c:if>

<!-- Stats Grid -->
<div class="stats-grid">
  <div class="stat-card">
    <div class="stat-icon blue">👥</div>
    <div><div class="stat-value">${users.size()}</div><div class="stat-label">Total Users</div></div>
  </div>
  <div class="stat-card">
    <div class="stat-icon green">✅</div>
    <div><div class="stat-value">${voted}</div><div class="stat-label">Votes Cast</div></div>
  </div>
  <div class="stat-card">
    <div class="stat-icon purple">📋</div>
    <div><div class="stat-value">${elections.size()}</div><div class="stat-label">Elections</div></div>
  </div>
  <div class="stat-card">
    <div class="stat-icon orange">👤</div>
    <div><div class="stat-value">${voters}</div><div class="stat-label">Registered Voters</div></div>
  </div>
  <div class="stat-card">
    <div class="stat-icon red">📊</div>
    <div><div class="stat-value">${pct}%</div><div class="stat-label">Voter Turnout</div></div>
  </div>
</div>

<!-- Turnout Bar -->
<div class="card mb-4">
  <div class="card-header">
    <h3 class="card-title">Voter Turnout</h3>
    <span class="badge badge-blue">${voted} / ${voters}</span>
  </div>
  <div class="progress-bar-wrap">
    <div class="progress-bar" style="width:${pct}%"></div>
  </div>
  <p style="margin-top:8px;font-size:0.82rem;color:var(--text-2);">${pct}% of registered voters have cast their ballot.</p>
</div>

<!-- Recent Audit -->
<div class="card">
  <div class="card-header">
    <h3 class="card-title">📝 Recent Activity</h3>
    <a href="${pageContext.request.contextPath}/admin/audit" class="btn btn-ghost btn-sm">View All</a>
  </div>
  <div class="audit-list">
    <c:choose>
      <c:when test="${empty recentLog}">
        <div class="empty-state"><div class="empty-icon">📝</div><p>No activity yet.</p></div>
      </c:when>
      <c:otherwise>
        <c:forEach var="log" items="${recentLog}">
          <div class="audit-item">
            <div class="audit-dot" style="background:var(--primary)"></div>
            <div class="audit-time">
              <c:out value="${log.formattedAt}" />
            </div>
            <div>
              <span class="badge badge-blue"><c:out value="${log.action}" /></span>
            </div>
            <div class="audit-msg" style="flex:2">
              <span class="audit-user"><c:out value="${log.performedByName != null ? log.performedByName : 'System'}" /></span>
              — <c:out value="${log.message}" />
            </div>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<jsp:include page="../footer.jsp" />


