# users router

'''

uvicorn app.main:app --host 0.0.0.0 --port 8080 --reload

curl -X POST http://localhost:8080/users/login/ -F "username=pm" -F "password=pm" -H "Content-Type: multipart/form-data"

(para encriptar contraseñas)
bcrypt.hashpw(password="pm".encode("utf-8"), salt=bcrypt.gensalt())

openssl rand -hex 32

'''
from pydantic import BaseModel
from fastapi.security.oauth2 import OAuth2PasswordRequestForm
from fastapi import APIRouter, status, HTTPException, Depends, UploadFile, File, Request

from app.auth import (
    create_token_pair,
    TokenPair,
    verify_password,
    decode_token,
    decode_refresh_token,
    oauth2_scheme,
    TokenData,
    get_hash_password,
)
from app.database import (
    insert_user,
    get_user_by_username,
    get_all_users,
    delete_user_by_username,
    update_user_by_username,
)
from app.models import UserIn, UserOut, UserDb, UserBase, UserUpdate
from app.shared.images import save_upload


router = APIRouter(
    prefix="/users",
    tags=["Users"]
)

@router.post("/signup/", status_code=status.HTTP_201_CREATED, response_model=UserOut)
async def create_user(user_in: UserIn):
    # Verificar si el usuario ya existe en la base de datos
    existing_user = get_user_by_username(user_in.username)
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Username already exists"
        )
    
    # Hash de la contraseña
    hashed_password = get_hash_password(user_in.password)
    
    # Insertar usuario en la base de datos
    user_id = insert_user(
        UserDb(
            id=0,  # El ID será generado por la base de datos
            name=user_in.name,
            username=user_in.username,
            email=user_in.email,
            password=hashed_password,
            image=user_in.image,
            role=user_in.role if hasattr(user_in, 'role') else 'user'
        )
    )
    return UserOut(id=user_id, name=user_in.name, username=user_in.username, email=user_in.email, image=user_in.image, role=user_in.role if hasattr(user_in, 'role') else 'user')
@router.post(
    "/login/",
    response_model=TokenPair,
    status_code=status.HTTP_200_OK
)
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    username: str | None = form_data.username
    password: str | None = form_data.password

    if username is None or password is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Nickname and/or password missing"
        )

    user = get_user_by_username(username)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Username and/or password incorrect"
        )

    if not verify_password(password, user.password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Username and/or password incorrect"
        )

    return create_token_pair(UserBase(username=user.username, password=user.password))


class RefreshRequest(BaseModel):
    refresh_token: str


@router.post("/refresh/", response_model=TokenPair, status_code=status.HTTP_200_OK)
async def refresh(request: RefreshRequest):
    data = decode_refresh_token(request.refresh_token)
    if not data.username:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token")
    user = get_user_by_username(data.username)
    if not user:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="User not found")
    return create_token_pair(UserBase(username=user.username, password=user.password))

# Get all users
#@router.get(
#    "/",
#    response_model=list[UserOut],
#    status_code=status.HTTP_200_OK
#)
#        token=f"mytoken:{user.nickname}-{user.name}",

# Get all users
@router.get("/", response_model=list[UserOut], status_code=status.HTTP_200_OK)
async def get_users(token: str = Depends(oauth2_scheme)):
    data: TokenData = decode_token(token)

    # Verificar que el usuario esté autenticado
    user = get_user_by_username(data.username)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Forbidden"
        )

    # Obtener todos los usuarios de la base de datos
    all_users = get_all_users()
    return [
        UserOut(id=userDb.id, name=userDb.name, username=userDb.username, email=userDb.email, image=userDb.image, role=userDb.role)
        for userDb in all_users
    ]

# Perfil del usuario logueado
@router.get("/me/", response_model=UserOut)
async def read_users_me(token: str = Depends(oauth2_scheme)):
    # Decodificamos el token para saber quién pregunta
    data: TokenData = decode_token(token)
    
    # Buscamos al usuario en la base de datos
    user_found = get_user_by_username(data.username)
    
    if user_found is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
        
    return UserOut(id=user_found.id, name=user_found.name, username=user_found.username, email=user_found.email, image=user_found.image, role=user_found.role)


# Buscar usuario por username
@router.get("/{username}/", response_model=UserOut)
async def read_user(username: str, token: str = Depends(oauth2_scheme)):
    # Verificamos token
    decode_token(token)
    
    user_found = get_user_by_username(username)
    
    if user_found is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"User {username} not found"
        )
    
    return UserOut(id=user_found.id, name=user_found.name, username=user_found.username, email=user_found.email, image=user_found.image, role=user_found.role)


# Actualizar perfil del usuario autenticado
@router.put("/me/", response_model=UserOut, status_code=status.HTTP_200_OK)
async def update_me(user_update: UserUpdate, token: str = Depends(oauth2_scheme)):
    data: TokenData = decode_token(token)
    user = get_user_by_username(data.username)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    fields: dict = {}
    if user_update.name is not None:
        fields["name"] = user_update.name
    if user_update.email is not None:
        fields["email"] = user_update.email
    if user_update.image is not None:
        fields["image"] = user_update.image
    if user_update.password is not None:
        fields["password"] = get_hash_password(user_update.password)

    if fields:
        updated = update_user_by_username(data.username, fields)
        if not updated:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="User could not be updated")

    updated_user = get_user_by_username(data.username)
    return UserOut(
        id=updated_user.id,
        name=updated_user.name,
        username=updated_user.username,
        email=updated_user.email,
        image=updated_user.image,
        role=updated_user.role,
    )


# Borrar usuario
@router.delete("/{username}/", status_code=status.HTTP_204_NO_CONTENT)
async def delete_user(username: str, token: str = Depends(oauth2_scheme)):
    data: TokenData = decode_token(token)
    requester = get_user_by_username(data.username)
    if not requester:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Forbidden")

    if requester.role != "admin" and requester.username != username:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Not allowed")

    user_found = get_user_by_username(username)
    
    if user_found is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    # Eliminar usuario de la base de datos
    deleted = delete_user_by_username(username)
    if not deleted:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to delete user"
        )
    
    return None  # 204

# --------------------------------------------------------------
#    print(token)
#
#    if token is None:
#        raise HTTPException(
#            status_code=status.HTTP_403_FORBIDDEN,
#            detail="Forbidden"
#        )
#
#    parts = token.split(":") # Separamos mytoken de lo demas
#    if len(parts) !=2:
#        raise HTTPException(
#            status_code=status.HTTP_403_FORBIDDEN,
#            detail="Forbidden"
#        )
#
#    if parts[0] != "mytoken": # Verificar el token
#        raise HTTPException(
#            status_code=status.HTTP_403_FORBIDDEN,
#            detail="Forbidden"
#        )
#
#    paylaod_parts = parts[1].split("--")
#    if len(paylaod_parts) !=2: # Separamos nickname de name
#        raise HTTPException(
#            status_code=status.HTTP_403_FORBIDDEN,
#            detail="Forbidden"
#        )
# mas o menos lo mismo que: "return users" ya que FastAPI se encarga de hacer el filtrado poniendole el response_model

'''

Payload
---------
{
    "sub": "nombre" (emisor del token)
    "iss": "..." --no hace falta por ahora pero es el emisor del token
    "exp": "tiempo de expiracion del token"
}

Signature
----------
Se coge el header, el paylode y se aplica el codigo secreto.

HM...(
    base64UrlEncode(header) + "." + base64UrlEncode(payload), secret
)

Name: alice           name="username"
Password: alice       name="password"

username=alice&password=alice

'''

@router.post("/me/image/", response_model=UserOut, status_code=status.HTTP_200_OK)
async def upload_profile_image(
    request: Request,
    file: UploadFile = File(...),
    token: str = Depends(oauth2_scheme),
):
    data: TokenData = decode_token(token)
    user = get_user_by_username(data.username)
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    image_url = await save_upload(file, request)

    update_user_by_username(data.username, {"image": image_url})
    updated_user = get_user_by_username(data.username)
    return UserOut(
        id=updated_user.id,
        name=updated_user.name,
        username=updated_user.username,
        email=updated_user.email,
        image=updated_user.image,
        role=updated_user.role,
    )
