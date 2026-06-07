import mariadb
from app.config.config import db_config
from app.models import ForumIn, ForumOut


def _row_to_forum(row) -> ForumOut:
    return ForumOut(id_forum=row[0], name=row[1], id_game=row[2], id_user=row[3], forum_type=row[4] or "community")


def insert_forum(forum_in: ForumIn, id_user: int, id_game: int) -> int:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "INSERT INTO forums (name, id_game, id_user, forum_type) VALUES (?, ?, ?, ?)"
            cursor.execute(sql, (forum_in.name, id_game, id_user, forum_in.forum_type))
            conn.commit()
            return cursor.lastrowid


def get_forum_by_id(forum_id: int) -> ForumOut | None:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            cursor.execute(
                "SELECT id_forum, name, id_game, id_user, forum_type FROM forums WHERE id_forum = ?",
                (forum_id,),
            )
            row = cursor.fetchone()
            return _row_to_forum(row) if row else None


def get_forums_by_game(game_id: int) -> list[ForumOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            cursor.execute(
                "SELECT id_forum, name, id_game, id_user, forum_type FROM forums WHERE id_game = ?",
                (game_id,),
            )
            return [_row_to_forum(r) for r in cursor.fetchall()]


def get_all_forums() -> list[ForumOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT id_forum, name, id_game, id_user, forum_type FROM forums")
            return [_row_to_forum(r) for r in cursor.fetchall()]


def delete_forum_by_id(forum_id: int) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "DELETE FROM forums WHERE id_forum = ?"
            cursor.execute(sql, (forum_id,))
            conn.commit()
            return cursor.rowcount > 0
