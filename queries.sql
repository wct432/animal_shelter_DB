USE animal_shelter;


-- Select the id's of animals that have no behavioural or mental problems 
SELECT  
        animal_id,
        behavior_problems 
FROM animal_behavior_history
WHERE behavior_problems = 'None'
UNION
SELECT  animal_id,
        health_problems
FROM animal_health_history
WHERE health_problems = 'None';


-- This query will select the id, Name, Eye Color and Fur Color
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


-- find number of unique fur colors
SELECT 
        COUNT(DISTINCT fur_color) AS "Unique Fur Colors"
FROM animal_features;


-- find staff who are not scheduled using left join
SELECT staff.staff_id 
FROM   staff staff
LEFT JOIN staff_animal_care_schedule schedule
ON 
    staff.staff_id = schedule.staff_id
WHERE
    schedule.staff_id IS null;


-- this query will show the last name, salary and the hours worked of staff
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


-- this query will select staff names and  of volunteers (their salary = 0)
SELECT  
        staff_id,
        last_name,
        salary
FROM staff
GROUP BY staff_id
HAVING salary = 0;


-- This query will select the name and id of any animal that has any
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


-- sets the animal's status with the id 3 to adopted
UPDATE animals
SET adoption_status = 'adopted'
WHERE animal_id = 3;