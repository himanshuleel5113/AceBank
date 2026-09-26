package com.acebank.lite.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record LoanApplication(int id, String loanType, BigDecimal amount, int tenure, String purpose, String status, LocalDateTime appliedAt) {}
