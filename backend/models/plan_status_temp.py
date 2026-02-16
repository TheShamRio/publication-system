from datetime import datetime

from sqlalchemy import ForeignKey, DateTime, String, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from infrastructure.database import Base


class PlanStatusTemp(Base):
    __tablename__ = "plan_status_temp"

    plan_id: Mapped[int] = mapped_column(
        ForeignKey("plans.id", ondelete="CASCADE"),
        primary_key=True,
    )

    status_id: Mapped[int] = mapped_column(
        ForeignKey("plan_statuses.id", ondelete="RESTRICT"),
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

    publication = relationship("Plan", back_populates="status_history")
    status = relationship("PlanStatus", back_populates="plans")
