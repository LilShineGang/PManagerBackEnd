import mariadb
from app.config.config import db_config


def upsert_vote(discussion_id: int, user_id: int, vote: int) -> tuple[int, int]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            cursor.execute(
                "SELECT vote FROM post_votes WHERE id_discussion = ? AND id_user = ?",
                (discussion_id, user_id),
            )
            row = cursor.fetchone()
            old_vote: int = row[0] if row else 0

            if old_vote == vote:
                cursor.execute(
                    "DELETE FROM post_votes WHERE id_discussion = ? AND id_user = ?",
                    (discussion_id, user_id),
                )
                conn.commit()
                return old_vote, 0

            cursor.execute(
                """INSERT INTO post_votes (id_discussion, id_user, vote) VALUES (?, ?, ?)
                   ON DUPLICATE KEY UPDATE vote = ?""",
                (discussion_id, user_id, vote, vote),
            )
            conn.commit()
            return old_vote, vote


def get_my_vote(discussion_id: int, user_id: int) -> int:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            cursor.execute(
                "SELECT vote FROM post_votes WHERE id_discussion = ? AND id_user = ?",
                (discussion_id, user_id),
            )
            row = cursor.fetchone()
            return int(row[0]) if row else 0


def get_vote_counts(discussion_id: int) -> tuple[int, int]:
    with mariadb.connect(**db_config) as conn:
        with conn.cursor() as cursor:
            cursor.execute(
                """SELECT
                       COALESCE(SUM(CASE WHEN vote =  1 THEN 1 ELSE 0 END), 0),
                       COALESCE(SUM(CASE WHEN vote = -1 THEN 1 ELSE 0 END), 0)
                   FROM post_votes WHERE id_discussion = ?""",
                (discussion_id,),
            )
            row = cursor.fetchone()
            return (int(row[0]), int(row[1]))
