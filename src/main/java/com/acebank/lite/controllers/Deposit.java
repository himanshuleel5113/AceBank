package com.acebank.lite.controllers;


import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import lombok.extern.java.Log;

import java.io.IOException;
import java.math.BigDecimal;

@Log
@WebServlet("/deposit")
public class Deposit extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BankService bankService = new BankServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer accNo = (Integer) session.getAttribute("accountNumber");
        String amountStr = request.getParameter("amount");

        if (accNo == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        try {
            BigDecimal amount = new BigDecimal(amountStr);

            // 1. Call Service to handle the deposit
            boolean success = bankService.processDeposit(accNo, amount);

            if (success) {
                // Refresh balance from service for accuracy
                session.setAttribute("balance", bankService.getBalance(accNo));
                session.setAttribute("toastMessage", "₹" + amount + " deposited successfully");
                session.setAttribute("toastType", "success");
                response.sendRedirect(request.getContextPath() + "/home");

            } else {
                session.setAttribute("toastMessage", "Deposit failed. Please try again.");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/home");

            }
        } catch (Exception e) {
            log.severe("Deposit error: " + e.getMessage());
            session.setAttribute("toastMessage", "Transaction failed. Please try again.");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/home");

        }
    }
}