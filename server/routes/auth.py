from fastapi import APIRouter, Depends, HTTPException, Header
from database import get_db
from middleware.auth_middleware import auth_middleware
from models.user import User
from pydantics_schema.user_create import UserCreate
from pydantics_schema.user_login import UserLogin
import bcrypt
import uuid
import jwt
import os
from sqlalchemy.orm import Session, joinedload




router = APIRouter()

@router.post('/signup')
def signup(user: UserCreate, db: Session=Depends(get_db)):
    user_data = db.query(User).filter(User.email == user.email).first()
    if user_data:
        raise HTTPException(status_code=400, detail="Account with this email already exist.")
    

    hashed_password = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())
    user_data = User(id=str(uuid.uuid4()),name=user.name, email=user.email, password=hashed_password)
    db.add(user_data)
    db.commit()
    db.refresh(user_data)
    return user_data


@router.post('/login')
def login(user: UserLogin, db: Session=Depends(get_db)):
    user_data = db.query(User).filter(User.email == user.email).first()
    if not user_data:
        raise HTTPException(status_code=400, detail="User with this email doesn't exist.")
    
    is_matched = bcrypt.checkpw(user.password.encode(), user_data.password)
    if not is_matched:
        raise HTTPException(status_code=400, detail="Incorrect password.")
    
    token = jwt.encode({'id': user_data.id,}, str(os.environ.get('JWT_SECRET_KEY'),))
    
    return {"token": token, "user": user_data}

@router.get('/')
def current_user(db: Session = Depends(get_db), user_dict = Depends(auth_middleware)):
    user = db.query(User).filter(User.id == user_dict['uid']).options(joinedload(User.favourites)).first()

    if not user:
        raise HTTPException(404, 'User not found!')
    
    return user