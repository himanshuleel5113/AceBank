    </div> <!-- /main-content -->

    <!-- Footer -->
    <footer>
        <div class="main-content" style="padding-top: 2rem;">
            <div class="grid grid-cols-2 md:grid-cols-4 gap-8 py-8 border-t border-gray-200" :class="{ 'border-gray-700' : darkMode }">
                <div>
                    <h4 class="font-semibold text-sm mb-4">About AceBank</h4>
                    <ul class="space-y-2 text-xs text-gray-600" :class="{ 'text-gray-400' : darkMode }">
                        <li><a href="#" class="hover:text-blue-600">Our Story</a></li>
                        <li><a href="#" class="hover:text-blue-600">Careers</a></li>
                        <li><a href="#" class="hover:text-blue-600">Newsroom</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-semibold text-sm mb-4">Products</h4>
                    <ul class="space-y-2 text-xs text-gray-600" :class="{ 'text-gray-400' : darkMode }">
                        <li><a href="#" class="hover:text-blue-600">Savings Account</a></li>
                        <li><a href="#" class="hover:text-blue-600">Fixed Deposit</a></li>
                        <li><a href="#" class="hover:text-blue-600">Loans</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-semibold text-sm mb-4">Support</h4>
                    <ul class="space-y-2 text-xs text-gray-600" :class="{ 'text-gray-400' : darkMode }">
                        <li><a href="#" class="hover:text-blue-600">Help Center</a></li>
                        <li><a href="#" class="hover:text-blue-600">Contact Us</a></li>
                        <li><a href="#" class="hover:text-blue-600">Branch Locator</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-semibold text-sm mb-4">Connect</h4>
                    <div class="flex space-x-3">
                        <a href="#" class="h-8 w-8 bg-gray-100 rounded-full flex items-center justify-center hover:bg-blue-600 hover:text-white transition" :class="{ 'bg-gray-700' : darkMode }"><i class="fab fa-facebook-f text-sm"></i></a>
                        <a href="#" class="h-8 w-8 bg-gray-100 rounded-full flex items-center justify-center hover:bg-blue-400 hover:text-white transition" :class="{ 'bg-gray-700' : darkMode }"><i class="fab fa-twitter text-sm"></i></a>
                        <a href="#" class="h-8 w-8 bg-gray-100 rounded-full flex items-center justify-center hover:bg-purple-600 hover:text-white transition" :class="{ 'bg-gray-700' : darkMode }"><i class="fab fa-instagram text-sm"></i></a>
                    </div>
                    <p class="text-xs text-gray-500 mt-4" :class="{ 'text-gray-400' : darkMode }">
                        <i class="fas fa-phone mr-2"></i>1800-123-4567<br>
                        <i class="fas fa-envelope mr-2"></i>support@acebank.com
                    </p>
                </div>
            </div>
            <div class="border-t border-gray-200 py-4 text-xs text-gray-500 flex flex-col md:flex-row justify-between items-center" :class="{ 'border-gray-700 text-gray-400' : darkMode }">
                <p>&copy; 2026 AceBank. All rights reserved. &nbsp;|&nbsp; A demonstration net-banking platform.</p>
                <div class="flex space-x-4 mt-2 md:mt-0">
                    <a href="#" class="hover:text-blue-600">Privacy Policy</a>
                    <a href="#" class="hover:text-blue-600">Terms of Use</a>
                    <a href="#" class="hover:text-blue-600">Security</a>
                </div>
            </div>
        </div>
    </footer>

    <style>[x-cloak] { display: none !important; }</style>

    <!-- Notification scripts: mutate Alpine's reactive scope on <body> -->
    <script>
        function bankScope() {
            var b = document.querySelector('body');
            return (b && window.Alpine) ? Alpine.$data(b) : null;
        }
        function loadNotifications() {
            fetch('<%= request.getContextPath() %>/notifications')
                .then(r => r.json())
                .then(data => {
                    var s = bankScope();
                    if (s) {
                        s.notifications = Array.isArray(data) ? data : [];
                        s.unreadCount = s.notifications.filter(n => !n.read).length;
                    }
                })
                .catch(err => console.error('Error loading notifications:', err));
        }
        function markAsRead(id) {
            fetch('<%= request.getContextPath() %>/notifications?action=markRead&id=' + id)
                .then(() => loadNotifications())
                .catch(err => console.error('Error marking as read:', err));
        }
        function markAllAsRead() {
            fetch('<%= request.getContextPath() %>/notifications?action=markAllRead')
                .then(() => { var s = bankScope(); if (s) s.unreadCount = 0; loadNotifications(); })
                .catch(err => console.error('Error marking all as read:', err));
        }
    </script>
</body>
</html>
