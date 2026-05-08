from dataclasses import dataclass

_EMAIL_RE = re.compile(r"^[^\s@]+@[^\s@]+\.[^\s@]+$")

@dataclass
class Email:
    value: str = ""
    
    def is_valid(self) -> bool:
        return bool(_EMAIL_RE.match(self.value))
    def __str__(self) -> str:
        return self.value
