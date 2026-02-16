from sqlalchemy import Integer, ForeignKey, String, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship

from infrastructure.database import Base


class Journal(Base):
    __tablename__ = "journals"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    title: Mapped[str] = mapped_column(String(512), nullable=False)
    date: Mapped[DateTime] = mapped_column(DateTime(timezone=True), nullable=False)
    ISSN: Mapped[str] = mapped_column(String(256), nullable=True)
    ISBN: Mapped[str] = mapped_column(String(256), nullable=True)
    volume: Mapped[str] = mapped_column(String(24), nullable=True)
    quartile: Mapped[str] = mapped_column(String(120), nullable=True)
    issue: Mapped[str] = mapped_column(String(24), nullable=True)
    circulation: Mapped[int] = mapped_column(Integer, nullable=True)

    publisher_id: Mapped[int] = mapped_column(ForeignKey("publishers.id"))

    publisher: Mapped["Publisher"] = relationship(back_populates="journals")
    publications: Mapped[list["Publication"]] = relationship(
        secondary="journal_publications",
        back_populates="journals",
    )
