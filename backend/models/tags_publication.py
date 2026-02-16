from sqlalchemy import ForeignKey
from sqlalchemy.orm import Mapped, mapped_column

from infrastructure.database import Base


class TagsPublication(Base):
    __tablename__ = "publication_tags"

    publication_id: Mapped[int] = mapped_column(ForeignKey("publications.id"), primary_key=True)
    tag_id: Mapped[int] = mapped_column(ForeignKey("tags.id"), primary_key=True)
