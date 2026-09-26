<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String savedAccount = "";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("rememberedAccount".equals(c.getName())) {
                savedAccount = c.getValue();
            }
        }
    }
    // Normalize message params server-side; c:out escapes on render (XSS-safe)
    String errorMsg = request.getParameter("error");
    if (errorMsg != null) errorMsg = errorMsg.replace("+", " ");
    String infoMsg = request.getParameter("msg");
    if (infoMsg != null) infoMsg = infoMsg.replace("+", " ");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AceBank - Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .gradient-bg {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
        }
    </style>
</head>
<body class="bg-gray-50">
    <div class="min-h-screen flex flex-col">
        <!-- Simple Header -->
        <header class="gradient-bg text-white shadow-lg">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
                <a href="index.jsp" class="text-2xl font-bold">
                    <i class="fas fa-university mr-2"></i>
                    <span class="text-blue-400">Ace</span><span class="text-yellow-400">Bank</span>
                </a>
            </div>
        </header>

        <!-- Login Form -->
        <div class="flex-1 flex items-center justify-center py-12 px-4">
            <div class="max-w-md w-full">
                <!-- Messages -->
                <% if (errorMsg != null) { %>
                    <div class="mb-4 p-4 bg-red-50 border border-red-200 rounded-lg flex items-center">
                        <i class="fas fa-exclamation-circle text-red-500 mr-3"></i>
                        <p class="text-red-600 text-sm"><c:out value="<%= errorMsg %>"/></p>
                    </div>
                <% } %>
                <% if (infoMsg != null) { %>
                    <div class="mb-4 p-4 bg-green-50 border border-green-200 rounded-lg flex items-center">
                        <i class="fas fa-check-circle text-green-500 mr-3"></i>
                        <p class="text-green-600 text-sm"><c:out value="<%= infoMsg %>"/></p>
                    </div>
                <% } %>

                <!-- Login Card -->
                <div class="bg-white rounded-2xl shadow-xl overflow-hidden">
                    <div class="p-8">
                        <div class="text-center mb-8">
                            <div class="h-20 w-20 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
                                <i class="fas fa-user-lock text-4xl text-blue-600"></i>
                            </div>
                            <h2 class="text-3xl font-bold text-gray-900">Welcome Back</h2>
                            <p class="text-gray-600 mt-2">Login to your AceBank account</p>
                        </div>

                        <form action="Login" method="POST" class="space-y-6" id="loginForm">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">
                                    <i class="fas fa-id-card mr-2"></i>Account Number
                                </label>
                                <input type="text" name="accountNumber" value="<c:out value='<%= savedAccount %>'/>" required
                                       class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-600 focus:border-transparent transition"
                                       placeholder="Enter your 8-digit account number"
                                       pattern="[0-9]{8,}" title="Please enter valid account number">
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">
                                    <i class="fas fa-lock mr-2"></i>Password
                                </label>
                                <input type="password" name="password" required
                                       class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-600 focus:border-transparent transition"
                                       placeholder="••••••••">
                            </div>

                            <div class="flex items-center justify-between">
                                <label class="flex items-center">
                                    <input type="checkbox" name="rememberMe" class="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-blue-500"
                                           <%= !savedAccount.isEmpty() ? "checked" : "" %>>
                                    <span class="ml-2 text-sm text-gray-600">Remember me</span>
                                </label>
                                <a href="ForgotPassword.jsp" class="text-sm text-blue-600 hover:text-blue-800 font-semibold">
                                    Forgot Password?
                                </a>
                            </div>

                            <button type="submit" class="w-full bg-blue-600 text-white py-3 rounded-lg font-semibold text-lg hover:bg-blue-700 transition flex items-center justify-center">
                                <i class="fas fa-sign-in-alt mr-2"></i> Login
                            </button>
                        </form>

                        <div class="mt-6 text-center">
                            <p class="text-gray-600">
                                New to AceBank?
                                <a href="SignUp.jsp" class="text-blue-600 font-semibold hover:text-blue-800">
                                    Create Account <i class="fas fa-arrow-right ml-1"></i>
                                </a>
                            </p>
                        </div>
                    </div>

                    <!-- Security Notice -->
                    <div class="bg-gray-50 px-8 py-4 border-t border-gray-200">
                        <p class="text-xs text-gray-500 flex items-center">
                            <i class="fas fa-shield-alt text-green-500 mr-2"></i>
                            256-bit SSL Secure Login. Your information is protected.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const account = document.querySelector('input[name="accountNumber"]').value;
            const password = document.querySelector('input[name="password"]').value;

            if(!account || !password) {
                e.preventDefault();
                alert('Please enter both account number and password');
            }
        });
    </script>
</body>
</html>