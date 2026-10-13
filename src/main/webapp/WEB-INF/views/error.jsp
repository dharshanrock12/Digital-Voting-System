<%-- error.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Error | Digital Voting System</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@700&family=Inter:wght@400&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
</head>
<body>
<div class="landing" style="text-align:center;">
  <div style="font-size:5rem;margin-bottom:1.5rem;">⚠️</div>
  <h1>Something went wrong</h1>
  <p class="text-muted" style="margin:1rem 0 2rem;max-width:480px;">
    <%= exception != null ? exception.getMessage() : "An unexpected error occurred." %>
  </p>
  <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">← Return to Login</a>
</div>
</body>
</html>
