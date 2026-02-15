from sqlalchemy import Integer, String, Text, DateTime, func
from sqlalchemy.orm import Mapped, mapped_column

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

"""authors
    - authorid
    - name
    - surname
    - third_name
    - email
    - phone number
    - ? userId
"""

"""publication author
    - authorid
    - publicationId
"""

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

"""note
    - id
    - publication id
    - text
"""

"""department
    - id
    - name
"""

"""publisher
    - ID
    - Title
    - Location
"""

"""publication_index(vak, rinc, scopus, wos, none)
    id
    title
"""


"""
publication status type
    id - UUID
    titile - string(черновик, требуется проверка, отправлено на доработку, опубликована)
"""


"""publication type
    - id
    - name
"""

"""display name
    - id
    - name
    - publication type id (foreign key)
"""

"""publication form
    - id
    - title
"""