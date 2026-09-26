<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.util.List" %>
<%@ page import="com.acebank.lite.models.Notification" %>
<%@ page import="com.acebank.lite.service.NotificationService" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");

    if (accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }

    List<Notification> notifications = NotificationService.getNotifications(accountNumber);
    int unreadCount = NotificationService.getUnreadCount(accountNumber);
%>
<jsp:include page="/includes/header.jsp" />

<div style="max-width: 48rem; margin: 0 auto;">
    <!-- Page Header -->
    <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:1rem; margin-bottom:1.5rem;">
        <div>
            <h1 style="font-size:1.5rem; font-weight:bold;">Notifications</h1>
            <p style="color:#6b7280;">You have <%= unreadCount %> unread notification<%= unreadCount == 1 ? "" : "s" %></p>
        </div>
        <div style="display:flex; gap:0.5rem;">
            <button onclick="pageMarkAllRead()" style="background:#2563eb; color:white; border:none; cursor:pointer; padding:0.5rem 1rem; border-radius:0.5rem; font-size:0.875rem; font-weight:600;">
                <i class="fas fa-check-double" style="margin-right:0.4rem;"></i> Mark all read
            </button>
            <button onclick="pageClearAll()" style="background:#e5e7eb; color:#374151; border:none; cursor:pointer; padding:0.5rem 1rem; border-radius:0.5rem; font-size:0.875rem; font-weight:600;">
                <i class="fas fa-trash-can" style="margin-right:0.4rem;"></i> Clear all
            </button>
        </div>
    </div>

    <div class="bg-white" style="border-radius:0.75rem; box-shadow:0 10px 15px -3px rgba(0,0,0,0.1); overflow:hidden;">
        <% if (notifications != null && !notifications.isEmpty()) {
            for (Notification n : notifications) { %>
                <div class="notification-item" style="padding:1.25rem; display:flex; align-items:flex-start; gap:1rem; cursor:pointer; <%= !n.isRead() ? "background:#eff6ff;" : "" %>"
                     onclick="pageMarkRead(<%= n.getId() %>, '<%= request.getContextPath() %>/<%= n.getActionLink() %>')">
                    <div style="height:2.5rem; width:2.5rem; border-radius:9999px; background:#f3f4f6; display:flex; align-items:center; justify-content:center; flex-shrink:0;">
                        <i class="fas <%= n.getIcon() %>"></i>
                    </div>
                    <div style="flex:1;">
                        <p style="color:#1f2937;"><c:out value="<%= n.getMessage() %>"/></p>
                        <p style="font-size:0.8rem; color:#6b7280; margin-top:0.25rem;"><%= n.getFormattedTime() %></p>
                    </div>
                    <% if (!n.isRead()) { %>
                        <span style="height:0.5rem; width:0.5rem; background:#2563eb; border-radius:9999px; margin-top:0.5rem; flex-shrink:0;"></span>
                    <% } %>
                </div>
        <% } } else { %>
            <div style="padding:3rem; text-align:center; color:#9ca3af;">
                <i class="fas fa-bell-slash" style="font-size:3rem; margin-bottom:1rem;"></i>
                <p style="font-size:1.125rem;">No notifications</p>
                <p style="font-size:0.875rem;">You're all caught up!</p>
            </div>
        <% } %>
    </div>
</div>

<script>
    // Page-scoped helpers (distinct names so they don't collide with footer.jsp's dropdown helpers)
    function pageMarkRead(id, link) {
        fetch('<%= request.getContextPath() %>/notifications?action=markRead&id=' + id)
            .then(() => { window.location.href = link; })
            .catch(() => { window.location.href = link; });
    }
    function pageMarkAllRead() {
        fetch('<%= request.getContextPath() %>/notifications?action=markAllRead')
            .then(() => window.location.reload())
            .catch(err => console.error('Error:', err));
    }
    function pageClearAll() {
        if (confirm('Clear all notifications?')) {
            fetch('<%= request.getContextPath() %>/notifications?action=clearAll')
                .then(() => window.location.reload())
                .catch(err => console.error('Error:', err));
        }
    }
</script>

<jsp:include page="/includes/footer.jsp" />
