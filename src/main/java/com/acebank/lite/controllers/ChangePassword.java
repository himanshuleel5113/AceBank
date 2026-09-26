package com.acebank.lite.controllers;

import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
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
@WebServlet("/ChangePassword")
public class ChangePassword extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BankService bankService = new BankServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        // Forward to Change Password page
        request.getRequestDispatcher("/ChangePassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        int accountNo = (int) session.getAttribute("accountNumber");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmNewPassword");

        // Validation
        if (currentPassword == null || currentPassword.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {

            response.sendRedirect("ChangePassword.jsp?error=All+fields+are+required");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("ChangePassword.jsp?error=New+password+and+confirm+password+do+not+match");
            return;
        }

        if (newPassword.length() < 8) {
            response.sendRedirect("ChangePassword.jsp?error=Password+must+be+at+least+8+characters");
            return;
        }

        // Check password strength
        if (!newPassword.matches(".*[A-Z].*") || !newPassword.matches(".*[0-9].*")) {
            response.sendRedirect("ChangePassword.jsp?error=Password+must+contain+at+least+one+uppercase+letter+and+one+number");
            return;
        }

        try {
            boolean success = bankService.changePassword(accountNo, currentPassword, newPassword);

            if (success) {
                log.info("Password changed successfully for account: " + accountNo);

                response.sendRedirect(request.getContextPath() + "/home?msg=Password+changed+successfully");
            } else {
                response.sendRedirect("ChangePassword.jsp?error=Current+password+is+incorrect");
            }

        } catch (SQLException e) {
            log.severe("Password change error: " + e.getMessage());
            response.sendRedirect("ChangePassword.jsp?error=System+error.+Please+try+again");
        }
    }
}