from pydantic import BaseSettings, AnyHttpUrl, PostgresDsn


class Settings(BaseSettings):
    # =========================
    # Database
    # =========================
    DATABASE_URL: PostgresDsn

    # =========================
    # Keycloak
    # =========================
    KEYCLOAK_URL: AnyHttpUrl
    KEYCLOAK_REALM: str
    KEYCLOAK_CLIENT_ID: str

    KEYCLOAK_ADMIN_USER: str
    KEYCLOAK_ADMIN_PASSWORD: str

    # =========================
    # MinIO
    # =========================
    MINIO_ENDPOINT: str
    MINIO_ACCESS_KEY: str
    MINIO_SECRET_KEY: str
    MINIO_BUCKET: str
    MINIO_SECURE: bool = False

    # =========================
    # Logging (Kafka → ELK)
    # =========================
    KAFKA_BOOTSTRAP_SERVERS: str
    LOG_TOPIC: str = "backend-logs"

    class Config:
        env_file = ".env"


settings = Settings()
