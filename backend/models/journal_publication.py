from sqlalchemy import ForeignKey
from sqlalchemy.orm import Mapped, mapped_column

from infrastructure.database import Base


class JournalPublication(Base):
    __tablename__ = "journal_publications"
    
    journal_id: Mapped[int] = mapped_column(ForeignKey("journals.id"), primary_key=True)
    publication_id: Mapped[int] = mapped_column(ForeignKey("publications.id"), primary_key=True)
