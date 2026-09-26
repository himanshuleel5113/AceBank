<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.math.BigDecimal" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    String firstName = (String) session.getAttribute("firstName");
    String email = (String) session.getAttribute("email");

    if(accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
%>
<jsp:include page="/includes/header.jsp" />

<style>
    /* Dark mode fixes for loan page */
    .dark-mode .loan-card {
        background: #1f2937 !important;
        border-color: #374151 !important;
        color: #f3f4f6 !important;
    }

    .dark-mode .loan-card h3,
    .dark-mode .loan-card p,
    .dark-mode .loan-card small {
        color: #f3f4f6 !important;
    }

    .dark-mode .loan-card .rate {
        color: #60a5fa !important;
    }

    .dark-mode .application-form {
        background: #1f2937 !important;
        color: #f3f4f6 !important;
    }

    .dark-mode .application-form input,
    .dark-mode .application-form select,
    .dark-mode .application-form textarea {
        background: #374151 !important;
        border-color: #4b5563 !important;
        color: #f3f4f6 !important;
    }

    .dark-mode .application-form label {
        color: #9ca3af !important;
    }

    .dark-mode .pre-approved {
        color: white !important;
    }

    .dark-mode .pre-approved p {
        color: #a7f3d0 !important;
    }
</style>

<div style="max-width: 72rem; margin: 0 auto;">
    <!-- Page Header -->
    <div style="margin-bottom: 1.5rem;">
        <h1 style="font-size: 1.5rem; font-weight: bold;">Loan Services</h1>
        <p style="color: #6b7280;">Choose from our range of loan products</p>
    </div>

    <!-- Pre-approved Offer -->
    <div class="pre-approved" style="background: linear-gradient(135deg, #059669, #047857); border-radius: 0.75rem; padding: 1.5rem; margin-bottom: 2rem; color: white;">
        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
            <div>
                <span style="background: #10b981; padding: 0.25rem 0.75rem; border-radius: 9999px; font-size: 0.75rem; display: inline-block; margin-bottom: 0.5rem;">Pre-approved</span>
                <h2 style="font-size: 1.5rem; font-weight: bold; margin-bottom: 0.5rem;">You're eligible for ₹5,00,000</h2>
                <p style="color: #a7f3d0;">Instant personal loan at 10.5% p.a.</p>
            </div>
            <button onclick="selectLoan('PERSONAL')" style="background: white; color: #059669; padding: 0.75rem 1.5rem; border-radius: 0.5rem; font-weight: 600; border: none; cursor: pointer;" onmouseover="this.style.background='#f3f4f6'" onmouseout="this.style.background='white'">
                Apply Now →
            </button>
        </div>
    </div>

    <!-- Loan Products Grid -->
    <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.5rem; margin-bottom: 2rem;">
        <!-- Home Loan -->
        <div onclick="selectLoan('HOME')" id="card-HOME" class="loan-card" style="background: white; border-radius: 0.75rem; padding: 1.5rem; text-align: center; border: 2px solid transparent; cursor: pointer; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); transition: all 0.3s;" onmouseover="this.style.borderColor='#2563eb'" onmouseout="if(!this.classList.contains('selected')) this.style.borderColor='transparent'">
            <div style="width: 4rem; height: 4rem; background: #dbeafe; border-radius: 9999px; display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem;">
                <i class="fas fa-home" style="font-size: 1.5rem; color: #2563eb;"></i>
            </div>
            <h3 style="font-size: 1.25rem; font-weight: bold;">Home Loan</h3>
            <p class="rate" style="font-size: 1.875rem; font-weight: bold; color: #2563eb; margin: 0.5rem 0;">8.40%</p>
            <p style="font-size: 0.875rem; color: #6b7280;">p.a. onwards</p>
            <small style="font-size: 0.75rem; color: #9ca3af; margin-top: 0.5rem; display: block;">Up to ₹5 Crore</small>
        </div>

        <!-- Personal Loan -->
        <div onclick="selectLoan('PERSONAL')" id="card-PERSONAL" class="loan-card" style="background: white; border-radius: 0.75rem; padding: 1.5rem; text-align: center; border: 2px solid transparent; cursor: pointer; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);" onmouseover="this.style.borderColor='#059669'" onmouseout="if(!this.classList.contains('selected')) this.style.borderColor='transparent'">
            <div style="width: 4rem; height: 4rem; background: #d1fae5; border-radius: 9999px; display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem;">
                <i class="fas fa-user" style="font-size: 1.5rem; color: #059669;"></i>
            </div>
            <h3 style="font-size: 1.25rem; font-weight: bold;">Personal Loan</h3>
            <p class="rate" style="font-size: 1.875rem; font-weight: bold; color: #059669; margin: 0.5rem 0;">10.50%</p>
            <p style="font-size: 0.875rem; color: #6b7280;">p.a. onwards</p>
            <small style="font-size: 0.75rem; color: #9ca3af; margin-top: 0.5rem; display: block;">Up to ₹15 Lakh</small>
        </div>

        <!-- Car Loan -->
        <div onclick="selectLoan('CAR')" id="card-CAR" class="loan-card" style="background: white; border-radius: 0.75rem; padding: 1.5rem; text-align: center; border: 2px solid transparent; cursor: pointer; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);" onmouseover="this.style.borderColor='#d97706'" onmouseout="if(!this.classList.contains('selected')) this.style.borderColor='transparent'">
            <div style="width: 4rem; height: 4rem; background: #fef3c7; border-radius: 9999px; display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem;">
                <i class="fas fa-car" style="font-size: 1.5rem; color: #d97706;"></i>
            </div>
            <h3 style="font-size: 1.25rem; font-weight: bold;">Car Loan</h3>
            <p class="rate" style="font-size: 1.875rem; font-weight: bold; color: #d97706; margin: 0.5rem 0;">8.75%</p>
            <p style="font-size: 0.875rem; color: #6b7280;">p.a. onwards</p>
            <small style="font-size: 0.75rem; color: #9ca3af; margin-top: 0.5rem; display: block;">Up to ₹15 Lakh</small>
        </div>

        <!-- Education Loan -->
        <div onclick="selectLoan('EDUCATION')" id="card-EDUCATION" class="loan-card" style="background: white; border-radius: 0.75rem; padding: 1.5rem; text-align: center; border: 2px solid transparent; cursor: pointer; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);" onmouseover="this.style.borderColor='#9333ea'" onmouseout="if(!this.classList.contains('selected')) this.style.borderColor='transparent'">
            <div style="width: 4rem; height: 4rem; background: #f3e8ff; border-radius: 9999px; display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem;">
                <i class="fas fa-graduation-cap" style="font-size: 1.5rem; color: #9333ea;"></i>
            </div>
            <h3 style="font-size: 1.25rem; font-weight: bold;">Education Loan</h3>
            <p class="rate" style="font-size: 1.875rem; font-weight: bold; color: #9333ea; margin: 0.5rem 0;">8.00%</p>
            <p style="font-size: 0.875rem; color: #6b7280;">p.a. onwards</p>
            <small style="font-size: 0.75rem; color: #9ca3af; margin-top: 0.5rem; display: block;">Up to ₹50 Lakh</small>
        </div>
    </div>

    <!-- Application Form -->
    <div id="applicationForm" class="application-form" style="display: none; background: white; border-radius: 0.75rem; padding: 2rem; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);">
        <h3 style="font-size: 1.5rem; font-weight: bold; margin-bottom: 0.5rem;">Apply for <span id="selectedLoanName">Loan</span></h3>
        <p style="color: #6b7280; margin-bottom: 1.5rem;">Please fill in the details below</p>

        <form action="<%= request.getContextPath() %>/Loan" method="POST" onsubmit="return validateLoanForm()">
            <input type="hidden" name="loanType" id="loanType">

            <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 1.5rem; margin-bottom: 1.5rem;">
                <div>
                    <label style="display: block; font-size: 0.875rem; font-weight: 500; margin-bottom: 0.5rem;">Full Name</label>
                    <input type="text" value="<c:out value='<%= firstName %>'/>" style="width: 100%; padding: 0.75rem; background: #f3f4f6; border: 1px solid #e5e7eb; border-radius: 0.5rem;" readonly>
                </div>
                <div>
                    <label style="display: block; font-size: 0.875rem; font-weight: 500; margin-bottom: 0.5rem;">Email Address</label>
                    <input type="email" value="<c:out value='<%= email %>'/>" style="width: 100%; padding: 0.75rem; background: #f3f4f6; border: 1px solid #e5e7eb; border-radius: 0.5rem;" readonly>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 1.5rem; margin-bottom: 1.5rem;">
                <div>
                    <label style="display: block; font-size: 0.875rem; font-weight: 500; margin-bottom: 0.5rem;">Loan Amount (₹)</label>
                    <input type="number" name="amount" id="amount" required
                           style="width: 100%; padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: 0.5rem;"
                           placeholder="Enter amount">
                </div>
                <div>
                    <label style="display: block; font-size: 0.875rem; font-weight: 500; margin-bottom: 0.5rem;">Tenure (Years)</label>
                    <select name="tenure" style="width: 100%; padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: 0.5rem;">
                        <option>1 Year</option>
                        <option>2 Years</option>
                        <option>3 Years</option>
                        <option>5 Years</option>
                        <option>10 Years</option>
                        <option>15 Years</option>
                        <option>20 Years</option>
                    </select>
                </div>
            </div>

            <div style="margin-bottom: 1.5rem;">
                <label style="display: block; font-size: 0.875rem; font-weight: 500; margin-bottom: 0.5rem;">Purpose of Loan</label>
                <textarea name="purpose" rows="3" style="width: 100%; padding: 0.75rem; border: 2px solid #e5e7eb; border-radius: 0.5rem;" placeholder="Briefly describe the purpose..."></textarea>
            </div>

            <button type="submit" style="width: 100%; background: #2563eb; color: white; padding: 1rem; border-radius: 0.5rem; font-weight: 600; border: none; cursor: pointer;" onmouseover="this.style.background='#1e40af'" onmouseout="this.style.background='#2563eb'">
                <i class="fas fa-paper-plane" style="margin-right: 0.5rem;"></i> Submit Application
            </button>
        </form>
    </div>
</div>

<script>
    function selectLoan(type) {
        // Remove selection from all cards
        document.querySelectorAll('[id^="card-"]').forEach(card => {
            card.style.borderColor = 'transparent';
            card.classList.remove('selected');
        });

        // Add selection to clicked card
        const card = document.getElementById('card-' + type);
        if(type === 'HOME') card.style.borderColor = '#2563eb';
        else if(type === 'PERSONAL') card.style.borderColor = '#059669';
        else if(type === 'CAR') card.style.borderColor = '#d97706';
        else if(type === 'EDUCATION') card.style.borderColor = '#9333ea';
        card.classList.add('selected');

        document.getElementById('loanType').value = type;

        const loanNames = {
            'HOME': 'Home Loan',
            'PERSONAL': 'Personal Loan',
            'CAR': 'Car Loan',
            'EDUCATION': 'Education Loan'
        };
        document.getElementById('selectedLoanName').textContent = loanNames[type];

        document.getElementById('applicationForm').style.display = 'block';
        document.getElementById('applicationForm').scrollIntoView({ behavior: 'smooth' });
    }

    function validateLoanForm() {
        const loanType = document.getElementById('loanType').value;
        const amount = document.getElementById('amount').value;

        if(!loanType) {
            alert('Please select a loan type first');
            return false;
        }
        if(amount < 10000) {
            alert('Minimum loan amount is ₹10,000');
            return false;
        }
        return confirm('Submit loan application?');
    }
</script>

<jsp:include page="/includes/footer.jsp" />