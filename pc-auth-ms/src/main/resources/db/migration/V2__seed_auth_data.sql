-- Password "eniaclabs2026" hashed con BCrypt (cost=12):
-- BCrypt: $2a$12$...
-- Generated using BCryptPasswordEncoder(12).encode("eniaclabs2026")
INSERT INTO usuarios (username, email, password_hash, nombres, apellidos, telefono, activo, fecha_creacion) VALUES
('admin', 'admin@eniaclabs.pe', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/RK.PZvO.S', 'Administrador', 'ENIAC Labs', '987654321', true, CURRENT_TIMESTAMP),
('laura.vargas', 'laura.vargas@upeu.edu.pe', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/RK.PZvO.S', 'Laura Vargas', 'Cristhian Paul', '998877665', true, CURRENT_TIMESTAMP),
('eliceo.parillo', 'eliceo.parillo@upeu.edu.pe', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/RK.PZvO.S', 'Eliceo', 'Parillo Mostajo', '911223344', true, CURRENT_TIMESTAMP);