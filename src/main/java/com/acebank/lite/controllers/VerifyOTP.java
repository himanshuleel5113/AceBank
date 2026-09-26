package com.acebank.lite.controllers;

import com.acebank.lite.service.OTPService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.java.Log;

import java.io.IOException;

@Log
@WebServlet("/VerifyOTP")
public class VerifyOTP extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("resetEmail") == null) {
            log.warning("No active reset session, redirecting to ForgotPassword");
            response.sendRedirect(request.getContextPath() + "/ForgotPassword.jsp");
            return;
        }

        String email = (String) session.getAttribute("resetEmail");
        log.info("VerifyOTP GET - Email from session: " + email);

        // Check if OTP is already verified
        if (OTPService.isVerified(email)) {
            log.info("OTP already verified, redirecting to ResetPassword");
            response.sendRedirect(request.getContextPath() + "/ResetPassword.jsp");
            return;
        }

        // Show OTP verification page
        log.info("Showing OTP verification page for email: " + email);
        request.getRequestDispatcher("/VerifyOTP.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            log.warning("No session found, redirecting to ForgotPassword");
            response.sendRedirect(request.getContextPath() + "/ForgotPassword.jsp");
            return;
        }

        String email = (String) session.getAttribute("resetEmail");
        String otp = request.getParameter("otp");
        String action = request.getParameter("action");

        log.info("VerifyOTP POST - Email: " + email + ", Action: " + action);

        if (email == null) {
            log.warning("No email in session, redirecting to ForgotPassword");
            response.sendRedirect(request.getContextPath() + "/ForgotPassword.jsp");
            return;
        }

        // Handle resend OTP
        if ("resend".equals(action)) {
            log.info("Resending OTP for email: " + email);
            response.sendRedirect(request.getContextPath() + "/Forgot?email=" + email);
            return;
        }

        // Validate OTP
        if (otp == null || otp.trim().isEmpty()) {
            log.warning("Empty OTP submitted");
            response.sendRedirect(request.getContextPath() + "/VerifyOTP.jsp?error=Please+enter+OTP");
            return;
        }

        log.info("Validating OTP for email: " + email);
        boolean valid = OTPService.validateOTP(email, otp);

        if (valid) {
            log.info("OTP verified successfully for email: " + email);
            response.sendRedirect(request.getContextPath() + "/ResetPassword.jsp");
        } else {
            log.warning("Invalid or expired OTP for email: " + email);
            response.sendRedirect(request.getContextPath() + "/VerifyOTP.jsp?error=Invalid+or+expired+OTP");
        }
    }
}