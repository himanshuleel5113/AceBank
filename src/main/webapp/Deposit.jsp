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
        <h1 style="font-size: 1.5rem; font-weight: bold;">Deposit Money</h1>
        <p style="color: #6b7280;">Add funds to your account securely</p>
    </div>

    <div class="bg-white" style="border-radius: 0.75rem; padding: 2rem; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);">
        <!-- Quick Amount Selection -->
        <div style="margin-bottom: 1.5rem;">
            <label style="display: block; font-size: 0.875rem; font-weight: 500; margin-bottom: 0.75rem;">Quick Amount</label>
            <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.75rem;">
                <button type="button" onclick="setAmount(1000)" class="quick-amount-btn" style="padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: 0.5rem; background: white; cursor: pointer; transition: all 0.3s;" onmouseover="this.style.borderColor='#059669'; this.style.backgroundColor='#f0fdf4';" onmouseout="this.style.borderColor='#e5e7eb'; this.style.backgroundColor='white';">₹1,000</button>
                <button type="button" onclick="setAmount(5000)" class="quick-amount-btn" style="padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: 0.5rem; background: white; cursor: pointer; transition: all 0.3s;" onmouseover="this.style.borderColor='#059669'; this.style.backgroundColor='#f0fdf4';" onmouseout="this.style.borderColor='#e5e7eb'; this.style.backgroundColor='white';">₹5,000</button>
                <button type="button" onclick="setAmount(10000)" class="quick-amount-btn" style="padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: 0.5rem; background: white; cursor: pointer; transition: all 0.3s;" onmouseover="this.style.borderColor='#059669'; this.style.backgroundColor='#f0fdf4';" onmouseout="this.style.borderColor='#e5e7eb'; this.style.backgroundColor='white';">₹10,000</button>
                <button type="button" onclick="setAmount(25000)" class="quick-amount-btn" style="padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: 0.5rem; background: white; cursor: pointer; transition: all 0.3s;" onmouseover="this.style.borderColor='#059669'; this.style.backgroundColor='#f0fdf4';" onmouseout="this.style.borderColor='#e5e7eb'; this.style.backgroundColor='white';">₹25,000</button>
                <button type="button" onclick="setAmount(50000)" class="quick-amount-btn" style="padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: 0.5rem; background: white; cursor: pointer; transition: all 0.3s;" onmouseover="this.style.borderColor='#059669'; this.style.backgroundColor='#f0fdf4';" onmouseout="this.style.borderColor='#e5e7eb'; this.style.backgroundColor='white';">₹50,000</button>
                <button type="button" onclick="setAmount(100000)" class="quick-amount-btn" style="padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: 0.5rem; background: white; cursor: pointer; transition: all 0.3s;" onmouseover="this.style.borderColor='#059669'; this.style.backgroundColor='#f0fdf4';" onmouseout="this.style.borderColor='#e5e7eb'; this.style.backgroundColor='white';">₹1,00,000</button>
            </div>
        </div>

        <!-- Deposit Form -->
        <form action="<%= request.getContextPath() %>/deposit" method="POST" onsubmit="return validateForm()">
            <div style="margin-bottom: 1.5rem;">
                <label style="display: block; font-size: 0.875rem; font-weight: 500; margin-bottom: 0.5rem;">Amount to Deposit (₹)</label>
                <input type="number" name="amount" id="amount" step="0.01" min="1" required
                       style="width: 100%; padding: 1rem; border: 2px solid #e5e7eb; border-radius: 0.5rem; font-size: 1.5rem; text-align: right;"
                       placeholder="0.00">
            </div>

            <div style="margin-bottom: 1.5rem; padding: 1rem; background: #f0fdf4; border-radius: 0.5rem;">
                <div style="display: flex; align-items: start;">
                    <i class="fas fa-info-circle" style="color: #059669; margin-top: 0.25rem; margin-right: 0.75rem;"></i>
                    <div>
                        <p style="font-size: 0.875rem; color: #047857; font-weight: 500;">Instant Credit</p>
                        <p style="font-size: 0.75rem; color: #059669;">Funds will be credited to your account immediately</p>
                    </div>
                </div>
            </div>

            <div style="display: flex; gap: 1rem;">
                <button type="submit" style="flex: 1; background: #059669; color: white; padding: 1rem; border-radius: 0.5rem; font-weight: 600; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center;" onmouseover="this.style.background='#047857'" onmouseout="this.style.background='#059669'">
                    <i class="fas fa-arrow-down" style="margin-right: 0.5rem;"></i> Deposit Now
                </button>
                <a href="home" style="flex: 1; background: #e5e7eb; color: #374151; padding: 1rem; border-radius: 0.5rem; font-weight: 600; text-align: center; text-decoration: none;" onmouseover="this.style.background='#d1d5db'" onmouseout="this.style.background='#e5e7eb'">
                    Cancel
                </a>
            </div>
        </form>

        <!-- Security Note -->
        <div style="margin-top: 1.5rem; padding: 0.75rem; background: #eff6ff; border-radius: 0.5rem;">
            <p style="font-size: 0.75rem; color: #2563eb; display: flex; align-items: center;">
                <i class="fas fa-shield-alt" style="margin-right: 0.5rem;"></i>
                Your transaction is secure with 256-bit encryption
            </p>
        </div>
    </div>
</div>

<script>
    function setAmount(amount) {
        document.getElementById('amount').value = amount;
    }

    function validateForm() {
        const amount = document.getElementById('amount').value;
        if(amount <= 0) {
            alert('Please enter a valid amount greater than 0');
            return false;
        }
        return confirm('Confirm deposit of ₹' + parseFloat(amount).toFixed(2) + '?');
    }
</script>

<jsp:include page="/includes/footer.jsp" />