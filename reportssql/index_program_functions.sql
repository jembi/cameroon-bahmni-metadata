
-- patientIsIndex

DROP FUNCTION IF EXISTS patientIsIndex;

DELIMITER $$
CREATE FUNCTION patientIsIndex(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE hivIndexAcceptedConceptUuid VARCHAR(38) DEFAULT "78d13812-cd29-4214-9a58-a8710fd69cff";

    SELECT TRUE INTO result
    FROM obs
    WHERE person_id = p_patientId AND obs.voided = 0 AND
        obs.concept_id = (select concept_id from concept where uuid = hivIndexAcceptedConceptUuid) AND
        obs.value_coded=1 -- concept "Yes"
    GROUP BY person_id;

    RETURN (result);
END$$
DELIMITER ;

-- getNumberOfContactsRelatedToIndex

DROP FUNCTION IF EXISTS getNumberOfContactsRelatedToIndex;

DELIMITER $$
CREATE FUNCTION getNumberOfContactsRelatedToIndex(
    p_patientId INT(11)) RETURNS INT(1)
    DETERMINISTIC
BEGIN
    DECLARE result INT(1) DEFAULT 0;

    SELECT count(DISTINCT pat.patient_id) INTO result
    FROM patient pat
    WHERE pat.voided = 0 AND
        patientsAreRelated(p_patientId, pat.patient_id) AND
        patientIsNotDead(pat.patient_id);

    RETURN (result);
END$$
DELIMITER ;

-- getNumberOfEnrolledContactsRelatedToIndex

DROP FUNCTION IF EXISTS getNumberOfEnrolledContactsRelatedToIndex;

DELIMITER $$
CREATE FUNCTION getNumberOfEnrolledContactsRelatedToIndex(
    p_patientId INT(11)) RETURNS INT(1)
    DETERMINISTIC
BEGIN
    DECLARE result INT(1) DEFAULT 0;

    SELECT count(DISTINCT pat.patient_id) INTO result
    FROM patient pat
    WHERE pat.voided = 0 AND
        patientsAreRelated(p_patientId, pat.patient_id) AND
        patientIsNotDead(pat.patient_id) AND
        patientHasEnrolledIntoIndexProgram(pat.patient_id);

    RETURN (result);
END$$
DELIMITER ;

-- patientIsContact

DROP FUNCTION IF EXISTS patientIsContact;

DELIMITER $$
CREATE FUNCTION patientIsContact(
    p_contactId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM person pIndex
    WHERE pIndex.voided = 0 AND
        patientIsIndex(pIndex.person_id) AND
        patientsAreRelated(p_contactId, pIndex.person_id)
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- patientsAreRelated

DROP FUNCTION IF EXISTS patientsAreRelated;

DELIMITER $$
CREATE FUNCTION patientsAreRelated(
    p_patientIdA INT(11),
    p_patientIdB INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM relationship 
    WHERE relationship.voided = 0 AND
        ((relationship.person_a = p_patientIdA AND relationship.person_b = p_patientIdB) OR
            (relationship.person_a = p_patientIdB AND relationship.person_b = p_patientIdA))
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getPatientMostRecentProgramAttributeValueFromName

DROP FUNCTION IF EXISTS getPatientMostRecentProgramAttributeValueFromName;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramAttributeValueFromName(
    p_patientId INT(11),
    p_programAttributeName VARCHAR(255)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);

    SELECT ppa.value_reference INTO result
    FROM patient_program_attribute ppa
        JOIN program_attribute_type pat ON pat.program_attribute_type_id = ppa.attribute_type_id AND pat.retired = 0
        JOIN patient_program pp ON ppa.patient_program_id = pp.patient_program_id AND pp.voided = 0
    WHERE
        ppa.voided = 0 AND
        pp.patient_id = p_patientId AND
        pat.name = p_programAttributeName
    ORDER BY ppa.date_created DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- patientHasEnrolledIntoIndexProgram

DROP FUNCTION IF EXISTS patientHasEnrolledIntoIndexProgram;

DELIMITER $$
CREATE FUNCTION patientHasEnrolledIntoIndexProgram(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT
        TRUE INTO result
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    JOIN program pro ON pro.program_id = pp.program_id AND pro.retired = 0
    WHERE p.person_id = p_patientId
        AND p.voided = 0
        AND pro.name = "INDEX_TESTING_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result);
END$$
DELIMITER ;
