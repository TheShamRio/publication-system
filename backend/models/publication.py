from sqlalchemy import Integer, String, Text, DateTime, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from infrastructure.database import Base


class Publication(Base):
    __tablename__ = "publications"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    author: Mapped[str] = mapped_column(String(255), nullable=False)
    abstract: Mapped[str | None] = mapped_column(Text, nullable=True)
    file_object_name: Mapped[str] = mapped_column(String(255), nullable=False)
    file_name: Mapped[str] = mapped_column(String(255), nullable=False)
    content_type: Mapped[str] = mapped_column(String(100), nullable=False)
    created_at: Mapped[DateTime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )

    status_history = relationship(
        "PublicationStatusTemp",
        back_populates="publication",
        cascade="all, delete-orphan",
        order_by="PublicationStatusTemp.date.desc()",
    )


"""publication metadata
    Id - UUID
    UserID - who inserted to the db(foreign key)
    Title - tile of publication
    DateCreated - date of publication
    PublicationFormId (foreign key)
    DateUpdated - date of change
    StatusId - foreign key
    FileURI - URI where the publication is stored
    JournalConferenceName
    DOI
    ISSN
    ISBN
    Quartile
    VOLUME
    Number - номер выпуска публикации
    Pages - location in the journal
    PrintedSheetsVolume - объем в печатных листах
    Classification code
    publication type alias id( foreign key)
    Тираж
    departmentId (foreign key)
    publisherId (foreign key)
"""


"""publication form
    - id
    - title
"""