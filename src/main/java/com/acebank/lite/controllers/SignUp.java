package com.acebank.lite.controllers;

import com.acebank.lite.models.LoginResult;
import com.acebank.lite.models.User;
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
import java.io.Serial;
import java.util.ArrayList;
import java.util.Optional;

@Log
@WebServlet("/signup")  // Keep this as lowercase - we'll match form to this
public class SignUp extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    private final BankService bankService = new BankServiceImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Extract Data
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String aadharStr = request.getParameter("aadharNumber");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        log.info("SignUp attempt for email: " + email);

        // Validation
        if (firstName == null || firstName.trim().isEmpty() ||
                lastName == null || lastName.trim().isEmpty() ||
                aadharStr == null || aadharStr.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {

            log.warning("SignUp failed: Missing required fields");
            response.sendRedirect("SignUp.jsp?error=All+fields+are+required");
            return;
        }

        // Validate Aadhar (12 digits)
        if (!aadharStr.matches("\\d{12}")) {
            log.warning("SignUp failed: Invalid Aadhar number");
            response.sendRedirect("SignUp.jsp?error=Invalid+Aadhar+number");
            return;
        }

        try {
            // 2. Create the User object
            User newUser = new User(
                    null,
                    firstName.trim(),
                    lastName.trim(),
                    aadharStr.trim(),
                    email.trim().toLowerCase(),
                    password, // Will be hashed in service layer
                    null
            );

            // 3. Call Service to handle logic
            Optional<LoginResult> resultOpt = bankService.registerUser(newUser);

            if (resultOpt.isPresent()) {
                var details = resultOpt.get();
                HttpSession session = request.getSession();

                // 4. Set Session Attributes
                session.setAttribute("accountNumber", details.accountNumber());
                session.setAttribute("firstName", details.firstName());
                session.setAttribute("lastName", details.lastName());
                session.setAttribute("email", details.email());
                session.setAttribute("balance", details.balance());
                session.setAttribute("transactionDetailsList", new ArrayList<>());

                log.info("User registered successfully: " + details.accountNumber());
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                log.warning("SignUp failed for email: " + email);
                response.sendRedirect("SignUp.jsp?error=Registration+failed.+Email+may+already+exist");
            }

        } catch (Exception e) {
            log.severe("SignUp Servlet Error: " + e.getMessage());
            response.sendRedirect("GenericError.html");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // Redirect GET requests to the signup page
        response.sendRedirect("SignUp.jsp");
    }
}