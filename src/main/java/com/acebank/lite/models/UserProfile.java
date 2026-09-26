package com.acebank.lite.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record UserProfile(int userId, String firstName, String lastName, String aadhaarNo, String email, String phone, LocalDateTime createdAt, int accountNo, String accountType, BigDecimal balance, String status) {}
