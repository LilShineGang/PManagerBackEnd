import mariadb
from app.config.config import db_config
from app.models import ForumIn, ForumOut


def insert_forum(forum_in: ForumIn, id_user: int, id_game: int) -> int:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "INSERT INTO forums (name, id_game, id_user) VALUES (?, ?, ?)"
            values = (forum_in.name, id_game, id_user)
            cursor.execute(sql, values)
            conn.commit()
            return cursor.lastrowid


def get_forum_by_id(forum_id: int) -> ForumOut | None:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_forum, name, id_game, id_user FROM forums WHERE id_forum = ?"
            cursor.execute(sql, (forum_id,))
            row = cursor.fetchone()
            if row:
                return ForumOut(id_forum=row[0], name=row[1], id_game=row[2], id_user=row[3])
            return None


def get_forums_by_game(game_id: int) -> list[ForumOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_forum, name, id_game, id_user FROM forums WHERE id_game = ?"
            cursor.execute(sql, (game_id,))
            rows = cursor.fetchall()
            return [ForumOut(id_forum=row[0], name=row[1], id_game=row[2], id_user=row[3]) for row in rows]


def get_all_forums() -> list[ForumOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_forum, name, id_game, id_user FROM forums"
            cursor.execute(sql)
            rows = cursor.fetchall()
            return [ForumOut(id_forum=row[0], name=row[1], id_game=row[2], id_user=row[3]) for row in rows]


def delete_forum_by_id(forum_id: int) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "DELETE FROM forums WHERE id_forum = ?"
            cursor.execute(sql, (forum_id,))
            conn.commit()
            return cursor.rowcount > 0
