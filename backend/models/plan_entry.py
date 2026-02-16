from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column

from infrastructure.database import Base


class PlanEntry(Base):
    __tablename__ = "plan_entries"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    title: Mapped[str] = mapped_column(Integer, nullable=False)
    status_id: Mapped[str] = mapped_column(Integer, nullable=False)

    user_id: Mapped[str] = mapped_column(String(36), nullable=True)
