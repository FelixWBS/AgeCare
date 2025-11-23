from bedrock_client import call_bedrock

MODEL_ID = "eu.meta.llama3-2-1b-instruct-v1:0"

SYSTEM = """
You generate short, clear notifications for relatives about medical appointments.
Don't invent details. Use only the given appointment JSON.
Return only the message text. No explanations. Clean English please!
"""

def generate_notification(appointment_json: str) -> str:
    # Combine system instructions and user input
    prompt = SYSTEM + "\n\nAPPOINTMENT DATA (JSON):\n" + appointment_json

    messages = [
        {
            "role": "user",
            "content": [{"text": prompt}]
        }
    ]

    res = call_bedrock(MODEL_ID, messages)
    return res["output"]["message"]["content"][0]["text"]
