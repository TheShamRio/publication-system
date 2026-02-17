from typing import Protocol

from models.university_department import UniversityDepartment
from models.author import Author


class IDepartmentRepository(Protocol):
    async def get_all(self, limit: int = 20, offset: int = 0) -> list[UniversityDepartment]:
        ...


    async def get_by_id(self, department_id: int) -> UniversityDepartment | None:
        ...


    async def add(self, author: UniversityDepartment) -> UniversityDepartment:
        ...


    async def update(self, department: UniversityDepartment) -> UniversityDepartment:
        ...


    async def delete(self, department: UniversityDepartment) -> None:
        ...
    

    async def get_all_department_authors(
        self, 
        department_id: int, 
        limit: int = 20, 
        offset: int = 0
    ) -> list[Author]:
        ...
