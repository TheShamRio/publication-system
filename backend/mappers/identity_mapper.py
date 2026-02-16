from api.rest.schemas.user import UserSchema


class IdentityMapper:
    """Maps IdP payloads into internal API schemas."""

    @staticmethod
    def from_keycloak(payload: dict) -> UserSchema:
        return UserSchema(
            id=payload["sub"],
            username=payload.get("preferred_username"),
            roles=payload.get("realm_access", {}).get("roles", []),
            first_name=payload.get("given_name"),
            middle_name=payload.get("middleName"),
            third_name=payload.get("family_name"),
        )
