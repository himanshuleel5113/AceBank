package com.acebank.lite.models;

import java.math.BigDecimal;

public record Account(
        Integer accountNo,
        Integer userId,
        String accountType,
        BigDecimal balance,
        String status,
        Integer version
) {
    /**
     * Optional: Helper to check if an account is usable
     */
//    public boolean isActive() {
//        return "ACTIVE".equalsIgnoreCase(status);
//    }
}