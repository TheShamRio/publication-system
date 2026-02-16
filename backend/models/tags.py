from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from infrastructure.database import Base


class Tags(Base):
    __tablename__ = "tags"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    title: Mapped[str] = mapped_column(String(128), nullable=False)

    publications: Mapped[list["Publication"]] = relationship(
        secondary="publication_tags",
        back_populates="tags",
    )
