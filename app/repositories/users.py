import mariadb
from app.config.config import db_config
from app.models.models import UserDb, AchievementOut
from app.auth.auth import get_hash_password
from typing import Optional, List


class MariaDBUserRepository(UserRepository):
    def __init__(self):
        self.db_config = db_config
    
    def _get_connection(self):
        return mariadb.connect(**self.db_config)
    
    def save(self, entity: User) -> User:
        with self._get_connection() as conn:
            with conn.cursor() as cursor:
                sql = "INSERT INTO users (name, username, email, password, image, role) VALUES (?, ?, ?, ?, ?, ?)"
                values = (
                    entity.name,
                    entity.username,
                    entity.email.value,
                    entity.password.value,
                    entity.image,
                    entity.role,
                )
                cursor.execute(sql, values)
                conn.commit()
                entity.id = cursor.lastrowid
                return entity
    
    def get_by_id(self, entity_id: int) -> Optional[User]:
        with self._get_connection() as conn:
            with conn.cursor() as cursor:
                sql = "SELECT id, name, username, email, password, image, role FROM users WHERE id = ?"
                cursor.execute(sql, (entity_id,))
                row = cursor.fetchone()
                if row:
                    return User(
                        id=row[0],
                        name=row[1],
                        username=row[2],
                        email=Email(row[3]),
                        password=Password(row[4]),
                        image=row[5],
                        role=row[6],
                    )
                return None
    
    def get_by_username(self, username: str) -> Optional[User]:
        with self._get_connection() as conn:
            with conn.cursor() as cursor:
                sql = "SELECT id, name, username, email, password, image, role FROM users WHERE username = ?"
                cursor.execute(sql, (username,))
                row = cursor.fetchone()
                if row:
                    return User(
                        id=row[0],
                        name=row[1],
                        username=row[2],
                        email=Email(row[3]),
                        password=Password(row[4]),
                        image=row[5],
                        role=row[6],
                    )
                return None
    
    def get_all(self) -> List[User]:
        with self._get_connection() as conn:
            with conn.cursor() as cursor:
                sql = "SELECT id, name, username, email, password, image, role FROM users"
                cursor.execute(sql)
                rows = cursor.fetchall()
                return [
                    User(
                        id=row[0],
                        name=row[1],
                        username=row[2],
                        email=Email(row[3]),
                        password=Password(row[4]),
                        image=row[5],
                        role=row[6],
                    )
                    for row in rows
                ]
    
    def delete(self, entity_id: int) -> bool:
        with self._get_connection() as conn:
            with conn.cursor() as cursor:
                sql = "DELETE FROM users WHERE id = ?"
                cursor.execute(sql, (entity_id,))
                conn.commit()
                return cursor.rowcount > 0
    
    def update(self, entity: User) -> User:
        with self._get_connection() as conn:
            with conn.cursor() as cursor:
                sql = """
                UPDATE users 
                SET name = ?, username = ?, email = ?, password = ?, image = ?, role = ?
                WHERE id = ?
                """
                values = (
                    entity.name,
                    entity.username,
                    entity.email.value,
                    entity.password.value,
                    entity.image,
                    entity.role,
                    entity.id
                )
                cursor.execute(sql, values)
                conn.commit()
                return entity
    
    def get_by_group(self, user_id: int, group_id: int) -> bool:
        with self._get_connection() as conn:
            with conn.cursor() as cursor:
                sql = "SELECT COUNT(*) FROM user_group WHERE id_user = ? AND id_group = ?"
                cursor.execute(sql, (user_id, group_id))
                result = cursor.fetchone()
                return result[0] > 0 if result else False
    
    def remove_from_group(self, user_id: int, group_id: int) -> bool:
        with self._get_connection() as conn:
            with conn.cursor() as cursor:
                sql = "DELETE FROM user_group WHERE id_user = ? AND id_group = ?"
                cursor.execute(sql, (user_id, group_id))
                conn.commit()
                return cursor.rowcount > 0


# Mantener las funciones existentes para compatibilidad con el código antiguo
users: list[UserDb] = [
    UserDb(
        id=1,
        name="dan",
        username="dan",
        email="dan@example.com",
        password=get_hash_password("dan"),
        image=None,
        role="admin",
    ),
    UserDb(
        id=2,
        name="pm",
        username="pm",
        email="pm@example.com",
        password=get_hash_password("pm"),
        image=None,
        role="user",
    ),
]


def insert_user(user: UserDb) -> int | None:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "insert into users (name, username, email, password, image, role) values (?, ?, ?, ?, ?, ?)"
            values = (
                user.name,
                user.username,
                user.email,
                user.password,
                user.image,
                user.role,
            )
            cursor.execute(sql, values)
            conn.commit()
            return cursor.lastrowid


def get_user_by_username(username: str) -> UserDb | None:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "select id, name, username, email, password, image, role from users where username = ?"
            cursor.execute(sql, (username,))
            row = cursor.fetchone()
            if row:
                return UserDb(
                    id=row[0],
                    name=row[1],
                    username=row[2],
                    email=row[3],
                    password=row[4],
                    image=row[5],
                    role=row[6],
                )
            return None


def get_all_users() -> list[UserDb]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "select id, name, username, email, password, image, role from users"
            cursor.execute(sql)
            rows = cursor.fetchall()
            return [
                UserDb(
                    id=row[0],
                    name=row[1],
                    username=row[2],
                    email=row[3],
                    password=row[4],
                    image=row[5],
                    role=row[6],
                )
                for row in rows
            ]


def delete_user_by_username(username: str) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "delete from users where username = ?"
            cursor.execute(sql, (username,))
            conn.commit()
            return cursor.rowcount > 0


def update_user_by_username(username: str, fields: dict) -> bool:
    if not fields:
        return False
    set_clause = ", ".join(f"{k} = ?" for k in fields)
    values = list(fields.values()) + [username]
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = f"UPDATE users SET {set_clause} WHERE username = ?"
            cursor.execute(sql, values)
            conn.commit()
            return cursor.rowcount > 0


# --- user_group (membership) ---


def add_user_to_group(user_id: int, group_id: int) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "INSERT IGNORE INTO user_group (id_user, id_group) VALUES (?, ?)"
            cursor.execute(sql, (user_id, group_id))
            conn.commit()
            return cursor.rowcount > 0


def remove_user_from_group(user_id: int, group_id: int) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "DELETE FROM user_group WHERE id_user = ? AND id_group = ?"
            cursor.execute(sql, (user_id, group_id))
            conn.commit()
            return cursor.rowcount > 0


def get_group_members(group_id: int) -> list[UserDb]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = (
                "SELECT u.id, u.name, u.username, u.email, u.password, u.image, u.role "
                "FROM users u "
                "JOIN user_group ug ON u.id = ug.id_user "
                "WHERE ug.id_group = ?"
            )
            cursor.execute(sql, (group_id,))
            rows = cursor.fetchall()
            return [
                UserDb(
                    id=row[0],
                    name=row[1],
                    username=row[2],
                    email=row[3],
                    password=row[4],
                    image=row[5],
                    role=row[6],
                )
                for row in rows
            ]


# --- user_achievement ---


def add_user_achievement(user_id: int, achievement_id: int) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "INSERT IGNORE INTO user_achievement (id_user, id_achievement) VALUES (?, ?)"
            cursor.execute(sql, (user_id, achievement_id))
            conn.commit()
            return cursor.rowcount > 0


def remove_user_achievement(user_id: int, achievement_id: int) -> bool:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = "DELETE FROM user_achievement WHERE id_user = ? AND id_achievement = ?"
            cursor.execute(sql, (user_id, achievement_id))
            conn.commit()
            return cursor.rowcount > 0


def get_user_achievements(user_id: int) -> list[AchievementOut]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            sql = (
                "SELECT a.id_achievement, a.difficulty, a.description, a.id_game "
                "FROM achievement a "
                "JOIN user_achievement ua ON a.id_achievement = ua.id_achievement "
                "WHERE ua.id_user = ?"
            )
            cursor.execute(sql, (user_id,))
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
