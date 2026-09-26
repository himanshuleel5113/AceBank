package com.acebank.lite.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.java.Log;

import java.io.IOException;
import java.io.Serial;

@Log
@WebServlet("/error-handler")
public class ErrorHandler extends HttpServlet {
    @Serial
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processError(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processError(request, response);
    }

    private void processError(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve error details from the request attributes
        Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
        String requestUri = (String) request.getAttribute("jakarta.servlet.error.request_uri");
        Throwable throwable = (Throwable) request.getAttribute("jakarta.servlet.error.exception");

        // Null-safety: Default values if the handler is accessed directly or attributes are missing
        if (statusCode == null) statusCode = 0;
        if (requestUri == null) requestUri = "Unknown Location";

        String title;
        String message;

        // Categorize the error
        if (statusCode == 404) {
            title = "Page Not Found";
            message = "The URL <strong>" + requestUri + "</strong> does not exist on our server.";
            log.warning("404 Error at: " + requestUri);
        } else if (statusCode == 500) {
            title = "Internal Server Error";
            message = "Our banking systems are experiencing a temporary hiccup. Our engineers have been notified.";
            log.severe("500 Error: " + (throwable != null ? throwable.getMessage() : "No exception trace"));
        } else if (statusCode == 403) {
            title = "Access Denied";
            message = "You do not have permission to view this resource.";
        } else {
            title = "Unexpected Error";
            message = "An unexpected error occurred (" + statusCode + "). Please try again later.";
            log.info("Generic Error Code: " + statusCode + " for URI: " + requestUri);
        }

        // Pass data to the JSP for rendering
        request.setAttribute("errorTitle", title);
        request.setAttribute("errorMessage", message);
        request.setAttribute("errorCode", statusCode);

        // Forward to the error page
        // Note: Use "/error.jsp" if it's in the webapp root,
        // or "/WEB-INF/views/error.jsp" if it's hidden there.
        request.getRequestDispatcher("error.jsp").forward(request, response);
    }
}