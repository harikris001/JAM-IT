from sqlalchemy import Column, ForeignKey, TEXT
from sqlalchemy.orm import relationship

from models.base import Base

class PlaylistSongs(Base):
    __tablename__ = 'playlist_songs'

    id = Column(TEXT, primary_key=True)
    playlist_id = Column(TEXT, ForeignKey('playlist.id'))
    song_id = Column(TEXT, ForeignKey('song.id'))

    song = relationship('Song')

    playlist = relationship('Playlist')
