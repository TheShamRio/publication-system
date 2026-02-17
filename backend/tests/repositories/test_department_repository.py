import pytest
from sqlalchemy.ext.asyncio import AsyncSession

from models.university_department import UniversityDepartment
from models.author import Author
from repositories.interface.department_repository import IDepartmentRepository
from repositories.imp.department_repository import DepartmentRepository


@pytest.mark.asyncio
async def test_add_department(
    session: AsyncSession,
):
    repo: IDepartmentRepository = DepartmentRepository(session)

    title = "PMI"
    department = UniversityDepartment(title=title)

    added = await repo.add(department)

    assert added.id is not None
    assert added.title == title


@pytest.mark.asyncio
async def test_update_department(session: AsyncSession):
    repo: IDepartmentRepository = DepartmentRepository(session)

    title = "PMI"
    department = UniversityDepartment(title=title)

    added = await repo.add(department)

    updated_title = "KS"
    added.title = updated_title
    updated = await repo.update(added)

    assert updated.title == updated_title


@pytest.mark.asyncio
async def test_delete_department(session: AsyncSession):
    repo: IDepartmentRepository = DepartmentRepository(session)

    department = UniversityDepartment(title="PMI")
    added = await repo.add(department)

    await repo.delete(added)

    fetched = await repo.get_by_id(added.id)
    assert fetched is None


@pytest.mark.asyncio
async def test_get_all_department_authors_with_pagination(session: AsyncSession):
    repo: IDepartmentRepository = DepartmentRepository(session)

    dept1 = UniversityDepartment(title="Dept1")
    dept2 = UniversityDepartment(title="Dept2")
    session.add_all([dept1, dept2])
    await session.commit()
    await session.refresh(dept1)
    await session.refresh(dept2)

    authors_data = [
        ("A1", "A1m", None, dept1.id),
        ("A2", "A2m", None, dept1.id),
        ("A3", "A3m", None, dept2.id),
        ("A4", "A4m", None, dept1.id),
        ("A5", "A5m", None, dept2.id),
        ("A6", "A6m", None, dept1.id),
    ]

    created_authors = []
    for first_name, middle_name, third_name, department_id in authors_data:
        author = Author(
            first_name=first_name,
            middle_name=middle_name,
            third_name=third_name,
            username=None,
            department_id=department_id,
        )
        session.add(author)
        await session.commit()
        await session.refresh(author)
        created_authors.append(author)

    # Fetch authors from department 1 with pagination
    page1 = await repo.get_all_department_authors(department_id=dept1.id, limit=2, offset=0)
    page2 = await repo.get_all_department_authors(department_id=dept1.id, limit=2, offset=2)
    page3 = await repo.get_all_department_authors(department_id=dept1.id, limit=2, offset=4)

    assert len(page1) == 2
    assert [a.first_name for a in page1] == ["A1", "A2"]

    assert len(page2) == 2
    assert [a.first_name for a in page2] == ["A4", "A6"]

    assert len(page3) == 0  # no more authors in dept1

    # Fetch all authors from department 2
    dept2_authors = await repo.get_all_department_authors(department_id=dept2.id)
    assert len(dept2_authors) == 2
    assert {a.first_name for a in dept2_authors} == {"A3", "A5"}
