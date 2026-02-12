from fastapi import FastAPI, Depends, HTTPException, status, Request
from fastapi.security import OAuth2AuthorizationCodeBearer
from jose import jwt, JWTError
import httpx
import os
import time
import asyncio
from typing import Optional

# =====================================================
# Configuration
# =====================================================

KEYCLOAK_URL = os.getenv("KEYCLOAK_URL", "http://keycloak:8080")
KEYCLOAK_REALM = os.getenv("KEYCLOAK_REALM", "myrealm")

ALGORITHM = "RS256"

JWKS_URL = (
    f"{KEYCLOAK_URL}/realms/{KEYCLOAK_REALM}"
    f"/protocol/openid-connect/certs"
)

oauth2_scheme = OAuth2AuthorizationCodeBearer(
    authorizationUrl=(
        f"{KEYCLOAK_URL}/realms/{KEYCLOAK_REALM}"
        f"/protocol/openid-connect/auth"
    ),
    tokenUrl=(
        f"{KEYCLOAK_URL}/realms/{KEYCLOAK_REALM}"
        f"/protocol/openid-connect/token"
    ),
)

# =====================================================
# JWKS cache (lazy-loaded)
# =====================================================

JWKS_CACHE: Optional[dict] = None
JWKS_LAST_FETCH: float = 0
JWKS_TTL: int = 3600  # seconds (1 hour)

# =====================================================
# FastAPI app
# =====================================================

app = FastAPI(title="FastAPI + Keycloak")

# =====================================================
# JWKS loader
# =====================================================

async def get_jwks() -> dict:
    """
    Fetches JWKS from Keycloak lazily and caches it.
    Retries while Keycloak is starting.
    """
    global JWKS_CACHE, JWKS_LAST_FETCH

    now = time.time()
    if JWKS_CACHE and now - JWKS_LAST_FETCH < JWKS_TTL:
        return JWKS_CACHE

    async with httpx.AsyncClient(timeout=5) as client:
        for _ in range(10):  # retry up to ~20s
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

# =====================================================
# Token decoding
# =====================================================

async def decode_token(token: str) -> dict:
    """
    Verifies JWT signature and returns payload.
    """
    jwks = await get_jwks()

    try:
        # Extract header WITHOUT verifying signature
        header = jwt.get_unverified_header(token)

        # Match the public key by key id (kid)
        key = next(k for k in jwks["keys"] if k["kid"] == header["kid"])

        # Verify signature and decode payload
        payload = jwt.decode(
            token,
            key,
            algorithms=[ALGORITHM],
            options={"verify_aud": False},
        )
        return payload

    except (JWTError, StopIteration):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
        )

# =====================================================
# Dependencies
# =====================================================

async def get_current_user(token: str = Depends(oauth2_scheme)):
    """
    Authentication dependency.
    Extracts user identity from JWT.
    """
    payload = await decode_token(token)

    return {
        "login": payload.get("preferred_username"),
        "firstName": payload.get("firstName"),
        "middleName": payload.get("middleName"),
        "thirdName": payload.get("thirdName"),
        "roles": payload.get("realm_access", {}).get("roles", []),
    }

def require_role(role: str):
    """
    Authorization dependency.
    Ensures user has a specific role.
    """
    async def role_checker(user=Depends(get_current_user)):
        if role not in user["roles"]:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Forbidden: insufficient role",
            )
        return user

    return role_checker

# =====================================================
# Routes
# =====================================================

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/me")
async def me(user=Depends(get_current_user)):
    return user

@app.get("/admin")
async def admin_endpoint(user=Depends(require_role("admin"))):
    return {
        "message": f"Hello admin {user['login']}",
        "user": user,
    }

@app.get("/manager")
async def manager_endpoint(user=Depends(require_role("manager"))):
    return {
        "message": "Hello manager",
        "user": user,
    }

@app.get("/user")
async def user_endpoint(user=Depends(require_role("user"))):
    return {
        "message": "Hello user",
        "user": user,
    }
