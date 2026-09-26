<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AceBank - Modern Banking Solutions</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .gradient-bg {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
        }
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);
        }
    </style>
</head>
<body class="bg-gray-50">
    <!-- Header -->
    <header class="gradient-bg text-white shadow-lg sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
            <div class="flex justify-between items-center">
                <div class="flex items-center space-x-2">
                    <i class="fas fa-university text-3xl text-yellow-400"></i>
                    <h1 class="text-3xl font-bold">
                        <span class="text-blue-400">Ace</span><span class="text-yellow-400">Bank</span>
                    </h1>
                </div>
                <nav class="hidden md:flex space-x-8">
                    <a href="#features" class="hover:text-yellow-400 transition">Features</a>
                    <a href="#services" class="hover:text-yellow-400 transition">Services</a>
                    <a href="#about" class="hover:text-yellow-400 transition">About</a>
                    <a href="#contact" class="hover:text-yellow-400 transition">Contact</a>
                </nav>
                <div class="flex space-x-4">
                    <a href="Login.jsp" class="px-4 py-2 border border-blue-400 rounded-lg hover:bg-blue-400 hover:text-white transition">Login</a>
                    <a href="SignUp.jsp" class="px-4 py-2 bg-yellow-400 text-gray-900 rounded-lg hover:bg-yellow-500 transition font-semibold">Open Account</a>
                </div>
            </div>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
        <div class="grid md:grid-cols-2 gap-12 items-center">
            <div>
                <span class="inline-block px-3 py-1 bg-blue-100 text-blue-900 rounded-full text-sm font-semibold mb-4">
                    <i class="fas fa-shield-alt mr-2"></i>RBI Registered Bank
                </span>
                <h1 class="text-5xl md:text-6xl font-bold text-gray-900 mb-6">
                    Banking That <span class="text-blue-600">Simplifies</span> Your Life
                </h1>
                <p class="text-xl text-gray-600 mb-8">
                    Join over 2 million happy customers. Experience secure, smart, and simple banking with AceBank.
                </p>
                <div class="flex flex-wrap gap-4">
                    <a href="SignUp.jsp" class="bg-blue-600 text-white px-8 py-4 rounded-lg text-lg font-semibold hover:bg-blue-700 transition flex items-center">
                        <i class="fas fa-user-plus mr-2"></i> Open Account Now
                    </a>
                    <a href="#video" class="border-2 border-blue-600 text-blue-600 px-8 py-4 rounded-lg text-lg font-semibold hover:bg-blue-50 transition flex items-center">
                        <i class="fas fa-play-circle mr-2"></i> Watch Video
                    </a>
                </div>
                <div class="flex mt-12 space-x-8">
                    <div>
                        <p class="text-3xl font-bold text-gray-900">2M+</p>
                        <p class="text-gray-600">Happy Customers</p>
                    </div>
                    <div>
                        <p class="text-3xl font-bold text-gray-900">₹500B+</p>
                        <p class="text-gray-600">Transactions</p>
                    </div>
                    <div>
                        <p class="text-3xl font-bold text-gray-900">24/7</p>
                        <p class="text-gray-600">Support</p>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="bg-white py-20">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-4xl font-bold text-gray-900 mb-4">Why Choose AceBank?</h2>
                <p class="text-xl text-gray-600">Experience banking that works for you, not the other way around</p>
            </div>
            <div class="grid md:grid-cols-3 gap-8">
                <div class="feature-card bg-gray-50 p-8 rounded-xl transition duration-300">
                    <div class="h-16 w-16 bg-blue-100 rounded-full flex items-center justify-center mb-6">
                        <i class="fas fa-shield-alt text-3xl text-blue-600"></i>
                    </div>
                    <h3 class="text-2xl font-semibold text-gray-900 mb-4">Bank-Grade Security</h3>
                    <p class="text-gray-600">Your money is safe with 256-bit encryption and multi-factor authentication.</p>
                </div>
                <div class="feature-card bg-gray-50 p-8 rounded-xl transition duration-300">
                    <div class="h-16 w-16 bg-green-100 rounded-full flex items-center justify-center mb-6">
                        <i class="fas fa-bolt text-3xl text-green-600"></i>
                    </div>
                    <h3 class="text-2xl font-semibold text-gray-900 mb-4">Instant Transfers</h3>
                    <p class="text-gray-600">Send money to any bank account in India instantly, 24/7.</p>
                </div>
                <div class="feature-card bg-gray-50 p-8 rounded-xl transition duration-300">
                    <div class="h-16 w-16 bg-yellow-100 rounded-full flex items-center justify-center mb-6">
                        <i class="fas fa-percent text-3xl text-yellow-600"></i>
                    </div>
                    <h3 class="text-2xl font-semibold text-gray-900 mb-4">Zero Hidden Fees</h3>
                    <p class="text-gray-600">No maintenance charges. No surprise fees. Complete transparency.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Services Section -->
    <section id="services" class="py-20">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-16">
                <h2 class="text-4xl font-bold text-gray-900 mb-4">Our Banking Services</h2>
                <p class="text-xl text-gray-600">Complete banking solutions for every need</p>
            </div>
            <div class="grid md:grid-cols-4 gap-6">
                <div class="text-center p-6">
                    <i class="fas fa-wallet text-5xl text-blue-600 mb-4"></i>
                    <h3 class="font-semibold text-lg">Savings Account</h3>
                    <p class="text-gray-500 text-sm">3.5% interest rate</p>
                </div>
                <div class="text-center p-6">
                    <i class="fas fa-credit-card text-5xl text-blue-600 mb-4"></i>
                    <h3 class="font-semibold text-lg">Debit Card</h3>
                    <p class="text-gray-500 text-sm">Free lifetime</p>
                </div>
                <div class="text-center p-6">
                    <i class="fas fa-hand-holding-usd text-5xl text-blue-600 mb-4"></i>
                    <h3 class="font-semibold text-lg">Personal Loan</h3>
                    <p class="text-gray-500 text-sm">10.5% p.a. onwards</p>
                </div>
                <div class="text-center p-6">
                    <i class="fas fa-exchange-alt text-5xl text-blue-600 mb-4"></i>
                    <h3 class="font-semibold text-lg">Fund Transfer</h3>
                    <p class="text-gray-500 text-sm">IMPS/NEFT/RTGS</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="gradient-bg text-white py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid md:grid-cols-4 gap-8">
                <div>
                    <h3 class="text-2xl font-bold mb-4">Ace<span class="text-yellow-400">Bank</span></h3>
                    <p class="text-gray-400">Your trusted banking partner since 1995</p>
                </div>
                <div>
                    <h4 class="font-semibold mb-4">Quick Links</h4>
                    <ul class="space-y-2 text-gray-400">
                        <li><a href="#" class="hover:text-yellow-400">About Us</a></li>
                        <li><a href="#" class="hover:text-yellow-400">Careers</a></li>
                        <li><a href="#" class="hover:text-yellow-400">Contact</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-semibold mb-4">Services</h4>
                    <ul class="space-y-2 text-gray-400">
                        <li><a href="#" class="hover:text-yellow-400">Savings</a></li>
                        <li><a href="#" class="hover:text-yellow-400">Loans</a></li>
                        <li><a href="#" class="hover:text-yellow-400">Cards</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-semibold mb-4">Connect</h4>
                    <div class="flex space-x-4">
                        <a href="#" class="text-2xl hover:text-yellow-400"><i class="fab fa-facebook"></i></a>
                        <a href="#" class="text-2xl hover:text-yellow-400"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="text-2xl hover:text-yellow-400"><i class="fab fa-linkedin"></i></a>
                    </div>
                </div>
            </div>
            <hr class="border-gray-700 my-8">
            <p class="text-center text-gray-400">© 2026 AceBank. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>