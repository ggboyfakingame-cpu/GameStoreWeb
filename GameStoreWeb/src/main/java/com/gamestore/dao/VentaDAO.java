package com.gamestore.dao;

import com.gamestore.config.ConexionDB;
import com.gamestore.model.VentaDetalle;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VentaDAO {

    public boolean registrarVenta(int idJuego, int idUsuario, int cantidad) {
        String sqlCheck = "SELECT precio, stock FROM videojuegos WHERE id_juego = ? FOR UPDATE";
        String sqlUpdateStock = "UPDATE videojuegos SET stock = stock - ? WHERE id_juego = ?";
        String sqlInsertVenta = "INSERT INTO ventas (id_juego, id_usuario, cantidad, total) VALUES (?, ?, ?, ?)";

        try (Connection conn = ConexionDB.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psCheck = conn.prepareStatement(sqlCheck)) {
                psCheck.setInt(1, idJuego);
                ResultSet rs = psCheck.executeQuery();
                if (!rs.next() || rs.getInt("stock") < cantidad) {
                    conn.rollback();
                    return false;
                }
                double total = rs.getDouble("precio") * cantidad;

                try (PreparedStatement psUpd = conn.prepareStatement(sqlUpdateStock);
                     PreparedStatement psIns = conn.prepareStatement(sqlInsertVenta)) {
                    psUpd.setInt(1, cantidad);
                    psUpd.setInt(2, idJuego);
                    psUpd.executeUpdate();

                    psIns.setInt(1, idJuego);
                    psIns.setInt(2, idUsuario);
                    psIns.setInt(3, cantidad);
                    psIns.setDouble(4, total);
                    psIns.executeUpdate();

                    conn.commit();
                    return true;
                }
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<VentaDetalle> listarVentas() {
        List<VentaDetalle> lista = new ArrayList<>();
        String sql = "SELECT ve.id_venta, vi.codigo_sku, vi.titulo, u.nombre AS vendedor, " +
                "ve.cantidad, ve.total, ve.fecha " +
                "FROM ventas ve " +
                "INNER JOIN videojuegos vi ON ve.id_juego = vi.id_juego " +
                "INNER JOIN usuarios u ON ve.id_usuario = u.id_usuario " +
                "ORDER BY ve.fecha DESC";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                VentaDetalle vd = new VentaDetalle();
                vd.setIdVenta(rs.getInt("id_venta"));
                vd.setCodigoSku(rs.getString("codigo_sku"));
                vd.setTituloJuego(rs.getString("titulo"));
                vd.setVendedor(rs.getString("vendedor"));
                vd.setCantidad(rs.getInt("cantidad"));
                vd.setTotal(rs.getDouble("total"));
                vd.setFecha(rs.getTimestamp("fecha"));
                lista.add(vd);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}