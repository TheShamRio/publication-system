from dataclasses import dataclass
from infrastructure.minio import MinioClient


@dataclass(frozen=True)
class PublicationStorageConfig:
    """Rules for publication object storage layout."""
    root_prefix: str = "publications"


class PublicationStorageService:
    """Publication file storage orchestration."""

    def __init__(
        self,
        minio: MinioClient,
        config: PublicationStorageConfig,
    ):
        self.minio = minio
        self.config = config

    async def store(
        self,
        owner_id: str,
        filename: str,
        data,
        content_type: str,
    ) -> str:
        object_name = f"{self.config.root_prefix}/{owner_id}/{filename}"

        await self.minio.upload(
            object_name=object_name,
            data=data,
            content_type=content_type,
        )

        return await self.minio.presigned_url(object_name)
