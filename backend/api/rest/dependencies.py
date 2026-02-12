from backend.services.publication_storage import PublicationStorageService
from core.container import container
from infrastructure.minio import MinioClient


def get_minio() -> MinioClient:
    """Provide MinIO client via dependency injection."""
    return container.minio



def get_publication_storage() -> PublicationStorageService:
    """Provide publication storage service."""
    return container.publication_storage