<%-- voter/results.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../header.jsp">
  <jsp:param name="pageTitle" value="Election Results" />
  <jsp:param name="activeNav" value="results" />
</jsp:include>

<div class="page-header">
  <h2>🏆 Election Results</h2>
  <c:if test="${not empty election}">
    <p><c:out value="${election.title}" /></p>
  </c:if>
</div>

<c:choose>
  <c:when test="${election.status != 'declared'}">
    <div class="card text-center" style="padding:3rem;">
      <div style="font-size:4rem;margin-bottom:1rem;">⏳</div>
      <h3>Results Not Yet Declared</h3>
      <p class="text-muted">
        Results will be published here once officially declared by the Election Officer.
      </p>
    </div>
  </c:when>
  <c:otherwise>
    <!-- Winner Card -->
    <c:if test="${not empty winner}">
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

    <!-- Full Results -->
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
              <div class="result-party"><c:out value="${c.party}" /></div>
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
  </c:otherwise>
</c:choose>

<jsp:include page="../footer.jsp" />


