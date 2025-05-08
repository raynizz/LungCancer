-- Створення унікальних записів у таблиці lifestyle
INSERT INTO safe.dim_lifestyle (smoking, alcohol_consuming, peer_pressure, lifestyle_name) VALUES
(false, false, false, 'Healthy Lifestyle'),
(true,  false, false, 'Smoker'),
(false, true,  false, 'Drinker'),
(false, false, true,  'Pressured'),
(true,  true,  false, 'Smoker Drinker'),
(true,  false, true,  'Smoker Pressured'),
(false, true,  true,  'Drinker Pressured'),
(true,  true,  true,  'Risky Lifestyle')
ON CONFLICT DO NOTHING;

-- Імпортування унікальних записів у таблиці статей
INSERT INTO safe.dim_gender (gender)
SELECT DISTINCT
    CASE
        WHEN LOWER(gender) IN ('m', 'male') THEN 'Male'
        WHEN LOWER(gender) IN ('f', 'female') THEN 'Female'
    END
FROM (
    SELECT gender FROM stage.lung_cancer_info1
    UNION ALL
    SELECT gender FROM stage.lung_cancer_info2
    UNION ALL
    SELECT gender FROM stage.survey_lung_cancer
) AS genders
WHERE gender IS NOT NULL
  AND LOWER(gender) IN ('m', 'male', 'f', 'female')
ON CONFLICT DO NOTHING;

-- Імпортування унікальних записів в таблиці пацієнтів
INSERT INTO safe.dim_patients (gender_id, age)
SELECT
    g.id,
    s.age
FROM (
    SELECT DISTINCT gender, age FROM stage.lung_cancer_info1
    UNION ALL
    SELECT DISTINCT gender, age FROM stage.lung_cancer_info2
    UNION ALL
    SELECT DISTINCT gender, age FROM stage.survey_lung_cancer
) s
JOIN safe.dim_gender g
  ON g.gender = CASE
                  WHEN LOWER(s.gender) IN ('m', 'male') THEN 'Male'
                  ELSE 'Female'
                END;

-- Імпортування унікальних записів в таблиці медичних станів
INSERT INTO safe.dim_medical_conditions (
    anxiety, yellow_fingers, chronic_disease, fatigue, allergy,
    wheezing, coughing, shortness_of_breath, swallowing_difficulty, chest_pain
)
SELECT DISTINCT
    CASE WHEN LOWER(anxiety) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END,
    CASE WHEN LOWER(yellow_fingers) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END,
    CASE WHEN LOWER(chronic_disease) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END,
    CASE WHEN LOWER(fatigue) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END,
    CASE WHEN LOWER(allergy) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END,
    CASE WHEN LOWER(wheezing) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END,
    CASE WHEN LOWER(coughing) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END,
    CASE WHEN LOWER(shortness_of_breath) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END,
    CASE WHEN LOWER(swallowing_difficulty) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END,
    CASE WHEN LOWER(chest_pain) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END
FROM (
    SELECT
        anxiety::TEXT,
        yellow_fingers::TEXT,
        chronic_disease::TEXT,
        fatigue::TEXT,
        allergy::TEXT,
        wheezing::TEXT,
        coughing::TEXT,
        shortness_of_breath::TEXT,
        swallowing_difficulty::TEXT,
        chest_pain::TEXT
    FROM stage.lung_cancer_info1

    UNION ALL

    SELECT
        anxiety::TEXT,
        yellow_fingers::TEXT,
        chronic_disease::TEXT,
        fatigue::TEXT,
        allergy::TEXT,
        wheezing::TEXT,
        coughing::TEXT,
        shortness_of_breath::TEXT,
        swallowing_difficulty::TEXT,
        chest_pain::TEXT
    FROM stage.lung_cancer_info2

    UNION ALL

    SELECT
        anxiety::TEXT,
        yellow_fingers::TEXT,
        chronic_disease::TEXT,
        fatigue::TEXT,
        allergy::TEXT,
        wheezing::TEXT,
        coughing::TEXT,
        shortness_of_breath::TEXT,
        swallowing_difficulty::TEXT,
        chest_pain::TEXT
    FROM stage.survey_lung_cancer
) AS med;

-- Імпортування унікальних записів в таблиці діагнозів
INSERT INTO safe.dim_diagnosis (lung_cancer)
SELECT DISTINCT
    CASE
        WHEN LOWER(lung_cancer) IN ('yes', 'lung cancer') THEN 'Lung cancer patient'
        ELSE 'Healthy'
    END
FROM (
    SELECT lung_cancer FROM stage.lung_cancer_info1
    UNION ALL
    SELECT lung_cancer FROM stage.lung_cancer_info2
    UNION ALL
    SELECT lung_cancer FROM stage.survey_lung_cancer
) AS diag
WHERE lung_cancer IS NOT NULL
ON CONFLICT DO NOTHING;

-- Імпортування даних в таблицю фактів захворювання на рак легень
INSERT INTO safe.facts_lung_cancer_facts (patient_id, lifestyle_id, medical_id, diagnosis_id)
SELECT
    p.id AS patient_id,
    l.id AS lifestyle_id,
    m.id AS medical_id,
    d.id AS diagnosis_id
FROM (
    SELECT DISTINCT gender, age,
        CASE WHEN LOWER(smoking) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END AS smoking,
        CASE WHEN LOWER(alcohol_consuming) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END AS alcohol_consuming,
        CASE WHEN LOWER(peer_pressure) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END AS peer_pressure,

        CASE WHEN LOWER(anxiety) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END AS anxiety,
        CASE WHEN LOWER(yellow_fingers) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END AS yellow_fingers,
        CASE WHEN LOWER(chronic_disease) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END AS chronic_disease,
        CASE WHEN LOWER(fatigue) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END AS fatigue,
        CASE WHEN LOWER(allergy) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END AS allergy,
        CASE WHEN LOWER(wheezing) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END AS wheezing,
        CASE WHEN LOWER(coughing) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END AS coughing,
        CASE WHEN LOWER(shortness_of_breath) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END AS shortness_of_breath,
        CASE WHEN LOWER(swallowing_difficulty) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END AS swallowing_difficulty,
        CASE WHEN LOWER(chest_pain) IN ('yes', '2', 'true') THEN TRUE ELSE FALSE END AS chest_pain,

        CASE WHEN LOWER(lung_cancer) IN ('yes', 'lung cancer') THEN 'Lung cancer patient' ELSE 'Healthy' END AS lung_cancer_status
    FROM stage.lung_cancer_info1
    UNION ALL
    SELECT DISTINCT gender, age,
        smoking::boolean, alcohol_consuming::boolean, peer_pressure::boolean,
        anxiety::boolean, yellow_fingers::boolean, chronic_disease::boolean, fatigue::boolean, allergy::boolean,
        wheezing::boolean, coughing::boolean, shortness_of_breath::boolean, swallowing_difficulty::boolean, chest_pain::boolean,
        CASE WHEN LOWER(lung_cancer) IN ('yes', 'lung cancer') THEN 'Lung cancer patient' ELSE 'Healthy' END AS lung_cancer_status
    FROM stage.lung_cancer_info2
    UNION ALL
    SELECT DISTINCT gender, age,
        smoking::boolean, alcohol_consuming::boolean, peer_pressure::boolean,
        anxiety::boolean, yellow_fingers::boolean, chronic_disease::boolean, fatigue::boolean, allergy::boolean,
        wheezing::boolean, coughing::boolean, shortness_of_breath::boolean, swallowing_difficulty::boolean, chest_pain::boolean,
        CASE WHEN LOWER(lung_cancer) IN ('yes', 'lung cancer') THEN 'Lung cancer patient' ELSE 'Healthy' END AS lung_cancer_status
    FROM stage.survey_lung_cancer
) AS all_data
JOIN safe.dim_gender g ON g.gender = CASE WHEN LOWER(all_data.gender) IN ('m', 'male') THEN 'Male' ELSE 'Female' END
JOIN safe.dim_patients p ON p.gender_id = g.id AND p.age = all_data.age
JOIN safe.dim_lifestyle l ON l.smoking = all_data.smoking AND l.alcohol_consuming = all_data.alcohol_consuming AND l.peer_pressure = all_data.peer_pressure
JOIN safe.dim_medical_conditions m ON
    m.anxiety = all_data.anxiety AND
    m.yellow_fingers = all_data.yellow_fingers AND
    m.chronic_disease = all_data.chronic_disease AND
    m.fatigue = all_data.fatigue AND
    m.allergy = all_data.allergy AND
    m.wheezing = all_data.wheezing AND
    m.coughing = all_data.coughing AND
    m.shortness_of_breath = all_data.shortness_of_breath AND
    m.swallowing_difficulty = all_data.swallowing_difficulty AND
    m.chest_pain = all_data.chest_pain
JOIN safe.dim_diagnosis d ON d.lung_cancer = all_data.lung_cancer_status;