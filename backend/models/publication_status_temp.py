from datetime import datetime

from sqlalchemy import ForeignKey, DateTime, String, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from infrastructure.database import Base


class PublicationStatusTemp(Base):
    __tablename__ = "publication_status_temp"

    publication_id: Mapped[int] = mapped_column(
        ForeignKey("publications.id", ondelete="CASCADE"),
        primary_key=True,
    )

    status_id: Mapped[int] = mapped_column(
        ForeignKey("publication_statuses.id", ondelete="RESTRICT"),
        primary_key=True,
    )

    date: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )

    username: Mapped[str] = mapped_column(
        String(100),
        nullable=False,
    )

    publication = relationship("Publication", back_populates="status_history")
    status = relationship("PublicationStatus", back_populates="publications")
