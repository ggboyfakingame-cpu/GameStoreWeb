package com.gamestore.dao;

import com.gamestore.config.ConexionDB;
import com.gamestore.model.Videojuego;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VideojuegoDAO {

    public List<Videojuego> listarConFiltros(String busqueda, Integer idPlataforma, String orden) {
        List<Videojuego> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT v.*, p.nombre AS plataforma_nombre FROM videojuegos v " +
                        "INNER JOIN plataformas p ON v.id_plataforma = p.id_plataforma WHERE v.activo = TRUE"
        );

        List<Object> params = new ArrayList<>();
        if (busqueda != null && !busqueda.trim().isEmpty()) {
            sql.append(" AND (v.titulo LIKE ? OR v.codigo_sku LIKE ? OR v.genero LIKE ?)");
            String like = "%" + busqueda.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (idPlataforma != null && idPlataforma > 0) {
            sql.append(" AND v.id_plataforma = ?");
            params.add(idPlataforma);
        }

        if ("precio_asc".equals(orden)) {
            sql.append(" ORDER BY v.precio ASC");
        } else if ("precio_desc".equals(orden)) {
            sql.append(" ORDER BY v.precio DESC");
        } else if ("stock_asc".equals(orden)) {
            sql.append(" ORDER BY v.stock ASC");
        } else {
            sql.append(" ORDER BY v.id_juego DESC");
        }

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearVideojuego(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Videojuego buscarPorId(int id) {
        String sql = "SELECT v.*, p.nombre AS plataforma_nombre FROM videojuegos v " +
                "INNER JOIN plataformas p ON v.id_plataforma = p.id_plataforma WHERE v.id_juego = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapearVideojuego(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertar(Videojuego v) {
        String sql = "INSERT INTO videojuegos (codigo_sku, titulo, genero, id_plataforma, precio, stock, clasificacion_esrb) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCodigoSku());
            ps.setString(2, v.getTitulo());
            ps.setString(3, v.getGenero());
            ps.setInt(4, v.getIdPlataforma());
            ps.setDouble(5, v.getPrecio());
            ps.setInt(6, v.getStock());
            ps.setString(7, v.getClasificacionEsrb());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizar(Videojuego v) {
        String sql = "UPDATE videojuegos SET codigo_sku=?, titulo=?, genero=?, id_plataforma=?, precio=?, stock=?, clasificacion_esrb=? WHERE id_juego=?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCodigoSku());
            ps.setString(2, v.getTitulo());
            ps.setString(3, v.getGenero());
            ps.setInt(4, v.getIdPlataforma());
            ps.setDouble(5, v.getPrecio());
            ps.setInt(6, v.getStock());
            ps.setString(7, v.getClasificacionEsrb());
            ps.setInt(8, v.getIdJuego());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminar(int idJuego) {
        String sql = "UPDATE videojuegos SET activo = FALSE WHERE id_juego = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idJuego);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

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

    private Videojuego mapearVideojuego(ResultSet rs) throws SQLException {
        Videojuego v = new Videojuego();
        v.setIdJuego(rs.getInt("id_juego"));
        v.setCodigoSku(rs.getString("codigo_sku"));
        v.setTitulo(rs.getString("titulo"));
        v.setGenero(rs.getString("genero"));
        v.setIdPlataforma(rs.getInt("id_plataforma"));
        v.setNombrePlataforma(rs.getString("plataforma_nombre"));
        v.setPrecio(rs.getDouble("precio"));
        v.setStock(rs.getInt("stock"));
        v.setClasificacionEsrb(rs.getString("clasificacion_esrb"));
        return v;
    }
}