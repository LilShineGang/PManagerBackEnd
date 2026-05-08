class UserAlreadyExistsError(Exception):
    """Raised when trying to create a user that already exists."""
    pass

class UserNotFoundError(Exception):
    """Raised when a user is not found."""
    pass

class InvalidEmailError(Exception):
    """Raised when an email is invalid."""
    pass

class InvalidPasswordError(Exception):
    """Raised when a password is invalid."""
    pass

class UnauthorizedAccessError(Exception):
    """Raised when a user tries to access unauthorized resources."""
    pass