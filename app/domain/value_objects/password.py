from dataclasses import dataclass

@dataclass
class Password:
    value: str = ""
    
    def is_hashed(self) -> bool:
        return len(self.value) > 50  # Simple check for bcrypt hash
    
    def __str__(self) -> str:
        return self.value
