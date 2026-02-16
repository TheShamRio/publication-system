from pydantic import BaseModel


class UserSchema(BaseModel):
    """User data exposed via API."""

    id: str
    username: str
    roles: list[str]

    first_name: str | None = None
    middle_name: str | None = None
    third_name: str | None = None

    class Config:
        from_attributes = True
