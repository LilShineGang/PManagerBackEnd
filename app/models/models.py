from pydantic import BaseModel


# --- Forum models ---
class ForumIn(BaseModel):
    name: str
    game_name: str
    forum_type: str = "community"  # "official" | "community"


class ForumOut(BaseModel):
    id_forum: int
    name: str
    id_game: int | None = None
    id_user: int | None = None
    forum_type: str = "community"


# --- User models ---
class UserBase(BaseModel):
    username: str
    password: str


class UserIn(UserBase):
    name: str
    email: str
    image: str | None = None
    banner: str | None = None
    role: str = "user"


class UserDb(UserIn):
    id: int
    honor: int = 0


class UserOut(BaseModel):
    id: int
    name: str
    username: str
    email: str
    image: str | None = None
    banner: str | None = None
    role: str
    honor: int = 0


class TokenOut(BaseModel):
    token: str


class UserUpdate(BaseModel):
    name: str | None = None
    email: str | None = None
    image: str | None = None
    banner: str | None = None
    password: str | None = None


# --- Game models ---
class GameIn(BaseModel):
    name: str
    gender: str
    difficulty: str
    rating: float | None = None
    image: str | None = None
    category: str


class GameDb(GameIn):
    id_game: int


class GameOut(BaseModel):
    id_game: int
    name: str
    gender: str
    difficulty: str
    rating: float | None = None
    image: str | None = None
    category: str


# --- Achievement models ---
class AchievementIn(BaseModel):
    difficulty: str
    description: str
    id_game: int | None = None


class AchievementDb(AchievementIn):
    id_achievement: int


class AchievementOut(BaseModel):
    id_achievement: int
    difficulty: str
    description: str
    id_game: int | None = None


# --- Guide models ---
class GuideIn(BaseModel):
    name: str
    difficulty: str
    category: str
    forum_id: int


class GuideDb(GuideIn):
    id_guide: int


class GuideOut(BaseModel):
    id_guide: int
    name: str
    difficulty: str
    category: str


# --- Wiki models ---
class WikiIn(BaseModel):
    name: str
    category: str
    description: str
    id_forum: int | None = None


class WikiOut(BaseModel):
    id_wiki: int
    name: str
    category: str
    description: str
    id_forum: int | None = None


# --- Messages Instance models ---
class MessageInstanceIn(BaseModel):
    status: str
    content: str | None = None


class MessageInstanceDb(MessageInstanceIn):
    id_mi: int
    timestamp: str | None = None


class MessageInstanceOut(BaseModel):
    id_mi: int
    status: str
    content: str | None = None
    timestamp: str | None = None


# --- Chat models ---
class ChatIn(BaseModel):
    id_mi: int
    content: str


class ChatDb(ChatIn):
    id_chat: int
    timestamp: str | None = None


class ChatOut(BaseModel):
    id_chat: int
    id_mi: int
    content: str
    timestamp: str | None = None


# --- Build models ---
class BuildIn(BaseModel):
    name: str
    planner: str
    category: str
    description: str
    id_forum: int | None = None


class BuildDb(BuildIn):
    id_build: int


class BuildOut(BaseModel):
    id_build: int
    name: str
    planner: str
    category: str
    description: str
    id_forum: int | None = None


# --- Tier list models ---
class TierListIn(BaseModel):
    name: str
    category: str
    description: str
    id_forum: int | None = None


class TierListOut(BaseModel):
    id_tl: int
    name: str
    category: str
    description: str
    id_forum: int | None = None


# --- Groups models ---
class GroupIn(BaseModel):
    name: str
    description: str | None = None
    image: str | None = None
    id_forum: int | None = None


class GroupOut(BaseModel):
    id_group: int
    name: str
    admin: int
    description: str | None = None
    image: str | None = None
    id_forum: int | None = None


# --- Discussion models ---
class DiscussionIn(BaseModel):
    name: str
    comments: str | None = None   # body / content
    image: str | None = None
    posts: int | None = None
    rating: float | None = None
    id_forum: int | None = None


class DiscussionDb(DiscussionIn):
    id_discussion: int


class DiscussionOut(BaseModel):
    id_discussion: int
    name: str
    comments: str | None = None
    image: str | None = None
    posts: int | None = None
    rating: float | None = None
    id_forum: int | None = None
    id_user: int | None = None
    author_username: str | None = None
    likes: int = 0
    dislikes: int = 0
    reply_count: int = 0
    created_at: str | None = None
    author_image: str | None = None


# --- Post reply models ---
class PostReplyIn(BaseModel):
    content: str
    id_parent_reply: int | None = None


class PostReplyOut(BaseModel):
    id_reply: int
    id_discussion: int
    id_user: int
    content: str
    image: str | None = None
    author_username: str | None = None
    created_at: str | None = None
    id_parent_reply: int | None = None
    parent_author: str | None = None
    likes: int = 0
    dislikes: int = 0
    author_image: str | None = None


# --- Vote models ---
class PostVoteIn(BaseModel):
    vote: int  # 1 = like, -1 = dislike


class VoteResponse(BaseModel):
    my_vote: int   # 0 = no vote, 1 = like, -1 = dislike
    likes: int
    dislikes: int


# --- Direct chat models ---
class StartConversationIn(BaseModel):
    other_username: str


class DirectConversationOut(BaseModel):
    id_conversation: int
    other_user_id: int
    other_username: str
    other_user_image: str | None = None
    last_message: str | None = None
    last_timestamp: str | None = None


class DirectMessageIn(BaseModel):
    content: str


class DirectMessageOut(BaseModel):
    id_message: int
    id_conversation: int
    sender_id: int
    sender_username: str
    content: str
    timestamp: str | None = None
