from fastapi import FastAPI
from routes import auth, song, playlist
from database import engine
from models.base import Base 

app = FastAPI()

app.include_router(auth.router, prefix="/auth")
app.include_router(song.router, prefix='/song')
app.include_router(playlist.router, prefix='/playlist')

Base.metadata.create_all(engine)