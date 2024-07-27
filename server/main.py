from fastapi import FastAPI
from routes import auth
from database import engine
from models.base import Base 

app = FastAPI()

app.include_router(auth.router,prefix="/auth")

Base.metadata.create_all(engine)