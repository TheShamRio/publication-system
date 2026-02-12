from typing import Optional
from pydantic import AnyHttpUrl, PostgresDsn
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    # =========================
    # Database
    # =========================
    DATABASE_URL: str  # use str for asyncpg URLs like postgresql+asyncpg://

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
    KAFKA_BOOTSTRAP_SERVERS: Optional[str] = None  # optional now
    LOG_TOPIC: str = "backend-logs"

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"


settings = Settings()
