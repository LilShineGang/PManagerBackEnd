-- =============================================================================
-- Glyph – esquema completo de base de datos
-- =============================================================================

-- ── Core ──────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS users (
    id       INT          AUTO_INCREMENT PRIMARY KEY,
    name     VARCHAR(100) NOT NULL,
    username VARCHAR(50)  NOT NULL UNIQUE,
    email    VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    image    VARCHAR(255),
    banner   VARCHAR(500),
    role     VARCHAR(20)  NOT NULL DEFAULT 'user',
    honor    INT          NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS games (
    id_game    INT          AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL UNIQUE,
    gender     VARCHAR(50),
    difficulty VARCHAR(50),
    rating     FLOAT,
    image      VARCHAR(255),
    category   VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS game_favorites (
    id_game INT NOT NULL,
    id_user INT NOT NULL,
    PRIMARY KEY (id_game, id_user),
    FOREIGN KEY (id_game) REFERENCES games(id_game) ON DELETE CASCADE,
    FOREIGN KEY (id_user) REFERENCES users(id)      ON DELETE CASCADE
);

-- ── Achievements ──────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS achievement (
    id_achievement INT AUTO_INCREMENT PRIMARY KEY,
    difficulty     VARCHAR(50),
    description    TEXT,
    id_game        INT,
    FOREIGN KEY (id_game) REFERENCES games(id_game) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS user_achievement (
    id_user        INT NOT NULL,
    id_achievement INT NOT NULL,
    PRIMARY KEY (id_user, id_achievement),
    FOREIGN KEY (id_user)        REFERENCES users(id)                   ON DELETE CASCADE,
    FOREIGN KEY (id_achievement) REFERENCES achievement(id_achievement) ON DELETE CASCADE
);

-- ── Forums ────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS forums (
    id_forum   INT          AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    id_game    INT,
    id_user    INT,
    forum_type VARCHAR(20)  NOT NULL DEFAULT 'community',
    FOREIGN KEY (id_game) REFERENCES games(id_game) ON DELETE SET NULL,
    FOREIGN KEY (id_user) REFERENCES users(id)      ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS discussion (
    id_discussion INT           AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(150),
    comments      TEXT          NULL,
    posts         INT           DEFAULT 0,
    rating        FLOAT         DEFAULT 0,
    image         VARCHAR(500)  NULL,
    id_forum      INT,
    id_user       INT,
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_forum) REFERENCES forums(id_forum) ON DELETE CASCADE,
    FOREIGN KEY (id_user)  REFERENCES users(id)        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS post_replies (
    id_reply        INT           AUTO_INCREMENT PRIMARY KEY,
    id_discussion   INT           NOT NULL,
    id_user         INT           NOT NULL,
    content         TEXT          NOT NULL,
    image           VARCHAR(500)  NULL,
    id_parent_reply INT           NULL,
    created_at      TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_discussion)   REFERENCES discussion(id_discussion) ON DELETE CASCADE,
    FOREIGN KEY (id_user)         REFERENCES users(id)                 ON DELETE CASCADE,
    FOREIGN KEY (id_parent_reply) REFERENCES post_replies(id_reply)   ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS post_votes (
    id_discussion INT     NOT NULL,
    id_user       INT     NOT NULL,
    vote          TINYINT NOT NULL,
    PRIMARY KEY (id_discussion, id_user),
    FOREIGN KEY (id_discussion) REFERENCES discussion(id_discussion) ON DELETE CASCADE,
    FOREIGN KEY (id_user)       REFERENCES users(id)                 ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS reply_votes (
    id_reply INT     NOT NULL,
    id_user  INT     NOT NULL,
    vote     TINYINT NOT NULL,
    PRIMARY KEY (id_reply, id_user),
    FOREIGN KEY (id_reply) REFERENCES post_replies(id_reply) ON DELETE CASCADE,
    FOREIGN KEY (id_user)  REFERENCES users(id)              ON DELETE CASCADE
);

-- ── Wiki / Guides / Builds / Tier lists ───────────────────────────────────────

CREATE TABLE IF NOT EXISTS wiki (
    id_wiki     INT          AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(150),
    category    VARCHAR(100),
    description TEXT,
    id_forum    INT,
    FOREIGN KEY (id_forum) REFERENCES forums(id_forum) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS guides (
    id_guide   INT          AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(150),
    difficulty VARCHAR(50),
    category   VARCHAR(100),
    id_user    INT,
    id_forum   INT,
    FOREIGN KEY (id_user)  REFERENCES users(id)        ON DELETE SET NULL,
    FOREIGN KEY (id_forum) REFERENCES forums(id_forum) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS tier_list (
    id_tl       INT          AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(150),
    category    VARCHAR(100),
    description TEXT,
    id_forum    INT,
    FOREIGN KEY (id_forum) REFERENCES forums(id_forum) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS builds (
    id_build    INT          AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(150),
    planner     VARCHAR(150),
    category    VARCHAR(100),
    description TEXT,
    id_forum    INT,
    FOREIGN KEY (id_forum) REFERENCES forums(id_forum) ON DELETE CASCADE
);

-- ── Groups ────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS groups_table (
    id_group    INT          AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    admin       VARCHAR(50),
    description TEXT,
    image       VARCHAR(255),
    id_forum    INT,
    FOREIGN KEY (id_forum) REFERENCES forums(id_forum) ON DELETE SET NULL
);

-- ── Legacy chat (mantenido por compatibilidad) ────────────────────────────────

CREATE TABLE IF NOT EXISTS messages_instance (
    id_mi     INT          AUTO_INCREMENT PRIMARY KEY,
    status    VARCHAR(50),
    content   TEXT,
    timestamp DATETIME     DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS chat (
    id_chat   INT  AUTO_INCREMENT PRIMARY KEY,
    id_mi     INT,
    content   TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_mi) REFERENCES messages_instance(id_mi) ON DELETE CASCADE
);

-- ── Direct chats (1-a-1) ──────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS direct_conversations (
    id_conversation INT AUTO_INCREMENT PRIMARY KEY,
    user1_id        INT NOT NULL,
    user2_id        INT NOT NULL,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user1_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (user2_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uq_conversation (user1_id, user2_id)
);

CREATE TABLE IF NOT EXISTS direct_messages (
    id_message      INT  AUTO_INCREMENT PRIMARY KEY,
    id_conversation INT  NOT NULL,
    sender_id       INT  NOT NULL,
    content         TEXT NOT NULL,
    timestamp       DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_conversation) REFERENCES direct_conversations(id_conversation) ON DELETE CASCADE,
    FOREIGN KEY (sender_id)       REFERENCES users(id)                             ON DELETE CASCADE
);

-- =============================================================================
-- ALTER TABLE para bases de datos existentes
-- =============================================================================

ALTER TABLE users
    ADD COLUMN IF NOT EXISTS banner VARCHAR(500),
    ADD COLUMN IF NOT EXISTS honor  INT NOT NULL DEFAULT 0;

ALTER TABLE forums
    ADD COLUMN IF NOT EXISTS forum_type VARCHAR(20) NOT NULL DEFAULT 'community';

ALTER TABLE discussion
    ADD COLUMN IF NOT EXISTS image      VARCHAR(500) NULL,
    ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE post_replies
    ADD COLUMN IF NOT EXISTS id_parent_reply INT NULL;
