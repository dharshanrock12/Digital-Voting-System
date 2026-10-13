<%-- officer/voters.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../header.jsp">
  <jsp:param name="pageTitle" value="Voter List" />
  <jsp:param name="activeNav" value="voters" />
</jsp:include>

<div class="page-header">
  <h2>Voter List</h2>
  <p>All registered voters and their current voting status.</p>
</div>

<div class="card">
  <div class="table-wrapper">
    <table class="data-table">
      <thead>
        <tr><th>#</th><th>Name</th><th>Username</th><th>Voter ID</th><th>Constituency</th><th>Status</th><th>Voted?</th></tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${empty voters}">
            <tr><td colspan="7">
              <div class="empty-state"><div class="empty-icon">📋</div><p>No voters registered.</p></div>
            </td></tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="v" items="${voters}" varStatus="s">
              <tr>
                <td>${s.count}</td>
                <td>
                  <div style="display:flex;align-items:center;gap:10px;">
                    <div style="width:30px;height:30px;border-radius:50%;background:#3b82f6;
                                display:flex;align-items:center;justify-content:center;font-size:0.7rem;font-weight:700;">
                      <c:out value="${v.initials}" />
                    </div>
                    <strong><c:out value="${v.fullName}" /></strong>
                  </div>
                </td>
                <td><code style="font-size:0.8rem;">@<c:out value="${v.username}" /></code></td>
                <td><c:out value="${v.voterId != null ? v.voterId : '—'}" /></td>
                <td><c:out value="${v.constituency != null ? v.constituency : '—'}" /></td>
                <td>
                  <c:choose>
                    <c:when test="${v.active}"><span class="badge badge-green">Active</span></c:when>
                    <c:otherwise><span class="badge badge-red">Inactive</span></c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${v.hasVoted}"><span class="badge badge-green">✅ Voted</span></c:when>
                    <c:otherwise><span class="badge badge-gray">⏳ Not Voted</span></c:otherwise>
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


