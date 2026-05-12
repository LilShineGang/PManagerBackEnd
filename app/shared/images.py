import os
import uuid

from fastapi import UploadFile, HTTPException, status, Request

ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".webp"}
MAX_SIZE_BYTES = 5 * 1024 * 1024  # 5 MB

STATIC_IMAGES_DIR = os.path.join(
    os.path.dirname(os.path.dirname(os.path.dirname(__file__))),
    "static", "images"
)


async def save_upload(file: UploadFile, request: Request) -> str:
    """Validates, saves the uploaded image and returns its public URL."""
    ext = os.path.splitext(file.filename or "")[1].lower()
    if ext not in ALLOWED_EXTENSIONS:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"File type not allowed. Allowed: {', '.join(sorted(ALLOWED_EXTENSIONS))}",
        )

    contents = await file.read()
    if len(contents) > MAX_SIZE_BYTES:
        raise HTTPException(
            status_code=status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
            detail="File too large (max 5 MB)",
        )

    os.makedirs(STATIC_IMAGES_DIR, exist_ok=True)
    filename = f"{uuid.uuid4().hex}{ext}"
    with open(os.path.join(STATIC_IMAGES_DIR, filename), "wb") as f:
        f.write(contents)

    base_url = str(request.base_url).rstrip("/")
    return f"{base_url}/static/images/{filename}"
