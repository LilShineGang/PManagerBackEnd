from fastapi import Depends
from app.application.services.user_service import UserService
from app.infra.database.repositories.users import MariaDBUserRepository
from app.shared.security.password_hasher import PasswordHasher

def get_user_repository() -> MariaDBUserRepository:
    return MariaDBUserRepository()

def get_password_hasher() -> PasswordHasher:
    return PasswordHasher()

def get_user_service(
    user_repo: MariaDBUserRepository = Depends(get_user_repository),
    password_hasher: PasswordHasher = Depends(get_password_hasher)
) -> UserService:
    return UserService(user_repo, password_hasher)
