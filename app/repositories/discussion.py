import mariadb
from app.config.config import db_config
from app.models import DiscussionIn, DiscussionOut

# Enriched SELECT: joins users, post_votes and post_replies in one shot.
_DISCUSSION_SELECT = """
    SELECT
        d.id_discussion,
        d.name,
        d.comments,
        d.image,
        d.posts,
        d.rating,
        d.id_forum,
        d.id_user,
        u.username AS author_username,
        COALESCE(SUM(CASE WHEN pv.vote =  1 THEN 1 ELSE 0 END), 0) AS likes,
        COALESCE(SUM(CASE WHEN pv.vote = -1 THEN 1 ELSE 0 END), 0) AS dislikes,
        COALESCE(COUNT(DISTINCT pr.id_reply), 0)                    AS reply_count,
        DATE_FORMAT(d.created_at, '%Y-%m-%d %H:%i')           AS created_at
    FROM discussion d
    LEFT JOIN users        u  ON d.id_user       = u.id
    LEFT JOIN post_votes   pv ON d.id_discussion = pv.id_discussion
    LEFT JOIN post_replies pr ON d.id_discussion = pr.id_discussion
"""

_GROUP_BY = """
    GROUP BY d.id_discussion, d.name, d.comments, d.image, d.posts, d.rating,
             d.id_forum, d.id_user, u.username, d.created_at
"""


def _row_to_discussion(row) -> DiscussionOut:
    return DiscussionOut(
        id_discussion=row[0],
        name=row[1],
        comments=row[2],
        image=row[3],
        posts=row[4],
        rating=row[5],
        id_forum=row[6],
        id_user=row[7],
        author_username=row[8],
        likes=int(row[9]),
        dislikes=int(row[10]),
        reply_count=int(row[11]),
        created_at=row[12],
    )


def insert_discussion(discussion_in: DiscussionIn, id_user: int) -> int:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = (
                "INSERT INTO discussion (name, comments, posts, rating, id_forum, id_user) "
                "VALUES (?, ?, ?, ?, ?, ?)"
            )
            cursor.execute(sql, (
                discussion_in.name,
                discussion_in.comments,
                discussion_in.posts,
                discussion_in.rating,
                discussion_in.id_forum,
                id_user,
            ))
            conn.commit()
            return cursor.lastrowid


def update_discussion_image(discussion_id: int, image_url: str) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            cursor.execute(
                "UPDATE discussion SET image = ? WHERE id_discussion = ?",
                (image_url, discussion_id),
            )
            conn.commit()
            return cursor.rowcount > 0


def get_discussion_by_id(discussion_id: int) -> DiscussionOut | None:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            cursor.execute(
                f"{_DISCUSSION_SELECT} WHERE d.id_discussion = ? {_GROUP_BY}",
                (discussion_id,),
            )
            row = cursor.fetchone()
            return _row_to_discussion(row) if row else None


def get_all_discussions() -> list[DiscussionOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            cursor.execute(
                f"{_DISCUSSION_SELECT} {_GROUP_BY} ORDER BY d.created_at DESC"
            )
            return [_row_to_discussion(r) for r in cursor.fetchall()]


def get_discussions_by_forum(forum_id: int) -> list[DiscussionOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            cursor.execute(
                f"{_DISCUSSION_SELECT} WHERE d.id_forum = ? {_GROUP_BY} ORDER BY d.created_at DESC",
                (forum_id,),
            )
            return [_row_to_discussion(r) for r in cursor.fetchall()]


def update_discussion(discussion_id: int, discussion_in: DiscussionIn) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = (
                "UPDATE discussion SET name=?, comments=?, posts=?, rating=?, id_forum=? "
                "WHERE id_discussion=?"
            )
            cursor.execute(sql, (
                discussion_in.name,
                discussion_in.comments,
                discussion_in.posts,
                discussion_in.rating,
                discussion_in.id_forum,
                discussion_id,
            ))
            conn.commit()
            return cursor.rowcount > 0


def delete_discussion(discussion_id: int) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            cursor.execute(
                "DELETE FROM discussion WHERE id_discussion = ?", (discussion_id,)
            )
            conn.commit()
            return cursor.rowcount > 0
