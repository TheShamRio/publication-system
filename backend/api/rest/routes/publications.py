from fastapi import APIRouter, Depends, UploadFile, Form, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from uuid import uuid4
from datetime import datetime

from infrastructure.database import get_session
from models.author import Author

from models.publication import Publication
from api.rest.schemas.publication import PublicationOut

from dependencies import get_current_user

router = APIRouter(prefix="/publications", tags=["Publications"])

ALLOWED_TYPES = {
    "application/pdf",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
}


async def find_publication_by_query():
    pass


async def get_publication_by_id():
    pass


@router.post("/", response_model=PublicationOut)
async def add_publication(
    title: str = Form(...),
    abstract: str | None = Form(None),
    file: UploadFile = None,
    session: AsyncSession = Depends(get_session),
    user=Depends(get_current_user),  # current Keycloak user
):
    if not file:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="File is required"
        )

    if file.content_type not in ALLOWED_TYPES:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Unsupported file type"
        )

    # Generate a unique object name
    object_name = f"{uuid4().hex}_{file.filename}"
    file_data = await file.read()

    # Upload file to MinIO (assuming you have a helper)
    from infrastructure.minio_service import upload_file_to_minio
    try:
        await upload_file_to_minio(file_data, object_name, file.content_type)
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Failed to upload file: {e}"
        )

    # Create Author entry if this Keycloak user does not exist in authors table
    author = None
    if user.get("keycloak_id"):
        result = await session.execute(
            # SQLAlchemy ORM query for author by keycloak_id
            Author.__table__.select().where(Author.keycloak_id == user["keycloak_id"])
        )
        author_row = result.first()
        if author_row:
            author = author_row[0]
        else:
            author = Author(
                first_name=user.get("firstName") or "",
                second_name=user.get("middleName") or "",
                third_name=user.get("thirdName"),
                keycloak_id=user["keycloak_id"]
            )
            session.add(author)
            await session.commit()
            await session.refresh(author)

    # Save publication
    publication = Publication(
        title=title,
        abstract=abstract,
        file_name=file.filename,
        file_object_name=object_name,
        content_type=file.content_type,
        created_at=datetime.utcnow(),
        author_id=author.id if author else None  # link to author table
    )

    session.add(publication)
    await session.commit()
    await session.refresh(publication)

    return publication


async def import_publications_from_bibtech():
    pass


async def edit_publication():
    pass
