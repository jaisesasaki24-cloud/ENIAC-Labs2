-- Migracion S07b: Adaptar cliente_id para almacenar el claim 'sub' (UUID de 36 caracteres) de Keycloak
ALTER TABLE ordenes_compra ALTER COLUMN cliente_id TYPE VARCHAR(36) USING cliente_id::text;
