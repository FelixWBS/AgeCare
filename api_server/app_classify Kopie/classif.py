from bedrock_client_antrh import call_bedrock

MODEL_ID = "anthropic.claude-3-sonnet-20240229-v1:0"

SYSTEM = """
You classify the User Input into one categegory. Based on your medicine knowledge.
Return one word which fits the need of the patient. If you are not sure just return an General Medicine.
These are all the options: General Medicine, Internal Medicine, Cardiology, Dermatology, Neurology, Pediatrics, Psychiatry, Gastroenterology, Pulmonology, Endocrinology, Nephrology, Rheumatology, Oncology, General Surgery, Orthopedic Surgery, Obstetrics and Gynecology, Urology, ENT, Ophthalmology, Radiology
"""

def classify(text: str) -> str:
    prompt = SYSTEM + "\n\nUSER INPUT:\n" + text

    print("PROMPT", prompt)

    messages = [
        {
            "role": "user",
            "content": [{"text": prompt}]
        }
    ]

    res = call_bedrock(MODEL_ID, messages)
    return res["output"]["message"]["content"][0]["text"]
