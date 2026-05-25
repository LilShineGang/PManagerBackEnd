# Historial de cambios — Backend (PManagerBackEnd)

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
| `8e4694e` | fix: resolve startup errors by correcting router imports | Corrige importaciones de routers rotas y el `import re` que faltaba e impedía arrancar el servidor. |
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
