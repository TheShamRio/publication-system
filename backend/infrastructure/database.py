from typing import AsyncIterator
from sqlalchemy.ext.asyncio import (
    AsyncEngine,
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)
from sqlalchemy.orm import DeclarativeBase
from config.settings import settings


class Base(DeclarativeBase):
    """Declarative base for all ORM models."""


engine: AsyncEngine = create_async_engine(
    settings.DATABASE_URL,
    echo=False,
    pool_pre_ping=True,
)

SessionFactory = async_sessionmaker(
    engine,
    expire_on_commit=False,
)


async def get_session() -> AsyncIterator[AsyncSession]:
    """Provide a transactional async DB session."""
    async with SessionFactory() as session:
        yield session
