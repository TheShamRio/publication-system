from fastapi import FastAPI, Depends
from api.rest.routes.publication_files import router as publication_files_router
from api.rest.dependencies import get_current_user, require_role

app = FastAPI(title="Publication Management System")

app.include_router(publication_files_router)


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/me")
async def me(user=Depends(get_current_user)):
    return user


@app.get("/admin")
async def admin_endpoint(user=Depends(require_role("admin"))):
    return {"message": f"Hello admin {user['login']}", "user": user}


@app.get("/manager")
async def manager_endpoint(user=Depends(require_role("manager"))):
    return {"message": "Hello manager", "user": user}


@app.get("/user")
async def user_endpoint(user=Depends(require_role("user"))):
    return {"message": "Hello user", "user": user}
