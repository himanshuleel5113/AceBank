package com.acebank.lite.controllers;

import com.acebank.lite.models.*;
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
import java.math.BigDecimal;
import java.util.List;

@Log
@WebServlet("/home")
public class Home extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BankService bankService = new BankServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("accountNumber") == null) {
            log.warning("Unauthorized access attempt to /home");
            response.sendRedirect(request.getContextPath() + "/Login.jsp?error=Please login first");
            return;
        }

        try {
            int accountNumber = (int) session.getAttribute("accountNumber");

            // Refresh session data
            BigDecimal balance = bankService.getBalance(accountNumber);
            List<Transaction> transactions = bankService.getTransactionHistory(accountNumber);

            session.setAttribute("balance", balance != null ? balance : BigDecimal.ZERO);
            session.setAttribute("transactionDetailsList", transactions != null ? transactions : List.of());

            log.info("Loading dashboard for account: " + accountNumber);

            request.getRequestDispatcher("/WEB-INF/views/Home.jsp").forward(request, response);

        } catch (Exception e) {
            log.severe("Error loading dashboard: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/GenericError.html");
        }
    }

}