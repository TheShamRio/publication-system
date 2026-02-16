from sqlalchemy import Integer, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column

from infrastructure.database import Base


class PublicationAuthor(Base):
    __tablename__ = "author_publication"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    author_id: Mapped[int] = mapped_column(ForeignKey("authors.id"))
    publication_id: Mapped[int] = mapped_column(ForeignKey("publications.id"))
