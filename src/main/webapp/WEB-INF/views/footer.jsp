<%-- footer.jsp — closes the shell layout opened by header.jsp --%>
    </div><!-- /page-content -->
  </div><!-- /main-content -->
</div><!-- /shell -->

<div id="toast-container"></div>

<script src="${pageContext.request.contextPath}/js/app.js"></script>
<script>
  // Live clock
  (function tick() {
    const el = document.getElementById('current-time');
    if (el) el.textContent = new Date().toLocaleTimeString('en-IN');
    setTimeout(tick, 1000);
  })();

  // Auto-dismiss flash messages
  document.querySelectorAll('.flash').forEach(el => {
    setTimeout(() => el.style.display = 'none', 4000);
  });
</script>
</body>
</html>
