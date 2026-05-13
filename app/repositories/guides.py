import mariadb
from app.config.config import db_config


def get_guide_by_id(guide_id: int):
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_guide, name, difficulty, category, id_user, id_forum FROM guides WHERE id_guide = ?"
            cursor.execute(sql, (guide_id,))
            row = cursor.fetchone()
            if row:
                return {
                    "id_guide": row[0],
                    "name": row[1],
                    "difficulty": row[2],
                    "category": row[3],
                    "id_user": row[4],
                    "id_forum": row[5],
                }
            return None


def insert_guide(guide_in, id_user: int, id_forum: int) -> int | None:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "INSERT INTO guides (name, difficulty, category, id_user, id_forum) VALUES (?, ?, ?, ?, ?)"
            values = (
                guide_in.name,
                guide_in.difficulty,
                guide_in.category,
                id_user,
                id_forum,
            )
            cursor.execute(sql, values)
            conn.commit()
            return cursor.lastrowid


def delete_guide_by_id(guide_id: int) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "DELETE FROM guides WHERE id_guide = ?"
            cursor.execute(sql, (guide_id,))
            conn.commit()
            return cursor.rowcount > 0


def get_guides_by_forum(forum_id: int) -> list[dict]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_guide, name, difficulty, category, id_user, id_forum FROM guides WHERE id_forum = ?"
            cursor.execute(sql, (forum_id,))
            rows = cursor.fetchall()
            return [
                {
                    "id_guide": row[0],
                    "name": row[1],
                    "difficulty": row[2],
                    "category": row[3],
                    "id_user": row[4],
                    "id_forum": row[5],
                }
                for row in rows
            ]
