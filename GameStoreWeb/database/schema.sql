CREATE DATABASE IF NOT EXISTS gamestore_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE gamestore_db;

CREATE TABLE usuarios (
                          id_usuario INT AUTO_INCREMENT PRIMARY KEY,
                          nombre VARCHAR(100) NOT NULL,
                          email VARCHAR(100) UNIQUE NOT NULL,
                          password VARCHAR(255) NOT NULL,
                          rol ENUM('ADMIN', 'VENDEDOR') DEFAULT 'VENDEDOR'
);

CREATE TABLE plataformas (
                             id_plataforma INT AUTO_INCREMENT PRIMARY KEY,
                             nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE videojuegos (
                             id_juego INT AUTO_INCREMENT PRIMARY KEY,
                             codigo_sku VARCHAR(30) UNIQUE NOT NULL,
                             titulo VARCHAR(120) NOT NULL,
                             genero VARCHAR(50) NOT NULL,
                             id_plataforma INT NOT NULL,
                             precio DECIMAL(10,2) NOT NULL,
                             stock INT NOT NULL DEFAULT 0,
                             clasificacion_esrb VARCHAR(10) NOT NULL,
                             activo BOOLEAN DEFAULT TRUE,
                             FOREIGN KEY (id_plataforma) REFERENCES plataformas(id_plataforma)
);

CREATE TABLE ventas (
                        id_venta INT AUTO_INCREMENT PRIMARY KEY,
                        id_juego INT NOT NULL,
                        id_usuario INT NOT NULL,
                        cantidad INT NOT NULL,
                        total DECIMAL(10,2) NOT NULL,
                        fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        FOREIGN KEY (id_juego) REFERENCES videojuegos(id_juego),
                        FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

INSERT INTO usuarios (nombre, email, password, rol) VALUES
    ('Admin GameStore', 'admin@gamestore.com', 'Admin123!', 'ADMIN');

INSERT INTO plataformas (nombre) VALUES
                                     ('PC / Steam'), ('PlayStation 5'), ('Xbox Series X|S'), ('Nintendo Switch');

INSERT INTO videojuegos (codigo_sku, titulo, genero, id_plataforma, precio, stock, clasificacion_esrb) VALUES
                                                                                                           ('GS-PC-001', 'Cyberpunk 2077: Ultimate Edition', 'RPG', 1, 1199.00, 15, 'M'),
                                                                                                           ('GS-PS5-002', 'God of War Ragnarök', 'Acción-Aventura', 2, 1399.00, 8, 'M'),
                                                                                                           ('GS-NSW-003', 'The Legend of Zelda: Tears of the Kingdom', 'Aventura', 4, 1299.00, 3, 'E10+');