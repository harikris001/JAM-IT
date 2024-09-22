from models.base import Base

from sqlalchemy import VARCHAR, TEXT, Column, ForeignKey, ARRAY, BOOLEAN
from sqlalchemy.orm import relationship

class Playlist(Base):
    __tablename__ = "playlist"

    id = Column(TEXT, primary_key=True)
    playlist_name = Column(VARCHAR(100))
    visible = Column(BOOLEAN)
    author_id = Column(TEXT, ForeignKey('users.id'))

    users = relationship('User', back_populates='playlist')
    songs = relationship('PlaylistSongs', back_populates='playlist')
