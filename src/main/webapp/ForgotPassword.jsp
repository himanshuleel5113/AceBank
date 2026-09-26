<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String errorMsg = request.getParameter("error");
    if (errorMsg != null) errorMsg = errorMsg.replace("+", " ");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AceBank - Forgot Password</title>
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
                        <div class="h-20 w-20 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
                            <i class="fas fa-key text-3xl text-blue-600"></i>
                        </div>
                        <h2 class="text-2xl font-bold text-gray-800">Forgot Password?</h2>
                        <p class="text-gray-500 mt-2">Enter your email to receive OTP</p>
                    </div>

                    <% if(errorMsg != null) { %>
                        <div class="mb-4 p-4 bg-red-50 border border-red-200 rounded-lg flex items-center">
                            <i class="fas fa-exclamation-circle text-red-500 mr-3"></i>
                            <p class="text-red-600 text-sm"><c:out value="<%= errorMsg %>"/></p>
                        </div>
                    <% } %>

                    <form action="Forgot" method="POST" class="space-y-6" onsubmit="return validateForm()">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">
                                <i class="fas fa-envelope mr-2"></i>Email Address
                            </label>
                            <input type="email" name="email" id="email" required
                                   class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-600 focus:border-transparent"
                                   placeholder="john.doe@example.com">
                        </div>

                        <div class="bg-yellow-50 p-4 rounded-lg">
                            <p class="text-sm text-yellow-800 flex items-center">
                                <i class="fas fa-info-circle mr-2"></i>
                                We'll send a 6-digit OTP to your email for verification
                            </p>
                        </div>

                        <button type="submit" class="w-full bg-blue-600 text-white py-3 rounded-lg font-semibold hover:bg-blue-700 transition flex items-center justify-center">
                            <i class="fas fa-paper-plane mr-2"></i>Send OTP
                        </button>
                    </form>

                    <div class="mt-6 text-center">
                        <a href="Login.jsp" class="text-blue-600 hover:text-blue-800">
                            <i class="fas fa-arrow-left mr-2"></i>Back to Login
                        </a>
                    </div>

                    <hr class="my-6">

                    <p class="text-center text-gray-600">
                        Don't have an account?
                        <a href="SignUp.jsp" class="text-blue-600 font-semibold hover:underline">Sign Up</a>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <script>
        function validateForm() {
            const email = document.getElementById('email').value;
            if(!email || !email.includes('@') || !email.includes('.')) {
                alert('Please enter a valid email address');
                return false;
            }
            return true;
        }
    </script>
</body>
</html>