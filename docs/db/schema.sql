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

-- User <-> Group junction# Historial de cambios del proyecto

## Backend — PManagerBackEnd

| Hash | Commit | Descripción |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Registra todas las imágenes subidas por los usuarios en la carpeta estática. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Crea la tabla `game_favorites` y añade los endpoints `GET /games/favorites/`, `POST /games/{id}/favorite/` y `DELETE /games/{id}/favorite/`. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Elimina el error 400 que se lanzaba cuando un `UPDATE` no afectaba ninguna fila porque los datos ya eran idénticos. |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restringe la creación de juegos al rol admin; añade el endpoint de logros; corrige respuestas de wiki y builds. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Elimina importaciones circulares causadas por referencias a clases de dominio que ya no existían. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Añade la lista blanca `_ALLOWED_GAME_COLUMNS` para proteger consultas UPDATE dinámicas; añade el etiquetador automático de PRs. |
| `4953077` | Merge master and resolve PR conflicts | Merge de integración resolviendo conflictos entre ramas. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Añade `POST /users/me/image/`, `POST /users/me/banner/` y `POST /games/{id}/image/`; sirve archivos estáticos desde FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Corrige importaciones de routers rotas y el `import re` que faltaba y que impedía arrancar el servidor. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrige el nombre del campo mal escrito en modelos, base de datos y endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Divide el `database.py` monolítico en un paquete con un archivo por dominio (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restaura funciones de repositorio y endpoints perdidos durante un merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Añade endpoints CRUD y funciones de base de datos para foros, listas tier y logros. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implementa los archivos de endpoints para chat, builds, discusiones y mensajes. |
| `511b343` | Finishing guides | Completa los endpoints de guías y sus funciones de repositorio. |
| `0fe1b2b` | Forums and Wiki endpoints | Añade los primeros endpoints REST de foros y wiki. |
| `84b8fee` | Finish the Game endpoints | Completa el CRUD de juegos con búsqueda y listado. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migra las rutas de usuario de stubs en memoria a consultas reales en MariaDB. |
| `35c4d29` | Implement CRUD functions and improve authentication | Añade el repositorio CRUD completo de usuarios y refuerza la lógica JWT. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extiende el modelo de usuario con `email` e `image`; actualiza `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduce los modelos Pydantic, la configuración de conexión a la BD y reestructura la autenticación. |
| `3839a1c` | Adding auth | Añade la generación de tokens JWT y el flujo OAuth2 con contraseña. |
| `f062496` | Added content to main and users router | Conecta el punto de entrada de FastAPI y las primeras rutas de usuario. |
| `32d4b6c` | Database tables | Definición inicial de tablas en `schema.sql`. |
| `06076e7` | First commit: project base created | Estructura vacía del proyecto FastAPI. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Descripción |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Añade la pestaña Juegos en la barra de navegación; la página de inicio muestra solo favoritos; botones de corazón y papelera en cada tarjeta de juego. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Añade los flujos `likedGameIds`/`juegosLiked`, `toggleLike` con actualización optimista y `eliminarJuego` con limpieza local de listas. |
| `15c717b` | Fix Android image upload filename extension and network security config | Deduce la extensión del archivo a partir del tipo MIME cuando falta; añade hosts con tráfico en claro a `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restaura `NavigationRail`/`NavigationBar` y el layout `BoxWithConstraints` perdidos al resolver un conflicto de merge. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Conserva la interfaz completa de edición de perfil (avatar + banner) tras un merge con conflictos. |
| `a0f91bb` | feat: add banner field to persist profile background | Añade el campo `banner` a `UserOut`; lo envía al actualizar el perfil y lo muestra como fondo en la pantalla de perfil. |
| `54fcae8` | feat: adapt frontend to backend API | Alinea modelos, formulario de login, gestión de sesión JWT y navegación con la API FastAPI. |
| `4310368` | Login view | Implementa la pantalla de inicio de sesión con validación de formulario. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Añade dependencias de Ktor + kotlinx-serialization y configura Gradle para KMP. |
| `1793fa4` | Login first contact | Primer borrador del composable de pantalla de login. |
| `c63bdfa` | First version uploaded | Estructura inicial del proyecto Compose Multiplatform. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
# Project Changelog

## Backend — PManagerBackEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Tracks all image files uploaded by users to the static folder. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Creates `game_favorites` table and adds `GET /games/favorites/`, `POST /games/{id}/favorite/`, `DELETE /games/{id}/favorite/` endpoints. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Removes the 400 error raised when `UPDATE` affects 0 rows (data was already identical). |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restricts game creation to admin role; adds achievements endpoint; fixes wiki and builds responses. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Eliminates circular import errors caused by leftover domain class references. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Adds `_ALLOWED_GAME_COLUMNS` guard on dynamic UPDATE queries; adds GitHub Actions PR labeler. |
| `4953077` | Merge master and resolve PR conflicts | Integration merge resolving conflicts between branches. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Adds `POST /users/me/image/`, `POST /users/me/banner/`, and `POST /games/{id}/image/`; serves static files via FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Fixes broken router imports and missing `re` import that prevented the server from starting. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrects field name typo across models, DB and endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Breaks the single `database.py` into a package with one file per domain (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restores missing repository functions and endpoints lost during a merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
# Project Changelog

## Backend — PManagerBackEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Tracks all image files uploaded by users to the static folder. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Creates `game_favorites` table and adds `GET /games/favorites/`, `POST /games/{id}/favorite/`, `DELETE /games/{id}/favorite/` endpoints. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Removes the 400 error raised when `UPDATE` affects 0 rows (data was already identical). |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restricts game creation to admin role; adds achievements endpoint; fixes wiki and builds responses. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Eliminates circular import errors caused by leftover domain class references. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Adds `_ALLOWED_GAME_COLUMNS` guard on dynamic UPDATE queries; adds GitHub Actions PR labeler. |
| `4953077` | Merge master and resolve PR conflicts | Integration merge resolving conflicts between branches. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Adds `POST /users/me/image/`, `POST /users/me/banner/`, and `POST /games/{id}/image/`; serves static files via FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Fixes broken router imports and missing `re` import that prevented the server from starting. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrects field name typo across models, DB and endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Breaks the single `database.py` into a package with one file per domain (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restores missing repository functions and endpoints lost during a merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
# Project Changelog

## Backend — PManagerBackEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Tracks all image files uploaded by users to the static folder. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Creates `game_favorites` table and adds `GET /games/favorites/`, `POST /games/{id}/favorite/`, `DELETE /games/{id}/favorite/` endpoints. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Removes the 400 error raised when `UPDATE` affects 0 rows (data was already identical). |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restricts game creation to admin role; adds achievements endpoint; fixes wiki and builds responses. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Eliminates circular import errors caused by leftover domain class references. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Adds `_ALLOWED_GAME_COLUMNS` guard on dynamic UPDATE queries; adds GitHub Actions PR labeler. |
| `4953077` | Merge master and resolve PR conflicts | Integration merge resolving conflicts between branches. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Adds `POST /users/me/image/`, `POST /users/me/banner/`, and `POST /games/{id}/image/`; serves static files via FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Fixes broken router imports and missing `re` import that prevented the server from starting. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrects field name typo across models, DB and endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Breaks the single `database.py` into a package with one file per domain (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restores missing repository functions and endpoints lost during a merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
# Project Changelog

## Backend — PManagerBackEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Tracks all image files uploaded by users to the static folder. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Creates `game_favorites` table and adds `GET /games/favorites/`, `POST /games/{id}/favorite/`, `DELETE /games/{id}/favorite/` endpoints. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Removes the 400 error raised when `UPDATE` affects 0 rows (data was already identical). |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restricts game creation to admin role; adds achievements endpoint; fixes wiki and builds responses. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Eliminates circular import errors caused by leftover domain class references. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Adds `_ALLOWED_GAME_COLUMNS` guard on dynamic UPDATE queries; adds GitHub Actions PR labeler. |
| `4953077` | Merge master and resolve PR conflicts | Integration merge resolving conflicts between branches. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Adds `POST /users/me/image/`, `POST /users/me/banner/`, and `POST /games/{id}/image/`; serves static files via FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Fixes broken router imports and missing `re` import that prevented the server from starting. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrects field name typo across models, DB and endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Breaks the single `database.py` into a package with one file per domain (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restores missing repository functions and endpoints lost during a merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
# Project Changelog

## Backend — PManagerBackEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Tracks all image files uploaded by users to the static folder. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Creates `game_favorites` table and adds `GET /games/favorites/`, `POST /games/{id}/favorite/`, `DELETE /games/{id}/favorite/` endpoints. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Removes the 400 error raised when `UPDATE` affects 0 rows (data was already identical). |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restricts game creation to admin role; adds achievements endpoint; fixes wiki and builds responses. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Eliminates circular import errors caused by leftover domain class references. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Adds `_ALLOWED_GAME_COLUMNS` guard on dynamic UPDATE queries; adds GitHub Actions PR labeler. |
| `4953077` | Merge master and resolve PR conflicts | Integration merge resolving conflicts between branches. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Adds `POST /users/me/image/`, `POST /users/me/banner/`, and `POST /games/{id}/image/`; serves static files via FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Fixes broken router imports and missing `re` import that prevented the server from starting. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrects field name typo across models, DB and endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Breaks the single `database.py` into a package with one file per domain (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restores missing repository functions and endpoints lost during a merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
# Project Changelog

## Backend — PManagerBackEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Tracks all image files uploaded by users to the static folder. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Creates `game_favorites` table and adds `GET /games/favorites/`, `POST /games/{id}/favorite/`, `DELETE /games/{id}/favorite/` endpoints. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Removes the 400 error raised when `UPDATE` affects 0 rows (data was already identical). |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restricts game creation to admin role; adds achievements endpoint; fixes wiki and builds responses. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Eliminates circular import errors caused by leftover domain class references. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Adds `_ALLOWED_GAME_COLUMNS` guard on dynamic UPDATE queries; adds GitHub Actions PR labeler. |
| `4953077` | Merge master and resolve PR conflicts | Integration merge resolving conflicts between branches. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Adds `POST /users/me/image/`, `POST /users/me/banner/`, and `POST /games/{id}/image/`; serves static files via FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Fixes broken router imports and missing `re` import that prevented the server from starting. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrects field name typo across models, DB and endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Breaks the single `database.py` into a package with one file per domain (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restores missing repository functions and endpoints lost during a merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
# Project Changelog

## Backend — PManagerBackEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Tracks all image files uploaded by users to the static folder. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Creates `game_favorites` table and adds `GET /games/favorites/`, `POST /games/{id}/favorite/`, `DELETE /games/{id}/favorite/` endpoints. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Removes the 400 error raised when `UPDATE` affects 0 rows (data was already identical). |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restricts game creation to admin role; adds achievements endpoint; fixes wiki and builds responses. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Eliminates circular import errors caused by leftover domain class references. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Adds `_ALLOWED_GAME_COLUMNS` guard on dynamic UPDATE queries; adds GitHub Actions PR labeler. |
| `4953077` | Merge master and resolve PR conflicts | Integration merge resolving conflicts between branches. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Adds `POST /users/me/image/`, `POST /users/me/banner/`, and `POST /games/{id}/image/`; serves static files via FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Fixes broken router imports and missing `re` import that prevented the server from starting. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrects field name typo across models, DB and endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Breaks the single `database.py` into a package with one file per domain (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restores missing repository functions and endpoints lost during a merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
# Project Changelog

## Backend — PManagerBackEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Tracks all image files uploaded by users to the static folder. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Creates `game_favorites` table and adds `GET /games/favorites/`, `POST /games/{id}/favorite/`, `DELETE /games/{id}/favorite/` endpoints. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Removes the 400 error raised when `UPDATE` affects 0 rows (data was already identical). |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restricts game creation to admin role; adds achievements endpoint; fixes wiki and builds responses. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Eliminates circular import errors caused by leftover domain class references. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Adds `_ALLOWED_GAME_COLUMNS` guard on dynamic UPDATE queries; adds GitHub Actions PR labeler. |
| `4953077` | Merge master and resolve PR conflicts | Integration merge resolving conflicts between branches. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Adds `POST /users/me/image/`, `POST /users/me/banner/`, and `POST /games/{id}/image/`; serves static files via FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Fixes broken router imports and missing `re` import that prevented the server from starting. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrects field name typo across models, DB and endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Breaks the single `database.py` into a package with one file per domain (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restores missing repository functions and endpoints lost during a merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
# Project Changelog

## Backend — PManagerBackEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Tracks all image files uploaded by users to the static folder. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Creates `game_favorites` table and adds `GET /games/favorites/`, `POST /games/{id}/favorite/`, `DELETE /games/{id}/favorite/` endpoints. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Removes the 400 error raised when `UPDATE` affects 0 rows (data was already identical). |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restricts game creation to admin role; adds achievements endpoint; fixes wiki and builds responses. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Eliminates circular import errors caused by leftover domain class references. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Adds `_ALLOWED_GAME_COLUMNS` guard on dynamic UPDATE queries; adds GitHub Actions PR labeler. |
| `4953077` | Merge master and resolve PR conflicts | Integration merge resolving conflicts between branches. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Adds `POST /users/me/image/`, `POST /users/me/banner/`, and `POST /games/{id}/image/`; serves static files via FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Fixes broken router imports and missing `re` import that prevented the server from starting. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrects field name typo across models, DB and endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Breaks the single `database.py` into a package with one file per domain (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restores missing repository functions and endpoints lost during a merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
# Project Changelog

## Backend — PManagerBackEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Tracks all image files uploaded by users to the static folder. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Creates `game_favorites` table and adds `GET /games/favorites/`, `POST /games/{id}/favorite/`, `DELETE /games/{id}/favorite/` endpoints. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Removes the 400 error raised when `UPDATE` affects 0 rows (data was already identical). |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restricts game creation to admin role; adds achievements endpoint; fixes wiki and builds responses. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Eliminates circular import errors caused by leftover domain class references. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Adds `_ALLOWED_GAME_COLUMNS` guard on dynamic UPDATE queries; adds GitHub Actions PR labeler. |
| `4953077` | Merge master and resolve PR conflicts | Integration merge resolving conflicts between branches. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Adds `POST /users/me/image/`, `POST /users/me/banner/`, and `POST /games/{id}/image/`; serves static files via FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Fixes broken router imports and missing `re` import that prevented the server from starting. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrects field name typo across models, DB and endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Breaks the single `database.py` into a package with one file per domain (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restores missing repository functions and endpoints lost during a merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
# Project Changelog

## Backend — PManagerBackEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Tracks all image files uploaded by users to the static folder. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Creates `game_favorites` table and adds `GET /games/favorites/`, `POST /games/{id}/favorite/`, `DELETE /games/{id}/favorite/` endpoints. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Removes the 400 error raised when `UPDATE` affects 0 rows (data was already identical). |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restricts game creation to admin role; adds achievements endpoint; fixes wiki and builds responses. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Eliminates circular import errors caused by leftover domain class references. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Adds `_ALLOWED_GAME_COLUMNS` guard on dynamic UPDATE queries; adds GitHub Actions PR labeler. |
| `4953077` | Merge master and resolve PR conflicts | Integration merge resolving conflicts between branches. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Adds `POST /users/me/image/`, `POST /users/me/banner/`, and `POST /games/{id}/image/`; serves static files via FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Fixes broken router imports and missing `re` import that prevented the server from starting. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrects field name typo across models, DB and endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Breaks the single `database.py` into a package with one file per domain (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restores missing repository functions and endpoints lost during a merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
# Project Changelog

## Backend — PManagerBackEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Tracks all image files uploaded by users to the static folder. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Creates `game_favorites` table and adds `GET /games/favorites/`, `POST /games/{id}/favorite/`, `DELETE /games/{id}/favorite/` endpoints. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Removes the 400 error raised when `UPDATE` affects 0 rows (data was already identical). |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restricts game creation to admin role; adds achievements endpoint; fixes wiki and builds responses. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Eliminates circular import errors caused by leftover domain class references. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Adds `_ALLOWED_GAME_COLUMNS` guard on dynamic UPDATE queries; adds GitHub Actions PR labeler. |
| `4953077` | Merge master and resolve PR conflicts | Integration merge resolving conflicts between branches. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Adds `POST /users/me/image/`, `POST /users/me/banner/`, and `POST /games/{id}/image/`; serves static files via FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Fixes broken router imports and missing `re` import that prevented the server from starting. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrects field name typo across models, DB and endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Breaks the single `database.py` into a package with one file per domain (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restores missing repository functions and endpoints lost during a merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
# Project Changelog

## Backend — PManagerBackEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Tracks all image files uploaded by users to the static folder. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Creates `game_favorites` table and adds `GET /games/favorites/`, `POST /games/{id}/favorite/`, `DELETE /games/{id}/favorite/` endpoints. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Removes the 400 error raised when `UPDATE` affects 0 rows (data was already identical). |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restricts game creation to admin role; adds achievements endpoint; fixes wiki and builds responses. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Eliminates circular import errors caused by leftover domain class references. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Adds `_ALLOWED_GAME_COLUMNS` guard on dynamic UPDATE queries; adds GitHub Actions PR labeler. |
| `4953077` | Merge master and resolve PR conflicts | Integration merge resolving conflicts between branches. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Adds `POST /users/me/image/`, `POST /users/me/banner/`, and `POST /games/{id}/image/`; serves static files via FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Fixes broken router imports and missing `re` import that prevented the server from starting. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrects field name typo across models, DB and endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Breaks the single `database.py` into a package with one file per domain (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restores missing repository functions and endpoints lost during a merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
# Project Changelog

## Backend — PManagerBackEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Tracks all image files uploaded by users to the static folder. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Creates `game_favorites` table and adds `GET /games/favorites/`, `POST /games/{id}/favorite/`, `DELETE /games/{id}/favorite/` endpoints. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Removes the 400 error raised when `UPDATE` affects 0 rows (data was already identical). |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restricts game creation to admin role; adds achievements endpoint; fixes wiki and builds responses. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Eliminates circular import errors caused by leftover domain class references. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Adds `_ALLOWED_GAME_COLUMNS` guard on dynamic UPDATE queries; adds GitHub Actions PR labeler. |
| `4953077` | Merge master and resolve PR conflicts | Integration merge resolving conflicts between branches. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Adds `POST /users/me/image/`, `POST /users/me/banner/`, and `POST /games/{id}/image/`; serves static files via FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Fixes broken router imports and missing `re` import that prevented the server from starting. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrects field name typo across models, DB and endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Breaks the single `database.py` into a package with one file per domain (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restores missing repository functions and endpoints lost during a merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
# Project Changelog

## Backend — PManagerBackEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Tracks all image files uploaded by users to the static folder. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Creates `game_favorites` table and adds `GET /games/favorites/`, `POST /games/{id}/favorite/`, `DELETE /games/{id}/favorite/` endpoints. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Removes the 400 error raised when `UPDATE` affects 0 rows (data was already identical). |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restricts game creation to admin role; adds achievements endpoint; fixes wiki and builds responses. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Eliminates circular import errors caused by leftover domain class references. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Adds `_ALLOWED_GAME_COLUMNS` guard on dynamic UPDATE queries; adds GitHub Actions PR labeler. |
| `4953077` | Merge master and resolve PR conflicts | Integration merge resolving conflicts between branches. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Adds `POST /users/me/image/`, `POST /users/me/banner/`, and `POST /games/{id}/image/`; serves static files via FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Fixes broken router imports and missing `re` import that prevented the server from starting. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrects field name typo across models, DB and endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Breaks the single `database.py` into a package with one file per domain (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restores missing repository functions and endpoints lost during a merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
# Project Changelog

## Backend — PManagerBackEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Tracks all image files uploaded by users to the static folder. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Creates `game_favorites` table and adds `GET /games/favorites/`, `POST /games/{id}/favorite/`, `DELETE /games/{id}/favorite/` endpoints. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Removes the 400 error raised when `UPDATE` affects 0 rows (data was already identical). |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restricts game creation to admin role; adds achievements endpoint; fixes wiki and builds responses. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Eliminates circular import errors caused by leftover domain class references. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Adds `_ALLOWED_GAME_COLUMNS` guard on dynamic UPDATE queries; adds GitHub Actions PR labeler. |
| `4953077` | Merge master and resolve PR conflicts | Integration merge resolving conflicts between branches. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Adds `POST /users/me/image/`, `POST /users/me/banner/`, and `POST /games/{id}/image/`; serves static files via FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Fixes broken router imports and missing `re` import that prevented the server from starting. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrects field name typo across models, DB and endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Breaks the single `database.py` into a package with one file per domain (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restores missing repository functions and endpoints lost during a merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
# Project Changelog

## Backend — PManagerBackEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Tracks all image files uploaded by users to the static folder. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Creates `game_favorites` table and adds `GET /games/favorites/`, `POST /games/{id}/favorite/`, `DELETE /games/{id}/favorite/` endpoints. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Removes the 400 error raised when `UPDATE` affects 0 rows (data was already identical). |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restricts game creation to admin role; adds achievements endpoint; fixes wiki and builds responses. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Eliminates circular import errors caused by leftover domain class references. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Adds `_ALLOWED_GAME_COLUMNS` guard on dynamic UPDATE queries; adds GitHub Actions PR labeler. |
| `4953077` | Merge master and resolve PR conflicts | Integration merge resolving conflicts between branches. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Adds `POST /users/me/image/`, `POST /users/me/banner/`, and `POST /games/{id}/image/`; serves static files via FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Fixes broken router imports and missing `re` import that prevented the server from starting. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrects field name typo across models, DB and endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Breaks the single `database.py` into a package with one file per domain (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restores missing repository functions and endpoints lost during a merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
# Project Changelog

## Backend — PManagerBackEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `97c0002` | Add uploaded game and user profile images | Tracks all image files uploaded by users to the static folder. |
| `94c53e4` | Add game favorites system with DB table and CRUD endpoints | Creates `game_favorites` table and adds `GET /games/favorites/`, `POST /games/{id}/favorite/`, `DELETE /games/{id}/favorite/` endpoints. |
| `b2273a2` | Fix profile update to not fail when data is unchanged | Removes the 400 error raised when `UPDATE` affects 0 rows (data was already identical). |
| `e033d3d` | feat: admin-only game creation, achievements endpoint, wiki/builds fixes | Restricts game creation to admin role; adds achievements endpoint; fixes wiki and builds responses. |
| `6a77985` | fix: resolve circular imports and remove dead DDD class from users repository | Eliminates circular import errors caused by leftover domain class references. |
| `dcadfe2` | fix: add column whitelist to prevent SQL injection, add labeler.yml | Adds `_ALLOWED_GAME_COLUMNS` guard on dynamic UPDATE queries; adds GitHub Actions PR labeler. |
| `4953077` | Merge master and resolve PR conflicts | Integration merge resolving conflicts between branches. |
| `b3c3398` | feat: add image upload endpoint and static file serving | Adds `POST /users/me/image/`, `POST /users/me/banner/`, and `POST /games/{id}/image/`; serves static files via FastAPI. |
| `8e4694e` | fix: resolve startup errors by correcting router imports | Fixes broken router imports and missing `re` import that prevented the server from starting. |
| `ad276ee` | Fix typo in 'gendre' to 'gender' in Game class | Corrects field name typo across models, DB and endpoints. |
| `488dd70` | refactor: split database.py into modular package structure | Breaks the single `database.py` into a package with one file per domain (`games`, `users`, `forums`, …). |
| `50845f5` | fix: resolve merge conflicts, add missing DB functions and endpoints | Restores missing repository functions and endpoints lost during a merge. |
| `490dd75` | Add Forum, tier_list and Achievements | Adds CRUD endpoints and DB functions for forums, tier lists and achievements. |
| `d5f2d15` | Added routers for chats, builds, messages_instance, discussion | Implements endpoint files for chat, builds, discussion and messages. |
| `511b343` | Finishing guides | Completes guides endpoints and repository functions. |
| `0fe1b2b` | Forums and Wiki endpoints | Adds initial forum and wiki REST endpoints. |
| `84b8fee` | Finish the Game endpoints | Completes game CRUD with search and listing endpoints. |
| `0e8cc83` | Configure user endpoints to use MariaDB | Migrates user routes from in-memory stubs to real MariaDB queries. |
| `35c4d29` | Implement CRUD functions and improve authentication | Adds full user CRUD repository and strengthens JWT auth logic. |
| `0e24ef9` | Add email and image fields to user models and expand database schema | Extends user model with `email` and `image`; updates `schema.sql`. |
| `5823ae1` | Adding models, database, changed auth import and users logic | Introduces Pydantic models, DB connection config and restructured auth. |
| `3839a1c` | Adding auth | Adds JWT token generation and OAuth2 password flow. |
| `f062496` | Added content to main and users router | Wires up FastAPI app entry point and first user routes. |
| `32d4b6c` | Database tables | Initial `schema.sql` with base table definitions. |
| `06076e7` | First commit: project base created | Empty FastAPI project scaffold. |

---

## Frontend — PManagetFrontEnd

| Hash | Commit | Description |
|------|--------|-------------|
| `bf86c0c` | Add Juegos nav section, favorites on home, like and delete buttons on game cards | Adds a dedicated Games tab in the nav bar; home page shows only favorites; heart and trash icon buttons on every game card. |
| `55c193b` | Add game favorites state, toggle like and delete game to ViewModel and ApiService | Adds `likedGameIds`/`juegosLiked` state flows, optimistic `toggleLike`, and `eliminarJuego` with local list cleanup. |
| `15c717b` | Fix Android image upload filename extension and network security config | Derives file extension from MIME type when missing; adds cleartext hosts to `network_security_config.xml`. |
| `3a75e7f` | fix: repair App.kt and PantallaPrincipal after broken merge | Restores `NavigationRail`/`NavigationBar` and `BoxWithConstraints` layout lost during merge conflict resolution. |
| `63e9c13` | fix: resolve merge conflict keeping full profile/banner UI | Keeps the complete profile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |
ofile editing UI (avatar + banner) after a conflicted merge. |
| `a0f91bb` | feat: add banner field to persist profile background | Adds `banner` field to `UserOut`; sends it on profile update; displays it as background in the profile screen. |
| `54fcae8` | feat: adapt frontend to backend API | Aligns models, login form, JWT session management and navigation to match the FastAPI backend. |
| `4310368` | Login view | Implements the login screen UI with form validation. |
| `d520632` | Updated packages for Login, gradle.build and added serialization alias | Adds Ktor + kotlinx-serialization dependencies and configures Gradle for KMP. |
| `1793fa4` | Login first contact | First draft of the login composable screen. |
| `c63bdfa` | First version uploaded | Initial Compose Multiplatform project scaffold. |

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

-- Game Favorites (user likes)
CREATE TABLE IF NOT EXISTS game_favorites (
    user_id  INT NOT NULL,
    game_id  INT NOT NULL,
    PRIMARY KEY (user_id, game_id),
    FOREIGN KEY (user_id) REFERENCES users(id)        ON DELETE CASCADE,
    FOREIGN KEY (game_id) REFERENCES games(id_game)   ON DELETE CASCADE
);
