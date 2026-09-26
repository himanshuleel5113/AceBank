package com.acebank.lite.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Set;
import java.util.logging.Logger;

@WebFilter(urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    private static final Logger log = Logger.getLogger(AuthFilter.class.getName());

    private static final Set<String> PUBLIC_PATHS = Set.of(
            "/Login.jsp",
            "/SignUp.jsp",
            "/index.jsp",
            "/ForgotPassword.jsp",
            "/ResetPassword.jsp",
            "/VerifyOTP.jsp",
            "/ForgotFail.jsp",
            "/LoginFail.jsp",
            "/GenericError.html",
            "/404.jsp",
            "/500.jsp",
            "/Forgot",
            "/VerifyOTP",
            "/ResetPassword",
            "/signup",
            "/Login",
            "/error-handler"
    );

    private static final Set<String> STATIC_EXTENSIONS = Set.of(
            ".css", ".js", ".png", ".jpg", ".jpeg", ".gif", ".svg", ".ico", ".woff", ".woff2", ".ttf", ".map"
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getServletPath();

        // Allow static resources
        if (isStaticResource(path)) {
            chain.doFilter(request, response);
            return;
        }

        // Allow public paths (exact match)
        if (PUBLIC_PATHS.contains(path)) {
            chain.doFilter(request, response);
            return;
        }

        // Check authentication
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("accountNumber") != null);

        if (isLoggedIn) {
            chain.doFilter(request, response);
        } else {
            log.fine("Unauthorized access to: " + path + " — redirecting to login");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/Login.jsp");
        }
    }

    private boolean isStaticResource(String path) {
        if (path == null) return false;
        for (String ext : STATIC_EXTENSIONS) {
            if (path.endsWith(ext)) return true;
        }
        return false;
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        log.info("AuthFilter initialized");
    }

    @Override
    public void destroy() {
        // no-op
    }
}
