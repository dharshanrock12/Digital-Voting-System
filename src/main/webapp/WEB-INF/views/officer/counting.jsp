<%-- officer/counting.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../header.jsp">
  <jsp:param name="pageTitle" value="Vote Counting" />
  <jsp:param name="activeNav" value="counting" />
</jsp:include>

<div class="page-header flex-between">
  <div>
    <h2>Vote Counting</h2>
    <p>Total votes received: <strong>${totalVotes}</strong></p>
  </div>
  <div style="display:flex;gap:8px;">
    <c:if test="${election.status == 'closed'}">
      <form method="post" action="${pageContext.request.contextPath}/officer/voting/status"
            onsubmit="return confirm('Start official vote counting?')">
        <input type="hidden" name="status" value="counting" />
        <button type="submit" class="btn btn-warning">&#x1F522; Start Count</button>
      </form>
    </c:if>
    <c:if test="${election.status == 'counting'}">
      <a href="${pageContext.request.contextPath}/officer/results" class="btn btn-primary">Declare Results &#x2192;</a>
    </c:if>
  </div>
</div>

<c:if test="${election.status == 'open'}">
  <div class="card text-center" style="padding:3rem;">
    <div style="font-size:4rem;margin-bottom:1rem;">&#x26A0;&#xFE0F;</div>
    <h3>Voting Still Open</h3>
    <p class="text-muted">Close the voting session before counting votes.</p>
    <a href="${pageContext.request.contextPath}/officer/voting" class="btn btn-danger mt-3">Close Voting First</a>
  </div>
</c:if>

<c:if test="${election.status != 'open' && not empty results}">
  <div class="card">
    <div class="card-header">
      <h3 class="card-title">Vote Tally</h3>
      <span class="badge badge-orange">${totalVotes} total votes</span>
    </div>
    <div class="results-list">
      <c:forEach var="c" items="${results}">
        <div class="result-row">
          <div class="result-rank ${c.rank == 1 ? 'gold' : c.rank == 2 ? 'silver' : c.rank == 3 ? 'bronze' : 'other'}">
            ${c.rank}
          </div>
          <div class="result-info">
            <div class="result-name"><c:out value="${c.symbol}" /> <c:out value="${c.fullName}" /></div>
            <div class="result-party"><c:out value="${c.party}" /> &middot; <c:out value="${c.constituency}" /></div>
          </div>
          <div class="result-bar-wrap">
            <div class="result-bar"
                 style="width:${c.percentageRounded}%;
                        background:${c.rank == 1 ? '#f59e0b' : c.rank == 2 ? '#94a3b8' : '#3b82f6'}">
            </div>
          </div>
          <div class="result-votes">${c.voteCount} votes (${c.formattedPercentage}%)</div>
        </div>
      </c:forEach>
    </div>
  </div>
</c:if>

<c:if test="${election.status != 'open' && empty results}">
  <div class="card">
    <div class="empty-state">
      <div class="empty-icon">&#x1F522;</div>
      <div class="empty-title">No votes yet.</div>
      <p class="empty-sub">No votes have been cast in this election.</p>
    </div>
  </div>
</c:if>

<jsp:include page="../footer.jsp" />
