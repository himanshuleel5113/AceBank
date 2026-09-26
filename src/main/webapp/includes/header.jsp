<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.acebank.lite.service.NotificationService" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    String firstName = (String) session.getAttribute("firstName");
    String lastName = (String) session.getAttribute("lastName");
    String email = (String) session.getAttribute("email");

    int unreadCount = 0;
    if (accountNumber != null) {
        unreadCount = NotificationService.getUnreadCount(accountNumber);
    }

    String currentPage = request.getRequestURI();
    String contextPath = request.getContextPath();

    // Pull one-shot toast from session (set by transaction servlets), then clear it
    String toastMessage = (String) session.getAttribute("toastMessage");
    String toastType = (String) session.getAttribute("toastType");
    if (toastMessage != null) {
        session.removeAttribute("toastMessage");
        session.removeAttribute("toastType");
    }

    String avatarInitial = (firstName != null && !firstName.isEmpty())
            ? firstName.substring(0, 1).toUpperCase() : "U";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AceBank &mdash; Secure Net Banking</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
    <style>
        :root {
            --brand-900: #0a1e33;
            --brand-800: #0f2b4b;
            --brand-600: #1e3a5f;
            --accent:    #eab308;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: #f3f4f6;
            min-height: 100vh;
        }

        /* ---------- Dark mode ---------- */
        .dark-mode { background: #111827; color: #f3f4f6; }
        .dark-mode .bg-white { background: #1f2937 !important; }
        .dark-mode .bg-gray-50 { background: #374151 !important; }
        .dark-mode .text-gray-800 { color: #f3f4f6 !important; }
        .dark-mode .text-gray-600, .dark-mode .text-gray-500 { color: #9ca3af !important; }
        .dark-mode .border-gray-200, .dark-mode .border-gray-100 { border-color: #374151 !important; }
        .dark-mode input, .dark-mode select, .dark-mode textarea, .dark-mode .border-2 {
            background: #374151 !important; border-color: #4b5563 !important; color: #f3f4f6 !important;
        }
        .dark-mode input::placeholder, .dark-mode textarea::placeholder { color: #9ca3af !important; }
        .dark-mode input:focus, .dark-mode select:focus, .dark-mode textarea:focus {
            border-color: #3b82f6 !important; outline: none;
        }
        .dark-mode .quick-amount-btn { background: #374151 !important; border-color: #4b5563 !important; color: #f3f4f6 !important; }
        .dark-mode .quick-amount-btn:hover { background: #4b5563 !important; border-color: #3b82f6 !important; }

        /* ---------- Header ---------- */
        .header {
            background: linear-gradient(135deg, var(--brand-800), var(--brand-900));
            color: white;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            position: sticky; top: 0; z-index: 50;
        }
        .header-content {
            max-width: 1280px; margin: 0 auto; padding: 0 1rem;
            height: 64px; display: flex; justify-content: space-between; align-items: center;
        }
        .logo { display: flex; align-items: center; gap: 0.5rem; font-size: 1.25rem; font-weight: bold; color: white; text-decoration: none; }
        .logo i { color: var(--accent); font-size: 1.5rem; }
        .nav-menu { display: flex; gap: 0.25rem; }
        .nav-item {
            padding: 0.5rem 1rem; border-radius: 0.5rem; display: flex; align-items: center; gap: 0.5rem;
            color: white; text-decoration: none; transition: background 0.3s; white-space: nowrap;
        }
        .nav-item:hover { background: rgba(255, 255, 255, 0.2); }
        .nav-item.active { background: var(--brand-600); }
        @media (max-width: 900px) { .nav-menu { display: none; } }

        .right-section { display: flex; align-items: center; gap: 0.5rem; }
        .icon-btn {
            width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;
            border-radius: 0.5rem; background: rgba(255, 255, 255, 0.1); color: white; border: none;
            cursor: pointer; transition: background 0.3s; position: relative;
        }
        .icon-btn:hover { background: rgba(255, 255, 255, 0.2); }
        .notification-badge {
            position: absolute; top: -5px; right: -5px; background: #ef4444; color: white;
            font-size: 10px; font-weight: bold; min-width: 18px; height: 18px; border-radius: 9999px;
            display: flex; align-items: center; justify-content: center; animation: pulse 2s infinite;
        }
        .profile-btn {
            display: flex; align-items: center; gap: 0.5rem; padding: 0.5rem 1rem; border-radius: 0.5rem;
            background: rgba(255, 255, 255, 0.1); border: none; color: white; cursor: pointer; transition: background 0.3s;
        }
        .profile-btn:hover { background: rgba(255, 255, 255, 0.2); }
        .avatar {
            width: 32px; height: 32px; border-radius: 9999px;
            background: linear-gradient(135deg, #fbbf24, #f59e0b);
            display: flex; align-items: center; justify-content: center;
            color: var(--brand-800); font-weight: bold; font-size: 14px;
        }

        /* ---------- Dropdowns ---------- */
        .dropdown {
            position: absolute; right: 0; margin-top: 0.5rem; background: white; border-radius: 0.75rem;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.15); border: 1px solid #e5e7eb; z-index: 100;
            min-width: 320px; max-height: 500px; overflow-y: auto;
        }
        .dark-mode .dropdown { background: #1f2937; border-color: #374151; }
        .dropdown-header { padding: 1rem; border-bottom: 1px solid #e5e7eb; position: sticky; top: 0; background: white; }
        .dark-mode .dropdown-header { background: #1f2937; border-color: #374151; }
        .dropdown-item {
            padding: 0.75rem 1rem; display: flex; align-items: center; gap: 0.75rem; color: #374151;
            text-decoration: none; transition: background 0.2s; font-size: 0.875rem; cursor: pointer;
        }
        .dark-mode .dropdown-item { color: #e5e7eb; }
        .dropdown-item:hover { background: #f3f4f6; }
        .dark-mode .dropdown-item:hover { background: #374151; }
        .notification-item { border-bottom: 1px solid #e5e7eb; }
        .dark-mode .notification-item { border-color: #374151; }

        /* ---------- Mobile drawer ---------- */
        .mobile-drawer {
            position: fixed; top: 0; left: 0; height: 100%; width: 260px; background: var(--brand-900);
            z-index: 200; transform: translateX(-100%); transition: transform 0.3s ease; padding: 1rem;
        }
        .mobile-drawer.open { transform: translateX(0); }
        .mobile-nav-item {
            display: flex; align-items: center; gap: 0.75rem; padding: 0.85rem 1rem; border-radius: 0.5rem;
            color: #cbd5e1; text-decoration: none; margin-bottom: 0.25rem;
        }
        .mobile-nav-item:hover { background: rgba(255,255,255,0.08); color: white; }
        .hamburger { display: none; }
        @media (max-width: 900px) { .hamburger { display: flex; } }

        .main-content { max-width: 1280px; margin: 0 auto; padding: 1.5rem 1rem; }

        /* ---------- Toast ---------- */
        #toastContainer { position: fixed; bottom: 20px; right: 20px; z-index: 9999; }
        @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.1); } }
        @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        @keyframes fadeOut { to { opacity: 0; transform: translateX(100%); } }
    </style>
</head>
<body x-data="{
    darkMode: localStorage.getItem('darkMode') === 'true',
    notifications: [],
    showNotifications: false,
    unreadCount: <%= unreadCount %>,
    showProfileMenu: false,
    mobileMenu: false
}" x-init="
    if (darkMode) $el.classList.add('dark-mode');
    $watch('darkMode', val => {
        $el.classList.toggle('dark-mode', val);
        localStorage.setItem('darkMode', val ? 'true' : 'false');
    });
    <% if (accountNumber != null) { %>
    loadNotifications();
    setInterval(loadNotifications, 30000);
    <% } %>
">

    <% if (accountNumber != null) { %>
    <!-- Mobile Drawer -->
    <div class="mobile-drawer" :class="{ 'open': mobileMenu }" @click.away="mobileMenu = false">
        <a href="<%= contextPath %>/index.jsp" class="logo" style="margin-bottom: 1.5rem;">
            <i class="fas fa-university"></i><span>Ace</span><span style="color: var(--accent);">Bank</span>
        </a>
        <a href="<%= contextPath %>/home" class="mobile-nav-item"><i class="fas fa-home"></i> Dashboard</a>
        <a href="<%= contextPath %>/statement" class="mobile-nav-item"><i class="fas fa-file-alt"></i> Statements</a>
        <a href="<%= contextPath %>/Transfer.jsp" class="mobile-nav-item"><i class="fas fa-exchange-alt"></i> Transfer</a>
        <a href="<%= contextPath %>/Deposit.jsp" class="mobile-nav-item"><i class="fas fa-arrow-down"></i> Deposit</a>
        <a href="<%= contextPath %>/Withdraw.jsp" class="mobile-nav-item"><i class="fas fa-arrow-up"></i> Withdraw</a>
        <a href="<%= contextPath %>/Loan.jsp" class="mobile-nav-item"><i class="fas fa-hand-holding-usd"></i> Apply Loan</a>
        <a href="<%= contextPath %>/loan-status" class="mobile-nav-item"><i class="fas fa-list-check"></i> Loan Status</a>
        <a href="<%= contextPath %>/profile" class="mobile-nav-item"><i class="fas fa-user-circle"></i> Profile</a>
        <a href="<%= contextPath %>/ChangePassword.jsp" class="mobile-nav-item"><i class="fas fa-key"></i> Change Password</a>
        <a href="<%= contextPath %>/Logout" class="mobile-nav-item" style="color:#fca5a5;"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
    <% } %>

    <!-- Header -->
    <header class="header">
        <div class="header-content">
            <div style="display:flex; align-items:center; gap:0.5rem;">
                <% if (accountNumber != null) { %>
                <button class="icon-btn hamburger" @click="mobileMenu = !mobileMenu"><i class="fas fa-bars"></i></button>
                <% } %>
                <a href="<%= contextPath %>/index.jsp" class="logo">
                    <i class="fas fa-university"></i><span>Ace</span><span style="color: var(--accent);">Bank</span>
                </a>
            </div>

            <% if (accountNumber != null) { %>
            <nav class="nav-menu">
                <a href="<%= contextPath %>/home" class="nav-item <%= currentPage.contains("home") ? "active" : "" %>">
                    <i class="fas fa-home"></i><span>Dashboard</span>
                </a>
                <a href="<%= contextPath %>/statement" class="nav-item <%= currentPage.contains("statement") || currentPage.contains("Statement") ? "active" : "" %>">
                    <i class="fas fa-file-alt"></i><span>Statements</span>
                </a>
                <a href="<%= contextPath %>/Transfer.jsp" class="nav-item <%= currentPage.contains("Transfer") ? "active" : "" %>">
                    <i class="fas fa-exchange-alt"></i><span>Transfer</span>
                </a>
                <a href="<%= contextPath %>/Loan.jsp" class="nav-item <%= currentPage.contains("Loan") ? "active" : "" %>">
                    <i class="fas fa-hand-holding-usd"></i><span>Loans</span>
                </a>
            </nav>
            <% } %>

            <div class="right-section">
                <button @click="darkMode = !darkMode" class="icon-btn" title="Toggle theme">
                    <i :class="darkMode ? 'fas fa-sun' : 'fas fa-moon'"></i>
                </button>

                <% if (accountNumber != null) { %>
                    <!-- Notifications -->
                    <div class="relative">
                        <button @click="showNotifications = !showNotifications; if(showNotifications) loadNotifications()" class="icon-btn">
                            <i class="fas fa-bell"></i>
                            <span x-show="unreadCount > 0" x-text="unreadCount" class="notification-badge" style="display: none;"></span>
                        </button>
                        <div x-show="showNotifications" @click.away="showNotifications = false" class="dropdown" style="display: none;" x-cloak>
                            <div class="dropdown-header">
                                <div style="display: flex; justify-content: space-between; align-items: center;">
                                    <h3 class="font-semibold">Notifications</h3>
                                    <button @click="markAllAsRead()" class="text-xs text-blue-600 hover:underline">Mark all read</button>
                                </div>
                            </div>
                            <div>
                                <template x-for="n in notifications" :key="n.id">
                                    <div class="dropdown-item notification-item" @click="markAsRead(n.id); window.location.href='<%= contextPath %>/' + n.actionLink">
                                        <i :class="'fas ' + n.icon" style="font-size: 1.25rem;"></i>
                                        <div style="flex: 1;">
                                            <p x-text="n.message" style="font-size: 0.875rem;"></p>
                                            <p class="text-xs text-gray-500" x-text="n.formattedTime" style="margin-top: 0.25rem;"></p>
                                        </div>
                                        <span x-show="!n.read" class="h-2 w-2 bg-blue-600 rounded-full" style="display: inline-block;"></span>
                                    </div>
                                </template>
                                <div x-show="notifications.length === 0" class="p-4 text-center text-gray-500">
                                    <i class="fas fa-bell-slash text-4xl mb-2"></i><p>No notifications</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Profile Menu -->
                    <div class="relative">
                        <button @click="showProfileMenu = !showProfileMenu" class="profile-btn">
                            <div class="avatar"><%= avatarInitial %></div>
                            <span class="hidden md:inline"><c:out value="<%= firstName != null ? firstName : \"\" %>"/></span>
                            <i class="fas fa-chevron-down text-xs"></i>
                        </button>
                        <div x-show="showProfileMenu" @click.away="showProfileMenu = false" class="dropdown" style="display: none;" x-cloak>
                            <div class="dropdown-header">
                                <p class="font-semibold"><c:out value="<%= (firstName != null ? firstName : \"\") + \" \" + (lastName != null ? lastName : \"\") %>"/></p>
                                <p class="text-xs text-gray-500"><c:out value="<%= email != null ? email : \"\" %>"/></p>
                            </div>
                            <a href="<%= contextPath %>/profile" class="dropdown-item"><i class="fas fa-user-circle"></i> My Profile</a>
                            <a href="<%= contextPath %>/loan-status" class="dropdown-item"><i class="fas fa-list-check"></i> Loan Status</a>
                            <a href="<%= contextPath %>/ChangePassword.jsp" class="dropdown-item"><i class="fas fa-key"></i> Change Password</a>
                            <a href="<%= contextPath %>/statement" class="dropdown-item"><i class="fas fa-file-alt"></i> Statements</a>
                            <hr class="my-2 border-gray-200">
                            <a href="<%= contextPath %>/Logout" class="dropdown-item" style="color: #dc2626;"><i class="fas fa-sign-out-alt"></i> Logout</a>
                        </div>
                    </div>
                <% } else { %>
                    <a href="<%= contextPath %>/Login.jsp" class="nav-item">Login</a>
                    <a href="<%= contextPath %>/SignUp.jsp" class="nav-item" style="background: var(--accent); color: var(--brand-800);">Sign Up</a>
                <% } %>
            </div>
        </div>
    </header>

    <!-- Toast container + one-shot server toast -->
    <div id="toastContainer"></div>
    <% if (toastMessage != null) { %>
    <div id="serverToast"
         data-message="<c:out value='<%= toastMessage %>'/>"
         data-type="<%= "error".equals(toastType) ? "error" : "success" %>"
         style="display:none;"></div>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var el = document.getElementById('serverToast');
            if (el) { showToast(el.getAttribute('data-message'), el.getAttribute('data-type')); }
        });
    </script>
    <% } %>

    <!-- Unified toast helper (available on every page) -->
    <script>
        function showToast(message, type) {
            type = type || 'success';
            var colors = { success: '#10b981', error: '#ef4444', info: '#3b82f6', warning: '#f59e0b' };
            var icons  = { success: 'fa-check-circle', error: 'fa-circle-exclamation', info: 'fa-circle-info', warning: 'fa-triangle-exclamation' };
            var toast = document.createElement('div');
            toast.style.cssText = 'background:' + (colors[type] || colors.success) + ';color:#fff;padding:16px 20px;border-radius:12px;'
                + 'box-shadow:0 10px 25px -5px rgba(0,0,0,0.25);margin-top:10px;font-size:14px;display:flex;align-items:center;'
                + 'gap:12px;min-width:300px;max-width:380px;animation:slideInRight 0.3s ease, fadeOut 0.3s ease 3.4s forwards;';
            toast.innerHTML = '<i class="fas ' + (icons[type] || icons.success) + '" style="font-size:20px;"></i>'
                + '<div style="flex:1;">' + message + '</div>'
                + '<button onclick="this.parentElement.remove()" style="background:none;border:none;color:#fff;opacity:.8;cursor:pointer;font-size:16px;"><i class="fas fa-times"></i></button>';
            document.getElementById('toastContainer').appendChild(toast);
            setTimeout(function () { if (toast.parentNode) toast.remove(); }, 3800);
        }
    </script>

    <!-- Main Content Container -->
    <div class="main-content">
