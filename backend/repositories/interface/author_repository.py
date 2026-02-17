from typing import Protocol
from models.author import Author

class IAuthorRepository(Protocol):
    async def get_all(self, limit: int = 20, offset: int = 0) -> list[Author]:
        ...

    async def get_by_id(self, author_id: int) -> Author | None:
        ...

    async def add(self, author: Author) -> Author:
        ...

    async def update(self, author: Author) -> Author:
        ...

    async def delete(self, author_id: int) -> None:
        ...
