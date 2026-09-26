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
        <h1 style="font-size: 1.5rem; font-weight: bold;">Withdraw Money</h1>
        <p style="color: #6b7280;">Withdraw cash from your account</p>
    </div>

    <!-- Balance Card -->
    <div style="background: linear-gradient(135deg, #2563eb, #1e40af); border-radius: 0.75rem; padding: 1.5rem; margin-bottom: 1.5rem; color: white;">
        <div style="display: flex; justify-content: space-between; align-items: center;">
            <div>
                <p style="color: #bfdbfe; font-size: 0.875rem;">Available Balance</p>
                <p style="font-size: 1.875rem; font-weight: bold;">₹ <%= balance != null ? String.format("%,.2f", balance) : "0.00" %></p>
            </div>
            <i class="fas fa-wallet" style="font-size: 2.25rem; opacity: 0.5;"></i>
        </div>
    </div>

    <div class="bg-white" style="border-radius: 0.75rem; padding: 2rem; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);">
        <!-- Quick Amount Selection -->
        <div style="margin-bottom: 1.5rem;">
            <label style="display: block; font-size: 0.875rem; font-weight: 500; margin-bottom: 0.75rem;">Quick Amount</label>
            <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.75rem;">
                <button type="button" onclick="setAmount(1000)" class="quick-amount-btn" style="padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: 0.5rem; background: white; cursor: pointer; transition: all 0.3s;" onmouseover="this.style.borderColor='#dc2626'; this.style.backgroundColor='#fee2e2';" onmouseout="this.style.borderColor='#e5e7eb'; this.style.backgroundColor='white';">₹1,000</button>
                <button type="button" onclick="setAmount(2000)" class="quick-amount-btn" style="padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: 0.5rem; background: white; cursor: pointer; transition: all 0.3s;" onmouseover="this.style.borderColor='#dc2626'; this.style.backgroundColor='#fee2e2';" onmouseout="this.style.borderColor='#e5e7eb'; this.style.backgroundColor='white';">₹2,000</button>
                <button type="button" onclick="setAmount(5000)" class="quick-amount-btn" style="padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: 0.5rem; background: white; cursor: pointer; transition: all 0.3s;" onmouseover="this.style.borderColor='#dc2626'; this.style.backgroundColor='#fee2e2';" onmouseout="this.style.borderColor='#e5e7eb'; this.style.backgroundColor='white';">₹5,000</button>
                <button type="button" onclick="setAmount(10000)" class="quick-amount-btn" style="padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: 0.5rem; background: white; cursor: pointer; transition: all 0.3s;" onmouseover="this.style.borderColor='#dc2626'; this.style.backgroundColor='#fee2e2';" onmouseout="this.style.borderColor='#e5e7eb'; this.style.backgroundColor='white';">₹10,000</button>
                <button type="button" onclick="setAmount(20000)" class="quick-amount-btn" style="padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: 0.5rem; background: white; cursor: pointer; transition: all 0.3s;" onmouseover="this.style.borderColor='#dc2626'; this.style.backgroundColor='#fee2e2';" onmouseout="this.style.borderColor='#e5e7eb'; this.style.backgroundColor='white';">₹20,000</button>
                <button type="button" onclick="setAmount(50000)" class="quick-amount-btn" style="padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: 0.5rem; background: white; cursor: pointer; transition: all 0.3s;" onmouseover="this.style.borderColor='#dc2626'; this.style.backgroundColor='#fee2e2';" onmouseout="this.style.borderColor='#e5e7eb'; this.style.backgroundColor='white';">₹50,000</button>
            </div>
        </div>

        <!-- Daily Limit Info -->
        <div style="margin-bottom: 1.5rem; padding: 1rem; background: #fef3c7; border-radius: 0.5rem;">
            <div style="display: flex; align-items: start;">
                <i class="fas fa-exclamation-triangle" style="color: #d97706; margin-top: 0.25rem; margin-right: 0.75rem;"></i>
                <div>
                    <p style="font-size: 0.875rem; color: #92400e; font-weight: 500;">Daily Withdrawal Limit: ₹50,000</p>
                    <p style="font-size: 0.75rem; color: #b45309;">You can withdraw up to ₹50,000 per day</p>
                </div>
            </div>
        </div>

        <!-- Withdrawal Form -->
        <form action="<%= request.getContextPath() %>/withdraw" method="POST" onsubmit="return validateWithdraw()">

            <div style="margin-bottom: 1.5rem;">
                <label style="display: block; font-size: 0.875rem; font-weight: 500; margin-bottom: 0.5rem;">Amount to Withdraw (₹)</label>
                <input type="number" name="amount" id="amount" step="0.01" min="1" max="50000" required
                       style="width: 100%; padding: 1rem; border: 2px solid #e5e7eb; border-radius: 0.5rem; font-size: 1.5rem; text-align: right;"
                       placeholder="0.00">
            </div>

            <div style="display: flex; gap: 1rem;">
                <button type="submit" style="flex: 1; background: #dc2626; color: white; padding: 1rem; border-radius: 0.5rem; font-weight: 600; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center;" onmouseover="this.style.background='#b91c1c'" onmouseout="this.style.background='#dc2626'">
                    <i class="fas fa-arrow-up" style="margin-right: 0.5rem;"></i> Withdraw Now
                </button>
                <a href="home" style="flex: 1; background: #e5e7eb; color: #374151; padding: 1rem; border-radius: 0.5rem; font-weight: 600; text-align: center; text-decoration: none;" onmouseover="this.style.background='#d1d5db'" onmouseout="this.style.background='#e5e7eb'">
                    Cancel
                </a>
            </div>
        </form>
    </div>
</div>

<script>
    function setAmount(amount) {
        document.getElementById('amount').value = amount;
    }

    function validateWithdraw() {
        const amount = parseFloat(document.getElementById('amount').value);
        const balance = <%= balance != null ? balance : 0 %>;

        if(amount <= 0) {
            alert('Please enter a valid amount');
            return false;
        }
        if(amount > 50000) {
            alert('Daily withdrawal limit is ₹50,000');
            return false;
        }
        if(amount > balance) {
            alert('Insufficient balance. Your available balance is ₹' + balance.toFixed(2));
            return false;
        }
        return confirm('Please confirm withdrawal of ₹' + amount.toFixed(2) + ' from your account?');
    }
</script>

<jsp:include page="/includes/footer.jsp" />