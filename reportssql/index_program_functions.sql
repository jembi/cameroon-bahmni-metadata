
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

-- getIndexNames

DROP FUNCTION IF EXISTS getIndexNames;

DELIMITER $$
CREATE FUNCTION getIndexNames(
    p_contactPatientId INT(11)) RETURNS TEXT
    DETERMINISTIC
BEGIN
    DECLARE result TEXT DEFAULT '';

    SELECT GROUP_CONCAT(concat(pn.given_name," ", ifnull(pn.family_name,''))) INTO result
    FROM person_name pn
    WHERE pn.voided = 0 AND
        patientsAreRelated(p_contactPatientId, pn.person_id) AND
        patientIsIndex(pn.person_id) AND
        patientIsNotDead(pn.person_id);

    RETURN (result);
END$$
DELIMITER ;


-- getIndexRelationships

DROP FUNCTION IF EXISTS getIndexRelationships;

DELIMITER $$
CREATE FUNCTION getIndexRelationships(
    p_contactPatientId INT(11)) RETURNS TEXT
    DETERMINISTIC
BEGIN
    DECLARE result TEXT DEFAULT '';

    SELECT GROUP_CONCAT(getRelationshipNameBetweenPatients(p_contactPatientId, pn.person_id)) INTO result
    FROM person_name pn
    WHERE pn.voided = 0 AND
        patientsAreRelated(p_contactPatientId, pn.person_id) AND
        patientIsIndex(pn.person_id) AND
        patientIsNotDead(pn.person_id);

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

-- getRelationshipNameBetweenPatients

DROP FUNCTION IF EXISTS getRelationshipNameBetweenPatients;

DELIMITER $$
CREATE FUNCTION getRelationshipNameBetweenPatients(
    p_patientIdA INT(11),
    p_patientIdB INT(11)) RETURNS VARCHAR(50)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(50) DEFAULT "";

    SELECT rt.a_is_to_b INTO result
    FROM relationship r
    JOIN relationship_type rt ON r.relationship = rt.relationship_type_id
    WHERE r.voided = 0 AND
        r.person_a = p_patientIdA AND r.person_b = p_patientIdB
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getPatientMostRecentProgramAttributeCodedValueFromName

DROP FUNCTION IF EXISTS getPatientMostRecentProgramAttributeCodedValueFromName;

DELIMITER $$
CREATE FUNCTION getPatientMostRecentProgramAttributeCodedValueFromName(
    p_patientId INT(11),
    p_programAttributeName VARCHAR(255),
    p_language VARCHAR(3)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE uuidProgramAttribute VARCHAR(38);

    SELECT pat.uuid INTO uuidProgramAttribute
    FROM program_attribute_type pat
    WHERE pat.name = p_programAttributeName
    LIMIT 1;

    RETURN getPatientMostRecentProgramAttributeCodedValue(p_patientId, uuidProgramAttribute, p_language);
END$$
DELIMITER ;

-- getMostRecentDateObservation

DROP FUNCTION IF EXISTS getMostRecentDateObservation;

DELIMITER $$
CREATE FUNCTION getMostRecentDateObservation(
    p_patientId INT(11),
    p_conceptName VARCHAR(255)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT o.value_datetime INTO result
    FROM obs o
    JOIN concept_name cn ON cn.concept_id = o.concept_id
    WHERE o.person_id = p_patientId
        AND o.voided = 0
        AND cn.name = p_conceptName
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;


-- getMostRecentTextObservation

DROP FUNCTION IF EXISTS getMostRecentTextObservation;

DELIMITER $$
CREATE FUNCTION getMostRecentTextObservation(
    p_patientId INT(11),
    p_conceptName VARCHAR(255)) RETURNS TEXT
    DETERMINISTIC
BEGIN
    DECLARE result TEXT;

    SELECT o.value_text INTO result
    FROM obs o
    JOIN concept_name cn ON cn.concept_id = o.concept_id
    WHERE o.person_id = p_patientId
        AND o.voided = 0
        AND cn.name = p_conceptName
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;


-- getMostRecentCodedObservation

DROP FUNCTION IF EXISTS getMostRecentCodedObservation;

DELIMITER $$
CREATE FUNCTION getMostRecentCodedObservation(
    p_patientId INT(11),
    p_conceptName VARCHAR(255),
    p_language VARCHAR(3)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);

    SELECT cn2.name INTO result
    FROM obs o
    JOIN concept_name cn ON cn.concept_id = o.concept_id
    JOIN concept_name cn2 ON cn2.concept_id = o.value_coded
    WHERE o.person_id = p_patientId
        AND o.voided = 0
        AND cn.name = p_conceptName
        AND cn2.locale = p_language
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN result;
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

-- getTestedLocation

DROP FUNCTION IF EXISTS getTestedLocation;

DELIMITER $$
CREATE FUNCTION getTestedLocation(
    p_patientId INT(11)) RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);

    SELECT l.name INTO result
    FROM obs o
    JOIN concept_name cn ON cn.concept_id = o.concept_id
    JOIN location l ON o.location_id = l.location_id
    WHERE o.person_id = p_patientId
        AND o.voided = 0
        AND cn.name = 'Final Test Result'
    ORDER BY o.date_created DESC
    LIMIT 1;

    RETURN result;
END$$
DELIMITER ;
