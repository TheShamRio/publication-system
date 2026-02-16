from sqlalchemy import ForeignKey
from sqlalchemy.orm import Mapped, mapped_column

from infrastructure.database import Base


class PlanEntryPublication(Base):
    __tablename__ = "plan_entry_publications"

    publication_id: Mapped[int] = mapped_column(ForeignKey("publications.id"), primary_key=True)
    plan_entry_id: Mapped[int] = mapped_column(ForeignKey("plans.id"), primary_key=True)
