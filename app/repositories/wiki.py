import mariadb
from app.config.config import db_config
from app.models import WikiIn, WikiOut


def insert_wiki(wiki_in: WikiIn) -> int:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "INSERT INTO wiki (name, category, description, id_forum) VALUES (?, ?, ?, ?)"
            values = (wiki_in.name, wiki_in.category, wiki_in.description, wiki_in.id_forum)
            cursor.execute(sql, values)
            conn.commit()
            return cursor.lastrowid


def get_wiki_by_id(wiki_id: int) -> WikiOut | None:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_wiki, name, category, description, id_forum FROM wiki WHERE id_wiki = ?"
            cursor.execute(sql, (wiki_id,))
            row = cursor.fetchone()
            if row:
                return WikiOut(
                    id_wiki=row[0],
                    name=row[1],
                    category=row[2],
                    description=row[3],
                    id_forum=row[4],
                )
            return None


def get_all_wiki() -> list[WikiOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_wiki, name, category, description, id_forum FROM wiki"
            cursor.execute(sql)
            rows = cursor.fetchall()
            return [
                WikiOut(
                    id_wiki=row[0],
                    name=row[1],
                    category=row[2],
                    description=row[3],
                    id_forum=row[4],
                )
                for row in rows
            ]


def get_wikis_by_forum(forum_id: int) -> list[WikiOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_wiki, name, category, description, id_forum FROM wiki WHERE id_forum = ?"
            cursor.execute(sql, (forum_id,))
            rows = cursor.fetchall()
            return [
                WikiOut(
                    id_wiki=row[0],
                    name=row[1],
                    category=row[2],
                    description=row[3],
                    id_forum=row[4],
                )
                for row in rows
            ]


def update_wiki_by_id(wiki_id: int, wiki_in: WikiIn) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "UPDATE wiki SET name=?, category=?, description=?, id_forum=? WHERE id_wiki=?"
            values = (wiki_in.name, wiki_in.category, wiki_in.description, wiki_in.id_forum, wiki_id)
            cursor.execute(sql, values)
            conn.commit()
            return cursor.rowcount > 0


def get_wikis_by_game(game_id: int) -> list[WikiOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = (
                "SELECT w.id_wiki, w.name, w.category, w.description, w.id_forum "
                "FROM wiki w "
                "JOIN forums f ON w.id_forum = f.id_forum "
                "WHERE f.id_game = ?"
            )
            cursor.execute(sql, (game_id,))
            rows = cursor.fetchall()
            return [
                WikiOut(
                    id_wiki=row[0],
                    name=row[1],
                    category=row[2],
                    description=row[3],
                    id_forum=row[4],
                )
                for row in rows
            ]


def delete_wiki_by_id(wiki_id: int) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "DELETE FROM wiki WHERE id_wiki = ?"
            cursor.execute(sql, (wiki_id,))
            conn.commit()
            return cursor.rowcount > 0
