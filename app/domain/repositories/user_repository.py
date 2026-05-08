from abc import abstractmethod
from app.domain.repositories.base_repository import BaseRepository
from app.domain.entities.user import User
from typing import Optional

class UserRepository(BaseRepository[User]):
    @abstractmethod
    def get_by_username(self, username: str) -> Optional[User]:
        pass

    @abstractmethod
    def get_by_group(self, user_id: int, group_id: int) -> bool:
        pass

    @abstractmethod
    def remove_from_group(self, user_id: int, group_id: int) -> bool:
        pass
