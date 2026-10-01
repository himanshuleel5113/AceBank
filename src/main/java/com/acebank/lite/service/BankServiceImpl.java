package com.acebank.lite.service;

import com.acebank.lite.dao.BankUserDao;
import com.acebank.lite.dao.BankUserDaoImpl;
import com.acebank.lite.models.*;
import com.acebank.lite.util.MailUtil;
import com.acebank.lite.util.PasswordUtil;
import lombok.extern.java.Log;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.ThreadLocalRandom;

@Log
public class BankServiceImpl implements BankService {

    private final BankUserDao userDao = new BankUserDaoImpl();
    private static final BigDecimal DAILY_LIMIT = new BigDecimal("50000.00");

    @Override
    public Optional<LoginResult> authenticate(int accountNo, String plainPassword) {
        try {
            String storedHash = userDao.getPasswordHash(accountNo);

            if (PasswordUtil.checkPassword(plainPassword, storedHash)) {
                LoginResult result = userDao.getUserDetails(accountNo);

                String message = "New login to your account at " +
                        new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new java.util.Date());
                NotificationService.addNotification(accountNo, message, "INFO");

                return Optional.of(result);
            }
        } catch (SQLException e) {
            log.severe("Database error during login: " + e.getMessage());
        }
        return Optional.empty();
    }

    @Override
    public boolean changePassword(int accountNo, String oldPlain, String newPlain) throws SQLException {
        String storedHash = userDao.getPasswordHash(accountNo);

        if (PasswordUtil.checkPassword(oldPlain, storedHash)) {
            String newSecureHash = PasswordUtil.hashPassword(newPlain);
            boolean success = userDao.changePassword(accountNo, storedHash, newSecureHash);

            if (success) {
                String message = "Your password was changed successfully";
                NotificationService.addNotification(accountNo, message, "SECURITY");
            }
            return success;
        }
        return false;
    }

    @Override
    public boolean processDeposit(int accountNo, BigDecimal amount) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return false;
        }

        try {
            boolean success = userDao.deposit(accountNo, amount);
            if (success) {
                String message = String.format("₹ %,.2f has been deposited to your account", amount);
                NotificationService.addNotification(accountNo, message, "DEPOSIT");
                log.info("Deposit successful for account: " + accountNo);
            }
            return success;
        } catch (SQLException e) {
            log.severe("Deposit Error for " + accountNo + ": " + e.getMessage());
            return false;
        }
    }

    @Override
    public String withdraw(int accountNo, BigDecimal amount) {
        try {
            if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
                return "Invalid amount. Please enter amount greater than 0.";
            }

            BigDecimal currentBalance = getBalance(accountNo);
            if (currentBalance.compareTo(amount) < 0) {
                return "Insufficient balance. Your current balance is ₹" + currentBalance;
            }

            BigDecimal alreadyWithdrawn = userDao.getDailyWithdrawalTotal(accountNo);
            BigDecimal projectedTotal = alreadyWithdrawn.add(amount);

            if (projectedTotal.compareTo(DAILY_LIMIT) > 0) {
                BigDecimal remaining = DAILY_LIMIT.subtract(alreadyWithdrawn);
                return "Daily withdrawal limit exceeded. You can withdraw ₹" + remaining + " more today.";
            }

            boolean success = userDao.withdraw(accountNo, amount);

            if (success) {
                String message = String.format("₹ %,.2f has been withdrawn from your account", amount);
                NotificationService.addNotification(accountNo, message, "WITHDRAWAL");
                log.info("Withdrawal successful: ₹" + amount + " from account " + accountNo);
                return "SUCCESS";
            } else {
                return "Transaction failed. Please try again.";
            }

        } catch (SQLException e) {
            log.severe("Withdrawal error for account " + accountNo + ": " + e.getMessage());
            return "System error. Please try later.";
        }
    }

    @Override
    public Optional<LoginResult> registerUser(User user) {
        String secureHash = PasswordUtil.hashPassword(user.passwordHash());

        User secureUser = new User(
                user.userId(), user.firstName(), user.lastName(),
                user.aadhaarNo(), user.email(), secureHash, user.createdAt()
        );

        // Retry loop to ensure unique account number
        int accountNumber = 0;
        boolean uniqueFound = false;
        for (int attempt = 0; attempt < 10; attempt++) {
            accountNumber = ThreadLocalRandom.current().nextInt(10000000, 99999999);
            try {
                if (!userDao.accountExists(accountNumber)) {
                    uniqueFound = true;
                    break;
                }
                log.info("Account number collision on attempt " + (attempt + 1) + ", retrying...");
            } catch (SQLException e) {
                log.severe("Error checking account existence: " + e.getMessage());
                return Optional.empty();
            }
        }

        if (!uniqueFound) {
            log.severe("Failed to generate unique account number after 10 attempts");
            return Optional.empty();
        }

        try {
            boolean isSaved = userDao.signUp(secureUser, accountNumber);

            if (isSaved) {
                sendWelcomeEmail(user, accountNumber);

                String message = "Welcome to AceBank! Your account has been created successfully.";
                NotificationService.addNotification(accountNumber, message, "INFO");

                return Optional.of(new LoginResult(
                        user.firstName(),
                        user.lastName(),
                        user.email(),
                        BigDecimal.ZERO,
                        accountNumber
                ));
            }
        } catch (Exception e) {
            log.severe("Signup Error: " + e.getMessage());
            e.printStackTrace();
        }
        return Optional.empty();
    }

    private void sendWelcomeEmail(User user, int accNo) {
        String subject = "Welcome to AceBank";
        String msg = String.format("""
            Dear %s,

            Welcome to AceBank! Your account has been created successfully.

            Account Details:
            - Account Number: %d
            - Account Type: Savings
            - Opening Balance: ₹0.00

            Important Information:
            • Your account is now active
            • You can start depositing money immediately
            • For security, never share your password

            Keep this information safe.

            Best regards,
            The AceBank Team""",
                user.firstName(), accNo);
        try {
            MailUtil.sendMail(user.email(), subject, msg);
        } catch (Exception e) {
            log.warning("Email failed to send, but account was created.");
        }
    }

    @Override
    public BigDecimal getBalance(int accountNo) {
        try {
            return userDao.getBalance(accountNo);
        } catch (SQLException e) {
            log.severe("Could not fetch balance for: " + accountNo);
            return BigDecimal.ZERO;
        }
    }

    @Override
    public List<Transaction> getTransactionHistory(int accountNo) {
        try {
            return userDao.getStatement(accountNo);
        } catch (SQLException e) {
            log.severe("Could not fetch transactions for: " + accountNo);
            return List.of();
        }
    }

    @Override
    public ServiceResponse processTransfer(int fromAcc, int toAcc, BigDecimal amount) {
        if (fromAcc == toAcc) {
            return new ServiceResponse(false, "You cannot transfer money to your own account.");
        }

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return new ServiceResponse(false, "Please enter a valid amount greater than zero.");
        }

        try {
            if (!userDao.accountExists(toAcc)) {
                return new ServiceResponse(false, "Recipient account number " + toAcc + " not found.");
            }

            BigDecimal currentBalance = userDao.getBalance(fromAcc);
            if (currentBalance.compareTo(amount) < 0) {
                return new ServiceResponse(false, "Insufficient balance. Your current balance is ₹" + currentBalance);
            }

            boolean success = userDao.transfer(fromAcc, toAcc, amount);

            if (success) {
                String senderMessage = String.format("₹ %,.2f transferred to account XXXX%d",
                        amount, toAcc % 10000);
                NotificationService.addNotification(fromAcc, senderMessage, "TRANSFER");

                String recipientMessage = String.format("Received ₹ %,.2f from account XXXX%d",
                        amount, fromAcc % 10000);
                NotificationService.addNotification(toAcc, recipientMessage, "TRANSFER");

                log.info("Transfer Successful: ₹" + amount + " from " + fromAcc + " to " + toAcc);
                return new ServiceResponse(true, "Transfer Successful!");
            } else {
                return new ServiceResponse(false, "Transfer could not be processed. Please try again.");
            }

        } catch (SQLException e) {
            log.severe("SQL Error during transfer: " + e.getMessage());
            return new ServiceResponse(false, "Database connection error. Please contact support.");
        }
    }

    @Override
    public boolean recoverAccount(String email) {
        try {
            log.info("Attempting to recover account for email: " + email);

            Optional<AccountRecoveryDTO> detailsOpt = userDao.getRecoveryDetails(email);

            if (detailsOpt.isPresent()) {
                AccountRecoveryDTO details = detailsOpt.get();

                String subject = "AceBank - Account Recovery Request";
                String msg = String.format(
                        "Dear %s %s,\n\n" +
                                "We received a request to recover your AceBank account.\n\n" +
                                "Account Details:\n" +
                                "----------------\n" +
                                "Account Number: %d\n" +
                                "Account Holder: %s %s\n\n" +
                                "Next Steps:\n" +
                                "-----------\n" +
                                "1. If you forgot your password, please visit our website and use the 'Change Password' feature.\n" +
                                "2. For security reasons, we cannot email your password.\n" +
                                "3. If you didn't request this recovery, please contact our support immediately.\n\n" +
                                "Stay safe,\n" +
                                "The AceBank Security Team",
                        details.firstName(), details.lastName(),
                        details.accountNo(),
                        details.firstName(), details.lastName());

                boolean emailSent = MailUtil.sendMail(email, subject, msg);

                if (emailSent) {
                    log.info("Recovery email sent successfully to: " + email);
                    NotificationService.addNotification(details.accountNo(), "Account recovery email sent to " + email, "INFO");
                    return true;
                } else {
                    log.severe("Failed to send recovery email to: " + email);
                    return false;
                }
            } else {
                log.warning("No account found for email: " + email);
                return false;
            }
        } catch (Exception e) {
            log.severe("Error in recoverAccount for email: " + email + " - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean applyForLoan(int accountNo, String firstName, String email, String loanType, BigDecimal amount, int tenure, String purpose) {
        try {
            // Insert loan application into database
            boolean dbSuccess = userDao.applyForLoan(accountNo, loanType, amount, tenure, purpose);

            if (!dbSuccess) {
                log.warning("Failed to insert loan application for account: " + accountNo);
                return false;
            }

            // Send confirmation email
            String subject = "Loan Application Received - AceBank";
            String body = String.format("""
                Dear %s,

                Thank you for applying for a %s loan with AceBank.

                Application Status: UNDER REVIEW
                Expected Response Time: 24-48 hours

                What happens next?
                1. Our loan officer will review your application
                2. You'll receive a call for verification
                3. Final decision will be communicated via email

                Required Documents (keep ready):
                • Identity Proof (Aadhar/PAN)
                • Address Proof
                • Income Documents
                • Bank Statements (last 6 months)

                We appreciate your interest in AceBank.

                Best regards,
                Loan Department
                AceBank""",
                    firstName, loanType);

            try {
                MailUtil.sendMail(email, subject, body);
            } catch (Exception e) {
                log.warning("Loan confirmation email failed to send, but application was saved.");
            }

            return true;

        } catch (SQLException e) {
            log.severe("Failed to apply for loan: " + e.getMessage());
            return false;
        }
    }

    @Override
    public Optional<AccountRecoveryDTO> getRecoveryDetails(String email) throws SQLException {
        try {
            return userDao.getRecoveryDetails(email);
        } catch (SQLException e) {
            log.severe("Error getting recovery details for email: " + email + " - " + e.getMessage());
            throw e;
        }
    }

    @Override
    public List<LoanApplication> getLoanApplications(int accountNo) {
        try {
            return userDao.getLoanApplications(accountNo);
        } catch (SQLException e) {
            log.severe("Could not fetch loan applications for account: " + accountNo + " - " + e.getMessage());
            return List.of();
        }
    }

    @Override
    public Optional<UserProfile> getUserProfile(int accountNo) {
        try {
            return userDao.getUserProfile(accountNo);
        } catch (SQLException e) {
            log.severe("Could not fetch user profile for account: " + accountNo + " - " + e.getMessage());
            return Optional.empty();
        }
    }
}
