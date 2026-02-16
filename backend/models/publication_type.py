from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from infrastructure.database import Base


class PublicationType(Base):
    __tablename__ = "publication_types"

    id: Mapped[int] = mapped_column(primary_key=True)

    title: Mapped[str] = mapped_column(
        String(50),
        nullable=False,
        unique=True,
        index=True,
    )

    aliases = relationship(
        "PublicationTypeAlias",
        back_populates="publication_type",
        cascade="all, delete-orphan"
    )
