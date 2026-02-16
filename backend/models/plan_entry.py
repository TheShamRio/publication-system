from sqlalchemy import Integer, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

from infrastructure.database import Base


class PlanEntry(Base):
    __tablename__ = "plan_entries"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    total_amount_planned: Mapped[int] = mapped_column(Integer, nullable=False)

    type_alias_id: Mapped[int] = mapped_column(ForeignKey("publication_type_aliases.id"), nullable=False)
    plan_id: Mapped[int] = mapped_column(ForeignKey("plans.id"), nullable=False)

    plan: Mapped["Plan"] = relationship(
        back_populates="entries"
    )

    type_alias: Mapped["PublicationTypeAlias"] = relationship()

    publications: Mapped[list["Publication"]] = relationship(
        secondary="plan_entry_publications",
        back_populates="plan_entries",
    )
