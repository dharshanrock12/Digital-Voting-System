<%-- officer/results.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../header.jsp">
  <jsp:param name="pageTitle" value="Declare Results" />
  <jsp:param name="activeNav" value="results" />
</jsp:include>

<div class="page-header flex-between">
  <div><h2>Declare Results</h2><p>Officially publish the election results.</p></div>
  <c:choose>
    <c:when test="${election.status == 'declared'}">
      <span class="badge badge-purple" style="padding:8px 16px;font-size:0.88rem;">✅ Results Declared</span>
    </c:when>
    <c:when test="${election.status == 'counting'}">
      <form method="post" action="${pageContext.request.contextPath}/officer/results/declare"
            onsubmit="return confirm('Officially declare these results? This cannot be undone.')">
        <button type="submit" class="btn btn-primary">🏆 Declare Results Officially</button>
      </form>
    </c:when>
    <c:otherwise>
      <a href="${pageContext.request.contextPath}/officer/counting" class="btn btn-warning">Go to Counting First →</a>
    </c:otherwise>
  </c:choose>
</div>

<!-- Winner Banner -->
<c:if test="${election.status == 'declared' && not empty winner}">
  <div class="card" style="border-color:rgba(245,158,11,0.4);background:rgba(245,158,11,0.06);
                            margin-bottom:1.5rem;text-align:center;padding:2.5rem;">
    <div class="winner-crown">👑</div>
    <h2 style="margin:0.75rem 0 0.25rem;">
      <c:out value="${winner.symbol}" /> <c:out value="${winner.fullName}" />
    </h2>
    <p style="color:var(--text-2);margin-bottom:0.5rem;"><c:out value="${winner.party}" /></p>
    <span class="badge badge-orange" style="font-size:0.85rem;padding:6px 16px;">
      ${winner.voteCount} votes &middot; ${winner.formattedPercentage}% share
    </span>
  </div>
</c:if>

<!-- Full Results Table -->
<c:if test="${not empty results}">
  <div class="card">
    <div class="card-header">
      <h3 class="card-title">Full Results</h3>
      <span class="badge badge-blue">${totalVotes} total votes</span>
    </div>
    <div class="results-list">
      <c:forEach var="c" items="${results}">
        <div class="result-row">
          <div class="result-rank ${c.rank == 1 ? 'gold' : c.rank == 2 ? 'silver' : c.rank == 3 ? 'bronze' : 'other'}">
            ${c.rank}
          </div>
          <div class="result-info">
            <div class="result-name"><c:out value="${c.symbol}" /> <c:out value="${c.fullName}" /></div>
            <div class="result-party"><c:out value="${c.party}" /> · <c:out value="${c.constituency}" /></div>
          </div>
          <div class="result-bar-wrap">
            <div class="result-bar"
                 style="width:${c.percentageRounded}%;
                        background:${c.rank == 1 ? '#f59e0b' : c.rank == 2 ? '#94a3b8' : '#3b82f6'}">
            </div>
          </div>
          <div class="result-votes">
            ${c.voteCount} (${c.formattedPercentage}%)
          </div>
        </div>
      </c:forEach>
    </div>
  </div>
</c:if>

<c:if test="${empty results}">
  <div class="card">
    <div class="empty-state">
      <div class="empty-icon">⏳</div>
      <div class="empty-title">No Results Yet</div>
      <p class="empty-sub">Complete vote counting before declaring results.</p>
    </div>
  </div>
</c:if>

<jsp:include page="../footer.jsp" />


