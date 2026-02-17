from sqlalchemy import Integer, String, Text, DateTime, func, Float, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

from infrastructure.database import Base


class Publication(Base):
    __tablename__ = "publications"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    username: Mapped[str] = mapped_column(String(36), nullable=True) # who inserted in the system
    external_url: Mapped[str] = mapped_column(Text, nullable=True)
    internal_url: Mapped[str] = mapped_column(Text, nullable=True)
    doi: Mapped[str] = mapped_column(String(512), nullable=True)
    printed_sheets_volume: Mapped[float] = mapped_column(Float, nullable=True)
    classification_code: Mapped[str] = mapped_column(String(55))
    notes: Mapped[str] = mapped_column(Text, nullable=True)
    work_form: Mapped[str] = mapped_column(String(24), nullable=False)
    created_at: Mapped[DateTime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )

    status_id: Mapped[int] = mapped_column(ForeignKey("publication_statuses.id"), nullable=False)
    type_alias_id: Mapped[int] = mapped_column(ForeignKey("publication_type_aliases.id"), nullable=False)
    publisher_id: Mapped[int] = mapped_column(ForeignKey("publishers.id"), nullable=True)
    journal_id: Mapped[int] = mapped_column(ForeignKey("journals.id"), nullable=True)

    status: Mapped["PublicationStatus"] = relationship(
        back_populates="publications"
    )
    status_history: Mapped[list["PublicationStatusTemp"]] = relationship(
        back_populates="publication",
        cascade="all, delete-orphan",
        order_by="PublicationStatusTemp.date.desc()",
    )
    authors: Mapped[list["Author"]] = relationship(
        secondary="author_publication",
        back_populates="publications"
    )

    plan_entries: Mapped[list["PlanEntry"]] = relationship(
        secondary="plan_entry_publications",
        back_populates="publications",
    )

    publisher: Mapped["Publisher"] = relationship(
        back_populates="publications"
    )

    comments: Mapped[list["PublicationComment"]] = relationship(
        back_populates="publication",
        cascade="all, delete-orphan",
        order_by="PublicationComment.created_at.desc()",
    )

    journals: Mapped[list["Journal"]] = relationship(
        secondary="journal_publications",
        back_populates="publications",
    )

    tags: Mapped[list["Tags"]] = relationship(
        secondary="publication_tags",
        back_populates="publications",
    )

    type_alias: Mapped["PublicationTypeAlias"] = relationship(
        back_populates="publications"
    )
