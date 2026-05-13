import mariadb
from app.config.config import db_config
from app.models import TierListIn, TierListOut


def insert_tier_list(tier_list_in: TierListIn) -> int:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "INSERT INTO tier_list (name, category, description, id_forum) VALUES (?, ?, ?, ?)"
            values = (
                tier_list_in.name,
                tier_list_in.category,
                tier_list_in.description,
                tier_list_in.id_forum,
            )
            cursor.execute(sql, values)
            conn.commit()
            return cursor.lastrowid


def get_tier_list_by_id(tier_list_id: int) -> TierListOut | None:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_tl, name, category, description, id_forum FROM tier_list WHERE id_tl = ?"
            cursor.execute(sql, (tier_list_id,))
            row = cursor.fetchone()
            if row:
                return TierListOut(
                    id_tl=row[0],
                    name=row[1],
                    category=row[2],
                    description=row[3],
                    id_forum=row[4],
                )
            return None


def get_all_tier_list() -> list[TierListOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_tl, name, category, description, id_forum FROM tier_list"
            cursor.execute(sql)
            rows = cursor.fetchall()
            return [
                TierListOut(
                    id_tl=row[0],
                    name=row[1],
                    category=row[2],
                    description=row[3],
                    id_forum=row[4],
                )
                for row in rows
            ]


def get_tier_lists_by_forum(forum_id: int) -> list[TierListOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_tl, name, category, description, id_forum FROM tier_list WHERE id_forum = ?"
            cursor.execute(sql, (forum_id,))
            rows = cursor.fetchall()
            return [
                TierListOut(
                    id_tl=row[0],
                    name=row[1],
                    category=row[2],
                    description=row[3],
                    id_forum=row[4],
                )
                for row in rows
            ]


def update_tier_list_by_id(tier_list_id: int, tier_list_in: TierListIn) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "UPDATE tier_list SET name = ?, category = ?, description = ?, id_forum = ? WHERE id_tl = ?"
            values = (
                tier_list_in.name,
                tier_list_in.category,
                tier_list_in.description,
                tier_list_in.id_forum,
                tier_list_id,
            )
            cursor.execute(sql, values)
            conn.commit()
            return cursor.rowcount > 0


def delete_tier_list_by_id(tier_list_id: int) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "DELETE FROM tier_list WHERE id_tl = ?"
            cursor.execute(sql, (tier_list_id,))
            conn.commit()
            return cursor.rowcount > 0
