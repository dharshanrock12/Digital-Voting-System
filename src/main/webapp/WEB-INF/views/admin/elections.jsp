<%-- admin/elections.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../header.jsp">
  <jsp:param name="pageTitle" value="Elections" />
  <jsp:param name="activeNav" value="elections" />
</jsp:include>

<div class="page-header">
  <h2>Elections</h2>
  <p>View all elections and their current status.</p>
</div>

<div class="card">
  <div class="table-wrapper">
    <table class="data-table">
      <thead>
        <tr><th>Election</th><th>Start Date</th><th>End Date</th><th>Candidates</th><th>Votes</th><th>Status</th></tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${empty elections}">
            <tr><td colspan="6">
              <div class="empty-state"><div class="empty-icon">📋</div><p>No elections found.</p></div>
            </td></tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="e" items="${elections}">
              <tr>
                <td>
                  <div style="font-weight:600"><c:out value="${e.title}" /></div>
                  <div style="font-size:0.75rem;color:var(--text-3)"><c:out value="${e.description}" /></div>
                </td>
                <td><c:out value="${e.formattedStartDate}" /></td>
                <td><c:out value="${e.formattedEndDate}" /></td>
                <td>${e.candidateCount}</td>
                <td>${e.voteCount}</td>
                <td>
                  <c:choose>
                    <c:when test="${e.status == 'open'}">    <span class="badge badge-green">Open</span></c:when>
                    <c:when test="${e.status == 'closed'}">  <span class="badge badge-red">Closed</span></c:when>
                    <c:when test="${e.status == 'counting'}"><span class="badge badge-orange">Counting</span></c:when>
                    <c:otherwise>                            <span class="badge badge-purple">Declared</span></c:otherwise>
                  </c:choose>
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


