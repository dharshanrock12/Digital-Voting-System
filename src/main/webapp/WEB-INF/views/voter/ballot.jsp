<%-- voter/ballot.jsp — Secure vote casting --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../header.jsp">
  <jsp:param name="pageTitle" value="Cast Vote" />
  <jsp:param name="activeNav" value="ballot" />
</jsp:include>

<div class="page-header">
  <h2>Cast Your Vote</h2>
  <c:if test="${not empty election}">
    <p>Election: <strong><c:out value="${election.title}" /></strong>
       · Constituency: <span class="badge badge-blue"><c:out value="${sessionUser.constituency}" /></span>
    </p>
  </c:if>
</div>

<!-- Already Voted -->
<c:if test="${alreadyVoted}">
  <div class="card text-center" style="padding:3rem;border-color:rgba(16,185,129,0.3);">
    <div style="font-size:4rem;margin-bottom:1rem;">✅</div>
    <h3 style="color:#34d399;">You have already voted!</h3>
    <p class="text-muted" style="margin-top:0.5rem;">Each voter may only vote once. Your vote is securely recorded.</p>
    <a href="${pageContext.request.contextPath}/voter/dashboard" class="btn btn-primary mt-3">← Back to Home</a>
  </div>
</c:if>

<!-- Voting Closed -->
<c:if test="${votingClosed}">
  <div class="card text-center" style="padding:3rem;">
    <div style="font-size:4rem;margin-bottom:1rem;">🔒</div>
    <h3>Voting is ${election != null ? election.statusLabel : 'Closed'}</h3>
    <p class="text-muted">The voting session is not accepting votes at this time.</p>
    <a href="${pageContext.request.contextPath}/voter/dashboard" class="btn btn-ghost mt-3">← Back to Home</a>
  </div>
</c:if>

<!-- Error Params -->
<c:if test="${param.err == 'duplicate'}">
  <div class="flash flash-error" style="margin-bottom:1rem;">⚠️ You have already cast your vote.</div>
</c:if>
<c:if test="${param.err == 'closed'}">
  <div class="flash flash-error" style="margin-bottom:1rem;">⚠️ The voting session is closed.</div>
</c:if>
<c:if test="${param.err == 'invalid'}">
  <div class="flash flash-error" style="margin-bottom:1rem;">⚠️ Invalid candidate selection.</div>
</c:if>
<c:if test="${param.err == 'system'}">
  <div class="flash flash-error" style="margin-bottom:1rem;">⚠️ A system error occurred. Please try again.</div>
</c:if>

<!-- Ballot -->
<c:if test="${not alreadyVoted && not votingClosed && not empty candidates}">
  <div class="card" style="margin-bottom:1.5rem;">
    <p style="font-size:0.88rem;color:var(--text-2);display:flex;align-items:center;gap:8px;">
      🔒 Your vote is secret and anonymous. Select a candidate and confirm to cast your vote.
    </p>
  </div>

  <form method="post" action="${pageContext.request.contextPath}/voter/cast" id="vote-form">
    <div class="ballot-grid" id="ballot-grid">
      <c:forEach var="c" items="${candidates}" varStatus="s">
        <div class="candidate-card" id="cc-${c.id}"
             onclick="selectCandidate(${c.id}, '${c.fullName}', '${c.party}')">
          <div class="candidate-avatar" style="background:#3b82f6;">
            <c:out value="${c.symbol}" />
          </div>
          <div class="candidate-name"><c:out value="${c.fullName}" /></div>
          <div class="candidate-party"><c:out value="${c.party}" /></div>
          <div class="candidate-number">Ballot No. ${c.ballotNumber}</div>
        </div>
      </c:forEach>
    </div>

    <input type="hidden" name="candidateId" id="selected-candidate-id" value="" />

    <div style="margin-top:2rem;text-align:center;">
      <div id="selected-info" style="margin-bottom:1rem;color:var(--text-2);font-size:0.9rem;">
        Select a candidate above to vote.
      </div>
      <button type="button" class="btn btn-success btn-lg" id="cast-vote-btn" disabled
              onclick="confirmVote()">
        ✅ Confirm Vote
      </button>
    </div>
  </form>
</c:if>

<c:if test="${not alreadyVoted && not votingClosed && empty candidates}">
  <div class="card text-center" style="padding:3rem;">
    <div style="font-size:4rem;margin-bottom:1rem;">🗳️</div>
    <h3>No Candidates</h3>
    <p class="text-muted">
      No candidates are registered for your constituency
      (<c:out value="${sessionUser.constituency != null ? sessionUser.constituency : 'Unknown'}" />).
    </p>
  </div>
</c:if>

<script>
let selectedId = null;

function selectCandidate(id, name, party) {
  selectedId = id;
  document.querySelectorAll('.candidate-card').forEach(el => el.classList.remove('selected'));
  document.getElementById('cc-' + id).classList.add('selected');
  document.getElementById('selected-candidate-id').value = id;
  document.getElementById('selected-info').innerHTML =
    'Selected: <strong>' + name + '</strong> (' + party + ')';
  document.getElementById('cast-vote-btn').disabled = false;
}

function confirmVote() {
  if (!selectedId) { alert('Please select a candidate.'); return; }
  const name = document.querySelector('#cc-' + selectedId + ' .candidate-name').textContent;
  if (confirm('Confirm your vote for: ' + name + '?\n\nThis action CANNOT be undone.')) {
    document.getElementById('vote-form').submit();
  }
}
</script>

<jsp:include page="../footer.jsp" />


