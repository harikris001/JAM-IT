import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# DATABASE_URL = 'postgresql://postgres:hari2001@localhost:5432/jamit'
DATABASE_URL = os.environ.get("DATABASE_URL")


engine = create_engine(DATABASE_URL)

sessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
print("Connected To DATABASE")

def get_db():
    db = sessionLocal()
    try:
        yield db
    finally:
        db.close()