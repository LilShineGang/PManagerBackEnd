-- Forum module migration
-- Run once against the MariaDB database before starting the backend.

ALTER TABLE discussion
    ADD COLUMN IF NOT EXISTS image      VARCHAR(500) NULL,
    ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE users
    ADD COLUMN IF NOT EXISTS honor INT NOT NULL DEFAULT 0;

CREATE TABLE IF NOT EXISTS post_replies (
    id_reply      INT AUTO_INCREMENT PRIMARY KEY,
    id_discussion INT  NOT NULL,
    id_user       INT  NOT NULL,
    content       TEXT NOT NULL,
    image         VARCHAR(500) NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_discussion) REFERENCES discussion(id_discussion) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS post_votes (
    id_discussion INT NOT NULL,
    id_user       INT NOT NULL,
    vote          TINYINT NOT NULL,          -- 1 = like, -1 = dislike
    PRIMARY KEY (id_discussion, id_user),
    FOREIGN KEY (id_discussion) REFERENCES discussion(id_discussion) ON DELETE CASCADE
);
