package com.gamestore.controller;

import com.gamestore.dao.UsuarioDAO;
import com.gamestore.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/registro")
public class RegistroServlet extends HttpServlet {
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String nombre = req.getParameter("nombre");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (nombre == null || nombre.trim().isEmpty() || email == null || password == null || password.length() < 6) {
            req.setAttribute("error", "Datos inválidos. La contraseña debe tener al menos 6 caracteres.");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
            return;
        }

        Usuario nuevo = new Usuario();
        nuevo.setNombre(nombre.trim());
        nuevo.setEmail(email.trim());
        nuevo.setPassword(password);

        if (usuarioDAO.registrar(nuevo)) {
            req.setAttribute("mensaje", "Registro exitoso. Ya puedes iniciar sesión.");
        } else {
            req.setAttribute("error", "El correo ya está registrado.");
        }
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}