package com.acebank.lite.service;

import com.acebank.lite.models.*;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface BankService {
    Optional<LoginResult> authenticate(int accountNo, String password) throws SQLException;

    boolean changePassword(int accountNo, String oldPlain, String newPlain) throws SQLException;

    boolean processDeposit(int accountNo, BigDecimal amount);

    BigDecimal getBalance(int accountNo);

    List<Transaction> getTransactionHistory(int accountNo);

    ServiceResponse processTransfer(int fromAcc, int toAcc, BigDecimal amount);

    String withdraw(int accountNo, BigDecimal amount);

    Optional<LoginResult> registerUser(User user);

    boolean recoverAccount(String email);

    boolean applyForLoan(int accountNo, String firstName, String email, String loanType, BigDecimal amount, int tenure, String purpose);

    Optional<AccountRecoveryDTO> getRecoveryDetails(String email) throws SQLException;

    List<LoanApplication> getLoanApplications(int accountNo);

    Optional<UserProfile> getUserProfile(int accountNo);
}
