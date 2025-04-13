CREATE TABLE safe.dim_gender (
    id SERIAL PRIMARY KEY,
    gender CHAR(10) CHECK (gender IN ('Male', 'Female'))
);

CREATE TABLE safe.dim_patients (
    id SERIAL PRIMARY KEY,
    gender_id INT REFERENCES safe.dim_gender(id),
    age INT CHECK (age > 0)
);

CREATE TABLE safe.dim_lifestyle (
    id SERIAL PRIMARY KEY,
    smoking BOOLEAN,
    alcohol_consuming BOOLEAN,
    peer_pressure BOOLEAN,
    lifestyle_name VARCHAR(50) UNIQUE
);

CREATE TABLE safe.dim_medical_conditions (
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

CREATE TABLE safe.dim_diagnosis (
    id SERIAL PRIMARY KEY,
    lung_cancer VARCHAR(55) CHECK (lung_cancer IN ('Lung cancer patient', 'Healthy'))
);

CREATE TABLE safe.facts_lung_cancer_facts (
    id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES safe.dim_patients(id),
    lifestyle_id INT REFERENCES safe.dim_lifestyle(id),
    medical_id INT REFERENCES safe.dim_medical_conditions(id),
    diagnosis_id INT REFERENCES safe.dim_diagnosis(id)
);