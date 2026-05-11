from dataclasses import dataclass
from typing import Optional, List
from app.domain.value_objects.email import Email
from app.domain.value_objects.password import Password

@dataclass
class User:
    id: Optional[int] = None
    username: str = ""
    email: Email = None
    password: Password = None
    role: str = "user"
    image: Optional[str] = None

    def __post_init__(self):
        if self.email is None:
            self.email = Email("")
        if self.password is None:
            self.password = Password("")
    
    def is_admin(self) -> bool:
        return self.role == "admin"

    def validate_email(self) -> bool:
        return self.email.is_valid()
        