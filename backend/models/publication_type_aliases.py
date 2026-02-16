from sqlalchemy import String, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

from infrastructure.database import Base


class PublicationTypeAlias(Base):
    __tablename__ = "publication_type_aliases"

    id: Mapped[int] = mapped_column(primary_key=True)

    publication_type_id: Mapped[int] = mapped_column(
        ForeignKey("publication_types.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )

    alias: Mapped[str] = mapped_column(
        String(50),
        nullable=False,
        index=True
    )

    publication_type = relationship(
        "PublicationType",
        back_populates="aliases"
    )
