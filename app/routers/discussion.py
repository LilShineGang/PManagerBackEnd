from fastapi import APIRouter, status, Depends, HTTPException, UploadFile, File, Request
from app.models import (
    DiscussionIn, DiscussionOut,
    PostReplyIn, PostReplyOut,
    PostVoteIn, VoteResponse,
)
from app.database import (
    insert_discussion,
    get_discussion_by_id,
    get_all_discussions,
    get_discussions_by_forum,
    update_discussion,
    delete_discussion,
    get_user_by_username,
)
from app.repositories.discussion import update_discussion_image
from app.repositories.post_replies import (
    insert_reply, get_reply_by_id,
    get_replies_by_discussion, update_reply_image, delete_reply,
)
from app.repositories.post_votes import upsert_vote, get_my_vote, get_vote_counts
from app.repositories.users import update_user_honor
from app.auth import oauth2_scheme, decode_token, TokenData
from app.shared.images import save_upload

router = APIRouter(prefix="/discussions", tags=["Discussions"])


# ── helpers ────────────────────────────────────────────────────────────────

def _require_user(token: str):
    data: TokenData = decode_token(token)
    user = get_user_by_username(data.username)
    if not user:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Forbidden")
    return user


# ── Discussion CRUD ────────────────────────────────────────────────────────

@router.post("/", status_code=status.HTTP_201_CREATED, response_model=DiscussionOut)
async def create_discussion(
    discussion_in: DiscussionIn,
    token: str = Depends(oauth2_scheme),
):
    user = _require_user(token)
    disc_id = insert_discussion(discussion_in, user.id)
    result = get_discussion_by_id(disc_id)
    return result


@router.get("/", response_model=list[DiscussionOut])
async def list_discussions(token: str = Depends(oauth2_scheme)):
    decode_token(token)
    return get_all_discussions()


@router.get("/forum/{id_forum}/", response_model=list[DiscussionOut])
async def list_discussions_by_forum(id_forum: int, token: str = Depends(oauth2_scheme)):
    decode_token(token)
    return get_discussions_by_forum(id_forum)


@router.get("/{id_discussion}/", response_model=DiscussionOut)
async def get_discussion(id_discussion: int, token: str = Depends(oauth2_scheme)):
    decode_token(token)
    disc = get_discussion_by_id(id_discussion)
    if not disc:
        raise HTTPException(status_code=404, detail="Discussion not found")
    return disc


@router.put("/{id_discussion}/", response_model=DiscussionOut)
async def update_discussion_endpoint(
    id_discussion: int,
    discussion_in: DiscussionIn,
    token: str = Depends(oauth2_scheme),
):
    user = _require_user(token)
    existing = get_discussion_by_id(id_discussion)
    if not existing:
        raise HTTPException(status_code=404, detail="Discussion not found")
    if user.role != "admin" and existing.id_user != user.id:
        raise HTTPException(status_code=403, detail="Not allowed")
    update_discussion(id_discussion, discussion_in)
    return get_discussion_by_id(id_discussion)


@router.delete("/{id_discussion}/", status_code=status.HTTP_204_NO_CONTENT)
async def delete_discussion_endpoint(
    id_discussion: int,
    token: str = Depends(oauth2_scheme),
):
    user = _require_user(token)
    existing = get_discussion_by_id(id_discussion)
    if not existing:
        raise HTTPException(status_code=404, detail="Discussion not found")
    if user.role != "admin" and existing.id_user != user.id:
        raise HTTPException(status_code=403, detail="Not allowed")
    delete_discussion(id_discussion)


# ── Image upload ────────────────────────────────────────────────────────────

@router.post("/{id_discussion}/image/", response_model=DiscussionOut)
async def upload_discussion_image(
    id_discussion: int,
    request: Request,
    file: UploadFile = File(...),
    token: str = Depends(oauth2_scheme),
):
    user = _require_user(token)
    disc = get_discussion_by_id(id_discussion)
    if not disc:
        raise HTTPException(status_code=404, detail="Discussion not found")
    if user.role != "admin" and disc.id_user != user.id:
        raise HTTPException(status_code=403, detail="Not allowed")
    image_url = await save_upload(file, request)
    update_discussion_image(id_discussion, image_url)
    return get_discussion_by_id(id_discussion)


# ── Votes ───────────────────────────────────────────────────────────────────

@router.post("/{id_discussion}/vote/", response_model=VoteResponse)
async def vote_discussion(
    id_discussion: int,
    vote_in: PostVoteIn,
    token: str = Depends(oauth2_scheme),
):
    user = _require_user(token)
    if vote_in.vote not in (1, -1):
        raise HTTPException(status_code=400, detail="vote must be 1 or -1")

    disc = get_discussion_by_id(id_discussion)
    if not disc:
        raise HTTPException(status_code=404, detail="Discussion not found")

    old_vote, new_vote = upsert_vote(id_discussion, user.id, vote_in.vote)

    # Honor: only likes (vote=1) affect honor
    if disc.id_user and disc.id_user != user.id:
        if old_vote != 1 and new_vote == 1:
            update_user_honor(disc.id_user, +1)
        elif old_vote == 1 and new_vote != 1:
            update_user_honor(disc.id_user, -1)

    likes, dislikes = get_vote_counts(id_discussion)
    return VoteResponse(my_vote=new_vote, likes=likes, dislikes=dislikes)


@router.get("/{id_discussion}/vote/", response_model=VoteResponse)
async def get_my_vote_endpoint(
    id_discussion: int,
    token: str = Depends(oauth2_scheme),
):
    user = _require_user(token)
    my = get_my_vote(id_discussion, user.id)
    likes, dislikes = get_vote_counts(id_discussion)
    return VoteResponse(my_vote=my, likes=likes, dislikes=dislikes)


# ── Replies ─────────────────────────────────────────────────────────────────

@router.get("/{id_discussion}/replies/", response_model=list[PostReplyOut])
async def list_replies(id_discussion: int, token: str = Depends(oauth2_scheme)):
    decode_token(token)
    return get_replies_by_discussion(id_discussion)


@router.post(
    "/{id_discussion}/replies/",
    status_code=status.HTTP_201_CREATED,
    response_model=PostReplyOut,
)
async def create_reply(
    id_discussion: int,
    reply_in: PostReplyIn,
    token: str = Depends(oauth2_scheme),
):
    user = _require_user(token)
    if not get_discussion_by_id(id_discussion):
        raise HTTPException(status_code=404, detail="Discussion not found")
    reply_id = insert_reply(reply_in, id_discussion, user.id)
    return get_reply_by_id(reply_id)


@router.post(
    "/{id_discussion}/replies/{id_reply}/image/",
    response_model=PostReplyOut,
)
async def upload_reply_image(
    id_discussion: int,
    id_reply: int,
    request: Request,
    file: UploadFile = File(...),
    token: str = Depends(oauth2_scheme),
):
    user = _require_user(token)
    reply = get_reply_by_id(id_reply)
    if not reply or reply.id_discussion != id_discussion:
        raise HTTPException(status_code=404, detail="Reply not found")
    if user.role != "admin" and reply.id_user != user.id:
        raise HTTPException(status_code=403, detail="Not allowed")
    image_url = await save_upload(file, request)
    update_reply_image(id_reply, image_url)
    return get_reply_by_id(id_reply)


@router.delete(
    "/{id_discussion}/replies/{id_reply}/",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_reply_endpoint(
    id_discussion: int,
    id_reply: int,
    token: str = Depends(oauth2_scheme),
):
    user = _require_user(token)
    reply = get_reply_by_id(id_reply)
    if not reply or reply.id_discussion != id_discussion:
        raise HTTPException(status_code=404, detail="Reply not found")
    if user.role != "admin" and reply.id_user != user.id:
        raise HTTPException(status_code=403, detail="Not allowed")
    delete_reply(id_reply)
