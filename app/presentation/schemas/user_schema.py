from pydantic import BaseModel, EmailStr
from app.domain.entities.user import User

class UserCreateRequest(BaseModel):
    username: str
    email: EmailStr
    name: str
    password: str
    role: str = "user"
    image: str = None

class UserResponse(BaseModel):
    id: int
    username: str
    email: EmailStr
    name: str
    role: str
    image: str = None

    @classmethod
    def from_entity(cls, user: User) -> "UserResponse":
        return cls(
            id=user.id,
            username=user.username,
            email=user.email,
            name=user.name,
            role=user.role,
            image=user.image
        )
