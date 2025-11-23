from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from handler import handle_text
from summary import make_summary

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/appointment")
async def prompt(request: dict):
    user_message = request.get("text", "")
    result = handle_text(user_text=user_message)
    return {"response" : result}


@app.post("/summary")
async def sumup(request: dict):
    text = request.get("text", "")
    result = make_summary(text = text)
    return {"response" : result}
