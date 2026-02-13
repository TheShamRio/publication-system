from io import BytesIO
import anyio
from minio import Minio
from config.settings import settings

MINIO_BUCKET = settings.MINIO_BUCKET

# Standard MinIO client (sync)
_minio_client = Minio(
    endpoint=settings.MINIO_ENDPOINT,
    access_key=settings.MINIO_ACCESS_KEY,
    secret_key=settings.MINIO_SECRET_KEY,
    secure=settings.MINIO_SECURE,
)


async def upload_file_to_minio(file_data: bytes, object_name: str, content_type: str | None = None):
    """Upload a file to MinIO asynchronously."""

    # Wrap bytes in a BytesIO stream
    stream = BytesIO(file_data)
    size = len(file_data)

    # MinIO is sync → run in thread
    await anyio.to_thread.run_sync(
        lambda: _minio_client.put_object(
            settings.MINIO_BUCKET,
            object_name,
            stream,
            size,
            content_type=content_type,
        )
    )
