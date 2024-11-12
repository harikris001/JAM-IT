from fastapi import FastAPI
from routes import auth, song, server_check
from database import engine
from models.base import Base 

app = FastAPI()

app.include_router(auth.router, prefix="/auth")
app.include_router(song.router, prefix='/song')
app.include_router(server_check.router)

Base.metadata.create_all(engine)