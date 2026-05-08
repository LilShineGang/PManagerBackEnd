import bcrypt
from app.domain.value_objects.password import Password

class PasswordHasher:
    def hash(self, password: str) -> Password:
        """Hash a password using bcrypt."""
        salt = bcrypt.gensalt()
        hashed = bcrypt.hashpw(password.encode('utf-8'), salt)
        return Password(hashed.decode('utf-8'))
    
    def verify(self, plain_password: str, hashed_password: str) -> bool:
        """Verify a password against its hash."""
        return bcrypt.checkpw(plain_password.encode('utf-8'), hashed_password.encode('utf-8'))
