<%-- officer/candidate-form.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../header.jsp">
  <jsp:param name="pageTitle" value="${empty candidate ? 'Add Candidate' : 'Edit Candidate'}" />
  <jsp:param name="activeNav" value="candidates" />
</jsp:include>

<div class="page-header">
  <h2>${empty candidate ? 'Add New Candidate' : 'Edit Candidate'}</h2>
  <p><a href="${pageContext.request.contextPath}/officer/candidates" style="color:var(--primary);">← Back to Candidates</a></p>
</div>

<div class="card" style="max-width:580px;">
  <form method="post" action="${pageContext.request.contextPath}/officer/candidates/save">
    <input type="hidden" name="id" value="${candidate.id}" />

    <div class="form-row">
      <div class="form-group">
        <label class="form-label" for="fullName">Full Name *</label>
        <input class="form-input" type="text" id="fullName" name="fullName" required
               placeholder="Candidate name" value="<c:out value='${candidate.fullName}'/>" />
      </div>
      <div class="form-group">
        <label class="form-label" for="party">Party *</label>
        <input class="form-input" type="text" id="party" name="party" required
               placeholder="Party name" value="<c:out value='${candidate.party}'/>" />
      </div>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label class="form-label" for="symbol">Symbol (Emoji)</label>
        <input class="form-input" type="text" id="symbol" name="symbol" maxlength="4"
               placeholder="e.g. 🌟" value="<c:out value='${candidate.symbol}'/>" />
      </div>
      <div class="form-group">
        <label class="form-label" for="constituency">Constituency *</label>
        <input class="form-input" type="text" id="constituency" name="constituency" required
               placeholder="e.g. Ward-1" value="<c:out value='${candidate.constituency}'/>" />
      </div>
    </div>

    <div class="form-group">
      <label class="form-label" for="ballotNumber">Ballot Number *</label>
      <input class="form-input" type="number" id="ballotNumber" name="ballotNumber"
             min="1" required placeholder="e.g. 1" value="${candidate.ballotNumber > 0 ? candidate.ballotNumber : ''}" />
    </div>

    <div style="display:flex;gap:10px;margin-top:1.5rem;">
      <button type="submit" class="btn btn-primary">
        ${empty candidate ? 'Add Candidate' : 'Save Changes'}
      </button>
      <a href="${pageContext.request.contextPath}/officer/candidates" class="btn btn-ghost">Cancel</a>
    </div>
  </form>
</div>

<jsp:include page="../footer.jsp" />


