<%-- login.jsp — role-based login page --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Login | Digital Voting System</title>
  <meta name="description" content="Secure login for Digital Voting System — Admin, Officer, Voter" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
</head>
<body>

<!-- Landing / Role Selection -->
<c:if test="${empty param.role}">
<div class="landing">
  <div class="landing-badge"><span class="dot"></span> Secure · Transparent · Efficient</div>
  <h1 class="gradient-text">Digital Voting System</h1>
  <p class="landing-subtitle">
    A fully automated election management platform ensuring secure voter authentication,
    transparent ballot management, and accurate vote counting.
  </p>
  <p style="font-size:0.78rem;color:var(--text-3);margin-bottom:2rem;">
    Dharshan Sathish Kumar &nbsp;·&nbsp; Reg: 3122255002029
  </p>

  <c:if test="${not empty error}">
    <div class="flash flash-error" style="margin-bottom:1.5rem;max-width:480px;"><c:out value="${error}" /></div>
  </c:if>

  <div class="role-cards">
    <a class="role-card" href="?role=admin" id="rc-admin" style="--role-gradient:linear-gradient(135deg,#6366f1,#4f46e5)">
      <span class="role-icon">🛡️</span>
      <h3>Administrator</h3>
      <p>Manage users, officers, and view system reports.</p>
      <span class="role-arrow">Login as Admin →</span>
    </a>
    <a class="role-card" href="?role=officer" id="rc-officer" style="--role-gradient:linear-gradient(135deg,#06b6d4,#0891b2)">
      <span class="role-icon">🗳️</span>
      <h3>Election Officer</h3>
      <p>Manage elections, candidates, voting sessions, and results.</p>
      <span class="role-arrow">Login as Officer →</span>
    </a>
    <a class="role-card" href="?role=voter" id="rc-voter" style="--role-gradient:linear-gradient(135deg,#10b981,#059669)">
      <span class="role-icon">👤</span>
      <h3>Voter</h3>
      <p>Authenticate, view ballot, cast vote, and see results.</p>
      <span class="role-arrow">Login as Voter →</span>
    </a>
  </div>
</div>
</c:if>

<!-- Login Form for selected role -->
<c:if test="${not empty param.role}">
<div class="login-screen">
  <a class="login-back" href="${pageContext.request.contextPath}/login">← Back</a>
  <div class="login-card">
    <div class="login-header">
      <c:choose>
        <c:when test="${param.role == 'admin'}">
          <span class="login-role-icon">🛡️</span>
          <h2>Administrator Login</h2>
          <p>Enter admin credentials to access the control panel.</p>
        </c:when>
        <c:when test="${param.role == 'officer'}">
          <span class="login-role-icon">🗳️</span>
          <h2>Election Officer Login</h2>
          <p>Enter officer credentials to manage elections.</p>
        </c:when>
        <c:otherwise>
          <span class="login-role-icon">👤</span>
          <h2>Voter Login</h2>
          <p>Enter your credentials to cast your vote.</p>
        </c:otherwise>
      </c:choose>
    </div>

    <c:if test="${not empty error}">
      <div class="flash flash-error" style="margin-bottom:1rem;"><c:out value="${error}" /></div>
    </c:if>

    <form class="login-form" id="login-form" method="post"
          action="${pageContext.request.contextPath}/login">
      <input type="hidden" name="role" value="${param.role}" />

      <div class="form-group">
        <label class="form-label" for="username">Username</label>
        <input class="form-input" type="text" id="username" name="username"
               placeholder="Enter username" required autocomplete="username"
               value="<c:out value='${param.username}'/>" />
      </div>
      <div class="form-group">
        <label class="form-label" for="password">Password</label>
        <input class="form-input" type="password" id="password" name="password"
               placeholder="Enter password" required autocomplete="current-password" />
      </div>

      <button type="submit" class="btn btn-primary btn-lg w-full" id="login-btn">
        Login →
      </button>
    </form>

    <div style="margin-top:1.25rem;padding:0.75rem;background:rgba(255,255,255,0.03);
                border-radius:8px;border:1px solid var(--border);font-size:0.78rem;
                color:var(--text-3);text-align:center;">
      🔑 Demo —
      <c:choose>
        <c:when test="${param.role == 'admin'}"><strong>admin</strong> / <strong>admin123</strong></c:when>
        <c:when test="${param.role == 'officer'}"><strong>officer</strong> / <strong>officer123</strong></c:when>
        <c:otherwise><strong>voter1</strong> / <strong>voter123</strong></c:otherwise>
      </c:choose>
    </div>
  </div>
</div>
</c:if>

<script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>


