<%-- officer/candidates.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../header.jsp">
  <jsp:param name="pageTitle" value="Candidates" />
  <jsp:param name="activeNav" value="candidates" />
</jsp:include>

<div class="page-header flex-between">
  <div><h2>Candidates / Ballot</h2><p>Add, update, or remove candidates from the ballot.</p></div>
  <a href="${pageContext.request.contextPath}/officer/candidates/add" class="btn btn-primary">+ Add Candidate</a>
</div>

<div class="card">
  <div class="table-wrapper">
    <table class="data-table">
      <thead>
        <tr><th>#</th><th>Candidate</th><th>Party</th><th>Constituency</th><th>Ballot No.</th><th>Actions</th></tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${empty candidates}">
            <tr><td colspan="6">
              <div class="empty-state"><div class="empty-icon">👤</div>
                <div class="empty-title">No Candidates</div>
                <p class="empty-sub">Add candidates to the ballot using the button above.</p></div>
            </td></tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="c" items="${candidates}" varStatus="s">
              <tr>
                <td>${s.count}</td>
                <td>
                  <div style="display:flex;align-items:center;gap:10px;">
                    <div style="width:36px;height:36px;border-radius:50%;background:#3b82f6;
                                display:flex;align-items:center;justify-content:center;font-size:1.1rem;">
                      <c:out value="${c.symbol}" />
                    </div>
                    <strong><c:out value="${c.fullName}" /></strong>
                  </div>
                </td>
                <td><c:out value="${c.party}" /></td>
                <td><c:out value="${c.constituency}" /></td>
                <td>${c.ballotNumber}</td>
                <td>
                  <div class="actions">
                    <a href="${pageContext.request.contextPath}/officer/candidates/edit?id=${c.id}"
                       class="btn btn-ghost btn-sm">✏️ Edit</a>
                    <form method="post" action="${pageContext.request.contextPath}/officer/candidates/delete"
                          style="display:inline;"
                          onsubmit="return confirm('Remove candidate \'${c.fullName}\'?')">
                      <input type="hidden" name="id" value="${c.id}" />
                      <button type="submit" class="btn btn-danger btn-sm">🗑️</button>
                    </form>
                  </div>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>
</div>

<jsp:include page="../footer.jsp" />


