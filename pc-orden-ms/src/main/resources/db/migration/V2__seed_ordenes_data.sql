-- Insertar orden semilla inicial para pruebas de sustentacion
INSERT INTO ordenes_compra (codigo_orden, cliente_id, cliente_nombre, cliente_email, subtotal, igv, total, estado, metodo_pago, direccion_envio, observaciones, fecha_creacion, fecha_actualizacion)
VALUES ('ENIAC-20260901-0001', 1, 'Eliceo Parillo Mostajo', 'eliceo.parillo@upeu.edu.pe', 6549.00, 1178.82, 7727.82, 'PAGADA', 'MERCADO_PAGO', 'Av. La Marina 2500, San Miguel, Lima', 'PC Ensamble Gamer de Alto Rendimiento', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO ordenes_compra_detalle (orden_compra_id, producto_id, sku, producto_nombre, precio_unitario, cantidad, subtotal_linea)
VALUES
(1, 1, 'AMD-7800X3D', 'AMD Ryzen 7 7800X3D 8 Cores 5.0GHz AM5', 1850.00, 1, 1850.00),
(1, 3, 'NV-RTX4080S', 'ASUS TUF Gaming GeForce RTX 4080 SUPER 16GB OC', 4699.00, 1, 4699.00);