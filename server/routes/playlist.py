from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func
import uuid

from database import get_db
from middleware.auth_middleware import auth_middleware
from models.playlist_songs import PlaylistSongs
from pydantics_schema.playlist_songs import PlaylistSongBody, PlaylistUpdate
from models.playlist import Playlist

router = APIRouter()

@router.get('/')
def get_playlist(db: Session = Depends(get_db)):
    playlist = db.query(Playlist).filter(Playlist.visible == True).limit(10).all()

    return playlist
@router.get('/my')
def get_my_playlist(
    db: Session = Depends(get_db), 
    auth_dict = Depends(auth_middleware)
    ):

    my_playlist = db.query(Playlist).filter(Playlist.author_id == auth_dict['uid']).all()

    return my_playlist

@router.get('/{playlist_id}')
def get_playlist_songs(
    playlist_id: str,
    db: Session = Depends(get_db),
    ):

    playlist_songs = db.query(PlaylistSongs).filter(PlaylistSongs.playlist_id == playlist_id).all()

    return playlist_songs

@router.post('/create', status_code=201)
def create_playlist(
    playlist: PlaylistSongBody,
    db: Session = Depends(get_db), 
    auth_dict = Depends(auth_middleware)
    ):

    existing_playlist = db.query(Playlist).filter(Playlist.playlist_name == playlist.name, Playlist.author_id == auth_dict['uid']).first()
    if existing_playlist:
        raise HTTPException(status_code=400, detail="Playlist already exists")
    
    new_playlist = Playlist(id = str(uuid.uuid4()), author_id = auth_dict['uid'], playlist_name = playlist.name, visible = playlist.visibility)
    db.add(new_playlist)
    db.commit()
    db.refresh(new_playlist)
    return new_playlist

@router.post('/{playlist_id}/add-song', status_code=200)
def add_song_to_playlist(
    playlist_id: str,
    playlist: PlaylistUpdate,
    db: Session=Depends(get_db), 
    auth_dict = Depends(auth_middleware), 
    ):

    update_playlist = db.query(Playlist).filter(Playlist.id == playlist_id).first()

    if not update_playlist:
        return HTTPException(status_code= 404, detail="No playlist found")
    
    playlist_song = db.query(PlaylistSongs).filter(PlaylistSongs.playlist_id == playlist_id, PlaylistSongs.song_id == playlist.song_id).first()

    if playlist_song:
        raise HTTPException(status_code=400, detail="Song already in playlist")

    # Add the song to the playlist
    new_playlist_song = PlaylistSongs(
        id=str(uuid.uuid4()),
        playlist_id=playlist_id,
        song_id=playlist.song_id)

    db.add(new_playlist_song)
    db.commit()
    db.refresh(new_playlist_song)

    return {"message": "Song added to playlist", "song": new_playlist_song}