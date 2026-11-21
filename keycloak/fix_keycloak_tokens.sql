-- ============================================================
-- SCRIPT IDEMPOTENTE DE CONFIGURACION KEYCLOAK ENIAC LABS
-- ============================================================

-- 1. Desactivar SSL Obligatorio en todos los realms
UPDATE realm SET ssl_required = 'NONE';

-- 2. Asegurar el Realm 'eniaclabs'
DO $$
DECLARE
    v_realm_id VARCHAR(36);
    v_client_id VARCHAR(36) := '25f3d0d8-5401-4761-8cae-2ab2f08ad3b5';
    v_user_id VARCHAR(36) := 'f6e310f2-39a9-4774-a6f6-da6068e63ab8';
    v_role_id VARCHAR(36);
BEGIN
    SELECT id INTO v_realm_id FROM realm WHERE name = 'eniaclabs';
    
    IF v_realm_id IS NULL THEN
        RAISE NOTICE 'Realm eniaclabs no encontrado. Debe crearse primero.';
        RETURN;
    END IF;

    -- 3. Crear o actualizar el cliente 'eniaclabs-frontend'
    IF EXISTS (SELECT 1 FROM client WHERE realm_id = v_realm_id AND client_id = 'eniaclabs-frontend') THEN
        UPDATE client SET 
            public_client = true,
            direct_access_grants_enabled = true,
            standard_flow_enabled = true,
            enabled = true,
            full_scope_allowed = true,
            root_url = '*',
            client_authenticator_type = 'client-secret'
        WHERE realm_id = v_realm_id AND client_id = 'eniaclabs-frontend';
        
        SELECT id INTO v_client_id FROM client WHERE realm_id = v_realm_id AND client_id = 'eniaclabs-frontend';
    ELSE
        INSERT INTO client (
            id, enabled, full_scope_allowed, client_id, not_before, 
            public_client, secret, base_url, bearer_only, management_url, 
            surrogate_auth_required, realm_id, protocol, node_rereg_timeout, 
            frontchannel_logout, consent_required, name, service_accounts_enabled, 
            client_authenticator_type, root_url, description, registration_token, 
            standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, 
            always_display_in_console, created_timestamp, last_modified_timestamp
        ) VALUES (
            v_client_id, true, true, 'eniaclabs-frontend', 0, 
            true, null, '', false, '', 
            false, v_realm_id, 'openid-connect', -1, 
            false, false, 'ENIAC Labs Frontend', false, 
            'client-secret', '*', '', null, 
            true, false, true, 
            false, 1792737533276, 1792737533328
        );
    END IF;

    -- 4. Configurar redirect URIs
    DELETE FROM redirect_uris WHERE client_id = v_client_id;
    INSERT INTO redirect_uris (client_id, value) VALUES 
        (v_client_id, '*'),
        (v_client_id, 'https://eniaclabs-nine.vercel.app/*'),
        (v_client_id, 'http://localhost:4200/*');

    -- 5. Configurar web origins (CORS)
    DELETE FROM web_origins WHERE client_id = v_client_id;
    INSERT INTO web_origins (client_id, value) VALUES 
        (v_client_id, '*'),
        (v_client_id, '+'),
        (v_client_id, 'https://eniaclabs-nine.vercel.app'),
        (v_client_id, 'http://localhost:4200');

    -- 6. Asegurar usuario cliente1
    IF NOT EXISTS (SELECT 1 FROM user_entity WHERE realm_id = v_realm_id AND username = 'cliente1') THEN
        INSERT INTO user_entity (
            id, email, email_constraint, email_verified, enabled, 
            federation_link, first_name, last_name, realm_id, 
            username, created_timestamp, not_before, last_modified_timestamp
        ) VALUES (
            v_user_id, 'cliente1@eniaclabs.pe', 'cliente1@eniaclabs.pe', true, true, 
            null, 'Cliente', 'Uno', v_realm_id, 
            'cliente1', 1792737538842, 0, 1792737538842
        );
    ELSE
        SELECT id INTO v_user_id FROM user_entity WHERE realm_id = v_realm_id AND username = 'cliente1';
        UPDATE user_entity SET enabled = true, email_verified = true WHERE id = v_user_id;
    END IF;

    -- 7. Contraseña para cliente1 (cliente123 en hash Argon2)
    DELETE FROM credential WHERE user_id = v_user_id AND type = 'password';
    INSERT INTO credential (
        id, type, user_id, created_date, secret_data, credential_data, priority
    ) VALUES (
        '68b0be80-3dfe-4d09-8122-4299e12849da', 'password', v_user_id, 1792737538850,
        '{"value":"nTbM5ZiBd6dyfYmFLaid3iwwNY/V8XfR4JPCxWb2/lQ=","salt":"2nIolxbHHUS18e0FtT/KKQ==","additionalParameters":{}}',
        '{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}',
        10
    );

    -- 8. Asegurar rol CLIENTE
    SELECT id INTO v_role_id FROM keycloak_role WHERE realm_id = v_realm_id AND name = 'CLIENTE';
    IF v_role_id IS NULL THEN
        v_role_id := 'ec5ea76b-e37e-484e-b906-8af3ed3a7513';
        INSERT INTO keycloak_role (id, name, description, realm_id, client_role)
        VALUES (v_role_id, 'CLIENTE', 'Rol de Cliente Estándar', v_realm_id, false);
    END IF;

    DELETE FROM user_role_mapping WHERE user_id = v_user_id AND role_id = v_role_id;
    INSERT INTO user_role_mapping (role_id, user_id) VALUES (v_role_id, v_user_id);

    RAISE NOTICE 'Keycloak configurado con éxito para realm %, cliente %, usuario %', v_realm_id, v_client_id, v_user_id;
END $$;

