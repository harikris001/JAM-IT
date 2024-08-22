from pydantic import BaseModel

class FavouriteSong(BaseModel):
    song_id: str