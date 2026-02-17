import pytest
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError

from models.university_department import UniversityDepartment
from models.author import Author
from repositories.imp.author_repository import AuthorRepository
from repositories.interface.author_repository import IAuthorRepository


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "first_name, middle_name, third_name, username, department_id",
    [
        ("Alice", "Brown", None, None, None),
        ("Bob", "Smith", "Black", "bob123", None),
        ("Charlie", "Davis", "White", None, None),
        ("David", "Evans", None, "david123", None),
    ]
)
async def test_add_author(
    session: AsyncSession,
    first_name, 
    middle_name,
    third_name,
    username,
    department_id
):
    repo: IAuthorRepository = AuthorRepository(session)
    author = Author(
        first_name=first_name,
        middle_name=middle_name,
        third_name=third_name,
        username=username,
        department_id=department_id
    )

    added = await repo.add(author)

    assert added.id is not None
    assert added.first_name == first_name
    assert added.middle_name == middle_name
    assert added.third_name == third_name
    assert added.username == username
    assert added.department_id == department_id


@pytest.mark.asyncio
async def test_username_unique_constraint(session: AsyncSession):
    repo: IAuthorRepository = AuthorRepository(session)

    author1 = Author(
        first_name="First",
        middle_name="Firstm",
        third_name=None,
        username="unique_user",
        department_id=None,
    )
    await repo.add(author1)

    author2 = Author(
        first_name="Second",
        middle_name="Secondm",
        third_name=None,
        username="unique_user",  # duplicate
        department_id=None,
    )

    with pytest.raises(IntegrityError):
        await repo.add(author2)


@pytest.mark.asyncio
async def test_add_author_without_firstname_raises(session: AsyncSession):
    repo: IAuthorRepository = AuthorRepository(session)

    author = Author(
        first_name=None,
        middle_name="Brown",
        third_name=None,
        username="alice123",
        department_id=None,
    )

    with pytest.raises(IntegrityError):
        await repo.add(author)


@pytest.mark.asyncio
async def test_add_author_without_middlename_raises(session: AsyncSession):
    repo: IAuthorRepository = AuthorRepository(session)

    author = Author(
        first_name="Alice",
        middle_name=None,
        third_name=None,
        username="alice123",
        department_id=None,
    )

    with pytest.raises(IntegrityError):
        await repo.add(author)


@pytest.mark.asyncio
async def test_get_all_authors_with_pagination(session: AsyncSession):
    repo: IAuthorRepository = AuthorRepository(session)

    # Create 5 authors
    authors_data = [
        ("A1", "A1m", None),
        ("A2", "A2m", None),
        ("A3", "A3m", None),
        ("A4", "A4m", None),
        ("A5", "A5m", None),
    ]

    created_authors = []

    for first_name, middle_name, third_name in authors_data:
        author = Author(
            first_name=first_name,
            middle_name=middle_name,
            third_name=third_name,
            username=None,
            department_id=None,
        )
        created = await repo.add(author)
        created_authors.append(created)

    # Fetch first page (limit=2, offset=0)
    page1 = await repo.get_all(limit=2, offset=0)

    assert len(page1) == 2
    assert page1[0].id == created_authors[0].id
    assert page1[1].id == created_authors[1].id

    # Fetch second page (limit=2, offset=2)
    page2 = await repo.get_all(limit=2, offset=2)

    assert len(page2) == 2
    assert page2[0].id == created_authors[2].id
    assert page2[1].id == created_authors[3].id

    # Fetch third page (limit=2, offset=4)
    page3 = await repo.get_all(limit=2, offset=4)

    assert len(page3) == 1
    assert page3[0].id == created_authors[4].id


@pytest.mark.asyncio
async def test_update_author(session: AsyncSession):
    repo: IAuthorRepository = AuthorRepository(session)

    author = Author(first_name="Old", middle_name="Oldm", third_name=None, username="olduser", department_id=None)
    added = await repo.add(author)

    added.first_name = "New"
    added.username = "newuser"
    updated = await repo.update(added)

    assert updated.first_name == "New"
    assert updated.username == "newuser"


@pytest.mark.asyncio
async def test_delete_author(session: AsyncSession):
    repo: IAuthorRepository = AuthorRepository(session)

    author = Author(first_name="ToDelete", middle_name="ToDeletem", third_name=None, username=None, department_id=None)
    added = await repo.add(author)

    await repo.delete(added)

    fetched = await repo.get_by_id(added.id)
    assert fetched is None


@pytest.mark.asyncio
async def test_author_department_fk_enforced(session: AsyncSession):
    repo: IAuthorRepository = AuthorRepository(session)

    author_no_dept = Author(first_name="Alice", middle_name="M", third_name=None, username="alice123")
    added = await repo.add(author_no_dept)
    assert added.id is not None
    assert added.department_id is None

    dept = UniversityDepartment(title="Physics")
    session.add(dept)
    await session.commit()
    await session.refresh(dept)

    author_with_dept = Author(first_name="Bob", middle_name="J", third_name=None, username="bob123", department_id=dept.id)
    added_dept = await repo.add(author_with_dept)
    assert added_dept.department_id == dept.id

    author_invalid_dept = Author(first_name="Charlie", middle_name="K", third_name=None, username="charlie123", department_id=9999)
    with pytest.raises(IntegrityError):
        await repo.add(author_invalid_dept)
