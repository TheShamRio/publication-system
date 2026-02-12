# app/schemas/publication.py
from datetime import datetime
from pydantic import BaseModel


class PublicationOut(BaseModel):
    id: int
    title: str
    author: str
    abstract: str | None
    file_name: str
    file_object_name: str
    content_type: str
    created_at: datetime

    model_config = {"from_attributes": True}
