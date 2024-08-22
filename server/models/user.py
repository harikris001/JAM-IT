from sqlalchemy import TEXT, VARCHAR, Column, LargeBinary
from sqlalchemy.orm import relationship
from models.base import Base


class User(Base):
    __tablename__ = "users"

    id = Column(TEXT, primary_key=True)
    name = Column(VARCHAR(255))
    email = Column(VARCHAR(255))
    password = Column(LargeBinary)

    favourites = relationship('Favourite', back_populates="favourites")