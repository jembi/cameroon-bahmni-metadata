SET @nursesalt = (SHA2(SUBSTRING(MD5(RAND()), -10), 512));
SET @doctorsalt = (SHA2(SUBSTRING(MD5(RAND()), -10), 512));
SET @receptionsalt = (SHA2(SUBSTRING(MD5(RAND()), -10), 512));
INSERT IGNORE INTO person (uuid,gender,date_created,creator) VALUES ('3f64faba-ad31-11e9-a2a3-2a2ae2dbcce4','F',NOW(),('4'));
INSERT IGNORE INTO person_name (person_id,uuid,given_name,family_name) 
VALUES
((SELECT person_id FROM person WHERE uuid = '3f64faba-ad31-11e9-a2a3-2a2ae2dbcce4'),(uuid()),('Nurse'),(''));
INSERT IGNORE INTO person (uuid,gender,date_created,creator) VALUES ('3f64fd1c-ad31-11e9-a2a3-2a2ae2dbcce4','F',NOW(),('4'));
INSERT IGNORE INTO person_name (person_id,uuid,given_name,family_name) 
VALUES
((SELECT person_id FROM person WHERE uuid = '3f64fd1c-ad31-11e9-a2a3-2a2ae2dbcce4'),(uuid()),('Doctor'),(''));
INSERT IGNORE INTO person (uuid,gender,date_created,creator) VALUES ('3f64fe70-ad31-11e9-a2a3-2a2ae2dbcce4','F',NOW(),('4'));
INSERT IGNORE INTO person_name (person_id,uuid,given_name,family_name) 
VALUES
((SELECT person_id FROM person WHERE uuid = '3f64fe70-ad31-11e9-a2a3-2a2ae2dbcce4'),(uuid()),('Reception'),(''));
INSERT IGNORE INTO users (system_id,username,password,salt,date_created,uuid,person_id,creator)
VALUES 
('Nurse', 'Nurse', SHA2(CONCAT('Nurse#123',@nursesalt), 512), @nursesalt, NOW(), '3bfbd6ec-ad1c-11e9-a2a3-2a2ae2dbcce4',(SELECT person_id FROM person WHERE uuid = '3f64faba-ad31-11e9-a2a3-2a2ae2dbcce4'),('4')),
('Doctor', 'Doctor', SHA2(CONCAT('Doctor#123',@doctorsalt), 512), @doctorsalt, NOW(), '3bfbdbba-ad1c-11e9-a2a3-2a2ae2dbcce4',(SELECT person_id FROM person WHERE uuid = '3f64fd1c-ad31-11e9-a2a3-2a2ae2dbcce4'),('4')),
('Reception', 'Reception', SHA2(CONCAT('Reception#123',@receptionsalt), 512), @receptionsalt, NOW(), '3bfbdd40-ad1c-11e9-a2a3-2a2ae2dbcce4',(SELECT person_id FROM person WHERE uuid = '3f64fe70-ad31-11e9-a2a3-2a2ae2dbcce4'),('4'));
INSERT IGNORE INTO provider 
(person_id,creator,date_created,uuid)
VALUES
((SELECT person_id FROM person WHERE uuid = '3f64faba-ad31-11e9-a2a3-2a2ae2dbcce4'),'4',NOW(),'1ad6aa26-adfa-11e9-a2a3-2a2ae2dbcce4'),
((SELECT person_id FROM person WHERE uuid = '3f64fd1c-ad31-11e9-a2a3-2a2ae2dbcce4'),'4',NOW(),'1ad6ac88-adfa-11e9-a2a3-2a2ae2dbcce4'),
((SELECT person_id FROM person WHERE uuid = '3f64fe70-ad31-11e9-a2a3-2a2ae2dbcce4'),'4',NOW(),'1ad6adf0-adfa-11e9-a2a3-2a2ae2dbcce4');
INSERT IGNORE INTO user_role (user_id,role)
VALUES 
((SELECT user_id FROM users WHERE username = 'Nurse'),
('Appointments:FullAccess')),
((SELECT user_id FROM users WHERE username = 'Nurse'),
('Clinical-App')),
((SELECT user_id FROM users WHERE username = 'Nurse'),
('PatientDocuments-App')),
((SELECT user_id FROM users WHERE username = 'Nurse'),
('Programs-App')),
((SELECT user_id FROM users WHERE username = 'Nurse'),
('Reports-App')),
((SELECT user_id FROM users WHERE username = 'Nurse'),
('Registration-App')),
((SELECT user_id FROM users WHERE username = 'Nurse'),
('Clinical-App-Bacteriology')),
((SELECT user_id FROM users WHERE username = 'Nurse'),
('Clinical-App-Diagnosis')),
((SELECT user_id FROM users WHERE username = 'Nurse'),
('Clinical-App-Observations')),
((SELECT user_id FROM users WHERE username = 'Nurse'),
('Clinical-App-Disposition')),
((SELECT user_id FROM users WHERE username = 'Nurse'),
('Clinical-App-Orders')),
((SELECT user_id FROM users WHERE username = 'Nurse'),
('Clinical-App-Save'));
INSERT IGNORE INTO user_role (user_id,role)
VALUES 
((SELECT user_id FROM users WHERE username = 'Doctor'),
('Appointments:FullAccess')),
((SELECT user_id FROM users WHERE username = 'Doctor'),
('Clinical-App')),
((SELECT user_id FROM users WHERE username = 'Doctor'),
('PatientDocuments-App')),
((SELECT user_id FROM users WHERE username = 'Doctor'),
('Programs-App')),
((SELECT user_id FROM users WHERE username = 'Doctor'),
('Reports-App')),
((SELECT user_id FROM users WHERE username = 'Doctor'),
('Registration-App')),
((SELECT user_id FROM users WHERE username = 'Doctor'),
('Clinical-App-Bacteriology')),
((SELECT user_id FROM users WHERE username = 'Doctor'),
('Clinical-App-Diagnosis')),
((SELECT user_id FROM users WHERE username = 'Doctor'),
('Clinical-App-Observations')),
((SELECT user_id FROM users WHERE username = 'Doctor'),
('Clinical-App-Disposition')),
((SELECT user_id FROM users WHERE username = 'Doctor'),
('Clinical-App-Orders')),
((SELECT user_id FROM users WHERE username = 'Doctor'),
('Clinical-App-Save'));
INSERT IGNORE INTO user_role (user_id,role)
VALUES 
((SELECT user_id FROM users WHERE username = 'Reception'),
('Appointments:FullAccess')),
((SELECT user_id FROM users WHERE username = 'Reception'),
('Clinical-App')),
((SELECT user_id FROM users WHERE username = 'Reception'),
('PatientDocuments-App')),
((SELECT user_id FROM users WHERE username = 'Reception'),
('Programs-App')),
((SELECT user_id FROM users WHERE username = 'Reception'),
('Reports-App')),
((SELECT user_id FROM users WHERE username = 'Reception'),
('Registration-App'));