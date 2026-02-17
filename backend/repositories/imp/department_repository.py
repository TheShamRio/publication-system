from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from repositories.interface.department_repository import IDepartmentRepository
from models.university_department import UniversityDepartment
from models.author import Author


class DepartmentRepository(IDepartmentRepository):
    def __init__(self, session: AsyncSession):
        self._session = session


    async def get_all(self, limit: int = 20, offset: int = 0) -> list[UniversityDepartment]:
        stmt = select(UniversityDepartment).order_by(UniversityDepartment.id).limit(limit).offset(offset)
        result = await self._session.execute(stmt)
        return result.scalars().all()


    async def get_by_id(self, department_id: int) -> UniversityDepartment | None:
        result = await self._session.execute(
            select(UniversityDepartment).where(UniversityDepartment.id == department_id)
        )
        return result.scalars().first()


    async def add(self, department: UniversityDepartment) -> UniversityDepartment:
        self._session.add(department)
        await self._session.commit()
        await self._session.refresh(department)
        return department


    async def update(self, department: UniversityDepartment) -> UniversityDepartment:
        await self._session.commit()
        await self._session.refresh(department)
        return department


    async def delete(self, department: UniversityDepartment) -> None:
        await self._session.delete(department)
        await self._session.commit()


    async def get_all_department_authors(
        self, 
        department_id: int, 
        limit: int = 20, 
        offset: int = 0
    ) -> list[Author]:
        stmt = select(Author).where(Author.department_id == department_id)\
                            .limit(limit).offset(offset)\
                            .order_by(Author.id)
        result = await self._session.execute(stmt)
        return result.scalars().all()
