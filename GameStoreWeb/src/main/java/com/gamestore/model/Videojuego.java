package com.gamestore.model;

public class Videojuego {
    private int idJuego;
    private String codigoSku;
    private String titulo;
    private String genero;
    private int idPlataforma;
    private String nombrePlataforma;
    private double precio;
    private int stock;
    private String clasificacionEsrb;

    public int getIdJuego() { return idJuego; }
    public void setIdJuego(int idJuego) { this.idJuego = idJuego; }
    public String getCodigoSku() { return codigoSku; }
    public void setCodigoSku(String codigoSku) { this.codigoSku = codigoSku; }
    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }
    public String getGenero() { return genero; }
    public void setGenero(String genero) { this.genero = genero; }
    public int getIdPlataforma() { return idPlataforma; }
    public void setIdPlataforma(int idPlataforma) { this.idPlataforma = idPlataforma; }
    public String getNombrePlataforma() { return nombrePlataforma; }
    public void setNombrePlataforma(String nombrePlataforma) { this.nombrePlataforma = nombrePlataforma; }
    public double getPrecio() { return precio; }
    public void setPrecio(double precio) { this.precio = precio; }
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
    public String getClasificacionEsrb() { return clasificacionEsrb; }
    public void setClasificacionEsrb(String clasificacionEsrb) { this.clasificacionEsrb = clasificacionEsrb; }
}