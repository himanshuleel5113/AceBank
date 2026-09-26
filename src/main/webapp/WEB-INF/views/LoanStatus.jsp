<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.acebank.lite.models.LoanApplication" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    if (accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
    @SuppressWarnings("unchecked")
    List<LoanApplication> loans = (List<LoanApplication>) request.getAttribute("loans");
    DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("dd MMM yyyy");
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp" />

<div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:1rem;margin-bottom:1.5rem;">
    <h2 style="font-size:1.5rem;font-weight:bold;">Loan Applications</h2>
    <a href="<%= ctx %>/Loan.jsp" style="background:#d97706;color:white;text-decoration:none;padding:0.6rem 1.2rem;border-radius:0.5rem;font-weight:600;display:flex;align-items:center;gap:0.5rem;">
        <i class="fas fa-plus"></i> New Application
    </a>
</div>

<div class="bg-white" style="border-radius:0.75rem;padding:1.5rem;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);">
    <% if (loans != null && !loans.isEmpty()) { %>
        <div style="overflow-x:auto;">
            <table style="width:100%;border-collapse:collapse;">
                <thead>
                    <tr style="background:linear-gradient(135deg,#0f2b4b,#1e3a5f);color:white;">
                        <th style="padding:0.75rem 1rem;text-align:left;">Applied On</th>
                        <th style="padding:0.75rem 1rem;text-align:left;">Type</th>
                        <th style="padding:0.75rem 1rem;text-align:right;">Amount</th>
                        <th style="padding:0.75rem 1rem;text-align:center;">Tenure</th>
                        <th style="padding:0.75rem 1rem;text-align:left;">Purpose</th>
                        <th style="padding:0.75rem 1rem;text-align:center;">Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (LoanApplication loan : loans) {
                        String st = loan.status() != null ? loan.status() : "PENDING";
                        String bg, fg;
                        switch (st) {
                            case "APPROVED": bg = "#d1fae5"; fg = "#065f46"; break;
                            case "REJECTED": bg = "#fee2e2"; fg = "#991b1b"; break;
                            default:         bg = "#fef3c7"; fg = "#92400e";
                        }
                    %>
                        <tr style="border-bottom:1px solid #e5e7eb;">
                            <td style="padding:0.75rem 1rem;font-size:0.875rem;"><%= loan.appliedAt() != null ? loan.appliedAt().format(dateFmt) : "—" %></td>
                            <td style="padding:0.75rem 1rem;font-size:0.875rem;font-weight:600;"><c:out value="<%= loan.loanType() %>"/></td>
                            <td style="padding:0.75rem 1rem;text-align:right;font-weight:600;">₹ <%= String.format("%,.2f", loan.amount()) %></td>
                            <td style="padding:0.75rem 1rem;text-align:center;font-size:0.875rem;"><%= loan.tenure() %> yr</td>
                            <td style="padding:0.75rem 1rem;font-size:0.875rem;"><c:out value="<%= loan.purpose() != null ? loan.purpose() : \"—\" %>"/></td>
                            <td style="padding:0.75rem 1rem;text-align:center;">
                                <span style="background:<%= bg %>;color:<%= fg %>;padding:0.25rem 0.75rem;border-radius:9999px;font-size:0.75rem;font-weight:600;"><%= st %></span>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } else { %>
        <div style="text-align:center;padding:3rem;" class="text-gray-500">
            <i class="fas fa-hand-holding-usd" style="font-size:3rem;margin-bottom:1rem;opacity:0.5;"></i>
            <p style="font-size:1.125rem;">No loan applications yet</p>
            <p style="font-size:0.875rem;margin-bottom:1.25rem;">Apply for a loan to see its status here.</p>
            <a href="<%= ctx %>/Loan.jsp" style="background:#d97706;color:white;text-decoration:none;padding:0.6rem 1.4rem;border-radius:0.5rem;font-weight:600;">Apply Now</a>
        </div>
    <% } %>
</div>

<jsp:include page="/includes/footer.jsp" />
