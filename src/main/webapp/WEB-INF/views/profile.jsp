<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.acebank.lite.models.UserProfile" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    if (accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
    UserProfile profile = (UserProfile) request.getAttribute("profile");
    String ctx = request.getContextPath();
    DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("dd MMM yyyy");

    String maskedAadhaar = "—";
    if (profile != null && profile.aadhaarNo() != null && profile.aadhaarNo().length() >= 4) {
        String a = profile.aadhaarNo();
        maskedAadhaar = "XXXX XXXX " + a.substring(a.length() - 4);
    }
%>
<jsp:include page="/includes/header.jsp" />

<h2 style="font-size:1.5rem;font-weight:bold;margin-bottom:1.5rem;">My Profile</h2>

<% if (profile != null) { %>
<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
    <!-- Identity card -->
    <div class="bg-white" style="border-radius:0.75rem;padding:1.75rem;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);text-align:center;">
        <div style="width:88px;height:88px;border-radius:9999px;background:linear-gradient(135deg,#fbbf24,#f59e0b);display:flex;align-items:center;justify-content:center;margin:0 auto 1rem;color:#0f2b4b;font-size:2rem;font-weight:bold;">
            <%= profile.firstName() != null && !profile.firstName().isEmpty() ? profile.firstName().substring(0,1).toUpperCase() : "U" %>
        </div>
        <h3 style="font-size:1.25rem;font-weight:bold;"><c:out value="<%= profile.firstName() + \" \" + profile.lastName() %>"/></h3>
        <p class="text-gray-500" style="font-size:0.875rem;"><c:out value="<%= profile.email() %>"/></p>
        <span style="display:inline-block;margin-top:0.75rem;background:#d1fae5;color:#065f46;padding:0.25rem 0.75rem;border-radius:9999px;font-size:0.75rem;font-weight:600;">
            <i class="fas fa-circle-check"></i> <c:out value="<%= profile.status() %>"/>
        </span>
    </div>

    <!-- Details -->
    <div class="bg-white md:col-span-2" style="border-radius:0.75rem;padding:1.75rem;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);">
        <h3 style="font-size:1.05rem;font-weight:600;margin-bottom:1.25rem;">Account Details</h3>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-y-5 gap-x-8">
            <div>
                <p class="text-gray-500" style="font-size:0.75rem;">Account Number</p>
                <p style="font-weight:600;font-family:monospace;"><%= profile.accountNo() %></p>
            </div>
            <div>
                <p class="text-gray-500" style="font-size:0.75rem;">Account Type</p>
                <p style="font-weight:600;"><c:out value="<%= profile.accountType() %>"/></p>
            </div>
            <div>
                <p class="text-gray-500" style="font-size:0.75rem;">Available Balance</p>
                <p style="font-weight:600;color:#2563eb;">₹ <%= String.format("%,.2f", profile.balance()) %></p>
            </div>
            <div>
                <p class="text-gray-500" style="font-size:0.75rem;">Member Since</p>
                <p style="font-weight:600;"><%= profile.createdAt() != null ? profile.createdAt().format(dateFmt) : "—" %></p>
            </div>
            <div>
                <p class="text-gray-500" style="font-size:0.75rem;">Phone</p>
                <p style="font-weight:600;"><c:out value="<%= profile.phone() != null ? profile.phone() : \"Not provided\" %>"/></p>
            </div>
            <div>
                <p class="text-gray-500" style="font-size:0.75rem;">Aadhaar</p>
                <p style="font-weight:600;font-family:monospace;"><%= maskedAadhaar %></p>
            </div>
        </div>
        <hr style="margin:1.5rem 0;" class="border-gray-200">
        <div style="display:flex;gap:0.75rem;flex-wrap:wrap;">
            <a href="<%= ctx %>/ChangePassword.jsp" style="background:#2563eb;color:white;text-decoration:none;padding:0.6rem 1.2rem;border-radius:0.5rem;font-weight:600;">
                <i class="fas fa-key"></i> Change Password
            </a>
            <a href="<%= ctx %>/statement" style="background:#e5e7eb;color:#374151;text-decoration:none;padding:0.6rem 1.2rem;border-radius:0.5rem;font-weight:600;">
                <i class="fas fa-file-alt"></i> View Statement
            </a>
        </div>
    </div>
</div>
<% } else { %>
<div class="bg-white" style="border-radius:0.75rem;padding:3rem;text-align:center;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);" class="text-gray-500">
    <i class="fas fa-user-slash" style="font-size:3rem;opacity:0.4;"></i>
    <p style="margin-top:1rem;">Profile could not be loaded.</p>
</div>
<% } %>

<jsp:include page="/includes/footer.jsp" />
