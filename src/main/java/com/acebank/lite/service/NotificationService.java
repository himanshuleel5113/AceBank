package com.acebank.lite.service;

import com.acebank.lite.models.Notification;
import lombok.extern.java.Log;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

@Log
public class NotificationService {

    private static final Map<Integer, List<Notification>> notificationsMap = new ConcurrentHashMap<>();
    private static int notificationCounter = 0;

    public static void addNotification(int accountNo, String message, String type) {
        try {
            Notification notification = new Notification(accountNo, message, type);
            notification.setId(++notificationCounter);

            notificationsMap.computeIfAbsent(accountNo, k -> new CopyOnWriteArrayList<>()).add(0, notification);

            // Keep only last 20 notifications
            List<Notification> userNotifications = notificationsMap.get(accountNo);
            if (userNotifications.size() > 20) {
                userNotifications.remove(userNotifications.size() - 1);
            }

            log.info("✅ NOTIFICATION ADDED for account " + accountNo + ": " + message + " (Type: " + type + ")");
            log.info("Total notifications for account " + accountNo + ": " + userNotifications.size());
        } catch (Exception e) {
            log.severe("Error adding notification: " + e.getMessage());
        }
    }

    public static List<Notification> getNotifications(int accountNo) {
        List<Notification> notifications = notificationsMap.get(accountNo);
        if (notifications == null) {
            log.info("No notifications found for account " + accountNo);
            return new ArrayList<>();
        }
        log.info("Retrieved " + notifications.size() + " notifications for account " + accountNo);
        return new ArrayList<>(notifications);
    }

    public static List<Notification> getUnreadNotifications(int accountNo) {
        List<Notification> unread = new ArrayList<>();
        List<Notification> all = getNotifications(accountNo);
        for (Notification n : all) {
            if (!n.isRead()) {
                unread.add(n);
            }
        }
        log.info("Unread notifications for account " + accountNo + ": " + unread.size());
        return unread;
    }

    public static int getUnreadCount(int accountNo) {
        int count = getUnreadNotifications(accountNo).size();
        log.info("Unread count for account " + accountNo + ": " + count);
        return count;
    }

    public static void markAsRead(int accountNo, int notificationId) {
        List<Notification> notifications = getNotifications(accountNo);
        for (Notification n : notifications) {
            if (n.getId() == notificationId) {
                n.setRead(true);
                log.info("Marked notification " + notificationId + " as read for account " + accountNo);
                break;
            }
        }
    }

    public static void markAllAsRead(int accountNo) {
        List<Notification> notifications = getNotifications(accountNo);
        for (Notification n : notifications) {
            n.setRead(true);
        }
        log.info("Marked all notifications as read for account " + accountNo);
    }

    public static void clearAll(int accountNo) {
        notificationsMap.remove(accountNo);
        log.info("Cleared all notifications for account " + accountNo);
    }
}