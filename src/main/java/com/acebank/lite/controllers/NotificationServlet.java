package com.acebank.lite.controllers;

import com.acebank.lite.models.Notification;
import com.acebank.lite.service.NotificationService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.java.Log;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

@Log
@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("accountNumber") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("[]");
            return;
        }

        int accountNo = (int) session.getAttribute("accountNumber");
        String action = request.getParameter("action");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            if ("count".equals(action)) {
                int count = NotificationService.getUnreadCount(accountNo);
                out.print(gson.toJson(Map.of("count", count)));

            } else if ("markRead".equals(action)) {
                String notificationId = request.getParameter("id");
                if (notificationId != null) {
                    NotificationService.markAsRead(accountNo, Integer.parseInt(notificationId));
                }
                out.print(gson.toJson(Map.of("success", true)));

            } else if ("markAllRead".equals(action)) {
                NotificationService.markAllAsRead(accountNo);
                out.print(gson.toJson(Map.of("success", true)));

            } else if ("clearAll".equals(action)) {
                NotificationService.clearAll(accountNo);
                out.print(gson.toJson(Map.of("success", true)));

            } else {
                List<Notification> notifications = NotificationService.getNotifications(accountNo);
                // Map to explicit view keys so the frontend contract (read, formattedTime) is preserved
                var payload = notifications.stream().map(n -> Map.of(
                        "id", n.getId(),
                        "accountNo", n.getAccountNo(),
                        "message", n.getMessage() == null ? "" : n.getMessage(),
                        "type", n.getType() == null ? "" : n.getType(),
                        "icon", n.getIcon() == null ? "" : n.getIcon(),
                        "actionLink", n.getActionLink() == null ? "#" : n.getActionLink(),
                        "read", n.isRead(),
                        "formattedTime", n.getFormattedTime() == null ? "" : n.getFormattedTime()
                )).toList();
                out.print(gson.toJson(payload));
            }
        } catch (Exception e) {
            log.severe("Error in NotificationServlet: " + e.getMessage());
            out.print("[]");
        }
    }
}
