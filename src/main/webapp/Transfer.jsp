<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.math.BigDecimal" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    String firstName = (String) session.getAttribute("firstName");
    BigDecimal balance = (BigDecimal) session.getAttribute("balance");

    if(accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
%>
<jsp:include page="/includes/header.jsp" />

<div style="max-width: 42rem; margin: 0 auto;">
    <!-- Page Header -->
    <div style="margin-bottom: 1.5rem;">
        <h1 style="font-size: 1.5rem; font-weight: bold;">Fund Transfer</h1>
        <p style="color: #6b7280;">Transfer money to other bank accounts</p>
    </div>

    <!-- Balance Card -->
    <div style="background: linear-gradient(135deg, #2563eb, #1e40af); border-radius: 0.75rem; padding: 1.5rem; margin-bottom: 1.5rem; color: white;">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <div>
                <p style="color: #bfdbfe; font-size: 0.875rem;">Available Balance</p>
                <p style="font-size: 1.875rem; font-weight: bold;">₹ <%= balance != null ? String.format("%,.2f", balance) : "0.00" %></p>
            </div>
            <i class="fas fa-exchange-alt" style="font-size: 2.25rem; opacity: 0.5;"></i>
        </div>
    </div>

    <div class="bg-white" style="border-radius: 0.75rem; padding: 2rem; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);">
        <!-- Quick Beneficiaries -->
        <div style="margin-bottom: 1.5rem;">
            <label style="display: block; font-size: 0.875rem; font-weight: 500; margin-bottom: 0.75rem;">Quick Beneficiaries</label>
            <div style="display: flex; gap: 0.75rem; overflow-x: auto; padding-bottom: 0.5rem;">
                <div style="flex-shrink: 0; width: 4rem; text-align: center;">
                    <div style="width: 3rem; height: 3rem; background: #dbeafe; border-radius: 9999px; display: flex; align-items: center; justify-content: center; margin: 0 auto 0.25rem;">
                        <i class="fas fa-user" style="color: #2563eb;"></i>
                    </div>
                    <p style="font-size: 0.75rem;">John</p>
                </div>
                <div style="flex-shrink: 0; width: 4rem; text-align: center;">
                    <div style="width: 3rem; height: 3rem; background: #d1fae5; border-radius: 9999px; display: flex; align-items: center; justify-content: center; margin: 0 auto 0.25rem;">
                        <i class="fas fa-user" style="color: #059669;"></i>
                    </div>
                    <p style="font-size: 0.75rem;">Priya</p>
                </div>
                <div style="flex-shrink: 0; width: 4rem; text-align: center;">
                    <div style="width: 3rem; height: 3rem; background: #f3e8ff; border-radius: 9999px; display: flex; align-items: center; justify-content: center; margin: 0 auto 0.25rem;">
                        <i class="fas fa-user" style="color: #9333ea;"></i>
                    </div>
                    <p style="font-size: 0.75rem;">Rahul</p>
                </div>
                <div style="flex-shrink: 0; width: 4rem; text-align: center;">
                    <div style="width: 3rem; height: 3rem; background: #fef3c7; border-radius: 9999px; display: flex; align-items: center; justify-content: center; margin: 0 auto 0.25rem;">
                        <i class="fas fa-plus" style="color: #d97706;"></i>
                    </div>
                    <p style="font-size: 0.75rem;">Add</p>
                </div>
            </div>
        </div>

        <!-- Transfer Form -->
        <form action="<%= request.getContextPath() %>/transfer" method="POST" onsubmit="return validateTransfer()">
            <div style="margin-bottom: 1rem;">
                <label style="display: block; font-size: 0.875rem; font-weight: 500; margin-bottom: 0.5rem;">From Account</label>
                <input type="text" value="Savings Account - XXXX<%= String.valueOf(accountNumber).substring(Math.max(0, String.valueOf(accountNumber).length()-4)) %>"
                       style="width: 100%; padding: 0.75rem; background: #f3f4f6; border: 1px solid #e5e7eb; border-radius: 0.5rem;" readonly>
            </div>

            <div style="margin-bottom: 1rem;">
                <label style="display: block; font-size: 0.875rem; font-weight: 500; margin-bottom: 0.5rem;">To Account Number</label>
                <input type="number" name="toAccount" id="toAccount" required
                       style="width: 100%; padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: 0.5rem;"
                       placeholder="Enter beneficiary account number">
            </div>

            <div style="margin-bottom: 1rem;">
                <label style="display: block; font-size: 0.875rem; font-weight: 500; margin-bottom: 0.5rem;">Amount (₹)</label>
                <input type="number" name="amount" id="amount" step="0.01" min="1" required
                       style="width: 100%; padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: 0.5rem; text-align: right; font-size: 1.25rem;"
                       placeholder="0.00">
            </div>

            <div style="margin-bottom: 1.5rem;">
                <label style="display: block; font-size: 0.875rem; font-weight: 500; margin-bottom: 0.5rem;">Remarks (Optional)</label>
                <input type="text" name="remarks"
                       style="width: 100%; padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: 0.5rem;"
                       placeholder="Add a remark">
            </div>

            <div style="margin-bottom: 1.5rem; padding: 1rem; background: #eff6ff; border-radius: 0.5rem;">
                <div style="display: flex; align-items: start;">
                    <i class="fas fa-info-circle" style="color: #2563eb; margin-top: 0.25rem; margin-right: 0.75rem;"></i>
                    <div>
                        <p style="font-size: 0.875rem; color: #1e40af; font-weight: 500;">Transfer Charges: ₹0</p>
                        <p style="font-size: 0.75rem; color: #3b82f6;">IMPS/NEFT transfers are free</p>
                    </div>
                </div>
            </div>

            <div style="display: flex; gap: 1rem;">
                <button type="submit" style="flex: 1; background: #2563eb; color: white; padding: 1rem; border-radius: 0.5rem; font-weight: 600; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center;" onmouseover="this.style.background='#1e40af'" onmouseout="this.style.background='#2563eb'">
                    <i class="fas fa-exchange-alt" style="margin-right: 0.5rem;"></i> Transfer Now
                </button>
                <a href="home" style="flex: 1; background: #e5e7eb; color: #374151; padding: 1rem; border-radius: 0.5rem; font-weight: 600; text-align: center; text-decoration: none;" onmouseover="this.style.background='#d1d5db'" onmouseout="this.style.background='#e5e7eb'">
                    Cancel
                </a>
            </div>
        </form>
    </div>
</div>

<script>
    function validateTransfer() {
        const toAccount = document.getElementById('toAccount').value;
        const amount = parseFloat(document.getElementById('amount').value);
        const balance = <%= balance != null ? balance : 0 %>;

        if(!toAccount || toAccount.length < 8) {
            alert('Please enter a valid account number');
            return false;
        }
        if(toAccount === '<%= accountNumber %>') {
            alert('You cannot transfer money to your own account');
            return false;
        }
        if(amount <= 0) {
            alert('Please enter a valid amount');
            return false;
        }
        if(amount > balance) {
            alert('Insufficient balance for this transfer');
            return false;
        }
        return confirm('Transfer ₹' + amount.toFixed(2) + ' to account ' + toAccount + '?');
    }
</script>

<jsp:include page="/includes/footer.jsp" />