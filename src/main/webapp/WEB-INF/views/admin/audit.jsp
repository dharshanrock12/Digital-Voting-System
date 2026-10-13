<%-- admin/audit.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../header.jsp">
  <jsp:param name="pageTitle" value="Audit Log" />
  <jsp:param name="activeNav" value="audit" />
</jsp:include>

<div class="page-header flex-between">
  <div>
    <h2>Audit Log</h2>
    <p>Complete trail of all system events.</p>
  </div>
  <span class="badge badge-blue">${logs.size()} entries</span>
</div>

<div class="card">
  <div class="audit-list">
    <c:choose>
      <c:when test="${empty logs}">
        <div class="empty-state"><div class="empty-icon">📝</div><p>No audit entries yet.</p></div>
      </c:when>
      <c:otherwise>
        <c:forEach var="log" items="${logs}">
          <div class="audit-item">
            <div class="audit-dot" style="background:var(--primary)"></div>
            <div class="audit-time" style="min-width:160px;">
              <c:out value="${log.formattedAt}" />
            </div>
            <div style="min-width:160px;">
              <span class="badge badge-blue"><c:out value="${log.action}" /></span>
            </div>
            <div class="audit-msg" style="flex:1">
              <span class="audit-user">
                <c:out value="${log.performedByName != null ? log.performedByName : 'System'}" />
              </span>
              — <c:out value="${log.message}" />
            </div>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<jsp:include page="../footer.jsp" />



