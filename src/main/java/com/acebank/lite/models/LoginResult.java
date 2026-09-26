package com.acebank.lite.models;

import java.math.BigDecimal;

public record LoginResult(
        String firstName,
        String lastName,
        String email,
        BigDecimal balance,
        int accountNumber
) {
}