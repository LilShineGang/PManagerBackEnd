import mariadb
from app.database.config import db_config
from app.models import MessageInstanceIn, MessageInstanceOut, ChatIn, ChatOut


# --- messages_instance ---


def insert_message_instance(message_in: MessageInstanceIn) -> int:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "INSERT INTO messages_instance (status, content) VALUES (?, ?)"
            values = (message_in.status, message_in.content)
            cursor.execute(sql, values)
            conn.commit()
            return cursor.lastrowid


def get_message_instance_by_id(mi_id: int) -> MessageInstanceOut | None:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_mi, status, content, timestamp FROM messages_instance WHERE id_mi = ?"
            cursor.execute(sql, (mi_id,))
            row = cursor.fetchone()
            if row:
                return MessageInstanceOut(
                    id_mi=row[0],
                    status=row[1],
                    content=row[2],
                    timestamp=str(row[3]) if row[3] else None,
                )
            return None


def get_all_messages_instance() -> list[MessageInstanceOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_mi, status, content, timestamp FROM messages_instance"
            cursor.execute(sql)
            rows = cursor.fetchall()
            return [
                MessageInstanceOut(
                    id_mi=row[0],
                    status=row[1],
                    content=row[2],
                    timestamp=str(row[3]) if row[3] else None,
                )
                for row in rows
            ]


def delete_message_instance(mi_id: int) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "DELETE FROM messages_instance WHERE id_mi = ?"
            cursor.execute(sql, (mi_id,))
            conn.commit()
            return cursor.rowcount > 0


# --- chat (subtable of messages_instance) ---


def insert_chat(chat_in: ChatIn) -> int:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "INSERT INTO chat (id_mi, content) VALUES (?, ?)"
            values = (chat_in.id_mi, chat_in.content)
            cursor.execute(sql, values)
            conn.commit()
            return cursor.lastrowid


def get_chat_by_id(chat_id: int) -> ChatOut | None:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_chat, id_mi, content, timestamp FROM chat WHERE id_chat = ?"
            cursor.execute(sql, (chat_id,))
            row = cursor.fetchone()
            if row:
                return ChatOut(
                    id_chat=row[0],
                    id_mi=row[1],
                    content=row[2],
                    timestamp=str(row[3]) if row[3] else None,
                )
            return None


def get_all_chats() -> list[ChatOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_chat, id_mi, content, timestamp FROM chat"
            cursor.execute(sql)
            rows = cursor.fetchall()
            return [
                ChatOut(
                    id_chat=row[0],
                    id_mi=row[1],
                    content=row[2],
                    timestamp=str(row[3]) if row[3] else None,
                )
                for row in rows
            ]


def get_chats_by_message_instance(mi_id: int) -> list[ChatOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "SELECT id_chat, id_mi, content, timestamp FROM chat WHERE id_mi = ?"
            cursor.execute(sql, (mi_id,))
            rows = cursor.fetchall()
            return [
                ChatOut(
                    id_chat=row[0],
                    id_mi=row[1],
                    content=row[2],
                    timestamp=str(row[3]) if row[3] else None,
                )
                for row in rows
            ]


def delete_chat(chat_id: int) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "DELETE FROM chat WHERE id_chat = ?"
            cursor.execute(sql, (chat_id,))
            conn.commit()
            return cursor.rowcount > 0
