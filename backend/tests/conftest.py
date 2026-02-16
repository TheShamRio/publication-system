import pytest
from fastapi.testclient import TestClient

from backend.main import app


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
