from minio import Minio


class MinioClient:
    """Async-safe MinIO wrapper used via dependency injection."""

    def __init__(
        self,
        endpoint: str,
        access_key: str,
        secret_key: str,
        secure: bool,
        bucket: str,
    ):
        self._client = Minio(
            endpoint,
            access_key=access_key,
            secret_key=secret_key,
            secure=secure,
        )
        self._bucket = bucket

    async def ensure_bucket(self) -> None:
        if not self._client.bucket_exists(self._bucket):
            self._client.make_bucket(self._bucket)

    async def upload(self, object_name: str, data, content_type: str) -> None:
        self._client.put_object(
            self._bucket,
            object_name,
            data,
            length=-1,
            part_size=10 * 1024 * 1024,
            content_type=content_type,
        )

    async def presigned_url(self, object_name: str) -> str:
        return self._client.presigned_get_object(
            self._bucket,
            object_name,
        )
