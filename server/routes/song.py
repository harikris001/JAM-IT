from fastapi import APIRouter, File, Form, UploadFile, Depends
from sqlalchemy.orm import Session
import cloudinary
import cloudinary.uploader
import os
import uuid
from middleware.auth_middleware import auth_middleware
from sqlalchemy.orm import joinedload

from models.favourite import Favourite
from models.song import Song
from database import get_db
from pydantics_schema.favourite_song import FavouriteSong
router = APIRouter()

@router.post('/upload',status_code=201)
def upload_song(
    song: UploadFile = File(...), 
    thumbnail: UploadFile = File(...), 
    artist: str = Form(...), 
    song_name: str = Form(...), 
    hex_code: str = Form(...), 
    db: Session = Depends(get_db), 
    auth_dict = Depends(auth_middleware)):

    cloudinary.config(
    cloud_name = "dqvdgzlmn", 
    api_key = "487972882298548", 
    api_secret = os.environ.get("SECRET_KEY"), 
    secure=True
    )

    song_id = str(uuid.uuid4())

    song_result = cloudinary.uploader.upload(file = song.file, resource_type = 'auto', folder = f"songs/{song_id}")
    thumbnail_result = cloudinary.uploader.upload(file = thumbnail.file, resource_type = 'image', folder=f"songs/{song_id}")

    new_song = Song(
        id = song_id,
        song_url = song_result['secure_url'],
        thumbnail_url = thumbnail_result['secure_url'],
        artist = artist,
        song_name = song_name,
        hex_code = hex_code
    )

    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    return new_song


@router.get('/list')
def list_songs(db: Session = Depends(get_db), auth_dict = Depends(auth_middleware)):
    songs = db.query(Song).all()
    return songs

@router.post('/favourite')
def favourite_song(song: FavouriteSong, db: Session = Depends(get_db), auth_dict = Depends(auth_middleware)):

    user_id = auth_dict['uid']
    fav_song = db.query(Favourite).filter(Favourite.song_id == song.song_id, Favourite.user_id == user_id).first()

    if fav_song:
        db.delete(fav_song)
        db.commit()
        return {'message': False}
    else:
        new_fav = Favourite(id = str(uuid.uuid4()), song_id=song.song_id, user_id=user_id)
        db.add(new_fav)
        db.commit()
        return {"message": True}
    
@router.get('/list/favourite')
def list_fav_songs(db: Session = Depends(get_db), auth_dict = Depends(auth_middleware)):
    user_id = auth_dict['uid']
    fav_songs = db.query(Favourite).filter(Favourite.user_id == user_id).options(joinedload(Favourite.song), ).all()
    return fav_songs


@router.get('/search/',status_code=200)
def search_songs(query: str, db: Session = Depends(get_db),auth_dict = Depends(auth_middleware)):
    songs = db.query(Song).filter(Song.song_name.ilike(f'%{query}%')).limit(10).all()
    return songs