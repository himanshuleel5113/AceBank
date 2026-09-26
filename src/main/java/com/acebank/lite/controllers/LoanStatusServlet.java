package com.acebank.lite.controllers;

import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import lombok.extern.java.Log;

import java.io.IOException;

@Log
@WebServlet("/loan-status")
public class LoanStatusServlet extends HttpServlet {
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

        var loans = bankService.getLoanApplications(accountNo);
        request.setAttribute("loans", loans);

        request.getRequestDispatcher("/WEB-INF/views/LoanStatus.jsp").forward(request, response);
    }
}
