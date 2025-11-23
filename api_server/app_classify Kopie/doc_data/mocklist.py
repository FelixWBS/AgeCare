import random


doctors_database = doctors_database = [
    {"id": 1, "postgrad": "Dr.", "firstname": "Anna", "lastname": "Müller", "expertise": "Cardiology",
     "open_timeslots": ["2025-11-25T09:00:00Z","2025-11-25T14:00:00Z","2025-11-26T11:00:00Z",
                        "2025-12-01T09:30:00Z","2025-12-02T14:00:00Z","2025-12-04T10:00:00Z"],
     "address": "Theresienstr. 12, 80333 München", "phone": "+49 89 1234567"},

    {"id": 2, "postgrad": "Dr.", "firstname": "Max", "lastname": "Schneider", "expertise": "Dermatology",
     "open_timeslots": ["2025-11-24T10:00:00Z","2025-11-25T13:30:00Z","2025-11-27T15:00:00Z",
                        "2025-12-01T11:00:00Z","2025-12-03T09:00:00Z","2025-12-05T15:30:00Z"],
     "address": "Leopoldstr. 45, 80802 München", "phone": "+49 89 7654321"},

    {"id": 3, "postgrad": "Prof. Dr.", "firstname": "Eva", "lastname": "Bauer", "expertise": "Neurology",
     "open_timeslots": ["2025-11-26T09:30:00Z","2025-11-26T13:00:00Z","2025-11-28T14:30:00Z",
                        "2025-12-02T10:00:00Z","2025-12-04T13:30:00Z","2025-12-06T09:00:00Z"],
     "address": "Schwanthalerstr. 101, 80339 München", "phone": "+49 89 2345678"},

    {"id": 4, "postgrad": "Dr.", "firstname": "Lukas", "lastname": "Fischer", "expertise": "Pediatrics",
     "open_timeslots": ["2025-11-25T08:30:00Z","2025-11-27T12:00:00Z","2025-11-29T10:00:00Z",
                        "2025-12-01T08:00:00Z","2025-12-03T12:30:00Z","2025-12-04T09:30:00Z"],
     "address": "Hohenzollernstr. 35, 80801 München", "phone": "+49 89 8765432"},

    {"id": 5, "postgrad": "Dr.", "firstname": "Sophie", "lastname": "Weber", "expertise": "General Medicine",
     "open_timeslots": ["2025-11-24T09:00:00Z","2025-11-25T15:30:00Z","2025-11-28T11:00:00Z",
                        "2025-12-01T10:00:00Z","2025-12-02T15:00:00Z","2025-12-05T11:30:00Z"],
     "address": "Sendlinger Str. 20, 80331 München", "phone": "+49 89 3456789"},

    {"id": 6, "postgrad": "Dr.", "firstname": "Johann", "lastname": "Klein", "expertise": "Internal Medicine",
     "open_timeslots": ["2025-12-01T09:00:00Z","2025-12-03T11:00:00Z","2025-12-07T14:00:00Z"],
     "address": "Kurfürstenstr. 12, 80336 München", "phone": "+49 89 1112223"},

    {"id": 7, "postgrad": "Dr.", "firstname": "Clara", "lastname": "Richter", "expertise": "Gastroenterology",
     "open_timeslots": ["2025-12-02T08:30:00Z","2025-12-04T13:00:00Z","2025-12-08T10:30:00Z"],
     "address": "Rosenheimer Str. 10, 81669 München", "phone": "+49 89 2223334"},

    {"id": 8, "postgrad": "Dr.", "firstname": "Peter", "lastname": "Lang", "expertise": "Pulmonology",
     "open_timeslots": ["2025-12-01T10:00:00Z","2025-12-05T14:30:00Z","2025-12-09T09:00:00Z"],
     "address": "Domagkstr. 20, 80807 München", "phone": "+49 89 4445556"},

    {"id": 9, "postgrad": "Dr.", "firstname": "Marta", "lastname": "Kovács", "expertise": "Endocrinology",
     "open_timeslots": ["2025-12-03T09:30:00Z","2025-12-06T11:30:00Z","2025-12-10T15:00:00Z"],
     "address": "Kaiserstr. 15, 80331 München", "phone": "+49 89 777888"},

    {"id": 10, "postgrad": "Dr.", "firstname": "Felix", "lastname": "Neumann", "expertise": "Nephrology",
     "open_timeslots": ["2025-12-02T12:00:00Z","2025-12-04T09:00:00Z","2025-12-09T13:30:00Z"],
     "address": "Bismarckallee 3, 80333 München", "phone": "+49 89 998877"},

    {"id": 11, "postgrad": "Dr.", "firstname": "Helga", "lastname": "Brandt", "expertise": "Rheumatology",
     "open_timeslots": ["2025-12-01T14:00:00Z","2025-12-06T10:00:00Z","2025-12-08T12:30:00Z"],
     "address": "Ringbahnstr. 22, 80339 München", "phone": "+49 89 3334445"},

    {"id": 12, "postgrad": "Dr.", "firstname": "Martin", "lastname": "Weiss", "expertise": "Hematology",
     "open_timeslots": ["2025-12-02T09:00:00Z","2025-12-05T11:00:00Z","2025-12-07T15:00:00Z"],
     "address": "Ludwigstr. 6, 80333 München", "phone": "+49 89 5556667"},

    {"id": 13, "postgrad": "Dr.", "firstname": "Laura", "lastname": "Fischer", "expertise": "Oncology",
     "open_timeslots": ["2025-12-03T13:00:00Z","2025-12-06T09:30:00Z","2025-12-10T11:00:00Z"],
     "address": "Zeppelinstraße 3, 80333 München", "phone": "+49 89 444000"},

    {"id": 14, "postgrad": "Dr.", "firstname": "Daniel", "lastname": "Kramer", "expertise": "Infectious Diseases",
     "open_timeslots": ["2025-12-01T11:30:00Z","2025-12-04T16:00:00Z","2025-12-08T09:00:00Z"],
     "address": "Königsallee 12, 80336 München", "phone": "+49 89 7771234"},

    {"id": 15, "postgrad": "Dr.", "firstname": "Günter", "lastname": "Schwarz", "expertise": "Geriatrics",
     "open_timeslots": ["2025-12-02T10:30:00Z","2025-12-05T14:00:00Z","2025-12-09T08:00:00Z"],
     "address": "Alte Leipziger Str. 1, 80331 München", "phone": "+49 89 111222"},

    {"id": 16, "postgrad": "Dr.", "firstname": "Rosa", "lastname": "Hoffmann", "expertise": "General Surgery",
     "open_timeslots": ["2025-12-01T07:30:00Z","2025-12-03T08:30:00Z","2025-12-07T13:00:00Z"],
     "address": "Hauptbahnhofstr. 2, 80331 München", "phone": "+49 89 222333"},

    {"id": 17, "postgrad": "Prof. Dr.", "firstname": "Andreas", "lastname": "Berg", "expertise": "Orthopedic Surgery",
     "open_timeslots": ["2025-12-02T09:00:00Z","2025-12-04T14:30:00Z","2025-12-08T10:00:00Z"],
     "address": "Friedrichstr. 20, 80331 München", "phone": "+49 89 6667778"},

    {"id": 18, "postgrad": "Dr.", "firstname": "Sven", "lastname": "Maier", "expertise": "Trauma Surgery",
     "open_timeslots": ["2025-12-01T12:00:00Z","2025-12-05T09:00:00Z","2025-12-09T14:00:00Z"],
     "address": "Hafenstr. 8, 80333 München", "phone": "+49 89 444888"},

    {"id": 19, "postgrad": "Dr.", "firstname": "Irina", "lastname": "Popov", "expertise": "Vascular Surgery",
     "open_timeslots": ["2025-12-03T10:00:00Z","2025-12-06T13:00:00Z","2025-12-10T09:30:00Z"],
     "address": "Maximilianstr. 7, 80333 München", "phone": "+49 89 5554443"},

    {"id": 20, "postgrad": "Prof. Dr.", "firstname": "Thomas", "lastname": "Keller", "expertise": "Neurosurgery",
     "open_timeslots": ["2025-12-02T11:00:00Z","2025-12-05T15:00:00Z","2025-12-08T09:00:00Z"],
     "address": "Kriegsstr. 20, 80336 München", "phone": "+49 89 999000"},

    {"id": 21, "postgrad": "Dr.", "firstname": "Nora", "lastname": "Lang", "expertise": "Plastic & Reconstructive Surgery",
     "open_timeslots": ["2025-12-01T13:30:00Z","2025-12-04T10:00:00Z","2025-12-09T11:30:00Z"],
     "address": "Opernring 5, 80333 München", "phone": "+49 89 3332221"},

    {"id": 22, "postgrad": "Dr.", "firstname": "Maximilian", "lastname": "Voss", "expertise": "Cardiothoracic Surgery",
     "open_timeslots": ["2025-12-03T08:00:00Z","2025-12-06T12:30:00Z","2025-12-10T14:00:00Z"],
     "address": "Burgstr. 4, 80333 München", "phone": "+49 89 444333"},

    {"id": 23, "postgrad": "Dr.", "firstname": "Anna-Lena", "lastname": "Schulz", "expertise": "ENT (Ear, Nose & Throat)",
     "open_timeslots": ["2025-12-02T08:30:00Z","2025-12-05T10:30:00Z","2025-12-07T13:00:00Z"],
     "address": "Lange Str. 9, 80336 München", "phone": "+49 89 888777"},

    {"id": 24, "postgrad": "Dr.", "firstname": "Sofia", "lastname": "Meyer", "expertise": "Ophthalmology",
     "open_timeslots": ["2025-12-01T09:00:00Z","2025-12-04T11:00:00Z","2025-12-08T15:00:00Z"],
     "address": "Neue Straße 2, 80331 München", "phone": "+49 89 999111"},

    {"id": 25, "postgrad": "Dr.", "firstname": "Stefan", "lastname": "Brand", "expertise": "Urology",
     "open_timeslots": ["2025-12-03T09:00:00Z","2025-12-06T14:00:00Z","2025-12-10T10:00:00Z"],
     "address": "Marktplatz 1, 80331 München", "phone": "+49 89 777888"},

    {"id": 26, "postgrad": "Dr.", "firstname": "Eva-Maria", "lastname": "Kuhn", "expertise": "Obstetrics & Gynecology",
     "open_timeslots": ["2025-12-01T11:00:00Z","2025-12-05T09:30:00Z","2025-12-09T12:00:00Z"],
     "address": "Friedrich-Ebert-Allee 30, 80333 München", "phone": "+49 89 444555"},

    {"id": 27, "postgrad": "Dr.", "firstname": "Oliver", "lastname": "Frank", "expertise": "Radiology",
     "open_timeslots": ["2025-12-02T13:00:00Z","2025-12-06T08:30:00Z","2025-12-08T11:00:00Z"],
     "address": "Rheinstraße 7, 80331 München", "phone": "+49 89 333666"},

    {"id": 28, "postgrad": "Dr.", "firstname": "Miriam", "lastname": "Hart", "expertise": "Nuclear Medicine",
     "open_timeslots": ["2025-12-03T10:30:00Z","2025-12-07T14:30:00Z","2025-12-10T09:00:00Z"],
     "address": "An der Alster 20, 80333 München", "phone": "+49 89 777666"},

    {"id": 29, "postgrad": "Dr.", "firstname": "Klaus", "lastname": "Richter", "expertise": "Pathology",
     "open_timeslots": ["2025-12-01T15:00:00Z","2025-12-04T09:00:00Z","2025-12-08T13:30:00Z"],
     "address": "Universitätsring 5, 80333 München", "phone": "+49 89 555222"},

    {"id": 30, "postgrad": "Dr.", "firstname": "Bianca", "lastname": "Engel", "expertise": "Laboratory Medicine",
     "open_timeslots": ["2025-12-02T09:00:00Z","2025-12-05T13:00:00Z","2025-12-09T15:00:00Z"],
     "address": "Bergstraße 12, 80331 München", "phone": "+49 89 888000"},

    {"id": 31, "postgrad": "Dr.", "firstname": "Wolfgang", "lastname": "Arnold", "expertise": "Anesthesiology",
     "open_timeslots": ["2025-12-01T07:00:00Z","2025-12-03T12:00:00Z","2025-12-06T16:00:00Z"],
     "address": "Kalkhof 4, 80333 München", "phone": "+49 89 444999"},

    {"id": 32, "postgrad": "Dr.", "firstname": "Julia", "lastname": "Bergmann", "expertise": "Child & Adolescent Psychiatry",
     "open_timeslots": ["2025-12-02T10:00:00Z","2025-12-04T14:00:00Z","2025-12-09T09:30:00Z"],
     "address": "Görlitzer Str. 1, 80333 München", "phone": "+49 89 222999"}

]


def find_doctors_by_expertise(expertise, database=doctors_database):
    """
    Returns a list of doctor entries that match the given expertise.
    
    Args:
        expertise (str): The medical specialty to search for.
        database (list): The doctors_database list.

    Returns:
        list: A list of doctors with the matching expertise.
    """
    expertise_normalized = expertise.strip().lower()

    return [
        doctor for doctor in database
        if doctor["expertise"].lower() == expertise_normalized
    ]

def return_random_appointment(options):
    """
    Returns a random appointment from a list of available options.
    
    Args:
        options (list): A list of appointment times (strings).
    
    Returns:
        str or None: A randomly chosen appointment time, or None if list is empty.
    """
    if not options:
        return None  # Alternativ: raise ValueError("No appointment options available")
    
    return random.choice(options)
