package com.acebank.lite.models;

public record User(
    Integer userId,
    String firstName,
    String lastName,
    String aadhaarNo,
    String email,
    String passwordHash,
    java.time.LocalDateTime createdAt
) {}