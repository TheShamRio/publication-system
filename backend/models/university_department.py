from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from infrastructure.database import Base


class UniversityDepartment(Base):
    __tablename__ = "university_department"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    title: Mapped[str] = mapped_column(String(255), nullable=False)

    authors: Mapped[list["Author"]] = relationship(
        back_populates="department"
    )
