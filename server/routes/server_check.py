from fastapi import APIRouter

router = APIRouter()

@router.get('/', status_code=200)
def server_check():
    return {"message": "Server is running"}

@router.head('/', status_code=200)
def head_check():
    return {"message": "Server is running"}