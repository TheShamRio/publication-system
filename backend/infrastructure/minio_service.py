from io import BytesIO
import anyio
from minio import Minio
from config.settings import settings


def get_minio_client() -> Minio:
    return Minio(
        endpoint=settings.MINIO_ENDPOINT,
        access_key=settings.MINIO_ACCESS_KEY,
        secret_key=settings.MINIO_SECRET_KEY,
        secure=settings.MINIO_SECURE,
    )


async def upload_file_to_minio(
    file_data: bytes,
    object_name: str,
    content_type: str | None = None,
):
    stream = BytesIO(file_data)
    size = len(file_data)

    client = get_minio_client()

    await anyio.to_thread.run_sync(
        lambda: client.put_object(
            settings.MINIO_BUCKET,
            object_name,
            stream,
            size,
            content_type=content_type,
        )
    )
