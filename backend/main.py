from fastapi import FastAPI, Request
from fastapi.responses import StreamingResponse
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Any
import asyncio
import json
from manager import init_db, load_all, upsert, seed as db_seed

app = FastAPI(title="snivy")

init_db()
DB = load_all()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

update_event = asyncio.Event()


class UpdatePayload(BaseModel):
    category: str = "feature_flags"
    key: str
    value: dict

@app.post("/admin/seed")
async def seed_db(initial_data: dict):
    global DB
    db_seed(initial_data)
    DB.update(initial_data)
    update_event.set()
    return {"status": "success", "message": "Database initialized"}

@app.post("/admin/update")
async def update_data(payload: UpdatePayload):
    # Ensure the category exists in the cache
    if payload.category not in DB:
        DB[payload.category] = {}
    
    DB[payload.category][payload.key] = payload.value
    upsert(payload.category, payload.key, payload.value)
    
    update_event.set()
    return {"status": "success", "message": f"{payload.key} updated"}

@app.get("/stream")
async def stream_data(request: Request):
    async def event_generator():
        yield f"data: {json.dumps(DB)}\n\n"
        while True:
            if await request.is_disconnected():
                break
            await update_event.wait()
            yield f"data: {json.dumps(DB)}\n\n"
            update_event.clear()

    return StreamingResponse(event_generator(), media_type="text/event-stream")

@app.get("/config")
async def get_config():
    return DB
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)
