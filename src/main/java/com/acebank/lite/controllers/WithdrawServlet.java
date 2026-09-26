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
@WebServlet("/withdraw")
public class WithdrawServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BankService bankService = new BankServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }

        int accountNo = (int) session.getAttribute("accountNumber");
        String amountStr = request.getParameter("amount");

        try {
            BigDecimal amount = new BigDecimal(amountStr);
            String result = bankService.withdraw(accountNo, amount);

            if ("SUCCESS".equals(result)) {
                session.setAttribute("balance", bankService.getBalance(accountNo));
                session.setAttribute("toastMessage", "₹" + amount + " withdrawn successfully");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMessage", result);
                session.setAttribute("toastType", "error");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid amount format");
            session.setAttribute("toastType", "error");
        } catch (Exception e) {
            log.severe("Withdrawal error: " + e.getMessage());
            session.setAttribute("toastMessage", "Transaction failed. Please try again.");
            session.setAttribute("toastType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/home");
    }
}
