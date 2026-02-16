from sqlalchemy import Integer, String, Text, DateTime, func, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

from infrastructure.database import Base


class PlanComment(Base):
    __tablename__ = "plan_comments"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    text: Mapped[str | None] = mapped_column(Text, nullable=False)
    created_at: Mapped[DateTime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )

    username: Mapped[str] = mapped_column(String(36), nullable=False)
    plan_id = mapped_column(ForeignKey("plans.id"))
    
    plan: Mapped["Plan"] = relationship(back_populates="comments")
