from sqlalchemy import Integer, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column

from infrastructure.database import Base


class Plan(Base):
    __tablename__ = "plans"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    year: Mapped[str] = mapped_column(Integer, nullable=False)

    status_id: Mapped[str] = mapped_column(ForeignKey("plan_statuses.id"), nullable=False)
    author_id: Mapped[str] = mapped_column(ForeignKey("authors.id"), nullable=False)
