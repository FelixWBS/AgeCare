from app_classify.appointment import create_appointment_json
from app_classify.classif import classify
from notify import generate_notification
from doc_data.mocklist import find_doctors_by_expertise, return_random_appointment


def handle_text(user_text: str):
    # 0. Ist Appointment erwünscht?
    yes_no = classify(user_text)
    print("CLASSIFICATION: ", yes_no)
    app = return_random_appointment(find_doctors_by_expertise(yes_no))

    # 1. Appointment erzeugen
    appointment_json = create_appointment_json(user_text, doctor=app)

    # 2. Notification aus dem Appointment bauen
    notification = generate_notification(appointment_json)

    print("json: ", appointment_json)
    print("notify: ", notification)
    return {
        "appointment": appointment_json,
        "notification": notification
    }





