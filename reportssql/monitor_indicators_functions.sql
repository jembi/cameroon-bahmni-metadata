
DROP FUNCTION IF EXISTS countRegPatientsByServiceType;

DELIMITER $$
CREATE FUNCTION countRegPatientsByServiceType(
    p_startDate DATETIME,
    p_endDate DATETIME,
    visitType VARCHAR(255)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT 
        COUNT(distinct p.patient_id) INTO result 
    FROM patient p, visit v 
    WHERE p.date_created between p_startDate and p_endDate
        AND v.patient_id=p.patient_id 
        AND v.visit_type_id=(select visit_type_id from visit_type where name=visitType);

    RETURN result;
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS countHivEncountersByForm;

DELIMITER $$
CREATE FUNCTION countHivEncountersByForm(
    p_startDate DATETIME,
    p_endDate DATETIME,
    formUuid VARCHAR(255)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT 
        COUNT(distinct e.encounter_id) INTO result 
    FROM encounter e, obs o 
    WHERE e.date_created between p_startDate and p_endDate
        AND o.encounter_id=e.encounter_id
        AND o.concept_id=(select concept_id from concept where uuid=formUuid);

    RETURN result;
END$$
DELIMITER ;
