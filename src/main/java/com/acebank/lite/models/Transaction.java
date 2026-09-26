package com.acebank.lite.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record Transaction(
        Integer id,
        Integer senderAccount,
        Integer receiverAccount,
        BigDecimal amount,
        String txType,
        String remark,
        LocalDateTime createdAt
) {
}