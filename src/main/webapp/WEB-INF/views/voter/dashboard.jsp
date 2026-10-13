<%-- voter/dashboard.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../header.jsp">
  <jsp:param name="pageTitle" value="Voter Home" />
  <jsp:param name="activeNav" value="dashboard" />
</jsp:include>

<div class="page-header">
  <h2>Welcome, <c:out value="${sessionScope.user.fullName}" />! 👋</h2>
  <p>Your secure digital voting portal.</p>
</div>

<c:if test="${param.voted == '1'}">
  <div class="flash flash-success" style="margin-bottom:1.5rem;">✅ Your vote has been securely recorded! Thank you for participating.</div>
</c:if>

<c:if test="${not empty election}">
  <div class="election-banner ${election.status}" style="margin-bottom:1.5rem;">
    <span class="banner-icon">
      <c:choose>
        <c:when test="${election.status == 'open'}">🟢</c:when>
        <c:when test="${election.status == 'declared'}">🏆</c:when>
        <c:otherwise>🔴</c:otherwise>
      </c:choose>
    </span>
    <div class="banner-text">
      <div class="banner-title">Voting is <c:out value="${election.statusLabel}" /></div>
      <div class="banner-desc"><c:out value="${election.title}" /></div>
    </div>
  </div>
</c:if>

<div class="stats-grid">
  <div class="stat-card">
    <div class="stat-icon blue">🪪</div>
    <div>
      <div class="stat-value" style="font-size:1.1rem;"><c:out value="${sessionScope.user.voterId != null ? sessionUser.voterId : 'N/A'}" /></div>
      <div class="stat-label">Voter ID</div>
    </div>
  </div>
  <div class="stat-card">
    <div class="stat-icon purple">📍</div>
    <div>
      <div class="stat-value" style="font-size:1.1rem;"><c:out value="${sessionScope.user.constituency != null ? sessionUser.constituency : 'N/A'}" /></div>
      <div class="stat-label">Constituency</div>
    </div>
  </div>
  <div class="stat-card">
    <div class="stat-icon ${sessionScope.user.hasVoted ? 'green' : 'orange'}">🗳️</div>
    <div>
      <div class="stat-value" style="font-size:1.1rem;">${sessionScope.user.hasVoted ? 'Voted' : 'Not Voted'}</div>
      <div class="stat-label">Vote Status</div>
    </div>
  </div>
</div>

<c:choose>
  <c:when test="${sessionScope.user.hasVoted}">
    <div class="card" style="border-color:rgba(16,185,129,0.3);background:rgba(16,185,129,0.05);
                              text-align:center;padding:2.5rem;">
      <div style="font-size:4rem;margin-bottom:1rem;">✅</div>
      <h3 style="color:#34d399;">Your vote has been recorded!</h3>
      <p class="text-muted" style="margin-top:0.5rem;">Thank you for participating in the democratic process.</p>
      <c:if test="${election.status == 'declared'}">
        <a href="${pageContext.request.contextPath}/voter/results" class="btn btn-primary mt-3">🏆 View Results</a>
      </c:if>
    </div>
  </c:when>
  <c:when test="${election.status == 'open'}">
    <div class="card" style="border-color:rgba(59,130,246,0.3);text-align:center;padding:2.5rem;">
      <div style="font-size:4rem;margin-bottom:1rem;">🗳️</div>
      <h3>Voting is Open!</h3>
      <p class="text-muted" style="margin-top:0.5rem;margin-bottom:1.5rem;">
        Cast your vote for <strong><c:out value="${election.title}" /></strong>.
      </p>
      <a href="${pageContext.request.contextPath}/voter/ballot" class="btn btn-primary btn-lg">Cast Your Vote →</a>
    </div>
  </c:when>
  <c:otherwise>
    <div class="card text-center" style="padding:2.5rem;">
      <div style="font-size:4rem;margin-bottom:1rem;">⏳</div>
      <h3>Voting Not Available</h3>
      <p class="text-muted">The voting session is currently
        <strong><c:out value="${election != null ? election.statusLabel : 'unavailable'}" /></strong>.
        Please wait for the Election Officer to open voting.
      </p>
    </div>
  </c:otherwise>
</c:choose>

<jsp:include page="../footer.jsp" />



