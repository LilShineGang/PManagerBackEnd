import mariadb
from app.config.config import db_config
from app.models import PostReplyIn, PostReplyOut

_REPLY_SELECT = """
    SELECT pr.id_reply, pr.id_discussion, pr.id_user, pr.content, pr.image,
           u.username,
           DATE_FORMAT(pr.created_at, '%Y-%m-%d %H:%i') AS created_at,
           pr.id_parent_reply,
           pu.username AS parent_author
    FROM post_replies pr
    LEFT JOIN users u  ON pr.id_user         = u.id
    LEFT JOIN post_replies pp ON pr.id_parent_reply = pp.id_reply
    LEFT JOIN users pu ON pp.id_user          = pu.id
"""


def _row_to_reply(row) -> PostReplyOut:
    return PostReplyOut(
        id_reply=row[0],
        id_discussion=row[1],
        id_user=row[2],
        content=row[3],
        image=row[4],
        author_username=row[5],
        created_at=row[6],
        id_parent_reply=row[7],
        parent_author=row[8],
    )


def insert_reply(reply_in: PostReplyIn, discussion_id: int, user_id: int) -> int:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            cursor.execute(
                "INSERT INTO post_replies (id_discussion, id_user, content, id_parent_reply) VALUES (?, ?, ?, ?)",
                (discussion_id, user_id, reply_in.content, reply_in.id_parent_reply),
            )
            conn.commit()
            return cursor.lastrowid


def get_reply_by_id(reply_id: int) -> PostReplyOut | None:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            cursor.execute(f"{_REPLY_SELECT} WHERE pr.id_reply = ?", (reply_id,))
            row = cursor.fetchone()
            return _row_to_reply(row) if row else None


def get_replies_by_discussion(discussion_id: int) -> list[PostReplyOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            cursor.execute(
                f"{_REPLY_SELECT} WHERE pr.id_discussion = ? ORDER BY pr.created_at ASC",
                (discussion_id,),
            )
            return [_row_to_reply(r) for r in cursor.fetchall()]


def update_reply_image(reply_id: int, image_url: str) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            cursor.execute(
                "UPDATE post_replies SET image = ? WHERE id_reply = ?",
                (image_url, reply_id),
            )
            conn.commit()
            return cursor.rowcount > 0


def delete_reply(reply_id: int) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            cursor.execute("DELETE FROM post_replies WHERE id_reply = ?", (reply_id,))
            conn.commit()
            return cursor.rowcount > 0
