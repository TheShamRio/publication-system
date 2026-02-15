-- =========================
-- Keycloak DB
-- =========================
CREATE DATABASE keycloak;
CREATE USER keycloak_user WITH PASSWORD 'keycloak_password';
GRANT ALL PRIVILEGES ON DATABASE keycloak TO keycloak_user;


\connect keycloak

GRANT ALL ON SCHEMA public TO keycloak_user;
ALTER SCHEMA public OWNER TO keycloak_user;

-- =========================
-- App DB
-- =========================
CREATE DATABASE app_db;
CREATE USER app_user WITH PASSWORD 'app_password';
GRANT ALL PRIVILEGES ON DATABASE app_db TO app_user;


\connect app_db

GRANT ALL ON SCHEMA public TO app_user;
ALTER SCHEMA public OWNER TO app_user;