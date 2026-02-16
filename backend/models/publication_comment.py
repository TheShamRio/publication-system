from sqlalchemy import Integer, String, Text, DateTime, func, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

from infrastructure.database import Base
from models.publication import Publication


class PublicationComment(Base):
    __tablename__ = "publication_comments"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    text: Mapped[str | None] = mapped_column(Text, nullable=False)
    username: Mapped[str] = mapped_column(String(36), nullable=True)
    created_at: Mapped[DateTime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )

    publication_id = mapped_column(ForeignKey("publications.id"))

    publication: Mapped["Publication"] = relationship(back_populates="comments")
