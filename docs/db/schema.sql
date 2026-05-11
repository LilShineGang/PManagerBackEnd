-- Users
CREATE TABLE IF NOT EXISTS users (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    email       VARCHAR(150) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    image       VARCHAR(255),
    role        VARCHAR(20)  NOT NULL DEFAULT 'user'
);

-- Games
CREATE TABLE IF NOT EXISTS games (
    id_game     INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    gender      VARCHAR(50),
    difficulty  VARCHAR(50),
    rating      FLOAT,
    image       VARCHAR(255),
    category    VARCHAR(100)
);

-- Achievements
CREATE TABLE IF NOT EXISTS achievement (
    id_achievement INT AUTO_INCREMENT PRIMARY KEY,
    difficulty     VARCHAR(50),
    description    TEXT,
    id_game        INT,
    FOREIGN KEY (id_game) REFERENCES games(id_game) ON DELETE SET NULL
);

-- User <-> Achievement junction
CREATE TABLE IF NOT EXISTS user_achievement (
    id_user        INT NOT NULL,
    id_achievement INT NOT NULL,
    PRIMARY KEY (id_user, id_achievement),
    FOREIGN KEY (id_user)        REFERENCES users(id)            ON DELETE CASCADE,
    FOREIGN KEY (id_achievement) REFERENCES achievement(id_achievement) ON DELETE CASCADE
);

-- Forums
CREATE TABLE IF NOT EXISTS forums (
    id_forum INT AUTO_INCREMENT PRIMARY KEY,
    name     VARCHAR(100) NOT NULL,
    id_game  INT,
    id_user  INT,
    FOREIGN KEY (id_game) REFERENCES games(id_game)   ON DELETE SET NULL,
    FOREIGN KEY (id_user) REFERENCES users(id)        ON DELETE SET NULL
);

-- Discussions
CREATE TABLE IF NOT EXISTS discussion (
    id_discussion INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(150),
    comments      INT DEFAULT 0,
    posts         INT DEFAULT 0,
    rating        FLOAT DEFAULT 0,
    id_forum      INT,
    id_user       INT,
    FOREIGN KEY (id_forum) REFERENCES forums(id_forum) ON DELETE CASCADE,
    FOREIGN KEY (id_user)  REFERENCES users(id)        ON DELETE SET NULL
);

-- Wiki
CREATE TABLE IF NOT EXISTS wiki (
    id_wiki      INT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(150),
    category     VARCHAR(100),
    description  TEXT,
    id_forum     INT,
    FOREIGN KEY (id_forum) REFERENCES forums(id_forum) ON DELETE CASCADE
);

-- Guides
CREATE TABLE IF NOT EXISTS guides (
    id_guide   INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(150),
    difficulty VARCHAR(50),
    category   VARCHAR(100),
    id_user    INT,
    id_forum   INT,
    FOREIGN KEY (id_user)  REFERENCES users(id)        ON DELETE SET NULL,
    FOREIGN KEY (id_forum) REFERENCES forums(id_forum) ON DELETE CASCADE
);

-- Tier Lists
CREATE TABLE IF NOT EXISTS tier_list (
    id_tl        INT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(150),
    category     VARCHAR(100),
    description  TEXT,
    id_forum     INT,
    FOREIGN KEY (id_forum) REFERENCES forums(id_forum) ON DELETE CASCADE
);

-- Builds
CREATE TABLE IF NOT EXISTS builds (
    id_build    INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(150),
    planner     VARCHAR(150),
    category    VARCHAR(100),
    description TEXT,
    id_forum    INT,
    FOREIGN KEY (id_forum) REFERENCES forums(id_forum) ON DELETE CASCADE
);

-- Groups
CREATE TABLE IF NOT EXISTS groups_table (
    id_group    INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    admin       VARCHAR(50),
    description TEXT,
    image       VARCHAR(255),
    id_forum    INT,
    FOREIGN KEY (id_forum) REFERENCES forums(id_forum) ON DELETE SET NULL
);

-- User <-> Group junction
CREATE TABLE IF NOT EXISTS user_group (
    id_user  INT NOT NULL,
    id_group INT NOT NULL,
    PRIMARY KEY (id_user, id_group),
    FOREIGN KEY (id_user)  REFERENCES users(id)              ON DELETE CASCADE,
    FOREIGN KEY (id_group) REFERENCES groups_table(id_group) ON DELETE CASCADE
);

-- Message Instances
CREATE TABLE IF NOT EXISTS messages_instance (
    id_mi     INT AUTO_INCREMENT PRIMARY KEY,
    status    VARCHAR(50),
    content   TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Chats
CREATE TABLE IF NOT EXISTS chat (
    id_chat   INT AUTO_INCREMENT PRIMARY KEY,
    id_mi     INT,
    content   TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_mi) REFERENCES messages_instance(id_mi) ON DELETE CASCADE
);
