from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from models.author import Author
from repositories.interface.author_repository import IAuthorRepository


class AuthorRepository(IAuthorRepository):
    def __init__(self, session: AsyncSession):
        self._session = session


    async def get_all(self, limit: int = 20, offset: int = 0) -> list[Author]:
        stmt = select(Author).order_by(Author.id).limit(limit).offset(offset)
        result = await self._session.execute(stmt)
        return result.scalars().all()


    async def get_by_id(self, author_id: int) -> Author:
        result = await self._session.execute(
            select(Author).where(Author.id == author_id)
        )
        return result.scalars().first()


    async def add(self, author: Author) -> Author:
        self._session.add(author)
        await self._session.commit()
        await self._session.refresh(author)
        return author

    
    async def update(self, author: Author) -> Author:
        await self._session.commit()
        await self._session.refresh(author)
        return author
    
    
    async def delete(self, author: Author) -> None:
        await self._session.delete(author)
        await self._session.commit()
