CREATE TABLE safe.patients (
    id SERIAL PRIMARY KEY,
    gender CHAR(10) CHECK (gender IN ('Male', 'Female')),
    age INT CHECK (age > 0)
);

CREATE TABLE safe.lifestyle (
    id SERIAL PRIMARY KEY,
    smoking BOOLEAN,
    alcohol_consuming BOOLEAN,
    peer_pressure BOOLEAN
);

CREATE TABLE safe.medical_conditions (
    id SERIAL PRIMARY KEY,
    anxiety BOOLEAN,
    yellow_fingers BOOLEAN,
    chronic_disease BOOLEAN,
    fatigue BOOLEAN,
    allergy BOOLEAN,
    wheezing BOOLEAN,
    coughing BOOLEAN,
    shortness_of_breath BOOLEAN,
    swallowing_difficulty BOOLEAN,
    chest_pain BOOLEAN
);

CREATE TABLE safe.diagnosis (
    id SERIAL PRIMARY KEY,
    lung_cancer BOOLEAN
);

CREATE TABLE safe.lung_cancer_facts (
    id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES safe.patients(id),
    lifestyle_id INT REFERENCES safe.lifestyle(id),
    medical_id INT REFERENCES safe.medical_conditions(id),
    diagnosis_id INT REFERENCES safe.diagnosis(id)
);