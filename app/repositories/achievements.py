import mariadb
from app.config.config import db_config
from app.models import AchievementIn, AchievementOut


def insert_achievement(achievement_in: AchievementIn) -> int:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "INSERT INTO achievement (difficulty, description, id_game) VALUES (?, ?, ?)"
            values = (
                achievement_in.difficulty,
                achievement_in.description,
                achievement_in.id_game,
            )
            cursor.execute(sql, values)
            conn.commit()
            return cursor.lastrowid


def get_achievement_by_id(achievement_id: int) -> AchievementOut | None:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_achievement, difficulty, description, id_game FROM achievement WHERE id_achievement = ?"
            cursor.execute(sql, (achievement_id,))
            row = cursor.fetchone()
            if row:
                return AchievementOut(
                    id_achievement=row[0],
                    difficulty=row[1],
                    description=row[2],
                    id_game=row[3],
                )
            return None


def get_all_achievements() -> list[AchievementOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_achievement, difficulty, description, id_game FROM achievement"
            cursor.execute(sql)
            rows = cursor.fetchall()
            return [
                AchievementOut(
                    id_achievement=row[0],
                    difficulty=row[1],
                    description=row[2],
                    id_game=row[3],
                )
                for row in rows
            ]


def get_achievements_by_game(game_id: int) -> list[AchievementOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_achievement, difficulty, description, id_game FROM achievement WHERE id_game = ?"
            cursor.execute(sql, (game_id,))
            rows = cursor.fetchall()
            return [
                AchievementOut(
                    id_achievement=row[0],
                    difficulty=row[1],
                    description=row[2],
                    id_game=row[3],
                )
                for row in rows
            ]


def update_achievement_by_id(achievement_id: int, achievement_in: AchievementIn) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "UPDATE achievement SET difficulty = ?, description = ?, id_game = ? WHERE id_achievement = ?"
            values = (
                achievement_in.difficulty,
                achievement_in.description,
                achievement_in.id_game,
                achievement_id,
            )
            cursor.execute(sql, values)
            conn.commit()
            return cursor.rowcount > 0


def delete_achievement_by_id(achievement_id: int) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "DELETE FROM achievement WHERE id_achievement = ?"
            cursor.execute(sql, (achievement_id,))
            conn.commit()
            return cursor.rowcount > 0
