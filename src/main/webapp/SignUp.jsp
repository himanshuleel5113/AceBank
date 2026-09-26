<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <title>AceBank - Create Account</title>
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
        <!-- Header -->
        <header class="gradient-bg text-white shadow-lg">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 flex justify-between items-center">
                <a href="index.jsp" class="text-2xl font-bold">
                    <i class="fas fa-university mr-2"></i>
                    <span class="text-blue-400">Ace</span><span class="text-yellow-400">Bank</span>
                </a>
                <a href="Login.jsp" class="text-white hover:text-yellow-400 transition">
                    <i class="fas fa-sign-in-alt mr-2"></i>Login
                </a>
            </div>
        </header>

        <!-- Signup Form -->
        <div class="flex-1 flex items-center justify-center py-12 px-4">
            <div class="max-w-3xl w-full">
                <!-- Progress Steps -->
                <div class="mb-8">
                    <div class="flex items-center justify-center">
                        <div class="flex items-center">
                            <div class="h-10 w-10 bg-blue-600 text-white rounded-full flex items-center justify-center font-bold">1</div>
                            <span class="ml-2 text-sm font-semibold text-gray-900">Personal Info</span>
                        </div>
                        <div class="w-16 h-1 bg-gray-300 mx-4"></div>
                        <div class="flex items-center">
                            <div class="h-10 w-10 bg-gray-300 text-gray-600 rounded-full flex items-center justify-center font-bold">2</div>
                            <span class="ml-2 text-sm text-gray-500">Verification</span>
                        </div>
                        <div class="w-16 h-1 bg-gray-300 mx-4"></div>
                        <div class="flex items-center">
                            <div class="h-10 w-10 bg-gray-300 text-gray-600 rounded-full flex items-center justify-center font-bold">3</div>
                            <span class="ml-2 text-sm text-gray-500">Complete</span>
                        </div>
                    </div>
                </div>

                <!-- Error Message -->
                <% if (errorMsg != null) { %>
                    <div class="mb-4 p-4 bg-red-50 border border-red-200 rounded-lg">
                        <p class="text-red-600 text-center"><c:out value="<%= errorMsg %>"/></p>
                    </div>
                <% } %>

                <!-- Signup Card -->
                <div class="bg-white rounded-2xl shadow-xl overflow-hidden">
                    <div class="p-8">
                        <div class="text-center mb-8">
                            <div class="h-20 w-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                                <i class="fas fa-user-plus text-4xl text-green-600"></i>
                            </div>
                            <h2 class="text-3xl font-bold text-gray-900">Open Your Account</h2>
                            <p class="text-gray-600 mt-2">Join thousands of customers who trust AceBank</p>
                        </div>

                        <form action="${pageContext.request.contextPath}/signup" method="POST" id="signupForm" class="space-y-6">
                            <div class="grid md:grid-cols-2 gap-6">
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">
                                        <i class="fas fa-user mr-2"></i>First Name
                                    </label>
                                    <input type="text" name="firstName" id="firstName" required
                                           class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-600 focus:border-transparent"
                                           placeholder="John">
                                </div>
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-2">
                                        <i class="fas fa-user mr-2"></i>Last Name
                                    </label>
                                    <input type="text" name="lastName" id="lastName" required
                                           class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-600 focus:border-transparent"
                                           placeholder="Doe">
                                </div>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">
                                    <i class="fas fa-id-card mr-2"></i>Aadhar Number
                                </label>
                                <input type="text" name="aadharNumber" id="aadharNumber" maxlength="12" pattern="[0-9]{12}" required
                                       class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-600 focus:border-transparent"
                                       placeholder="1234 5678 9012">
                                <p class="mt-1 text-xs text-gray-500">Enter 12-digit Aadhar number without spaces</p>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">
                                    <i class="fas fa-envelope mr-2"></i>Email Address
                                </label>
                                <input type="email" name="email" id="email" required
                                       class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-600 focus:border-transparent"
                                       placeholder="john.doe@example.com">
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">
                                    <i class="fas fa-lock mr-2"></i>Password
                                </label>
                                <input type="password" name="password" id="password" minlength="8" required
                                       class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-600 focus:border-transparent"
                                       placeholder="Create a strong password">
                                <div class="mt-2 flex items-center space-x-2 text-xs" id="password-strength">
                                    <span class="px-2 py-1 bg-gray-200 rounded">Min 8 chars</span>
                                    <span class="px-2 py-1 bg-gray-200 rounded">1 Uppercase</span>
                                    <span class="px-2 py-1 bg-gray-200 rounded">1 Number</span>
                                </div>
                            </div>

                            <div class="bg-blue-50 p-4 rounded-lg">
                                <label class="flex items-start">
                                    <input type="checkbox" name="terms" required class="mt-1 mr-3">
                                    <span class="text-sm text-gray-700">
                                        I agree to the <a href="#" class="text-blue-600 font-semibold">Terms & Conditions</a> and
                                        <a href="#" class="text-blue-600 font-semibold">Privacy Policy</a>. I confirm that I'm 18 years or older.
                                    </span>
                                </label>
                            </div>

                            <button type="submit" class="w-full bg-blue-600 text-white py-4 rounded-lg font-semibold text-lg hover:bg-blue-700 transition flex items-center justify-center">
                                <i class="fas fa-user-plus mr-2"></i> Create Account
                            </button>
                        </form>

                        <p class="mt-6 text-center text-gray-600">
                            Already have an account?
                            <a href="Login.jsp" class="text-blue-600 font-semibold hover:text-blue-800">
                                Login here <i class="fas fa-arrow-right ml-1"></i>
                            </a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Real-time validation
        document.getElementById('aadharNumber').addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '').slice(0, 12);
        });

        document.getElementById('password').addEventListener('input', function(e) {
            const password = this.value;
            const strengthDiv = document.getElementById('password-strength');
            const indicators = strengthDiv.children;

            // Length check
            indicators[0].className = password.length >= 8 ? 'px-2 py-1 bg-green-200 text-green-800 rounded' : 'px-2 py-1 bg-gray-200 rounded';

            // Uppercase check
            indicators[1].className = /[A-Z]/.test(password) ? 'px-2 py-1 bg-green-200 text-green-800 rounded' : 'px-2 py-1 bg-gray-200 rounded';

            // Number check
            indicators[2].className = /[0-9]/.test(password) ? 'px-2 py-1 bg-green-200 text-green-800 rounded' : 'px-2 py-1 bg-gray-200 rounded';
        });

        document.getElementById('signupForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const aadhar = document.getElementById('aadharNumber').value;

            if(aadhar.length !== 12) {
                e.preventDefault();
                alert('Please enter a valid 12-digit Aadhar number');
                return;
            }

            if(password.length < 8 || !/[A-Z]/.test(password) || !/[0-9]/.test(password)) {
                e.preventDefault();
                alert('Password must be at least 8 characters with 1 uppercase and 1 number');
            }
        });
    </script>
</body>
</html>