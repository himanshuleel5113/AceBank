package com.acebank.lite.controllers;

import com.acebank.lite.models.AccountRecoveryDTO;
import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import com.acebank.lite.service.OTPService;
import com.acebank.lite.util.MailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.java.Log;

import java.io.IOException;
import java.util.Optional;

@Log
@WebServlet("/Forgot")
public class Forgot extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BankService bankService = new BankServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if we're in the middle of OTP verification
        if (session != null) {
            String email = (String) session.getAttribute("resetEmail");

            if (email != null) {
                if (OTPService.isVerified(email)) {
                    // OTP already verified, go to reset password
                    response.sendRedirect("ResetPassword.jsp");
                    return;
                } else {
                    // Show OTP entry page
                    response.sendRedirect("VerifyOTP.jsp");
                    return;
                }
            }
        }

        // No active reset session, show forgot password page
        response.sendRedirect("ForgotPassword.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        log.info("Processing forgot password for email: " + email);

        if (email == null || email.trim().isEmpty()) {
            response.sendRedirect("ForgotPassword.jsp?error=Email+is+required");
            return;
        }

        // Validate email format
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            response.sendRedirect("ForgotPassword.jsp?error=Invalid+email+format");
            return;
        }

        try {
            // Get account details from email
            Optional<AccountRecoveryDTO> detailsOpt = bankService.getRecoveryDetails(email.trim());

            if (detailsOpt.isPresent()) {
                AccountRecoveryDTO details = detailsOpt.get();

                // Generate 6-digit OTP
                String otp = OTPService.generateOTP(details.accountNo(), email);

                // Store email in session
                HttpSession session = request.getSession();
                session.setAttribute("resetEmail", email);
                session.setAttribute("resetAccountNo", details.accountNo());
                session.setAttribute("resetFirstName", details.firstName());
                session.setAttribute("resetLastName", details.lastName());

                // Log the session attributes for debugging
                log.info("Session created for email: " + email);
                log.info("Session ID: " + session.getId());

                // Send OTP via email
                String subject = "AceBank - Password Reset OTP";
                String msg = String.format(
                        "Dear %s %s,\n\n" +
                                "We received a request to reset your AceBank password.\n\n" +
                                "Your OTP (One-Time Password) is: %s\n\n" +
                                "This OTP is valid for 10 minutes.\n\n" +
                                "If you didn't request this password reset, please ignore this email.\n\n" +
                                "Stay safe,\n" +
                                "The AceBank Security Team",
                        details.firstName(), details.lastName(), otp);

                boolean emailSent = MailUtil.sendMail(email, subject, msg);

                if (emailSent) {
                    log.info("OTP sent successfully to: " + email);
                    log.info("Redirecting to VerifyOTP.jsp");
                    // IMPORTANT: Redirect to OTP verification page, NOT login
                    response.sendRedirect(request.getContextPath() + "/VerifyOTP.jsp");
                } else {
                    log.severe("Failed to send OTP email to: " + email);
                    response.sendRedirect("ForgotPassword.jsp?error=Failed+to+send+OTP.+Please+try+again");
                }
            } else {
                log.warning("No account found for email: " + email);
                response.sendRedirect("ForgotFail.jsp");
            }
        } catch (Exception e) {
            log.severe("Error in forgot password: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("ForgotPassword.jsp?error=System+error.+Please+try+again");
        }
    }
}