<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String email = (String) session.getAttribute("resetEmail");
    Boolean verified = (Boolean) session.getAttribute("otpVerified");

    if (email == null) {
        response.sendRedirect("ForgotPassword.jsp");
        return;
    }
    String errorMsg = request.getParameter("error");
    if (errorMsg != null) errorMsg = errorMsg.replace("+", " ");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AceBank - Reset Password</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-100">
    <div class="min-h-screen flex flex-col">
        <!-- Header -->
        <header class="bg-gradient-to-r from-blue-900 to-blue-800 text-white shadow-lg">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
                <a href="index.jsp" class="text-2xl font-bold">
                    <i class="fas fa-university mr-2"></i>
                    <span class="text-blue-300">Ace</span><span class="text-yellow-400">Bank</span>
                </a>
            </div>
        </header>

        <!-- Main Content -->
        <div class="flex-1 flex items-center justify-center py-12 px-4">
            <div class="max-w-md w-full">
                <div class="bg-white rounded-xl shadow-lg p-8">
                    <div class="text-center mb-8">
                        <div class="h-20 w-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                            <i class="fas fa-key text-3xl text-green-600"></i>
                        </div>
                        <h2 class="text-2xl font-bold text-gray-800">Create New Password</h2>
                        <p class="text-gray-500 mt-2">OTP verified successfully!</p>
                    </div>

                    <% if(errorMsg != null) { %>
                        <div class="mb-4 p-4 bg-red-50 border border-red-200 rounded-lg">
                            <p class="text-red-600 text-sm"><c:out value="<%= errorMsg %>"/></p>
                        </div>
                    <% } %>

                    <form action="ResetPassword" method="POST" class="space-y-6" onsubmit="return validateForm()">
                        <div>
                            <label class="block text-sm font-medium mb-2">New Password</label>
                            <input type="password" name="newPassword" id="newPassword" required
                                   class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-green-600 focus:border-transparent"
                                   placeholder="Enter new password">
                        </div>

                        <div>
                            <label class="block text-sm font-medium mb-2">Confirm Password</label>
                            <input type="password" name="confirmPassword" id="confirmPassword" required
                                   class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-green-600 focus:border-transparent"
                                   placeholder="Confirm new password">
                        </div>

                        <!-- Password Requirements -->
                        <div class="bg-blue-50 p-4 rounded-lg space-y-2">
                            <p class="text-sm font-medium text-blue-800">Password Requirements:</p>
                            <div class="flex items-center text-xs text-gray-600">
                                <i class="fas fa-circle mr-2 text-[8px]"></i>
                                <span>At least 8 characters</span>
                            </div>
                            <div class="flex items-center text-xs text-gray-600">
                                <i class="fas fa-circle mr-2 text-[8px]"></i>
                                <span>At least one uppercase letter</span>
                            </div>
                            <div class="flex items-center text-xs text-gray-600">
                                <i class="fas fa-circle mr-2 text-[8px]"></i>
                                <span>At least one lowercase letter</span>
                            </div>
                            <div class="flex items-center text-xs text-gray-600">
                                <i class="fas fa-circle mr-2 text-[8px]"></i>
                                <span>At least one number</span>
                            </div>
                        </div>

                        <button type="submit" class="w-full bg-green-600 text-white py-3 rounded-lg font-semibold hover:bg-green-700 transition">
                            <i class="fas fa-save mr-2"></i> Reset Password
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        function validateForm() {
            const newPass = document.getElementById('newPassword').value;
            const confirmPass = document.getElementById('confirmPassword').value;

            if(newPass !== confirmPass) {
                alert('Passwords do not match!');
                return false;
            }

            if(newPass.length < 8) {
                alert('Password must be at least 8 characters long');
                return false;
            }

            if(!/[A-Z]/.test(newPass)) {
                alert('Password must contain at least one uppercase letter');
                return false;
            }

            if(!/[a-z]/.test(newPass)) {
                alert('Password must contain at least one lowercase letter');
                return false;
            }

            if(!/[0-9]/.test(newPass)) {
                alert('Password must contain at least one number');
                return false;
            }

            return true;
        }
    </script>
</body>
</html>