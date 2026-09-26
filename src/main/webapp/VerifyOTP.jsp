<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String email = (String) session.getAttribute("resetEmail");
    String firstName = (String) session.getAttribute("resetFirstName");

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
    <title>AceBank - Verify OTP</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .otp-input {
            width: 60px;
            height: 60px;
            text-align: center;
            font-size: 28px;
            font-weight: bold;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            margin: 0 5px;
            transition: all 0.3s;
            background: white;
        }
        .otp-input:focus {
            border-color: #2563eb;
            outline: none;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.2);
        }
        .timer {
            font-size: 16px;
            color: #6b7280;
            font-weight: 500;
        }
        .timer-expired {
            color: #dc2626;
        }
        .otp-container {
            display: flex;
            justify-content: center;
            gap: 8px;
            margin: 20px 0;
        }
    </style>
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
                            <i class="fas fa-lock-open text-3xl text-blue-600"></i>
                        </div>
                        <h2 class="text-2xl font-bold text-gray-800">Verify OTP</h2>
                        <p class="text-gray-500 mt-2">We've sent a 6-digit code to</p>
                        <p class="font-semibold text-blue-600"><c:out value="<%= email %>"/></p>
                        <% if(firstName != null) { %>
                            <p class="text-sm text-gray-500 mt-1">Hello, <c:out value="<%= firstName %>"/>!</p>
                        <% } %>
                    </div>

                    <% if(errorMsg != null) { %>
                        <div class="mb-4 p-4 bg-red-50 border border-red-200 rounded-lg flex items-center">
                            <i class="fas fa-exclamation-circle text-red-500 mr-3"></i>
                            <p class="text-red-600 text-sm"><c:out value="<%= errorMsg %>"/></p>
                        </div>
                    <% } %>

                    <form action="VerifyOTP" method="POST" id="otpForm">
                        <div class="mb-6">
                            <label class="block text-sm font-medium text-gray-700 mb-3 text-center">
                                Enter 6-digit OTP
                            </label>
                            <div class="otp-container">
                                <input type="text" name="otp1" id="otp1" maxlength="1"
                                       class="otp-input"
                                       onkeyup="moveToNext(this, 'otp2')"
                                       onkeypress="return onlyNumbers(event)"
                                       oninput="combineOTP()"
                                       autofocus>
                                <input type="text" name="otp2" id="otp2" maxlength="1"
                                       class="otp-input"
                                       onkeyup="moveToNext(this, 'otp3')"
                                       onkeypress="return onlyNumbers(event)"
                                       oninput="combineOTP()">
                                <input type="text" name="otp3" id="otp3" maxlength="1"
                                       class="otp-input"
                                       onkeyup="moveToNext(this, 'otp4')"
                                       onkeypress="return onlyNumbers(event)"
                                       oninput="combineOTP()">
                                <input type="text" name="otp4" id="otp4" maxlength="1"
                                       class="otp-input"
                                       onkeyup="moveToNext(this, 'otp5')"
                                       onkeypress="return onlyNumbers(event)"
                                       oninput="combineOTP()">
                                <input type="text" name="otp5" id="otp5" maxlength="1"
                                       class="otp-input"
                                       onkeyup="moveToNext(this, 'otp6')"
                                       onkeypress="return onlyNumbers(event)"
                                       oninput="combineOTP()">
                                <input type="text" name="otp6" id="otp6" maxlength="1"
                                       class="otp-input"
                                       onkeyup="moveToNext(this, '')"
                                       onkeypress="return onlyNumbers(event)"
                                       oninput="combineOTP()">
                            </div>
                            <input type="hidden" name="otp" id="otp">
                        </div>

                        <div class="text-center mb-4">
                            <span class="timer" id="timer">OTP expires in 10:00</span>
                        </div>

                        <button type="submit" id="submitBtn" class="w-full bg-blue-600 text-white py-3 rounded-lg font-semibold hover:bg-blue-700 transition flex items-center justify-center">
                            <i class="fas fa-check-circle mr-2"></i>Verify OTP
                        </button>
                    </form>

                    <div class="mt-6 flex justify-center space-x-4">
                        <form action="VerifyOTP" method="POST" class="inline">
                            <input type="hidden" name="action" value="resend">
                            <button type="submit" class="text-blue-600 hover:underline text-sm flex items-center">
                                <i class="fas fa-redo-alt mr-1"></i>Resend OTP
                            </button>
                        </form>
                        <span class="text-gray-300">|</span>
                        <a href="ForgotPassword.jsp" class="text-gray-600 hover:text-gray-800 text-sm flex items-center">
                            <i class="fas fa-arrow-left mr-1"></i>Back
                        </a>
                    </div>

                    <div class="mt-6 p-3 bg-blue-50 rounded-lg">
                        <p class="text-xs text-blue-600 flex items-center">
                            <i class="fas fa-info-circle mr-2"></i>
                            For demo, check server logs for OTP if email not configured
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Timer functionality
        let timeLeft = 600; // 10 minutes in seconds
        let timerInterval;

        function updateTimer() {
            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            const timerElement = document.getElementById('timer');

            if (timeLeft <= 0) {
                timerElement.innerHTML = 'OTP expired';
                timerElement.classList.add('timer-expired');
                clearInterval(timerInterval);
                document.getElementById('submitBtn').disabled = true;
                document.getElementById('submitBtn').classList.add('opacity-50', 'cursor-not-allowed');
                return;
            }

            timerElement.innerHTML = `OTP expires in ${minutes}:${seconds.toString().padStart(2, '0')}`;
            timeLeft--;
        }

        timerInterval = setInterval(updateTimer, 1000);

        // Only allow numbers
        function onlyNumbers(e) {
            const charCode = e.which ? e.which : e.keyCode;
            if (charCode < 48 || charCode > 57) {
                e.preventDefault();
                return false;
            }
            return true;
        }

        // Move to next input
        function moveToNext(current, nextId) {
            if (current.value.length === 1) {
                if (nextId) {
                    document.getElementById(nextId)?.focus();
                }
            }
        }

        // Combine all OTP digits
        function combineOTP() {
            const otp =
                document.getElementById('otp1').value +
                document.getElementById('otp2').value +
                document.getElementById('otp3').value +
                document.getElementById('otp4').value +
                document.getElementById('otp5').value +
                document.getElementById('otp6').value;

            document.getElementById('otp').value = otp;

            // Auto-submit when all 6 digits are entered
            if (otp.length === 6) {
                setTimeout(() => {
                    document.getElementById('otpForm').submit();
                }, 100); // Small delay to ensure last digit is registered
            }
        }

        // Handle backspace key
        document.querySelectorAll('.otp-input').forEach((input, index) => {
            input.addEventListener('keydown', function(e) {
                if (e.key === 'Backspace' && this.value.length === 0) {
                    const prev = document.getElementById(`otp${index}`);
                    if (prev) {
                        prev.focus();
                    }
                }
            });
        });

        // Paste functionality
        document.addEventListener('paste', function(e) {
            e.preventDefault();
            const paste = (e.clipboardData || window.clipboardData).getData('text');
            if (paste.length === 6 && /^\d+$/.test(paste)) {
                for (let i = 0; i < 6; i++) {
                    document.getElementById(`otp${i+1}`).value = paste[i];
                }
                combineOTP();
            } else {
                alert('Please paste a valid 6-digit OTP');
            }
        });

        // Prevent form submission if OTP is incomplete
        document.getElementById('otpForm').addEventListener('submit', function(e) {
            const otp = document.getElementById('otp').value;
            if (otp.length !== 6) {
                e.preventDefault();
                alert('Please enter complete 6-digit OTP');
            }
        });
    </script>
</body>
</html>