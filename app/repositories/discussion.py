import mariadb
from app.config.config import db_config
from app.models import DiscussionIn, DiscussionOut

# Subqueries avoid the Cartesian product that JOIN post_votes × post_replies would cause.
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
        COALESCE((SELECT COUNT(*) FROM post_votes  WHERE id_discussion = d.id_discussion AND vote =  1), 0) AS likes,
        COALESCE((SELECT COUNT(*) FROM post_votes  WHERE id_discussion = d.id_discussion AND vote = -1), 0) AS dislikes,
        COALESCE((SELECT COUNT(*) FROM post_replies WHERE id_discussion = d.id_discussion), 0)              AS reply_count,
        DATE_FORMAT(d.created_at, '%Y-%m-%d %H:%i') AS created_at,
        u.image                                      AS author_image
    FROM discussion d
    LEFT JOIN users u ON d.id_user = u.id
"""

_GROUP_BY = ""


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
        author_image=row[13],
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
                f"{_DISCUSSION_SELECT} WHERE d.id_discussion = ?",
                (discussion_id,),
            )
            row = cursor.fetchone()
            return _row_to_discussion(row) if row else None


def get_all_discussions() -> list[DiscussionOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            cursor.execute(
                f"{_DISCUSSION_SELECT} ORDER BY d.created_at DESC"
            )
            return [_row_to_discussion(r) for r in cursor.fetchall()]


def get_discussions_by_forum(forum_id: int) -> list[DiscussionOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            cursor.execute(
                f"{_DISCUSSION_SELECT} WHERE d.id_forum = ? ORDER BY d.created_at DESC",
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
