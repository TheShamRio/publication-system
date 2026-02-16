from sqlalchemy import Integer, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

from infrastructure.database import Base


class Plan(Base):
    __tablename__ = "plans"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    year: Mapped[str] = mapped_column(Integer, nullable=False)

    status_id: Mapped[str] = mapped_column(ForeignKey("plan_statuses.id"), nullable=False)
    author_id: Mapped[str] = mapped_column(ForeignKey("authors.id"), nullable=False)

    author: Mapped["Author"] = relationship(
        back_populates="plans"
    )

    status: Mapped["PlanStatus"] = relationship(
        back_populates="plans"
    )
    entries: Mapped[list["PlanEntry"]] = relationship(
        back_populates="plan",
        cascade="all, delete-orphan",
    )

    status_history: Mapped[list["PlanStatusTemp"]] = relationship(
        back_populates="plan",
        cascade="all, delete-orphan",
        order_by="PlanStatusTemp.date.desc()",
    )

    comments: Mapped[list["PlanComment"]] = relationship(
        back_populates="plan",
        cascade="all, delete-orphan",
        order_by="PlanComment.created_at.desc()",
    )
