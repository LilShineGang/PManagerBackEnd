import re
import mariadb
from app.config.config import db_config
from app.models import GameDb, GameIn

_VALID_COLUMN = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
_ALLOWED_GAME_COLUMNS = {"name", "gender", "difficulty", "rating", "image", "category"}


def insert_game(game: GameIn) -> int | None:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "insert into games (name, gender, difficulty, rating, image, category) values (?, ?, ?, ?, ?, ?)"
            values = (
                game.name,
                game.gender,
                game.difficulty,
                game.rating,
                game.image,
                game.category,
            )
            cursor.execute(sql, values)
            conn.commit()
            return cursor.lastrowid


def get_game_by_name(name: str) -> GameDb | None:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "select id_game, name, gender, difficulty, rating, image, category from games where name = ?"
            cursor.execute(sql, (name,))
            row = cursor.fetchone()
            if row:
                return GameDb(
                    id_game=row[0],
                    name=row[1],
                    gender=row[2],
                    difficulty=row[3],
                    rating=row[4],
                    image=row[5],
                    category=row[6],
                )
            return None


def get_game_by_id(game_id: int) -> GameDb | None:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "select id_game, name, gender, difficulty, rating, image, category from games where id_game = ?"
            cursor.execute(sql, (game_id,))
            row = cursor.fetchone()
            if row:
                return GameDb(
                    id_game=row[0],
                    name=row[1],
                    gender=row[2],
                    difficulty=row[3],
                    rating=row[4],
                    image=row[5],
                    category=row[6],
                )
            return None


def get_all_game() -> list[GameDb]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "select id_game, name, gender, difficulty, rating, image, category from games"
            cursor.execute(sql)
            rows = cursor.fetchall()
            return [
                GameDb(
                    id_game=row[0],
                    name=row[1],
                    gender=row[2],
                    difficulty=row[3],
                    rating=row[4],
                    image=row[5],
                    category=row[6],
                )
                for row in rows
            ]


def update_game_by_id(game_id: int, game_in: GameIn) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "UPDATE games SET name=?, gender=?, difficulty=?, rating=?, image=?, category=? WHERE id_game=?"
            values = (
                game_in.name,
                game_in.gender,
                game_in.difficulty,
                game_in.rating,
                game_in.image,
                game_in.category,
                game_id,
            )
            cursor.execute(sql, values)
            conn.commit()
            return cursor.rowcount > 0


def update_game_fields_by_id(game_id: int, fields: dict) -> bool:
    if not fields:
        return False
    for col in fields:
        if not _VALID_COLUMN.match(col) or col not in _ALLOWED_GAME_COLUMNS:
            raise ValueError(f"Invalid column name: {col!r}")
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            set_clause = ", ".join(f"{col}=?" for col in fields)
            values = list(fields.values()) + [game_id]
            cursor.execute(f"UPDATE games SET {set_clause} WHERE id_game=?", values)
            conn.commit()
            return cursor.rowcount > 0


def delete_game_by_id(game_id: int) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "DELETE FROM games WHERE id_game=?"
            cursor.execute(sql, (game_id,))
            conn.commit()
            return cursor.rowcount > 0
