from datetime import datetime, timezone
from fastapi import APIRouter, UploadFile, HTTPException, status, Form, Depends
from uuid import uuid4

from sqlalchemy.ext.asyncio import AsyncSession

from api.rest.schemas.publication import PublicationOut
from infrastructure.database import get_session
from infrastructure.minio_service import upload_file_to_minio
from models.publication import Publication

router = APIRouter(prefix="/publications", tags=["Publications"])

ALLOWED_TYPES = {
    "application/pdf",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
}


@router.post("/publications/", response_model=PublicationOut)
async def upload_publication(
    title: str = Form(...),
    author: str = Form(...),
    abstract: str | None = Form(None),
    file: UploadFile = None,
    session: AsyncSession = Depends(get_session),
):
    if not file:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="File is required")

    # Generate unique object name
    object_name = f"{uuid4().hex}_{file.filename}"

    # Read file once
    file_data = await file.read()

    # Upload asynchronously to MinIO
    try:
        await upload_file_to_minio(file_data, object_name, file.content_type)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to upload file: {e}")

    # Insert metadata into DB
    publication = Publication(
        title=title,
        author=author,
        abstract=abstract,
        file_name=file.filename,
        file_object_name=object_name,
        content_type=file.content_type,
        created_at=datetime.now(timezone.utc),
    )

    session.add(publication)
    await session.commit()
    await session.refresh(publication)

    return publication