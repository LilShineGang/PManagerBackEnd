import mariadb
from app.config.config import db_config
from app.models import BuildIn, BuildOut


def insert_build(build_in: BuildIn) -> int:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "INSERT INTO builds (name, planner, category, description, id_forum) VALUES (?, ?, ?, ?, ?)"
            values = (
                build_in.name,
                build_in.planner,
                build_in.category,
                build_in.description,
                build_in.id_forum,
            )
            cursor.execute(sql, values)
            conn.commit()
            return cursor.lastrowid


def get_build_by_id(build_id: int) -> BuildOut | None:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_build, name, planner, category, description, id_forum FROM builds WHERE id_build = ?"
            cursor.execute(sql, (build_id,))
            row = cursor.fetchone()
            if row:
                return BuildOut(
                    id_build=row[0],
                    name=row[1],
                    planner=row[2],
                    category=row[3],
                    description=row[4],
                    id_forum=row[5],
                )
            return None


def get_all_builds() -> list[BuildOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_build, name, planner, category, description, id_forum FROM builds"
            cursor.execute(sql)
            rows = cursor.fetchall()
            return [
                BuildOut(
                    id_build=row[0],
                    name=row[1],
                    planner=row[2],
                    category=row[3],
                    description=row[4],
                    id_forum=row[5],
                )
                for row in rows
            ]


def get_builds_by_forum(forum_id: int) -> list[BuildOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_build, name, planner, category, description, id_forum FROM builds WHERE id_forum = ?"
            cursor.execute(sql, (forum_id,))
            rows = cursor.fetchall()
            return [
                BuildOut(
                    id_build=row[0],
                    name=row[1],
                    planner=row[2],
                    category=row[3],
                    description=row[4],
                    id_forum=row[5],
                )
                for row in rows
            ]


def get_builds_by_game(game_id: int) -> list[BuildOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = (
                "SELECT b.id_build, b.name, b.planner, b.category, b.description, b.id_forum "
                "FROM builds b "
                "JOIN forums f ON b.id_forum = f.id_forum "
                "WHERE f.id_game = ?"
            )
            cursor.execute(sql, (game_id,))
            rows = cursor.fetchall()
            return [
                BuildOut(
                    id_build=row[0],
                    name=row[1],
                    planner=row[2],
                    category=row[3],
                    description=row[4],
                    id_forum=row[5],
                )
                for row in rows
            ]


def get_builds_by_planner(planner: str) -> list[BuildOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_build, name, planner, category, description, id_forum FROM builds WHERE planner = ?"
            cursor.execute(sql, (planner,))
            rows = cursor.fetchall()
            return [
                BuildOut(
                    id_build=row[0],
                    name=row[1],
                    planner=row[2],
                    category=row[3],
                    description=row[4],
                    id_forum=row[5],
                )
                for row in rows
            ]


def update_build(build_id: int, build_in: BuildIn) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "UPDATE builds SET name=?, planner=?, category=?, description=?, id_forum=? WHERE id_build=?"
            values = (
                build_in.name,
                build_in.planner,
                build_in.category,
                build_in.description,
                build_in.id_forum,
                build_id,
            )
            cursor.execute(sql, values)
            conn.commit()
            return cursor.rowcount > 0


def delete_build(build_id: int) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "DELETE FROM builds WHERE id_build = ?"
            cursor.execute(sql, (build_id,))
            conn.commit()
            return cursor.rowcount > 0
