SET @nursesalt = (SHA2(SUBSTRING(MD5(RAND()), -10), 512));
SET @doctorsalt = (SHA2(SUBSTRING(MD5(RAND()), -10), 512));
SET @receptionsalt = (SHA2(SUBSTRING(MD5(RAND()), -10), 512));

SET @nurse_person_uuid = '3f64faba-ad31-11e9-a2a3-2a2ae2dbcce4';
SET @doctor_person_uuid = '3f64fd1c-ad31-11e9-a2a3-2a2ae2dbcce4';
SET @reception_person_uuid = '3f64fe70-ad31-11e9-a2a3-2a2ae2dbcce4';

SET @nurse_user_uuid = '3bfbd6ec-ad1c-11e9-a2a3-2a2ae2dbcce4';
SET @doctor_user_uuid = '3bfbdbba-ad1c-11e9-a2a3-2a2ae2dbcce4';
SET @reception_user_uuid = '3bfbdd40-ad1c-11e9-a2a3-2a2ae2dbcce4';

INSERT IGNORE INTO person (uuid, gender, date_created, creator)
    VALUES (@nurse_person_uuid, 'F', NOW(), '4');

INSERT IGNORE INTO person_name (person_id, uuid, given_name, family_name) 
    VALUES (@nurse_person_uuid, '7459fb76-c81a-4a04-9578-656018d2828f', 'Nurse', '');

INSERT IGNORE INTO person (uuid, gender, date_created, creator)
    VALUES (@doctor_person_uuid, 'F', NOW(), '4');

INSERT IGNORE INTO person_name (person_id, uuid, given_name, family_name) 
    VALUES (@doctor_person_uuid, 'c4d2632f-3ed2-4f5f-b37a-f92398cc5cc8', 'Doctor', '');

INSERT IGNORE INTO person (uuid, gender, date_created, creator)
    VALUES (@reception_person_uuid, 'F', NOW(), '4');

INSERT IGNORE INTO person_name (person_id, uuid, given_name, family_name) 
    VALUES (@reception_person_uuid, 'df9280ef-9f5a-4207-9668-9725355dfd01', 'Reception', '');

INSERT IGNORE INTO users (system_id, username, password, salt, date_created, uuid, person_id, creator)
    VALUES 
        ('Nurse', 'Nurse', SHA2(CONCAT('Nurse#123', @nursesalt), 512), @nursesalt, NOW(), @nurse_user_uuid, @nurse_person_uuid, '4'),
        ('Doctor', 'Doctor', SHA2(CONCAT('Doctor#123', @doctorsalt), 512), @doctorsalt, NOW(), @doctor_user_uuid, @doctor_person_uuid, '4'),
        ('Reception', 'Reception', SHA2(CONCAT('Reception#123', @receptionsalt), 512), @receptionsalt, NOW(), @reception_user_uuid, @reception_person_uuid, '4');

SET @nurse_user_id = (SELECT user_id FROM users WHERE uuid = @nurse_user_uuid);
SET @doctor_user_id = (SELECT user_id FROM users WHERE uuid = @doctor_user_uuid);
SET @reception_user_id = (SELECT user_id FROM users WHERE uuid = @reception_user_uuid);

INSERT IGNORE INTO provider (person_id, creator, date_created, uuid)
    VALUES
        (@nurse_person_uuid, '4', NOW(), '1ad6aa26-adfa-11e9-a2a3-2a2ae2dbcce4'),
        (@doctor_person_uuid, '4', NOW(), '1ad6ac88-adfa-11e9-a2a3-2a2ae2dbcce4'),
        (@reception_person_uuid, '4', NOW(), '1ad6adf0-adfa-11e9-a2a3-2a2ae2dbcce4');

INSERT IGNORE INTO user_role (user_id, role)
    VALUES 
        (@nurse_user_id, 'Appointments:FullAccess'),
        (@nurse_user_id, 'Clinical-App'),
        (@nurse_user_id, 'PatientDocuments-App'),
        (@nurse_user_id, 'Programs-App'),
        (@nurse_user_id, 'Reports-App'),
        (@nurse_user_id, 'Registration-App'),
        (@nurse_user_id, 'Clinical-App-Bacteriology'),
        (@nurse_user_id, 'Clinical-App-Diagnosis'),
        (@nurse_user_id, 'Clinical-App-Observations'),
        (@nurse_user_id, 'Clinical-App-Disposition'),
        (@nurse_user_id, 'Clinical-App-Orders'),
        (@nurse_user_id, 'Clinical-App-Save');

INSERT IGNORE INTO user_role (user_id, role)
    VALUES 
        (@doctor_user_id, 'Appointments:FullAccess'),
        (@doctor_user_id, 'Clinical-App'),
        (@doctor_user_id, 'PatientDocuments-App'),
        (@doctor_user_id, 'Programs-App'),
        (@doctor_user_id, 'Reports-App'),
        (@doctor_user_id, 'Registration-App'),
        (@doctor_user_id, 'Clinical-App-Bacteriology'),
        (@doctor_user_id, 'Clinical-App-Diagnosis'),
        (@doctor_user_id, 'Clinical-App-Observations'),
        (@doctor_user_id, 'Clinical-App-Disposition'),
        (@doctor_user_id, 'Clinical-App-Orders'),
        (@doctor_user_id, 'Clinical-App-Save');

INSERT IGNORE INTO user_role (user_id, role)
    VALUES 
        (@reception_user_id, 'Appointments:FullAccess'),
        (@reception_user_id, 'Clinical-App'),
        (@reception_user_id, 'PatientDocuments-App'),
        (@reception_user_id, 'Programs-App'),
        (@reception_user_id, 'Reports-App'),
        (@reception_user_id, 'Registration-App');