import pandas as pd
import random
from datetime import datetime, timedelta

normal_doc = {
    "title": "Dr.",
    "first_name": "Manuel",
    "lastname": "Neuer",
    "specialty": "family doctor",
    "address": "Marienplatz 1",
    "phone": "+49 89 372736",
}

def get_random_workday_next_week():
    today = datetime.today()
    # Find next Monday
    days_ahead = 0 - today.weekday() + 7  # 0 = Monday
    next_monday = today + timedelta(days=days_ahead)
    
    # Generate random workday offset (0-4)
    random_offset = random.randint(0, 4)
    random_workday = next_monday + timedelta(days=random_offset)
    
    # Return in ISO format
    return random_workday.strftime("%Y-%m-%d")

def search_for_doc(special: str):
    # Load CSV
    df = pd.read_csv("doc_data/mock_doctors_munich_english_specialties.csv")

    # HERE!!!!
    # Normalize specialty strings
    df["specialty"] = df["specialty"].str.strip().str.lower()
    special = special.strip().lower()

    # Truncate address after first comma
    df["address"] = df["address"].apply(lambda x: str(x).split(",")[0].strip())

    # Find matching doctors
    doctors = df[df["specialty"] == special]

    # Default result
    res = normal_doc.copy()  # use copy to avoid modifying the original dict

    # If at least one match exists, extract the first row as a dict
    if len(doctors) > 0:
        res = doctors.iloc[0].to_dict()

    # Append random workday next week
    res["date"] = get_random_workday_next_week()

    print(res)
    return res
