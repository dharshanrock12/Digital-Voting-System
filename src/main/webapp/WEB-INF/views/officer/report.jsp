<%-- officer/report.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../header.jsp">
  <jsp:param name="pageTitle" value="Election Report" />
  <jsp:param name="activeNav" value="report" />
</jsp:include>
<%
    java.util.List<?> voters = (java.util.List<?>) request.getAttribute("voters");
    int voted  = (Integer) request.getAttribute("voted");
    int total  = voters != null ? voters.size() : 0;
    int pct    = total > 0 ? (voted * 100 / total) : 0;
%>

<div class="page-header flex-between">
  <div><h2>Election Report</h2><p>Generated: <strong><jsp:expression>new java.util.Date()</jsp:expression></strong></p></div>
  <button class="btn btn-ghost" onclick="window.print()">🖨️ Print</button>
</div>

<div class="stats-grid" style="margin-bottom:1.5rem;">
  <div class="stat-card"><div class="stat-icon blue">👤</div>
    <div><div class="stat-value"><%=total%></div><div class="stat-label">Registered Voters</div></div></div>
  <div class="stat-card"><div class="stat-icon green">✅</div>
    <div><div class="stat-value"><%=voted%></div><div class="stat-label">Voted</div></div></div>
  <div class="stat-card"><div class="stat-icon red">📊</div>
    <div><div class="stat-value"><%=pct%>%</div><div class="stat-label">Turnout</div></div></div>
  <div class="stat-card"><div class="stat-icon purple">🏛️</div>
    <div><div class="stat-value">${results.size()}</div><div class="stat-label">Candidates</div></div></div>
</div>

<c:if test="${not empty results}">
<div class="card mb-4">
  <div class="card-header"><h3 class="card-title">📊 Vote Tally</h3></div>
  <div class="results-list">
    <c:forEach var="c" items="${results}">
      <div class="result-row">
        <div class="result-rank ${c.rank == 1 ? 'gold' : c.rank == 2 ? 'silver' : 'other'}">${c.rank}</div>
        <div class="result-info">
          <div class="result-name"><c:out value="${c.symbol}" /> <c:out value="${c.fullName}" /></div>
          <div class="result-party"><c:out value="${c.party}" /></div>
        </div>
        <div class="result-bar-wrap">
          <div class="result-bar" style="width:${c.percentageRounded}%;background:#3b82f6;"></div>
        </div>
        <div class="result-votes">
          ${c.voteCount} (${c.formattedPercentage}%)
        </div>
      </div>
    </c:forEach>
  </div>
</div>
</c:if>

<div class="card">
  <h3 style="margin-bottom:1rem;">📋 Voter Status</h3>
  <div class="table-wrapper">
    <table class="data-table">
      <thead><tr><th>#</th><th>Name</th><th>Voter ID</th><th>Constituency</th><th>Voted?</th></tr></thead>
      <tbody>
        <c:forEach var="v" items="${voters}" varStatus="s">
          <tr>
            <td>${s.count}</td>
            <td><c:out value="${v.fullName}" /></td>
            <td><c:out value="${v.voterId != null ? v.voterId : '—'}" /></td>
            <td><c:out value="${v.constituency != null ? v.constituency : '—'}" /></td>
            <td>
              <c:choose>
                <c:when test="${v.hasVoted}"><span class="badge badge-green">✅ Voted</span></c:when>
                <c:otherwise><span class="badge badge-gray">⏳ Not Voted</span></c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<jsp:include page="../footer.jsp" />


