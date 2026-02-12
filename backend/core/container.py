from config.settings import settings
from infrastructure.minio import MinioClient
from infrastructure.auth.keycloak_admin import KeycloakAdmin
from services.publication_storage import (
    PublicationStorageService,
    PublicationStorageConfig,
)


class Container:
    """Application dependency container."""

    def __init__(self):
        self.minio = MinioClient(
            settings.MINIO_ENDPOINT,
            settings.MINIO_ACCESS_KEY,
            settings.MINIO_SECRET_KEY,
            settings.MINIO_SECURE,
            settings.MINIO_BUCKET,
        )

        self.keycloak_admin = KeycloakAdmin(
            settings.KEYCLOAK_URL,
            settings.KEYCLOAK_ADMIN_USER,
            settings.KEYCLOAK_ADMIN_PASSWORD,
            settings.KEYCLOAK_REALM,
        )

        self.publication_storage = PublicationStorageService(
            minio=self.minio,
            config=PublicationStorageConfig(),
        )


container = Container()
