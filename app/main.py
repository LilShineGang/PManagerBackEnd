import os
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from app.routers import (
    achievements,
    builds,
    chats,
    direct_chats,
    discussion,
    forums,
    games,
    groups,
    guides,
    messages_instance,
    tier_list,
    users,
    wiki,
)

app = FastAPI(debug=True)

STATIC_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), "static")
os.makedirs(os.path.join(STATIC_DIR, "images"), exist_ok=True)
app.mount("/static", StaticFiles(directory=STATIC_DIR), name="static")

app.include_router(users.router)
app.include_router(games.router)
app.include_router(forums.router)
app.include_router(wiki.router)
app.include_router(guides.router)
app.include_router(achievements.router)
app.include_router(tier_list.router)
app.include_router(groups.router)
app.include_router(messages_instance.router)
app.include_router(chats.router)
app.include_router(direct_chats.router)
app.include_router(builds.router)
app.include_router(discussion.router)

@app.get("/")
async def root():
    return {"message": "Welcome to PManager API"}
