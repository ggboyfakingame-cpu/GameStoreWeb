package com.gamestore.controller;

import com.gamestore.dao.VentaDAO;
import com.gamestore.model.Usuario;
import com.gamestore.model.VentaDetalle;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ventas")
public class VentaServlet extends HttpServlet {
    private final VentaDAO ventaDAO = new VentaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<VentaDetalle> ventas = ventaDAO.listarVentas();
        double ingresosTotales = ventas.stream().mapToDouble(VentaDetalle::getTotal).sum();

        req.setAttribute("ventas", ventas);
        req.setAttribute("ingresosTotales", ingresosTotales);
        req.getRequestDispatcher("/WEB-INF/views/historial_ventas.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int idJuego = Integer.parseInt(req.getParameter("id_juego"));
        int cantidad = Integer.parseInt(req.getParameter("cantidad"));
        Usuario u = (Usuario) req.getSession().getAttribute("usuario");

        if (cantidad <= 0 || !ventaDAO.registrarVenta(idJuego, u.getIdUsuario(), cantidad)) {
            req.getSession().setAttribute("flashError", "Stock insuficiente o cantidad inválida.");
        } else {
            req.getSession().setAttribute("flashOk", "Venta registrada y stock actualizado.");
        }
        resp.sendRedirect(req.getContextPath() + "/videojuegos");
    }
}