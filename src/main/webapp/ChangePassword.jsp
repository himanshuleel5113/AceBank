<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    String firstName = (String) session.getAttribute("firstName");

    if(accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
    String errorMsg = request.getParameter("error");
    if (errorMsg != null) errorMsg = errorMsg.replace("+", " ");
%>
<jsp:include page="/includes/header.jsp" />

<div class="max-w-lg mx-auto">
    <!-- Page Header -->
    <div class="mb-6">
        <h1 class="text-2xl font-bold">Change Password</h1>
        <p class="text-gray-600">Update your account password</p>
    </div>

    <div class="bg-white rounded-xl shadow-lg p-8">
        <!-- Security Banner -->
        <div class="bg-blue-50 p-4 rounded-lg mb-6">
            <div class="flex items-start">
                <i class="fas fa-shield-alt text-blue-600 mt-1 mr-3"></i>
                <div>
                    <p class="text-sm text-blue-700 font-medium">Security Tips</p>
                    <ul class="text-xs text-blue-600 mt-1 list-disc list-inside">
                        <li>Use a strong password with mix of characters</li>
                        <li>Never share your password with anyone</li>
                        <li>Change password regularly</li>
                    </ul>
                </div>
            </div>
        </div>

        <% if (errorMsg != null) { %>
            <div class="mb-4 p-4 bg-red-50 border border-red-200 rounded-lg flex items-center">
                <i class="fas fa-exclamation-circle text-red-500 mr-3"></i>
                <p class="text-red-600 text-sm"><c:out value="<%= errorMsg %>"/></p>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/ChangePassword" method="POST" id="passwordForm" class="space-y-6">
            <div>
                <label class="block text-sm font-medium mb-2">Current Password</label>
                <input type="password" name="currentPassword" required
                       class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-600 focus:border-transparent">
            </div>

            <div>
                <label class="block text-sm font-medium mb-2">New Password</label>
                <input type="password" name="newPassword" id="newPassword" required
                       class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-600 focus:border-transparent">
            </div>

            <div>
                <label class="block text-sm font-medium mb-2">Confirm New Password</label>
                <input type="password" name="confirmNewPassword" id="confirmPassword" required
                       class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-600 focus:border-transparent">
            </div>

            <!-- Password Requirements -->
            <div class="bg-gray-50 p-4 rounded-lg space-y-2">
                <p class="text-sm font-medium mb-2">Password must contain:</p>
                <div class="flex items-center text-sm" id="req-length">
                    <i class="fas fa-circle text-gray-300 mr-2 text-xs"></i>
                    <span>At least 8 characters</span>
                </div>
                <div class="flex items-center text-sm" id="req-uppercase">
                    <i class="fas fa-circle text-gray-300 mr-2 text-xs"></i>
                    <span>At least one uppercase letter</span>
                </div>
                <div class="flex items-center text-sm" id="req-lowercase">
                    <i class="fas fa-circle text-gray-300 mr-2 text-xs"></i>
                    <span>At least one lowercase letter</span>
                </div>
                <div class="flex items-center text-sm" id="req-number">
                    <i class="fas fa-circle text-gray-300 mr-2 text-xs"></i>
                    <span>At least one number</span>
                </div>
            </div>

            <button type="submit" class="w-full bg-blue-600 text-white py-3 rounded-lg font-semibold hover:bg-blue-700 transition">
                <i class="fas fa-save mr-2"></i> Update Password
            </button>
        </form>
    </div>
</div>

<script>
    document.getElementById('newPassword').addEventListener('input', function() {
        const password = this.value;

        document.getElementById('req-length').innerHTML = password.length >= 8 ?
            '<i class="fas fa-check-circle text-green-500 mr-2"></i><span class="text-green-600">At least 8 characters ✓</span>' :
            '<i class="fas fa-circle text-gray-300 mr-2 text-xs"></i><span>At least 8 characters</span>';

        document.getElementById('req-uppercase').innerHTML = /[A-Z]/.test(password) ?
            '<i class="fas fa-check-circle text-green-500 mr-2"></i><span class="text-green-600">At least one uppercase letter ✓</span>' :
            '<i class="fas fa-circle text-gray-300 mr-2 text-xs"></i><span>At least one uppercase letter</span>';

        document.getElementById('req-lowercase').innerHTML = /[a-z]/.test(password) ?
            '<i class="fas fa-check-circle text-green-500 mr-2"></i><span class="text-green-600">At least one lowercase letter ✓</span>' :
            '<i class="fas fa-circle text-gray-300 mr-2 text-xs"></i><span>At least one lowercase letter</span>';

        document.getElementById('req-number').innerHTML = /[0-9]/.test(password) ?
            '<i class="fas fa-check-circle text-green-500 mr-2"></i><span class="text-green-600">At least one number ✓</span>' :
            '<i class="fas fa-circle text-gray-300 mr-2 text-xs"></i><span>At least one number</span>';
    });

    document.getElementById('passwordForm').addEventListener('submit', function(e) {
        const newPass = document.getElementById('newPassword').value;
        const confirmPass = document.getElementById('confirmPassword').value;

        if(newPass !== confirmPass) {
            e.preventDefault();
            alert('New password and confirm password do not match!');
            return;
        }

        if(newPass.length < 8 || !/[A-Z]/.test(newPass) || !/[a-z]/.test(newPass) || !/[0-9]/.test(newPass)) {
            e.preventDefault();
            alert('Password does not meet the requirements!');
        }
    });
</script>

<jsp:include page="/includes/footer.jsp" />