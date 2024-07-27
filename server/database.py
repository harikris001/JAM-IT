from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

DATABASE_URL = 'postgresql://postgres:root1234@localhost:5432/jamit'


engine = create_engine(DATABASE_URL)

sessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def get_db():
    db = sessionLocal()
    try:
        yield db
    finally:
        db.close()