import mariadb
from app.config.config import db_config
from app.models import DiscussionIn, DiscussionOut


def insert_discussion(discussion_in: DiscussionIn, id_user: int) -> int:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = (
                "INSERT INTO discussion (name, comments, posts, rating, id_forum, id_user) "
                "VALUES (?, ?, ?, ?, ?, ?)"
            )
            values = (
                discussion_in.name,
                discussion_in.comments,
                discussion_in.posts,
                discussion_in.rating,
                discussion_in.id_forum,
                id_user,
            )
            cursor.execute(sql, values)
            conn.commit()
            return cursor.lastrowid


def get_discussion_by_id(discussion_id: int) -> DiscussionOut | None:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = (
                "SELECT id_discussion, name, comments, posts, rating, id_forum, id_user "
                "FROM discussion WHERE id_discussion = ?"
            )
            cursor.execute(sql, (discussion_id,))
            row = cursor.fetchone()
            if row:
                return DiscussionOut(
                    id_discussion=row[0],
                    name=row[1],
                    comments=row[2],
                    posts=row[3],
                    rating=row[4],
                    id_forum=row[5],
                    id_user=row[6],
                )
            return None


def get_all_discussions() -> list[DiscussionOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = (
                "SELECT id_discussion, name, comments, posts, rating, id_forum, id_user "
                "FROM discussion"
            )
            cursor.execute(sql)
            rows = cursor.fetchall()
            return [
                DiscussionOut(
                    id_discussion=row[0],
                    name=row[1],
                    comments=row[2],
                    posts=row[3],
                    rating=row[4],
                    id_forum=row[5],
                    id_user=row[6],
                )
                for row in rows
            ]


def get_discussions_by_forum(forum_id: int) -> list[DiscussionOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = (
                "SELECT id_discussion, name, comments, posts, rating, id_forum, id_user "
                "FROM discussion WHERE id_forum = ?"
            )
            cursor.execute(sql, (forum_id,))
            rows = cursor.fetchall()
            return [
                DiscussionOut(
                    id_discussion=row[0],
                    name=row[1],
                    comments=row[2],
                    posts=row[3],
                    rating=row[4],
                    id_forum=row[5],
                    id_user=row[6],
                )
                for row in rows
            ]


def update_discussion(discussion_id: int, discussion_in: DiscussionIn) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = (
                "UPDATE discussion SET name=?, comments=?, posts=?, rating=?, id_forum=? "
                "WHERE id_discussion=?"
            )
            values = (
                discussion_in.name,
                discussion_in.comments,
                discussion_in.posts,
                discussion_in.rating,
                discussion_in.id_forum,
                discussion_id,
            )
            cursor.execute(sql, values)
            conn.commit()
            return cursor.rowcount > 0


def delete_discussion(discussion_id: int) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "DELETE FROM discussion WHERE id_discussion = ?"
            cursor.execute(sql, (discussion_id,))
            conn.commit()
            return cursor.rowcount > 0
