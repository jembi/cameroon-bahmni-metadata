-- getDateMostRecentARVAppointmentThatIsBeforeReportEndDate

DROP FUNCTION IF EXISTS getDateMostRecentARVAppointmentThatIsBeforeReportEndDate;

DELIMITER $$
CREATE FUNCTION getDateMostRecentARVAppointmentThatIsBeforeReportEndDate(
    p_patientId INT(11),
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT DATE(pa.start_date_time) INTO result
    FROM patient_appointment pa
    JOIN appointment_service aps ON aps.appointment_service_id = pa.appointment_service_id AND aps.voided = 0
    WHERE pa.voided = 0
        AND pa.patient_id = p_patientId
        AND pa.start_date_time < p_endDate
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

-- getDateMostRecentHIVRelatedEncounterWithinReportingPeriod

DROP FUNCTION IF EXISTS getDateMostRecentHIVRelatedEncounterWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION getDateMostRecentHIVRelatedEncounterWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT e.encounter_datetime INTO result
    FROM encounter e
    JOIN `location` loc ON loc.location_id = e.location_id
    WHERE e.voided = 0
        AND e.patient_id = p_patientId
        AND e.encounter_datetime BETWEEN p_startDate AND p_endDate
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

-- getDateMostRecentARVPickupWithinReportingPeriod

DROP FUNCTION IF EXISTS getDateMostRecentARVPickupWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION getDateMostRecentARVPickupWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE result DATE;

    SELECT o.scheduled_date INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN concept c ON do.duration_units = c.concept_id AND c.retired = 0
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.concept_id)
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    ORDER BY o.scheduled_date DESC
    LIMIT 1;

    RETURN (result);
END$$
DELIMITER ;

-- patientIsLostToFollowUp

DROP FUNCTION IF EXISTS patientIsLostToFollowUp;

DELIMITER $$
CREATE FUNCTION patientIsLostToFollowUp(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    DECLARE dateOfARVAppointment DATE;
    DECLARE dateOfMostRecentHIVRelatedEncounterWithinReportingPeriod DATE;
    DECLARE dateOfLastARVPickupWithinReportingPeriod DATE;
    DECLARE ltfuStartDate DATE;

    SET dateOfARVAppointment = getDateMostRecentARVAppointmentThatIsBeforeReportEndDate(p_patientId, p_endDate);
    SET dateOfMostRecentHIVRelatedEncounterWithinReportingPeriod = getDateMostRecentHIVRelatedEncounterWithinReportingPeriod(p_patientId, p_startDate, p_endDate);
    SET dateOfLastARVPickupWithinReportingPeriod = getDateMostRecentARVPickupWithinReportingPeriod(p_patientId, p_startDate, p_endDate);

    IF dateOfARVAppointment IS NOT NULL THEN
        SET ltfuStartDate = timestampadd(DAY, 28, dateOfARVAppointment);
    END IF;

    SET result =
        ltfuStartDate <= p_endDate AND
        dateOfLastARVPickupWithinReportingPeriod IS NULL AND
        (
            dateOfMostRecentHIVRelatedEncounterWithinReportingPeriod IS NULL OR
            dateOfMostRecentHIVRelatedEncounterWithinReportingPeriod > ltfuStartDate
        );

    RETURN (result);
END$$
DELIMITER ;
