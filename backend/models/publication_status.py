from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from infrastructure.database import Base


class PublicationStatus(Base):
    __tablename__ = "publication_statuses"

    id: Mapped[int] = mapped_column(primary_key=True)

    title: Mapped[str] = mapped_column(
        String(50),
        nullable=False,
        unique=True,
        index=True,
    )

    publications: Mapped[list["Publication"]] = relationship(
        back_populates="status"
    )

    history_entries: Mapped[list["PublicationStatusTemp"]] = relationship(
        back_populates="status",
        cascade="all, delete-orphan",
    )
