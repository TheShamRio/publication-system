from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from infrastructure.database import Base


class PlanStatus(Base):
    __tablename__ = "plan_statuses"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    title: Mapped[str] = mapped_column(String(32), nullable=False)

    plans: Mapped[list["Plan"]] = relationship(
        back_populates="status"
    )

    # history relationship
    history_entries: Mapped[list["PlanStatusTemp"]] = relationship(
        back_populates="status",
        cascade="all, delete-orphan",
    )