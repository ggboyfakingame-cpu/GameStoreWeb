package com.gamestore.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter({"/videojuegos", "/ventas", "/views/*"})
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // Evita que el navegador guarde en caché páginas privadas al dar clic en "Atrás"
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        // Bloquea acceso directo a /views/ o a cualquier .jsp interno y manda al Servlet
        String uri = req.getRequestURI();
        if (uri.endsWith("/views/") || uri.endsWith("/views") || uri.endsWith(".jsp")) {
            resp.sendRedirect(req.getContextPath() + "/videojuegos");
            return;
        }

        chain.doFilter(request, response);
    }
}