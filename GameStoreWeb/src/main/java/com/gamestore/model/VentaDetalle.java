package com.gamestore.model;

import java.sql.Timestamp;

public class VentaDetalle {
    private int idVenta;
    private String codigoSku;
    private String tituloJuego;
    private String vendedor;
    private int cantidad;
    private double total;
    private Timestamp fecha;

    public int getIdVenta() { return idVenta; }
    public void setIdVenta(int idVenta) { this.idVenta = idVenta; }
    public String getCodigoSku() { return codigoSku; }
    public void setCodigoSku(String codigoSku) { this.codigoSku = codigoSku; }
    public String getTituloJuego() { return tituloJuego; }
    public void setTituloJuego(String tituloJuego) { this.tituloJuego = tituloJuego; }
    public String getVendedor() { return vendedor; }
    public void setVendedor(String vendedor) { this.vendedor = vendedor; }
    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }
    public Timestamp getFecha() { return fecha; }
    public void setFecha(Timestamp fecha) { this.fecha = fecha; }
}