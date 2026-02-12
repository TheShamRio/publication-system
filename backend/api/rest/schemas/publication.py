from pydantic import BaseModel


class PublicationUploadResponse(BaseModel):
    """Response returned after publication upload."""

    filename: str
    url: str
