<%-- admin/users.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../header.jsp">
  <jsp:param name="pageTitle" value="Manage Users" />
  <jsp:param name="activeNav" value="users" />
</jsp:include>

<div class="page-header flex-between">
  <div>
    <h2>Manage Users</h2>
    <p>Add, edit, or remove Admin, Officer, and Voter accounts.</p>
  </div>
  <a href="${pageContext.request.contextPath}/admin/users/add" class="btn btn-primary">+ Add User</a>
</div>

<c:if test="${not empty error}">
  <div class="flash flash-error"><c:out value="${error}" /></div>
</c:if>

<div class="card">
  <div class="table-wrapper">
    <table class="data-table">
      <thead>
        <tr>
          <th>Name</th><th>Username</th><th>Role</th>
          <th>Voter ID</th><th>Constituency</th>
          <th>Voted?</th><th>Status</th><th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${empty users}">
            <tr><td colspan="8">
              <div class="empty-state"><div class="empty-icon">👥</div><p>No users found.</p></div>
            </td></tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="u" items="${users}">
              <tr>
                <td>
                  <div style="display:flex;align-items:center;gap:10px;">
                    <div style="width:32px;height:32px;border-radius:50%;background:#3b82f6;
                                display:flex;align-items:center;justify-content:center;
                                font-size:0.75rem;font-weight:700;">
                      <c:out value="${u.initials}" />
                    </div>
                    <strong><c:out value="${u.fullName}" /></strong>
                  </div>
                </td>
                <td><code style="font-size:0.8rem;">@<c:out value="${u.username}" /></code></td>
                <td>
                  <c:choose>
                    <c:when test="${u.role == 'admin'}"><span class="badge badge-purple">Admin</span></c:when>
                    <c:when test="${u.role == 'officer'}"><span class="badge badge-blue">Officer</span></c:when>
                    <c:otherwise><span class="badge badge-green">Voter</span></c:otherwise>
                  </c:choose>
                </td>
                <td><c:out value="${u.voterId != null ? u.voterId : '—'}" /></td>
                <td><c:out value="${u.constituency != null ? u.constituency : '—'}" /></td>
                <td>
                  <c:if test="${u.role == 'voter'}">
                    <c:choose>
                      <c:when test="${u.hasVoted}"><span class="badge badge-green">✅ Voted</span></c:when>
                      <c:otherwise><span class="badge badge-gray">⏳ Not Voted</span></c:otherwise>
                    </c:choose>
                  </c:if>
                  <c:if test="${u.role != 'voter'}">—</c:if>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${u.active}"><span class="badge badge-green">Active</span></c:when>
                    <c:otherwise><span class="badge badge-red">Inactive</span></c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <div class="actions">
                    <a href="${pageContext.request.contextPath}/admin/users/edit?id=${u.id}"
                       class="btn btn-ghost btn-sm">✏️ Edit</a>
                    <c:if test="${u.role != 'admin'}">
                      <form method="post" action="${pageContext.request.contextPath}/admin/users/delete"
                            style="display:inline;"
                            onsubmit="return confirm('Delete user \'${u.fullName}\'?')">
                        <input type="hidden" name="id" value="${u.id}" />
                        <button type="submit" class="btn btn-danger btn-sm">🗑️</button>
                      </form>
                    </c:if>
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


