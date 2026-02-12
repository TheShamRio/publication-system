from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column
from infrastructure.database import Base


class User(Base):
    """Local projection of an authenticated user."""

    __tablename__ = "users"

    id: Mapped[str] = mapped_column(String, primary_key=True)
    username: Mapped[str] = mapped_column(String, unique=True, nullable=False)

    first_name: Mapped[str | None] = mapped_column(String)
    middle_name: Mapped[str | None] = mapped_column(String)
    third_name: Mapped[str | None] = mapped_column(String)
