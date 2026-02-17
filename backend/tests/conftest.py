from typing import AsyncGenerator
import os
import sys
from pathlib import Path

import pytest_asyncio
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import text
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession

backend_root = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(backend_root))

os.environ["DATABASE_URL"] = "sqlite+aiosqlite:///:memory:"
os.environ["KEYCLOAK_URL"] = "http://localhost"
os.environ["KEYCLOAK_REALM"] = "test"
os.environ["KEYCLOAK_CLIENT_ID"] = "test"
os.environ["KEYCLOAK_ADMIN_USER"] = "admin"
os.environ["KEYCLOAK_ADMIN_PASSWORD"] = "admin"
os.environ["MINIO_ENDPOINT"] = "http://localhost"
os.environ["MINIO_ACCESS_KEY"] = "test"
os.environ["MINIO_SECRET_KEY"] = "test"
os.environ["MINIO_BUCKET"] = "test"
os.environ["MINIO_SECURE"] = "False"

from infrastructure.database import Base  # noqa: E402
from main import app  # noqa: E402


DATABASE_URL = "sqlite+aiosqlite:///:memory:"

engine = create_async_engine(DATABASE_URL, echo=False)


@pytest_asyncio.fixture(scope="session")
async def setup_db():
    """
    Create all tables at the beginning of the test session and drop at the end.
    """
    async with engine.begin() as conn:
        await conn.execute(text("PRAGMA foreign_keys=ON"))
        await conn.run_sync(Base.metadata.create_all)
    yield
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)


@pytest_asyncio.fixture
async def session(setup_db) -> AsyncGenerator[AsyncSession, None]:
    async with engine.connect() as conn:
        transaction = await conn.begin()

        async_session = async_sessionmaker(
            bind=conn,
            expire_on_commit=False,
        )

        async with async_session() as session:
            yield session

        await transaction.rollback()


@pytest.fixture(scope="session")
def client():
    """
    Provides a reusable FastAPI TestClient for all tests.
    Scope: session -> created once per test session.
    """
    with TestClient(app) as c:
        yield c


@pytest.fixture
def temp_dir(tmp_path):
    """
    Provides a temporary directory for file operations.
    """
    return tmp_path
