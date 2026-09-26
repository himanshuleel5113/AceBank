<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.acebank.lite.models.Transaction" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    String firstName = (String) session.getAttribute("firstName");
    BigDecimal balance = (BigDecimal) session.getAttribute("balance");
    @SuppressWarnings("unchecked")
    List<Transaction> transactions = (List<Transaction>) session.getAttribute("transactionDetailsList");

    if (accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }

    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");
    String fullAccountNumber = accountNumber.toString();
    String hiddenAccountNumber = "XXXX " + (fullAccountNumber.length() > 4
        ? fullAccountNumber.substring(fullAccountNumber.length() - 4) : fullAccountNumber);

    // Compute simple in/out totals for the summary cards (from loaded history)
    BigDecimal totalIn = BigDecimal.ZERO, totalOut = BigDecimal.ZERO;
    if (transactions != null) {
        for (Transaction t : transactions) {
            boolean isDebit = (t.senderAccount() != null && t.senderAccount().equals(accountNumber));
            if (isDebit) totalOut = totalOut.add(t.amount());
            else totalIn = totalIn.add(t.amount());
        }
    }
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp" />

<!-- Welcome Banner -->
<div class="bg-white" style="background: linear-gradient(135deg, #0f2b4b, #0a1e33); border-radius: 1rem; padding: 1.75rem; margin-bottom: 1.5rem; color: white;">
    <p style="color: #93c5fd; font-size: 0.875rem;">Welcome back,</p>
    <h2 style="font-size: 1.875rem; font-weight: bold; margin-bottom: 0.5rem;"><c:out value="<%= firstName != null ? firstName : \"\" %>"/> 👋</h2>
    <div style="display: flex; align-items: center; gap: 0.5rem;">
        <span style="color: #93c5fd; font-size: 0.875rem;">Account:</span>
        <span style="font-family: monospace; font-size: 1.05rem; font-weight: 600;" id="accountNumberDisplay"><%= hiddenAccountNumber %></span>
        <button onclick="toggleAccountNumber()" style="background:none;border:none;cursor:pointer;color:#93c5fd;font-size:1rem;">
            <i class="fas fa-eye" id="accountToggleIcon"></i>
        </button>
    </div>
</div>

<!-- Account Overview Cards -->
<div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
    <div class="bg-white" style="border-radius:0.75rem;padding:1.5rem;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);border-left:4px solid #2563eb;">
        <div style="display:flex;justify-content:space-between;">
            <div>
                <p class="text-gray-600" style="font-size:0.875rem;">Available Balance</p>
                <div style="display:flex;align-items:center;gap:0.5rem;">
                    <p style="font-size:1.875rem;font-weight:bold;color:#2563eb;" id="balanceAmount">₹ <%= balance != null ? String.format("%,.2f", balance) : "0.00" %></p>
                    <button onclick="toggleBalance()" style="background:none;border:none;cursor:pointer;color:#2563eb;font-size:1.1rem;">
                        <i class="fas fa-eye" id="balanceToggleIcon"></i>
                    </button>
                </div>
                <p class="text-gray-500" style="font-size:0.75rem;margin-top:0.5rem;">Savings account</p>
            </div>
            <div style="width:48px;height:48px;background:#dbeafe;border-radius:9999px;display:flex;align-items:center;justify-content:center;">
                <i class="fas fa-wallet" style="color:#2563eb;font-size:1.25rem;"></i>
            </div>
        </div>
    </div>

    <div class="bg-white" style="border-radius:0.75rem;padding:1.5rem;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);border-left:4px solid #059669;">
        <div style="display:flex;justify-content:space-between;">
            <div>
                <p class="text-gray-600" style="font-size:0.875rem;">Money In</p>
                <p style="font-size:1.875rem;font-weight:bold;color:#059669;">₹ <%= String.format("%,.2f", totalIn) %></p>
                <p class="text-gray-500" style="font-size:0.75rem;margin-top:0.5rem;">Recent credits</p>
            </div>
            <div style="width:48px;height:48px;background:#d1fae5;border-radius:9999px;display:flex;align-items:center;justify-content:center;">
                <i class="fas fa-arrow-down" style="color:#059669;font-size:1.25rem;"></i>
            </div>
        </div>
    </div>

    <div class="bg-white" style="border-radius:0.75rem;padding:1.5rem;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);border-left:4px solid #dc2626;">
        <div style="display:flex;justify-content:space-between;">
            <div>
                <p class="text-gray-600" style="font-size:0.875rem;">Money Out</p>
                <p style="font-size:1.875rem;font-weight:bold;color:#dc2626;">₹ <%= String.format("%,.2f", totalOut) %></p>
                <p class="text-gray-500" style="font-size:0.75rem;margin-top:0.5rem;">Recent debits</p>
            </div>
            <div style="width:48px;height:48px;background:#fee2e2;border-radius:9999px;display:flex;align-items:center;justify-content:center;">
                <i class="fas fa-arrow-up" style="color:#dc2626;font-size:1.25rem;"></i>
            </div>
        </div>
    </div>
</div>

<!-- Quick Actions -->
<h3 style="font-size:1.125rem;font-weight:600;margin-bottom:1rem;display:flex;align-items:center;">
    <i class="fas fa-bolt" style="color:#eab308;margin-right:0.5rem;"></i> Quick Actions
</h3>
<div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
    <a href="<%= ctx %>/Deposit.jsp" class="bg-white quick-action" style="border-radius:0.75rem;padding:1.5rem;text-align:center;text-decoration:none;color:inherit;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);transition:all 0.3s;">
        <div style="width:64px;height:64px;background:#d1fae5;border-radius:9999px;display:flex;align-items:center;justify-content:center;margin:0 auto 0.75rem;">
            <i class="fas fa-arrow-down" style="color:#059669;font-size:1.5rem;"></i>
        </div>
        <span style="display:block;font-weight:600;">Deposit</span>
        <span class="text-gray-500" style="font-size:0.75rem;">Add money</span>
    </a>
    <a href="<%= ctx %>/Withdraw.jsp" class="bg-white quick-action" style="border-radius:0.75rem;padding:1.5rem;text-align:center;text-decoration:none;color:inherit;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);transition:all 0.3s;">
        <div style="width:64px;height:64px;background:#fee2e2;border-radius:9999px;display:flex;align-items:center;justify-content:center;margin:0 auto 0.75rem;">
            <i class="fas fa-arrow-up" style="color:#dc2626;font-size:1.5rem;"></i>
        </div>
        <span style="display:block;font-weight:600;">Withdraw</span>
        <span class="text-gray-500" style="font-size:0.75rem;">Cash out</span>
    </a>
    <a href="<%= ctx %>/Transfer.jsp" class="bg-white quick-action" style="border-radius:0.75rem;padding:1.5rem;text-align:center;text-decoration:none;color:inherit;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);transition:all 0.3s;">
        <div style="width:64px;height:64px;background:#dbeafe;border-radius:9999px;display:flex;align-items:center;justify-content:center;margin:0 auto 0.75rem;">
            <i class="fas fa-exchange-alt" style="color:#2563eb;font-size:1.5rem;"></i>
        </div>
        <span style="display:block;font-weight:600;">Transfer</span>
        <span class="text-gray-500" style="font-size:0.75rem;">Send money</span>
    </a>
    <a href="<%= ctx %>/Loan.jsp" class="bg-white quick-action" style="border-radius:0.75rem;padding:1.5rem;text-align:center;text-decoration:none;color:inherit;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);transition:all 0.3s;">
        <div style="width:64px;height:64px;background:#fef3c7;border-radius:9999px;display:flex;align-items:center;justify-content:center;margin:0 auto 0.75rem;">
            <i class="fas fa-hand-holding-usd" style="color:#d97706;font-size:1.5rem;"></i>
        </div>
        <span style="display:block;font-weight:600;">Apply Loan</span>
        <span class="text-gray-500" style="font-size:0.75rem;">Quick apply</span>
    </a>
</div>

<!-- Recent Transactions -->
<div class="bg-white" style="border-radius:0.75rem;padding:1.5rem;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1rem;">
        <h3 style="font-size:1.125rem;font-weight:600;">
            <i class="fas fa-history" style="color:#2563eb;margin-right:0.5rem;"></i> Recent Transactions
        </h3>
        <a href="<%= ctx %>/statement" style="color:#2563eb;font-size:0.875rem;text-decoration:none;">
            View All <i class="fas fa-arrow-right" style="margin-left:0.25rem;"></i>
        </a>
    </div>

    <% if (transactions != null && !transactions.isEmpty()) { %>
        <div style="overflow-x:auto;">
            <table style="width:100%;border-collapse:collapse;">
                <thead>
                    <tr style="background:linear-gradient(135deg,#0f2b4b,#1e3a5f);color:white;">
                        <th style="padding:0.75rem 1rem;text-align:left;">Date &amp; Time</th>
                        <th style="padding:0.75rem 1rem;text-align:left;">Description</th>
                        <th style="padding:0.75rem 1rem;text-align:left;">Type</th>
                        <th style="padding:0.75rem 1rem;text-align:right;">Amount</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    int count = 0;
                    for (Transaction t : transactions) {
                        if (count++ >= 5) break;
                        boolean isDebit = (t.senderAccount() != null && t.senderAccount().equals(accountNumber));
                        String badgeBg = "DEPOSIT".equals(t.txType()) ? "#d1fae5" : "WITHDRAWAL".equals(t.txType()) ? "#fed7aa" : "#dbeafe";
                        String badgeFg = "DEPOSIT".equals(t.txType()) ? "#065f46" : "WITHDRAWAL".equals(t.txType()) ? "#92400e" : "#1e40af";
                        String desc;
                        if ("TRANSFER".equals(t.txType())) {
                            Integer other = isDebit ? t.receiverAccount() : t.senderAccount();
                            String tail = (other != null) ? other.toString() : "";
                            tail = tail.length() > 4 ? tail.substring(tail.length() - 4) : tail;
                            desc = (isDebit ? "To A/C XXXX" : "From A/C XXXX") + tail;
                        } else if ("DEPOSIT".equals(t.txType())) {
                            desc = "Cash Deposit";
                        } else {
                            desc = "Cash Withdrawal";
                        }
                    %>
                        <tr style="border-bottom:1px solid #e5e7eb;">
                            <td style="padding:0.75rem 1rem;font-size:0.875rem;"><%= t.createdAt().format(formatter) %></td>
                            <td style="padding:0.75rem 1rem;font-size:0.875rem;"><c:out value="<%= desc %>"/></td>
                            <td style="padding:0.75rem 1rem;">
                                <span style="background:<%= badgeBg %>;color:<%= badgeFg %>;padding:0.25rem 0.6rem;border-radius:9999px;font-size:0.75rem;font-weight:600;"><%= t.txType() %></span>
                            </td>
                            <td style="padding:0.75rem 1rem;text-align:right;font-weight:600;<%= isDebit ? "color:#dc2626;" : "color:#059669;" %>">
                                <%= isDebit ? "-" : "+" %> ₹ <%= String.format("%,.2f", t.amount()) %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } else { %>
        <div style="text-align:center;padding:3rem;" class="text-gray-500">
            <i class="fas fa-receipt" style="font-size:3rem;margin-bottom:1rem;opacity:0.5;"></i>
            <p style="font-size:1.125rem;">No transactions yet</p>
            <p style="font-size:0.875rem;">Start by making a deposit or transfer</p>
        </div>
    <% } %>
</div>

<style>
    .quick-action:hover { transform: translateY(-5px); box-shadow: 0 20px 25px -5px rgba(0,0,0,0.12) !important; }
</style>
<script>
    // Account number show/hide
    let accountVisible = false;
    const fullAccountNumber = '<%= fullAccountNumber %>';
    const hiddenAccountNumber = '<%= hiddenAccountNumber %>';
    function toggleAccountNumber() {
        const el = document.getElementById('accountNumberDisplay');
        const icon = document.getElementById('accountToggleIcon');
        el.textContent = accountVisible ? hiddenAccountNumber : fullAccountNumber;
        icon.className = accountVisible ? 'fas fa-eye' : 'fas fa-eye-slash';
        accountVisible = !accountVisible;
    }
    // Balance show/hide
    let balanceVisible = true;
    const originalBalance = '<%= balance != null ? String.format("%,.2f", balance) : "0.00" %>';
    function toggleBalance() {
        const el = document.getElementById('balanceAmount');
        const icon = document.getElementById('balanceToggleIcon');
        el.textContent = balanceVisible ? '₹ ••••••' : '₹ ' + originalBalance;
        icon.className = balanceVisible ? 'fas fa-eye-slash' : 'fas fa-eye';
        balanceVisible = !balanceVisible;
    }
</script>

<jsp:include page="/includes/footer.jsp" />
