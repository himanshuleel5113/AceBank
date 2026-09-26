<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.acebank.lite.models.Transaction" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    BigDecimal balance = (BigDecimal) session.getAttribute("balance");
    @SuppressWarnings("unchecked")
    List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");

    if (accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }

    DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");
    DateTimeFormatter isoFmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    // Running balance: newest-first list. balanceAfter(newest) == current balance.
    // Walk down (older) by reversing each transaction's effect.
    BigDecimal running = (balance != null) ? balance : BigDecimal.ZERO;
    String ctx = request.getContextPath();
%>
<jsp:include page="/includes/header.jsp" />

<div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:1rem;margin-bottom:1.5rem;">
    <div>
        <h2 style="font-size:1.5rem;font-weight:bold;">Account Statement</h2>
        <p class="text-gray-600" style="font-size:0.875rem;">Account No: <span style="font-family:monospace;font-weight:600;"><%= accountNumber %></span></p>
    </div>
    <button onclick="exportCSV()" style="background:#059669;color:white;border:none;padding:0.6rem 1.2rem;border-radius:0.5rem;font-weight:600;cursor:pointer;display:flex;align-items:center;gap:0.5rem;">
        <i class="fas fa-file-csv"></i> Export CSV
    </button>
</div>

<!-- Filters -->
<div class="bg-white" style="border-radius:0.75rem;padding:1.25rem;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);margin-bottom:1.5rem;">
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4" style="align-items:end;">
        <div>
            <label class="text-gray-600" style="font-size:0.8rem;display:block;margin-bottom:0.35rem;">From Date</label>
            <input type="date" id="fromDate" class="border-2" style="width:100%;padding:0.55rem;border:2px solid #e5e7eb;border-radius:0.5rem;">
        </div>
        <div>
            <label class="text-gray-600" style="font-size:0.8rem;display:block;margin-bottom:0.35rem;">To Date</label>
            <input type="date" id="toDate" class="border-2" style="width:100%;padding:0.55rem;border:2px solid #e5e7eb;border-radius:0.5rem;">
        </div>
        <div>
            <label class="text-gray-600" style="font-size:0.8rem;display:block;margin-bottom:0.35rem;">Type</label>
            <select id="typeFilter" class="border-2" style="width:100%;padding:0.55rem;border:2px solid #e5e7eb;border-radius:0.5rem;">
                <option value="">All Types</option>
                <option value="DEPOSIT">Deposit</option>
                <option value="WITHDRAWAL">Withdrawal</option>
                <option value="TRANSFER">Transfer</option>
            </select>
        </div>
        <div style="display:flex;gap:0.5rem;">
            <button onclick="applyFilters()" style="flex:1;background:#2563eb;color:white;border:none;padding:0.6rem;border-radius:0.5rem;font-weight:600;cursor:pointer;">Apply</button>
            <button onclick="clearFilters()" style="background:#e5e7eb;color:#374151;border:none;padding:0.6rem 0.9rem;border-radius:0.5rem;font-weight:600;cursor:pointer;">Clear</button>
        </div>
    </div>
</div>

<!-- Statement Table -->
<div class="bg-white" style="border-radius:0.75rem;padding:1.5rem;box-shadow:0 4px 6px -1px rgba(0,0,0,0.1);">
    <% if (transactions != null && !transactions.isEmpty()) { %>
        <div style="overflow-x:auto;">
            <table id="statementTable" style="width:100%;border-collapse:collapse;">
                <thead>
                    <tr style="background:linear-gradient(135deg,#0f2b4b,#1e3a5f);color:white;">
                        <th style="padding:0.75rem 1rem;text-align:left;">Date &amp; Time</th>
                        <th style="padding:0.75rem 1rem;text-align:left;">Description</th>
                        <th style="padding:0.75rem 1rem;text-align:left;">Type</th>
                        <th style="padding:0.75rem 1rem;text-align:right;">Debit</th>
                        <th style="padding:0.75rem 1rem;text-align:right;">Credit</th>
                        <th style="padding:0.75rem 1rem;text-align:right;">Balance</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    for (Transaction t : transactions) {
                        boolean isDebit = (t.senderAccount() != null && t.senderAccount().equals(accountNumber));
                        BigDecimal balanceAfter = running;   // balance right after this transaction
                        // reverse effect for the next (older) row
                        running = isDebit ? running.add(t.amount()) : running.subtract(t.amount());

                        String badgeBg = "DEPOSIT".equals(t.txType()) ? "#d1fae5" : "WITHDRAWAL".equals(t.txType()) ? "#fed7aa" : "#dbeafe";
                        String badgeFg = "DEPOSIT".equals(t.txType()) ? "#065f46" : "WITHDRAWAL".equals(t.txType()) ? "#92400e" : "#1e40af";
                        String desc;
                        if ("TRANSFER".equals(t.txType())) {
                            Integer other = isDebit ? t.receiverAccount() : t.senderAccount();
                            String tail = (other != null) ? other.toString() : "";
                            tail = tail.length() > 4 ? tail.substring(tail.length() - 4) : tail;
                            desc = (isDebit ? "Transfer to XXXX" : "Transfer from XXXX") + tail;
                        } else if ("DEPOSIT".equals(t.txType())) {
                            desc = "Cash Deposit";
                        } else {
                            desc = "Cash Withdrawal";
                        }
                        String remark = (t.remark() != null && !t.remark().isBlank()) ? t.remark() : desc;
                    %>
                        <tr class="stmt-row" style="border-bottom:1px solid #e5e7eb;"
                            data-date="<%= t.createdAt().format(isoFmt) %>"
                            data-type="<%= t.txType() %>">
                            <td style="padding:0.75rem 1rem;font-size:0.875rem;"><%= t.createdAt().format(dateFmt) %></td>
                            <td style="padding:0.75rem 1rem;font-size:0.875rem;"><c:out value="<%= remark %>"/></td>
                            <td style="padding:0.75rem 1rem;">
                                <span style="background:<%= badgeBg %>;color:<%= badgeFg %>;padding:0.25rem 0.6rem;border-radius:9999px;font-size:0.75rem;font-weight:600;"><%= t.txType() %></span>
                            </td>
                            <td style="padding:0.75rem 1rem;text-align:right;color:#dc2626;font-weight:600;"><%= isDebit ? "₹ " + String.format("%,.2f", t.amount()) : "-" %></td>
                            <td style="padding:0.75rem 1rem;text-align:right;color:#059669;font-weight:600;"><%= !isDebit ? "₹ " + String.format("%,.2f", t.amount()) : "-" %></td>
                            <td style="padding:0.75rem 1rem;text-align:right;font-weight:600;">₹ <%= String.format("%,.2f", balanceAfter) %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
            <div id="noResults" style="display:none;text-align:center;padding:2rem;" class="text-gray-500">
                <i class="fas fa-filter" style="font-size:2rem;opacity:0.4;"></i>
                <p style="margin-top:0.5rem;">No transactions match your filters</p>
            </div>
        </div>
    <% } else { %>
        <div style="text-align:center;padding:3rem;" class="text-gray-500">
            <i class="fas fa-receipt" style="font-size:3rem;margin-bottom:1rem;opacity:0.5;"></i>
            <p style="font-size:1.125rem;">No transactions found</p>
        </div>
    <% } %>
</div>

<script>
    function applyFilters() {
        const from = document.getElementById('fromDate').value;
        const to = document.getElementById('toDate').value;
        const type = document.getElementById('typeFilter').value;
        const rows = document.querySelectorAll('.stmt-row');
        let visible = 0;
        rows.forEach(row => {
            const d = row.getAttribute('data-date');
            const t = row.getAttribute('data-type');
            let show = true;
            if (from && d < from) show = false;
            if (to && d > to) show = false;
            if (type && t !== type) show = false;
            row.style.display = show ? '' : 'none';
            if (show) visible++;
        });
        const nr = document.getElementById('noResults');
        if (nr) nr.style.display = visible === 0 ? 'block' : 'none';
    }
    function clearFilters() {
        document.getElementById('fromDate').value = '';
        document.getElementById('toDate').value = '';
        document.getElementById('typeFilter').value = '';
        document.querySelectorAll('.stmt-row').forEach(r => r.style.display = '');
        const nr = document.getElementById('noResults');
        if (nr) nr.style.display = 'none';
    }
    function exportCSV() {
        const rows = document.querySelectorAll('.stmt-row');
        let csv = 'Date,Description,Type,Debit,Credit,Balance\n';
        rows.forEach(row => {
            if (row.style.display === 'none') return;
            const cells = row.querySelectorAll('td');
            const vals = [];
            cells.forEach(c => vals.push('"' + c.textContent.trim().replace(/"/g, '""') + '"'));
            csv += vals.join(',') + '\n';
        });
        const blob = new Blob([csv], { type: 'text/csv' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'AceBank_Statement_<%= accountNumber %>.csv';
        a.click();
        URL.revokeObjectURL(url);
    }
</script>

<jsp:include page="/includes/footer.jsp" />
