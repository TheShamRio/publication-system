from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2AuthorizationCodeBearer
from infrastructure.keycloak_service import get_user_info_from_token

oauth2_scheme = OAuth2AuthorizationCodeBearer(
    authorizationUrl="http://keycloak:8080/realms/myrealm/protocol/openid-connect/auth",
    tokenUrl="http://keycloak:8080/realms/myrealm/protocol/openid-connect/token",
)


async def get_current_user(token: str = Depends(oauth2_scheme)):
    return await get_user_info_from_token(token)


def require_role(role: str):
    async def role_checker(user=Depends(get_current_user)):
        if role not in user["roles"]:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Forbidden: insufficient role",
            )
        return user
    return role_checker
