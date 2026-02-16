from sqlalchemy import ForeignKey
from sqlalchemy.orm import Mapped, mapped_column

from infrastructure.database import Base


class PublicationAuthor(Base):
    __tablename__ = "author_publication"

    author_id: Mapped[int] = mapped_column(
        ForeignKey("authors.id", ondelete="CASCADE"),
        primary_key=True,
    )

    publication_id: Mapped[int] = mapped_column(
        ForeignKey("publications.id", ondelete="CASCADE"),
        primary_key=True,
    )
