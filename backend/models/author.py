from sqlalchemy import Integer, String, Text, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship

from infrastructure.database import Base


class Author(Base):
    __tablename__ = "authors"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    first_name: Mapped[str] = mapped_column(String(255), nullable=False)
    middle_name: Mapped[str] = mapped_column(String(255), nullable=False)
    third_name: Mapped[str | None] = mapped_column(Text, nullable=True)

    username: Mapped[str] = mapped_column(String(36), nullable=True)

    department_id: Mapped[int] = mapped_column(
        ForeignKey("university_department.id"),
        nullable=False,
    )

    department: Mapped["UniversityDepartment"] = relationship(
        back_populates="authors"
    )

    publications: Mapped[list["Publication"]] = relationship(
        secondary="author_publication",
        back_populates="authors"
    )

    plans: Mapped[list["Plan"]] = relationship(
        back_populates="author",
        cascade="all, delete-orphan",
    )
