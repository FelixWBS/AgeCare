

from bedrock_client_antrh import call_bedrock

MODEL_ID = "eu.meta.llama3-2-1b-instruct-v1:0"

SYSTEM = """
You summarize the given input into 3 bulletpoints. Return format should be three three bulletpoints and LESS if not enough information is provided. Nothing more!
"""

def make_summary(text: str):
    prompt = SYSTEM + "\n\nUSER INPUT:\n" + text

    messages = [
        {
            "role": "user",
            "content": [{"text": prompt}]
        }
    ]

    res = call_bedrock(MODEL_ID, messages)
    return res["output"]["message"]["content"][0]["text"]
