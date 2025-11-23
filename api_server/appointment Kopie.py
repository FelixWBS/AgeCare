from bedrock_client_antrh import call_bedrock
import json


MODEL_ID = "anthropic.claude-3-sonnet-20240229-v1:0"

SYSTEM = """
You convert a given appointment string into a JSON structure for an appointment.
Title is a SHORT description of the appointment NOT of the DOCTOR.
Give a breif overview of the appointment in the notes.
Return ONLY valid JSON with these fields:
"title", "nameOfDoctor", "date", "location", "phoneNumber", "notes".
Missing fields must be empty strings "".
Date must be ISO8601: YYYY-MM-DDTHH:MM:SSZ.
If not provided come up with additional information.
No explanation, no extra text.
"""

def create_appointment_json(text: str, doctor: dict) -> str:
    prompt = SYSTEM + "\n\nDoktor Info:\n" + str(doctor) + "\nUser Input:" + text

    messages = [
        {
            "role": "user",
            "content": [{"text": prompt}]
        }
    ]

    res = call_bedrock(MODEL_ID, messages)



    output_text = res["output"]["message"]["content"][0]["text"]

    demo = False
    if demo:
        # Parse JSON safely
        appointment = {}
        try:
            appointment = json.loads(output_text)

            print("IS IT POSSIBLE??? ------------", appointment)
        except json.JSONDecodeError:
            # fallback to empty template
            appointment = {
                "title": "",
                "nameOfDoctor": "",
                "date": "",
                "location": "",
                "phoneNumber": "",
                "notes": ""
            }

        # Hardcode default title if missing
    
        appointment["title"] = "Routine Checkup"
        appointment["nameOfDoctor"] = doctor["title"] + doctor["lastname"]
        appointment["date"] = doctor["date"]
        appointment["phoneNumber"] = doctor["phone"]
        appointment["location"] = doctor["address"]
        appointment["notes"] = "Yearly blood test"
        return str(appointment)
    


    # demo
    #return str(appointment)
    return res["output"]["message"]["content"][0]["text"]
