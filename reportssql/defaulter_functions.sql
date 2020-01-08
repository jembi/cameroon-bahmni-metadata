-- getDateMostRecentARVAppointment

DROP FUNCTION IF EXISTS getDateMostRecentARVAppointment;

DELIMITER $$
CREATE FUNCTION getDateMostRecentARVAppointment(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT DATE(pa.start_date_time) INTO result
    FROM patient_appointment pa
    JOIN appointment_service aps ON aps.appointment_service_id = pa.appointment_service_id AND aps.voided = 0
    WHERE pa.voided = 0
        AND pa.patient_id = p_patientId
        AND (
            aps.name = "APPOINTMENT_SERVICE_ANC_KEY" OR
            aps.name = "APPOINTMENT_SERVICE_ART_KEY" OR
            aps.name = "APPOINTMENT_SERVICE_ART_DISPENSARY_KEY" OR
            aps.name = "APPOINTMENT_SERVICE_OPD_KEY")
    ORDER BY pa.start_date_time DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- getDateMostRecentHIVRelatedEncounter

DROP FUNCTION IF EXISTS getDateMostRecentHIVRelatedEncounter;

DELIMITER $$
CREATE FUNCTION getDateMostRecentHIVRelatedEncounter(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT e.encounter_datetime INTO result
    FROM encounter e
    JOIN `location` loc ON loc.location_id = e.location_id
    WHERE e.voided = 0
        AND e.patient_id = p_patientId
        AND loc.name IN (
            "LOCATION_ANC",
            "LOCATION_ART",
            "LOCATION_ART_DISPENSATION",
            "LOCATION_OPD"
        )
    ORDER BY e.encounter_datetime DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;


-- patientIsDefaulter

DROP FUNCTION IF EXISTS patientIsDefaulter;

DELIMITER $$
CREATE FUNCTION patientIsDefaulter(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE dateOfLastHIVRelatedAppointment DATE;
    DECLARE dateOfLastHIVRelatedEncounter DATE;

    SET dateOfLastHIVRelatedAppointment = getDateMostRecentARVAppointment(p_patientId);
    SET dateOfLastHIVRelatedEncounter = getDateMostRecentHIVRelatedEncounter(p_patientId);

    IF (
        patientHasEnrolledIntoHivProgram(p_patientId) = "No" OR -- a patient not in HIV cannot be a defaulter
        dateOfLastHIVRelatedAppointment IS NULL OR -- the patient has no appointment and therefore cannot be a defaulter
        TIMESTAMPADD(DAY, 7, dateOfLastHIVRelatedAppointment) > CURRENT_DATE() OR -- one week after the last appointment falls in future, the patient is therefore not yet a defaulter
        (dateOfLastHIVRelatedEncounter IS NOT NULL AND dateOfLastHIVRelatedEncounter >= dateOfLastHIVRelatedAppointment) -- the patient visited the clinic at or after the date of the appointment
    ) THEN
        RETURN 0;
    ELSE
        RETURN 1;
    END IF;
END$$
DELIMITER ;
