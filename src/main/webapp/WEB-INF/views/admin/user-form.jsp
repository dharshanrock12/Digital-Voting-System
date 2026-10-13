<%-- admin/user-form.jsp — Add/Edit user form --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../header.jsp">
  <jsp:param name="pageTitle" value="${empty editUser ? 'Add User' : 'Edit User'}" />
  <jsp:param name="activeNav" value="users" />
</jsp:include>

<div class="page-header">
  <h2>${empty editUser ? 'Add New User' : 'Edit User'}</h2>
  <p><a href="${pageContext.request.contextPath}/admin/users" style="color:var(--primary);">← Back to Users</a></p>
</div>

<div class="card" style="max-width:640px;">
  <form method="post" action="${pageContext.request.contextPath}/admin/users/save" id="user-form">
    <input type="hidden" name="id" value="${editUser.id}" />

    <div class="form-row">
      <div class="form-group">
        <label class="form-label" for="fullName">Full Name *</label>
        <input class="form-input" type="text" id="fullName" name="fullName" required
               placeholder="Full Name" value="<c:out value='${editUser.fullName}'/>" />
      </div>
      <div class="form-group">
        <label class="form-label" for="username">Username *</label>
        <input class="form-input" type="text" id="username" name="username" required
               placeholder="Username" value="<c:out value='${editUser.username}'/>" />
      </div>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label class="form-label" for="password">
          Password ${empty editUser ? '*' : '(leave blank to keep current)'}
        </label>
        <input class="form-input" type="password" id="password" name="password"
               placeholder="${empty editUser ? 'Set password' : 'New password (optional)'}"
               ${empty editUser ? 'required' : ''} />
      </div>
      <div class="form-group">
        <label class="form-label" for="role">Role *</label>
        <select class="form-select" id="role" name="role" onchange="toggleVoterFields()" required>
          <option value="voter"   ${editUser.role == 'voter'   ? 'selected' : ''}>Voter</option>
          <option value="officer" ${editUser.role == 'officer' ? 'selected' : ''}>Election Officer</option>
          <option value="admin"   ${editUser.role == 'admin'   ? 'selected' : ''}>Admin</option>
        </select>
      </div>
    </div>

    <div id="voter-fields">
      <div class="form-row">
        <div class="form-group">
          <label class="form-label" for="voterId">Voter ID</label>
          <input class="form-input" type="text" id="voterId" name="voterId"
                 placeholder="e.g. ECI-004" value="<c:out value='${editUser.voterId}'/>" />
        </div>
        <div class="form-group">
          <label class="form-label" for="constituency">Constituency</label>
          <input class="form-input" type="text" id="constituency" name="constituency"
                 placeholder="e.g. Ward-1" value="<c:out value='${editUser.constituency}'/>" />
        </div>
      </div>
    </div>

    <div class="form-group">
      <label style="display:flex;align-items:center;gap:8px;cursor:pointer;">
        <input type="checkbox" name="active" id="active"
               ${(empty editUser || editUser.active) ? 'checked' : ''}
               style="accent-color:var(--primary);" />
        <span style="font-size:0.9rem;">Active Account</span>
      </label>
    </div>

    <div style="display:flex;gap:10px;margin-top:1.5rem;">
      <button type="submit" class="btn btn-primary">
        ${empty editUser ? 'Create User' : 'Save Changes'}
      </button>
      <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-ghost">Cancel</a>
    </div>
  </form>
</div>

<script>
function toggleVoterFields() {
  const role = document.getElementById('role').value;
  document.getElementById('voter-fields').style.display = role === 'voter' ? '' : 'none';
}
toggleVoterFields();
</script>

<jsp:include page="../footer.jsp" />


