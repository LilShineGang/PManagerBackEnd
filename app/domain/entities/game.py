from dataclasses import dataclass
from typing import Optional
from app.domain.entities.game_rating import GameRating

@dataclass
class Game:
    id: Optional[int] = None
    name: str = ""
    gendre: str = ""
    difficulty: str = ""
    rating: Optional[GameRating] = None
    image: Optional[str] = None
    category: str = ""

    def __post_init__(self):
        if self.rating is None:
            self.rating = GameRating(0.0)

    def is_popular(self) -> bool:
        return self.rating.average >= 4.0
