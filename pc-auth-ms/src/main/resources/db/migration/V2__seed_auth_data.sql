-- Roles basicos
INSERT INTO roles (nombre, descripcion) VALUES
('ROLE_ADMIN', 'Administrador del sistema con control total'),
('ROLE_CLIENTE', 'Cliente comprador de hardware y ensamblajes'),
('ROLE_TECNICO', 'TÃ©cnico de ensamblaje y soporte de hardware');

-- Password "eniaclabs2026" hashed con SHA-256:
-- echo -n "eniaclabs2026" | sha256sum -> e482e9d29df83be27b545d1370eef1855e4e69b08f43eb75ea0874e0d4dfd410
INSERT INTO usuarios (username, email, password_hash, nombres, apellidos, telefono, activo, fecha_creacion) VALUES
('admin', 'admin@eniaclabs.pe', 'e482e9d29df83be27b545d1370eef1855e4e69b08f43eb75ea0874e0d4dfd410', 'Administrador', 'ENIAC Labs', '987654321', true, CURRENT_TIMESTAMP),
('laura.vargas', 'laura.vargas@upeu.edu.pe', 'e482e9d29df83be27b545d1370eef1855e4e69b08f43eb75ea0874e0d4dfd410', 'Laura Vargas', 'Cristhian Paul', '998877665', true, CURRENT_TIMESTAMP),
('eliceo.parillo', 'eliceo.parillo@upeu.edu.pe', 'e482e9d29df83be27b545d1370eef1855e4e69b08f43eb75ea0874e0d4dfd410', 'Eliceo', 'Parillo Mostajo', '911223344', true, CURRENT_TIMESTAMP);

-- Asignacion de roles
INSERT INTO usuarios_roles (usuario_id, rol_id) VALUES
(1, 1), -- admin -> ROLE_ADMIN
(2, 1), -- laura.vargas -> ROLE_ADMIN
(2, 2), -- laura.vargas -> ROLE_CLIENTE
(3, 1), -- eliceo.parillo -> ROLE_ADMIN
(3, 2); -- eliceo.parillo -> ROLE_CLIENTE