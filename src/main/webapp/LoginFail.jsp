<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AceBank - Login Failed</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">
    <div class="min-h-screen flex flex-col">
        <header class="bg-blue-900 text-white shadow-lg">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
                <a href="index.jsp" class="text-2xl font-bold">
                    <i class="fas fa-university mr-2"></i>
                    <span class="text-blue-400">Ace</span><span class="text-yellow-400">Bank</span>
                </a>
            </div>
        </header>

        <div class="flex-1 flex items-center justify-center py-12 px-4">
            <div class="max-w-md w-full">
                <div class="bg-white rounded-2xl shadow-xl p-8 text-center">
                    <div class="h-24 w-24 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-6">
                        <i class="fas fa-times-circle text-5xl text-red-600"></i>
                    </div>

                    <h2 class="text-2xl font-bold text-gray-900 mb-4">Login Failed</h2>

                    <div class="bg-red-50 border border-red-200 rounded-lg p-4 mb-6">
                        <p class="text-red-700 font-medium">Invalid account number or password</p>
                        <p class="text-sm text-red-500 mt-1">Please check your credentials and try again.</p>
                    </div>

                    <div class="space-y-3">
                        <a href="Login.jsp" class="block w-full bg-blue-600 text-white py-3 rounded-lg font-semibold hover:bg-blue-700 transition">
                            Try Again
                        </a>
                        <a href="ForgotPassword.jsp" class="block w-full border-2 border-blue-600 text-blue-600 py-3 rounded-lg font-semibold hover:bg-blue-50 transition">
                            Forgot Password?
                        </a>
                    </div>

                    <hr class="my-6">

                    <p class="text-gray-600">
                        Don't have an account?
                        <a href="SignUp.jsp" class="text-blue-600 font-semibold hover:underline">Sign Up</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>