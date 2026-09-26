package com.acebank.lite.controllers;

import com.acebank.lite.models.Transaction;
import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import lombok.extern.java.Log;

import java.io.IOException;
import java.util.List;

@Log
@WebServlet("/statement")
public class StatementServlet extends HttpServlet {
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

        int accountNo = (int) session.getAttribute("accountNumber");

        List<Transaction> transactions = bankService.getTransactionHistory(accountNo);
        request.setAttribute("transactions", transactions);
        request.setAttribute("accountNo", accountNo);

        request.getRequestDispatcher("/WEB-INF/views/Statement.jsp").forward(request, response);
    }
}
