package com.acebank.lite.models;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Notification {
    private int id;
    private int accountNo;
    private String message;
    private String type; // INFO, SUCCESS, WARNING, DANGER
    private boolean isRead;
    private LocalDateTime createdAt;
    private String icon;
    private String actionLink;

    public Notification(int accountNo, String message, String type) {
        this.accountNo = accountNo;
        this.message = message;
        this.type = type;
        this.isRead = false;
        this.createdAt = LocalDateTime.now();
        setIconAndLink();
    }

    private void setIconAndLink() {
        switch (type) {
            case "DEPOSIT":
                this.icon = "fa-arrow-down text-green-500";
                this.actionLink = "statement";
                break;
            case "WITHDRAWAL":
                this.icon = "fa-arrow-up text-red-500";
                this.actionLink = "statement";
                break;
            case "TRANSFER":
                this.icon = "fa-exchange-alt text-blue-500";
                this.actionLink = "statement";
                break;
            case "LOAN":
                this.icon = "fa-hand-holding-usd text-yellow-500";
                this.actionLink = "loan-status";
                break;
            case "SECURITY":
                this.icon = "fa-shield-alt text-purple-500";
                this.actionLink = "ChangePassword.jsp";
                break;
            default:
                this.icon = "fa-info-circle text-gray-500";
                this.actionLink = "home";
        }
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getAccountNo() { return accountNo; }
    public void setAccountNo(int accountNo) { this.accountNo = accountNo; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public String getIcon() { return icon; }
    public String getActionLink() { return actionLink; }
    
    public String getFormattedTime() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM, hh:mm a");
        return createdAt.format(formatter);
    }
}