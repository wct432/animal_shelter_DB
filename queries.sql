USE animal_shelter;

-- Call our find_name function 
SELECT find_name(3) FROM staff LIMIT 1;


-- Call our find_color procedure
CALL find_color('brown');

-- View our number_of_appointments view which shows how many
-- appointments each animal has
SELECT * FROM number_of_appointments;


-- Query 1. Select the id's of animals that have no behavioural or mental problems 
SELECT  
        animal_id,
        behavior_problems as Problems 
FROM animal_behavior_history
WHERE behavior_problems = 'None'
UNION
SELECT  animal_id,
        health_problems
FROM animal_health_history
WHERE health_problems = 'None';


-- Query 2. This query will select the id, Name, Eye Color and Fur Color
-- of any Rhodesian Ridgeback with brown eyes 
SELECT 
        animal.animal_id,
        animal.animal_name as Name,
        feature.eye_color as "Eye Color",
        feature.fur_color as "Fur Color"
FROM animals animal
JOIN animal_features feature
ON 
    animal.animal_id = feature.animal_id
WHERE
    animal.breed = "rhodesian ridgeback"
AND 
    feature.eye_color = "brown";


-- Query 3. Find number of unique fur colors
SELECT 
        COUNT(DISTINCT fur_color) AS "Unique Fur Colors"
FROM animal_features;


-- Query 4. Find staff who are not scheduled 
SELECT 
        staff.staff_id AS "ID's of Unscheduled Staff"
FROM    staff staff
LEFT JOIN staff_animal_care_schedule schedule
ON 
    staff.staff_id = schedule.staff_id
WHERE
    schedule.staff_id IS null;


-- Query 5. This query will show the last name, salary and the hours worked of staff
SELECT  
        staff.staff_id,
        staff.last_name,
        staff.salary,
        log.hours_worked
FROM staff
LEFT JOIN
staff_log log
ON 
    staff.staff_id = log.staff_id
WHERE staff.staff_id IN (
    SELECT staff_id FROM staff_animal_care_schedule
    );


-- Query 6. This query will select staff names  of volunteers (their salary = 0)
SELECT  
        staff_id,
        last_name,
        salary
FROM staff
GROUP BY staff_id
HAVING salary = 0;


-- Query 7. This query will select the name and id of any animal that has any
-- kind of cleaning activity equal to two hours
SELECT  
        animal_id,
        animal_name
FROM animals
WHERE EXISTS
    (SELECT 
        animal_id,
            duration
    FROM staff_animal_care_schedule
    WHERE staff_animal_care_schedule.animal_id = animals.animal_id
    AND activity LIKE '%clean%'
    AND duration = 2
    );


-- Update sets the animal's status with the id 3 to adopted
UPDATE animals
SET adoption_status = 'adopted'
WHERE animal_id = 3;