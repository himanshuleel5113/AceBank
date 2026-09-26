package com.acebank.lite.controllers;

import com.acebank.lite.dao.BankUserDao;
import com.acebank.lite.dao.BankUserDaoImpl;
import com.acebank.lite.service.NotificationService;
import com.acebank.lite.service.OTPService;
import com.acebank.lite.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.java.Log;

import java.io.IOException;
import java.sql.SQLException;

@Log
@WebServlet("/ResetPassword")
public class ResetPassword extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BankUserDao userDao = new BankUserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("resetEmail") == null) {
            log.warning("No active reset session, redirecting to ForgotPassword");
            response.sendRedirect("ForgotPassword.jsp");
            return;
        }

        String email = (String) session.getAttribute("resetEmail");
        log.info("ResetPassword GET - Email from session: " + email);

        // Check if OTP was verified
        if (!OTPService.isVerified(email)) {
            log.warning("Attempt to access reset page without OTP verification");
            response.sendRedirect("VerifyOTP.jsp?error=Please+verify+OTP+first");
            return;
        }

        // Show reset password page
        log.info("Showing reset password page for email: " + email);
        request.getRequestDispatcher("ResetPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("ForgotPassword.jsp");
            return;
        }

        String email = (String) session.getAttribute("resetEmail");
        Integer accountNo = (Integer) session.getAttribute("resetAccountNo");

        log.info("ResetPassword POST - Email: " + email + ", AccountNo: " + accountNo);

        if (email == null || accountNo == null) {
            log.warning("Missing email or accountNo in session");
            response.sendRedirect("ForgotPassword.jsp");
            return;
        }

        // Check if OTP was verified
        if (!OTPService.isVerified(email)) {
            log.warning("Attempt to reset password without OTP verification for email: " + email);
            response.sendRedirect("VerifyOTP.jsp?error=Please+verify+OTP+first");
            return;
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate inputs
        if (newPassword == null || newPassword.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {
            response.sendRedirect("ResetPassword.jsp?error=All+fields+are+required");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("ResetPassword.jsp?error=Passwords+do+not+match");
            return;
        }

        if (newPassword.length() < 8) {
            response.sendRedirect("ResetPassword.jsp?error=Password+must+be+at+least+8+characters");
            return;
        }

        if (!newPassword.matches(".*[A-Z].*") || !newPassword.matches(".*[0-9].*")) {
            response.sendRedirect("ResetPassword.jsp?error=Password+must+contain+uppercase+and+number");
            return;
        }

        try {
            // Hash the new password
            String hashedPassword = PasswordUtil.hashPassword(newPassword);

            // Update password in database
            boolean success = userDao.updatePasswordByAccountNo(accountNo, hashedPassword);

            if (success) {
                // Clear OTP data
                OTPService.clearOTP(email);

                // Clear session attributes
                session.removeAttribute("resetEmail");
                session.removeAttribute("resetAccountNo");
                session.removeAttribute("resetFirstName");
                session.removeAttribute("resetLastName");

                // Add notification
                NotificationService.addNotification(accountNo,
                        "Your password was reset successfully using OTP", "SECURITY");

                log.info("Password reset successful for account: " + accountNo);
                response.sendRedirect(request.getContextPath() + "/Login.jsp?msg=Password+reset+successful.+Please+login+with+your+new+password");
            } else {
                log.warning("Failed to reset password for account: " + accountNo);
                response.sendRedirect("ResetPassword.jsp?error=Failed+to+reset+password");
            }

        } catch (SQLException e) {
            log.severe("Error resetting password: " + e.getMessage());
            response.sendRedirect("ResetPassword.jsp?error=System+error.+Please+try+again");
        }
    }
}