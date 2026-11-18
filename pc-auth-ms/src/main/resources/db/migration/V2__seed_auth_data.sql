-- Password "eniaclabs2026" hashed con BCrypt (cost=12):
-- BCrypt: $2a$12$...
-- Generated using BCryptPasswordEncoder(12).encode("eniaclabs2026")
INSERT INTO usuarios (username, email, password_hash, nombres, apellidos, telefono, activo, fecha_creacion) VALUES
('admin', 'admin@eniaclabs.pe', '$2a$12$zAbtKSRcijUWHxt2OtxNuO6sixvJfCS.rO45T.spkzSzv1wpI4KEO', 'Administrador', 'ENIAC Labs', '987654321', true, CURRENT_TIMESTAMP),
('laura.vargas', 'laura.vargas@upeu.edu.pe', '$2a$12$zAbtKSRcijUWHxt2OtxNuO6sixvJfCS.rO45T.spkzSzv1wpI4KEO', 'Laura Vargas', 'Cristhian Paul', '998877665', true, CURRENT_TIMESTAMP),
('eliceo.parillo', 'eliceo.parillo@upeu.edu.pe', '$2a$12$zAbtKSRcijUWHxt2OtxNuO6sixvJfCS.rO45T.spkzSzv1wpI4KEO', 'Eliceo', 'Parillo Mostajo', '911223344', true, CURRENT_TIMESTAMP);

INSERT INTO usuarios_roles (usuario_id, rol_id) VALUES
(1, 1), (1, 2),
(2, 1), (2, 2),
(3, 1), (3, 2)
ON CONFLICT DO NOTHING;