from dataclasses import dataclass

@dataclass
class Email:
    value: str = ""
    
    def is_valid(self) -> bool:
        return "@" in self.value and "." in self.value.split("@")[-1]
    
    def __str__(self) -> str:
        return self.value
