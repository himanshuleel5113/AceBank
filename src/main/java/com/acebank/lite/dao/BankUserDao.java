package com.acebank.lite.dao;

import com.acebank.lite.models.*;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface BankUserDao {

    String getPasswordHash(int accountNo) throws SQLException;

    boolean signUp(User user, int accountNo) throws SQLException;

    LoginResult getUserDetails(int accountNo) throws SQLException;

    boolean deposit(int accountNo, BigDecimal amount) throws SQLException;

    boolean withdraw(int accountNo, BigDecimal amount) throws SQLException;

    BigDecimal getDailyWithdrawalTotal(int accountNo) throws SQLException;

    boolean transfer(int fromAccount, int toAccount, BigDecimal amount) throws SQLException;

    List<Transaction> getStatement(int accountNo) throws SQLException;

    List<Transaction> getStatement(int accountNo, int limit, int offset) throws SQLException;

    boolean changePassword(int accountNo, String oldPw, String newPw) throws SQLException;

    Optional<AccountRecoveryDTO> getRecoveryDetails(String email) throws SQLException;

    boolean accountExists(int accountNo) throws SQLException;

    BigDecimal getBalance(int accountNo) throws SQLException;

    boolean updatePasswordByAccountNo(int accountNo, String newHashedPassword) throws SQLException;

    List<LoanApplication> getLoanApplications(int accountNo) throws SQLException;

    Optional<UserProfile> getUserProfile(int accountNo) throws SQLException;

    boolean applyForLoan(int accountNo, String loanType, BigDecimal amount, int tenure, String purpose) throws SQLException;
}
