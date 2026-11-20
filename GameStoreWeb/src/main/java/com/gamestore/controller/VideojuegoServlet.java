package com.gamestore.controller;

import com.gamestore.dao.VideojuegoDAO;
import com.gamestore.model.Usuario;
import com.gamestore.model.Videojuego;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/videojuegos")
public class VideojuegoServlet extends HttpServlet {
    private final VideojuegoDAO dao = new VideojuegoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "nuevo":
                req.getRequestDispatcher("/WEB-INF/views/form_videojuego.jsp").forward(req, resp);
                break;
            case "editar":
                int idEditar = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("juego", dao.buscarPorId(idEditar));
                req.getRequestDispatcher("/WEB-INF/views/form_videojuego.jsp").forward(req, resp);
                break;
            case "eliminar":
                int idEliminar = Integer.parseInt(req.getParameter("id"));
                dao.eliminar(idEliminar);
                resp.sendRedirect("videojuegos");
                break;
            default:
                String q = req.getParameter("q");
                String platStr = req.getParameter("plataforma");
                String orden = req.getParameter("orden");
                Integer idPlat = (platStr != null && !platStr.isEmpty()) ? Integer.parseInt(platStr) : null;

                List<Videojuego> lista = dao.listarConFiltros(q, idPlat, orden);
                req.setAttribute("videojuegos", lista);
                req.getRequestDispatcher("/WEB-INF/views/inventario.jsp").forward(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");

        if ("vender".equals(accion)) {
            int idJuego = Integer.parseInt(req.getParameter("id_juego"));
            int cantidad = Integer.parseInt(req.getParameter("cantidad"));
            Usuario u = (Usuario) req.getSession().getAttribute("usuario");

            if (cantidad <= 0 || !dao.registrarVenta(idJuego, u.getIdUsuario(), cantidad)) {
                req.getSession().setAttribute("flashError", "Stock insuficiente o cantidad inválida para la venta.");
            } else {
                req.getSession().setAttribute("flashOk", "Venta registrada y stock actualizado.");
            }
            resp.sendRedirect("videojuegos");
            return;
        }

        String idStr = req.getParameter("id_juego");
        String sku = req.getParameter("codigo_sku");
        String titulo = req.getParameter("titulo");
        String genero = req.getParameter("genero");
        String esrb = req.getParameter("clasificacion_esrb");

        try {
            int idPlataforma = Integer.parseInt(req.getParameter("id_plataforma"));
            double precio = Double.parseDouble(req.getParameter("precio"));
            int stock = Integer.parseInt(req.getParameter("stock"));

            if (sku == null || sku.trim().isEmpty() || titulo == null || titulo.trim().isEmpty() || precio <= 0 || stock < 0) {
                throw new IllegalArgumentException("Campos obligatorios vacíos o valores negativos.");
            }

            Videojuego v = new Videojuego();
            v.setCodigoSku(sku.trim().toUpperCase());
            v.setTitulo(titulo.trim());
            v.setGenero(genero.trim());
            v.setIdPlataforma(idPlataforma);
            v.setPrecio(precio);
            v.setStock(stock);
            v.setClasificacionEsrb(esrb);

            if (idStr == null || idStr.isEmpty()) {
                dao.insertar(v);
            } else {
                v.setIdJuego(Integer.parseInt(idStr));
                dao.actualizar(v);
            }
            resp.sendRedirect("videojuegos");

        } catch (Exception e) {
            req.setAttribute("error", "Error de validación: verifica que precio > 0, stock >= 0 y el SKU no esté repetido.");
            req.getRequestDispatcher("/WEB-INF/views/form_videojuego.jsp").forward(req, resp);
        }
    }
}