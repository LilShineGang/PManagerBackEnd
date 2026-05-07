import mariadb
from app.database.config import db_config
from app.models import GroupIn, GroupOut


def insert_group(group_in: GroupIn, admin_id: int) -> int:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = (
                "INSERT INTO groups_table (name, admin, description, image, id_forum) "
                "VALUES (?, ?, ?, ?, ?)"
            )
            values = (
                group_in.name,
                admin_id,
                group_in.description,
                group_in.image,
                group_in.id_forum,
            )
            cursor.execute(sql, values)
            conn.commit()
            return cursor.lastrowid


def get_group_by_id(group_id: int) -> GroupOut | None:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = (
                "SELECT id_group, name, admin, description, image, id_forum "
                "FROM groups_table WHERE id_group = ?"
            )
            cursor.execute(sql, (group_id,))
            row = cursor.fetchone()
            if row:
                return GroupOut(
                    id_group=row[0],
                    name=row[1],
                    admin=row[2],
                    description=row[3],
                    image=row[4],
                    id_forum=row[5],
                )
            return None


def get_all_groups() -> list[GroupOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_group, name, admin, description, image, id_forum FROM groups_table"
            cursor.execute(sql)
            rows = cursor.fetchall()
            return [
                GroupOut(
                    id_group=row[0],
                    name=row[1],
                    admin=row[2],
                    description=row[3],
                    image=row[4],
                    id_forum=row[5],
                )
                for row in rows
            ]


def get_groups_by_forum(forum_id: int) -> list[GroupOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = (
                "SELECT id_group, name, admin, description, image, id_forum "
                "FROM groups_table WHERE id_forum = ?"
            )
            cursor.execute(sql, (forum_id,))
            rows = cursor.fetchall()
            return [
                GroupOut(
                    id_group=row[0],
                    name=row[1],
                    admin=row[2],
                    description=row[3],
                    image=row[4],
                    id_forum=row[5],
                )
                for row in rows
            ]


def update_group_by_id(group_id: int, group_in: GroupIn) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = (
                "UPDATE groups_table SET name = ?, description = ?, image = ?, id_forum = ? "
                "WHERE id_group = ?"
            )
            values = (
                group_in.name,
                group_in.description,
                group_in.image,
                group_in.id_forum,
                group_id,
            )
            cursor.execute(sql, values)
            conn.commit()
            return cursor.rowcount > 0


def delete_group_by_id(group_id: int) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "DELETE FROM groups_table WHERE id_group = ?"
            cursor.execute(sql, (group_id,))
            conn.commit()
            return cursor.rowcount > 0
