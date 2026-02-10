-- 1. Crear tabla de Categorías
CREATE TABLE IF NOT EXISTS categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255)
);

-- 2. Crear tabla de Productos
CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    categoria_id INT,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE SET NULL
);

-- 3. Crear tabla de Ventas (Historial)
CREATE TABLE IF NOT EXISTS ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT,
    cantidad INT NOT NULL,
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- Inserción de datos de prueba
INSERT INTO categorias (nombre, descripcion) VALUES 
('Laptops', 'Equipos portátiles de alto rendimiento'),
('Periféricos', 'Teclados, ratones y monitores');

INSERT INTO productos (nombre, precio, stock, categoria_id) VALUES 
('ASUS TUF Gaming F15', 1100.00, 10, 1),
('Ratón Gaming RGB', 45.50, 50, 2),
('Teclado Mecánico', 89.99, 25, 2);

INSERT INTO ventas (producto_id, cantidad) VALUES 
(1, 1),
(2, 2);