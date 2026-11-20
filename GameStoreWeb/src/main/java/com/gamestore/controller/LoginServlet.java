package com.gamestore.controller;

import com.gamestore.dao.UsuarioDAO;
import com.gamestore.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        Usuario u = usuarioDAO.validarLogin(email, password);

        if (u != null) {
            HttpSession session = req.getSession(true);
            session.setAttribute("usuario", u);
            resp.sendRedirect(req.getContextPath() + "/videojuegos");
        } else {
            req.setAttribute("error", "Credenciales incorrectas.");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }
}