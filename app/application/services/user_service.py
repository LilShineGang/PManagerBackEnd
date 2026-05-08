from app.domain.entities.user import User
from app.domain.repositories.user_repository import UserRepository
from app.application.exceptions.user_exceptions import (
    UserAlreadyExistsError, InvalidEmailError
)
from app.shared.security.password_hasher import PasswordHasher
from typing import Optional, List

class UserService:
    def __init__(self, user_repository: UserRepository, password_hasher: PasswordHasher):
        self.user_repository = user_repository
        self.password_hasher = password_hasher

    async def create_user(
            self, 
            username: str, 
            email: str, 
            password: str, 
            role: str = "user"
            ) -> User:
        # Check if user already exists
        existing_user = self.user_repository.get_by_username(username)
        if existing_user:
            raise UserAlreadyExistsError(f"User {username} already exists")        
        
        # Create user entity
        user = User(
            username=username,
            email=email,
            name=name,
            password=self.password_hasher.hash(password)
            role=role
        )

        # Email validation
        if not user.validate_email():
            raise InvalidEmailError(f"Invalid email: {email}")

        return self.user_repository.save(user)

        async def authenticate_user(self, username: str, password: str) -> Optional[User]:
            user = self.user_repository.get_by_username(username)
            if user and self.password_hasher.verify(password, user.password.value):
                return user
            return None

        async def get_user_by_id(self, user_id: int) -> Optional[User]:
            return self.user_repository.get_by_id(user_id)

        async def get_all_users(self) -> List[User]:
            return self.user_repository.get_all()

