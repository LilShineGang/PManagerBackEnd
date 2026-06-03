-- Migration v2: forum types + nested replies
-- Run once against the MariaDB database.

ALTER TABLE forums
    ADD COLUMN IF NOT EXISTS forum_type VARCHAR(20) NOT NULL DEFAULT 'community';

ALTER TABLE post_replies
    ADD COLUMN IF NOT EXISTS id_parent_reply INT NULL,
    ADD CONSTRAINT fk_parent_reply
        FOREIGN KEY IF NOT EXISTS (id_parent_reply) REFERENCES post_replies(id_reply) ON DELETE SET NULL;
