from pydantic import BaseModel

class PlaylistSongBody(BaseModel):
    name: str
    visibility: bool

class PlaylistUpdate(BaseModel):
    song_id: str