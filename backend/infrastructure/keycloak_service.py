import os
import httpx
import asyncio
from jose import jwt, JWTError
from fastapi import HTTPException, status
from typing import Optional, Dict
import time

KEYCLOAK_URL = os.getenv("KEYCLOAK_URL", "http://keycloak:8080")
KEYCLOAK_REALM = os.getenv("KEYCLOAK_REALM", "myrealm")
ALGORITHM = "RS256"

JWKS_URL = f"{KEYCLOAK_URL}/realms/{KEYCLOAK_REALM}/protocol/openid-connect/certs"

JWKS_CACHE: Optional[dict] = None
JWKS_LAST_FETCH: float = 0
JWKS_TTL: int = 3600  # 1 hour


async def get_jwks() -> dict:
    """Fetch JWKS from Keycloak lazily and cache it."""
    global JWKS_CACHE, JWKS_LAST_FETCH
    now = time.time()
    if JWKS_CACHE and now - JWKS_LAST_FETCH < JWKS_TTL:
        return JWKS_CACHE

    async with httpx.AsyncClient(timeout=5) as client:
        for _ in range(10):
            try:
                resp = await client.get(JWKS_URL)
                resp.raise_for_status()
                JWKS_CACHE = resp.json()
                JWKS_LAST_FETCH = time.time()
                return JWKS_CACHE
            except Exception:
                await asyncio.sleep(2)

    raise HTTPException(
        status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
        detail="Keycloak JWKS not available",
    )


async def decode_token(token: str) -> dict:
    """Verify JWT and return payload."""
    jwks = await get_jwks()
    try:
        header = jwt.get_unverified_header(token)
        key = next(k for k in jwks["keys"] if k["kid"] == header["kid"])
        payload = jwt.decode(token, key, algorithms=[ALGORITHM], options={"verify_aud": False})
        return payload
    except (JWTError, StopIteration):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired token")


async def get_user_info_from_token(token: str) -> Dict:
    """Return minimal user info from JWT payload."""
    payload = await decode_token(token)
    return {
        "keycloak_id": payload.get("sub"),
        "login": payload.get("preferred_username"),
        "firstName": payload.get("firstName"),
        "middleName": payload.get("middleName"),
        "thirdName": payload.get("thirdName"),
        "roles": payload.get("realm_access", {}).get("roles", []),
    }
