USE animal_shelter;

DROP TABLE IF EXISTS animal_history;
DROP TABLE IF EXISTS animal_care_schedule;
DROP TABLE IF EXISTS animal_health_schedule;
DROP TABLE IF EXISTS animal_health_history;
DROP TABLE IF EXISTS animal_behavior_history;
DROP TABLE IF EXISTS animal_features;
DROP TABLE IF EXISTS staff_log;
DROP TABLE IF EXISTS staff_animal_care_schedule;
DROP TABLE IF EXISTS animals;
DROP TABLE IF EXISTS staff;


-- CREATE TABLES
CREATE TABLE animals
        (animal_id smallint NOT NULL AUTO_INCREMENT PRIMARY KEY,
        animal_name varchar(20),
        breed varchar(50),
        adoption_status varchar(20),
        d_o_b date
        );

CREATE TABLE animal_history 
        (animal_id smallint,
        vaccination_status char(1),
        FOREIGN KEY(animal_id) 
                REFERENCES animals(animal_id)
                ON DELETE CASCADE
        );

CREATE TABLE animal_health_history 
        (animal_id smallint,
        FOREIGN KEY(animal_id) 
                REFERENCES animals(animal_id)
                ON DELETE CASCADE,
        health_problems varchar(200)
        );

CREATE TABLE animal_behavior_history 
        (animal_id smallint,
        FOREIGN KEY(animal_id) 
                REFERENCES animals(animal_id)
                ON DELETE CASCADE,
        behavior_problems varchar(200)
        );

CREATE TABLE animal_features 
        (animal_id smallint,
        FOREIGN KEY(animal_id) 
                REFERENCES animals(animal_id)
                ON DELETE CASCADE,
        fur_color varchar(20),
        eye_color varchar(20)
        );

CREATE TABLE staff
        (staff_id smallint NOT NULL AUTO_INCREMENT PRIMARY KEY,
        first_name   varchar(20),
        last_name   varchar(20),
        email varchar(30) UNIQUE,
        job_title varchar(50),
        salary mediumint,
        volunteer varchar(1)
        GENERATED ALWAYS AS 
                (CASE WHEN salary = 0 THEN
                        'y'
                WHEN salary != 0 THEN
                        'n'
                END )
        );

CREATE TABLE staff_log 
        (staff_id smallint,
        hours_worked tinyint,
        scheduled_date date,
        FOREIGN KEY(staff_id) 
                REFERENCES staff(staff_id)
                ON DELETE CASCADE
        );

CREATE TABLE staff_animal_care_schedule
        (staff_id smallint,
        animal_id smallint,
        activity varchar(100),
        date_time datetime,
        duration tinyint,
        FOREIGN KEY(staff_id) 
                REFERENCES staff(staff_id)
                ON DELETE CASCADE,
        FOREIGN KEY(animal_id) 
                REFERENCES animals(animal_id)
                ON DELETE CASCADE
        );




-- INSERT TEST DATA
INSERT INTO animals(animal_name, breed, adoption_status, d_o_b)
        VALUES 
                ('Kaya','black lab pit mix','adopted','2017-9-18'),
                ('Wyatt','rhodesian ridgeback','adopted','2010-5-23'),
                ('Jake','golden rtriever','in-shelter','2014-12-3'),
                ('Sam','presa canario','adopted','2020-5-3'),
                ('Spot','border collie german shepherd mix','in-trial','2021-10-22');


INSERT INTO animal_history(animal_id,vaccination_status)
        VALUES 
                (1,'y'),
                (2,'n'),
                (3,'y'),
                (4,'y'),
                (5,'n');


INSERT INTO animal_health_history(animal_id, health_problems)
        VALUES 
                (1,'None'),
                (2,'Suffers from stomach cramps. '),
                (3,'Lethargic and has arthritis.'),
                (4,'None'),
                (5,'Propensity for rashes and irritated skin.');


INSERT INTO animal_behavior_history(animal_id, behavior_problems)
        VALUES 
                (1,'Very energetic and propensity to jump.'),
                (2,'Very mellow and well natured.'),
                (3,'Barks often, but is friendly.'),
                (4,'None'),
                (5,'A bit hard to handle, needs space to roam.');


INSERT INTO animal_features(animal_id, fur_color, eye_color)
        VALUES 
                (1,'black', 'brown'),
                (2,'brown','brown'),
                (3,'gold','blue'),
                (4,'tan','brown'),
                (5,'marbled','black');


INSERT INTO staff(first_name,last_name,email,job_title,salary)
        VALUES 
                ('Robert', 'Smith','rsmith@gmail.com', 'Head Veterinarian', 75000),
                ('Tim', 'Lee', 'tlvet@vets.com','Assistant Veterinarian', 50000),
                ('Rachael', 'Jones','rachael123@yahoo.com', 'None', 0),
                ('Sarah', 'Davis','sdavis@gmail.com', 'Secretary', 45000),
                ('Sam', 'Brown','sambrown@yahoo.com', 'None', 0);


INSERT INTO staff_log(staff_id, hours_worked, scheduled_date)
        VALUES
            (1,6,'2021-10-10'),
            (2,8,'2021-10-17'),
            (3,4,'2021-10-12'),
            (4,7,'2021-10-7'),
            (5,6,'2021-11-22'),
            (5,10,'2021-10-22');


INSERT INTO staff_animal_care_schedule(staff_id, animal_id, activity, date_time, duration)
        VALUES
            (1,2,'checkup','2021-10-29 10:30:00',1),
            (2,2,'nail trimming, cleaning, and checkup','2021-10-12 13:00:00',2),
            (3,1,'walk','2021-10-29 16:00:00',2),
            (2,4,'tooth cleaning','2021-11-12 15:15:00',1),
            (5,5,'walk','2021-11-18 9:00:00',1);



-- DEFINE FUNCTION, VIEW, and PROCEDURE 


-- This function returns the full name of an employee from their ID
DROP FUNCTION IF EXISTS find_name;
DELIMITER $$
CREATE FUNCTION find_name(staff_id smallint) 
RETURNS varchar(200)
DETERMINISTIC
BEGIN
        return 
        (SELECT 
                CONCAT(first_name," ",last_name) 
        FROM 
                staff where staff_id = staff_id
        LIMIT 1);
        
END $$
DELIMITER ;



-- Procedure finds a dog with a specific fur color
DROP PROCEDURE IF EXISTS find_color;
DELIMITER $$
CREATE PROCEDURE find_color
(fur_color varchar(20))
BEGIN
        SELECT 
                features.animal_id AS "Animal ID",
                animal.animal_name AS "Name"
        FROM
                animal_features features
        JOIN animals animal
        ON features.animal_id = animal.animal_id
        WHERE features.fur_color = fur_color;

END $$
DELIMITER ;




-- This view shows the number of appointments an animal has along with their name
DROP VIEW IF EXISTS number_of_appointments;
CREATE VIEW number_of_appointments
AS 
SELECT 
        schedule.animal_id AS "Animal ID",
        COUNT(*) AS Count,
        animal.animal_name AS "Name"
FROM
        staff_animal_care_schedule schedule
JOIN animals animal
ON
        schedule.animal_id = animal.animal_id
GROUP BY
        schedule.animal_id;


