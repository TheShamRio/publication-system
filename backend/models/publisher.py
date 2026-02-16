from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from infrastructure.database import Base


class Publisher(Base):
    __tablename__ = "publishers"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    location: Mapped[str] = mapped_column(String(255), nullable=False)

    publications: Mapped[list["Publication"]] = relationship(
        back_populates="publisher"
    )

    journals: Mapped[list["Journal"]] = relationship(back_populates="publisher")
