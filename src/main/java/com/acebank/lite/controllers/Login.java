package com.acebank.lite.controllers;

import java.io.IOException;
import java.io.Serial;
import java.util.Optional;

import com.acebank.lite.models.LoginResult;
import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import lombok.extern.java.Log;

@Log
@WebServlet(name = "Login", urlPatterns = "/Login")
public class Login extends HttpServlet {

    @Serial
    private static final long serialVersionUID = 1L;

    private final BankService bankService = new BankServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accStr = request.getParameter("accountNumber");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        try {
            int accountNo = Integer.parseInt(accStr);

            Optional<LoginResult> result = bankService.authenticate(accountNo, password);
            if (result.isPresent()) {
                LoginResult details = result.get();
                request.changeSessionId(); // session fixation protection
                HttpSession session = request.getSession(true);
                session.setAttribute("accountNumber", accountNo);
                session.setAttribute("firstName", details.firstName());
                session.setAttribute("lastName", details.lastName());
                session.setAttribute("email", details.email());
                session.setAttribute("balance", details.balance());
                // transactions will be loaded by Home servlet

                if (rememberMe != null) {
                    Cookie cookie = new Cookie("rememberedAccount", String.valueOf(accountNo));
                    cookie.setMaxAge(30 * 24 * 60 * 60);
                    cookie.setPath("/");
                    cookie.setHttpOnly(true);
                    cookie.setSecure(true);
                    response.addCookie(cookie);
                    response.setHeader("Set-Cookie",
                            "rememberedAccount=" + accountNo
                                    + "; Max-Age=" + (30 * 24 * 60 * 60)
                                    + "; Path=/; HttpOnly; Secure; SameSite=Strict");
                }

                log.info("User " + accountNo + " logged in successfully.");
                response.sendRedirect(request.getContextPath() + "/home");

            } else {
                log.warning("Authentication failed for account: " + accStr);
                response.sendRedirect("LoginFail.jsp");
            }

        } catch (Exception e) {
            log.severe("Login Error: " + e.getMessage());
            response.sendRedirect("LoginFail.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Login.jsp");
    }
}
