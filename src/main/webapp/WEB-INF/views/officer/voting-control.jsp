<%-- officer/voting-control.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../header.jsp">
  <jsp:param name="pageTitle" value="Voting Control" />
  <jsp:param name="activeNav" value="voting" />
</jsp:include>

<div class="page-header">
  <h2>Voting Control Panel</h2>
  <p>Open or close the voting session and manage the election lifecycle.</p>
</div>

<c:if test="${not empty election}">
  <div class="election-banner ${election.status}" style="margin-bottom:1.5rem;">
    <span class="banner-icon">
      <c:choose>
        <c:when test="${election.status == 'open'}">🟢</c:when>
        <c:when test="${election.status == 'closed'}">🔴</c:when>
        <c:when test="${election.status == 'counting'}">🔢</c:when>
        <c:otherwise>🏆</c:otherwise>
      </c:choose>
    </span>
    <div class="banner-text">
      <div class="banner-title">Current Status: <strong><c:out value="${election.statusLabel}" /></strong></div>
      <div class="banner-desc"><c:out value="${election.title}" /></div>
    </div>
  </div>

  <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:1.25rem;margin-bottom:2rem;">

    <div class="card text-center" style="padding:2rem;">
      <div style="font-size:3rem;margin-bottom:1rem;">🟢</div>
      <h3>Open Voting</h3>
      <p class="text-muted" style="font-size:0.84rem;margin:0.75rem 0 1.25rem;">Allow voters to cast ballots.</p>
      <form method="post" action="${pageContext.request.contextPath}/officer/voting/status"
            onsubmit="return confirm('Open the voting session?')">
        <input type="hidden" name="status" value="open" />
        <button type="submit" class="btn btn-success w-full"
                ${election.status == 'open' ? 'disabled' : ''}>Open Voting</button>
      </form>
    </div>

    <div class="card text-center" style="padding:2rem;">
      <div style="font-size:3rem;margin-bottom:1rem;">🔴</div>
      <h3>Close Voting</h3>
      <p class="text-muted" style="font-size:0.84rem;margin:0.75rem 0 1.25rem;">Stop accepting new votes.</p>
      <form method="post" action="${pageContext.request.contextPath}/officer/voting/status"
            onsubmit="return confirm('Close the voting session? No more votes will be accepted.')">
        <input type="hidden" name="status" value="closed" />
        <button type="submit" class="btn btn-danger w-full"
                ${election.status != 'open' ? 'disabled' : ''}>Close Voting</button>
      </form>
    </div>

    <div class="card text-center" style="padding:2rem;">
      <div style="font-size:3rem;margin-bottom:1rem;">🔢</div>
      <h3>Start Counting</h3>
      <p class="text-muted" style="font-size:0.84rem;margin:0.75rem 0 1.25rem;">Begin vote counting process.</p>
      <a href="${pageContext.request.contextPath}/officer/counting"
         class="btn btn-warning w-full ${election.status == 'open' ? 'disabled' : ''}">
        Go to Counting →
      </a>
    </div>

  </div>

  <!-- Lifecycle Indicator (c:set string list — EL 3.0 literals not supported in Tomcat 7) -->
  <div class="card">
    <h3 style="margin-bottom:1rem;">&#x1F4CB; Election Lifecycle</h3>
    <c:set var="stages" value="open,closed,counting,declared" />
    <div style="display:flex;align-items:center;gap:0;flex-wrap:wrap;">
      <c:forEach var="s" items="${stages}">
        <div style="display:flex;align-items:center;">
          <div style="padding:8px 16px;border-radius:6px;font-size:0.82rem;font-weight:600;
                      background:${election.status == s ? 'rgba(59,130,246,0.2)' : 'rgba(255,255,255,0.04)'};
                      border:1px solid ${election.status == s ? 'var(--primary)' : 'var(--border)'};
                      color:${election.status == s ? '#60a5fa' : 'var(--text-2)'}">
            <c:out value="${s}" />
          </div>
          <c:if test="${s != 'declared'}">
            <div style="width:32px;height:2px;background:var(--border);"></div>
          </c:if>
        </div>
      </c:forEach>
    </div>
  </div>
</c:if>

<c:if test="${empty election}">
  <div class="card text-center" style="padding:3rem;">
    <div style="font-size:4rem;margin-bottom:1rem;">📋</div>
    <h3>No Active Election</h3>
    <p class="text-muted">No election found in the system.</p>
  </div>
</c:if>

<jsp:include page="../footer.jsp" />


