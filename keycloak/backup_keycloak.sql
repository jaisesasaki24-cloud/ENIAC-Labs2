--
-- PostgreSQL database dump
--

\restrict uWQih7VU2O07sH6e8fGgCj7dIn10AUzRg8hJK0uPqBfBui9MHz0LWKgwkudYIqT

-- Dumped from database version 17.11
-- Dumped by pg_dump version 17.11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64),
    details_json text
);


ALTER TABLE public.admin_event_entity OWNER TO eniaclabs_keycloak;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO eniaclabs_keycloak;

--
-- Name: auth_session; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.auth_session (
    root_auth_session_id character varying(36) NOT NULL,
    tab_id character varying(36) NOT NULL,
    client_uuid character varying(255),
    auth_user_id character varying(255),
    "timestamp" bigint,
    version integer,
    redirect_uri text,
    action character varying(255),
    protocol character varying(255),
    client_scopes text,
    execution_status text,
    client_notes text,
    auth_notes text,
    required_actions text,
    user_session_notes text
);


ALTER TABLE public.auth_session OWNER TO eniaclabs_keycloak;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO eniaclabs_keycloak;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO eniaclabs_keycloak;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO eniaclabs_keycloak;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO eniaclabs_keycloak;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO eniaclabs_keycloak;

--
-- Name: client; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL,
    created_timestamp bigint,
    last_modified_timestamp bigint
);


ALTER TABLE public.client OWNER TO eniaclabs_keycloak;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.client_attributes OWNER TO eniaclabs_keycloak;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO eniaclabs_keycloak;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO eniaclabs_keycloak;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO eniaclabs_keycloak;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO eniaclabs_keycloak;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO eniaclabs_keycloak;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO eniaclabs_keycloak;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO eniaclabs_keycloak;

--
-- Name: cluster_event; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.cluster_event (
    id character varying(36) NOT NULL,
    target_cluster character varying(200) NOT NULL,
    sender_cluster character varying(200) NOT NULL,
    event_data oid NOT NULL,
    created_at bigint NOT NULL
);


ALTER TABLE public.cluster_event OWNER TO eniaclabs_keycloak;

--
-- Name: component; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO eniaclabs_keycloak;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.component_config OWNER TO eniaclabs_keycloak;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO eniaclabs_keycloak;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer,
    version integer DEFAULT 0
);


ALTER TABLE public.credential OWNER TO eniaclabs_keycloak;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO eniaclabs_keycloak;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO eniaclabs_keycloak;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO eniaclabs_keycloak;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255),
    details_json_long_value text
);


ALTER TABLE public.event_entity OWNER TO eniaclabs_keycloak;

--
-- Name: fed_issued_ver_credential; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.fed_issued_ver_credential (
    id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36) NOT NULL,
    ver_credential_id character varying(36) NOT NULL,
    issued_at bigint NOT NULL,
    expires_at bigint,
    client_id character varying(36),
    revision character varying(36) NOT NULL
);


ALTER TABLE public.fed_issued_ver_credential OWNER TO eniaclabs_keycloak;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024),
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.fed_user_attribute OWNER TO eniaclabs_keycloak;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO eniaclabs_keycloak;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    parameter character varying(255) DEFAULT '#N A#'::character varying NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO eniaclabs_keycloak;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO eniaclabs_keycloak;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO eniaclabs_keycloak;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO eniaclabs_keycloak;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO eniaclabs_keycloak;

--
-- Name: fed_user_ver_credential; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.fed_user_ver_credential (
    id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    client_scope_id character varying(36) NOT NULL,
    revision character varying(36) NOT NULL,
    user_attributes text,
    created_date bigint,
    updated_date bigint,
    version integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.fed_user_ver_credential OWNER TO eniaclabs_keycloak;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO eniaclabs_keycloak;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO eniaclabs_keycloak;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO eniaclabs_keycloak;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO eniaclabs_keycloak;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean,
    authenticate_by_default boolean,
    realm_id character varying(36),
    add_token_role boolean,
    trust_email boolean,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean,
    hide_on_login boolean
);


ALTER TABLE public.identity_provider OWNER TO eniaclabs_keycloak;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO eniaclabs_keycloak;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO eniaclabs_keycloak;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO eniaclabs_keycloak;

--
-- Name: issued_ver_credential; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.issued_ver_credential (
    id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL,
    ver_credential_id character varying(36) NOT NULL,
    issued_at bigint NOT NULL,
    expires_at bigint,
    client_id character varying(36),
    revision character varying(36) NOT NULL
);


ALTER TABLE public.issued_ver_credential OWNER TO eniaclabs_keycloak;

--
-- Name: jgroups_ping; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.jgroups_ping (
    address character varying(200) NOT NULL,
    name character varying(200),
    cluster_name character varying(200) NOT NULL,
    ip character varying(200) NOT NULL,
    coord boolean,
    last_update bigint,
    coordinated_by character varying(200)
);


ALTER TABLE public.jgroups_ping OWNER TO eniaclabs_keycloak;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36),
    type integer DEFAULT 0 NOT NULL,
    description character varying(255),
    org_id character varying(255),
    created_timestamp bigint,
    last_modified_timestamp bigint
);


ALTER TABLE public.keycloak_group OWNER TO eniaclabs_keycloak;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO eniaclabs_keycloak;

--
-- Name: login_failure; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.login_failure (
    realm_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    failed_login_not_before bigint DEFAULT 0,
    num_failures integer DEFAULT 0,
    num_temporary_lockouts integer DEFAULT 0,
    last_failure bigint DEFAULT 0,
    last_ip_failure character varying(255),
    num_secondary_auth_failures integer DEFAULT 0
);


ALTER TABLE public.login_failure OWNER TO eniaclabs_keycloak;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO eniaclabs_keycloak;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL,
    version integer DEFAULT 0,
    realm_id character varying(36)
);


ALTER TABLE public.offline_client_session OWNER TO eniaclabs_keycloak;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL,
    broker_session_id character varying(1024),
    version integer DEFAULT 0,
    remember_me boolean,
    session_bucket smallint DEFAULT 0 NOT NULL,
    last_session_refresh_coarse bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.offline_user_session OWNER TO eniaclabs_keycloak;

--
-- Name: org; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.org (
    id character varying(255) NOT NULL,
    enabled boolean NOT NULL,
    realm_id character varying(255) NOT NULL,
    group_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    alias character varying(255) NOT NULL,
    redirect_url character varying(2048)
);


ALTER TABLE public.org OWNER TO eniaclabs_keycloak;

--
-- Name: org_domain; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.org_domain (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    verified boolean NOT NULL,
    org_id character varying(255) NOT NULL,
    realm_id character varying(255) NOT NULL,
    idp_id character varying(36),
    auto_redirect boolean DEFAULT false NOT NULL
);


ALTER TABLE public.org_domain OWNER TO eniaclabs_keycloak;

--
-- Name: org_identity_provider; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.org_identity_provider (
    organization_id character varying(255) NOT NULL,
    identity_provider_id character varying(36) NOT NULL,
    auto_membership boolean DEFAULT true NOT NULL,
    membership_type character varying(255) DEFAULT 'UNMANAGED'::character varying
);


ALTER TABLE public.org_identity_provider OWNER TO eniaclabs_keycloak;

--
-- Name: org_invitation; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.org_invitation (
    id character varying(36) NOT NULL,
    organization_id character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    created_at integer NOT NULL,
    expires_at integer,
    invite_link character varying(2048)
);


ALTER TABLE public.org_invitation OWNER TO eniaclabs_keycloak;

--
-- Name: outbox_entry; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.outbox_entry (
    id character varying(36) NOT NULL,
    entry_kind character varying(64) NOT NULL,
    realm_id character varying(36) NOT NULL,
    owner_id character varying(64) NOT NULL,
    container_id character varying(64),
    correlation_id character varying(255) NOT NULL,
    entry_type character varying(256) NOT NULL,
    payload text NOT NULL,
    metadata text,
    status character varying(16) NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    next_attempt_at timestamp without time zone NOT NULL,
    last_error character varying(2048),
    created_at timestamp without time zone NOT NULL,
    delivered_at timestamp without time zone
);


ALTER TABLE public.outbox_entry OWNER TO eniaclabs_keycloak;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO eniaclabs_keycloak;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO eniaclabs_keycloak;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO eniaclabs_keycloak;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255),
    display_name character varying(255)
);


ALTER TABLE public.realm OWNER TO eniaclabs_keycloak;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO eniaclabs_keycloak;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO eniaclabs_keycloak;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO eniaclabs_keycloak;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO eniaclabs_keycloak;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO eniaclabs_keycloak;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO eniaclabs_keycloak;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO eniaclabs_keycloak;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO eniaclabs_keycloak;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO eniaclabs_keycloak;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO eniaclabs_keycloak;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO eniaclabs_keycloak;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO eniaclabs_keycloak;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO eniaclabs_keycloak;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO eniaclabs_keycloak;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode smallint NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO eniaclabs_keycloak;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO eniaclabs_keycloak;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy smallint,
    logic smallint,
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO eniaclabs_keycloak;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO eniaclabs_keycloak;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO eniaclabs_keycloak;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO eniaclabs_keycloak;

--
-- Name: revoked_token; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.revoked_token (
    id character varying(255) NOT NULL,
    expire bigint NOT NULL
);


ALTER TABLE public.revoked_token OWNER TO eniaclabs_keycloak;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO eniaclabs_keycloak;

--
-- Name: root_auth_session; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.root_auth_session (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" bigint,
    version integer,
    session_bucket smallint DEFAULT 0 NOT NULL,
    created_on bigint DEFAULT 0 NOT NULL,
    timestamp_coarse bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.root_auth_session OWNER TO eniaclabs_keycloak;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO eniaclabs_keycloak;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO eniaclabs_keycloak;

--
-- Name: server_config; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.server_config (
    server_config_key character varying(255) NOT NULL,
    value text NOT NULL,
    version integer DEFAULT 0
);


ALTER TABLE public.server_config OWNER TO eniaclabs_keycloak;

--
-- Name: single_use_object; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.single_use_object (
    id character varying(255) NOT NULL,
    notes text,
    expire bigint NOT NULL
);


ALTER TABLE public.single_use_object OWNER TO eniaclabs_keycloak;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.user_attribute OWNER TO eniaclabs_keycloak;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO eniaclabs_keycloak;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    parameter character varying(255) DEFAULT '#N A#'::character varying NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO eniaclabs_keycloak;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL,
    last_modified_timestamp bigint
);


ALTER TABLE public.user_entity OWNER TO eniaclabs_keycloak;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO eniaclabs_keycloak;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO eniaclabs_keycloak;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO eniaclabs_keycloak;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO eniaclabs_keycloak;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL,
    membership_type character varying(255) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO eniaclabs_keycloak;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO eniaclabs_keycloak;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO eniaclabs_keycloak;

--
-- Name: user_ver_credential; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.user_ver_credential (
    id character varying(36) NOT NULL,
    client_scope_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL,
    revision character varying(36) NOT NULL,
    created_date bigint,
    updated_date bigint,
    user_attributes text,
    version integer
);


ALTER TABLE public.user_ver_credential OWNER TO eniaclabs_keycloak;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO eniaclabs_keycloak;

--
-- Name: workflow_state; Type: TABLE; Schema: public; Owner: eniaclabs_keycloak
--

CREATE TABLE public.workflow_state (
    execution_id character varying(255) NOT NULL,
    resource_id character varying(255) NOT NULL,
    workflow_id character varying(255) NOT NULL,
    resource_type character varying(255),
    scheduled_step_id character varying(255),
    scheduled_step_timestamp bigint
);


ALTER TABLE public.workflow_state OWNER TO eniaclabs_keycloak;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type, details_json) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: auth_session; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.auth_session (root_auth_session_id, tab_id, client_uuid, auth_user_id, "timestamp", version, redirect_uri, action, protocol, client_scopes, execution_status, client_notes, auth_notes, required_actions, user_session_notes) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
b43b1cc4-1288-4c4b-b486-b40fff3a1129	\N	auth-cookie	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	52d7de4a-288f-4227-add6-195247d301ae	2	10	f	\N	\N
bc4942a4-7781-434b-b88b-14fa80f03eb2	\N	auth-spnego	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	52d7de4a-288f-4227-add6-195247d301ae	3	20	f	\N	\N
fa80645c-f076-415f-93a2-3aba76d0cdb7	\N	identity-provider-redirector	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	52d7de4a-288f-4227-add6-195247d301ae	2	25	f	\N	\N
bb5a703f-e892-4dad-85ec-ad75dbb0b469	\N	\N	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	52d7de4a-288f-4227-add6-195247d301ae	2	30	t	d0a1e80b-23e2-4571-b74a-8eda0f56c01c	\N
f4aa91fd-1404-44a8-8dfa-38012bdd7b2c	\N	auth-username-password-form	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	d0a1e80b-23e2-4571-b74a-8eda0f56c01c	0	10	f	\N	\N
be362b34-df6c-46da-abc7-09a0d3f3f687	\N	\N	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	d0a1e80b-23e2-4571-b74a-8eda0f56c01c	1	20	t	298a2348-e1fa-4718-a17d-87b8f8e12f42	\N
a014c7df-1ac9-490e-8f44-1290d2dc07a4	\N	conditional-user-configured	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	298a2348-e1fa-4718-a17d-87b8f8e12f42	0	10	f	\N	\N
d2c58ab4-046a-4c6f-ab71-934318588c73	\N	conditional-credential	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	298a2348-e1fa-4718-a17d-87b8f8e12f42	0	20	f	\N	775c9305-7523-405c-808f-32daf7d102d5
c2be1ad1-83ba-427f-b7db-44220d1e22b6	\N	auth-otp-form	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	298a2348-e1fa-4718-a17d-87b8f8e12f42	2	30	f	\N	\N
a9ccf91f-2a22-4753-930d-2bd1eb6a4e5e	\N	webauthn-authenticator	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	298a2348-e1fa-4718-a17d-87b8f8e12f42	3	40	f	\N	\N
ed674394-7a5e-4419-b276-8a180fd6bfd3	\N	auth-recovery-authn-code-form	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	298a2348-e1fa-4718-a17d-87b8f8e12f42	3	50	f	\N	\N
bb49d286-8f54-4b88-8299-24b636021df8	\N	direct-grant-validate-username	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	09b816ea-122e-4457-bfce-daf26456660c	0	10	f	\N	\N
eee90849-6445-46a6-9ddf-aa2ac05bf823	\N	direct-grant-validate-password	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	09b816ea-122e-4457-bfce-daf26456660c	0	20	f	\N	\N
8600e3d2-06c2-4e76-ad85-1c2e797e4e75	\N	\N	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	09b816ea-122e-4457-bfce-daf26456660c	1	30	t	8d80250e-070e-45fd-a283-b4183d337c9d	\N
02ef6051-70cd-4e03-b922-ad97a21bbb42	\N	conditional-user-configured	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	8d80250e-070e-45fd-a283-b4183d337c9d	0	10	f	\N	\N
62b55f9c-d134-470c-998f-6f21e004c9c5	\N	direct-grant-validate-otp	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	8d80250e-070e-45fd-a283-b4183d337c9d	0	20	f	\N	\N
d60fd757-db23-4363-a9f6-684130dfcd14	\N	registration-page-form	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	f5108288-dc2b-4b3e-b71e-28fe19b85ee5	0	10	t	f4a162ab-7e4a-4a6d-a4a4-00366f679308	\N
605ee316-4b6c-4aca-b423-71d9c1d1d1ba	\N	registration-user-creation	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	f4a162ab-7e4a-4a6d-a4a4-00366f679308	0	20	f	\N	\N
b2ec54d2-fa6c-4211-9a0f-055997a4724a	\N	registration-password-action	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	f4a162ab-7e4a-4a6d-a4a4-00366f679308	0	50	f	\N	\N
a9b32fde-1bc5-4a5f-8e7a-1e75b0368e6b	\N	registration-recaptcha-action	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	f4a162ab-7e4a-4a6d-a4a4-00366f679308	3	60	f	\N	\N
4c141f55-f2c0-4a6d-b7cc-90658050f86c	\N	registration-terms-and-conditions	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	f4a162ab-7e4a-4a6d-a4a4-00366f679308	3	70	f	\N	\N
d9a86f1f-6f12-4ddd-add3-6ca55c718ae5	\N	reset-credentials-choose-user	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	97bedeaa-0569-48be-99f2-d4208f5f192b	0	10	f	\N	\N
702ab68d-becb-40c2-b67d-492e8fc2c6e8	\N	reset-credential-email	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	97bedeaa-0569-48be-99f2-d4208f5f192b	0	20	f	\N	\N
1bc1541b-4ad3-4e44-9a11-54bd96322d44	\N	reset-password	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	97bedeaa-0569-48be-99f2-d4208f5f192b	0	30	f	\N	\N
43f46c9a-4855-41f7-931d-221fad8a3b7b	\N	\N	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	97bedeaa-0569-48be-99f2-d4208f5f192b	1	40	t	e311735c-7335-4c17-afba-03ccfdb6d633	\N
cea93207-cac7-482a-88cb-6dccb0d0ae56	\N	conditional-user-configured	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	e311735c-7335-4c17-afba-03ccfdb6d633	0	10	f	\N	\N
d0ca115e-89b9-4ff9-a428-83b31986fce6	\N	reset-otp	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	e311735c-7335-4c17-afba-03ccfdb6d633	0	20	f	\N	\N
bbd69bc6-4df7-4193-8716-33a8a46a1332	\N	client-secret	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	2993cfc9-b16c-4a00-9466-15a3c366c827	2	10	f	\N	\N
0f6a4311-2272-4f9a-a038-0228390299c6	\N	client-jwt	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	2993cfc9-b16c-4a00-9466-15a3c366c827	2	20	f	\N	\N
0e775a69-ac0b-4a9c-8654-1ebfcbb50b31	\N	client-secret-jwt	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	2993cfc9-b16c-4a00-9466-15a3c366c827	2	30	f	\N	\N
9de85ae5-49c1-4fa9-a7da-00ee898c078a	\N	client-x509	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	2993cfc9-b16c-4a00-9466-15a3c366c827	2	40	f	\N	\N
eea7a22d-5fd6-4e18-b58b-977336b8a042	\N	federated-jwt	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	2993cfc9-b16c-4a00-9466-15a3c366c827	2	50	f	\N	\N
ee1a3022-b8d6-47d4-a673-dd01eb9507d5	\N	idp-review-profile	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	df69000b-52d8-4fd2-91df-b5e8f8720191	0	10	f	\N	8d6862b3-a87d-4ec2-a6d7-1013d82145e4
8dce4d22-00e0-4bb0-8149-942f68aa2404	\N	\N	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	df69000b-52d8-4fd2-91df-b5e8f8720191	0	20	t	5d55c538-b281-4550-a5b9-10e2f9e6eaaf	\N
48af8ccd-b116-403c-bf7d-4564b3c25e05	\N	idp-create-user-if-unique	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	5d55c538-b281-4550-a5b9-10e2f9e6eaaf	2	10	f	\N	0d403612-e202-445a-9d13-3f7bfe4ad972
be3373f0-22ce-487c-83f6-fc6eda3160fd	\N	\N	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	5d55c538-b281-4550-a5b9-10e2f9e6eaaf	2	20	t	21de7c94-7c8f-4629-a53e-7f7f07f65b6b	\N
977245bd-fd59-4eae-a165-99e2d421ec99	\N	idp-confirm-link	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	21de7c94-7c8f-4629-a53e-7f7f07f65b6b	0	10	f	\N	\N
0e2fb136-7e74-4245-ab21-b62c382b66a3	\N	\N	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	21de7c94-7c8f-4629-a53e-7f7f07f65b6b	0	20	t	b603d160-e0b2-49b7-b8bb-6f2ecc461855	\N
73b545aa-11bc-497d-893f-9a21b6cdaeef	\N	idp-email-verification	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	b603d160-e0b2-49b7-b8bb-6f2ecc461855	2	10	f	\N	\N
e39f1d64-c1fc-4dcb-b04e-b4b4df8c8c24	\N	\N	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	b603d160-e0b2-49b7-b8bb-6f2ecc461855	2	20	t	d51a0259-7f23-4d78-b7f9-31ffe202f784	\N
735458e4-c029-4344-92e0-e54002adfa90	\N	idp-username-password-form	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	d51a0259-7f23-4d78-b7f9-31ffe202f784	0	10	f	\N	\N
3c119a58-4a37-4766-9592-049f133fc54a	\N	\N	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	d51a0259-7f23-4d78-b7f9-31ffe202f784	1	20	t	5a0bcecd-89ef-4974-9095-bf50e0f327e7	\N
95836904-86c8-4006-a95c-1caf1d82429f	\N	conditional-user-configured	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	5a0bcecd-89ef-4974-9095-bf50e0f327e7	0	10	f	\N	\N
8751fa49-00f2-4aba-be1d-840ed0c0a05b	\N	conditional-credential	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	5a0bcecd-89ef-4974-9095-bf50e0f327e7	0	20	f	\N	12c5e506-fafa-447a-aed6-427ca58b3679
64611a28-8dac-4ce5-9bbe-45d0bb5ebf7e	\N	auth-otp-form	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	5a0bcecd-89ef-4974-9095-bf50e0f327e7	2	30	f	\N	\N
e1cabce3-0155-476d-8aa7-72b845ec1b01	\N	webauthn-authenticator	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	5a0bcecd-89ef-4974-9095-bf50e0f327e7	3	40	f	\N	\N
4ba15589-542e-4713-8335-5127c3588373	\N	auth-recovery-authn-code-form	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	5a0bcecd-89ef-4974-9095-bf50e0f327e7	3	50	f	\N	\N
4b2d5dc9-b74c-433b-ac78-01605a8dcb12	\N	http-basic-authenticator	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9ca0785c-bf44-4a5b-b877-24004c11c445	0	10	f	\N	\N
3ba87bb1-7e97-4b2e-b0f8-fde7a73fa165	\N	docker-http-basic-authenticator	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	04ec2a75-7275-4a0c-a5e5-c7f2f04f8f6b	0	10	f	\N	\N
2027d9e0-408f-4adf-9d56-b6fbb6c5a80e	\N	auth-cookie	16778b9e-50cb-4ccd-8250-1e80093e3d7e	a057c2b4-4743-4176-a830-8fbe1a2e8222	2	10	f	\N	\N
ad9f9141-de65-4e43-9d59-c471ae3d53b6	\N	auth-spnego	16778b9e-50cb-4ccd-8250-1e80093e3d7e	a057c2b4-4743-4176-a830-8fbe1a2e8222	3	20	f	\N	\N
d17a9528-d027-4825-b4c4-6528c2c2b1a6	\N	identity-provider-redirector	16778b9e-50cb-4ccd-8250-1e80093e3d7e	a057c2b4-4743-4176-a830-8fbe1a2e8222	2	25	f	\N	\N
180e58e5-6a11-4bdc-baca-253ae6768a94	\N	\N	16778b9e-50cb-4ccd-8250-1e80093e3d7e	a057c2b4-4743-4176-a830-8fbe1a2e8222	2	30	t	910f2680-98b7-49c4-9004-7cb1066f7f01	\N
212334eb-f7ad-4d20-b0f5-f3a59ae5106c	\N	auth-username-password-form	16778b9e-50cb-4ccd-8250-1e80093e3d7e	910f2680-98b7-49c4-9004-7cb1066f7f01	0	10	f	\N	\N
eb1ffb97-e805-40cf-b807-6dba4ebe7ef2	\N	\N	16778b9e-50cb-4ccd-8250-1e80093e3d7e	910f2680-98b7-49c4-9004-7cb1066f7f01	1	20	t	4ca51b19-a0e1-4dd8-bd8d-d8bf78cb6dc0	\N
ad437d55-c623-4e2e-971b-9a9d7c736562	\N	conditional-user-configured	16778b9e-50cb-4ccd-8250-1e80093e3d7e	4ca51b19-a0e1-4dd8-bd8d-d8bf78cb6dc0	0	10	f	\N	\N
d3ecf533-17a6-4f93-8f43-c00fc166e770	\N	conditional-credential	16778b9e-50cb-4ccd-8250-1e80093e3d7e	4ca51b19-a0e1-4dd8-bd8d-d8bf78cb6dc0	0	20	f	\N	5002b992-a9d2-47ad-84ee-2d25acca98e2
3d8ab37e-2d22-4a55-bda3-be89f49595c9	\N	auth-otp-form	16778b9e-50cb-4ccd-8250-1e80093e3d7e	4ca51b19-a0e1-4dd8-bd8d-d8bf78cb6dc0	2	30	f	\N	\N
9f7fbbb8-f89b-4732-a7c7-6576df8de967	\N	webauthn-authenticator	16778b9e-50cb-4ccd-8250-1e80093e3d7e	4ca51b19-a0e1-4dd8-bd8d-d8bf78cb6dc0	3	40	f	\N	\N
c52913f7-8fae-4bc6-a963-7f9817f30e2e	\N	auth-recovery-authn-code-form	16778b9e-50cb-4ccd-8250-1e80093e3d7e	4ca51b19-a0e1-4dd8-bd8d-d8bf78cb6dc0	3	50	f	\N	\N
c3bb97b2-f696-4ab0-94da-996be346b070	\N	\N	16778b9e-50cb-4ccd-8250-1e80093e3d7e	a057c2b4-4743-4176-a830-8fbe1a2e8222	2	26	t	e1865cf1-0fb0-4279-9a64-19fe09c01ff2	\N
a53f2d57-67db-49b8-a907-b59afc5d78c7	\N	\N	16778b9e-50cb-4ccd-8250-1e80093e3d7e	e1865cf1-0fb0-4279-9a64-19fe09c01ff2	1	10	t	ecfedc16-64ca-4fbc-8561-126335e1c177	\N
96bb3ee1-f731-4d9e-970a-cc8893d0f62b	\N	conditional-user-configured	16778b9e-50cb-4ccd-8250-1e80093e3d7e	ecfedc16-64ca-4fbc-8561-126335e1c177	0	10	f	\N	\N
feed7ad6-bb81-4cba-9aab-d74542724657	\N	organization	16778b9e-50cb-4ccd-8250-1e80093e3d7e	ecfedc16-64ca-4fbc-8561-126335e1c177	2	20	f	\N	\N
e25c86ea-c9af-4db5-a468-4b5324092888	\N	direct-grant-validate-username	16778b9e-50cb-4ccd-8250-1e80093e3d7e	3ddbe808-9ec6-4246-a242-f93511740a2e	0	10	f	\N	\N
6b73dae9-a29e-4134-bcf0-84d9c61ec17c	\N	direct-grant-validate-password	16778b9e-50cb-4ccd-8250-1e80093e3d7e	3ddbe808-9ec6-4246-a242-f93511740a2e	0	20	f	\N	\N
a7d01b76-5e7e-4272-b918-bd55ae0b0ad2	\N	\N	16778b9e-50cb-4ccd-8250-1e80093e3d7e	3ddbe808-9ec6-4246-a242-f93511740a2e	1	30	t	fa543c67-ced6-4a9e-9c86-bbb992b526a0	\N
901d96c2-9ee4-4712-8b9d-7321df3d678c	\N	conditional-user-configured	16778b9e-50cb-4ccd-8250-1e80093e3d7e	fa543c67-ced6-4a9e-9c86-bbb992b526a0	0	10	f	\N	\N
f1314395-103e-4d70-9bfb-89fb2c1b7082	\N	direct-grant-validate-otp	16778b9e-50cb-4ccd-8250-1e80093e3d7e	fa543c67-ced6-4a9e-9c86-bbb992b526a0	0	20	f	\N	\N
a45bab30-a88a-4a26-a01a-f47e943e9fed	\N	registration-page-form	16778b9e-50cb-4ccd-8250-1e80093e3d7e	9673faae-83c0-41e4-8dcb-9b01fa4b0e4c	0	10	t	177ae1e0-b269-45e3-89b9-2b84d9b33254	\N
201fd994-a163-42f1-b989-2b9a00980fc5	\N	registration-user-creation	16778b9e-50cb-4ccd-8250-1e80093e3d7e	177ae1e0-b269-45e3-89b9-2b84d9b33254	0	20	f	\N	\N
1831ad43-45b6-4574-bdf8-79d17c8d8476	\N	registration-password-action	16778b9e-50cb-4ccd-8250-1e80093e3d7e	177ae1e0-b269-45e3-89b9-2b84d9b33254	0	50	f	\N	\N
4ffea39f-0f6c-4bc4-85cf-2656c3b52dd8	\N	registration-recaptcha-action	16778b9e-50cb-4ccd-8250-1e80093e3d7e	177ae1e0-b269-45e3-89b9-2b84d9b33254	3	60	f	\N	\N
d5f03334-aac6-4f5a-93d7-05b1d6fc9113	\N	registration-terms-and-conditions	16778b9e-50cb-4ccd-8250-1e80093e3d7e	177ae1e0-b269-45e3-89b9-2b84d9b33254	3	70	f	\N	\N
cc5360d1-e96e-41e0-b1f2-254831716b6a	\N	reset-credentials-choose-user	16778b9e-50cb-4ccd-8250-1e80093e3d7e	900557ba-269b-4086-8e3a-e2c32896c600	0	10	f	\N	\N
c148d913-af5f-4921-97ff-677c67487018	\N	reset-credential-email	16778b9e-50cb-4ccd-8250-1e80093e3d7e	900557ba-269b-4086-8e3a-e2c32896c600	0	20	f	\N	\N
b3a30361-4acc-49ac-ae0b-c6fb3f027f0c	\N	reset-password	16778b9e-50cb-4ccd-8250-1e80093e3d7e	900557ba-269b-4086-8e3a-e2c32896c600	0	30	f	\N	\N
d1a1c8d6-3310-405c-86ac-b4e6ca5fbc2c	\N	\N	16778b9e-50cb-4ccd-8250-1e80093e3d7e	900557ba-269b-4086-8e3a-e2c32896c600	1	40	t	1d5af11c-a48e-4b33-89e2-2feba525b118	\N
ddd7ff3b-6566-4498-8788-a81e77112887	\N	conditional-user-configured	16778b9e-50cb-4ccd-8250-1e80093e3d7e	1d5af11c-a48e-4b33-89e2-2feba525b118	0	10	f	\N	\N
b0a12085-e36e-4dff-9d9d-3e5a945d1e29	\N	reset-otp	16778b9e-50cb-4ccd-8250-1e80093e3d7e	1d5af11c-a48e-4b33-89e2-2feba525b118	0	20	f	\N	\N
f2c583db-102e-4623-9fc0-7df967f13800	\N	client-secret	16778b9e-50cb-4ccd-8250-1e80093e3d7e	a407cd9d-2730-427c-a4b5-ebcbbd4e8861	2	10	f	\N	\N
0ffc9f13-9bf5-49a0-b1d8-99f041fa0d28	\N	client-jwt	16778b9e-50cb-4ccd-8250-1e80093e3d7e	a407cd9d-2730-427c-a4b5-ebcbbd4e8861	2	20	f	\N	\N
dd9ee286-a603-4d2c-b879-01b7953e126e	\N	client-secret-jwt	16778b9e-50cb-4ccd-8250-1e80093e3d7e	a407cd9d-2730-427c-a4b5-ebcbbd4e8861	2	30	f	\N	\N
a0629398-723b-4b44-8268-2baeb6e6e7f9	\N	client-x509	16778b9e-50cb-4ccd-8250-1e80093e3d7e	a407cd9d-2730-427c-a4b5-ebcbbd4e8861	2	40	f	\N	\N
45b15fee-db39-4368-88ce-b75f33d5537e	\N	federated-jwt	16778b9e-50cb-4ccd-8250-1e80093e3d7e	a407cd9d-2730-427c-a4b5-ebcbbd4e8861	2	50	f	\N	\N
3a6212a0-6618-4b34-be7b-ea9c0789ac65	\N	idp-review-profile	16778b9e-50cb-4ccd-8250-1e80093e3d7e	219e3f50-5306-4819-bc6b-78c9458037e8	0	10	f	\N	49d1774c-022d-4e12-90f0-0e33f6ce0608
4b766d58-fe6e-4b81-9369-6490bc426640	\N	\N	16778b9e-50cb-4ccd-8250-1e80093e3d7e	219e3f50-5306-4819-bc6b-78c9458037e8	0	20	t	41d12f5d-1464-451a-b638-bb0fdb76a05b	\N
11f1985f-fe52-4878-8fb5-912d663e290d	\N	idp-create-user-if-unique	16778b9e-50cb-4ccd-8250-1e80093e3d7e	41d12f5d-1464-451a-b638-bb0fdb76a05b	2	10	f	\N	c737b444-ec96-4d92-8b1b-d6ac4aa6e417
b4399056-281b-42e4-b7a0-3cc70bbe14b5	\N	\N	16778b9e-50cb-4ccd-8250-1e80093e3d7e	41d12f5d-1464-451a-b638-bb0fdb76a05b	2	20	t	79a9f1f2-134f-4a1c-a2ed-fc3b9e8b762a	\N
941c26b9-1943-4780-8f7a-73e2beaacdec	\N	idp-confirm-link	16778b9e-50cb-4ccd-8250-1e80093e3d7e	79a9f1f2-134f-4a1c-a2ed-fc3b9e8b762a	0	10	f	\N	\N
7bad3d60-5513-4829-9b3e-420190cf93ff	\N	\N	16778b9e-50cb-4ccd-8250-1e80093e3d7e	79a9f1f2-134f-4a1c-a2ed-fc3b9e8b762a	0	20	t	e78fb580-b264-466a-b117-f1a8714820ec	\N
476fb758-5b4b-4f19-b324-a6e17099088d	\N	idp-email-verification	16778b9e-50cb-4ccd-8250-1e80093e3d7e	e78fb580-b264-466a-b117-f1a8714820ec	2	10	f	\N	\N
2c64bc7d-424d-4b9f-809e-6df7b2a7b95a	\N	\N	16778b9e-50cb-4ccd-8250-1e80093e3d7e	e78fb580-b264-466a-b117-f1a8714820ec	2	20	t	c38c3c59-58c2-4a1a-8ed0-62d544225b55	\N
db674ca4-1b78-4ab9-a32a-4777274ac68c	\N	idp-username-password-form	16778b9e-50cb-4ccd-8250-1e80093e3d7e	c38c3c59-58c2-4a1a-8ed0-62d544225b55	0	10	f	\N	\N
c59c0143-d877-4098-83e9-53ba5ce0059a	\N	\N	16778b9e-50cb-4ccd-8250-1e80093e3d7e	c38c3c59-58c2-4a1a-8ed0-62d544225b55	1	20	t	e5a5cb7a-9ea5-49f5-ad0e-3e96be473fcf	\N
006d742f-eda5-4ac2-968e-e845dc0eb11a	\N	conditional-user-configured	16778b9e-50cb-4ccd-8250-1e80093e3d7e	e5a5cb7a-9ea5-49f5-ad0e-3e96be473fcf	0	10	f	\N	\N
0a6a2bb5-95b0-481f-8d9d-b539efaa9e62	\N	conditional-credential	16778b9e-50cb-4ccd-8250-1e80093e3d7e	e5a5cb7a-9ea5-49f5-ad0e-3e96be473fcf	0	20	f	\N	76d1f18c-cec5-4440-a411-cfe7604bc6e2
1f4587d6-0c74-4a15-91b5-a1156d899459	\N	auth-otp-form	16778b9e-50cb-4ccd-8250-1e80093e3d7e	e5a5cb7a-9ea5-49f5-ad0e-3e96be473fcf	2	30	f	\N	\N
a6b1dff3-9b33-425d-9a4b-96c6777c4f3f	\N	webauthn-authenticator	16778b9e-50cb-4ccd-8250-1e80093e3d7e	e5a5cb7a-9ea5-49f5-ad0e-3e96be473fcf	3	40	f	\N	\N
1cf4416d-2531-459e-81a3-45248b7c7341	\N	auth-recovery-authn-code-form	16778b9e-50cb-4ccd-8250-1e80093e3d7e	e5a5cb7a-9ea5-49f5-ad0e-3e96be473fcf	3	50	f	\N	\N
4ccded41-aefd-4251-992e-d5c52fca59fb	\N	\N	16778b9e-50cb-4ccd-8250-1e80093e3d7e	219e3f50-5306-4819-bc6b-78c9458037e8	1	60	t	8d9bc763-dd58-43e4-8aa4-285f6100b258	\N
009fd026-f247-4968-b7ae-423ba9b1a87b	\N	conditional-user-configured	16778b9e-50cb-4ccd-8250-1e80093e3d7e	8d9bc763-dd58-43e4-8aa4-285f6100b258	0	10	f	\N	\N
07488285-2647-417d-ab7c-9ab4a8155c67	\N	idp-add-organization-member	16778b9e-50cb-4ccd-8250-1e80093e3d7e	8d9bc763-dd58-43e4-8aa4-285f6100b258	0	20	f	\N	\N
f5c937d2-ac92-4863-9ac0-6d83118b291a	\N	http-basic-authenticator	16778b9e-50cb-4ccd-8250-1e80093e3d7e	874007df-f459-4b97-92c3-46ff35f25cb9	0	10	f	\N	\N
4af2070a-e156-4190-aa75-b5317b2002fd	\N	docker-http-basic-authenticator	16778b9e-50cb-4ccd-8250-1e80093e3d7e	4a2c6a64-8c25-43c5-9fb2-38e9b0947468	0	10	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
52d7de4a-288f-4227-add6-195247d301ae	browser	Browser based authentication	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	basic-flow	t	t
d0a1e80b-23e2-4571-b74a-8eda0f56c01c	forms	Username, password, otp and other auth forms.	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	basic-flow	f	t
298a2348-e1fa-4718-a17d-87b8f8e12f42	Browser - Conditional 2FA	Flow to determine if any 2FA is required for the authentication	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	basic-flow	f	t
09b816ea-122e-4457-bfce-daf26456660c	direct grant	OpenID Connect Resource Owner Grant	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	basic-flow	t	t
8d80250e-070e-45fd-a283-b4183d337c9d	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	basic-flow	f	t
f5108288-dc2b-4b3e-b71e-28fe19b85ee5	registration	Registration flow	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	basic-flow	t	t
f4a162ab-7e4a-4a6d-a4a4-00366f679308	registration form	Registration form	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	form-flow	f	t
97bedeaa-0569-48be-99f2-d4208f5f192b	reset credentials	Reset credentials for a user if they forgot their password or something	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	basic-flow	t	t
e311735c-7335-4c17-afba-03ccfdb6d633	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	basic-flow	f	t
2993cfc9-b16c-4a00-9466-15a3c366c827	clients	Base authentication for clients	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	client-flow	t	t
df69000b-52d8-4fd2-91df-b5e8f8720191	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	basic-flow	t	t
5d55c538-b281-4550-a5b9-10e2f9e6eaaf	User creation or linking	Flow for the existing/non-existing user alternatives	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	basic-flow	f	t
21de7c94-7c8f-4629-a53e-7f7f07f65b6b	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	basic-flow	f	t
b603d160-e0b2-49b7-b8bb-6f2ecc461855	Account verification options	Method with which to verify the existing account	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	basic-flow	f	t
d51a0259-7f23-4d78-b7f9-31ffe202f784	Verify Existing Account by Re-authentication	Reauthentication of existing account	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	basic-flow	f	t
5a0bcecd-89ef-4974-9095-bf50e0f327e7	First broker login - Conditional 2FA	Flow to determine if any 2FA is required for the authentication	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	basic-flow	f	t
9ca0785c-bf44-4a5b-b877-24004c11c445	saml ecp	SAML ECP Profile Authentication Flow	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	basic-flow	t	t
04ec2a75-7275-4a0c-a5e5-c7f2f04f8f6b	docker auth	Used by Docker clients to authenticate against the IDP	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	basic-flow	t	t
a057c2b4-4743-4176-a830-8fbe1a2e8222	browser	Browser based authentication	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	t	t
910f2680-98b7-49c4-9004-7cb1066f7f01	forms	Username, password, otp and other auth forms.	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	f	t
4ca51b19-a0e1-4dd8-bd8d-d8bf78cb6dc0	Browser - Conditional 2FA	Flow to determine if any 2FA is required for the authentication	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	f	t
e1865cf1-0fb0-4279-9a64-19fe09c01ff2	Organization	\N	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	f	t
ecfedc16-64ca-4fbc-8561-126335e1c177	Browser - Conditional Organization	Flow to determine if the organization identity-first login is to be used	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	f	t
3ddbe808-9ec6-4246-a242-f93511740a2e	direct grant	OpenID Connect Resource Owner Grant	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	t	t
fa543c67-ced6-4a9e-9c86-bbb992b526a0	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	f	t
9673faae-83c0-41e4-8dcb-9b01fa4b0e4c	registration	Registration flow	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	t	t
177ae1e0-b269-45e3-89b9-2b84d9b33254	registration form	Registration form	16778b9e-50cb-4ccd-8250-1e80093e3d7e	form-flow	f	t
900557ba-269b-4086-8e3a-e2c32896c600	reset credentials	Reset credentials for a user if they forgot their password or something	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	t	t
1d5af11c-a48e-4b33-89e2-2feba525b118	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	f	t
a407cd9d-2730-427c-a4b5-ebcbbd4e8861	clients	Base authentication for clients	16778b9e-50cb-4ccd-8250-1e80093e3d7e	client-flow	t	t
219e3f50-5306-4819-bc6b-78c9458037e8	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	t	t
41d12f5d-1464-451a-b638-bb0fdb76a05b	User creation or linking	Flow for the existing/non-existing user alternatives	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	f	t
79a9f1f2-134f-4a1c-a2ed-fc3b9e8b762a	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	f	t
e78fb580-b264-466a-b117-f1a8714820ec	Account verification options	Method with which to verify the existing account	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	f	t
c38c3c59-58c2-4a1a-8ed0-62d544225b55	Verify Existing Account by Re-authentication	Reauthentication of existing account	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	f	t
e5a5cb7a-9ea5-49f5-ad0e-3e96be473fcf	First broker login - Conditional 2FA	Flow to determine if any 2FA is required for the authentication	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	f	t
8d9bc763-dd58-43e4-8aa4-285f6100b258	First Broker Login - Conditional Organization	Flow to determine if the authenticator that adds organization members is to be used	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	f	t
874007df-f459-4b97-92c3-46ff35f25cb9	saml ecp	SAML ECP Profile Authentication Flow	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	t	t
4a2c6a64-8c25-43c5-9fb2-38e9b0947468	docker auth	Used by Docker clients to authenticate against the IDP	16778b9e-50cb-4ccd-8250-1e80093e3d7e	basic-flow	t	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
775c9305-7523-405c-808f-32daf7d102d5	browser-conditional-credential	e7107428-2e29-4f5c-b9b0-26341d6ad9ba
8d6862b3-a87d-4ec2-a6d7-1013d82145e4	review profile config	e7107428-2e29-4f5c-b9b0-26341d6ad9ba
0d403612-e202-445a-9d13-3f7bfe4ad972	create unique user config	e7107428-2e29-4f5c-b9b0-26341d6ad9ba
12c5e506-fafa-447a-aed6-427ca58b3679	first-broker-login-conditional-credential	e7107428-2e29-4f5c-b9b0-26341d6ad9ba
5002b992-a9d2-47ad-84ee-2d25acca98e2	browser-conditional-credential	16778b9e-50cb-4ccd-8250-1e80093e3d7e
49d1774c-022d-4e12-90f0-0e33f6ce0608	review profile config	16778b9e-50cb-4ccd-8250-1e80093e3d7e
c737b444-ec96-4d92-8b1b-d6ac4aa6e417	create unique user config	16778b9e-50cb-4ccd-8250-1e80093e3d7e
76d1f18c-cec5-4440-a411-cfe7604bc6e2	first-broker-login-conditional-credential	16778b9e-50cb-4ccd-8250-1e80093e3d7e
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
0d403612-e202-445a-9d13-3f7bfe4ad972	false	require.password.update.after.registration
12c5e506-fafa-447a-aed6-427ca58b3679	webauthn-passwordless	credentials
775c9305-7523-405c-808f-32daf7d102d5	webauthn-passwordless	credentials
8d6862b3-a87d-4ec2-a6d7-1013d82145e4	missing	update.profile.on.first.login
49d1774c-022d-4e12-90f0-0e33f6ce0608	missing	update.profile.on.first.login
5002b992-a9d2-47ad-84ee-2d25acca98e2	webauthn-passwordless	credentials
76d1f18c-cec5-4440-a411-cfe7604bc6e2	webauthn-passwordless	credentials
c737b444-ec96-4d92-8b1b-d6ac4aa6e417	false	require.password.update.after.registration
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console, created_timestamp, last_modified_timestamp) FROM stdin;
727bf2a1-6b03-4c06-88ff-5710a91cde68	t	f	master-realm	0	f	\N	\N	t	\N	f	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f	1792733483517	1792733483521
11c4e2f2-6350-491d-b968-ea462bbc2ffa	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f	1792733483635	1792733483655
546d4646-e2b4-4715-86bd-cf8e84405f59	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f	1792733483685	1792733483694
a230c0c1-1e6f-4198-8bd1-030f671a614c	t	f	broker	0	f	\N	\N	t	\N	f	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f	1792733483702	1792733483713
1fc3ed36-de0f-475c-a220-69e3cdc7bc16	t	t	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f	1792733483724	1792733483739
4115dc62-643a-433b-a63d-3b7d549317ed	t	t	admin-cli	0	t	\N	\N	f	\N	f	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f	1792733483751	1792733483760
9eac8266-847b-4518-a656-b3d4bbb3bab4	t	f	eniaclabs-realm	0	f	\N	\N	t	\N	f	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	\N	0	f	f	eniaclabs Realm	f	client-secret	\N	\N	\N	t	f	f	f	1792737515885	1792737515887
10b3e9b7-f507-438c-af2c-f4f03d586467	t	f	realm-management	0	f	\N	\N	t	\N	f	16778b9e-50cb-4ccd-8250-1e80093e3d7e	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f	1792737515948	1792737515954
7c82d307-0ab0-49b1-9cd4-fadd06207309	t	f	account	0	t	\N	/realms/eniaclabs/account/	f	\N	f	16778b9e-50cb-4ccd-8250-1e80093e3d7e	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f	1792737516003	1792737516008
72b2a634-cd62-465a-88c1-070cdfaad787	t	f	account-console	0	t	\N	/realms/eniaclabs/account/	f	\N	f	16778b9e-50cb-4ccd-8250-1e80093e3d7e	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f	1792737516024	1792737516028
d6cc51ad-d6d4-4c6e-a5c1-c3acf0c74f60	t	f	broker	0	f	\N	\N	t	\N	f	16778b9e-50cb-4ccd-8250-1e80093e3d7e	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f	1792737516047	1792737516052
839d8416-a602-45b7-a9d9-88bc3119aea9	t	t	security-admin-console	0	t	\N	/admin/eniaclabs/console/	f	\N	f	16778b9e-50cb-4ccd-8250-1e80093e3d7e	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f	1792737516055	1792737516058
2a974e15-a1e9-47fd-9b71-10317e85e83d	t	t	admin-cli	0	t	\N	\N	f	\N	f	16778b9e-50cb-4ccd-8250-1e80093e3d7e	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f	1792737516061	1792737516066
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	t	t	eniaclabs-frontend	0	t	\N	\N	f	\N	f	16778b9e-50cb-4ccd-8250-1e80093e3d7e	openid-connect	-1	f	f	\N	f	client-secret	http://localhost:4200	\N	\N	t	f	t	f	1792737533276	1792737533328
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
11c4e2f2-6350-491d-b968-ea462bbc2ffa	post.logout.redirect.uris	+
546d4646-e2b4-4715-86bd-cf8e84405f59	post.logout.redirect.uris	+
546d4646-e2b4-4715-86bd-cf8e84405f59	pkce.code.challenge.method	S256
1fc3ed36-de0f-475c-a220-69e3cdc7bc16	post.logout.redirect.uris	+
1fc3ed36-de0f-475c-a220-69e3cdc7bc16	pkce.code.challenge.method	S256
1fc3ed36-de0f-475c-a220-69e3cdc7bc16	client.use.lightweight.access.token.enabled	true
4115dc62-643a-433b-a63d-3b7d549317ed	client.use.lightweight.access.token.enabled	true
7c82d307-0ab0-49b1-9cd4-fadd06207309	post.logout.redirect.uris	+
72b2a634-cd62-465a-88c1-070cdfaad787	post.logout.redirect.uris	+
72b2a634-cd62-465a-88c1-070cdfaad787	pkce.code.challenge.method	S256
839d8416-a602-45b7-a9d9-88bc3119aea9	post.logout.redirect.uris	+
839d8416-a602-45b7-a9d9-88bc3119aea9	pkce.code.challenge.method	S256
839d8416-a602-45b7-a9d9-88bc3119aea9	client.use.lightweight.access.token.enabled	true
2a974e15-a1e9-47fd-9b71-10317e85e83d	client.use.lightweight.access.token.enabled	true
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	pkce.code.challenge.method	S256
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
be8c874d-687b-4c92-bac9-c29f8cfc3042	offline_access	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	OpenID Connect built-in scope: offline_access	openid-connect
94084437-d935-4ca8-ab96-d30dc2ad0c56	role_list	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	SAML role list	saml
f7bfccff-969b-439b-9b1e-9e7fd198070a	saml_organization	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	Organization Membership	saml
70986669-c00d-4402-bfec-8554cadf8515	AuthnContextClassRef	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	AuthnContextClassRef Level of Authentiation	saml
3d2eb408-6825-4160-ad57-d8f0e2ccc282	profile	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	OpenID Connect built-in scope: profile	openid-connect
91680d69-1643-468a-bcc8-fdb6364dbf97	email	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	OpenID Connect built-in scope: email	openid-connect
92533f6a-8a2f-4307-a327-fa5f7cfb77ab	address	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	OpenID Connect built-in scope: address	openid-connect
0ad81363-840d-428a-838a-5aa3268fc771	phone	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	OpenID Connect built-in scope: phone	openid-connect
670840e1-22ef-4dcf-adbe-5a1447ab5be0	roles	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	OpenID Connect scope for add user roles to the access token	openid-connect
130a3249-05e9-4f7b-85c8-c9943294127c	web-origins	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	OpenID Connect scope for add allowed web origins to the access token	openid-connect
1a1c76d6-e386-4741-9f47-fb30f07d22d2	microprofile-jwt	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	Microprofile - JWT built-in scope	openid-connect
96b931aa-efd9-46b1-bc6c-7813ba720f9e	acr	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
3d8a669f-ea17-4b17-8cfb-8a7e44366f14	basic	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	OpenID Connect scope for add all basic claims to the token	openid-connect
073702ac-9a2a-46bc-a915-dfe212937a56	service_account	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	Specific scope for a client enabled for service accounts	openid-connect
2fc9bb0a-cd40-42cf-b4e7-f3f5044a8d91	organization	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	Additional claims about the organization a subject belongs to	openid-connect
cd8b7110-93fb-4335-9353-43985411298b	offline_access	16778b9e-50cb-4ccd-8250-1e80093e3d7e	OpenID Connect built-in scope: offline_access	openid-connect
5e676abc-a591-44ff-8bb9-e99415958278	role_list	16778b9e-50cb-4ccd-8250-1e80093e3d7e	SAML role list	saml
f048dc00-bfed-4d5a-9a43-9e0ad34a80c9	saml_organization	16778b9e-50cb-4ccd-8250-1e80093e3d7e	Organization Membership	saml
f432d52c-e26b-404e-8bb6-389b5da67b2c	AuthnContextClassRef	16778b9e-50cb-4ccd-8250-1e80093e3d7e	AuthnContextClassRef Level of Authentiation	saml
786baf1e-8607-4c02-92c0-e913ec08349e	profile	16778b9e-50cb-4ccd-8250-1e80093e3d7e	OpenID Connect built-in scope: profile	openid-connect
b4275634-8c93-4041-a984-1c6b26e77c09	email	16778b9e-50cb-4ccd-8250-1e80093e3d7e	OpenID Connect built-in scope: email	openid-connect
3b1d4471-3c96-45fb-a878-ce3fa04a0a54	address	16778b9e-50cb-4ccd-8250-1e80093e3d7e	OpenID Connect built-in scope: address	openid-connect
d4d68849-77f1-42be-a68b-6774b05d357a	phone	16778b9e-50cb-4ccd-8250-1e80093e3d7e	OpenID Connect built-in scope: phone	openid-connect
50efe53c-e60a-4589-a095-d47ee4f83988	roles	16778b9e-50cb-4ccd-8250-1e80093e3d7e	OpenID Connect scope for add user roles to the access token	openid-connect
544c84aa-6d24-46ab-8178-01d878e901b6	web-origins	16778b9e-50cb-4ccd-8250-1e80093e3d7e	OpenID Connect scope for add allowed web origins to the access token	openid-connect
23f29c91-a04b-42d8-b780-27f3fcce5ec2	microprofile-jwt	16778b9e-50cb-4ccd-8250-1e80093e3d7e	Microprofile - JWT built-in scope	openid-connect
61eb6801-1490-4ee9-9706-0ed0d7dc7f16	acr	16778b9e-50cb-4ccd-8250-1e80093e3d7e	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
93486f6f-bad4-42e1-91e7-66be5a740110	basic	16778b9e-50cb-4ccd-8250-1e80093e3d7e	OpenID Connect scope for add all basic claims to the token	openid-connect
3eb3469f-74a5-402e-9cbc-f29cdd825c0c	service_account	16778b9e-50cb-4ccd-8250-1e80093e3d7e	Specific scope for a client enabled for service accounts	openid-connect
0a8747d0-1630-4e86-a1ef-caf9966f86f1	organization	16778b9e-50cb-4ccd-8250-1e80093e3d7e	Additional claims about the organization a subject belongs to	openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
be8c874d-687b-4c92-bac9-c29f8cfc3042	true	display.on.consent.screen
be8c874d-687b-4c92-bac9-c29f8cfc3042	${offlineAccessScopeConsentText}	consent.screen.text
94084437-d935-4ca8-ab96-d30dc2ad0c56	true	display.on.consent.screen
94084437-d935-4ca8-ab96-d30dc2ad0c56	${samlRoleListScopeConsentText}	consent.screen.text
f7bfccff-969b-439b-9b1e-9e7fd198070a	false	display.on.consent.screen
3d2eb408-6825-4160-ad57-d8f0e2ccc282	true	display.on.consent.screen
3d2eb408-6825-4160-ad57-d8f0e2ccc282	${profileScopeConsentText}	consent.screen.text
3d2eb408-6825-4160-ad57-d8f0e2ccc282	true	include.in.token.scope
91680d69-1643-468a-bcc8-fdb6364dbf97	true	display.on.consent.screen
91680d69-1643-468a-bcc8-fdb6364dbf97	${emailScopeConsentText}	consent.screen.text
91680d69-1643-468a-bcc8-fdb6364dbf97	true	include.in.token.scope
92533f6a-8a2f-4307-a327-fa5f7cfb77ab	true	display.on.consent.screen
92533f6a-8a2f-4307-a327-fa5f7cfb77ab	${addressScopeConsentText}	consent.screen.text
92533f6a-8a2f-4307-a327-fa5f7cfb77ab	true	include.in.token.scope
0ad81363-840d-428a-838a-5aa3268fc771	true	display.on.consent.screen
0ad81363-840d-428a-838a-5aa3268fc771	${phoneScopeConsentText}	consent.screen.text
0ad81363-840d-428a-838a-5aa3268fc771	true	include.in.token.scope
670840e1-22ef-4dcf-adbe-5a1447ab5be0	true	display.on.consent.screen
670840e1-22ef-4dcf-adbe-5a1447ab5be0	${rolesScopeConsentText}	consent.screen.text
670840e1-22ef-4dcf-adbe-5a1447ab5be0	false	include.in.token.scope
130a3249-05e9-4f7b-85c8-c9943294127c	false	display.on.consent.screen
130a3249-05e9-4f7b-85c8-c9943294127c	false	include.in.token.scope
1a1c76d6-e386-4741-9f47-fb30f07d22d2	false	display.on.consent.screen
1a1c76d6-e386-4741-9f47-fb30f07d22d2	true	include.in.token.scope
96b931aa-efd9-46b1-bc6c-7813ba720f9e	false	display.on.consent.screen
96b931aa-efd9-46b1-bc6c-7813ba720f9e	false	include.in.token.scope
3d8a669f-ea17-4b17-8cfb-8a7e44366f14	false	display.on.consent.screen
3d8a669f-ea17-4b17-8cfb-8a7e44366f14	false	include.in.token.scope
073702ac-9a2a-46bc-a915-dfe212937a56	false	display.on.consent.screen
073702ac-9a2a-46bc-a915-dfe212937a56	false	include.in.token.scope
2fc9bb0a-cd40-42cf-b4e7-f3f5044a8d91	true	display.on.consent.screen
2fc9bb0a-cd40-42cf-b4e7-f3f5044a8d91	${organizationScopeConsentText}	consent.screen.text
2fc9bb0a-cd40-42cf-b4e7-f3f5044a8d91	true	include.in.token.scope
cd8b7110-93fb-4335-9353-43985411298b	true	display.on.consent.screen
cd8b7110-93fb-4335-9353-43985411298b	${offlineAccessScopeConsentText}	consent.screen.text
5e676abc-a591-44ff-8bb9-e99415958278	true	display.on.consent.screen
5e676abc-a591-44ff-8bb9-e99415958278	${samlRoleListScopeConsentText}	consent.screen.text
f048dc00-bfed-4d5a-9a43-9e0ad34a80c9	false	display.on.consent.screen
786baf1e-8607-4c02-92c0-e913ec08349e	true	display.on.consent.screen
786baf1e-8607-4c02-92c0-e913ec08349e	${profileScopeConsentText}	consent.screen.text
786baf1e-8607-4c02-92c0-e913ec08349e	true	include.in.token.scope
b4275634-8c93-4041-a984-1c6b26e77c09	true	display.on.consent.screen
b4275634-8c93-4041-a984-1c6b26e77c09	${emailScopeConsentText}	consent.screen.text
b4275634-8c93-4041-a984-1c6b26e77c09	true	include.in.token.scope
3b1d4471-3c96-45fb-a878-ce3fa04a0a54	true	display.on.consent.screen
3b1d4471-3c96-45fb-a878-ce3fa04a0a54	${addressScopeConsentText}	consent.screen.text
3b1d4471-3c96-45fb-a878-ce3fa04a0a54	true	include.in.token.scope
d4d68849-77f1-42be-a68b-6774b05d357a	true	display.on.consent.screen
d4d68849-77f1-42be-a68b-6774b05d357a	${phoneScopeConsentText}	consent.screen.text
d4d68849-77f1-42be-a68b-6774b05d357a	true	include.in.token.scope
50efe53c-e60a-4589-a095-d47ee4f83988	true	display.on.consent.screen
50efe53c-e60a-4589-a095-d47ee4f83988	${rolesScopeConsentText}	consent.screen.text
50efe53c-e60a-4589-a095-d47ee4f83988	false	include.in.token.scope
544c84aa-6d24-46ab-8178-01d878e901b6	false	display.on.consent.screen
544c84aa-6d24-46ab-8178-01d878e901b6	false	include.in.token.scope
23f29c91-a04b-42d8-b780-27f3fcce5ec2	false	display.on.consent.screen
23f29c91-a04b-42d8-b780-27f3fcce5ec2	true	include.in.token.scope
61eb6801-1490-4ee9-9706-0ed0d7dc7f16	false	display.on.consent.screen
61eb6801-1490-4ee9-9706-0ed0d7dc7f16	false	include.in.token.scope
93486f6f-bad4-42e1-91e7-66be5a740110	false	display.on.consent.screen
93486f6f-bad4-42e1-91e7-66be5a740110	false	include.in.token.scope
3eb3469f-74a5-402e-9cbc-f29cdd825c0c	false	display.on.consent.screen
3eb3469f-74a5-402e-9cbc-f29cdd825c0c	false	include.in.token.scope
0a8747d0-1630-4e86-a1ef-caf9966f86f1	true	display.on.consent.screen
0a8747d0-1630-4e86-a1ef-caf9966f86f1	${organizationScopeConsentText}	consent.screen.text
0a8747d0-1630-4e86-a1ef-caf9966f86f1	true	include.in.token.scope
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
11c4e2f2-6350-491d-b968-ea462bbc2ffa	670840e1-22ef-4dcf-adbe-5a1447ab5be0	t
11c4e2f2-6350-491d-b968-ea462bbc2ffa	3d2eb408-6825-4160-ad57-d8f0e2ccc282	t
11c4e2f2-6350-491d-b968-ea462bbc2ffa	96b931aa-efd9-46b1-bc6c-7813ba720f9e	t
11c4e2f2-6350-491d-b968-ea462bbc2ffa	130a3249-05e9-4f7b-85c8-c9943294127c	t
11c4e2f2-6350-491d-b968-ea462bbc2ffa	3d8a669f-ea17-4b17-8cfb-8a7e44366f14	t
11c4e2f2-6350-491d-b968-ea462bbc2ffa	91680d69-1643-468a-bcc8-fdb6364dbf97	t
11c4e2f2-6350-491d-b968-ea462bbc2ffa	92533f6a-8a2f-4307-a327-fa5f7cfb77ab	f
11c4e2f2-6350-491d-b968-ea462bbc2ffa	2fc9bb0a-cd40-42cf-b4e7-f3f5044a8d91	f
11c4e2f2-6350-491d-b968-ea462bbc2ffa	0ad81363-840d-428a-838a-5aa3268fc771	f
11c4e2f2-6350-491d-b968-ea462bbc2ffa	be8c874d-687b-4c92-bac9-c29f8cfc3042	f
11c4e2f2-6350-491d-b968-ea462bbc2ffa	1a1c76d6-e386-4741-9f47-fb30f07d22d2	f
546d4646-e2b4-4715-86bd-cf8e84405f59	670840e1-22ef-4dcf-adbe-5a1447ab5be0	t
546d4646-e2b4-4715-86bd-cf8e84405f59	3d2eb408-6825-4160-ad57-d8f0e2ccc282	t
546d4646-e2b4-4715-86bd-cf8e84405f59	96b931aa-efd9-46b1-bc6c-7813ba720f9e	t
546d4646-e2b4-4715-86bd-cf8e84405f59	130a3249-05e9-4f7b-85c8-c9943294127c	t
546d4646-e2b4-4715-86bd-cf8e84405f59	3d8a669f-ea17-4b17-8cfb-8a7e44366f14	t
546d4646-e2b4-4715-86bd-cf8e84405f59	91680d69-1643-468a-bcc8-fdb6364dbf97	t
546d4646-e2b4-4715-86bd-cf8e84405f59	92533f6a-8a2f-4307-a327-fa5f7cfb77ab	f
546d4646-e2b4-4715-86bd-cf8e84405f59	2fc9bb0a-cd40-42cf-b4e7-f3f5044a8d91	f
546d4646-e2b4-4715-86bd-cf8e84405f59	0ad81363-840d-428a-838a-5aa3268fc771	f
546d4646-e2b4-4715-86bd-cf8e84405f59	be8c874d-687b-4c92-bac9-c29f8cfc3042	f
546d4646-e2b4-4715-86bd-cf8e84405f59	1a1c76d6-e386-4741-9f47-fb30f07d22d2	f
4115dc62-643a-433b-a63d-3b7d549317ed	670840e1-22ef-4dcf-adbe-5a1447ab5be0	t
4115dc62-643a-433b-a63d-3b7d549317ed	3d2eb408-6825-4160-ad57-d8f0e2ccc282	t
4115dc62-643a-433b-a63d-3b7d549317ed	96b931aa-efd9-46b1-bc6c-7813ba720f9e	t
4115dc62-643a-433b-a63d-3b7d549317ed	130a3249-05e9-4f7b-85c8-c9943294127c	t
4115dc62-643a-433b-a63d-3b7d549317ed	3d8a669f-ea17-4b17-8cfb-8a7e44366f14	t
4115dc62-643a-433b-a63d-3b7d549317ed	91680d69-1643-468a-bcc8-fdb6364dbf97	t
4115dc62-643a-433b-a63d-3b7d549317ed	92533f6a-8a2f-4307-a327-fa5f7cfb77ab	f
4115dc62-643a-433b-a63d-3b7d549317ed	2fc9bb0a-cd40-42cf-b4e7-f3f5044a8d91	f
4115dc62-643a-433b-a63d-3b7d549317ed	0ad81363-840d-428a-838a-5aa3268fc771	f
4115dc62-643a-433b-a63d-3b7d549317ed	be8c874d-687b-4c92-bac9-c29f8cfc3042	f
4115dc62-643a-433b-a63d-3b7d549317ed	1a1c76d6-e386-4741-9f47-fb30f07d22d2	f
a230c0c1-1e6f-4198-8bd1-030f671a614c	670840e1-22ef-4dcf-adbe-5a1447ab5be0	t
a230c0c1-1e6f-4198-8bd1-030f671a614c	3d2eb408-6825-4160-ad57-d8f0e2ccc282	t
a230c0c1-1e6f-4198-8bd1-030f671a614c	96b931aa-efd9-46b1-bc6c-7813ba720f9e	t
a230c0c1-1e6f-4198-8bd1-030f671a614c	130a3249-05e9-4f7b-85c8-c9943294127c	t
a230c0c1-1e6f-4198-8bd1-030f671a614c	3d8a669f-ea17-4b17-8cfb-8a7e44366f14	t
a230c0c1-1e6f-4198-8bd1-030f671a614c	91680d69-1643-468a-bcc8-fdb6364dbf97	t
a230c0c1-1e6f-4198-8bd1-030f671a614c	92533f6a-8a2f-4307-a327-fa5f7cfb77ab	f
a230c0c1-1e6f-4198-8bd1-030f671a614c	2fc9bb0a-cd40-42cf-b4e7-f3f5044a8d91	f
a230c0c1-1e6f-4198-8bd1-030f671a614c	0ad81363-840d-428a-838a-5aa3268fc771	f
a230c0c1-1e6f-4198-8bd1-030f671a614c	be8c874d-687b-4c92-bac9-c29f8cfc3042	f
a230c0c1-1e6f-4198-8bd1-030f671a614c	1a1c76d6-e386-4741-9f47-fb30f07d22d2	f
727bf2a1-6b03-4c06-88ff-5710a91cde68	670840e1-22ef-4dcf-adbe-5a1447ab5be0	t
727bf2a1-6b03-4c06-88ff-5710a91cde68	3d2eb408-6825-4160-ad57-d8f0e2ccc282	t
727bf2a1-6b03-4c06-88ff-5710a91cde68	96b931aa-efd9-46b1-bc6c-7813ba720f9e	t
727bf2a1-6b03-4c06-88ff-5710a91cde68	130a3249-05e9-4f7b-85c8-c9943294127c	t
727bf2a1-6b03-4c06-88ff-5710a91cde68	3d8a669f-ea17-4b17-8cfb-8a7e44366f14	t
727bf2a1-6b03-4c06-88ff-5710a91cde68	91680d69-1643-468a-bcc8-fdb6364dbf97	t
727bf2a1-6b03-4c06-88ff-5710a91cde68	92533f6a-8a2f-4307-a327-fa5f7cfb77ab	f
727bf2a1-6b03-4c06-88ff-5710a91cde68	2fc9bb0a-cd40-42cf-b4e7-f3f5044a8d91	f
727bf2a1-6b03-4c06-88ff-5710a91cde68	0ad81363-840d-428a-838a-5aa3268fc771	f
727bf2a1-6b03-4c06-88ff-5710a91cde68	be8c874d-687b-4c92-bac9-c29f8cfc3042	f
727bf2a1-6b03-4c06-88ff-5710a91cde68	1a1c76d6-e386-4741-9f47-fb30f07d22d2	f
1fc3ed36-de0f-475c-a220-69e3cdc7bc16	670840e1-22ef-4dcf-adbe-5a1447ab5be0	t
1fc3ed36-de0f-475c-a220-69e3cdc7bc16	3d2eb408-6825-4160-ad57-d8f0e2ccc282	t
1fc3ed36-de0f-475c-a220-69e3cdc7bc16	96b931aa-efd9-46b1-bc6c-7813ba720f9e	t
1fc3ed36-de0f-475c-a220-69e3cdc7bc16	130a3249-05e9-4f7b-85c8-c9943294127c	t
1fc3ed36-de0f-475c-a220-69e3cdc7bc16	3d8a669f-ea17-4b17-8cfb-8a7e44366f14	t
1fc3ed36-de0f-475c-a220-69e3cdc7bc16	91680d69-1643-468a-bcc8-fdb6364dbf97	t
1fc3ed36-de0f-475c-a220-69e3cdc7bc16	92533f6a-8a2f-4307-a327-fa5f7cfb77ab	f
1fc3ed36-de0f-475c-a220-69e3cdc7bc16	2fc9bb0a-cd40-42cf-b4e7-f3f5044a8d91	f
1fc3ed36-de0f-475c-a220-69e3cdc7bc16	0ad81363-840d-428a-838a-5aa3268fc771	f
1fc3ed36-de0f-475c-a220-69e3cdc7bc16	be8c874d-687b-4c92-bac9-c29f8cfc3042	f
1fc3ed36-de0f-475c-a220-69e3cdc7bc16	1a1c76d6-e386-4741-9f47-fb30f07d22d2	f
7c82d307-0ab0-49b1-9cd4-fadd06207309	786baf1e-8607-4c02-92c0-e913ec08349e	t
7c82d307-0ab0-49b1-9cd4-fadd06207309	50efe53c-e60a-4589-a095-d47ee4f83988	t
7c82d307-0ab0-49b1-9cd4-fadd06207309	61eb6801-1490-4ee9-9706-0ed0d7dc7f16	t
7c82d307-0ab0-49b1-9cd4-fadd06207309	93486f6f-bad4-42e1-91e7-66be5a740110	t
7c82d307-0ab0-49b1-9cd4-fadd06207309	b4275634-8c93-4041-a984-1c6b26e77c09	t
7c82d307-0ab0-49b1-9cd4-fadd06207309	544c84aa-6d24-46ab-8178-01d878e901b6	t
7c82d307-0ab0-49b1-9cd4-fadd06207309	3b1d4471-3c96-45fb-a878-ce3fa04a0a54	f
7c82d307-0ab0-49b1-9cd4-fadd06207309	23f29c91-a04b-42d8-b780-27f3fcce5ec2	f
7c82d307-0ab0-49b1-9cd4-fadd06207309	cd8b7110-93fb-4335-9353-43985411298b	f
7c82d307-0ab0-49b1-9cd4-fadd06207309	d4d68849-77f1-42be-a68b-6774b05d357a	f
7c82d307-0ab0-49b1-9cd4-fadd06207309	0a8747d0-1630-4e86-a1ef-caf9966f86f1	f
72b2a634-cd62-465a-88c1-070cdfaad787	786baf1e-8607-4c02-92c0-e913ec08349e	t
72b2a634-cd62-465a-88c1-070cdfaad787	50efe53c-e60a-4589-a095-d47ee4f83988	t
72b2a634-cd62-465a-88c1-070cdfaad787	61eb6801-1490-4ee9-9706-0ed0d7dc7f16	t
72b2a634-cd62-465a-88c1-070cdfaad787	93486f6f-bad4-42e1-91e7-66be5a740110	t
72b2a634-cd62-465a-88c1-070cdfaad787	b4275634-8c93-4041-a984-1c6b26e77c09	t
72b2a634-cd62-465a-88c1-070cdfaad787	544c84aa-6d24-46ab-8178-01d878e901b6	t
72b2a634-cd62-465a-88c1-070cdfaad787	3b1d4471-3c96-45fb-a878-ce3fa04a0a54	f
72b2a634-cd62-465a-88c1-070cdfaad787	23f29c91-a04b-42d8-b780-27f3fcce5ec2	f
72b2a634-cd62-465a-88c1-070cdfaad787	cd8b7110-93fb-4335-9353-43985411298b	f
72b2a634-cd62-465a-88c1-070cdfaad787	d4d68849-77f1-42be-a68b-6774b05d357a	f
72b2a634-cd62-465a-88c1-070cdfaad787	0a8747d0-1630-4e86-a1ef-caf9966f86f1	f
2a974e15-a1e9-47fd-9b71-10317e85e83d	786baf1e-8607-4c02-92c0-e913ec08349e	t
2a974e15-a1e9-47fd-9b71-10317e85e83d	50efe53c-e60a-4589-a095-d47ee4f83988	t
2a974e15-a1e9-47fd-9b71-10317e85e83d	61eb6801-1490-4ee9-9706-0ed0d7dc7f16	t
2a974e15-a1e9-47fd-9b71-10317e85e83d	93486f6f-bad4-42e1-91e7-66be5a740110	t
2a974e15-a1e9-47fd-9b71-10317e85e83d	b4275634-8c93-4041-a984-1c6b26e77c09	t
2a974e15-a1e9-47fd-9b71-10317e85e83d	544c84aa-6d24-46ab-8178-01d878e901b6	t
2a974e15-a1e9-47fd-9b71-10317e85e83d	3b1d4471-3c96-45fb-a878-ce3fa04a0a54	f
2a974e15-a1e9-47fd-9b71-10317e85e83d	23f29c91-a04b-42d8-b780-27f3fcce5ec2	f
2a974e15-a1e9-47fd-9b71-10317e85e83d	cd8b7110-93fb-4335-9353-43985411298b	f
2a974e15-a1e9-47fd-9b71-10317e85e83d	d4d68849-77f1-42be-a68b-6774b05d357a	f
2a974e15-a1e9-47fd-9b71-10317e85e83d	0a8747d0-1630-4e86-a1ef-caf9966f86f1	f
d6cc51ad-d6d4-4c6e-a5c1-c3acf0c74f60	786baf1e-8607-4c02-92c0-e913ec08349e	t
d6cc51ad-d6d4-4c6e-a5c1-c3acf0c74f60	50efe53c-e60a-4589-a095-d47ee4f83988	t
d6cc51ad-d6d4-4c6e-a5c1-c3acf0c74f60	61eb6801-1490-4ee9-9706-0ed0d7dc7f16	t
d6cc51ad-d6d4-4c6e-a5c1-c3acf0c74f60	93486f6f-bad4-42e1-91e7-66be5a740110	t
d6cc51ad-d6d4-4c6e-a5c1-c3acf0c74f60	b4275634-8c93-4041-a984-1c6b26e77c09	t
d6cc51ad-d6d4-4c6e-a5c1-c3acf0c74f60	544c84aa-6d24-46ab-8178-01d878e901b6	t
d6cc51ad-d6d4-4c6e-a5c1-c3acf0c74f60	3b1d4471-3c96-45fb-a878-ce3fa04a0a54	f
d6cc51ad-d6d4-4c6e-a5c1-c3acf0c74f60	23f29c91-a04b-42d8-b780-27f3fcce5ec2	f
d6cc51ad-d6d4-4c6e-a5c1-c3acf0c74f60	cd8b7110-93fb-4335-9353-43985411298b	f
d6cc51ad-d6d4-4c6e-a5c1-c3acf0c74f60	d4d68849-77f1-42be-a68b-6774b05d357a	f
d6cc51ad-d6d4-4c6e-a5c1-c3acf0c74f60	0a8747d0-1630-4e86-a1ef-caf9966f86f1	f
10b3e9b7-f507-438c-af2c-f4f03d586467	786baf1e-8607-4c02-92c0-e913ec08349e	t
10b3e9b7-f507-438c-af2c-f4f03d586467	50efe53c-e60a-4589-a095-d47ee4f83988	t
10b3e9b7-f507-438c-af2c-f4f03d586467	61eb6801-1490-4ee9-9706-0ed0d7dc7f16	t
10b3e9b7-f507-438c-af2c-f4f03d586467	93486f6f-bad4-42e1-91e7-66be5a740110	t
10b3e9b7-f507-438c-af2c-f4f03d586467	b4275634-8c93-4041-a984-1c6b26e77c09	t
10b3e9b7-f507-438c-af2c-f4f03d586467	544c84aa-6d24-46ab-8178-01d878e901b6	t
10b3e9b7-f507-438c-af2c-f4f03d586467	3b1d4471-3c96-45fb-a878-ce3fa04a0a54	f
10b3e9b7-f507-438c-af2c-f4f03d586467	23f29c91-a04b-42d8-b780-27f3fcce5ec2	f
10b3e9b7-f507-438c-af2c-f4f03d586467	cd8b7110-93fb-4335-9353-43985411298b	f
10b3e9b7-f507-438c-af2c-f4f03d586467	d4d68849-77f1-42be-a68b-6774b05d357a	f
10b3e9b7-f507-438c-af2c-f4f03d586467	0a8747d0-1630-4e86-a1ef-caf9966f86f1	f
839d8416-a602-45b7-a9d9-88bc3119aea9	786baf1e-8607-4c02-92c0-e913ec08349e	t
839d8416-a602-45b7-a9d9-88bc3119aea9	50efe53c-e60a-4589-a095-d47ee4f83988	t
839d8416-a602-45b7-a9d9-88bc3119aea9	61eb6801-1490-4ee9-9706-0ed0d7dc7f16	t
839d8416-a602-45b7-a9d9-88bc3119aea9	93486f6f-bad4-42e1-91e7-66be5a740110	t
839d8416-a602-45b7-a9d9-88bc3119aea9	b4275634-8c93-4041-a984-1c6b26e77c09	t
839d8416-a602-45b7-a9d9-88bc3119aea9	544c84aa-6d24-46ab-8178-01d878e901b6	t
839d8416-a602-45b7-a9d9-88bc3119aea9	3b1d4471-3c96-45fb-a878-ce3fa04a0a54	f
839d8416-a602-45b7-a9d9-88bc3119aea9	23f29c91-a04b-42d8-b780-27f3fcce5ec2	f
839d8416-a602-45b7-a9d9-88bc3119aea9	cd8b7110-93fb-4335-9353-43985411298b	f
839d8416-a602-45b7-a9d9-88bc3119aea9	d4d68849-77f1-42be-a68b-6774b05d357a	f
839d8416-a602-45b7-a9d9-88bc3119aea9	0a8747d0-1630-4e86-a1ef-caf9966f86f1	f
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	786baf1e-8607-4c02-92c0-e913ec08349e	t
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	50efe53c-e60a-4589-a095-d47ee4f83988	t
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	61eb6801-1490-4ee9-9706-0ed0d7dc7f16	t
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	93486f6f-bad4-42e1-91e7-66be5a740110	t
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	b4275634-8c93-4041-a984-1c6b26e77c09	t
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	544c84aa-6d24-46ab-8178-01d878e901b6	t
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	3b1d4471-3c96-45fb-a878-ce3fa04a0a54	f
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	23f29c91-a04b-42d8-b780-27f3fcce5ec2	f
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	cd8b7110-93fb-4335-9353-43985411298b	f
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	d4d68849-77f1-42be-a68b-6774b05d357a	f
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	0a8747d0-1630-4e86-a1ef-caf9966f86f1	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
be8c874d-687b-4c92-bac9-c29f8cfc3042	26576a80-1f8b-4e4a-9395-5fc77bc6acb3
cd8b7110-93fb-4335-9353-43985411298b	48258be2-c7bc-45cc-89d6-66244d5cec66
\.


--
-- Data for Name: cluster_event; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.cluster_event (id, target_cluster, sender_cluster, event_data, created_at) FROM stdin;
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
e214711a-67c8-44d0-81da-87d42ecfe2e8	Trusted Hosts	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	anonymous
615e993b-6e62-46a1-9cbf-850db408b73d	Consent Required	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	anonymous
321eddad-d38f-4be3-96e5-10b03071a372	Full Scope Disabled	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	anonymous
d22e4d35-d0e1-49e0-b07b-bf4a0db16691	Max Clients Limit	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	anonymous
e2e952e3-8702-4b0d-8bd4-ef70402c9bdf	Allowed Protocol Mapper Types	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	anonymous
dbaea7b2-cb73-4a6c-840c-7de06f05688b	Allowed Client Scopes	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	anonymous
a8526aa9-6d67-4e29-8e2a-75b01b0d89dc	Allowed Registration Web Origins	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	registration-web-origins	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	anonymous
c2407cb0-a31b-485c-bd68-3fcb3ffe38be	Allowed Protocol Mapper Types	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	authenticated
821c1a30-1f45-4d80-9f5f-d2d8b2ffdf95	Allowed Client Scopes	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	authenticated
e8632027-0294-4ec1-9539-b48b193125a2	Allowed Registration Web Origins	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	registration-web-origins	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	authenticated
f8cb4f28-416b-401a-b7ce-a3177b67eab3	rsa-generated	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	rsa-generated	org.keycloak.keys.KeyProvider	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	\N
14aada29-8bcb-4e1d-8097-294a933124c6	rsa-enc-generated	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	rsa-enc-generated	org.keycloak.keys.KeyProvider	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	\N
cb2cbc39-bd8f-4229-9b09-0d0f3daf1649	hmac-generated-hs512	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	hmac-generated	org.keycloak.keys.KeyProvider	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	\N
40a13734-353e-429e-902c-f5b404892d65	aes-generated	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	aes-generated	org.keycloak.keys.KeyProvider	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	\N
f53f48a7-3a66-4519-b60e-b8375d31c3fe	\N	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	declarative-user-profile	org.keycloak.userprofile.UserProfileProvider	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	\N
82b75162-f322-4031-8c84-5f42481ce3f5	rsa-generated	16778b9e-50cb-4ccd-8250-1e80093e3d7e	rsa-generated	org.keycloak.keys.KeyProvider	16778b9e-50cb-4ccd-8250-1e80093e3d7e	\N
2cb88268-e965-4976-872b-386bbf49e0ad	rsa-enc-generated	16778b9e-50cb-4ccd-8250-1e80093e3d7e	rsa-enc-generated	org.keycloak.keys.KeyProvider	16778b9e-50cb-4ccd-8250-1e80093e3d7e	\N
26862d96-4cdd-4f73-93cc-017e6248ba27	hmac-generated-hs512	16778b9e-50cb-4ccd-8250-1e80093e3d7e	hmac-generated	org.keycloak.keys.KeyProvider	16778b9e-50cb-4ccd-8250-1e80093e3d7e	\N
78cebf6d-879d-4347-8da3-97129a2b5fee	aes-generated	16778b9e-50cb-4ccd-8250-1e80093e3d7e	aes-generated	org.keycloak.keys.KeyProvider	16778b9e-50cb-4ccd-8250-1e80093e3d7e	\N
aea0cab7-793b-4cdd-89e2-5f20362767ef	Trusted Hosts	16778b9e-50cb-4ccd-8250-1e80093e3d7e	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	16778b9e-50cb-4ccd-8250-1e80093e3d7e	anonymous
c10c10e3-c0d9-4ba1-aaec-2ff962f967fd	Consent Required	16778b9e-50cb-4ccd-8250-1e80093e3d7e	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	16778b9e-50cb-4ccd-8250-1e80093e3d7e	anonymous
7ded5ec2-2b32-4ea9-a0b7-8050fab23698	Full Scope Disabled	16778b9e-50cb-4ccd-8250-1e80093e3d7e	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	16778b9e-50cb-4ccd-8250-1e80093e3d7e	anonymous
26376ee7-faa4-42e6-81a6-f52a49cf55bd	Max Clients Limit	16778b9e-50cb-4ccd-8250-1e80093e3d7e	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	16778b9e-50cb-4ccd-8250-1e80093e3d7e	anonymous
81b13348-e1da-4dc1-8317-2b08b8bbb439	Allowed Protocol Mapper Types	16778b9e-50cb-4ccd-8250-1e80093e3d7e	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	16778b9e-50cb-4ccd-8250-1e80093e3d7e	anonymous
87aeb8f9-f9b2-4c72-852a-ab33fddd7fe5	Allowed Client Scopes	16778b9e-50cb-4ccd-8250-1e80093e3d7e	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	16778b9e-50cb-4ccd-8250-1e80093e3d7e	anonymous
4aedfd8c-f952-4c9e-b731-9ff6719fed3e	Allowed Registration Web Origins	16778b9e-50cb-4ccd-8250-1e80093e3d7e	registration-web-origins	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	16778b9e-50cb-4ccd-8250-1e80093e3d7e	anonymous
4952b17a-711e-4dd2-829d-e7b51ba5061f	Allowed Protocol Mapper Types	16778b9e-50cb-4ccd-8250-1e80093e3d7e	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	16778b9e-50cb-4ccd-8250-1e80093e3d7e	authenticated
69830114-7f29-47b3-a16e-8063be09f439	Allowed Client Scopes	16778b9e-50cb-4ccd-8250-1e80093e3d7e	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	16778b9e-50cb-4ccd-8250-1e80093e3d7e	authenticated
a3e0d14f-b142-4d8c-babb-d4a8cf199265	Allowed Registration Web Origins	16778b9e-50cb-4ccd-8250-1e80093e3d7e	registration-web-origins	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	16778b9e-50cb-4ccd-8250-1e80093e3d7e	authenticated
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
16e7f6b4-b827-476e-b66f-aa90ddddd0c3	e214711a-67c8-44d0-81da-87d42ecfe2e8	client-uris-must-match	true
57d80357-b7fb-457f-aaba-6bd7ae42f066	e214711a-67c8-44d0-81da-87d42ecfe2e8	host-sending-registration-request-must-match	true
17a96fe5-e0eb-44df-a728-65e7c8a620ca	821c1a30-1f45-4d80-9f5f-d2d8b2ffdf95	allow-default-scopes	true
550b3802-5874-429d-b53f-647be818c9e6	e2e952e3-8702-4b0d-8bd4-ef70402c9bdf	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
3c48fb9e-5957-4918-9799-eebb45b0c41c	e2e952e3-8702-4b0d-8bd4-ef70402c9bdf	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
84a179b4-1bf3-439a-b3ea-750dc61b6470	e2e952e3-8702-4b0d-8bd4-ef70402c9bdf	allowed-protocol-mapper-types	saml-user-attribute-mapper
40f1bb7b-ceed-440b-9170-8ca57b8420e6	e2e952e3-8702-4b0d-8bd4-ef70402c9bdf	allowed-protocol-mapper-types	saml-role-list-mapper
a200daa0-20f9-4932-8ec4-bb36c2884e18	e2e952e3-8702-4b0d-8bd4-ef70402c9bdf	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
6e72107b-484f-4a0d-b882-d6230065a8ab	e2e952e3-8702-4b0d-8bd4-ef70402c9bdf	allowed-protocol-mapper-types	saml-user-property-mapper
36e700ba-d5d5-4599-a51e-a393ec9ca136	e2e952e3-8702-4b0d-8bd4-ef70402c9bdf	allowed-protocol-mapper-types	oidc-full-name-mapper
25751608-efa8-4f8c-aa69-e42f44951bd0	e2e952e3-8702-4b0d-8bd4-ef70402c9bdf	allowed-protocol-mapper-types	oidc-address-mapper
5ad39682-748a-4b9a-b1d6-e0e7a242ba49	d22e4d35-d0e1-49e0-b07b-bf4a0db16691	max-clients	200
b70c378f-81c3-4531-b816-63ae9b39c1c6	c2407cb0-a31b-485c-bd68-3fcb3ffe38be	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
5af796c5-9559-4916-9937-4faed2119d47	c2407cb0-a31b-485c-bd68-3fcb3ffe38be	allowed-protocol-mapper-types	oidc-full-name-mapper
35378959-2be2-4eea-a17a-cff8d70ae728	c2407cb0-a31b-485c-bd68-3fcb3ffe38be	allowed-protocol-mapper-types	saml-role-list-mapper
80374562-de89-4637-b7b1-8aae76c75238	c2407cb0-a31b-485c-bd68-3fcb3ffe38be	allowed-protocol-mapper-types	saml-user-attribute-mapper
7135383e-fa46-4437-a546-a61904e36985	c2407cb0-a31b-485c-bd68-3fcb3ffe38be	allowed-protocol-mapper-types	oidc-address-mapper
25832661-31ff-4f22-9672-a53804da0d23	c2407cb0-a31b-485c-bd68-3fcb3ffe38be	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
bba43146-f2e9-4685-9052-4049b820dea6	c2407cb0-a31b-485c-bd68-3fcb3ffe38be	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
624531ef-bf55-45bc-8bff-6bf03857b16f	c2407cb0-a31b-485c-bd68-3fcb3ffe38be	allowed-protocol-mapper-types	saml-user-property-mapper
71ef1159-e3da-4e12-b891-b00473e80857	dbaea7b2-cb73-4a6c-840c-7de06f05688b	allow-default-scopes	true
55fb8c79-bfa2-4f17-b9a8-85578747ae09	40a13734-353e-429e-902c-f5b404892d65	priority	100
89b4d0bc-5a1e-4e47-a700-4320b26a578d	40a13734-353e-429e-902c-f5b404892d65	kid	cabe3fea-c27c-403c-a90f-ea3abb4e3f91
de271b69-80f6-4add-8ac4-c98a7d669500	40a13734-353e-429e-902c-f5b404892d65	secret	nTbfEh7lHVtMGG-jezc1PKyLfD_hYcyRgrrRo3Af2xU
8822133a-4ca0-475b-a879-d8676b0e9fe2	14aada29-8bcb-4e1d-8097-294a933124c6	priority	100
cb4077ca-b0e4-4629-a894-dc163ec6b9ef	14aada29-8bcb-4e1d-8097-294a933124c6	algorithm	RSA-OAEP
fa938812-4539-445a-b151-9135f3672f04	14aada29-8bcb-4e1d-8097-294a933124c6	keyUse	ENC
98964f0d-d989-486c-ae8b-f46b1575d06b	14aada29-8bcb-4e1d-8097-294a933124c6	certificate	MIICmzCCAYMCBgGhZz4WXjANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjYxMDIzMDUyOTQ0WhcNMzYxMDIzMDUzMTI0WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDJNlxHj6/Z/ielhQHRB7VKk8v8emstRZSloF8cWy7Mvg+WCRbr0F96pcI+BK2ODOGAUcNFwvDCtCCWo2T8cUPw3nRt8S1EDVQb8nLyheSRhtUhi+TVHrJBYHG9GU/gnq5l3VmtGe7Pugl02da3gYdIMy46D3wF+lnESDWd3aElCzeictVjTEyE2WJx8z/sgy3CRAwx+fzY5mF3qJihtcK/lgZkpkRWfhVsNhM1W7T6sNGAKDSydFSEk5u6YwyaVqY8LTEDPGWGFSSCtNpL9t0jRm9OGPPPGV4fUuhnqjuIFrf697qB2kICZ5F+OJx/fsw6OdZe6NJ0QDlKvEbpPmnHAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAD/q54G2GfoGifV1BTt8cYy3UwJ8Av2CypZmc2QXj1ArdD2h9kjz+ITWgFwBZosTlLx3MPmUOeGL5Ixzspw0BIw0RTTpixzVA/mMCTX0zEt4T/ffpytcR654HsVffsULIh6XB3Gjwb4Ws0zouosruM4fQ0Bi3mA7IRjD21vpOmhj/lXtIZSvDcGeqDG7eiQMtcNu8BGlRqfmekm8FILpW+3mZERauhG6XzbchKGCduw/z9J+OljafSojXBqJVoToiNt6i1iAgqXLTIcDzbe2SXK8Z/kOAVp5sNRKGN+5SS4uCW218OXDHh1UfAQE6CF3aRzI8Jxt3Iyim0zCEL4+ruY=
e4be1637-4ce2-4fc7-a7e6-c5fcc356789a	14aada29-8bcb-4e1d-8097-294a933124c6	privateKey	MIIEpAIBAAKCAQEAyTZcR4+v2f4npYUB0Qe1SpPL/HprLUWUpaBfHFsuzL4PlgkW69BfeqXCPgStjgzhgFHDRcLwwrQglqNk/HFD8N50bfEtRA1UG/Jy8oXkkYbVIYvk1R6yQWBxvRlP4J6uZd1ZrRnuz7oJdNnWt4GHSDMuOg98BfpZxEg1nd2hJQs3onLVY0xMhNlicfM/7IMtwkQMMfn82OZhd6iYobXCv5YGZKZEVn4VbDYTNVu0+rDRgCg0snRUhJObumMMmlamPC0xAzxlhhUkgrTaS/bdI0ZvThjzzxleH1LoZ6o7iBa3+ve6gdpCAmeRfjicf37MOjnWXujSdEA5SrxG6T5pxwIDAQABAoIBACm3z6I2tGsqOuYikaHZS0lPI3gRma8lQhClE5M5hJaGwYyGDe6OoX04aPGa3rEZEpgcW7RXGrwDxM32yrVcdo22UcWJv6zgZpP0zMhj4mQZ5I60Bpn5Z1QOvwZJ/TnBLL+KCVHOkqkXFWbY05/why/9DJSVKU3D/mCn6BX3IbYgIxnYNoXHBf4kbIIDJXiSEKV15OmU7fZtwrEq1t/4F+puRVHsC5NgqyAYcbhVcz5zqfo86Y4+7NcRjWKwFkZt8zZjzmYfXnjr6uyS1tUCX2pghUwLD/wQSejvtm91fkAeoEbA+Td7oDSF4vR009hnbUKI6yjVDOxeHaujPXd2WmECgYEA6svvkXHg+nVw+KKZLoySIKIvW4gqoHvVIVnh2ORgA0eFUxp26wZyXd7M/LirAT5Ec178N2ZWr1k3qB1V0uhmcpUXcILDZeNvmUErVBLzkS71a7bvZ36/t9PJtd7gtMIs2VetMtP8ckVLeAUDnywJG+KX+aeUFwFDMrGeXLjCvv0CgYEA22IEpxSCFXLDUtq84Bghthe+SDkvwW8ovenS9OQqRFuJqKkJyoPjp0KV5Ki3asnu9aTZBXO/Fbh27BKpbgX2DIi7rmEDk1Yvm4ZO56q1l4bk4LAZkjVdro/INfDv2lFQbZIpJVMxF0DM+w8adPm4DNki2P2QKJ63NBU3+AE8QRMCgYAgCT9gyvb1dXy6kATykv+FMFvh00xtpTfJWygzncVz7RhF5ICBRNnp8PJrMQ80FjjkvPsQ3AfL2RJ8/7OsGUWRMMKH+W+LwWKCuJ+e0w8kqhGWZtl3d5XVETKefBCQ2UWhShM5si7psIbBk32RBEMh6OLvj2vnT6bJje6bnCIGSQKBgQCxhdeN/CJniL5VxXshO2XMG9p2RxBFztWBGD0Evb0WI5x5RpANuDv3lQIGTiBd4ZnkXMjgiJEP2n0g+tjvlxNLgTmeGhLynsNXbo9bF+BqBVYgG2AV1+k+4Ep6m8T7POGASM3SzkbjMiSs48Pc9FXiz7JLNKP6urQ1CRaJMTa40QKBgQCV6Y3JrNs2qhuIvHU/AcAIJUnO3FPl0jhWd+237Ubqa8Yl/5vdKns/vEtI3CJgdTnW+1xin8rFsxzQWLez4X6XSJs1rw4MsqdTj4xh/w8lEITy+9DjvLPLEfvJ7fMADZ9FufLWPlzyO8iy18SbEYh8YnjH7PNo0Ph1k+Y00+JryA==
cab4de38-b095-4a89-a4ba-c42dfd7260f3	cb2cbc39-bd8f-4229-9b09-0d0f3daf1649	kid	eb82ec67-2910-40b8-808a-56ff21d861cd
8863cd90-9ee7-477d-89da-ccd05de5da13	cb2cbc39-bd8f-4229-9b09-0d0f3daf1649	secret	Za708VnfgaYMV-HHImbGAW4j-HnVPGDpTlMmS3Zp7Y3tsz98uMDxFaXkh6Ibb1mLzR9nBFc_mxNUltbXpz40_7GE6E9bwiVDc0hh_6_I_7CBtCsK1YzEQMLZ7lr38k0YuFk9qP6SUwDiyldHZCwlSNhU4Nk8tAbWu5iZF-RSfpc
fd26417c-07a4-4ccf-925a-c7e4a80cac7b	cb2cbc39-bd8f-4229-9b09-0d0f3daf1649	priority	100
f18f7717-55ec-40f8-8838-e033854b6fa4	cb2cbc39-bd8f-4229-9b09-0d0f3daf1649	algorithm	HS512
92b2e58a-a45b-4738-868a-5208d6dbc3f8	f53f48a7-3a66-4519-b60e-b8375d31c3fe	kc.user.profile.config	{"attributes":[{"name":"username","displayName":"${username}","validations":{"length":{"min":3,"max":255},"username-prohibited-characters":{},"up-username-not-idn-homograph":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"email","displayName":"${email}","validations":{"email":{},"length":{"max":255}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"firstName","displayName":"${firstName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"lastName","displayName":"${lastName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false}],"groups":[{"name":"user-metadata","displayHeader":"User metadata","displayDescription":"Attributes, which refer to user metadata"}]}
2958cb15-3109-4da1-a6b9-bd17d750d26f	f8cb4f28-416b-401a-b7ce-a3177b67eab3	priority	100
91fa5036-6f49-446f-b13e-3fed96b57ffe	f8cb4f28-416b-401a-b7ce-a3177b67eab3	privateKey	MIIEowIBAAKCAQEAqlGAvfwB12YCmb31pMjMgKykBKnDj45DvcxnfDZ/WjABTbrYYlybXYH9fS5cxrP4T9242vp/ZXB7UwFLd4jnI0Yuw0tK/0D52jP9pIPSLzegO+3ccrnlfCVJ58Jq8jNfIkdkfnr3XCuPs9zH0ec1pG2FFajqf50eg0jZ+LbRVaY4950wVkbvbL25P5za3yA+gXs/9hh6nN3hztpYrt4trJCHBBgI3kjaGM2TNoDE1an95p9bepcg2YFgcWuvMBzzpWQ+UVjZAeGj9oSHURYeLUMaSa92O2bAeW3xxBdXs9MfNh/+eqOYf2mEufkywLgHsgnIqOgrqMJniJGZmr56xQIDAQABAoIBADreSN1hyVEmFSgGnG0EaorfISHre4iW55sml247d/E4PnsbZcc5swmy8GbgK3kSo3UXcdleU8JACqA6BleeniV3EJq334gycSmWZskCNxfS5jNQl62fy04JpW3RqR1l3DAA9R8yaWUWOWk1mmtWuxfGMwW1iLfrGqzN9Wkd52TuqnqXJEqiW7zi5gvsDkSC/J806ne5lke/33MU1Xj1loWhcYNONEbGsCHzK06/MjtydRDjW4vTguAi+HmZLd5MlEyc9U8stufymOYMLC+FdJCd8AjR54NM5aZRbHkusQcHYv93dRyf77pLnqKq/G1Y43lQnJHy1uwGr80qKlbNe1ECgYEA35utNupuAgTIeopfVE5JjavoMS/edMej8XfAfSFAzcpEJEJDVTpGOz0AzANGcwwB+DPagZK6NWZAnqHMa+IL7XX78BpcEgbgskahiEag4/3bqOunzuMx08V/KW9y2U1TV7vcGx9cbdIr028UHsWuqdh2lgOBcKvtNBd3/6fLIfcCgYEAwv2etQFEfXw5vmHbcx7zhOorvmQswT2gkJs5Cxbes+KR6/5GLD0LFhqkzVORGnijz/TDt1UixvkhpgxcI3DY5P2fKd4uNXSuNUMno3Uf9+Ph2kI02wvZgga3Ayi2R6MGYQJaE9yCYdkB64lw9GxaOvis8ZyAn5sUchk+OT44WiMCgYEAxTvc4naPyCoN58DL62IOkO8UJOazUtCRtDjLydOeBKcnyc/E8pUvQ6tAW7N73Zi22AZs8yPIKbfiwcm3tWUy3ibWreeiVKhKZBXW/4xE+DWAHpSWdO+DkOdAjfznEfOZ0uY6dJYKAjiDPcFZvvbhZKExoIrBDvAnj24wA4ouq+sCgYB1J4zDlA9ildDb4k/Hy0DlCw1dRzLcp/pg5+JOF1+XFPo3oH7o9YRDs55w/1SfYvyJZbZx4GUUx3rAGY0CfjrS2s9WiHebBo/k0IRwYV7jwbdhO4YmVehJh19ONpfOUtTyVEdqx4JO5+OPcPS85p0P8Xl3cWCWhMa0BxarrgaNoQKBgHZIkSa/UY50EftUs3AtBj+dUp89bbjZFNGSJQwvZKhP4EtzPUP6P0JHBAK7BcudvAau0ESFRxPxjfT0ZzuU60WdBK7ZoFj3AHwFtH3TRFxS1cWQVQr2TsddJFTLKLCAm7xBJWSkJJOnD3+CwkiVawJvfGoE3K6zys7efbO9ZBS/
7549db5c-ffba-4000-94f7-8533e2abc04d	f8cb4f28-416b-401a-b7ce-a3177b67eab3	keyUse	SIG
434a5b2d-95cf-41fa-ba94-3921a2bf38be	f8cb4f28-416b-401a-b7ce-a3177b67eab3	certificate	MIICmzCCAYMCBgGhZz4VqjANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjYxMDIzMDUyOTQ0WhcNMzYxMDIzMDUzMTI0WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCqUYC9/AHXZgKZvfWkyMyArKQEqcOPjkO9zGd8Nn9aMAFNuthiXJtdgf19LlzGs/hP3bja+n9lcHtTAUt3iOcjRi7DS0r/QPnaM/2kg9IvN6A77dxyueV8JUnnwmryM18iR2R+evdcK4+z3MfR5zWkbYUVqOp/nR6DSNn4ttFVpjj3nTBWRu9svbk/nNrfID6Bez/2GHqc3eHO2liu3i2skIcEGAjeSNoYzZM2gMTVqf3mn1t6lyDZgWBxa68wHPOlZD5RWNkB4aP2hIdRFh4tQxpJr3Y7ZsB5bfHEF1ez0x82H/56o5h/aYS5+TLAuAeyCcio6CuowmeIkZmavnrFAgMBAAEwDQYJKoZIhvcNAQELBQADggEBACWR427WuaT5VoR4D45yae8tpNIdKxKRgInBQ0aSRVBS9zPK+4xYOKTFwWzd+3/iYF3jMMp2PW1t8DTHUPUZj8g9itSaySRlUh7NnXQ/T/+SOcZLYhSGlmxSexpqrN0HSPm8MWesj4PASb2NwW7BV7GOrPTh0OkWQP96DD2BNtm+Zzk2YRDZdWBBaumHEXVLyuyGh0S4TpjBC1juWPj9wdq3rNJ8hjrbVrIdi4S/TShjrag9181nv0uMEfNVOz1NaF9fgNTzKvCkH8u8/fgzk+8ac+g6QzXezdlYcGOcZbZF/9+Y2CXTSKsY56ozFT1XX60a16WarZLOMVO9lPwgkDM=
f5374f81-3163-45bb-90f8-e77017ea1d87	82b75162-f322-4031-8c84-5f42481ce3f5	privateKey	MIIEpAIBAAKCAQEA6bqOpvrYDN/FuoMtHWN/WwaPTpXFqF+hDT7sfPSy9Tqt/8rLsGmnu077in87B2+Zo5XvPapzEIbIdY6FEYA8JiqdNgN/v8klPN+8fCDbOlF8iyNGn3ltzrUfWMSYYeG8tuzUrq4X0ef03yZ0xViy2ORGv/v47bI4BhSZcnaBcIUVZnt/Bnr+B9AFeoIT0kE2YZm+IEKgKiLJ+i7LpbKpLPbManmC1i7FIAvqm4rz4BAGyH6B3kxPsObSfUwbwTiE9dE+MbEDtqWWB8Dgti3R+gPeR+5jbFw30BhDLXToCwb1MpR0jalZdd7TMuXBVlHUHZElKWwG7R9J7JL6tSYL5QIDAQABAoIBADDcZ7r/oI/cbeUGTDWjGbopPmcyxz3iM/RlbaHXs9uxNzPMrNVF2SM+qTY0T95HlcpNa1SsX96aFqkAsM/OS4S9Dt1+UMQCpE68BRa79aiU5WDe8IIhK/P1CEcR3jtEKiPhkbqsuV0PzTCjRPEGkGjoG+RBpDHoum6G+ucjX/7p5RhOHdQdPeqHmF6FeS3Y8g/Cf7SBmeSaSwMsvVfme8S2JAjcUAOsx4umAcO5PdiVCtZyQsHiap4CVdEdqeO+kGQvdoLWGIL0ojV4ToXnuXSvYeyVVG+o3CMdcxqDALLp5O4Ac0BXK56jgYHWpr2aYWwtREAefxTZ71EFvy7da2cCgYEA+pTgWqjfKKG1a0M42apEHQlrmawaU+0MeVFcVBZ6NM3YIC5by+jhBykV5cfTFcEmTr+YfWcL87WE7wC5mtcHt/kwvwTcpeWh+dH/VfUPqYCQUSD0zvOicmz1iTXAkXSVOi2OYhSPdj5P6I2UGZ54wY37LjmES2beMA8eejes1SMCgYEA7shj4Jk7kMpGwg0Y5L0wjRQK6WEtNsZKe5I6CkZlsFuIrhp1A+usLJfeqeY53tC+lcQPOXIZri4+vDXxD6n9AItu5uR32SrhCf6ReUxWpZWkMmgxFbDl31xJKuv++5AlQQFt0+Y+ijGax3RjXhL0t5b2iEi2aJUjD6BQqzGSP1cCgYEAxeDU/qLGfwacBhUyiqirWya6QsMmk0nphNAcEgciABrhZiBVu0OumAH42dift1ks0Bj66WR7iru4OyieaUkPPlfZB69mMteQvn/3m8CG2rq8vGRDDj5U9PlYOD8rT3H5+dRJ0OgdlimE3scWwdhj0a02Qn2HHCgio179GVRn9nMCgYEApG03Ya0C+IRhzzSHpNOmgC+CCA1Tvjkzhv49m1+4nIWbjBBJ7cY2zIpT2Pjhds6VvrnAphUtG+Vaa+5VLi0nPF3Ho5VF9jRxvJkhAb8Ql3uBEvjue/pRgMqi07yo2//5t1bNkzIkdLMN2zUJS/mPrHB3GYfAnCm+d/80LX64L4cCgYBhEIkzkNy+wAgI2aIKbTBniZgTiwc+xTKM1tPLicXIPuqxG1IzmiVE9cseyNX19WzeI2ibFgaAnBAMAJa9WRDAr3ef0wz9xfsJL6StcMCtEEIWRUMJBRc9hnqJssr77XDm2NAQ2yzIsb9NK2oNRFs3shzR17zY1D+ccMNB7xr1Ng==
eed1a360-39e1-4bb7-b3a1-4732a94b15aa	82b75162-f322-4031-8c84-5f42481ce3f5	certificate	MIICoTCCAYkCBgGhZ3ubazANBgkqhkiG9w0BAQsFADAUMRIwEAYDVQQDDAllbmlhY2xhYnMwHhcNMjYxMDIzMDYzNjU2WhcNMzYxMDIzMDYzODM2WjAUMRIwEAYDVQQDDAllbmlhY2xhYnMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDpuo6m+tgM38W6gy0dY39bBo9OlcWoX6ENPux89LL1Oq3/ysuwaae7TvuKfzsHb5mjle89qnMQhsh1joURgDwmKp02A3+/ySU837x8INs6UXyLI0afeW3OtR9YxJhh4by27NSurhfR5/TfJnTFWLLY5Ea/+/jtsjgGFJlydoFwhRVme38Gev4H0AV6ghPSQTZhmb4gQqAqIsn6Lsulsqks9sxqeYLWLsUgC+qbivPgEAbIfoHeTE+w5tJ9TBvBOIT10T4xsQO2pZYHwOC2LdH6A95H7mNsXDfQGEMtdOgLBvUylHSNqVl13tMy5cFWUdQdkSUpbAbtH0nskvq1JgvlAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAJQpAI2/fbJ0y+3tyyaXOQrA6toptJ4KQqbHZKTuafYS7k4gEyntuIuid9lf7APfAym4YWINbOkrJY1LhUAkLTJ696xREgtkG9/GF+NngYt7GVyNX+giolNr0tVCrmwmNPk5U0Vqo4O1Q9TyEve/Mof239X6Q1GdWUI3Zg+byu9C/BNiefxCR4KB0vNF7SuPEVa4xTByc/0pok3rrOZiec/gUd15EQsJZAtUqwDJD3eTs7Dn7aUUKrJ2K5jrnRPYPcTXbNrgBbfVcY3O9RCCFXNuTZgUXEgCf/YkGouOmHx+EUhI64r+Y0hJVGTanVuIS7JHH7lNZHiKMnMd8q+lz4A=
28e3fcf8-4405-44ac-b793-fccb1dddcb67	82b75162-f322-4031-8c84-5f42481ce3f5	keyUse	SIG
38e3a386-8dac-4384-9a3e-7cdca02d9388	82b75162-f322-4031-8c84-5f42481ce3f5	priority	100
4239d43f-977f-4487-bb28-695ef5cf40e1	2cb88268-e965-4976-872b-386bbf49e0ad	algorithm	RSA-OAEP
aff22335-b323-4088-8e8e-f0ca1be80e65	2cb88268-e965-4976-872b-386bbf49e0ad	keyUse	ENC
e6ef0748-9572-4772-9470-0afa0943783b	2cb88268-e965-4976-872b-386bbf49e0ad	priority	100
99dc7685-8d8d-4338-b9a6-2da214076b9f	2cb88268-e965-4976-872b-386bbf49e0ad	privateKey	MIIEpAIBAAKCAQEA3fJLYefZWcpfJg9wmVcsKNu1uojn3OJpBoKfSQDEgGLCNLSOkeiLueecS6qAdotXTTXDALkGVgoz+6qq92eLV44PNKIBBvG5fHngG0a369oKHmbder224/8k3F5oAVo8SeMG7p9elF/j2pmjbLnJLGjfWCOzn7BexQfgVcXqDLYGMNXTmytN6LIPi60qXN5jCSkyycaq7wsN6A6mfFkCtaSGv9qm796pouS82qQGoCvoVldTkGOcBKq/8nuzVI9WnHbXD2+s1KEjCRKNnETyZ1vCk3qQcyBVNdu4swVlN66nkyVyrw2H6EGLIQ4BRh96KUS10rE0JvaRWEFHwaGs6QIDAQABAoIBAAxci+8kLxOZDAkL7av6bayAU6HT6DmB8QT6hTIOIwg501byuTapxg+jEOUGjQ1on/BL80ILMK3d0sFe4xMZ8EWQ1UFnD14oEwNfGTsCipsE+EwqCj1TIkPfvRBD5Kvo5fy4FwgJVk/tjZf8ku6YmvqDzV3dyXd/lIn3XsP/E4KExJODg3buPJA7nyNfoo7hnRg/M5EOaZ/YOU87+mVhLZZiO5X/WSi0tXr0AlU4McQ3ybJTXVxyTuzNhzJQWSICi2Lyo7eAMLE90u5XEDDRyPLbKsLPZylC+m2osBmSKHePYkcUwJXHp8WoTQGdx+Y2V8LkRF2kd3r9gAj61EAVC2UCgYEA88cw67M9ow2F2A5dvVG444hWvaJncsozuPD4w4NY2kY/2tLvxahGAnvRuNHu/vc+0VEOZRXUceT16KA6EbcOH6JhP1levC8qhF2RR3DM//1XHG45jS0USLNQ2A6RWYICTLnx5COsrOqui9hBP5ECGe+RN8Zt7lUVBkxB9YZueusCgYEA6RLm36i6dG3Zu59r4pzIgHHc3FAud+XfCS2UZQbL/YswZMXtbxZZ7gq+7L5RXsH5q4RVcot0aEZopTJJfC20DedgcHntdWZ05PkYCRdSWehIH/2GxK/zM/iKSxP3/FHnGUKmsMhg1jWgWzdUz51VEHdgkMzVRgnMpsGdTriCWnsCgYEA6VVKfQBWSeBisRenH9O9/YN9SwvMqrHh6e40nab2AA7nhcMLH4zeXfg4GAhRExiCtwU3mwfXDaESwzPCATzOtvbM0D7xj3wx3PpWWSQeBBRwMdVLHtb8KE4CXpsrApqPKvN8FVsUJ3qF0XMPmRFqCnsk61bx2AL2Gc4aADFJRDsCgYEA10GkxqW/Zm5Z7AVlj0o7hx0h3LuU3xkHLyPQbKmlVonpbPi7u6AJ+GYmROHUps5Bdx3mCL8xCGkWlpNl+PEA3OJ3WAnTvFye0yYXA7ZtUSnNCvaMNDVISRRfLM3Jd1hxNgwvhQ/bF5s5eWUVyBVHjcii/7idtGyyfMROM3kGsucCgYBGxbfegT4ohK0d4QFXgQRJWcWMQTsAuNqaF7Us87ESZhmVXzS+6LamPFruhAE+F2QEPaL1+4wbF2+sP+tomWRJAfNn7A5RJaPORWmvyc9B+r3QvPym5U6/dySXgkRuUUB4QOrHzlsJUR2sycivjwSXE4GLkpBFng5OmTPsKhX7og==
2cd4bfa7-5f18-406b-8fb5-b67409936a92	2cb88268-e965-4976-872b-386bbf49e0ad	certificate	MIICoTCCAYkCBgGhZ3ubnzANBgkqhkiG9w0BAQsFADAUMRIwEAYDVQQDDAllbmlhY2xhYnMwHhcNMjYxMDIzMDYzNjU2WhcNMzYxMDIzMDYzODM2WjAUMRIwEAYDVQQDDAllbmlhY2xhYnMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDd8kth59lZyl8mD3CZVywo27W6iOfc4mkGgp9JAMSAYsI0tI6R6Iu555xLqoB2i1dNNcMAuQZWCjP7qqr3Z4tXjg80ogEG8bl8eeAbRrfr2goeZt16vbbj/yTcXmgBWjxJ4wbun16UX+PamaNsucksaN9YI7OfsF7FB+BVxeoMtgYw1dObK03osg+LrSpc3mMJKTLJxqrvCw3oDqZ8WQK1pIa/2qbv3qmi5LzapAagK+hWV1OQY5wEqr/ye7NUj1acdtcPb6zUoSMJEo2cRPJnW8KTepBzIFU127izBWU3rqeTJXKvDYfoQYshDgFGH3opRLXSsTQm9pFYQUfBoazpAgMBAAEwDQYJKoZIhvcNAQELBQADggEBABuxm9LhcHr6g8pNzaUSW1xLUucKcw7RZ3nHcEh2bXaZQdMvtounhiSFC6vT0JrpwdzDi0snUKz0IWApUbWQ1NEDNY/lBYw2CqMsV9Tmvn51M2YijvsdpZ+JpbXJMP0td8d8OIAe3N1vLfX4CmHeIL01x/22TciCXL97RwqAZILbJToOhys73RAxjyA2LCMULk9OErpz/HUinBZgiT861NNFARjb+kmGKHV4uo0Fvj/ktntZ5sGraD6xdnvUo53x9GT9+dCCO5Vai/FLzHggFxXNm4fKCstcXkyrozdYYi1+8+JBiZ4iqV3Qywg3DbJkzHv/TsyZxoMQKf0DEKZd3yM=
b3660746-332e-48c9-97dc-14d91edbad99	26862d96-4cdd-4f73-93cc-017e6248ba27	algorithm	HS512
1a3a159f-148d-4220-9335-5845f9b1c105	26862d96-4cdd-4f73-93cc-017e6248ba27	secret	KOzpOYbjeaI7mTVurBYGKogTwyzq9jPZ128V2mHsagdXmvmaZeGCUfK6L31b3Nl63SW_AgYj8hH43w_IKbJZe-lwzex-WSP9v3uINLnTbv2o_hD2Gefe1UXJpPGxlg2No6Ch8xuMR_Jn1QDqx7RP9vVuzmQ8q-6xzVso1XmGA_I
963f3f1f-5076-42d2-a2be-25b4f43b5738	26862d96-4cdd-4f73-93cc-017e6248ba27	kid	d1b85d85-a19a-47ab-bbec-ccdd87dcb0f5
29e22062-a7d1-4cd0-82ca-c11e6ebb021f	26862d96-4cdd-4f73-93cc-017e6248ba27	priority	100
c9a6b544-e106-4b3f-b1ea-c2d4e938b782	78cebf6d-879d-4347-8da3-97129a2b5fee	priority	100
29e73864-2d2d-4606-8f95-a4d75eecd771	78cebf6d-879d-4347-8da3-97129a2b5fee	secret	mUCO_RiKcNWFfvNU10O6bHQ8EG0-cMfiseeavZwxk0Y
6d2fd9e2-e84e-4ec3-ac36-fd7cace4b5d6	78cebf6d-879d-4347-8da3-97129a2b5fee	kid	29fdaa7c-c7ba-47bd-bc1f-d847d51f4da5
407904aa-8d57-42c8-9364-7b42c27f7186	26376ee7-faa4-42e6-81a6-f52a49cf55bd	max-clients	200
52479125-160c-479c-98ba-f5306aeb8ed9	aea0cab7-793b-4cdd-89e2-5f20362767ef	client-uris-must-match	true
061a400a-e0d3-4c14-9d6e-a35fd70a4812	aea0cab7-793b-4cdd-89e2-5f20362767ef	host-sending-registration-request-must-match	true
cf166c6c-01bd-470c-8911-6a19abc740dd	81b13348-e1da-4dc1-8317-2b08b8bbb439	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
48179142-c996-4494-acfd-342fd76cdbeb	81b13348-e1da-4dc1-8317-2b08b8bbb439	allowed-protocol-mapper-types	saml-user-property-mapper
9e2c84d6-f08c-41bb-a4c8-22bcb1a5c6a0	81b13348-e1da-4dc1-8317-2b08b8bbb439	allowed-protocol-mapper-types	oidc-full-name-mapper
2d047f65-c4cc-4b99-adea-bfc9ba9c8ee9	81b13348-e1da-4dc1-8317-2b08b8bbb439	allowed-protocol-mapper-types	oidc-address-mapper
3333d106-2df5-44f9-b229-c7262b25fdd9	81b13348-e1da-4dc1-8317-2b08b8bbb439	allowed-protocol-mapper-types	saml-user-attribute-mapper
ddf68e59-527f-4306-8a52-c4b3f6f80e5c	81b13348-e1da-4dc1-8317-2b08b8bbb439	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
cea1d264-c6db-4d17-9446-082f2a66d4ef	81b13348-e1da-4dc1-8317-2b08b8bbb439	allowed-protocol-mapper-types	saml-role-list-mapper
8198fa84-b48a-495a-aa9d-21e3bd33b590	81b13348-e1da-4dc1-8317-2b08b8bbb439	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
22021951-8be9-45e7-aeb2-d52ecb9c2fc0	4952b17a-711e-4dd2-829d-e7b51ba5061f	allowed-protocol-mapper-types	saml-role-list-mapper
a739f259-2423-41b9-80ab-44a84c826d7a	4952b17a-711e-4dd2-829d-e7b51ba5061f	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
5409b223-8dd2-4bd5-8b10-df12646a6d35	4952b17a-711e-4dd2-829d-e7b51ba5061f	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
e3038576-b769-4639-b905-03eec6bbb328	4952b17a-711e-4dd2-829d-e7b51ba5061f	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
4f800b5e-1720-4fa6-b0e7-ee16c4bc7898	4952b17a-711e-4dd2-829d-e7b51ba5061f	allowed-protocol-mapper-types	saml-user-property-mapper
cede0387-7b3a-4a92-b88e-a397867b2731	4952b17a-711e-4dd2-829d-e7b51ba5061f	allowed-protocol-mapper-types	saml-user-attribute-mapper
2d1350fe-cfd2-434b-8a39-09f16c32046f	4952b17a-711e-4dd2-829d-e7b51ba5061f	allowed-protocol-mapper-types	oidc-address-mapper
e1b1e0f4-5030-43a0-9199-ffc7b8d5382e	4952b17a-711e-4dd2-829d-e7b51ba5061f	allowed-protocol-mapper-types	oidc-full-name-mapper
274bf83d-d5ac-49f1-94ec-dce363e8b674	87aeb8f9-f9b2-4c72-852a-ab33fddd7fe5	allow-default-scopes	true
a714fc46-2b90-4d50-b7a9-9cbbb04b9758	69830114-7f29-47b3-a16e-8063be09f439	allow-default-scopes	true
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.composite_role (composite, child_role) FROM stdin;
55c449af-77fa-4a46-a813-2e59895d2a9e	ef926176-c437-47f7-b739-b8a8438baf61
55c449af-77fa-4a46-a813-2e59895d2a9e	659a7a70-985f-4cac-8433-182092900630
55c449af-77fa-4a46-a813-2e59895d2a9e	bb46684d-95fb-4c9f-85aa-2939ca784621
55c449af-77fa-4a46-a813-2e59895d2a9e	7029b9e3-8a7f-489b-91a2-8ed58f4b137d
55c449af-77fa-4a46-a813-2e59895d2a9e	098b198d-4e48-4f91-9bf9-1eb6ee86bf10
55c449af-77fa-4a46-a813-2e59895d2a9e	9df921ed-4da4-4e72-bb80-96b076760fc1
55c449af-77fa-4a46-a813-2e59895d2a9e	798a190f-4d57-4c78-a77d-4e3098074787
55c449af-77fa-4a46-a813-2e59895d2a9e	fd115c68-d694-4d79-b5e9-493b4abab1d7
55c449af-77fa-4a46-a813-2e59895d2a9e	ab494458-b52a-4751-93e0-1fec3003d523
55c449af-77fa-4a46-a813-2e59895d2a9e	828a1a18-b90d-49b8-b134-fef43e33a773
55c449af-77fa-4a46-a813-2e59895d2a9e	d53982c3-c95c-46aa-afc5-2c25e2eccad4
55c449af-77fa-4a46-a813-2e59895d2a9e	824d52e0-e168-4931-aea9-6a9a347a7d40
55c449af-77fa-4a46-a813-2e59895d2a9e	8ea3eeea-0d6a-4aa5-a30a-fce7a343f597
55c449af-77fa-4a46-a813-2e59895d2a9e	41ef19c7-c0a5-478a-9350-2b014459b658
55c449af-77fa-4a46-a813-2e59895d2a9e	fa8831a0-4f1c-4b89-9226-dd97dc7813c7
55c449af-77fa-4a46-a813-2e59895d2a9e	1b6a2194-6f33-42bb-a50c-7744327718bf
55c449af-77fa-4a46-a813-2e59895d2a9e	567c5b14-9595-4fca-bd2b-065446a3db00
55c449af-77fa-4a46-a813-2e59895d2a9e	960bcb71-a06a-4b97-91ca-b04db87a7b3c
55c449af-77fa-4a46-a813-2e59895d2a9e	b3b0d0d3-96dd-4990-a2af-24ffdb88742b
55c449af-77fa-4a46-a813-2e59895d2a9e	18ead793-de89-40d7-9653-99f78a0f95c2
55c449af-77fa-4a46-a813-2e59895d2a9e	4dc0a933-c23a-46f3-8185-7648e61903ab
098b198d-4e48-4f91-9bf9-1eb6ee86bf10	960bcb71-a06a-4b97-91ca-b04db87a7b3c
7029b9e3-8a7f-489b-91a2-8ed58f4b137d	567c5b14-9595-4fca-bd2b-065446a3db00
7029b9e3-8a7f-489b-91a2-8ed58f4b137d	18ead793-de89-40d7-9653-99f78a0f95c2
ab494458-b52a-4751-93e0-1fec3003d523	4dc0a933-c23a-46f3-8185-7648e61903ab
6a0bc16e-872b-4c44-ae7b-16dea5221812	5b15ee41-d027-4963-b08e-36255a8f9cff
6a0bc16e-872b-4c44-ae7b-16dea5221812	e2dd4f5a-baa9-40f4-b0ac-c777d4487eae
e2dd4f5a-baa9-40f4-b0ac-c777d4487eae	7a776c32-fe77-4cca-9e75-551931cfdc31
9a0725a0-1e54-40ea-b5fe-926cd3199550	9949bd94-24f2-4d6c-9a85-86211854c2c1
55c449af-77fa-4a46-a813-2e59895d2a9e	4f82bb57-bbbd-44d8-9eb0-f074eba1b8be
6a0bc16e-872b-4c44-ae7b-16dea5221812	26576a80-1f8b-4e4a-9395-5fc77bc6acb3
6a0bc16e-872b-4c44-ae7b-16dea5221812	c7b37c40-3006-4bd2-8dc1-49779e91c0a7
55c449af-77fa-4a46-a813-2e59895d2a9e	b30b4753-8515-4861-8f1f-6071431e83a5
55c449af-77fa-4a46-a813-2e59895d2a9e	71cbcb9d-15f0-4cd8-be09-ea41e3dae154
55c449af-77fa-4a46-a813-2e59895d2a9e	974ef83b-351a-402c-8420-4ed8d9dd84cf
55c449af-77fa-4a46-a813-2e59895d2a9e	5eb6e2b9-7978-4aad-b5b7-240895f4fb50
55c449af-77fa-4a46-a813-2e59895d2a9e	20dd03c2-10ce-4abf-9910-abb441274b58
55c449af-77fa-4a46-a813-2e59895d2a9e	9d550c6b-e019-4613-9e59-b7792e4dd48c
55c449af-77fa-4a46-a813-2e59895d2a9e	32b9485b-c7e0-49a4-93f9-cb7d9b834801
55c449af-77fa-4a46-a813-2e59895d2a9e	29006ee5-d504-45be-bce0-1f3e1cfa502d
55c449af-77fa-4a46-a813-2e59895d2a9e	e5304a0c-879b-4028-9450-7577d9260e51
55c449af-77fa-4a46-a813-2e59895d2a9e	620c014d-2e44-4f05-b66e-46fc0661680a
55c449af-77fa-4a46-a813-2e59895d2a9e	cfdca7ea-82b1-4204-8514-492c480e1e0c
55c449af-77fa-4a46-a813-2e59895d2a9e	a6c5cc24-4909-4ddc-bd06-0b1ce81c37d9
55c449af-77fa-4a46-a813-2e59895d2a9e	2382a64a-9879-4be1-a611-e5e487e00c3a
55c449af-77fa-4a46-a813-2e59895d2a9e	87888590-3d16-4cfa-b817-6983b6d95417
55c449af-77fa-4a46-a813-2e59895d2a9e	c33f3bc9-b115-4f71-b4df-316e25dcdb54
55c449af-77fa-4a46-a813-2e59895d2a9e	e78649bd-841c-4c08-b5d2-ceccb09cf9a4
55c449af-77fa-4a46-a813-2e59895d2a9e	ce5b8b66-08ec-43cd-bae6-b85e0d173d82
55c449af-77fa-4a46-a813-2e59895d2a9e	04142d81-0af3-4e50-88ad-ba0781157c4c
55c449af-77fa-4a46-a813-2e59895d2a9e	fa9ba3f7-34ba-4c6d-9d18-c97b5649e29e
55c449af-77fa-4a46-a813-2e59895d2a9e	cb694d40-4228-4aab-8424-0354cd578cb8
5eb6e2b9-7978-4aad-b5b7-240895f4fb50	ce5b8b66-08ec-43cd-bae6-b85e0d173d82
974ef83b-351a-402c-8420-4ed8d9dd84cf	e78649bd-841c-4c08-b5d2-ceccb09cf9a4
974ef83b-351a-402c-8420-4ed8d9dd84cf	fa9ba3f7-34ba-4c6d-9d18-c97b5649e29e
29006ee5-d504-45be-bce0-1f3e1cfa502d	cb694d40-4228-4aab-8424-0354cd578cb8
574fab0f-d02e-41c1-ad7e-ccae12655673	abfbf52f-7ad5-415f-8a46-bce66ed5c53a
574fab0f-d02e-41c1-ad7e-ccae12655673	4a0aadc9-5e3f-4c9d-8d42-6dfb78499ef4
574fab0f-d02e-41c1-ad7e-ccae12655673	52be68da-cea9-4e06-b029-8a0d8f04a8b4
574fab0f-d02e-41c1-ad7e-ccae12655673	6fe748c8-3ea8-47c8-8471-15d85eabc0e8
574fab0f-d02e-41c1-ad7e-ccae12655673	c3b0b26a-9c98-49f4-abcf-8f051a605e22
574fab0f-d02e-41c1-ad7e-ccae12655673	89d2af98-b6e3-4664-a125-d00d0f60bc86
574fab0f-d02e-41c1-ad7e-ccae12655673	0c1d018f-849b-4d8b-98d7-4862c12dcc3f
574fab0f-d02e-41c1-ad7e-ccae12655673	8108f9cd-2277-469e-90d9-3902d87aeffd
574fab0f-d02e-41c1-ad7e-ccae12655673	40fb1d76-9aee-4509-8bf9-4b3ecaf8983d
574fab0f-d02e-41c1-ad7e-ccae12655673	5802adbe-86b4-4dd7-b881-2c54adb460cd
574fab0f-d02e-41c1-ad7e-ccae12655673	7f22c564-5147-4082-a6f4-1bcd8fab8ede
574fab0f-d02e-41c1-ad7e-ccae12655673	958a4faf-a450-47a5-8feb-c7b470a55a2e
574fab0f-d02e-41c1-ad7e-ccae12655673	04859ffe-8bb7-4454-b658-b02a6e2130b9
574fab0f-d02e-41c1-ad7e-ccae12655673	3dffc968-968a-450f-97d0-b4ae8b57d470
574fab0f-d02e-41c1-ad7e-ccae12655673	c3ea2e63-8c5e-4190-817c-b8098062cd47
574fab0f-d02e-41c1-ad7e-ccae12655673	6de41b64-7db8-4d38-9a3b-a10565ba1b96
574fab0f-d02e-41c1-ad7e-ccae12655673	2d829f87-0048-4417-90c8-a505d06969fa
574fab0f-d02e-41c1-ad7e-ccae12655673	b3dcdadb-4ff8-46ea-a039-be35bbfef016
574fab0f-d02e-41c1-ad7e-ccae12655673	b4b98bb1-6aa1-4908-b96d-ca07fc2a38bd
574fab0f-d02e-41c1-ad7e-ccae12655673	e82325ef-23ad-4e32-9cdf-b47540259822
6fe748c8-3ea8-47c8-8471-15d85eabc0e8	2d829f87-0048-4417-90c8-a505d06969fa
52be68da-cea9-4e06-b029-8a0d8f04a8b4	6de41b64-7db8-4d38-9a3b-a10565ba1b96
52be68da-cea9-4e06-b029-8a0d8f04a8b4	b4b98bb1-6aa1-4908-b96d-ca07fc2a38bd
8108f9cd-2277-469e-90d9-3902d87aeffd	e82325ef-23ad-4e32-9cdf-b47540259822
e42b75f9-c709-4bd0-beac-4333775dfa6f	e317135f-e1b5-458a-ace7-8930d7ac0ccc
e42b75f9-c709-4bd0-beac-4333775dfa6f	40fdb277-9caa-4710-ad59-1e6c2452df70
40fdb277-9caa-4710-ad59-1e6c2452df70	7778e2a5-663e-4711-b006-f8f84239b701
5fdd983f-6b3d-4cbe-95b1-1deb2db4a71d	e75f0ad7-e190-438c-a604-8b96acf527f4
55c449af-77fa-4a46-a813-2e59895d2a9e	bac4d3c7-ed15-4a71-8c46-a04496bc4101
574fab0f-d02e-41c1-ad7e-ccae12655673	ce38e71d-907f-46d8-871a-79e1f8180d28
e42b75f9-c709-4bd0-beac-4333775dfa6f	48258be2-c7bc-45cc-89d6-66244d5cec66
e42b75f9-c709-4bd0-beac-4333775dfa6f	c03b2200-f5b9-40b5-b6b5-85ad68fdf4c0
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority, version) FROM stdin;
e3b4066f-e0a6-4e1f-a8db-707dc81b7b33	\N	password	43c72179-5374-4c43-ba1d-b3bbd92bded1	1792733484917	\N	{"value":"4cYz9N4OnqLu7iM2YWor3lHkK964htxx+jMmFL9lCjQ=","salt":"6yJqeaFYzsovWuoZ/ViwMg==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	0
de122eb6-9f08-42dd-9ca2-58c2057c8b7d	\N	password	c7ea15f0-810c-416c-a912-6ee86590f010	1793157855953	\N	{"value":"OXluhBkbIVCTO6vWmy03snSBJLFEtC/rh2o2d0HfBF8=","salt":"vqrfuie4BLvQxon4z2sSQw==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	1
68b0be80-3dfe-4d09-8122-4299e12849da	\N	password	f6e310f2-39a9-4774-a6f6-da6068e63ab8	1793157863273	\N	{"value":"nTbM5ZiBd6dyfYmFLaid3iwwNY/V8XfR4JPCxWb2/lQ=","salt":"2nIolxbHHUS18e0FtT/KKQ==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10	1
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2026-10-23 05:31:12.66296	1	EXECUTED	9:6f1016664e21e16d26517a4418f5e3df	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.33.0	\N	\N	2733469070
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2026-10-23 05:31:12.673103	2	MARK_RAN	9:828775b1596a07d1200ba1d49e5e3941	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.33.0	\N	\N	2733469070
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2026-10-23 05:31:12.701901	3	EXECUTED	9:5f090e44a7d595883c1fb61f4b41fd38	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.33.0	\N	\N	2733469070
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2026-10-23 05:31:12.708483	4	EXECUTED	9:c07e577387a3d2c04d1adc9aaad8730e	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.33.0	\N	\N	2733469070
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2026-10-23 05:31:12.784672	5	EXECUTED	9:b68ce996c655922dbcd2fe6b6ae72686	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.33.0	\N	\N	2733469070
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2026-10-23 05:31:12.788873	6	MARK_RAN	9:543b5c9989f024fe35c6f6c5a97de88e	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.33.0	\N	\N	2733469070
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2026-10-23 05:31:12.852226	7	EXECUTED	9:765afebbe21cf5bbca048e632df38336	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.33.0	\N	\N	2733469070
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2026-10-23 05:31:12.856921	8	MARK_RAN	9:db4a145ba11a6fdaefb397f6dbf829a1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.33.0	\N	\N	2733469070
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2026-10-23 05:31:12.866263	9	EXECUTED	9:9d05c7be10cdb873f8bcb41bc3a8ab23	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.33.0	\N	\N	2733469070
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2026-10-23 05:31:12.917746	10	EXECUTED	9:18593702353128d53111f9b1ff0b82b8	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.33.0	\N	\N	2733469070
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2026-10-23 05:31:12.954566	11	EXECUTED	9:6122efe5f090e41a85c0f1c9e52cbb62	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.33.0	\N	\N	2733469070
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2026-10-23 05:31:12.957819	12	MARK_RAN	9:e1ff28bf7568451453f844c5d54bb0b5	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.33.0	\N	\N	2733469070
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2026-10-23 05:31:12.978932	13	EXECUTED	9:7af32cd8957fbc069f796b61217483fd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.33.0	\N	\N	2733469070
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2026-10-23 05:31:12.99206	14	EXECUTED	9:6005e15e84714cd83226bf7879f54190	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.33.0	\N	\N	2733469070
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2026-10-23 05:31:12.994286	15	MARK_RAN	9:bf656f5a2b055d07f314431cae76f06c	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2026-10-23 05:31:12.997234	16	MARK_RAN	9:f8dadc9284440469dcf71e25ca6ab99b	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.33.0	\N	\N	2733469070
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2026-10-23 05:31:13.001373	17	EXECUTED	9:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.33.0	\N	\N	2733469070
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2026-10-23 05:31:13.032158	18	EXECUTED	9:3368ff0be4c2855ee2dd9ca813b38d8e	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.33.0	\N	\N	2733469070
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2026-10-23 05:31:13.069759	19	EXECUTED	9:8ac2fb5dd030b24c0570a763ed75ed20	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.33.0	\N	\N	2733469070
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2026-10-23 05:31:13.076259	20	EXECUTED	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.33.0	\N	\N	2733469070
22.0.5-24031	keycloak	META-INF/jpa-changelog-22.0.0.xml	2026-10-23 05:31:15.992344	119	MARK_RAN	9:a60d2d7b315ec2d3eba9e2f145f9df28	customChange		\N	4.33.0	\N	\N	2733469070
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2026-10-23 05:31:13.08055	21	MARK_RAN	9:831e82914316dc8a57dc09d755f23c51	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.33.0	\N	\N	2733469070
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2026-10-23 05:31:13.085838	22	MARK_RAN	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.33.0	\N	\N	2733469070
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2026-10-23 05:31:13.132637	23	EXECUTED	9:bc3d0f9e823a69dc21e23e94c7a94bb1	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.33.0	\N	\N	2733469070
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2026-10-23 05:31:13.139852	24	EXECUTED	9:c9999da42f543575ab790e76439a2679	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.33.0	\N	\N	2733469070
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2026-10-23 05:31:13.142207	25	MARK_RAN	9:0d6c65c6f58732d81569e77b10ba301d	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.33.0	\N	\N	2733469070
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2026-10-23 05:31:13.386696	26	EXECUTED	9:fc576660fc016ae53d2d4778d84d86d0	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.33.0	\N	\N	2733469070
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2026-10-23 05:31:13.43011	27	EXECUTED	9:43ed6b0da89ff77206289e87eaa9c024	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.33.0	\N	\N	2733469070
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2026-10-23 05:31:13.435327	28	EXECUTED	9:44bae577f551b3738740281eceb4ea70	update tableName=RESOURCE_SERVER_POLICY		\N	4.33.0	\N	\N	2733469070
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2026-10-23 05:31:13.469311	29	EXECUTED	9:bd88e1f833df0420b01e114533aee5e8	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.33.0	\N	\N	2733469070
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2026-10-23 05:31:13.47971	30	EXECUTED	9:a7022af5267f019d020edfe316ef4371	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.33.0	\N	\N	2733469070
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2026-10-23 05:31:13.494787	31	EXECUTED	9:fc155c394040654d6a79227e56f5e25a	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.33.0	\N	\N	2733469070
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2026-10-23 05:31:13.499979	32	EXECUTED	9:eac4ffb2a14795e5dc7b426063e54d88	customChange		\N	4.33.0	\N	\N	2733469070
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2026-10-23 05:31:13.506024	33	EXECUTED	9:54937c05672568c4c64fc9524c1e9462	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2026-10-23 05:31:13.508224	34	MARK_RAN	9:f9753208029f582525ed12011a19d054	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.33.0	\N	\N	2733469070
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2026-10-23 05:31:13.529507	35	EXECUTED	9:33d72168746f81f98ae3a1e8e0ca3554	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.33.0	\N	\N	2733469070
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2026-10-23 05:31:13.537188	36	EXECUTED	9:61b6d3d7a4c0e0024b0c839da283da0c	addColumn tableName=REALM		\N	4.33.0	\N	\N	2733469070
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2026-10-23 05:31:13.543107	37	EXECUTED	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	2733469070
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2026-10-23 05:31:13.549099	38	EXECUTED	9:a2b870802540cb3faa72098db5388af3	addColumn tableName=FED_USER_CONSENT		\N	4.33.0	\N	\N	2733469070
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2026-10-23 05:31:13.55406	39	EXECUTED	9:132a67499ba24bcc54fb5cbdcfe7e4c0	addColumn tableName=IDENTITY_PROVIDER		\N	4.33.0	\N	\N	2733469070
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2026-10-23 05:31:13.555892	40	MARK_RAN	9:938f894c032f5430f2b0fafb1a243462	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.33.0	\N	\N	2733469070
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2026-10-23 05:31:13.558059	41	MARK_RAN	9:845c332ff1874dc5d35974b0babf3006	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.33.0	\N	\N	2733469070
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2026-10-23 05:31:13.562513	42	EXECUTED	9:fc86359c079781adc577c5a217e4d04c	customChange		\N	4.33.0	\N	\N	2733469070
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2026-10-23 05:31:14.497053	43	EXECUTED	9:59a64800e3c0d09b825f8a3b444fa8f4	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.33.0	\N	\N	2733469070
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2026-10-23 05:31:14.503479	44	EXECUTED	9:d48d6da5c6ccf667807f633fe489ce88	addColumn tableName=USER_ENTITY		\N	4.33.0	\N	\N	2733469070
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-10-23 05:31:14.50919	45	EXECUTED	9:dde36f7973e80d71fceee683bc5d2951	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.33.0	\N	\N	2733469070
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-10-23 05:31:14.514152	46	EXECUTED	9:b855e9b0a406b34fa323235a0cf4f640	customChange		\N	4.33.0	\N	\N	2733469070
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-10-23 05:31:14.518089	47	MARK_RAN	9:51abbacd7b416c50c4421a8cabf7927e	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.33.0	\N	\N	2733469070
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-10-23 05:31:14.599171	48	EXECUTED	9:bdc99e567b3398bac83263d375aad143	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.33.0	\N	\N	2733469070
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-10-23 05:31:14.604436	49	EXECUTED	9:d198654156881c46bfba39abd7769e69	addColumn tableName=REALM		\N	4.33.0	\N	\N	2733469070
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2026-10-23 05:31:14.623434	50	EXECUTED	9:cfdd8736332ccdd72c5256ccb42335db	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.33.0	\N	\N	2733469070
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2026-10-23 05:31:14.83197	51	EXECUTED	9:7c84de3d9bd84d7f077607c1a4dcb714	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.33.0	\N	\N	2733469070
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2026-10-23 05:31:14.838849	52	EXECUTED	9:5a6bb36cbefb6a9d6928452c0852af2d	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	2733469070
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2026-10-23 05:31:14.842664	53	EXECUTED	9:8f23e334dbc59f82e0a328373ca6ced0	update tableName=REALM		\N	4.33.0	\N	\N	2733469070
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2026-10-23 05:31:14.847901	54	EXECUTED	9:9156214268f09d970cdf0e1564d866af	update tableName=CLIENT		\N	4.33.0	\N	\N	2733469070
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2026-10-23 05:31:14.858167	55	EXECUTED	9:db806613b1ed154826c02610b7dbdf74	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.33.0	\N	\N	2733469070
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2026-10-23 05:31:14.865741	56	EXECUTED	9:229a041fb72d5beac76bb94a5fa709de	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.33.0	\N	\N	2733469070
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2026-10-23 05:31:14.895477	57	EXECUTED	9:079899dade9c1e683f26b2aa9ca6ff04	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.33.0	\N	\N	2733469070
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2026-10-23 05:31:15.28863	58	EXECUTED	9:139b79bcbbfe903bb1c2d2a4dbf001d9	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.33.0	\N	\N	2733469070
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2026-10-23 05:31:15.309467	59	EXECUTED	9:b55738ad889860c625ba2bf483495a04	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.33.0	\N	\N	2733469070
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2026-10-23 05:31:15.317295	60	EXECUTED	9:e0057eac39aa8fc8e09ac6cfa4ae15fe	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.33.0	\N	\N	2733469070
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2026-10-23 05:31:15.327892	61	EXECUTED	9:42a33806f3a0443fe0e7feeec821326c	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.33.0	\N	\N	2733469070
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2026-10-23 05:31:15.336377	62	EXECUTED	9:9968206fca46eecc1f51db9c024bfe56	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.33.0	\N	\N	2733469070
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2026-10-23 05:31:15.341819	63	EXECUTED	9:92143a6daea0a3f3b8f598c97ce55c3d	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.33.0	\N	\N	2733469070
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2026-10-23 05:31:15.345579	64	EXECUTED	9:82bab26a27195d889fb0429003b18f40	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.33.0	\N	\N	2733469070
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2026-10-23 05:31:15.349806	65	EXECUTED	9:e590c88ddc0b38b0ae4249bbfcb5abc3	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.33.0	\N	\N	2733469070
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2026-10-23 05:31:15.379659	66	EXECUTED	9:5c1f475536118dbdc38d5d7977950cc0	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.33.0	\N	\N	2733469070
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2026-10-23 05:31:15.403546	67	EXECUTED	9:e7c9f5f9c4d67ccbbcc215440c718a17	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.33.0	\N	\N	2733469070
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2026-10-23 05:31:15.408968	68	EXECUTED	9:88e0bfdda924690d6f4e430c53447dd5	addColumn tableName=REALM		\N	4.33.0	\N	\N	2733469070
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2026-10-23 05:31:15.436594	69	EXECUTED	9:f53177f137e1c46b6a88c59ec1cb5218	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.33.0	\N	\N	2733469070
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2026-10-23 05:31:15.443786	70	EXECUTED	9:a74d33da4dc42a37ec27121580d1459f	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.33.0	\N	\N	2733469070
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2026-10-23 05:31:15.450074	71	EXECUTED	9:fd4ade7b90c3b67fae0bfcfcb42dfb5f	addColumn tableName=RESOURCE_SERVER		\N	4.33.0	\N	\N	2733469070
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-10-23 05:31:15.458153	72	EXECUTED	9:aa072ad090bbba210d8f18781b8cebf4	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.33.0	\N	\N	2733469070
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-10-23 05:31:15.466306	73	EXECUTED	9:1ae6be29bab7c2aa376f6983b932be37	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.33.0	\N	\N	2733469070
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-10-23 05:31:15.469483	74	MARK_RAN	9:14706f286953fc9a25286dbd8fb30d97	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.33.0	\N	\N	2733469070
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-10-23 05:31:15.492137	75	EXECUTED	9:2b9cc12779be32c5b40e2e67711a218b	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.33.0	\N	\N	2733469070
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-10-23 05:31:15.517833	76	EXECUTED	9:91fa186ce7a5af127a2d7a91ee083cc5	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.33.0	\N	\N	2733469070
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2026-10-23 05:31:15.527413	77	EXECUTED	9:6335e5c94e83a2639ccd68dd24e2e5ad	addColumn tableName=CLIENT		\N	4.33.0	\N	\N	2733469070
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2026-10-23 05:31:15.529782	78	MARK_RAN	9:6bdb5658951e028bfe16fa0a8228b530	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.33.0	\N	\N	2733469070
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2026-10-23 05:31:15.550606	79	EXECUTED	9:d5bc15a64117ccad481ce8792d4c608f	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.33.0	\N	\N	2733469070
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2026-10-23 05:31:15.553226	80	MARK_RAN	9:077cba51999515f4d3e7ad5619ab592c	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.33.0	\N	\N	2733469070
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-10-23 05:31:15.57669	81	EXECUTED	9:be969f08a163bf47c6b9e9ead8ac2afb	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.33.0	\N	\N	2733469070
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-10-23 05:31:15.57855	82	MARK_RAN	9:6d3bb4408ba5a72f39bd8a0b301ec6e3	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	2733469070
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-10-23 05:31:15.583602	83	EXECUTED	9:966bda61e46bebf3cc39518fbed52fa7	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	2733469070
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-10-23 05:31:15.585708	84	MARK_RAN	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	2733469070
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-10-23 05:31:15.608477	85	EXECUTED	9:7d93d602352a30c0c317e6a609b56599	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.33.0	\N	\N	2733469070
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2026-10-23 05:31:15.614195	86	EXECUTED	9:71c5969e6cdd8d7b6f47cebc86d37627	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.33.0	\N	\N	2733469070
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2026-10-23 05:31:15.624221	87	EXECUTED	9:a9ba7d47f065f041b7da856a81762021	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.33.0	\N	\N	2733469070
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2026-10-23 05:31:15.630953	88	EXECUTED	9:fffabce2bc01e1a8f5110d5278500065	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.33.0	\N	\N	2733469070
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-10-23 05:31:15.638339	89	EXECUTED	9:fa8a5b5445e3857f4b010bafb5009957	addColumn tableName=REALM; customChange		\N	4.33.0	\N	\N	2733469070
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-10-23 05:31:15.647246	90	EXECUTED	9:67ac3241df9a8582d591c5ed87125f39	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.33.0	\N	\N	2733469070
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-10-23 05:31:15.670621	91	EXECUTED	9:ad1194d66c937e3ffc82386c050ba089	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-10-23 05:31:15.679984	92	EXECUTED	9:d9be619d94af5a2f5d07b9f003543b91	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.33.0	\N	\N	2733469070
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-10-23 05:31:15.682068	93	MARK_RAN	9:544d201116a0fcc5a5da0925fbbc3bde	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.33.0	\N	\N	2733469070
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-10-23 05:31:15.689971	94	EXECUTED	9:43c0c1055b6761b4b3e89de76d612ccf	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.33.0	\N	\N	2733469070
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-10-23 05:31:15.691872	95	MARK_RAN	9:8bd711fd0330f4fe980494ca43ab1139	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.33.0	\N	\N	2733469070
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-10-23 05:31:15.697039	96	EXECUTED	9:e07d2bc0970c348bb06fb63b1f82ddbf	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.33.0	\N	\N	2733469070
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-10-23 05:31:15.757185	97	EXECUTED	9:24fb8611e97f29989bea412aa38d12b7	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-10-23 05:31:15.760315	98	MARK_RAN	9:259f89014ce2506ee84740cbf7163aa7	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	2733469070
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-10-23 05:31:15.771237	99	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	2733469070
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-10-23 05:31:15.793087	100	EXECUTED	9:60ca84a0f8c94ec8c3504a5a3bc88ee8	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	2733469070
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-10-23 05:31:15.794993	101	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	2733469070
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-10-23 05:31:15.815328	102	EXECUTED	9:0b305d8d1277f3a89a0a53a659ad274c	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.33.0	\N	\N	2733469070
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-10-23 05:31:15.81957	103	EXECUTED	9:2c374ad2cdfe20e2905a84c8fac48460	customChange		\N	4.33.0	\N	\N	2733469070
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2026-10-23 05:31:15.826189	104	EXECUTED	9:47a760639ac597360a8219f5b768b4de	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.33.0	\N	\N	2733469070
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2026-10-23 05:31:15.849445	105	EXECUTED	9:a6272f0576727dd8cad2522335f5d99e	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.33.0	\N	\N	2733469070
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2026-10-23 05:31:15.873506	106	EXECUTED	9:015479dbd691d9cc8669282f4828c41d	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.33.0	\N	\N	2733469070
18.0.15-30992-index-consent	keycloak	META-INF/jpa-changelog-18.0.15.xml	2026-10-23 05:31:15.89716	107	EXECUTED	9:80071ede7a05604b1f4906f3bf3b00f0	createIndex indexName=IDX_USCONSENT_SCOPE_ID, tableName=USER_CONSENT_CLIENT_SCOPE		\N	4.33.0	\N	\N	2733469070
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2026-10-23 05:31:15.901138	108	EXECUTED	9:9518e495fdd22f78ad6425cc30630221	customChange		\N	4.33.0	\N	\N	2733469070
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2026-10-23 05:31:15.92215	109	EXECUTED	9:e5f243877199fd96bcc842f27a1656ac	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.33.0	\N	\N	2733469070
20.0.0-12964-supported-dbs-edb-migration	keycloak	META-INF/jpa-changelog-20.0.0.xml	2026-10-23 05:31:15.952459	110	EXECUTED	9:a6b18a8e38062df5793edbe064f4aecd	dropIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE; createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.33.0	\N	\N	2733469070
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2026-10-23 05:31:15.954762	111	MARK_RAN	9:1a6fcaa85e20bdeae0a9ce49b41946a5	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.33.0	\N	\N	2733469070
client-attributes-string-accomodation-fixed-pre-drop-index	keycloak	META-INF/jpa-changelog-20.0.0.xml	2026-10-23 05:31:15.959459	112	EXECUTED	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	2733469070
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2026-10-23 05:31:15.966843	113	EXECUTED	9:3f332e13e90739ed0c35b0b25b7822ca	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	2733469070
client-attributes-string-accomodation-fixed-post-create-index	keycloak	META-INF/jpa-changelog-20.0.0.xml	2026-10-23 05:31:15.969319	114	MARK_RAN	9:bd2bd0fc7768cf0845ac96a8786fa735	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	2733469070
21.0.2-17277	keycloak	META-INF/jpa-changelog-21.0.2.xml	2026-10-23 05:31:15.973414	115	EXECUTED	9:7ee1f7a3fb8f5588f171fb9a6ab623c0	customChange		\N	4.33.0	\N	\N	2733469070
21.1.0-19404	keycloak	META-INF/jpa-changelog-21.1.0.xml	2026-10-23 05:31:15.984903	116	EXECUTED	9:3d7e830b52f33676b9d64f7f2b2ea634	modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER		\N	4.33.0	\N	\N	2733469070
21.1.0-19404-2	keycloak	META-INF/jpa-changelog-21.1.0.xml	2026-10-23 05:31:15.986996	117	MARK_RAN	9:627d032e3ef2c06c0e1f73d2ae25c26c	addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...		\N	4.33.0	\N	\N	2733469070
22.0.0-17484-updated	keycloak	META-INF/jpa-changelog-22.0.0.xml	2026-10-23 05:31:15.9906	118	EXECUTED	9:90af0bfd30cafc17b9f4d6eccd92b8b3	customChange		\N	4.33.0	\N	\N	2733469070
23.0.0-12062	keycloak	META-INF/jpa-changelog-23.0.0.xml	2026-10-23 05:31:15.997153	120	EXECUTED	9:2168fbe728fec46ae9baf15bf80927b8	addColumn tableName=COMPONENT_CONFIG; update tableName=COMPONENT_CONFIG; dropColumn columnName=VALUE, tableName=COMPONENT_CONFIG; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=COMPONENT_CONFIG		\N	4.33.0	\N	\N	2733469070
23.0.0-17258	keycloak	META-INF/jpa-changelog-23.0.0.xml	2026-10-23 05:31:16.002438	121	EXECUTED	9:36506d679a83bbfda85a27ea1864dca8	addColumn tableName=EVENT_ENTITY		\N	4.33.0	\N	\N	2733469070
24.0.0-9758	keycloak	META-INF/jpa-changelog-24.0.0.xml	2026-10-23 05:31:16.080978	122	EXECUTED	9:502c557a5189f600f0f445a9b49ebbce	addColumn tableName=USER_ATTRIBUTE; addColumn tableName=FED_USER_ATTRIBUTE; createIndex indexName=USER_ATTR_LONG_VALUES, tableName=USER_ATTRIBUTE; createIndex indexName=FED_USER_ATTR_LONG_VALUES, tableName=FED_USER_ATTRIBUTE; createIndex indexName...		\N	4.33.0	\N	\N	2733469070
24.0.0-9758-2	keycloak	META-INF/jpa-changelog-24.0.0.xml	2026-10-23 05:31:16.086219	123	EXECUTED	9:bf0fdee10afdf597a987adbf291db7b2	customChange		\N	4.33.0	\N	\N	2733469070
24.0.0-26618-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.0.xml	2026-10-23 05:31:16.09179	124	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	2733469070
24.0.0-26618-reindex	keycloak	META-INF/jpa-changelog-24.0.0.xml	2026-10-23 05:31:16.113816	125	EXECUTED	9:08707c0f0db1cef6b352db03a60edc7f	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	2733469070
24.0.0-26618-edb-migration	keycloak	META-INF/jpa-changelog-24.0.0.xml	2026-10-23 05:31:16.143825	126	EXECUTED	9:2f684b29d414cd47efe3a3599f390741	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES; createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	2733469070
24.0.2-27228	keycloak	META-INF/jpa-changelog-24.0.2.xml	2026-10-23 05:31:16.148607	127	EXECUTED	9:eaee11f6b8aa25d2cc6a84fb86fc6238	customChange		\N	4.33.0	\N	\N	2733469070
24.0.2-27967-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.2.xml	2026-10-23 05:31:16.151702	128	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	2733469070
24.0.2-27967-reindex	keycloak	META-INF/jpa-changelog-24.0.2.xml	2026-10-23 05:31:16.154849	129	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.33.0	\N	\N	2733469070
25.0.0-28265-tables	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-10-23 05:31:16.163085	130	EXECUTED	9:deda2df035df23388af95bbd36c17cef	addColumn tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	2733469070
25.0.0-28265-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-10-23 05:31:16.187826	131	EXECUTED	9:3e96709818458ae49f3c679ae58d263a	createIndex indexName=IDX_OFFLINE_USS_BY_LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
25.0.0-28265-index-cleanup-uss-createdon	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-10-23 05:31:16.196119	132	EXECUTED	9:78ab4fc129ed5e8265dbcc3485fba92f	dropIndex indexName=IDX_OFFLINE_USS_CREATEDON, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
25.0.0-28265-index-cleanup-uss-preload	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-10-23 05:31:16.204189	133	EXECUTED	9:de5f7c1f7e10994ed8b62e621d20eaab	dropIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
25.0.0-28265-index-cleanup-uss-by-usersess	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-10-23 05:31:16.212863	134	EXECUTED	9:6eee220d024e38e89c799417ec33667f	dropIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
25.0.0-28265-index-cleanup-css-preload	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-10-23 05:31:16.227347	135	EXECUTED	9:5411d2fb2891d3e8d63ddb55dfa3c0c9	dropIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	2733469070
25.0.0-28265-index-2-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-10-23 05:31:16.229554	136	MARK_RAN	9:b7ef76036d3126bb83c2423bf4d449d6	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
25.0.0-28265-index-2-not-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-10-23 05:31:16.256364	137	EXECUTED	9:23396cf51ab8bc1ae6f0cac7f9f6fcf7	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
25.0.0-org	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-10-23 05:31:16.266512	138	EXECUTED	9:5c859965c2c9b9c72136c360649af157	createTable tableName=ORG; addUniqueConstraint constraintName=UK_ORG_NAME, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_GROUP, tableName=ORG; createTable tableName=ORG_DOMAIN		\N	4.33.0	\N	\N	2733469070
unique-consentuser	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-10-23 05:31:16.27489	139	EXECUTED	9:5857626a2ea8767e9a6c66bf3a2cb32f	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.33.0	\N	\N	2733469070
unique-consentuser-edb-migration	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-10-23 05:31:16.281392	140	MARK_RAN	9:5857626a2ea8767e9a6c66bf3a2cb32f	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.33.0	\N	\N	2733469070
unique-consentuser-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-10-23 05:31:16.284081	141	MARK_RAN	9:b79478aad5adaa1bc428e31563f55e8e	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.33.0	\N	\N	2733469070
25.0.0-28861-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-10-23 05:31:16.326872	142	EXECUTED	9:b9acb58ac958d9ada0fe12a5d4794ab1	createIndex indexName=IDX_PERM_TICKET_REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; createIndex indexName=IDX_PERM_TICKET_OWNER, tableName=RESOURCE_SERVER_PERM_TICKET		\N	4.33.0	\N	\N	2733469070
26.0.0-org-alias	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-10-23 05:31:16.338237	143	EXECUTED	9:6ef7d63e4412b3c2d66ed179159886a4	addColumn tableName=ORG; update tableName=ORG; addNotNullConstraint columnName=ALIAS, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_ALIAS, tableName=ORG		\N	4.33.0	\N	\N	2733469070
26.0.0-org-group	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-10-23 05:31:16.344941	144	EXECUTED	9:da8e8087d80ef2ace4f89d8c5b9ca223	addColumn tableName=KEYCLOAK_GROUP; update tableName=KEYCLOAK_GROUP; addNotNullConstraint columnName=TYPE, tableName=KEYCLOAK_GROUP; customChange		\N	4.33.0	\N	\N	2733469070
26.0.0-org-indexes	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-10-23 05:31:16.371254	145	EXECUTED	9:79b05dcd610a8c7f25ec05135eec0857	createIndex indexName=IDX_ORG_DOMAIN_ORG_ID, tableName=ORG_DOMAIN		\N	4.33.0	\N	\N	2733469070
26.0.0-org-group-membership	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-10-23 05:31:16.375905	146	EXECUTED	9:a6ace2ce583a421d89b01ba2a28dc2d4	addColumn tableName=USER_GROUP_MEMBERSHIP; update tableName=USER_GROUP_MEMBERSHIP; addNotNullConstraint columnName=MEMBERSHIP_TYPE, tableName=USER_GROUP_MEMBERSHIP		\N	4.33.0	\N	\N	2733469070
31296-persist-revoked-access-tokens	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-10-23 05:31:16.38134	147	EXECUTED	9:64ef94489d42a358e8304b0e245f0ed4	createTable tableName=REVOKED_TOKEN; addPrimaryKey constraintName=CONSTRAINT_RT, tableName=REVOKED_TOKEN		\N	4.33.0	\N	\N	2733469070
31725-index-persist-revoked-access-tokens	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-10-23 05:31:16.418415	148	EXECUTED	9:b994246ec2bf7c94da881e1d28782c7b	createIndex indexName=IDX_REV_TOKEN_ON_EXPIRE, tableName=REVOKED_TOKEN		\N	4.33.0	\N	\N	2733469070
26.0.0-idps-for-login	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-10-23 05:31:16.503175	149	EXECUTED	9:51f5fffadf986983d4bd59582c6c1604	addColumn tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_REALM_ORG, tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER; customChange		\N	4.33.0	\N	\N	2733469070
26.0.0-32583-drop-redundant-index-on-client-session	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-10-23 05:31:16.511848	150	EXECUTED	9:24972d83bf27317a055d234187bb4af9	dropIndex indexName=IDX_US_SESS_ID_ON_CL_SESS, tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	2733469070
26.0.0.32582-remove-tables-user-session-user-session-note-and-client-session	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-10-23 05:31:16.534487	151	EXECUTED	9:febdc0f47f2ed241c59e60f58c3ceea5	dropTable tableName=CLIENT_SESSION_ROLE; dropTable tableName=CLIENT_SESSION_NOTE; dropTable tableName=CLIENT_SESSION_PROT_MAPPER; dropTable tableName=CLIENT_SESSION_AUTH_STATUS; dropTable tableName=CLIENT_USER_SESSION_NOTE; dropTable tableName=CLI...		\N	4.33.0	\N	\N	2733469070
26.0.0-33201-org-redirect-url	keycloak	META-INF/jpa-changelog-26.0.0.xml	2026-10-23 05:31:16.540332	152	EXECUTED	9:4d0e22b0ac68ebe9794fa9cb752ea660	addColumn tableName=ORG		\N	4.33.0	\N	\N	2733469070
29399-jdbc-ping-default	keycloak	META-INF/jpa-changelog-26.1.0.xml	2026-10-23 05:31:16.548976	153	EXECUTED	9:007dbe99d7203fca403b89d4edfdf21e	createTable tableName=JGROUPS_PING; addPrimaryKey constraintName=CONSTRAINT_JGROUPS_PING, tableName=JGROUPS_PING		\N	4.33.0	\N	\N	2733469070
26.1.0-34013	keycloak	META-INF/jpa-changelog-26.1.0.xml	2026-10-23 05:31:16.556706	154	EXECUTED	9:e6b686a15759aef99a6d758a5c4c6a26	addColumn tableName=ADMIN_EVENT_ENTITY		\N	4.33.0	\N	\N	2733469070
26.1.0-34380	keycloak	META-INF/jpa-changelog-26.1.0.xml	2026-10-23 05:31:16.56281	155	EXECUTED	9:ac8b9edb7c2b6c17a1c7a11fcf5ccf01	dropTable tableName=USERNAME_LOGIN_FAILURE		\N	4.33.0	\N	\N	2733469070
26.2.0-36750	keycloak	META-INF/jpa-changelog-26.2.0.xml	2026-10-23 05:31:16.570998	156	EXECUTED	9:b49ce951c22f7eb16480ff085640a33a	createTable tableName=SERVER_CONFIG		\N	4.33.0	\N	\N	2733469070
26.2.0-26106	keycloak	META-INF/jpa-changelog-26.2.0.xml	2026-10-23 05:31:16.575969	157	EXECUTED	9:b5877d5dab7d10ff3a9d209d7beb6680	addColumn tableName=CREDENTIAL		\N	4.33.0	\N	\N	2733469070
26.2.6-39866-duplicate	keycloak	META-INF/jpa-changelog-26.2.6.xml	2026-10-23 05:31:16.58088	158	EXECUTED	9:1dc67ccee24f30331db2cba4f372e40e	customChange		\N	4.33.0	\N	\N	2733469070
26.2.6-39866-uk	keycloak	META-INF/jpa-changelog-26.2.6.xml	2026-10-23 05:31:16.587463	159	EXECUTED	9:b70b76f47210cf0a5f4ef0e219eac7cd	addUniqueConstraint constraintName=UK_MIGRATION_VERSION, tableName=MIGRATION_MODEL		\N	4.33.0	\N	\N	2733469070
26.2.6-40088-duplicate	keycloak	META-INF/jpa-changelog-26.2.6.xml	2026-10-23 05:31:16.591701	160	EXECUTED	9:cc7e02ed69ab31979afb1982f9670e8f	customChange		\N	4.33.0	\N	\N	2733469070
26.2.6-40088-uk	keycloak	META-INF/jpa-changelog-26.2.6.xml	2026-10-23 05:31:16.596321	161	EXECUTED	9:5bb848128da7bc4595cc507383325241	addUniqueConstraint constraintName=UK_MIGRATION_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.33.0	\N	\N	2733469070
26.3.0-groups-description	keycloak	META-INF/jpa-changelog-26.3.0.xml	2026-10-23 05:31:16.603207	162	EXECUTED	9:e1a3c05574326fb5b246b73b9a4c4d49	addColumn tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	2733469070
26.4.0-40933-saml-encryption-attributes	keycloak	META-INF/jpa-changelog-26.4.0.xml	2026-10-23 05:31:16.607647	163	EXECUTED	9:7e9eaba362ca105efdda202303a4fe49	customChange		\N	4.33.0	\N	\N	2733469070
26.4.0-51321	keycloak	META-INF/jpa-changelog-26.4.0.xml	2026-10-23 05:31:16.666036	164	EXECUTED	9:34bab2bc56f75ffd7e347c580874e306	createIndex indexName=IDX_EVENT_ENTITY_USER_ID_TYPE, tableName=EVENT_ENTITY		\N	4.33.0	\N	\N	2733469070
40343-workflow-state-table	keycloak	META-INF/jpa-changelog-26.4.0.xml	2026-10-23 05:31:16.745416	165	EXECUTED	9:ed3ab4723ceed210e5b5e60ac4562106	createTable tableName=WORKFLOW_STATE; addPrimaryKey constraintName=PK_WORKFLOW_STATE, tableName=WORKFLOW_STATE; addUniqueConstraint constraintName=UQ_WORKFLOW_RESOURCE, tableName=WORKFLOW_STATE; createIndex indexName=IDX_WORKFLOW_STATE_STEP, table...		\N	4.33.0	\N	\N	2733469070
26.5.0-index-offline-css-by-client	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-10-23 05:31:16.782846	166	EXECUTED	9:383e981ce95d16e32af757b7998820f7	createIndex indexName=IDX_OFFLINE_CSS_BY_CLIENT, tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	2733469070
26.5.0-index-offline-css-by-client-storage-provider	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-10-23 05:31:16.831915	167	EXECUTED	9:f5bc200e6fa7d7e483854dee535ca425	createIndex indexName=IDX_OFFLINE_CSS_BY_CLIENT_STORAGE_PROVIDER, tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	2733469070
26.5.0-idp-config-allow-null-fixed-drop-mssql-index	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-10-23 05:31:16.844037	168	MARK_RAN	9:50c51d2c98cd1d624eb1c485c3cf1f75	dropIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER		\N	4.33.0	\N	\N	2733469070
26.5.0-idp-config-allow-null	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-10-23 05:31:16.864627	169	EXECUTED	9:b667fb087874303b324c1af7fae4f606	dropDefaultValue columnName=TRUST_EMAIL, tableName=IDENTITY_PROVIDER; dropNotNullConstraint columnName=TRUST_EMAIL, tableName=IDENTITY_PROVIDER; dropNotNullConstraint columnName=STORE_TOKEN, tableName=IDENTITY_PROVIDER; dropDefaultValue columnName...		\N	4.33.0	\N	\N	2733469070
26.5.0-idp-config-allow-null-fixed-create-mssql-index	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-10-23 05:31:16.867437	170	MARK_RAN	9:dcbbb24c151c3b0b59f12fede23cc94d	createIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER		\N	4.33.0	\N	\N	2733469070
26.5.0-remove-workflow-provider-id-column	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-10-23 05:31:16.903918	171	EXECUTED	9:d8eeb324484d45e946d03b953e168b21	dropIndex indexName=IDX_WORKFLOW_STATE_PROVIDER, tableName=WORKFLOW_STATE; createIndex indexName=IDX_WORKFLOW_STATE_PROVIDER, tableName=WORKFLOW_STATE; dropColumn columnName=WORKFLOW_PROVIDER_ID, tableName=WORKFLOW_STATE		\N	4.33.0	\N	\N	2733469070
26.5.0-add-remember-me	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-10-23 05:31:16.909993	172	EXECUTED	9:a7273ea8b21bd2f674c9c49141999f05	addColumn tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
26.5.0-add-sess-refresh-idx	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-10-23 05:31:16.950669	173	EXECUTED	9:ce49383d317ccbcd3434d1f21172b0b7	createIndex indexName=IDX_USER_SESSION_EXPIRATION_CREATED, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
26.5.0-add-sess-create-idx	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-10-23 05:31:16.988899	174	EXECUTED	9:aaee09e23a4d8468fbc5c51b7b314c58	createIndex indexName=IDX_USER_SESSION_EXPIRATION_LAST_REFRESH, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
26.5.0-drop-sess-refresh-idx	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-10-23 05:31:16.997421	175	EXECUTED	9:f0082210b6ccbbaf81287c27aa23753c	dropIndex indexName=IDX_OFFLINE_USS_BY_LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
26.5.0-mysql-mariadb-default-charset-collation	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-10-23 05:31:17.000102	176	MARK_RAN	9:1b383fa60d2db0a8952b365e725f9d16	customChange		\N	4.33.0	\N	\N	2733469070
26.5.0-invitations-table-fixed2	keycloak	META-INF/jpa-changelog-26.5.0.xml	2026-10-23 05:31:17.094279	177	EXECUTED	9:322cb11fc03181903dcd67a54f8b3cf0	createTable tableName=ORG_INVITATION; addForeignKeyConstraint baseTableName=ORG_INVITATION, constraintName=FK_ORG_INVITATION_ORG, referencedTableName=ORG; createIndex indexName=IDX_ORG_INVITATION_ORG_ID, tableName=ORG_INVITATION; createIndex index...		\N	4.33.0	\N	\N	2733469070
26.6.0-45009-broker-link-user-id	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-10-23 05:31:17.128802	178	EXECUTED	9:05026bbbc8d2ead5afcbda2f5fdf3a2b	createIndex indexName=IDX_BROKER_LINK_USER_ID, tableName=BROKER_LINK		\N	4.33.0	\N	\N	2733469070
26.6.0-45009-broker-link-identity-provider	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-10-23 05:31:17.16234	179	EXECUTED	9:7d9a0253c9de7be754efef8bba4265bd	createIndex indexName=IDX_BROKER_LINK_IDENTITY_PROVIDER, tableName=BROKER_LINK		\N	4.33.0	\N	\N	2733469070
26.6.0-org-group-relationship	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-10-23 05:31:17.198068	180	EXECUTED	9:05685853fba030f53548ac6bf23245e3	addColumn tableName=KEYCLOAK_GROUP; addForeignKeyConstraint baseTableName=KEYCLOAK_GROUP, constraintName=FK_GROUP_ORGANIZATION, referencedTableName=ORG; createIndex indexName=IDX_GROUP_ORG_ID, tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	2733469070
26.6.0-44424-index-css-user-session-and-offline	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-10-23 05:31:17.235732	181	EXECUTED	9:a704d8598df241a3fd3cb91b6ab4b2d4	createIndex indexName=IDX_OFFLINE_CSS_BY_USER_SESSION_AND_OFFLINE, tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	2733469070
26.6.0-44424-create-realm-in-client-session	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-10-23 05:31:17.243201	182	EXECUTED	9:77dbbc72d943e98cfe472ba8cc56a31c	addColumn tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	2733469070
26.6.0-44424-set-realm-in-client-session	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-10-23 05:31:17.248303	183	EXECUTED	9:3964a3148d32a55ef81126e23cdf6721	customChange		\N	4.33.0	\N	\N	2733469070
26.6.0-44424-idx-css-realm-and-clients	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-10-23 05:31:17.285764	184	EXECUTED	9:a093877fff41185ac24103be80e00968	createIndex indexName=IDX_OFFLINE_CSS_BY_CLIENT_AND_REALM, tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	2733469070
26.6.0-add-last-modified-timestamp-user	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-10-23 05:31:17.291503	185	EXECUTED	9:8aa583d2cdd9e913dff42fecd626c560	addColumn tableName=USER_ENTITY		\N	4.33.0	\N	\N	2733469070
26.6.0-add-timestamps-group	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-10-23 05:31:17.306513	186	EXECUTED	9:4363d45dc25105a3fc5db9ff6936b0a9	addColumn tableName=KEYCLOAK_GROUP		\N	4.33.0	\N	\N	2733469070
26.6.0-43829-user-created-timestamp-index	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-10-23 05:31:17.3564	187	EXECUTED	9:f2531a49b8bb21a7a97966d88fd1a411	createIndex indexName=IDX_USER_CREATED_TIMESTAMP, tableName=USER_ENTITY		\N	4.33.0	\N	\N	2733469070
26.6.0-48716-create-mssql-idp-index	keycloak	META-INF/jpa-changelog-26.6.0.xml	2026-10-23 05:31:17.358634	188	MARK_RAN	9:dcbbb24c151c3b0b59f12fede23cc94d	createIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER		\N	4.33.0	\N	\N	2733469070
26.7.0-jdbcping-timestamp	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:17.364102	189	EXECUTED	9:9a91f62e494bd013594e007b74d01638	addColumn tableName=JGROUPS_PING		\N	4.33.0	\N	\N	2733469070
26.7.0-45292-realm-display-name-add-column	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:17.370582	190	EXECUTED	9:1de8c7824ce4fd7c739db6195f42be21	addColumn tableName=REALM		\N	4.33.0	\N	\N	2733469070
26.7.0-45292-realm-display-name-migrate-data	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:17.374763	191	EXECUTED	9:293096bc554dd51428d1d9882f2de1dd	customChange		\N	4.33.0	\N	\N	2733469070
26.7.0-45292-realm-display-name-remove-attribute	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:17.377714	192	EXECUTED	9:a08357e3b0908c09d478e692cf82f865	delete tableName=REALM_ATTRIBUTE		\N	4.33.0	\N	\N	2733469070
26.7.0-verifiable-credential	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:17.388746	193	EXECUTED	9:68d8df23794085e79ba08b5046cba31d	createTable tableName=USER_VER_CREDENTIAL; addPrimaryKey constraintName=CONSTRAINT_VCRED_PM, tableName=USER_VER_CREDENTIAL; addForeignKeyConstraint baseTableName=USER_VER_CREDENTIAL, constraintName=FK_VCRED_USER, referencedTableName=USER_ENTITY; a...		\N	4.33.0	\N	\N	2733469070
26.7.0-federated-verifiable-credentials-1	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:17.425168	194	EXECUTED	9:49092fa73b1c2b3afca48d91b8111c65	createTable tableName=FED_USER_VER_CREDENTIAL; addUniqueConstraint constraintName=UK_FED_USER_VC, tableName=FED_USER_VER_CREDENTIAL; createIndex indexName=IDX_FED_USER_VC_REALM_USER, tableName=FED_USER_VER_CREDENTIAL		\N	4.33.0	\N	\N	2733469070
26.7.0-outbox	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:17.545307	195	EXECUTED	9:338b2743ca1be95f895d8f9b0cbe7b55	createTable tableName=OUTBOX_ENTRY; addUniqueConstraint constraintName=UC_OUTBOX_KIND_OWNER_CORRELATION, tableName=OUTBOX_ENTRY; createIndex indexName=IDX_OUTBOX_DRAIN, tableName=OUTBOX_ENTRY; createIndex indexName=IDX_OUTBOX_REALM, tableName=OUTB...		\N	4.33.0	\N	\N	2733469070
26.7.0-9686-dynamic-scopes-consent	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:17.559189	196	EXECUTED	9:fb689bc3ff64e174d6319014b38876f1	addColumn tableName=USER_CONSENT_CLIENT_SCOPE; dropPrimaryKey constraintName=CONSTRAINT_GRNTCSNT_CLSC_PM, tableName=USER_CONSENT_CLIENT_SCOPE; addPrimaryKey constraintName=CONSTRAINT_GRNTCSNT_CLSC_PM, tableName=USER_CONSENT_CLIENT_SCOPE; addColumn...		\N	4.33.0	\N	\N	2733469070
26.7.0-46204-issued-ver-credential-table	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:17.595179	197	EXECUTED	9:4918c6f68ba90ce417f1aaa031013168	createTable tableName=ISSUED_VER_CREDENTIAL; addPrimaryKey constraintName=PK_ISSUED_VER_CREDENTIAL, tableName=ISSUED_VER_CREDENTIAL; addForeignKeyConstraint baseTableName=ISSUED_VER_CREDENTIAL, constraintName=FK_ISSUED_VER_CREDENTIAL_USER, referen...		\N	4.33.0	\N	\N	2733469070
26.7.0-issued-ver-credential-expires-at-index	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:17.63252	198	EXECUTED	9:ab9e4c0c9f21d9217ffe52968a3cf732	createIndex indexName=IDX_ISSUED_VER_CREDENTIAL_EXPIRES_AT, tableName=ISSUED_VER_CREDENTIAL		\N	4.33.0	\N	\N	2733469070
26.7.0-issued-ver-credential-vc-id-index	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:17.663741	199	EXECUTED	9:1c9b18926e48b4b66d0341400bd13834	createIndex indexName=IDX_ISSUED_VER_CREDENTIAL_VC, tableName=ISSUED_VER_CREDENTIAL		\N	4.33.0	\N	\N	2733469070
26.7.0-federated-issued-ver-credential	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:17.783574	200	EXECUTED	9:3d610f5527879623a0d2362e64fa667f	createTable tableName=FED_ISSUED_VER_CREDENTIAL; addForeignKeyConstraint baseTableName=FED_ISSUED_VER_CREDENTIAL, constraintName=FK_FED_ISSUED_VC_VER_CRED, referencedTableName=FED_USER_VER_CREDENTIAL; createIndex indexName=IDX_FED_ISSUED_VC_USER, ...		\N	4.33.0	\N	\N	2733469070
26.7.0-persistent-auth-session-root-table	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:17.792793	201	EXECUTED	9:ad622d5eebdf468747a0d08d2367a68e	createTable tableName=ROOT_AUTH_SESSION		\N	4.33.0	\N	\N	2733469070
26.7.0-persistent-auth-session-root-index	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:17.912077	202	EXECUTED	9:3090cd11d2dfeb5df754f41c0ffa35d7	createIndex indexName=IDX_ROOT_AUTH_SESSION_REALM, tableName=ROOT_AUTH_SESSION		\N	4.33.0	\N	\N	2733469070
26.7.0-persistent-auth-session-table	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:17.931962	203	EXECUTED	9:609b8a172e43f617bb8920efd2b9ae5f	createTable tableName=AUTH_SESSION; addPrimaryKey constraintName=PK_AUTH_SESSION, tableName=AUTH_SESSION; addForeignKeyConstraint baseTableName=AUTH_SESSION, constraintName=FK_AUTH_SESSION_ROOT, referencedTableName=ROOT_AUTH_SESSION		\N	4.33.0	\N	\N	2733469070
26.7.0-single-use-object-table	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:17.941101	204	EXECUTED	9:22bc4eb8e456b3b7be2808e457a44cb7	createTable tableName=SINGLE_USE_OBJECT		\N	4.33.0	\N	\N	2733469070
26.7.0-single-use-object-index	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:17.981213	205	EXECUTED	9:b2ad66c013f48dc131ce109eface7fa5	createIndex indexName=IDX_SINGLE_USE_OBJ_EXPIRE, tableName=SINGLE_USE_OBJECT		\N	4.33.0	\N	\N	2733469070
26.7.0-login-failure-table	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:17.988678	206	EXECUTED	9:671b50f88904b24ceb02463dd2d0c045	createTable tableName=LOGIN_FAILURE; addPrimaryKey constraintName=PK_LOGIN_FAILURE, tableName=LOGIN_FAILURE		\N	4.33.0	\N	\N	2733469070
26.7.0-login-failure-index	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:18.02077	207	EXECUTED	9:f554afc6ad14784c99f6ad8811ac30ec	createIndex indexName=IDX_LOGIN_FAILURE_EXPIRE, tableName=LOGIN_FAILURE		\N	4.33.0	\N	\N	2733469070
26.7.0-add-timestamps-client	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:18.027319	208	EXECUTED	9:df5324c82398b446690b206c07649d40	addColumn tableName=CLIENT		\N	4.33.0	\N	\N	2733469070
26.7.0-add-last-modified-timestamp-client	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:18.033708	209	EXECUTED	9:bae67d2faa5438ee35adfbb20a53c3c6	addColumn tableName=CLIENT		\N	4.33.0	\N	\N	2733469070
26.7.0-cluster-event	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:18.072013	210	EXECUTED	9:556b201eb9c378fa05d5bf22ec9c8dcf	createTable tableName=CLUSTER_EVENT; addPrimaryKey constraintName=PK_CLUSTER_EVENT, tableName=CLUSTER_EVENT; createIndex indexName=IDX_CLUSTER_EVENT_TARGET, tableName=CLUSTER_EVENT		\N	4.33.0	\N	\N	2733469070
26.7.0-50970	keycloak	META-INF/jpa-changelog-26.7.0.xml	2026-10-23 05:31:18.15343	211	EXECUTED	9:82981762d25248a32ebfba9f02cee332	createIndex indexName=IDX_WORKFLOW_STATE_SCHEDULED, tableName=WORKFLOW_STATE		\N	4.33.0	\N	\N	2733469070
26.8.0-auth-session-auth-user-id-index	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.187819	212	EXECUTED	9:9d39f9ace96248659e332a25be722f5a	createIndex indexName=IDX_AUTH_SESSION_AUTH_USER_ID, tableName=AUTH_SESSION		\N	4.33.0	\N	\N	2733469070
26.8.0-51851-add-session-bucket	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.194136	213	EXECUTED	9:aec230951f35c974d78dd1f294df15a5	addColumn tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
26.8.0-51900-add-last-session-refresh-coarse	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.200463	214	EXECUTED	9:5fd2333a98d3ae004bdf4bf0b356cd88	addColumn tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
26.8.0-51851-drop-old-expiration-idx-created	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.208914	215	EXECUTED	9:0273f3da4167a41778eef56284bf1e9b	dropIndex indexName=IDX_USER_SESSION_EXPIRATION_CREATED, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
26.8.0-51851-drop-old-expiration-idx-last-refresh	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.217424	216	EXECUTED	9:fea923eeda0c0ff06e2006b46c49bb3f	dropIndex indexName=IDX_USER_SESSION_EXPIRATION_LAST_REFRESH, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
26.8.0-51851-add-bucketed-expiration-idx-created	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.254572	217	EXECUTED	9:f174e4939ae2b6e20003fbe10776d3fe	createIndex indexName=IDX_USER_SESSION_EXPIRATION_CREATED, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
26.8.0-51900-51851-add-bucketed-and-coarse-expiration-idx-last-refresh	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.290228	218	EXECUTED	9:095cf7bc0be9e5ed960134103d237cdb	createIndex indexName=IDX_USER_SESSION_EXPIRATION_LAST_REFRESH, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
26.8.0-51854-drop-css-user-session-offline-idx	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.297657	219	EXECUTED	9:57c23f6dd89e48f0b1fe2fa8482c36a7	dropIndex indexName=IDX_OFFLINE_CSS_BY_USER_SESSION_AND_OFFLINE, tableName=OFFLINE_CLIENT_SESSION		\N	4.33.0	\N	\N	2733469070
26.8.0-51854-drop-broker-session-idx	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.306024	220	EXECUTED	9:e816715f16e00f007f713bce752beebb	dropIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
26.8.0-51854-add-filtered-broker-session-idx	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.341562	221	EXECUTED	9:cd8d73766133879ec9940ec5471ec1cd	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.33.0	\N	\N	2733469070
26.8.0-53211-add-root-auth-session-bucket	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.347333	222	EXECUTED	9:cc5ff3f556fe1fc5348cdaeee7040585	addColumn tableName=ROOT_AUTH_SESSION		\N	4.33.0	\N	\N	2733469070
26.8.0-53211-add-root-auth-session-created-on	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.353967	223	EXECUTED	9:acf55770b549ccbfb5990780799be30f	addColumn tableName=ROOT_AUTH_SESSION		\N	4.33.0	\N	\N	2733469070
26.8.0-53211-add-root-auth-session-timestamp-coarse	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.359473	224	EXECUTED	9:bd48e1f4aa197f804aef55931031ecbd	addColumn tableName=ROOT_AUTH_SESSION		\N	4.33.0	\N	\N	2733469070
26.8.0-53211-drop-old-root-auth-session-idx	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.367088	225	EXECUTED	9:f10e6cd0afa4befe76d8161aab680d14	dropIndex indexName=IDX_ROOT_AUTH_SESSION_REALM, tableName=ROOT_AUTH_SESSION		\N	4.33.0	\N	\N	2733469070
26.8.0-53211-add-bucketed-root-auth-session-idx	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.401797	226	EXECUTED	9:98933a08c7e98f2124c5438d5ec2a52b	createIndex indexName=IDX_ROOT_AUTH_SESSION_REALM, tableName=ROOT_AUTH_SESSION		\N	4.33.0	\N	\N	2733469070
26.8.0-org-domain-add-realm-id	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.407239	227	EXECUTED	9:1495524d8e111590a9561921445e0bf2	addColumn tableName=ORG_DOMAIN		\N	4.33.0	\N	\N	2733469070
26.8.0-org-domain-populate-realm-id	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.411801	228	EXECUTED	9:12ca3d104545ae937c26dcb1a518c93c	customChange		\N	4.33.0	\N	\N	2733469070
26.8.0-org-domain-realm-id-not-null	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.449661	229	EXECUTED	9:b9354aa858afdd63abc3c4cb8d94d0c3	addNotNullConstraint columnName=REALM_ID, tableName=ORG_DOMAIN; addUniqueConstraint constraintName=UK_ORG_DOMAIN_REALM_NAME, tableName=ORG_DOMAIN; createIndex indexName=IDX_ORG_DOMAIN_REALM, tableName=ORG_DOMAIN		\N	4.33.0	\N	\N	2733469070
26.8.0-org-domain-add-idp-columns	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:18.455975	230	EXECUTED	9:f40909058fb66836a9c1fa8061dec9f9	addColumn tableName=ORG_DOMAIN		\N	4.33.0	\N	\N	2733469070
26.8.0-org-domain-add-org-fk	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:19.233732	231	EXECUTED	9:2bee6a398cef692c05ec4c9f78a9cd94	addForeignKeyConstraint baseTableName=ORG_DOMAIN, constraintName=FK_ORG_DOMAIN_ORG, referencedTableName=ORG		\N	4.33.0	\N	\N	2733469070
26.8.0-create-org-identity-provider	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:19.30423	232	EXECUTED	9:8cdd68d8fbbbb2e1a1d09f7e09892492	createTable tableName=ORG_IDENTITY_PROVIDER; addPrimaryKey constraintName=PK_ORG_IDP, tableName=ORG_IDENTITY_PROVIDER; addForeignKeyConstraint baseTableName=ORG_IDENTITY_PROVIDER, constraintName=FK_ORG_IDP_ORG, referencedTableName=ORG; addForeignK...		\N	4.33.0	\N	\N	2733469070
26.8.0-org-idp-and-domain-routing-migration	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:19.308646	233	EXECUTED	9:833e203db6b2bcaa07f38b286ecad308	customChange		\N	4.33.0	\N	\N	2733469070
26.8.0-org-domain-add-idp-fk	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:20.106468	234	EXECUTED	9:ab74c0d43b09017a43b7814e8232765b	addForeignKeyConstraint baseTableName=ORG_DOMAIN, constraintName=FK_ORG_DOMAIN_IDP, referencedTableName=IDENTITY_PROVIDER; createIndex indexName=IDX_ORG_DOMAIN_IDP_ID, tableName=ORG_DOMAIN		\N	4.33.0	\N	\N	2733469070
26.8.0-idp-mapper-organization-id	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:20.111631	235	EXECUTED	9:665accb97ce0a8e0111e8ff57aa93467	customChange		\N	4.33.0	\N	\N	2733469070
26.8.0-drop-idp-organization-id	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:20.151163	236	EXECUTED	9:f1111108b2183ca31c2a74cb1b3494e2	dropIndex indexName=IDX_IDP_REALM_ORG, tableName=IDENTITY_PROVIDER; dropIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER; dropColumn columnName=ORGANIZATION_ID, tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_FOR_LOGIN, ta...		\N	4.33.0	\N	\N	2733469070
26.8.0-backfill-group-org-id	keycloak	META-INF/jpa-changelog-26.8.0.xml	2026-10-23 05:31:20.156615	237	EXECUTED	9:c834da04f981e7198c7b6298f409f3c7	customChange		\N	4.33.0	\N	\N	2733469070
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
e7107428-2e29-4f5c-b9b0-26341d6ad9ba	be8c874d-687b-4c92-bac9-c29f8cfc3042	f
e7107428-2e29-4f5c-b9b0-26341d6ad9ba	94084437-d935-4ca8-ab96-d30dc2ad0c56	t
e7107428-2e29-4f5c-b9b0-26341d6ad9ba	f7bfccff-969b-439b-9b1e-9e7fd198070a	t
e7107428-2e29-4f5c-b9b0-26341d6ad9ba	70986669-c00d-4402-bfec-8554cadf8515	t
e7107428-2e29-4f5c-b9b0-26341d6ad9ba	3d2eb408-6825-4160-ad57-d8f0e2ccc282	t
e7107428-2e29-4f5c-b9b0-26341d6ad9ba	91680d69-1643-468a-bcc8-fdb6364dbf97	t
e7107428-2e29-4f5c-b9b0-26341d6ad9ba	92533f6a-8a2f-4307-a327-fa5f7cfb77ab	f
e7107428-2e29-4f5c-b9b0-26341d6ad9ba	0ad81363-840d-428a-838a-5aa3268fc771	f
e7107428-2e29-4f5c-b9b0-26341d6ad9ba	670840e1-22ef-4dcf-adbe-5a1447ab5be0	t
e7107428-2e29-4f5c-b9b0-26341d6ad9ba	130a3249-05e9-4f7b-85c8-c9943294127c	t
e7107428-2e29-4f5c-b9b0-26341d6ad9ba	1a1c76d6-e386-4741-9f47-fb30f07d22d2	f
e7107428-2e29-4f5c-b9b0-26341d6ad9ba	96b931aa-efd9-46b1-bc6c-7813ba720f9e	t
e7107428-2e29-4f5c-b9b0-26341d6ad9ba	3d8a669f-ea17-4b17-8cfb-8a7e44366f14	t
e7107428-2e29-4f5c-b9b0-26341d6ad9ba	2fc9bb0a-cd40-42cf-b4e7-f3f5044a8d91	f
16778b9e-50cb-4ccd-8250-1e80093e3d7e	cd8b7110-93fb-4335-9353-43985411298b	f
16778b9e-50cb-4ccd-8250-1e80093e3d7e	5e676abc-a591-44ff-8bb9-e99415958278	t
16778b9e-50cb-4ccd-8250-1e80093e3d7e	f048dc00-bfed-4d5a-9a43-9e0ad34a80c9	t
16778b9e-50cb-4ccd-8250-1e80093e3d7e	f432d52c-e26b-404e-8bb6-389b5da67b2c	t
16778b9e-50cb-4ccd-8250-1e80093e3d7e	786baf1e-8607-4c02-92c0-e913ec08349e	t
16778b9e-50cb-4ccd-8250-1e80093e3d7e	b4275634-8c93-4041-a984-1c6b26e77c09	t
16778b9e-50cb-4ccd-8250-1e80093e3d7e	3b1d4471-3c96-45fb-a878-ce3fa04a0a54	f
16778b9e-50cb-4ccd-8250-1e80093e3d7e	d4d68849-77f1-42be-a68b-6774b05d357a	f
16778b9e-50cb-4ccd-8250-1e80093e3d7e	50efe53c-e60a-4589-a095-d47ee4f83988	t
16778b9e-50cb-4ccd-8250-1e80093e3d7e	544c84aa-6d24-46ab-8178-01d878e901b6	t
16778b9e-50cb-4ccd-8250-1e80093e3d7e	23f29c91-a04b-42d8-b780-27f3fcce5ec2	f
16778b9e-50cb-4ccd-8250-1e80093e3d7e	61eb6801-1490-4ee9-9706-0ed0d7dc7f16	t
16778b9e-50cb-4ccd-8250-1e80093e3d7e	93486f6f-bad4-42e1-91e7-66be5a740110	t
16778b9e-50cb-4ccd-8250-1e80093e3d7e	0a8747d0-1630-4e86-a1ef-caf9966f86f1	f
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id, details_json_long_value) FROM stdin;
\.


--
-- Data for Name: fed_issued_ver_credential; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.fed_issued_ver_credential (id, user_id, realm_id, storage_provider_id, ver_credential_id, issued_at, expires_at, client_id, revision) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id, parameter) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_ver_credential; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.fed_user_ver_credential (id, user_id, realm_id, storage_provider_id, client_scope_id, revision, user_attributes, created_date, updated_date, version) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only, hide_on_login) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: issued_ver_credential; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.issued_ver_credential (id, user_id, ver_credential_id, issued_at, expires_at, client_id, revision) FROM stdin;
\.


--
-- Data for Name: jgroups_ping; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.jgroups_ping (address, name, cluster_name, ip, coord, last_update, coordinated_by) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.keycloak_group (id, name, parent_group, realm_id, type, description, org_id, created_timestamp, last_modified_timestamp) FROM stdin;
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
6a0bc16e-872b-4c44-ae7b-16dea5221812	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	f	${role_default-roles}	default-roles-master	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	\N	\N
55c449af-77fa-4a46-a813-2e59895d2a9e	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	f	${role_admin}	admin	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	\N	\N
ef926176-c437-47f7-b739-b8a8438baf61	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	f	${role_create-realm}	create-realm	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	\N	\N
659a7a70-985f-4cac-8433-182092900630	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_create-client}	create-client	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
bb46684d-95fb-4c9f-85aa-2939ca784621	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_view-realm}	view-realm	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
7029b9e3-8a7f-489b-91a2-8ed58f4b137d	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_view-users}	view-users	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
098b198d-4e48-4f91-9bf9-1eb6ee86bf10	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_view-clients}	view-clients	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
9df921ed-4da4-4e72-bb80-96b076760fc1	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_view-events}	view-events	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
798a190f-4d57-4c78-a77d-4e3098074787	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_view-identity-providers}	view-identity-providers	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
fd115c68-d694-4d79-b5e9-493b4abab1d7	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_view-authorization}	view-authorization	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
ab494458-b52a-4751-93e0-1fec3003d523	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_view-organizations}	view-organizations	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
828a1a18-b90d-49b8-b134-fef43e33a773	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_manage-realm}	manage-realm	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
d53982c3-c95c-46aa-afc5-2c25e2eccad4	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_manage-users}	manage-users	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
824d52e0-e168-4931-aea9-6a9a347a7d40	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_manage-clients}	manage-clients	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
8ea3eeea-0d6a-4aa5-a30a-fce7a343f597	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_manage-events}	manage-events	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
41ef19c7-c0a5-478a-9350-2b014459b658	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_manage-identity-providers}	manage-identity-providers	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
fa8831a0-4f1c-4b89-9226-dd97dc7813c7	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_manage-authorization}	manage-authorization	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
1b6a2194-6f33-42bb-a50c-7744327718bf	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_manage-organizations}	manage-organizations	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
567c5b14-9595-4fca-bd2b-065446a3db00	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_query-users}	query-users	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
960bcb71-a06a-4b97-91ca-b04db87a7b3c	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_query-clients}	query-clients	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
b3b0d0d3-96dd-4990-a2af-24ffdb88742b	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_query-realms}	query-realms	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
18ead793-de89-40d7-9653-99f78a0f95c2	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_query-groups}	query-groups	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
4dc0a933-c23a-46f3-8185-7648e61903ab	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_query-organizations}	query-organizations	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
5b15ee41-d027-4963-b08e-36255a8f9cff	11c4e2f2-6350-491d-b968-ea462bbc2ffa	t	${role_view-profile}	view-profile	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	11c4e2f2-6350-491d-b968-ea462bbc2ffa	\N
e2dd4f5a-baa9-40f4-b0ac-c777d4487eae	11c4e2f2-6350-491d-b968-ea462bbc2ffa	t	${role_manage-account}	manage-account	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	11c4e2f2-6350-491d-b968-ea462bbc2ffa	\N
7a776c32-fe77-4cca-9e75-551931cfdc31	11c4e2f2-6350-491d-b968-ea462bbc2ffa	t	${role_manage-account-links}	manage-account-links	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	11c4e2f2-6350-491d-b968-ea462bbc2ffa	\N
8823aa2c-9818-4ea0-b272-96c752db9f67	11c4e2f2-6350-491d-b968-ea462bbc2ffa	t	${role_view-applications}	view-applications	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	11c4e2f2-6350-491d-b968-ea462bbc2ffa	\N
9949bd94-24f2-4d6c-9a85-86211854c2c1	11c4e2f2-6350-491d-b968-ea462bbc2ffa	t	${role_view-consent}	view-consent	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	11c4e2f2-6350-491d-b968-ea462bbc2ffa	\N
9a0725a0-1e54-40ea-b5fe-926cd3199550	11c4e2f2-6350-491d-b968-ea462bbc2ffa	t	${role_manage-consent}	manage-consent	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	11c4e2f2-6350-491d-b968-ea462bbc2ffa	\N
2fb125f8-b4f9-4fb5-a95c-1320a9a967d3	11c4e2f2-6350-491d-b968-ea462bbc2ffa	t	${role_view-groups}	view-groups	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	11c4e2f2-6350-491d-b968-ea462bbc2ffa	\N
224a08be-8bcf-4912-8fcc-716d12b767d5	11c4e2f2-6350-491d-b968-ea462bbc2ffa	t	${role_delete-account}	delete-account	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	11c4e2f2-6350-491d-b968-ea462bbc2ffa	\N
e7555073-e8ae-4a92-9e49-898ecca9f4e1	a230c0c1-1e6f-4198-8bd1-030f671a614c	t	${role_read-token}	read-token	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	a230c0c1-1e6f-4198-8bd1-030f671a614c	\N
4f82bb57-bbbd-44d8-9eb0-f074eba1b8be	727bf2a1-6b03-4c06-88ff-5710a91cde68	t	${role_impersonation}	impersonation	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	727bf2a1-6b03-4c06-88ff-5710a91cde68	\N
26576a80-1f8b-4e4a-9395-5fc77bc6acb3	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	f	${role_offline-access}	offline_access	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	\N	\N
c7b37c40-3006-4bd2-8dc1-49779e91c0a7	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	f	${role_uma_authorization}	uma_authorization	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	\N	\N
e42b75f9-c709-4bd0-beac-4333775dfa6f	16778b9e-50cb-4ccd-8250-1e80093e3d7e	f	${role_default-roles}	default-roles-eniaclabs	16778b9e-50cb-4ccd-8250-1e80093e3d7e	\N	\N
b30b4753-8515-4861-8f1f-6071431e83a5	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_create-client}	create-client	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
71cbcb9d-15f0-4cd8-be09-ea41e3dae154	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_view-realm}	view-realm	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
974ef83b-351a-402c-8420-4ed8d9dd84cf	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_view-users}	view-users	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
5eb6e2b9-7978-4aad-b5b7-240895f4fb50	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_view-clients}	view-clients	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
20dd03c2-10ce-4abf-9910-abb441274b58	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_view-events}	view-events	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
9d550c6b-e019-4613-9e59-b7792e4dd48c	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_view-identity-providers}	view-identity-providers	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
32b9485b-c7e0-49a4-93f9-cb7d9b834801	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_view-authorization}	view-authorization	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
29006ee5-d504-45be-bce0-1f3e1cfa502d	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_view-organizations}	view-organizations	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
e5304a0c-879b-4028-9450-7577d9260e51	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_manage-realm}	manage-realm	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
620c014d-2e44-4f05-b66e-46fc0661680a	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_manage-users}	manage-users	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
cfdca7ea-82b1-4204-8514-492c480e1e0c	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_manage-clients}	manage-clients	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
a6c5cc24-4909-4ddc-bd06-0b1ce81c37d9	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_manage-events}	manage-events	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
2382a64a-9879-4be1-a611-e5e487e00c3a	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_manage-identity-providers}	manage-identity-providers	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
87888590-3d16-4cfa-b817-6983b6d95417	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_manage-authorization}	manage-authorization	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
c33f3bc9-b115-4f71-b4df-316e25dcdb54	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_manage-organizations}	manage-organizations	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
e78649bd-841c-4c08-b5d2-ceccb09cf9a4	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_query-users}	query-users	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
ce5b8b66-08ec-43cd-bae6-b85e0d173d82	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_query-clients}	query-clients	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
04142d81-0af3-4e50-88ad-ba0781157c4c	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_query-realms}	query-realms	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
fa9ba3f7-34ba-4c6d-9d18-c97b5649e29e	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_query-groups}	query-groups	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
cb694d40-4228-4aab-8424-0354cd578cb8	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_query-organizations}	query-organizations	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
574fab0f-d02e-41c1-ad7e-ccae12655673	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_realm-admin}	realm-admin	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
abfbf52f-7ad5-415f-8a46-bce66ed5c53a	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_create-client}	create-client	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
4a0aadc9-5e3f-4c9d-8d42-6dfb78499ef4	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_view-realm}	view-realm	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
52be68da-cea9-4e06-b029-8a0d8f04a8b4	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_view-users}	view-users	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
6fe748c8-3ea8-47c8-8471-15d85eabc0e8	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_view-clients}	view-clients	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
c3b0b26a-9c98-49f4-abcf-8f051a605e22	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_view-events}	view-events	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
89d2af98-b6e3-4664-a125-d00d0f60bc86	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_view-identity-providers}	view-identity-providers	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
0c1d018f-849b-4d8b-98d7-4862c12dcc3f	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_view-authorization}	view-authorization	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
8108f9cd-2277-469e-90d9-3902d87aeffd	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_view-organizations}	view-organizations	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
40fb1d76-9aee-4509-8bf9-4b3ecaf8983d	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_manage-realm}	manage-realm	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
5802adbe-86b4-4dd7-b881-2c54adb460cd	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_manage-users}	manage-users	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
7f22c564-5147-4082-a6f4-1bcd8fab8ede	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_manage-clients}	manage-clients	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
958a4faf-a450-47a5-8feb-c7b470a55a2e	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_manage-events}	manage-events	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
04859ffe-8bb7-4454-b658-b02a6e2130b9	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_manage-identity-providers}	manage-identity-providers	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
3dffc968-968a-450f-97d0-b4ae8b57d470	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_manage-authorization}	manage-authorization	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
c3ea2e63-8c5e-4190-817c-b8098062cd47	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_manage-organizations}	manage-organizations	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
6de41b64-7db8-4d38-9a3b-a10565ba1b96	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_query-users}	query-users	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
2d829f87-0048-4417-90c8-a505d06969fa	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_query-clients}	query-clients	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
b3dcdadb-4ff8-46ea-a039-be35bbfef016	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_query-realms}	query-realms	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
b4b98bb1-6aa1-4908-b96d-ca07fc2a38bd	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_query-groups}	query-groups	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
e82325ef-23ad-4e32-9cdf-b47540259822	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_query-organizations}	query-organizations	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
e317135f-e1b5-458a-ace7-8930d7ac0ccc	7c82d307-0ab0-49b1-9cd4-fadd06207309	t	${role_view-profile}	view-profile	16778b9e-50cb-4ccd-8250-1e80093e3d7e	7c82d307-0ab0-49b1-9cd4-fadd06207309	\N
40fdb277-9caa-4710-ad59-1e6c2452df70	7c82d307-0ab0-49b1-9cd4-fadd06207309	t	${role_manage-account}	manage-account	16778b9e-50cb-4ccd-8250-1e80093e3d7e	7c82d307-0ab0-49b1-9cd4-fadd06207309	\N
7778e2a5-663e-4711-b006-f8f84239b701	7c82d307-0ab0-49b1-9cd4-fadd06207309	t	${role_manage-account-links}	manage-account-links	16778b9e-50cb-4ccd-8250-1e80093e3d7e	7c82d307-0ab0-49b1-9cd4-fadd06207309	\N
71420dfa-ba17-4d53-bbc8-690c7418ac1c	7c82d307-0ab0-49b1-9cd4-fadd06207309	t	${role_view-applications}	view-applications	16778b9e-50cb-4ccd-8250-1e80093e3d7e	7c82d307-0ab0-49b1-9cd4-fadd06207309	\N
e75f0ad7-e190-438c-a604-8b96acf527f4	7c82d307-0ab0-49b1-9cd4-fadd06207309	t	${role_view-consent}	view-consent	16778b9e-50cb-4ccd-8250-1e80093e3d7e	7c82d307-0ab0-49b1-9cd4-fadd06207309	\N
5fdd983f-6b3d-4cbe-95b1-1deb2db4a71d	7c82d307-0ab0-49b1-9cd4-fadd06207309	t	${role_manage-consent}	manage-consent	16778b9e-50cb-4ccd-8250-1e80093e3d7e	7c82d307-0ab0-49b1-9cd4-fadd06207309	\N
ac7cf7db-550c-4199-999e-846b207bf45c	7c82d307-0ab0-49b1-9cd4-fadd06207309	t	${role_view-groups}	view-groups	16778b9e-50cb-4ccd-8250-1e80093e3d7e	7c82d307-0ab0-49b1-9cd4-fadd06207309	\N
cf3863a3-15d9-4116-b963-f5a9e9d3a935	7c82d307-0ab0-49b1-9cd4-fadd06207309	t	${role_delete-account}	delete-account	16778b9e-50cb-4ccd-8250-1e80093e3d7e	7c82d307-0ab0-49b1-9cd4-fadd06207309	\N
bac4d3c7-ed15-4a71-8c46-a04496bc4101	9eac8266-847b-4518-a656-b3d4bbb3bab4	t	${role_impersonation}	impersonation	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	9eac8266-847b-4518-a656-b3d4bbb3bab4	\N
ce38e71d-907f-46d8-871a-79e1f8180d28	10b3e9b7-f507-438c-af2c-f4f03d586467	t	${role_impersonation}	impersonation	16778b9e-50cb-4ccd-8250-1e80093e3d7e	10b3e9b7-f507-438c-af2c-f4f03d586467	\N
bae03b50-d70b-4be3-b80f-677e272f10dd	d6cc51ad-d6d4-4c6e-a5c1-c3acf0c74f60	t	${role_read-token}	read-token	16778b9e-50cb-4ccd-8250-1e80093e3d7e	d6cc51ad-d6d4-4c6e-a5c1-c3acf0c74f60	\N
48258be2-c7bc-45cc-89d6-66244d5cec66	16778b9e-50cb-4ccd-8250-1e80093e3d7e	f	${role_offline-access}	offline_access	16778b9e-50cb-4ccd-8250-1e80093e3d7e	\N	\N
c03b2200-f5b9-40b5-b6b5-85ad68fdf4c0	16778b9e-50cb-4ccd-8250-1e80093e3d7e	f	${role_uma_authorization}	uma_authorization	16778b9e-50cb-4ccd-8250-1e80093e3d7e	\N	\N
ec5ea76b-e37e-484e-b906-8af3ed3a7513	16778b9e-50cb-4ccd-8250-1e80093e3d7e	f	\N	CLIENTE	16778b9e-50cb-4ccd-8250-1e80093e3d7e	\N	\N
f1f7df74-2b72-4630-9f03-bb513e32b3ae	16778b9e-50cb-4ccd-8250-1e80093e3d7e	f	\N	ADMIN	16778b9e-50cb-4ccd-8250-1e80093e3d7e	\N	\N
\.


--
-- Data for Name: login_failure; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.login_failure (realm_id, user_id, failed_login_not_before, num_failures, num_temporary_lockouts, last_failure, last_ip_failure, num_secondary_auth_failures) FROM stdin;
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.migration_model (id, version, update_time) FROM stdin;
slgx2	26.8.0	1792733483
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id, version, realm_id) FROM stdin;
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh, broker_session_id, version, remember_me, session_bucket, last_session_refresh_coarse) FROM stdin;
\.


--
-- Data for Name: org; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.org (id, enabled, realm_id, group_id, name, description, alias, redirect_url) FROM stdin;
\.


--
-- Data for Name: org_domain; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.org_domain (id, name, verified, org_id, realm_id, idp_id, auto_redirect) FROM stdin;
\.


--
-- Data for Name: org_identity_provider; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.org_identity_provider (organization_id, identity_provider_id, auto_membership, membership_type) FROM stdin;
\.


--
-- Data for Name: org_invitation; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.org_invitation (id, organization_id, email, first_name, last_name, created_at, expires_at, invite_link) FROM stdin;
\.


--
-- Data for Name: outbox_entry; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.outbox_entry (id, entry_kind, realm_id, owner_id, container_id, correlation_id, entry_type, payload, metadata, status, attempts, next_attempt_at, last_error, created_at, delivered_at) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
a6e1be42-f8ef-49fa-935c-772687f2eba4	audience resolve	openid-connect	oidc-audience-resolve-mapper	546d4646-e2b4-4715-86bd-cf8e84405f59	\N
bf7e3b28-eb8e-4a83-923e-26e246213d8b	locale	openid-connect	oidc-usermodel-attribute-mapper	1fc3ed36-de0f-475c-a220-69e3cdc7bc16	\N
b7ab6868-0a16-48d6-97d7-0f52b7fc2b43	role list	saml	saml-role-list-mapper	\N	94084437-d935-4ca8-ab96-d30dc2ad0c56
ff1038eb-026d-4dc2-ba29-5a8fb7b9717b	organization	saml	saml-organization-membership-mapper	\N	f7bfccff-969b-439b-9b1e-9e7fd198070a
e785acad-7b0c-4d81-b5c0-dda83ffe41f4	AuthnContextClassRef	saml	saml-authn-context-class-ref-mapper	\N	70986669-c00d-4402-bfec-8554cadf8515
e207dbc4-2541-4bc8-8cd0-2444f25b6f4d	full name	openid-connect	oidc-full-name-mapper	\N	3d2eb408-6825-4160-ad57-d8f0e2ccc282
89a74603-0e8a-4c26-ae96-8f2a00c14e94	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	3d2eb408-6825-4160-ad57-d8f0e2ccc282
801e4ae7-d35a-487e-b65c-c6134ba107a0	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	3d2eb408-6825-4160-ad57-d8f0e2ccc282
7ba91147-1401-4d16-b05a-196403e07cc2	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	3d2eb408-6825-4160-ad57-d8f0e2ccc282
b22cbb5b-09c5-458c-a8cc-a1c7728664de	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	3d2eb408-6825-4160-ad57-d8f0e2ccc282
bed66452-6ece-457f-96ec-73b5efda71ff	username	openid-connect	oidc-usermodel-attribute-mapper	\N	3d2eb408-6825-4160-ad57-d8f0e2ccc282
c032dc79-93f3-4729-91b0-6ded7385a646	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	3d2eb408-6825-4160-ad57-d8f0e2ccc282
3c0498f0-7f90-446b-a749-65c7fff18c66	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	3d2eb408-6825-4160-ad57-d8f0e2ccc282
80cf8e4f-bee9-4339-907a-e14b99469d7e	website	openid-connect	oidc-usermodel-attribute-mapper	\N	3d2eb408-6825-4160-ad57-d8f0e2ccc282
01f7b447-405d-444f-b0d4-d897f871c15c	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	3d2eb408-6825-4160-ad57-d8f0e2ccc282
d8c77859-9117-46d0-aff5-d42257252de0	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	3d2eb408-6825-4160-ad57-d8f0e2ccc282
896b8dfa-c4b5-4fe1-b42d-5cf1604b3836	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	3d2eb408-6825-4160-ad57-d8f0e2ccc282
c0aa012d-99ee-446d-9a05-eab99c614bc4	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	3d2eb408-6825-4160-ad57-d8f0e2ccc282
22288489-84ac-46ce-adaa-ec5c1bc3edba	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	3d2eb408-6825-4160-ad57-d8f0e2ccc282
85f3b554-3972-49df-bfa7-c0a9e6930bd2	email	openid-connect	oidc-usermodel-attribute-mapper	\N	91680d69-1643-468a-bcc8-fdb6364dbf97
1eae8737-1a71-4a07-9c3e-77ea23b10244	email verified	openid-connect	oidc-usermodel-property-mapper	\N	91680d69-1643-468a-bcc8-fdb6364dbf97
10505e6a-1cba-4b5d-ab10-9e357bb474a3	address	openid-connect	oidc-address-mapper	\N	92533f6a-8a2f-4307-a327-fa5f7cfb77ab
d79ece71-0d56-4b5c-bf17-e9f659d95b2e	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	0ad81363-840d-428a-838a-5aa3268fc771
83badbc0-83ac-47d9-b6ec-1dd9062df7be	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	0ad81363-840d-428a-838a-5aa3268fc771
c3250a80-14f2-4f05-8e58-78603565ec8f	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	670840e1-22ef-4dcf-adbe-5a1447ab5be0
5a9fadb2-36b2-43b7-ac75-d75caaee2077	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	670840e1-22ef-4dcf-adbe-5a1447ab5be0
453fdd5d-9505-4a7a-bc78-9f74dd92beb5	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	670840e1-22ef-4dcf-adbe-5a1447ab5be0
1719b9d5-ce41-4185-8097-ea62830ba1aa	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	130a3249-05e9-4f7b-85c8-c9943294127c
29747a97-1d40-49eb-af50-1dda8455f9c5	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	1a1c76d6-e386-4741-9f47-fb30f07d22d2
25e19c35-be3c-431c-bd7f-e4273e703578	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	1a1c76d6-e386-4741-9f47-fb30f07d22d2
30bce4b1-c914-4541-980c-443dca3f73c7	acr loa level	openid-connect	oidc-acr-mapper	\N	96b931aa-efd9-46b1-bc6c-7813ba720f9e
ec4711c3-ebb7-4779-9e5e-23da8459ee98	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	3d8a669f-ea17-4b17-8cfb-8a7e44366f14
99510a23-95e0-4fe9-9514-594ac8669ff5	sub	openid-connect	oidc-sub-mapper	\N	3d8a669f-ea17-4b17-8cfb-8a7e44366f14
25690d8a-831c-4f46-8542-d42ccda62964	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	\N	073702ac-9a2a-46bc-a915-dfe212937a56
ca0bc1f4-6442-4706-8950-1e7994a2b87f	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	\N	073702ac-9a2a-46bc-a915-dfe212937a56
cf9b5f80-0673-42f0-8090-e67907f2effc	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	\N	073702ac-9a2a-46bc-a915-dfe212937a56
36f8b276-9db8-4e11-bef2-7eef6e96e8d2	organization	openid-connect	oidc-organization-membership-mapper	\N	2fc9bb0a-cd40-42cf-b4e7-f3f5044a8d91
20990811-78ce-481a-a48c-07f462f34360	audience resolve	openid-connect	oidc-audience-resolve-mapper	72b2a634-cd62-465a-88c1-070cdfaad787	\N
7e1dd60e-77df-407b-9605-5a0537d82a93	role list	saml	saml-role-list-mapper	\N	5e676abc-a591-44ff-8bb9-e99415958278
048caf8a-ce1e-4a2e-95b4-8faeee612b0c	organization	saml	saml-organization-membership-mapper	\N	f048dc00-bfed-4d5a-9a43-9e0ad34a80c9
bee6928f-97fc-45fa-9ef1-f602603912d6	AuthnContextClassRef	saml	saml-authn-context-class-ref-mapper	\N	f432d52c-e26b-404e-8bb6-389b5da67b2c
c452ba09-64a0-46a2-a603-f564bf7e5dc0	full name	openid-connect	oidc-full-name-mapper	\N	786baf1e-8607-4c02-92c0-e913ec08349e
c3aa2451-3ed1-44b1-b0bb-d3feb4ac739d	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	786baf1e-8607-4c02-92c0-e913ec08349e
ef7e33f6-47cb-42e6-a1b6-ec687229d5fb	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	786baf1e-8607-4c02-92c0-e913ec08349e
97712647-b507-41c4-9443-67b32bed5090	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	786baf1e-8607-4c02-92c0-e913ec08349e
58e1ed14-a837-40d2-84f4-2e1057cfb522	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	786baf1e-8607-4c02-92c0-e913ec08349e
09f42ad6-1bf1-41fd-add3-7d557c880b36	username	openid-connect	oidc-usermodel-attribute-mapper	\N	786baf1e-8607-4c02-92c0-e913ec08349e
795ef095-b316-467f-8217-4cbfac9bc582	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	786baf1e-8607-4c02-92c0-e913ec08349e
07a635eb-365e-4109-9e70-6c900c500b32	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	786baf1e-8607-4c02-92c0-e913ec08349e
f674f0e0-9963-4ea8-8ca6-f0039cf72a62	website	openid-connect	oidc-usermodel-attribute-mapper	\N	786baf1e-8607-4c02-92c0-e913ec08349e
66b1b79e-f3cb-4eb3-8b62-abd0c939b833	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	786baf1e-8607-4c02-92c0-e913ec08349e
a917c9ae-38cf-4661-a7ce-34566a7a7204	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	786baf1e-8607-4c02-92c0-e913ec08349e
3bba9318-49a5-4bbd-9260-92ca07fa5786	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	786baf1e-8607-4c02-92c0-e913ec08349e
c8b1efe0-a5aa-4526-958c-8d404e6baf11	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	786baf1e-8607-4c02-92c0-e913ec08349e
a33298c3-1e8b-446b-ab77-b799ca8d61ca	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	786baf1e-8607-4c02-92c0-e913ec08349e
0b050024-8df5-45f1-8da9-acbe41c1633a	email	openid-connect	oidc-usermodel-attribute-mapper	\N	b4275634-8c93-4041-a984-1c6b26e77c09
b3f5afb3-ecdb-4521-b093-0610fae52b01	email verified	openid-connect	oidc-usermodel-property-mapper	\N	b4275634-8c93-4041-a984-1c6b26e77c09
1cdfdd42-4a96-4d51-a2e5-4d6bb6b96f22	address	openid-connect	oidc-address-mapper	\N	3b1d4471-3c96-45fb-a878-ce3fa04a0a54
2b2fe963-8603-4ff6-a51c-eae57e5356b7	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	d4d68849-77f1-42be-a68b-6774b05d357a
a9b0f5c6-7d87-4eec-a175-ba233cc2971d	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	d4d68849-77f1-42be-a68b-6774b05d357a
06c85da1-6552-419d-818d-d623e6a9e5cc	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	50efe53c-e60a-4589-a095-d47ee4f83988
3d2cbcc9-097e-4d8b-bf38-88047801f8d9	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	50efe53c-e60a-4589-a095-d47ee4f83988
adaa766f-d12f-4756-9ba7-b622ac5aec2c	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	50efe53c-e60a-4589-a095-d47ee4f83988
9a5ea4e9-40f5-4189-b938-f3617f0bb43d	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	544c84aa-6d24-46ab-8178-01d878e901b6
83612980-b7c7-4a02-9464-f5a61e4a061d	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	23f29c91-a04b-42d8-b780-27f3fcce5ec2
6cfffaaa-683f-48e7-a8a4-2c38a1462bfb	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	23f29c91-a04b-42d8-b780-27f3fcce5ec2
bcdac89b-f1b1-44b9-b7d3-a351fdbd2107	acr loa level	openid-connect	oidc-acr-mapper	\N	61eb6801-1490-4ee9-9706-0ed0d7dc7f16
0448ca3b-e220-4bf3-b260-5c1501ea8ad7	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	93486f6f-bad4-42e1-91e7-66be5a740110
0eaaf718-64fb-4eb0-add0-d02ea3e5d3cf	sub	openid-connect	oidc-sub-mapper	\N	93486f6f-bad4-42e1-91e7-66be5a740110
2dc4036a-4a73-4db8-baea-c8f08f2d114a	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	\N	3eb3469f-74a5-402e-9cbc-f29cdd825c0c
61146c24-163e-481c-a62f-83559e1e097d	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	\N	3eb3469f-74a5-402e-9cbc-f29cdd825c0c
c4e2d59e-8e0f-4db4-b684-784421deda78	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	\N	3eb3469f-74a5-402e-9cbc-f29cdd825c0c
0d2543e0-8dc3-4ad4-86a8-12f4e0fe1829	organization	openid-connect	oidc-organization-membership-mapper	\N	0a8747d0-1630-4e86-a1ef-caf9966f86f1
b88a7fdd-dcdd-441c-b504-9882c0e47942	locale	openid-connect	oidc-usermodel-attribute-mapper	839d8416-a602-45b7-a9d9-88bc3119aea9	\N
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
bf7e3b28-eb8e-4a83-923e-26e246213d8b	true	introspection.token.claim
bf7e3b28-eb8e-4a83-923e-26e246213d8b	true	userinfo.token.claim
bf7e3b28-eb8e-4a83-923e-26e246213d8b	locale	user.attribute
bf7e3b28-eb8e-4a83-923e-26e246213d8b	true	id.token.claim
bf7e3b28-eb8e-4a83-923e-26e246213d8b	true	access.token.claim
bf7e3b28-eb8e-4a83-923e-26e246213d8b	locale	claim.name
bf7e3b28-eb8e-4a83-923e-26e246213d8b	String	jsonType.label
b7ab6868-0a16-48d6-97d7-0f52b7fc2b43	false	single
b7ab6868-0a16-48d6-97d7-0f52b7fc2b43	Basic	attribute.nameformat
b7ab6868-0a16-48d6-97d7-0f52b7fc2b43	Role	attribute.name
01f7b447-405d-444f-b0d4-d897f871c15c	true	introspection.token.claim
01f7b447-405d-444f-b0d4-d897f871c15c	true	userinfo.token.claim
01f7b447-405d-444f-b0d4-d897f871c15c	gender	user.attribute
01f7b447-405d-444f-b0d4-d897f871c15c	true	id.token.claim
01f7b447-405d-444f-b0d4-d897f871c15c	true	access.token.claim
01f7b447-405d-444f-b0d4-d897f871c15c	gender	claim.name
01f7b447-405d-444f-b0d4-d897f871c15c	String	jsonType.label
22288489-84ac-46ce-adaa-ec5c1bc3edba	true	introspection.token.claim
22288489-84ac-46ce-adaa-ec5c1bc3edba	true	userinfo.token.claim
22288489-84ac-46ce-adaa-ec5c1bc3edba	updatedAt	user.attribute
22288489-84ac-46ce-adaa-ec5c1bc3edba	true	id.token.claim
22288489-84ac-46ce-adaa-ec5c1bc3edba	true	access.token.claim
22288489-84ac-46ce-adaa-ec5c1bc3edba	updated_at	claim.name
22288489-84ac-46ce-adaa-ec5c1bc3edba	long	jsonType.label
3c0498f0-7f90-446b-a749-65c7fff18c66	true	introspection.token.claim
3c0498f0-7f90-446b-a749-65c7fff18c66	true	userinfo.token.claim
3c0498f0-7f90-446b-a749-65c7fff18c66	picture	user.attribute
3c0498f0-7f90-446b-a749-65c7fff18c66	true	id.token.claim
3c0498f0-7f90-446b-a749-65c7fff18c66	true	access.token.claim
3c0498f0-7f90-446b-a749-65c7fff18c66	picture	claim.name
3c0498f0-7f90-446b-a749-65c7fff18c66	String	jsonType.label
7ba91147-1401-4d16-b05a-196403e07cc2	true	introspection.token.claim
7ba91147-1401-4d16-b05a-196403e07cc2	true	userinfo.token.claim
7ba91147-1401-4d16-b05a-196403e07cc2	middleName	user.attribute
7ba91147-1401-4d16-b05a-196403e07cc2	true	id.token.claim
7ba91147-1401-4d16-b05a-196403e07cc2	true	access.token.claim
7ba91147-1401-4d16-b05a-196403e07cc2	middle_name	claim.name
7ba91147-1401-4d16-b05a-196403e07cc2	String	jsonType.label
801e4ae7-d35a-487e-b65c-c6134ba107a0	true	introspection.token.claim
801e4ae7-d35a-487e-b65c-c6134ba107a0	true	userinfo.token.claim
801e4ae7-d35a-487e-b65c-c6134ba107a0	firstName	user.attribute
801e4ae7-d35a-487e-b65c-c6134ba107a0	true	id.token.claim
801e4ae7-d35a-487e-b65c-c6134ba107a0	true	access.token.claim
801e4ae7-d35a-487e-b65c-c6134ba107a0	given_name	claim.name
801e4ae7-d35a-487e-b65c-c6134ba107a0	String	jsonType.label
80cf8e4f-bee9-4339-907a-e14b99469d7e	true	introspection.token.claim
80cf8e4f-bee9-4339-907a-e14b99469d7e	true	userinfo.token.claim
80cf8e4f-bee9-4339-907a-e14b99469d7e	website	user.attribute
80cf8e4f-bee9-4339-907a-e14b99469d7e	true	id.token.claim
80cf8e4f-bee9-4339-907a-e14b99469d7e	true	access.token.claim
80cf8e4f-bee9-4339-907a-e14b99469d7e	website	claim.name
80cf8e4f-bee9-4339-907a-e14b99469d7e	String	jsonType.label
896b8dfa-c4b5-4fe1-b42d-5cf1604b3836	true	introspection.token.claim
896b8dfa-c4b5-4fe1-b42d-5cf1604b3836	true	userinfo.token.claim
896b8dfa-c4b5-4fe1-b42d-5cf1604b3836	zoneinfo	user.attribute
896b8dfa-c4b5-4fe1-b42d-5cf1604b3836	true	id.token.claim
896b8dfa-c4b5-4fe1-b42d-5cf1604b3836	true	access.token.claim
896b8dfa-c4b5-4fe1-b42d-5cf1604b3836	zoneinfo	claim.name
896b8dfa-c4b5-4fe1-b42d-5cf1604b3836	String	jsonType.label
89a74603-0e8a-4c26-ae96-8f2a00c14e94	true	introspection.token.claim
89a74603-0e8a-4c26-ae96-8f2a00c14e94	true	userinfo.token.claim
89a74603-0e8a-4c26-ae96-8f2a00c14e94	lastName	user.attribute
89a74603-0e8a-4c26-ae96-8f2a00c14e94	true	id.token.claim
89a74603-0e8a-4c26-ae96-8f2a00c14e94	true	access.token.claim
89a74603-0e8a-4c26-ae96-8f2a00c14e94	family_name	claim.name
89a74603-0e8a-4c26-ae96-8f2a00c14e94	String	jsonType.label
b22cbb5b-09c5-458c-a8cc-a1c7728664de	true	introspection.token.claim
b22cbb5b-09c5-458c-a8cc-a1c7728664de	true	userinfo.token.claim
b22cbb5b-09c5-458c-a8cc-a1c7728664de	nickname	user.attribute
b22cbb5b-09c5-458c-a8cc-a1c7728664de	true	id.token.claim
b22cbb5b-09c5-458c-a8cc-a1c7728664de	true	access.token.claim
b22cbb5b-09c5-458c-a8cc-a1c7728664de	nickname	claim.name
b22cbb5b-09c5-458c-a8cc-a1c7728664de	String	jsonType.label
bed66452-6ece-457f-96ec-73b5efda71ff	true	introspection.token.claim
bed66452-6ece-457f-96ec-73b5efda71ff	true	userinfo.token.claim
bed66452-6ece-457f-96ec-73b5efda71ff	username	user.attribute
bed66452-6ece-457f-96ec-73b5efda71ff	true	id.token.claim
bed66452-6ece-457f-96ec-73b5efda71ff	true	access.token.claim
bed66452-6ece-457f-96ec-73b5efda71ff	preferred_username	claim.name
bed66452-6ece-457f-96ec-73b5efda71ff	String	jsonType.label
c032dc79-93f3-4729-91b0-6ded7385a646	true	introspection.token.claim
c032dc79-93f3-4729-91b0-6ded7385a646	true	userinfo.token.claim
c032dc79-93f3-4729-91b0-6ded7385a646	profile	user.attribute
c032dc79-93f3-4729-91b0-6ded7385a646	true	id.token.claim
c032dc79-93f3-4729-91b0-6ded7385a646	true	access.token.claim
c032dc79-93f3-4729-91b0-6ded7385a646	profile	claim.name
c032dc79-93f3-4729-91b0-6ded7385a646	String	jsonType.label
c0aa012d-99ee-446d-9a05-eab99c614bc4	true	introspection.token.claim
c0aa012d-99ee-446d-9a05-eab99c614bc4	true	userinfo.token.claim
c0aa012d-99ee-446d-9a05-eab99c614bc4	locale	user.attribute
c0aa012d-99ee-446d-9a05-eab99c614bc4	true	id.token.claim
c0aa012d-99ee-446d-9a05-eab99c614bc4	true	access.token.claim
c0aa012d-99ee-446d-9a05-eab99c614bc4	locale	claim.name
c0aa012d-99ee-446d-9a05-eab99c614bc4	String	jsonType.label
d8c77859-9117-46d0-aff5-d42257252de0	true	introspection.token.claim
d8c77859-9117-46d0-aff5-d42257252de0	true	userinfo.token.claim
d8c77859-9117-46d0-aff5-d42257252de0	birthdate	user.attribute
d8c77859-9117-46d0-aff5-d42257252de0	true	id.token.claim
d8c77859-9117-46d0-aff5-d42257252de0	true	access.token.claim
d8c77859-9117-46d0-aff5-d42257252de0	birthdate	claim.name
d8c77859-9117-46d0-aff5-d42257252de0	String	jsonType.label
e207dbc4-2541-4bc8-8cd0-2444f25b6f4d	true	introspection.token.claim
e207dbc4-2541-4bc8-8cd0-2444f25b6f4d	true	userinfo.token.claim
e207dbc4-2541-4bc8-8cd0-2444f25b6f4d	true	id.token.claim
e207dbc4-2541-4bc8-8cd0-2444f25b6f4d	true	access.token.claim
1eae8737-1a71-4a07-9c3e-77ea23b10244	true	introspection.token.claim
1eae8737-1a71-4a07-9c3e-77ea23b10244	true	userinfo.token.claim
1eae8737-1a71-4a07-9c3e-77ea23b10244	emailVerified	user.attribute
1eae8737-1a71-4a07-9c3e-77ea23b10244	true	id.token.claim
1eae8737-1a71-4a07-9c3e-77ea23b10244	true	access.token.claim
1eae8737-1a71-4a07-9c3e-77ea23b10244	email_verified	claim.name
1eae8737-1a71-4a07-9c3e-77ea23b10244	boolean	jsonType.label
85f3b554-3972-49df-bfa7-c0a9e6930bd2	true	introspection.token.claim
85f3b554-3972-49df-bfa7-c0a9e6930bd2	true	userinfo.token.claim
85f3b554-3972-49df-bfa7-c0a9e6930bd2	email	user.attribute
85f3b554-3972-49df-bfa7-c0a9e6930bd2	true	id.token.claim
85f3b554-3972-49df-bfa7-c0a9e6930bd2	true	access.token.claim
85f3b554-3972-49df-bfa7-c0a9e6930bd2	email	claim.name
85f3b554-3972-49df-bfa7-c0a9e6930bd2	String	jsonType.label
10505e6a-1cba-4b5d-ab10-9e357bb474a3	formatted	user.attribute.formatted
10505e6a-1cba-4b5d-ab10-9e357bb474a3	country	user.attribute.country
10505e6a-1cba-4b5d-ab10-9e357bb474a3	true	introspection.token.claim
10505e6a-1cba-4b5d-ab10-9e357bb474a3	postal_code	user.attribute.postal_code
10505e6a-1cba-4b5d-ab10-9e357bb474a3	true	userinfo.token.claim
10505e6a-1cba-4b5d-ab10-9e357bb474a3	street	user.attribute.street
10505e6a-1cba-4b5d-ab10-9e357bb474a3	true	id.token.claim
10505e6a-1cba-4b5d-ab10-9e357bb474a3	region	user.attribute.region
10505e6a-1cba-4b5d-ab10-9e357bb474a3	true	access.token.claim
10505e6a-1cba-4b5d-ab10-9e357bb474a3	locality	user.attribute.locality
83badbc0-83ac-47d9-b6ec-1dd9062df7be	true	introspection.token.claim
83badbc0-83ac-47d9-b6ec-1dd9062df7be	true	userinfo.token.claim
83badbc0-83ac-47d9-b6ec-1dd9062df7be	phoneNumberVerified	user.attribute
83badbc0-83ac-47d9-b6ec-1dd9062df7be	true	id.token.claim
83badbc0-83ac-47d9-b6ec-1dd9062df7be	true	access.token.claim
83badbc0-83ac-47d9-b6ec-1dd9062df7be	phone_number_verified	claim.name
83badbc0-83ac-47d9-b6ec-1dd9062df7be	boolean	jsonType.label
d79ece71-0d56-4b5c-bf17-e9f659d95b2e	true	introspection.token.claim
d79ece71-0d56-4b5c-bf17-e9f659d95b2e	true	userinfo.token.claim
d79ece71-0d56-4b5c-bf17-e9f659d95b2e	phoneNumber	user.attribute
d79ece71-0d56-4b5c-bf17-e9f659d95b2e	true	id.token.claim
d79ece71-0d56-4b5c-bf17-e9f659d95b2e	true	access.token.claim
d79ece71-0d56-4b5c-bf17-e9f659d95b2e	phone_number	claim.name
d79ece71-0d56-4b5c-bf17-e9f659d95b2e	String	jsonType.label
453fdd5d-9505-4a7a-bc78-9f74dd92beb5	true	introspection.token.claim
453fdd5d-9505-4a7a-bc78-9f74dd92beb5	true	access.token.claim
5a9fadb2-36b2-43b7-ac75-d75caaee2077	true	introspection.token.claim
5a9fadb2-36b2-43b7-ac75-d75caaee2077	true	multivalued
5a9fadb2-36b2-43b7-ac75-d75caaee2077	foo	user.attribute
5a9fadb2-36b2-43b7-ac75-d75caaee2077	true	access.token.claim
5a9fadb2-36b2-43b7-ac75-d75caaee2077	resource_access.${client_id}.roles	claim.name
5a9fadb2-36b2-43b7-ac75-d75caaee2077	String	jsonType.label
c3250a80-14f2-4f05-8e58-78603565ec8f	true	introspection.token.claim
c3250a80-14f2-4f05-8e58-78603565ec8f	true	multivalued
c3250a80-14f2-4f05-8e58-78603565ec8f	foo	user.attribute
c3250a80-14f2-4f05-8e58-78603565ec8f	true	access.token.claim
c3250a80-14f2-4f05-8e58-78603565ec8f	realm_access.roles	claim.name
c3250a80-14f2-4f05-8e58-78603565ec8f	String	jsonType.label
1719b9d5-ce41-4185-8097-ea62830ba1aa	true	introspection.token.claim
1719b9d5-ce41-4185-8097-ea62830ba1aa	true	access.token.claim
25e19c35-be3c-431c-bd7f-e4273e703578	true	introspection.token.claim
25e19c35-be3c-431c-bd7f-e4273e703578	true	multivalued
25e19c35-be3c-431c-bd7f-e4273e703578	foo	user.attribute
25e19c35-be3c-431c-bd7f-e4273e703578	true	id.token.claim
25e19c35-be3c-431c-bd7f-e4273e703578	true	access.token.claim
25e19c35-be3c-431c-bd7f-e4273e703578	groups	claim.name
25e19c35-be3c-431c-bd7f-e4273e703578	String	jsonType.label
29747a97-1d40-49eb-af50-1dda8455f9c5	true	introspection.token.claim
29747a97-1d40-49eb-af50-1dda8455f9c5	true	userinfo.token.claim
29747a97-1d40-49eb-af50-1dda8455f9c5	username	user.attribute
29747a97-1d40-49eb-af50-1dda8455f9c5	true	id.token.claim
29747a97-1d40-49eb-af50-1dda8455f9c5	true	access.token.claim
29747a97-1d40-49eb-af50-1dda8455f9c5	upn	claim.name
29747a97-1d40-49eb-af50-1dda8455f9c5	String	jsonType.label
30bce4b1-c914-4541-980c-443dca3f73c7	true	introspection.token.claim
30bce4b1-c914-4541-980c-443dca3f73c7	true	id.token.claim
30bce4b1-c914-4541-980c-443dca3f73c7	true	access.token.claim
99510a23-95e0-4fe9-9514-594ac8669ff5	true	introspection.token.claim
99510a23-95e0-4fe9-9514-594ac8669ff5	true	access.token.claim
ec4711c3-ebb7-4779-9e5e-23da8459ee98	AUTH_TIME	user.session.note
ec4711c3-ebb7-4779-9e5e-23da8459ee98	true	introspection.token.claim
ec4711c3-ebb7-4779-9e5e-23da8459ee98	true	id.token.claim
ec4711c3-ebb7-4779-9e5e-23da8459ee98	true	access.token.claim
ec4711c3-ebb7-4779-9e5e-23da8459ee98	auth_time	claim.name
ec4711c3-ebb7-4779-9e5e-23da8459ee98	long	jsonType.label
25690d8a-831c-4f46-8542-d42ccda62964	client_id	user.session.note
25690d8a-831c-4f46-8542-d42ccda62964	true	introspection.token.claim
25690d8a-831c-4f46-8542-d42ccda62964	true	id.token.claim
25690d8a-831c-4f46-8542-d42ccda62964	true	access.token.claim
25690d8a-831c-4f46-8542-d42ccda62964	client_id	claim.name
25690d8a-831c-4f46-8542-d42ccda62964	String	jsonType.label
ca0bc1f4-6442-4706-8950-1e7994a2b87f	clientHost	user.session.note
ca0bc1f4-6442-4706-8950-1e7994a2b87f	true	introspection.token.claim
ca0bc1f4-6442-4706-8950-1e7994a2b87f	true	id.token.claim
ca0bc1f4-6442-4706-8950-1e7994a2b87f	true	access.token.claim
ca0bc1f4-6442-4706-8950-1e7994a2b87f	clientHost	claim.name
ca0bc1f4-6442-4706-8950-1e7994a2b87f	String	jsonType.label
cf9b5f80-0673-42f0-8090-e67907f2effc	clientAddress	user.session.note
cf9b5f80-0673-42f0-8090-e67907f2effc	true	introspection.token.claim
cf9b5f80-0673-42f0-8090-e67907f2effc	true	id.token.claim
cf9b5f80-0673-42f0-8090-e67907f2effc	true	access.token.claim
cf9b5f80-0673-42f0-8090-e67907f2effc	clientAddress	claim.name
cf9b5f80-0673-42f0-8090-e67907f2effc	String	jsonType.label
36f8b276-9db8-4e11-bef2-7eef6e96e8d2	true	introspection.token.claim
36f8b276-9db8-4e11-bef2-7eef6e96e8d2	true	multivalued
36f8b276-9db8-4e11-bef2-7eef6e96e8d2	true	id.token.claim
36f8b276-9db8-4e11-bef2-7eef6e96e8d2	true	access.token.claim
36f8b276-9db8-4e11-bef2-7eef6e96e8d2	organization	claim.name
36f8b276-9db8-4e11-bef2-7eef6e96e8d2	String	jsonType.label
7e1dd60e-77df-407b-9605-5a0537d82a93	false	single
7e1dd60e-77df-407b-9605-5a0537d82a93	Basic	attribute.nameformat
7e1dd60e-77df-407b-9605-5a0537d82a93	Role	attribute.name
07a635eb-365e-4109-9e70-6c900c500b32	true	introspection.token.claim
07a635eb-365e-4109-9e70-6c900c500b32	true	userinfo.token.claim
07a635eb-365e-4109-9e70-6c900c500b32	picture	user.attribute
07a635eb-365e-4109-9e70-6c900c500b32	true	id.token.claim
07a635eb-365e-4109-9e70-6c900c500b32	true	access.token.claim
07a635eb-365e-4109-9e70-6c900c500b32	picture	claim.name
07a635eb-365e-4109-9e70-6c900c500b32	String	jsonType.label
09f42ad6-1bf1-41fd-add3-7d557c880b36	true	introspection.token.claim
09f42ad6-1bf1-41fd-add3-7d557c880b36	true	userinfo.token.claim
09f42ad6-1bf1-41fd-add3-7d557c880b36	username	user.attribute
09f42ad6-1bf1-41fd-add3-7d557c880b36	true	id.token.claim
09f42ad6-1bf1-41fd-add3-7d557c880b36	true	access.token.claim
09f42ad6-1bf1-41fd-add3-7d557c880b36	preferred_username	claim.name
09f42ad6-1bf1-41fd-add3-7d557c880b36	String	jsonType.label
3bba9318-49a5-4bbd-9260-92ca07fa5786	true	introspection.token.claim
3bba9318-49a5-4bbd-9260-92ca07fa5786	true	userinfo.token.claim
3bba9318-49a5-4bbd-9260-92ca07fa5786	zoneinfo	user.attribute
3bba9318-49a5-4bbd-9260-92ca07fa5786	true	id.token.claim
3bba9318-49a5-4bbd-9260-92ca07fa5786	true	access.token.claim
3bba9318-49a5-4bbd-9260-92ca07fa5786	zoneinfo	claim.name
3bba9318-49a5-4bbd-9260-92ca07fa5786	String	jsonType.label
58e1ed14-a837-40d2-84f4-2e1057cfb522	true	introspection.token.claim
58e1ed14-a837-40d2-84f4-2e1057cfb522	true	userinfo.token.claim
58e1ed14-a837-40d2-84f4-2e1057cfb522	nickname	user.attribute
58e1ed14-a837-40d2-84f4-2e1057cfb522	true	id.token.claim
58e1ed14-a837-40d2-84f4-2e1057cfb522	true	access.token.claim
58e1ed14-a837-40d2-84f4-2e1057cfb522	nickname	claim.name
58e1ed14-a837-40d2-84f4-2e1057cfb522	String	jsonType.label
66b1b79e-f3cb-4eb3-8b62-abd0c939b833	true	introspection.token.claim
66b1b79e-f3cb-4eb3-8b62-abd0c939b833	true	userinfo.token.claim
66b1b79e-f3cb-4eb3-8b62-abd0c939b833	gender	user.attribute
66b1b79e-f3cb-4eb3-8b62-abd0c939b833	true	id.token.claim
66b1b79e-f3cb-4eb3-8b62-abd0c939b833	true	access.token.claim
66b1b79e-f3cb-4eb3-8b62-abd0c939b833	gender	claim.name
66b1b79e-f3cb-4eb3-8b62-abd0c939b833	String	jsonType.label
795ef095-b316-467f-8217-4cbfac9bc582	true	introspection.token.claim
795ef095-b316-467f-8217-4cbfac9bc582	true	userinfo.token.claim
795ef095-b316-467f-8217-4cbfac9bc582	profile	user.attribute
795ef095-b316-467f-8217-4cbfac9bc582	true	id.token.claim
795ef095-b316-467f-8217-4cbfac9bc582	true	access.token.claim
795ef095-b316-467f-8217-4cbfac9bc582	profile	claim.name
795ef095-b316-467f-8217-4cbfac9bc582	String	jsonType.label
97712647-b507-41c4-9443-67b32bed5090	true	introspection.token.claim
97712647-b507-41c4-9443-67b32bed5090	true	userinfo.token.claim
97712647-b507-41c4-9443-67b32bed5090	middleName	user.attribute
97712647-b507-41c4-9443-67b32bed5090	true	id.token.claim
97712647-b507-41c4-9443-67b32bed5090	true	access.token.claim
97712647-b507-41c4-9443-67b32bed5090	middle_name	claim.name
97712647-b507-41c4-9443-67b32bed5090	String	jsonType.label
a33298c3-1e8b-446b-ab77-b799ca8d61ca	true	introspection.token.claim
a33298c3-1e8b-446b-ab77-b799ca8d61ca	true	userinfo.token.claim
a33298c3-1e8b-446b-ab77-b799ca8d61ca	updatedAt	user.attribute
a33298c3-1e8b-446b-ab77-b799ca8d61ca	true	id.token.claim
a33298c3-1e8b-446b-ab77-b799ca8d61ca	true	access.token.claim
a33298c3-1e8b-446b-ab77-b799ca8d61ca	updated_at	claim.name
a33298c3-1e8b-446b-ab77-b799ca8d61ca	long	jsonType.label
a917c9ae-38cf-4661-a7ce-34566a7a7204	true	introspection.token.claim
a917c9ae-38cf-4661-a7ce-34566a7a7204	true	userinfo.token.claim
a917c9ae-38cf-4661-a7ce-34566a7a7204	birthdate	user.attribute
a917c9ae-38cf-4661-a7ce-34566a7a7204	true	id.token.claim
a917c9ae-38cf-4661-a7ce-34566a7a7204	true	access.token.claim
a917c9ae-38cf-4661-a7ce-34566a7a7204	birthdate	claim.name
a917c9ae-38cf-4661-a7ce-34566a7a7204	String	jsonType.label
c3aa2451-3ed1-44b1-b0bb-d3feb4ac739d	true	introspection.token.claim
c3aa2451-3ed1-44b1-b0bb-d3feb4ac739d	true	userinfo.token.claim
c3aa2451-3ed1-44b1-b0bb-d3feb4ac739d	lastName	user.attribute
c3aa2451-3ed1-44b1-b0bb-d3feb4ac739d	true	id.token.claim
c3aa2451-3ed1-44b1-b0bb-d3feb4ac739d	true	access.token.claim
c3aa2451-3ed1-44b1-b0bb-d3feb4ac739d	family_name	claim.name
c3aa2451-3ed1-44b1-b0bb-d3feb4ac739d	String	jsonType.label
c452ba09-64a0-46a2-a603-f564bf7e5dc0	true	introspection.token.claim
c452ba09-64a0-46a2-a603-f564bf7e5dc0	true	userinfo.token.claim
c452ba09-64a0-46a2-a603-f564bf7e5dc0	true	id.token.claim
c452ba09-64a0-46a2-a603-f564bf7e5dc0	true	access.token.claim
c8b1efe0-a5aa-4526-958c-8d404e6baf11	true	introspection.token.claim
c8b1efe0-a5aa-4526-958c-8d404e6baf11	true	userinfo.token.claim
c8b1efe0-a5aa-4526-958c-8d404e6baf11	locale	user.attribute
c8b1efe0-a5aa-4526-958c-8d404e6baf11	true	id.token.claim
c8b1efe0-a5aa-4526-958c-8d404e6baf11	true	access.token.claim
c8b1efe0-a5aa-4526-958c-8d404e6baf11	locale	claim.name
c8b1efe0-a5aa-4526-958c-8d404e6baf11	String	jsonType.label
ef7e33f6-47cb-42e6-a1b6-ec687229d5fb	true	introspection.token.claim
ef7e33f6-47cb-42e6-a1b6-ec687229d5fb	true	userinfo.token.claim
ef7e33f6-47cb-42e6-a1b6-ec687229d5fb	firstName	user.attribute
ef7e33f6-47cb-42e6-a1b6-ec687229d5fb	true	id.token.claim
ef7e33f6-47cb-42e6-a1b6-ec687229d5fb	true	access.token.claim
ef7e33f6-47cb-42e6-a1b6-ec687229d5fb	given_name	claim.name
ef7e33f6-47cb-42e6-a1b6-ec687229d5fb	String	jsonType.label
f674f0e0-9963-4ea8-8ca6-f0039cf72a62	true	introspection.token.claim
f674f0e0-9963-4ea8-8ca6-f0039cf72a62	true	userinfo.token.claim
f674f0e0-9963-4ea8-8ca6-f0039cf72a62	website	user.attribute
f674f0e0-9963-4ea8-8ca6-f0039cf72a62	true	id.token.claim
f674f0e0-9963-4ea8-8ca6-f0039cf72a62	true	access.token.claim
f674f0e0-9963-4ea8-8ca6-f0039cf72a62	website	claim.name
f674f0e0-9963-4ea8-8ca6-f0039cf72a62	String	jsonType.label
0b050024-8df5-45f1-8da9-acbe41c1633a	true	introspection.token.claim
0b050024-8df5-45f1-8da9-acbe41c1633a	true	userinfo.token.claim
0b050024-8df5-45f1-8da9-acbe41c1633a	email	user.attribute
0b050024-8df5-45f1-8da9-acbe41c1633a	true	id.token.claim
0b050024-8df5-45f1-8da9-acbe41c1633a	true	access.token.claim
0b050024-8df5-45f1-8da9-acbe41c1633a	email	claim.name
0b050024-8df5-45f1-8da9-acbe41c1633a	String	jsonType.label
b3f5afb3-ecdb-4521-b093-0610fae52b01	true	introspection.token.claim
b3f5afb3-ecdb-4521-b093-0610fae52b01	true	userinfo.token.claim
b3f5afb3-ecdb-4521-b093-0610fae52b01	emailVerified	user.attribute
b3f5afb3-ecdb-4521-b093-0610fae52b01	true	id.token.claim
b3f5afb3-ecdb-4521-b093-0610fae52b01	true	access.token.claim
b3f5afb3-ecdb-4521-b093-0610fae52b01	email_verified	claim.name
b3f5afb3-ecdb-4521-b093-0610fae52b01	boolean	jsonType.label
1cdfdd42-4a96-4d51-a2e5-4d6bb6b96f22	formatted	user.attribute.formatted
1cdfdd42-4a96-4d51-a2e5-4d6bb6b96f22	country	user.attribute.country
1cdfdd42-4a96-4d51-a2e5-4d6bb6b96f22	true	introspection.token.claim
1cdfdd42-4a96-4d51-a2e5-4d6bb6b96f22	postal_code	user.attribute.postal_code
1cdfdd42-4a96-4d51-a2e5-4d6bb6b96f22	true	userinfo.token.claim
1cdfdd42-4a96-4d51-a2e5-4d6bb6b96f22	street	user.attribute.street
1cdfdd42-4a96-4d51-a2e5-4d6bb6b96f22	true	id.token.claim
1cdfdd42-4a96-4d51-a2e5-4d6bb6b96f22	region	user.attribute.region
1cdfdd42-4a96-4d51-a2e5-4d6bb6b96f22	true	access.token.claim
1cdfdd42-4a96-4d51-a2e5-4d6bb6b96f22	locality	user.attribute.locality
2b2fe963-8603-4ff6-a51c-eae57e5356b7	true	introspection.token.claim
2b2fe963-8603-4ff6-a51c-eae57e5356b7	true	userinfo.token.claim
2b2fe963-8603-4ff6-a51c-eae57e5356b7	phoneNumber	user.attribute
2b2fe963-8603-4ff6-a51c-eae57e5356b7	true	id.token.claim
2b2fe963-8603-4ff6-a51c-eae57e5356b7	true	access.token.claim
2b2fe963-8603-4ff6-a51c-eae57e5356b7	phone_number	claim.name
2b2fe963-8603-4ff6-a51c-eae57e5356b7	String	jsonType.label
a9b0f5c6-7d87-4eec-a175-ba233cc2971d	true	introspection.token.claim
a9b0f5c6-7d87-4eec-a175-ba233cc2971d	true	userinfo.token.claim
a9b0f5c6-7d87-4eec-a175-ba233cc2971d	phoneNumberVerified	user.attribute
a9b0f5c6-7d87-4eec-a175-ba233cc2971d	true	id.token.claim
a9b0f5c6-7d87-4eec-a175-ba233cc2971d	true	access.token.claim
a9b0f5c6-7d87-4eec-a175-ba233cc2971d	phone_number_verified	claim.name
a9b0f5c6-7d87-4eec-a175-ba233cc2971d	boolean	jsonType.label
06c85da1-6552-419d-818d-d623e6a9e5cc	true	introspection.token.claim
06c85da1-6552-419d-818d-d623e6a9e5cc	true	multivalued
06c85da1-6552-419d-818d-d623e6a9e5cc	foo	user.attribute
06c85da1-6552-419d-818d-d623e6a9e5cc	true	access.token.claim
06c85da1-6552-419d-818d-d623e6a9e5cc	realm_access.roles	claim.name
06c85da1-6552-419d-818d-d623e6a9e5cc	String	jsonType.label
3d2cbcc9-097e-4d8b-bf38-88047801f8d9	true	introspection.token.claim
3d2cbcc9-097e-4d8b-bf38-88047801f8d9	true	multivalued
3d2cbcc9-097e-4d8b-bf38-88047801f8d9	foo	user.attribute
3d2cbcc9-097e-4d8b-bf38-88047801f8d9	true	access.token.claim
3d2cbcc9-097e-4d8b-bf38-88047801f8d9	resource_access.${client_id}.roles	claim.name
3d2cbcc9-097e-4d8b-bf38-88047801f8d9	String	jsonType.label
adaa766f-d12f-4756-9ba7-b622ac5aec2c	true	introspection.token.claim
adaa766f-d12f-4756-9ba7-b622ac5aec2c	true	access.token.claim
9a5ea4e9-40f5-4189-b938-f3617f0bb43d	true	introspection.token.claim
9a5ea4e9-40f5-4189-b938-f3617f0bb43d	true	access.token.claim
6cfffaaa-683f-48e7-a8a4-2c38a1462bfb	true	introspection.token.claim
6cfffaaa-683f-48e7-a8a4-2c38a1462bfb	true	multivalued
6cfffaaa-683f-48e7-a8a4-2c38a1462bfb	foo	user.attribute
6cfffaaa-683f-48e7-a8a4-2c38a1462bfb	true	id.token.claim
6cfffaaa-683f-48e7-a8a4-2c38a1462bfb	true	access.token.claim
6cfffaaa-683f-48e7-a8a4-2c38a1462bfb	groups	claim.name
6cfffaaa-683f-48e7-a8a4-2c38a1462bfb	String	jsonType.label
83612980-b7c7-4a02-9464-f5a61e4a061d	true	introspection.token.claim
83612980-b7c7-4a02-9464-f5a61e4a061d	true	userinfo.token.claim
83612980-b7c7-4a02-9464-f5a61e4a061d	username	user.attribute
83612980-b7c7-4a02-9464-f5a61e4a061d	true	id.token.claim
83612980-b7c7-4a02-9464-f5a61e4a061d	true	access.token.claim
83612980-b7c7-4a02-9464-f5a61e4a061d	upn	claim.name
83612980-b7c7-4a02-9464-f5a61e4a061d	String	jsonType.label
bcdac89b-f1b1-44b9-b7d3-a351fdbd2107	true	introspection.token.claim
bcdac89b-f1b1-44b9-b7d3-a351fdbd2107	true	id.token.claim
bcdac89b-f1b1-44b9-b7d3-a351fdbd2107	true	access.token.claim
0448ca3b-e220-4bf3-b260-5c1501ea8ad7	AUTH_TIME	user.session.note
0448ca3b-e220-4bf3-b260-5c1501ea8ad7	true	introspection.token.claim
0448ca3b-e220-4bf3-b260-5c1501ea8ad7	true	id.token.claim
0448ca3b-e220-4bf3-b260-5c1501ea8ad7	true	access.token.claim
0448ca3b-e220-4bf3-b260-5c1501ea8ad7	auth_time	claim.name
0448ca3b-e220-4bf3-b260-5c1501ea8ad7	long	jsonType.label
0eaaf718-64fb-4eb0-add0-d02ea3e5d3cf	true	introspection.token.claim
0eaaf718-64fb-4eb0-add0-d02ea3e5d3cf	true	access.token.claim
2dc4036a-4a73-4db8-baea-c8f08f2d114a	client_id	user.session.note
2dc4036a-4a73-4db8-baea-c8f08f2d114a	true	introspection.token.claim
2dc4036a-4a73-4db8-baea-c8f08f2d114a	true	id.token.claim
2dc4036a-4a73-4db8-baea-c8f08f2d114a	true	access.token.claim
2dc4036a-4a73-4db8-baea-c8f08f2d114a	client_id	claim.name
2dc4036a-4a73-4db8-baea-c8f08f2d114a	String	jsonType.label
61146c24-163e-481c-a62f-83559e1e097d	clientHost	user.session.note
61146c24-163e-481c-a62f-83559e1e097d	true	introspection.token.claim
61146c24-163e-481c-a62f-83559e1e097d	true	id.token.claim
61146c24-163e-481c-a62f-83559e1e097d	true	access.token.claim
61146c24-163e-481c-a62f-83559e1e097d	clientHost	claim.name
61146c24-163e-481c-a62f-83559e1e097d	String	jsonType.label
c4e2d59e-8e0f-4db4-b684-784421deda78	clientAddress	user.session.note
c4e2d59e-8e0f-4db4-b684-784421deda78	true	introspection.token.claim
c4e2d59e-8e0f-4db4-b684-784421deda78	true	id.token.claim
c4e2d59e-8e0f-4db4-b684-784421deda78	true	access.token.claim
c4e2d59e-8e0f-4db4-b684-784421deda78	clientAddress	claim.name
c4e2d59e-8e0f-4db4-b684-784421deda78	String	jsonType.label
0d2543e0-8dc3-4ad4-86a8-12f4e0fe1829	true	introspection.token.claim
0d2543e0-8dc3-4ad4-86a8-12f4e0fe1829	true	multivalued
0d2543e0-8dc3-4ad4-86a8-12f4e0fe1829	true	id.token.claim
0d2543e0-8dc3-4ad4-86a8-12f4e0fe1829	true	access.token.claim
0d2543e0-8dc3-4ad4-86a8-12f4e0fe1829	organization	claim.name
0d2543e0-8dc3-4ad4-86a8-12f4e0fe1829	String	jsonType.label
b88a7fdd-dcdd-441c-b504-9882c0e47942	true	introspection.token.claim
b88a7fdd-dcdd-441c-b504-9882c0e47942	true	userinfo.token.claim
b88a7fdd-dcdd-441c-b504-9882c0e47942	locale	user.attribute
b88a7fdd-dcdd-441c-b504-9882c0e47942	true	id.token.claim
b88a7fdd-dcdd-441c-b504-9882c0e47942	true	access.token.claim
b88a7fdd-dcdd-441c-b504-9882c0e47942	locale	claim.name
b88a7fdd-dcdd-441c-b504-9882c0e47942	String	jsonType.label
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role, display_name) FROM stdin;
e7107428-2e29-4f5c-b9b0-26341d6ad9ba	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	727bf2a1-6b03-4c06-88ff-5710a91cde68	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	52d7de4a-288f-4227-add6-195247d301ae	f5108288-dc2b-4b3e-b71e-28fe19b85ee5	09b816ea-122e-4457-bfce-daf26456660c	97bedeaa-0569-48be-99f2-d4208f5f192b	2993cfc9-b16c-4a00-9466-15a3c366c827	2592000	f	900	t	f	04ec2a75-7275-4a0c-a5e5-c7f2f04f8f6b	0	f	0	0	6a0bc16e-872b-4c44-ae7b-16dea5221812	Keycloak
16778b9e-50cb-4ccd-8250-1e80093e3d7e	60	300	300	\N	\N	\N	t	f	0	\N	eniaclabs	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	9eac8266-847b-4518-a656-b3d4bbb3bab4	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	a057c2b4-4743-4176-a830-8fbe1a2e8222	9673faae-83c0-41e4-8dcb-9b01fa4b0e4c	3ddbe808-9ec6-4246-a242-f93511740a2e	900557ba-269b-4086-8e3a-e2c32896c600	a407cd9d-2730-427c-a4b5-ebcbbd4e8861	2592000	f	900	t	f	4a2c6a64-8c25-43c5-9fb2-38e9b0947468	0	f	0	0	e42b75f9-c709-4bd0-beac-4333775dfa6f	\N
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	
_browser_header.xContentTypeOptions	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	nosniff
_browser_header.referrerPolicy	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	no-referrer
_browser_header.xRobotsTag	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	none
_browser_header.xFrameOptions	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	SAMEORIGIN
_browser_header.contentSecurityPolicy	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.strictTransportSecurity	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	max-age=31536000; includeSubDomains
bruteForceProtected	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	false
permanentLockout	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	false
maxTemporaryLockouts	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	0
bruteForceStrategy	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	MULTIPLE
maxFailureWaitSeconds	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	900
minimumQuickLoginWaitSeconds	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	60
waitIncrementSeconds	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	60
quickLoginCheckMilliSeconds	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	1000
maxDeltaTimeSeconds	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	43200
failureFactor	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	30
maxSecondaryAuthFailures	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	0
realmReusableOtpCode	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	false
firstBrokerLoginFlowId	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	df69000b-52d8-4fd2-91df-b5e8f8720191
displayNameHtml	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	RS256
offlineSessionMaxLifespanEnabled	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	false
offlineSessionMaxLifespan	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	5184000
_browser_header.contentSecurityPolicyReportOnly	16778b9e-50cb-4ccd-8250-1e80093e3d7e	
_browser_header.xContentTypeOptions	16778b9e-50cb-4ccd-8250-1e80093e3d7e	nosniff
_browser_header.referrerPolicy	16778b9e-50cb-4ccd-8250-1e80093e3d7e	no-referrer
_browser_header.xRobotsTag	16778b9e-50cb-4ccd-8250-1e80093e3d7e	none
_browser_header.xFrameOptions	16778b9e-50cb-4ccd-8250-1e80093e3d7e	SAMEORIGIN
_browser_header.contentSecurityPolicy	16778b9e-50cb-4ccd-8250-1e80093e3d7e	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.strictTransportSecurity	16778b9e-50cb-4ccd-8250-1e80093e3d7e	max-age=31536000; includeSubDomains
bruteForceProtected	16778b9e-50cb-4ccd-8250-1e80093e3d7e	false
permanentLockout	16778b9e-50cb-4ccd-8250-1e80093e3d7e	false
maxTemporaryLockouts	16778b9e-50cb-4ccd-8250-1e80093e3d7e	0
bruteForceStrategy	16778b9e-50cb-4ccd-8250-1e80093e3d7e	MULTIPLE
maxFailureWaitSeconds	16778b9e-50cb-4ccd-8250-1e80093e3d7e	900
minimumQuickLoginWaitSeconds	16778b9e-50cb-4ccd-8250-1e80093e3d7e	60
waitIncrementSeconds	16778b9e-50cb-4ccd-8250-1e80093e3d7e	60
quickLoginCheckMilliSeconds	16778b9e-50cb-4ccd-8250-1e80093e3d7e	1000
maxDeltaTimeSeconds	16778b9e-50cb-4ccd-8250-1e80093e3d7e	43200
failureFactor	16778b9e-50cb-4ccd-8250-1e80093e3d7e	30
maxSecondaryAuthFailures	16778b9e-50cb-4ccd-8250-1e80093e3d7e	0
realmReusableOtpCode	16778b9e-50cb-4ccd-8250-1e80093e3d7e	false
defaultSignatureAlgorithm	16778b9e-50cb-4ccd-8250-1e80093e3d7e	RS256
offlineSessionMaxLifespanEnabled	16778b9e-50cb-4ccd-8250-1e80093e3d7e	false
offlineSessionMaxLifespan	16778b9e-50cb-4ccd-8250-1e80093e3d7e	5184000
actionTokenGeneratedByAdminLifespan	16778b9e-50cb-4ccd-8250-1e80093e3d7e	43200
actionTokenGeneratedByUserLifespan	16778b9e-50cb-4ccd-8250-1e80093e3d7e	300
oauth2DeviceCodeLifespan	16778b9e-50cb-4ccd-8250-1e80093e3d7e	600
oauth2DevicePollingInterval	16778b9e-50cb-4ccd-8250-1e80093e3d7e	5
webAuthnPolicyRpEntityName	16778b9e-50cb-4ccd-8250-1e80093e3d7e	keycloak
webAuthnPolicySignatureAlgorithms	16778b9e-50cb-4ccd-8250-1e80093e3d7e	ES256,RS256
webAuthnPolicyRpId	16778b9e-50cb-4ccd-8250-1e80093e3d7e	
webAuthnPolicyAttestationConveyancePreference	16778b9e-50cb-4ccd-8250-1e80093e3d7e	not specified
webAuthnPolicyAuthenticatorAttachment	16778b9e-50cb-4ccd-8250-1e80093e3d7e	not specified
webAuthnPolicyResidentKey	16778b9e-50cb-4ccd-8250-1e80093e3d7e	not specified
webAuthnPolicyRequireResidentKey	16778b9e-50cb-4ccd-8250-1e80093e3d7e	not specified
webAuthnPolicyUserVerificationRequirement	16778b9e-50cb-4ccd-8250-1e80093e3d7e	not specified
webAuthnPolicyCreateTimeout	16778b9e-50cb-4ccd-8250-1e80093e3d7e	0
webAuthnPolicyAvoidSameAuthenticatorRegister	16778b9e-50cb-4ccd-8250-1e80093e3d7e	false
webAuthnPolicyRpEntityNamePasswordless	16778b9e-50cb-4ccd-8250-1e80093e3d7e	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	16778b9e-50cb-4ccd-8250-1e80093e3d7e	ES256,RS256
webAuthnPolicyRpIdPasswordless	16778b9e-50cb-4ccd-8250-1e80093e3d7e	
webAuthnPolicyAttestationConveyancePreferencePasswordless	16778b9e-50cb-4ccd-8250-1e80093e3d7e	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	16778b9e-50cb-4ccd-8250-1e80093e3d7e	not specified
webAuthnPolicyResidentKeyPasswordless	16778b9e-50cb-4ccd-8250-1e80093e3d7e	required
webAuthnPolicyRequireResidentKeyPasswordless	16778b9e-50cb-4ccd-8250-1e80093e3d7e	not specified
webAuthnPolicyUserVerificationRequirementPasswordless	16778b9e-50cb-4ccd-8250-1e80093e3d7e	required
webAuthnPolicyCreateTimeoutPasswordless	16778b9e-50cb-4ccd-8250-1e80093e3d7e	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	16778b9e-50cb-4ccd-8250-1e80093e3d7e	false
cibaBackchannelTokenDeliveryMode	16778b9e-50cb-4ccd-8250-1e80093e3d7e	poll
cibaExpiresIn	16778b9e-50cb-4ccd-8250-1e80093e3d7e	120
cibaInterval	16778b9e-50cb-4ccd-8250-1e80093e3d7e	5
cibaAuthRequestedUserHint	16778b9e-50cb-4ccd-8250-1e80093e3d7e	login_hint
parRequestUriLifespan	16778b9e-50cb-4ccd-8250-1e80093e3d7e	60
firstBrokerLoginFlowId	16778b9e-50cb-4ccd-8250-1e80093e3d7e	219e3f50-5306-4819-bc6b-78c9458037e8
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
e7107428-2e29-4f5c-b9b0-26341d6ad9ba	jboss-logging
16778b9e-50cb-4ccd-8250-1e80093e3d7e	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	e7107428-2e29-4f5c-b9b0-26341d6ad9ba
password	password	t	t	16778b9e-50cb-4ccd-8250-1e80093e3d7e
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.redirect_uris (client_id, value) FROM stdin;
11c4e2f2-6350-491d-b968-ea462bbc2ffa	/realms/master/account/*
546d4646-e2b4-4715-86bd-cf8e84405f59	/realms/master/account/*
1fc3ed36-de0f-475c-a220-69e3cdc7bc16	/admin/master/console/*
7c82d307-0ab0-49b1-9cd4-fadd06207309	/realms/eniaclabs/account/*
72b2a634-cd62-465a-88c1-070cdfaad787	/realms/eniaclabs/account/*
839d8416-a602-45b7-a9d9-88bc3119aea9	/admin/eniaclabs/console/*
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	http://localhost:4200/*
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	*
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	https://localhost:4200/*
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
cfb9ef00-2685-4426-98df-447f98c9a8c8	VERIFY_EMAIL	Verify Email	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	t	f	VERIFY_EMAIL	50
242be9c7-a912-4784-bb08-355e57fc9c64	UPDATE_PROFILE	Update Profile	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	t	f	UPDATE_PROFILE	40
d5b0b31b-52b2-429d-84a7-e643039cf751	CONFIGURE_TOTP	Configure OTP	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	t	f	CONFIGURE_TOTP	54
7e7cd95f-7794-4e40-be06-95dc89c11c0c	UPDATE_PASSWORD	Update Password	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	t	f	UPDATE_PASSWORD	57
d6ac47b4-f98d-437a-a12a-5487293eff06	TERMS_AND_CONDITIONS	Terms and Conditions	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	f	f	TERMS_AND_CONDITIONS	20
64f02f1f-ccda-411f-ae63-a39534bbb665	delete_account	Delete Account	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	f	f	delete_account	60
f8458fab-87fd-472c-847d-dffbcd56ec78	delete_credential	Delete Credential	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	t	f	delete_credential	110
1043ab05-9091-4047-ad89-190bb5b82c30	update_user_locale	Update User Locale	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	t	f	update_user_locale	1000
be757745-f5c5-428f-be83-cb5b84ffaa15	UPDATE_EMAIL	Update Email	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	f	f	UPDATE_EMAIL	70
0c8fac94-3fbd-4069-98c8-705f59820ec9	CONFIGURE_RECOVERY_AUTHN_CODES	Recovery Authentication Codes	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	t	f	CONFIGURE_RECOVERY_AUTHN_CODES	130
44499740-84f9-4e62-8e78-35391f078a47	webauthn-register	Webauthn Register	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	t	f	webauthn-register	80
a906e054-a758-45ca-b2b8-bc3717a30058	webauthn-register-passwordless	Webauthn Register Passwordless	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	t	f	webauthn-register-passwordless	90
c4a7dc7a-e0f5-4bdb-91e0-033122ac53e4	VERIFY_PROFILE	Verify Profile	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	t	f	VERIFY_PROFILE	100
fd75ee37-ca9d-4489-bb0b-27611ddc2614	idp_link	Linking Identity Provider	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	t	f	idp_link	120
1c8472a8-286e-4860-9db2-b446e57a5f08	VERIFY_EMAIL	Verify Email	16778b9e-50cb-4ccd-8250-1e80093e3d7e	t	f	VERIFY_EMAIL	50
c9c81015-cdea-4a53-abd3-57f1fe996e29	UPDATE_PROFILE	Update Profile	16778b9e-50cb-4ccd-8250-1e80093e3d7e	t	f	UPDATE_PROFILE	40
f80c0511-9af7-4e29-a067-135a3ac782dc	CONFIGURE_TOTP	Configure OTP	16778b9e-50cb-4ccd-8250-1e80093e3d7e	t	f	CONFIGURE_TOTP	54
d2c85f06-c26e-4207-b9d4-24186f2c9ada	UPDATE_PASSWORD	Update Password	16778b9e-50cb-4ccd-8250-1e80093e3d7e	t	f	UPDATE_PASSWORD	57
44ae3d12-cb18-41e4-8dfc-90da34cd479c	TERMS_AND_CONDITIONS	Terms and Conditions	16778b9e-50cb-4ccd-8250-1e80093e3d7e	f	f	TERMS_AND_CONDITIONS	20
7e0edab7-0876-44c1-91c4-570671ac4bf8	delete_account	Delete Account	16778b9e-50cb-4ccd-8250-1e80093e3d7e	f	f	delete_account	60
fb787f2b-bb9b-4610-a147-c2e1bb03e952	delete_credential	Delete Credential	16778b9e-50cb-4ccd-8250-1e80093e3d7e	t	f	delete_credential	110
3371e2ea-75b4-4e96-a33a-0705a77db6c7	update_user_locale	Update User Locale	16778b9e-50cb-4ccd-8250-1e80093e3d7e	t	f	update_user_locale	1000
fefbee09-cbc3-4263-9429-276940441e8b	UPDATE_EMAIL	Update Email	16778b9e-50cb-4ccd-8250-1e80093e3d7e	f	f	UPDATE_EMAIL	70
f0f08400-149e-4887-b9c9-3f4a90098b42	CONFIGURE_RECOVERY_AUTHN_CODES	Recovery Authentication Codes	16778b9e-50cb-4ccd-8250-1e80093e3d7e	t	f	CONFIGURE_RECOVERY_AUTHN_CODES	130
8937e505-016f-433e-ac04-8f89794418d5	webauthn-register	Webauthn Register	16778b9e-50cb-4ccd-8250-1e80093e3d7e	t	f	webauthn-register	80
abd4c0f6-32b4-41c4-aa55-5b27f031db92	webauthn-register-passwordless	Webauthn Register Passwordless	16778b9e-50cb-4ccd-8250-1e80093e3d7e	t	f	webauthn-register-passwordless	90
54700573-2619-4a42-993a-7db45d3a7073	VERIFY_PROFILE	Verify Profile	16778b9e-50cb-4ccd-8250-1e80093e3d7e	t	f	VERIFY_PROFILE	100
5e896eba-528f-4cda-9304-a4ed7676856c	idp_link	Linking Identity Provider	16778b9e-50cb-4ccd-8250-1e80093e3d7e	t	f	idp_link	120
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: revoked_token; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.revoked_token (id, expire) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: root_auth_session; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.root_auth_session (id, realm_id, "timestamp", version, session_bucket, created_on, timestamp_coarse) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
546d4646-e2b4-4715-86bd-cf8e84405f59	e2dd4f5a-baa9-40f4-b0ac-c777d4487eae
546d4646-e2b4-4715-86bd-cf8e84405f59	2fb125f8-b4f9-4fb5-a95c-1320a9a967d3
72b2a634-cd62-465a-88c1-070cdfaad787	40fdb277-9caa-4710-ad59-1e6c2452df70
72b2a634-cd62-465a-88c1-070cdfaad787	ac7cf7db-550c-4199-999e-846b207bf45c
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: server_config; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.server_config (server_config_key, value, version) FROM stdin;
exp-realm-login-failure-16778b9e-50cb-4ccd-8250-1e80093e3d7e	1795164987	1155
exp-realm-login-failure-e7107428-2e29-4f5c-b9b0-26341d6ad9ba	1795164987	1159
\.


--
-- Data for Name: single_use_object; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.single_use_object (id, notes, expire) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.user_attribute (name, value, user_id, id, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
is_temporary_admin	true	43c72179-5374-4c43-ba1d-b3bbd92bded1	f9c481d4-3320-431c-b19e-4f2b9f81150b	\N	\N	\N
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.user_consent_client_scope (user_consent_id, scope_id, parameter) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before, last_modified_timestamp) FROM stdin;
43c72179-5374-4c43-ba1d-b3bbd92bded1	\N	08930b03-c194-476d-894b-6552817018ad	f	t	\N	\N	\N	e7107428-2e29-4f5c-b9b0-26341d6ad9ba	admin	1792733484728	\N	0	1792733484728
f6e310f2-39a9-4774-a6f6-da6068e63ab8	cliente1@eniaclabs.pe	cliente1@eniaclabs.pe	t	t	\N	Cliente	Uno	16778b9e-50cb-4ccd-8250-1e80093e3d7e	cliente1	1792737538842	\N	0	1792737538842
c7ea15f0-810c-416c-a912-6ee86590f010	admin@eniaclabs.pe	admin@eniaclabs.pe	t	t	\N	Admin	Eniac	16778b9e-50cb-4ccd-8250-1e80093e3d7e	admin	1792737545697	\N	0	1792737545697
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.user_group_membership (group_id, user_id, membership_type) FROM stdin;
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
6a0bc16e-872b-4c44-ae7b-16dea5221812	43c72179-5374-4c43-ba1d-b3bbd92bded1
55c449af-77fa-4a46-a813-2e59895d2a9e	43c72179-5374-4c43-ba1d-b3bbd92bded1
e42b75f9-c709-4bd0-beac-4333775dfa6f	f6e310f2-39a9-4774-a6f6-da6068e63ab8
ec5ea76b-e37e-484e-b906-8af3ed3a7513	f6e310f2-39a9-4774-a6f6-da6068e63ab8
e42b75f9-c709-4bd0-beac-4333775dfa6f	c7ea15f0-810c-416c-a912-6ee86590f010
f1f7df74-2b72-4630-9f03-bb513e32b3ae	c7ea15f0-810c-416c-a912-6ee86590f010
574fab0f-d02e-41c1-ad7e-ccae12655673	c7ea15f0-810c-416c-a912-6ee86590f010
\.


--
-- Data for Name: user_ver_credential; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.user_ver_credential (id, client_scope_id, user_id, revision, created_date, updated_date, user_attributes, version) FROM stdin;
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.web_origins (client_id, value) FROM stdin;
1fc3ed36-de0f-475c-a220-69e3cdc7bc16	+
839d8416-a602-45b7-a9d9-88bc3119aea9	+
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	https://localhost:4200
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	*
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	+
25f3d0d8-5401-4761-8cae-2ab2f08ad3b5	http://localhost:4200
\.


--
-- Data for Name: workflow_state; Type: TABLE DATA; Schema: public; Owner: eniaclabs_keycloak
--

COPY public.workflow_state (execution_id, resource_id, workflow_id, resource_type, scheduled_step_id, scheduled_step_timestamp) FROM stdin;
\.


--
-- Name: org_domain ORG_DOMAIN_pkey; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.org_domain
    ADD CONSTRAINT "ORG_DOMAIN_pkey" PRIMARY KEY (id, name);


--
-- Name: org ORG_pkey; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT "ORG_pkey" PRIMARY KEY (id);


--
-- Name: server_config SERVER_CONFIG_pkey; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.server_config
    ADD CONSTRAINT "SERVER_CONFIG_pkey" PRIMARY KEY (server_config_key);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id, parameter);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id, parameter);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: jgroups_ping constraint_jgroups_ping; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.jgroups_ping
    ADD CONSTRAINT constraint_jgroups_ping PRIMARY KEY (address);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: org_invitation constraint_org_invitation; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.org_invitation
    ADD CONSTRAINT constraint_org_invitation PRIMARY KEY (id);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: revoked_token constraint_rt; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.revoked_token
    ADD CONSTRAINT constraint_rt PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: user_ver_credential constraint_vcred_pm; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_ver_credential
    ADD CONSTRAINT constraint_vcred_pm PRIMARY KEY (id);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: auth_session pk_auth_session; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.auth_session
    ADD CONSTRAINT pk_auth_session PRIMARY KEY (root_auth_session_id, tab_id);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: cluster_event pk_cluster_event; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.cluster_event
    ADD CONSTRAINT pk_cluster_event PRIMARY KEY (id, target_cluster);


--
-- Name: fed_issued_ver_credential pk_fed_issued_ver_credential; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.fed_issued_ver_credential
    ADD CONSTRAINT pk_fed_issued_ver_credential PRIMARY KEY (id);


--
-- Name: fed_user_ver_credential pk_fed_user_ver_credential; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.fed_user_ver_credential
    ADD CONSTRAINT pk_fed_user_ver_credential PRIMARY KEY (id);


--
-- Name: issued_ver_credential pk_issued_ver_credential; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.issued_ver_credential
    ADD CONSTRAINT pk_issued_ver_credential PRIMARY KEY (id);


--
-- Name: login_failure pk_login_failure; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.login_failure
    ADD CONSTRAINT pk_login_failure PRIMARY KEY (realm_id, user_id);


--
-- Name: org_identity_provider pk_org_idp; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.org_identity_provider
    ADD CONSTRAINT pk_org_idp PRIMARY KEY (organization_id, identity_provider_id);


--
-- Name: outbox_entry pk_outbox_entry; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.outbox_entry
    ADD CONSTRAINT pk_outbox_entry PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: root_auth_session pk_root_auth_session; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.root_auth_session
    ADD CONSTRAINT pk_root_auth_session PRIMARY KEY (id);


--
-- Name: single_use_object pk_single_use_object; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.single_use_object
    ADD CONSTRAINT pk_single_use_object PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: workflow_state pk_workflow_state; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.workflow_state
    ADD CONSTRAINT pk_workflow_state PRIMARY KEY (execution_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: outbox_entry uc_outbox_kind_owner_correlation; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.outbox_entry
    ADD CONSTRAINT uc_outbox_kind_owner_correlation UNIQUE (entry_kind, owner_id, correlation_id);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: user_consent uk_external_consent; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_external_consent UNIQUE (client_storage_provider, external_client_id, user_id);


--
-- Name: fed_user_ver_credential uk_fed_user_vc; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.fed_user_ver_credential
    ADD CONSTRAINT uk_fed_user_vc UNIQUE (user_id, client_scope_id);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_ver_credential uk_kkuwuvd67ontgsugogm8uewre; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_ver_credential
    ADD CONSTRAINT uk_kkuwuvd67ontgsugogm8uewre UNIQUE (user_id, client_scope_id);


--
-- Name: user_consent uk_local_consent; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_local_consent UNIQUE (client_id, user_id);


--
-- Name: migration_model uk_migration_update_time; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT uk_migration_update_time UNIQUE (update_time);


--
-- Name: migration_model uk_migration_version; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT uk_migration_version UNIQUE (version);


--
-- Name: org uk_org_alias; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_alias UNIQUE (realm_id, alias);


--
-- Name: org_domain uk_org_domain_realm_name; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.org_domain
    ADD CONSTRAINT uk_org_domain_realm_name UNIQUE (realm_id, name);


--
-- Name: org uk_org_group; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_group UNIQUE (group_id);


--
-- Name: org_invitation uk_org_invitation_email; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.org_invitation
    ADD CONSTRAINT uk_org_invitation_email UNIQUE (organization_id, email);


--
-- Name: org uk_org_name; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_name UNIQUE (realm_id, name);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: workflow_state uq_workflow_resource; Type: CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.workflow_state
    ADD CONSTRAINT uq_workflow_resource UNIQUE (workflow_id, resource_id);


--
-- Name: fed_user_attr_long_values; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX fed_user_attr_long_values ON public.fed_user_attribute USING btree (long_value_hash, name);


--
-- Name: fed_user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX fed_user_attr_long_values_lower_case ON public.fed_user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_auth_session_auth_user_id; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_auth_session_auth_user_id ON public.auth_session USING btree (auth_user_id);


--
-- Name: idx_broker_link_identity_provider; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_broker_link_identity_provider ON public.broker_link USING btree (realm_id, identity_provider, broker_user_id);


--
-- Name: idx_broker_link_user_id; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_broker_link_user_id ON public.broker_link USING btree (user_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_att_by_name_value; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_client_att_by_name_value ON public.client_attributes USING btree (name, substr(value, 1, 255));


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_cluster_event_target; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_cluster_event_target ON public.cluster_event USING btree (target_cluster, created_at);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_entity_user_id_type; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_event_entity_user_id_type ON public.event_entity USING btree (user_id, type, event_time);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fed_issued_vc_cred_id; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fed_issued_vc_cred_id ON public.fed_issued_ver_credential USING btree (ver_credential_id);


--
-- Name: idx_fed_issued_vc_expires; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fed_issued_vc_expires ON public.fed_issued_ver_credential USING btree (expires_at);


--
-- Name: idx_fed_issued_vc_storage; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fed_issued_vc_storage ON public.fed_issued_ver_credential USING btree (storage_provider_id);


--
-- Name: idx_fed_issued_vc_user; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fed_issued_vc_user ON public.fed_issued_ver_credential USING btree (user_id, realm_id, issued_at);


--
-- Name: idx_fed_user_vc_realm_user; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fed_user_vc_realm_user ON public.fed_user_ver_credential USING btree (realm_id, user_id);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_org_id; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_group_org_id ON public.keycloak_group USING btree (org_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_idp_for_login; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_idp_for_login ON public.identity_provider USING btree (realm_id, enabled, link_only, hide_on_login);


--
-- Name: idx_issued_ver_credential_expires_at; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_issued_ver_credential_expires_at ON public.issued_ver_credential USING btree (expires_at);


--
-- Name: idx_issued_ver_credential_user; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_issued_ver_credential_user ON public.issued_ver_credential USING btree (user_id, issued_at);


--
-- Name: idx_issued_ver_credential_vc; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_issued_ver_credential_vc ON public.issued_ver_credential USING btree (ver_credential_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_login_failure_expire; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_login_failure_expire ON public.login_failure USING btree (last_failure);


--
-- Name: idx_offline_css_by_client; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_offline_css_by_client ON public.offline_client_session USING btree (client_id, offline_flag) WHERE ((client_id)::text <> 'external'::text);


--
-- Name: idx_offline_css_by_client_and_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_offline_css_by_client_and_realm ON public.offline_client_session USING btree (realm_id, offline_flag, client_id, client_storage_provider, external_client_id);


--
-- Name: idx_offline_css_by_client_storage_provider; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_offline_css_by_client_storage_provider ON public.offline_client_session USING btree (client_storage_provider, external_client_id, offline_flag) WHERE ((client_storage_provider)::text <> 'internal'::text);


--
-- Name: idx_offline_uss_by_broker_session_id; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_offline_uss_by_broker_session_id ON public.offline_user_session USING btree (broker_session_id, realm_id) WHERE (broker_session_id IS NOT NULL);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_org_domain_idp_id; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_org_domain_idp_id ON public.org_domain USING btree (idp_id);


--
-- Name: idx_org_domain_org_id; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_org_domain_org_id ON public.org_domain USING btree (org_id);


--
-- Name: idx_org_domain_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_org_domain_realm ON public.org_domain USING btree (realm_id);


--
-- Name: idx_org_idp_idp_id; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_org_idp_idp_id ON public.org_identity_provider USING btree (identity_provider_id);


--
-- Name: idx_org_idp_org_id; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_org_idp_org_id ON public.org_identity_provider USING btree (organization_id);


--
-- Name: idx_org_invitation_email; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_org_invitation_email ON public.org_invitation USING btree (email);


--
-- Name: idx_org_invitation_expires; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_org_invitation_expires ON public.org_invitation USING btree (expires_at);


--
-- Name: idx_org_invitation_org_id; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_org_invitation_org_id ON public.org_invitation USING btree (organization_id);


--
-- Name: idx_outbox_container; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_outbox_container ON public.outbox_entry USING btree (entry_kind, owner_id, container_id);


--
-- Name: idx_outbox_drain; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_outbox_drain ON public.outbox_entry USING btree (entry_kind, status, next_attempt_at);


--
-- Name: idx_outbox_owner; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_outbox_owner ON public.outbox_entry USING btree (entry_kind, owner_id, status);


--
-- Name: idx_outbox_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_outbox_realm ON public.outbox_entry USING btree (entry_kind, realm_id, status);


--
-- Name: idx_perm_ticket_owner; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_perm_ticket_owner ON public.resource_server_perm_ticket USING btree (owner);


--
-- Name: idx_perm_ticket_requester; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_perm_ticket_requester ON public.resource_server_perm_ticket USING btree (requester);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_rev_token_on_expire; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_rev_token_on_expire ON public.revoked_token USING btree (expire);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_root_auth_session_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_root_auth_session_realm ON public.root_auth_session USING btree (realm_id, session_bucket, timestamp_coarse);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_single_use_obj_expire; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_single_use_obj_expire ON public.single_use_object USING btree (expire);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_usconsent_scope_id; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_usconsent_scope_id ON public.user_consent_client_scope USING btree (scope_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_created_timestamp; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_user_created_timestamp ON public.user_entity USING btree (realm_id, created_timestamp);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- Name: idx_user_session_expiration_created; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_user_session_expiration_created ON public.offline_user_session USING btree (realm_id, offline_flag, remember_me, session_bucket, created_on);


--
-- Name: idx_user_session_expiration_last_refresh; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_user_session_expiration_last_refresh ON public.offline_user_session USING btree (realm_id, offline_flag, remember_me, session_bucket, last_session_refresh_coarse);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: idx_workflow_state_provider; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_workflow_state_provider ON public.workflow_state USING btree (resource_id);


--
-- Name: idx_workflow_state_scheduled; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_workflow_state_scheduled ON public.workflow_state USING btree (workflow_id, scheduled_step_timestamp);


--
-- Name: idx_workflow_state_step; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX idx_workflow_state_step ON public.workflow_state USING btree (workflow_id, scheduled_step_id);


--
-- Name: user_attr_long_values; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX user_attr_long_values ON public.user_attribute USING btree (long_value_hash, name);


--
-- Name: user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: eniaclabs_keycloak
--

CREATE INDEX user_attr_long_values_lower_case ON public.user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: auth_session fk_auth_session_root; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.auth_session
    ADD CONSTRAINT fk_auth_session_root FOREIGN KEY (root_auth_session_id) REFERENCES public.root_auth_session(id) ON DELETE CASCADE;


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: fed_issued_ver_credential fk_fed_issued_vc_ver_cred; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.fed_issued_ver_credential
    ADD CONSTRAINT fk_fed_issued_vc_ver_cred FOREIGN KEY (ver_credential_id) REFERENCES public.fed_user_ver_credential(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: keycloak_group fk_group_organization; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT fk_group_organization FOREIGN KEY (org_id) REFERENCES public.org(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: issued_ver_credential fk_issued_ver_credential_user; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.issued_ver_credential
    ADD CONSTRAINT fk_issued_ver_credential_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: issued_ver_credential fk_issued_ver_credential_vc; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.issued_ver_credential
    ADD CONSTRAINT fk_issued_ver_credential_vc FOREIGN KEY (ver_credential_id) REFERENCES public.user_ver_credential(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: org_domain fk_org_domain_idp; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.org_domain
    ADD CONSTRAINT fk_org_domain_idp FOREIGN KEY (idp_id) REFERENCES public.identity_provider(internal_id) ON DELETE SET NULL;


--
-- Name: org_domain fk_org_domain_org; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.org_domain
    ADD CONSTRAINT fk_org_domain_org FOREIGN KEY (org_id) REFERENCES public.org(id) ON DELETE CASCADE;


--
-- Name: org_identity_provider fk_org_idp_idp; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.org_identity_provider
    ADD CONSTRAINT fk_org_idp_idp FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id) ON DELETE CASCADE;


--
-- Name: org_identity_provider fk_org_idp_org; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.org_identity_provider
    ADD CONSTRAINT fk_org_idp_org FOREIGN KEY (organization_id) REFERENCES public.org(id) ON DELETE CASCADE;


--
-- Name: org_invitation fk_org_invitation_org; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.org_invitation
    ADD CONSTRAINT fk_org_invitation_org FOREIGN KEY (organization_id) REFERENCES public.org(id) ON DELETE CASCADE;


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_ver_credential fk_vcred_user; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.user_ver_credential
    ADD CONSTRAINT fk_vcred_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: eniaclabs_keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

\unrestrict uWQih7VU2O07sH6e8fGgCj7dIn10AUzRg8hJK0uPqBfBui9MHz0LWKgwkudYIqT

