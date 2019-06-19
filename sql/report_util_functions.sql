-- patientGenderIs

DROP FUNCTION IF EXISTS patientGenderIs;

DELIMITER $$
CREATE FUNCTION patientGenderIs(
    p_patientId INT(11),
    p_gender VARCHAR(1)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT p.gender = p_gender INTO result
    FROM person p
    WHERE p.person_id = p_patientId AND p.voided = 0;

    RETURN (result );
END$$
DELIMITER ;

-- patientAgeWhenRegisteredForHivProgramIsBetween

DROP FUNCTION IF EXISTS patientAgeWhenRegisteredForHivProgramIsBetween;  

DELIMITER $$ 
CREATE FUNCTION patientAgeWhenRegisteredForHivProgramIsBetween(
    p_patientId INT(11),
    p_startAge INT(11),
    p_endAge INT(11),
    p_includeEndAge TINYINT(1)) RETURNS TINYINT(1) 
    DETERMINISTIC 
BEGIN 
    DECLARE result TINYINT(1) DEFAULT 0; 
    SELECT  
        IF (p_includeEndAge, 
            timestampdiff(YEAR, p.birthdate, pp.date_enrolled) BETWEEN p_startAge AND p_endAge, 
            timestampdiff(YEAR, p.birthdate, pp.date_enrolled) >= p_startAge
                AND timestampdiff(YEAR, p.birthdate, pp.date_enrolled) < p_endAge
        ) INTO result  
    FROM person p 
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0 
    JOIN program pro ON pp.program_id = pro.program_id AND pro.retired = 0 
    WHERE p.person_id = p_patientId AND p.voided = 0 
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result ); 
END$$ 
DELIMITER ;

-- patientHasEnrolledIntoHivProgramBefore

DROP FUNCTION IF EXISTS patientHasEnrolledIntoHivProgramBefore;

DELIMITER $$
CREATE FUNCTION patientHasEnrolledIntoHivProgramBefore(
    p_patientId INT(11),
    p_date DATE) RETURNS TINYINT(1)
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
        AND DATE(pp.date_enrolled) < p_date
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result );
END$$
DELIMITER ;

-- patientHasEnrolledIntoHivProgramDuringReportingPeriod

DROP FUNCTION IF EXISTS patientHasEnrolledIntoHivProgramDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasEnrolledIntoHivProgramDuringReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
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
        AND DATE(pp.date_enrolled) BETWEEN p_startDate AND p_endDate
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result );
END$$
DELIMITER ;

-- patientHasEnrolledIntoHivProgramDuringOrBeforeReportingPeriod

DROP FUNCTION IF EXISTS patientHasEnrolledIntoHivProgramDuringOrBeforeReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasEnrolledIntoHivProgramDuringOrBeforeReportingPeriod(
    p_patientId INT(11),
    p_endDate DATE) RETURNS TINYINT(1)
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
        AND DATE(pp.date_enrolled) <= p_endDate
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result );
END$$
DELIMITER ;

-- patientHasStartedARVTreatmentBefore

DROP FUNCTION IF EXISTS patientHasStartedARVTreatmentBefore;

DELIMITER $$
CREATE FUNCTION patientHasStartedARVTreatmentBefore(
    p_patientId INT(11),
    p_startDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE uuidARVTreatmentStartDate VARCHAR(38) DEFAULT "e3f9c7ee-aa3e-4224-9d18-42e09b095ac6";

    SELECT
        TRUE INTO result
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidARVTreatmentStartDate
        AND o.value_datetime IS NOT NULL
        AND cast(o.value_datetime AS DATE) < p_startDate
    GROUP BY c.uuid;

    RETURN (result );
END$$
DELIMITER ;

-- patientHasStartedARVTreatmentDuringReportingPeriod

DROP FUNCTION IF EXISTS patientHasStartedARVTreatmentDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasStartedARVTreatmentDuringReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE uuidARVTreatmentStartDate VARCHAR(38) DEFAULT "e3f9c7ee-aa3e-4224-9d18-42e09b095ac6";

    SELECT
        TRUE INTO result
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidARVTreatmentStartDate
        AND o.value_datetime IS NOT NULL
        AND cast(o.value_datetime AS DATE) BETWEEN p_startDate AND p_endDate
        LIMIT 1;

    RETURN (result );
END$$
DELIMITER ;

-- patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod

DROP FUNCTION IF EXISTS patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod(
    p_patientId INT(11),
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE uuidARVTreatmentStartDate VARCHAR(38) DEFAULT "e3f9c7ee-aa3e-4224-9d18-42e09b095ac6";

    SELECT
        TRUE INTO result
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidARVTreatmentStartDate
        AND o.value_datetime IS NOT NULL
        AND cast(o.value_datetime AS DATE) <= p_endDate
    GROUP BY c.uuid;

    RETURN (result );
END$$
DELIMITER ;

-- patientWasOnARVTreatmentDuringEntireReportingPeriod

DROP FUNCTION IF EXISTS patientWasOnARVTreatmentDuringEntireReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientWasOnARVTreatmentDuringEntireReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_protocolLineNumber INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN concept c ON do.duration_units = c.concept_id AND c.retired = 0
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.name, p_protocolLineNumber)
        AND o.date_activated < p_startDate
        AND calculateTreatmentEndDate(
            o.date_activated,
            do.duration,
            c.uuid -- uuid of the duration unit concept
            ) >= p_endDate
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    GROUP BY o.patient_id;

    RETURN (result );
END$$ 
DELIMITER ;

-- patientHasStartedARVTreatment12MonthsAgo

DROP FUNCTION IF EXISTS patientHasStartedARVTreatment12MonthsAgo;

DELIMITER $$
CREATE FUNCTION patientHasStartedARVTreatment12MonthsAgo(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE uuidARVTreatmentStartDate VARCHAR(38) DEFAULT "e3f9c7ee-aa3e-4224-9d18-42e09b095ac6";

    SELECT
        TRUE INTO result
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidARVTreatmentStartDate
        AND o.value_datetime IS NOT NULL
        AND timestampadd(YEAR, 1, cast(o.value_datetime AS DATE)) BETWEEN p_startDate AND p_endDate
    GROUP BY c.uuid;

    RETURN (result );
END$$ 
DELIMITER ;

-- patientWasOnARVOrHasPickedUpADrugWithinPeriodPlusOrMinusMonths

DROP FUNCTION IF EXISTS patientWasOnARVOrHasPickedUpADrugWithinPeriodPlusOrMinusMonths;

DELIMITER $$
CREATE FUNCTION patientWasOnARVOrHasPickedUpADrugWithinPeriodPlusOrMinusMonths(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_protocolLineNumber INT(11),
    p_months INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE extended_startDate DATE;
    DECLARE extended_endDate DATE;
    SET extended_startDate = timestampadd(MONTH, -p_months, p_startDate);
    SET extended_endDate = timestampadd(MONTH, p_months, p_endDate);

    RETURN
        patientWasOnARVTreatmentDuringEntireReportingPeriod(p_patientId, extended_startDate, p_endDate, p_protocolLineNumber)
        OR
        patientWasOnARVTreatmentDuringEntireReportingPeriod(p_patientId, p_startDate, extended_endDate, p_protocolLineNumber)
        OR
        patientPickedARVDrugDuringReportingPeriod(p_patientId, extended_startDate, extended_endDate, p_protocolLineNumber);
END$$ 
DELIMITER ;

-- patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod

DROP FUNCTION IF EXISTS patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_protocolLineNumber INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    RETURN
        patientWasOnARVTreatmentDuringEntireReportingPeriod(p_patientId, p_startDate, p_endDate, p_protocolLineNumber)
        OR
        patientPickedARVDrugDuringReportingPeriod(p_patientId, p_startDate, p_endDate, p_protocolLineNumber);
END$$ 
DELIMITER ;

-- patientWasOnARVTreatmentDuringReportingPeriod

DROP FUNCTION IF EXISTS patientWasOnARVTreatmentDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientWasOnARVTreatmentDuringReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN concept c ON do.duration_units = c.concept_id AND c.retired = 0
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.name, 0)
        AND o.date_activated <= p_endDate
        AND calculateTreatmentEndDate(
            o.date_activated,
            do.duration,
            c.uuid -- uuid of the duration unit concept
            ) >= p_startDate
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    GROUP BY o.patient_id;

    RETURN (result );
END$$ 
DELIMITER ;

-- patientPickedARVDrugDuringReportingPeriod

DROP FUNCTION IF EXISTS patientPickedARVDrugDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientPickedARVDrugDuringReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_protocolLineNumber INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN concept c ON do.duration_units = c.concept_id AND c.retired = 0
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.name, p_protocolLineNumber)
        AND o.date_activated BETWEEN p_startDate AND p_endDate
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    GROUP BY o.patient_id;

    RETURN (result );
END$$ 
DELIMITER ;

-- patientDidntCollectARV
DROP FUNCTION IF EXISTS patientDidntCollectARV;

DELIMITER $$
CREATE FUNCTION patientDidntCollectARV(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_protocolLineNumber INT(11),
    p_monthOffset INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE drugNotDispensed TINYINT(1) DEFAULT 0;
    DECLARE drugNotOrdered TINYINT(1) DEFAULT 1;

    SELECT TRUE INTO drugNotDispensed
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN concept c ON do.duration_units = c.concept_id AND c.retired = 0
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.name, p_protocolLineNumber)
        AND o.date_activated BETWEEN TIMESTAMPADD(MONTH,p_monthOffset,p_startDate) AND TIMESTAMPADD(MONTH,p_monthOffset,p_endDate)
        AND !drugOrderIsDispensed(p_patientId, o.order_id)
    GROUP BY o.patient_id;

    SELECT FALSE INTO drugNotOrdered
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN concept c ON do.duration_units = c.concept_id AND c.retired = 0
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARV(d.name, p_protocolLineNumber)
        AND o.date_activated BETWEEN TIMESTAMPADD(MONTH,p_monthOffset,p_startDate) AND TIMESTAMPADD(MONTH,p_monthOffset,p_endDate)
    GROUP BY o.patient_id;

    RETURN (drugNotDispensed OR drugNotOrdered);
END$$ 
DELIMITER ;

-- patientHasScheduledAnARTAppointmentDuringReportingPeriod

DROP FUNCTION IF EXISTS patientHasScheduledAnARTAppointment;

DELIMITER $$
CREATE FUNCTION patientHasScheduledAnARTAppointment(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE,
    p_monthOffset INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM patient_appointment pa
    JOIN appointment_service aps ON aps.appointment_service_id = pa.appointment_service_id AND aps.voided = 0
    JOIN `location` lc ON lc.location_id = pa.location_id AND lc.retired = 0
    WHERE pa.voided = 0
        AND pa.patient_id = p_patientId
        AND pa.start_date_time BETWEEN TIMESTAMPADD(MONTH,p_monthOffset,p_startDate)  AND TIMESTAMPADD(MONTH,p_monthOffset,p_endDate)
        AND aps.name = "APPOINTMENT_SERVICE_ART_KEY"
        AND lc.name = "LOCATION_ART_DISPENTION"
    GROUP BY pa.patient_id;

    RETURN (result );
END$$ 
DELIMITER ;

-- patientHadViralLoadTest3MonthsBeforeOrAfterReportingPeriod

DROP FUNCTION IF EXISTS patientHadViralLoadTest3MonthsBeforeOrAfterReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHadViralLoadTest3MonthsBeforeOrAfterReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1);
    DECLARE testDate DATE;

    -- retrieve the test date
    SET testDate = retrieveViralLoadTestDate(p_patientId);

    -- if the test date is null, return FALSE (because the patient didn't have a viral load test)
    IF testDate IS NULL THEN
        RETURN 0;
    END IF;

    -- return true if the viral load test date is 3 months before or after the reporting period
    IF timestampdiff(MONTH, testDate, p_startDate) BETWEEN 0 AND 3 OR timestampdiff(MONTH, p_endDate, testDate) BETWEEN 0 AND 3 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;

END$$ 
DELIMITER ;

-- retrieveViralLoadTestDate
DROP FUNCTION IF EXISTS retrieveViralLoadTestDate;

DELIMITER $$
CREATE FUNCTION retrieveViralLoadTestDate(
    p_patientId INT(11)) RETURNS DATE
    DETERMINISTIC
BEGIN
    DECLARE viralLoadTestDateUuid VARCHAR(38) DEFAULT 'cac6bf44-f671-4f85-ab76-71e7f099d3cb';
    DECLARE viralLoadTestUuid VARCHAR(38) DEFAULT '4d80e0ce-5465-4041-9d1e-d281d25a9b50';
    DECLARE testDate DATE;
    DECLARE testDateFromForm DATE;
    DECLARE testDateFromOpenElis DATE;

    -- Read and store latest test date from form "LAB RESULTS - ADD MANUALLY"
    SELECT o.value_datetime INTO testDateFromForm
    FROM obs o
    JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
    WHERE voided = 0
        AND order_id IS NULL
        AND o.value_datetime IS NOT NULL
        AND o.person_id = p_patientId
        AND c.uuid = viralLoadTestDateUuid
    ORDER BY o.value_datetime DESC
    LIMIT 1;

    -- read and store latest test date from elis
    SELECT o.obs_datetime INTO testDateFromOpenElis
    FROM obs o
    JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
    WHERE voided = 0
        AND order_id IS NOT NULL
        AND o.value_numeric IS NOT NULL
        AND o.person_id = p_patientId
        AND c.uuid = viralLoadTestUuid
    ORDER BY o.obs_datetime DESC
    LIMIT 1;

    -- if both dates are null, return NULL
    IF (testDateFromForm IS NULL AND testDateFromOpenElis IS NULL) THEN
        RETURN NULL;
    END IF;

    -- select the test date to use
    IF (testDateFromForm IS NULL) THEN -- if date from form is null, use date from elis as test date
        SET testDate = testDateFromOpenElis;
    ELSEIF (testDateFromOpenElis IS NULL) THEN -- else if date from elis is null, use date from form
        SET testDate = testDateFromForm;
    ELSEIF (DATE(testDateFromForm) = DATE(testDateFromOpenElis)) THEN -- if date from form = date from elis, use the date from elis
        SET testDate = testDateFromOpenElis;
    END IF;

    RETURN (testDate);
END$$ 
DELIMITER ;

-- drugOrderIsDispensed

DROP FUNCTION IF EXISTS drugOrderIsDispensed;

DELIMITER $$
CREATE FUNCTION drugOrderIsDispensed(
    p_patientId INT(11),
    p_orderId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE drugDispensed TINYINT(1) DEFAULT 0;
    DECLARE retrospectiveDrugEntry TINYINT(1) DEFAULT 0;
    DECLARE uuidDispensedConcept VARCHAR(38) DEFAULT 'ff0d6d6a-e276-11e4-900f-080027b662ec';

    SELECT TRUE INTO drugDispensed
    FROM obs o
    JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
    WHERE voided = 0
        AND o.person_id = p_patientId
        AND o.order_id = p_orderId
        AND c.uuid = uuidDispensedConcept;

    SELECT TRUE INTO retrospectiveDrugEntry
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN concept c ON c.concept_id = do.duration_units AND retired = 0
    WHERE o.voided = 0
        AND o.patient_id = p_patientId
        AND o.order_id = p_orderId
        AND o.date_created > calculateTreatmentEndDate(
            o.date_activated,
            do.duration,
            c.uuid);

    RETURN (drugDispensed OR retrospectiveDrugEntry); 
END$$ 

DELIMITER ; 

-- calculateTreatmentEndDate

DROP FUNCTION IF EXISTS calculateTreatmentEndDate;

DELIMITER $$
CREATE FUNCTION calculateTreatmentEndDate(
    p_startDate DATE,
    p_duration INT(11),
    p_uuidDurationUnit VARCHAR(38)) RETURNS DATE
    DETERMINISTIC
BEGIN

    DECLARE result DATE;
    DECLARE uuidMinute VARCHAR(38) DEFAULT '33bc78b1-8a92-11e4-977f-0800271c1b75';
    DECLARE uuidHour VARCHAR(38) DEFAULT 'bb62c684-3f10-11e4-adec-0800271c1b75';
    DECLARE uuidDay VARCHAR(38) DEFAULT '9d7437a9-3f10-11e4-adec-0800271c1b75';
    DECLARE uuidWeek VARCHAR(38) DEFAULT 'bb6436e3-3f10-11e4-adec-0800271c1b75';
    DECLARE uuidMonth VARCHAR(38) DEFAULT 'bb655344-3f10-11e4-adec-0800271c1b75';

    IF p_uuidDurationUnit = uuidMinute THEN
        SET result = timestampadd(MINUTE, p_duration, p_startDate);
    ELSEIF p_uuidDurationUnit = uuidHour THEN
        SET result = timestampadd(HOUR, p_duration, p_startDate);
    ELSEIF p_uuidDurationUnit = uuidDay THEN
        SET result = timestampadd(DAY, p_duration, p_startDate);
    ELSEIF p_uuidDurationUnit = uuidWeek THEN
        SET result = timestampadd(WEEK, p_duration, p_startDate);
    ELSEIF p_uuidDurationUnit = uuidMonth THEN
        SET result = timestampadd(MONTH, p_duration, p_startDate);
    END IF;

    RETURN (result); 
END$$ 

DELIMITER ; 

-- drugIsARV

DROP FUNCTION IF EXISTS drugIsARV;

DELIMITER $$
CREATE FUNCTION drugIsARV(
    p_drugName VARCHAR(255),
    p_protocolLineNumber INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1);
    
    IF p_protocolLineNumber = 1 THEN
        SET result = drugIsARVFirstLine(p_drugName);
    ELSEIF p_protocolLineNumber = 2 THEN
        SET result = drugIsARVSecondLine(p_drugName);
    ELSEIF p_protocolLineNumber = 3 THEN
        SET result = drugIsARVThirdLine(p_drugName);
    ELSE
        SET result =  
            drugIsARVFirstLine(p_drugName) OR
            drugIsARVSecondLine(p_drugName) OR
            drugIsARVThirdLine(p_drugName);
    END IF;

    RETURN (result); 
END$$
DELIMITER ;

-- patientIsNotDead

DROP FUNCTION IF EXISTS patientIsNotDead;

DELIMITER $$
CREATE FUNCTION patientIsNotDead(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT p.dead INTO result
    FROM person p
    WHERE p.person_id = p_patientId AND p.voided = 0;

    RETURN (!result );

END$$
DELIMITER ;

-- patientIsNotLostToFollowUp

DROP FUNCTION IF EXISTS patientIsNotLostToFollowUp;

DELIMITER $$
CREATE FUNCTION patientIsNotLostToFollowUp(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN 
    DECLARE patientLostToFollowUp TINYINT(1) DEFAULT 0;

    DECLARE uuidPatientLostToFollowUp VARCHAR(38) DEFAULT "7ca4f879-4862-4cd5-84b3-e1ead8ff54ff";

    SELECT TRUE INTO patientLostToFollowUp
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    JOIN concept c ON c.concept_id = pp.outcome_concept_id
    WHERE p.person_id = p_patientId AND p.voided = 0
        AND c.uuid = uuidPatientLostToFollowUp;

    RETURN (!patientLostToFollowUp );
END$$
DELIMITER ;

-- patientIsNotTransferredOut

DROP FUNCTION IF EXISTS patientIsNotTransferredOut;

DELIMITER $$
CREATE FUNCTION patientIsNotTransferredOut(
    p_patientId INT) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE patientTransferedOut TINYINT(1) DEFAULT 0;

    DECLARE uuidPatientTransferredOut VARCHAR(38) DEFAULT "c614b7a3-9ffa-4047-8c20-f42e6a347deb";

    SELECT TRUE INTO patientTransferedOut
    FROM person p
    JOIN patient_program pp ON pp.patient_id = p.person_id AND pp.voided = 0
    JOIN concept c ON c.concept_id = pp.outcome_concept_id
    WHERE p.person_id = p_patientId
        AND p.voided = 0 
        AND c.uuid = patientTransferedOut;

    RETURN (!patientTransferedOut); 

END$$
DELIMITER ;

-- patientPickedFirstLineProtocolARVDrugDuringReportingPeriod

DROP FUNCTION IF EXISTS patientPickedFirstLineProtocolARVDrugDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientPickedFirstLineProtocolARVDrugDuringReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN concept c ON do.duration_units = c.concept_id AND c.retired = 0
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsARVFirstLine(d.name)
        AND o.date_activated BETWEEN p_startDate AND p_endDate
    GROUP BY o.patient_id;

    RETURN (result );
END$$ 
DELIMITER ;

-- drugIsARVFirstLine

DROP FUNCTION IF EXISTS drugIsARVFirstLine;

DELIMITER $$
CREATE FUNCTION drugIsARVFirstLine(
    p_drugName VARCHAR(255)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE firstOrderLineUuid VARCHAR(38) DEFAULT "2f8dba15-95b4-4e1e-a2cf-10f3b2510ed8";

    return _drugIsARV(p_drugName, firstOrderLineUuid);
END$$
DELIMITER ;


-- drugIsARVSecondLine

DROP FUNCTION IF EXISTS drugIsARVSecondLine;

DELIMITER $$
CREATE FUNCTION drugIsARVSecondLine(
    p_drugName VARCHAR(255)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE secondOrderLineUuid VARCHAR(38) DEFAULT "da334532-dbb3-4456-b684-55fcb42e6fcb";

    return _drugIsARV(p_drugName, secondOrderLineUuid);
END$$
DELIMITER ;

-- drugIsARVThirdLine

DROP FUNCTION IF EXISTS drugIsARVThirdLine;

DELIMITER $$
CREATE FUNCTION drugIsARVThirdLine(
    p_drugName VARCHAR(255)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE thirdOrderLineUuid VARCHAR(38) DEFAULT "89640844-136a-470e-9371-37b26dd7d3c2";

    return _drugIsARV(p_drugName, thirdOrderLineUuid);
END$$
DELIMITER ;

-- _drugIsARV
-- This is a util function to avoid duplicating the SQL code on 
-- drugIsARVFirstLine, drugIsARVSecondLine and drugIsARVThirdLine

DROP FUNCTION IF EXISTS _drugIsARV;

DELIMITER $$
CREATE FUNCTION _drugIsARV(
    p_drugName VARCHAR(255),
    p_orderLineUuid VARCHAR(38)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM concept_set cs
    INNER JOIN concept c ON c.concept_id = cs.concept_set AND c.retired = 0
    INNER JOIN concept_name cn ON cn.concept_id = cs.concept_id
    WHERE c.uuid = p_orderLineUuid
        AND cn.name = p_drugName
    LIMIT 1;

    return result;
END$$
DELIMITER ;

-- isOldPatient

DROP FUNCTION IF EXISTS isOldPatient;

DELIMITER $$
CREATE FUNCTION isOldPatient(
    p_patientId INT(11),
    p_startDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;
    
    SELECT TRUE INTO result
    FROM patient_program pp
    JOIN person p ON p.person_id = p_patientId AND p.voided = 0
    JOIN program pro ON pro.program_id = pp.program_id AND pro.retired = 0
    WHERE DATE(pp.date_enrolled) < p_startDate
        AND pp.patient_id = p.person_id
        AND pp.voided = 0
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (result);
END$$
DELIMITER ;

-- patientHasNotBeenEnrolledIntoHivProgramDuringReportingPeriod

DROP FUNCTION IF EXISTS patientHasNotBeenEnrolledIntoHivProgramDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasNotBeenEnrolledIntoHivProgramDuringReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
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
        AND DATE(pp.date_enrolled) BETWEEN p_startDate AND p_endDate
        AND pro.name = "HIV_PROGRAM_KEY"
    GROUP BY pro.name;

    RETURN (!result);
END$$
DELIMITER ;

-- patientAgeIsBetween

DROP FUNCTION IF EXISTS patientAgeIsBetween;  

DELIMITER $$ 
CREATE FUNCTION patientAgeIsBetween(
    p_patientId INT(11),
    p_startAge INT(11),
    p_endAge INT(11),
    p_includeEndAge TINYINT(1)) RETURNS TINYINT(1) 
    DETERMINISTIC 
BEGIN 
    DECLARE result TINYINT(1) DEFAULT 0; 
    SELECT  
        IF (p_includeEndAge, 
            timestampdiff(YEAR, p.birthdate, CURDATE()) BETWEEN p_startAge AND p_endAge, 
            timestampdiff(YEAR, p.birthdate, CURDATE()) >= p_startAge
                AND timestampdiff(YEAR, p.birthdate, CURDATE()) < p_endAge
        ) INTO result
        FROM person p 
        WHERE p.person_id = p_patientId AND p.voided = 0;

    RETURN (result ); 
END$$ 
DELIMITER ;

-- patientHasPickedProphylaxisDuringReportingPeriod

DROP FUNCTION IF EXISTS patientHasPickedProphylaxisDuringReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHasPickedProphylaxisDuringReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN

    DECLARE result TINYINT(1) DEFAULT 0;

    SELECT TRUE INTO result
    FROM orders o
    JOIN drug_order do ON do.order_id = o.order_id
    JOIN concept c ON do.duration_units = c.concept_id AND c.retired = 0
    JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
    WHERE o.patient_id = p_patientId AND o.voided = 0
        AND drugIsProphylaxis(d.name)
        AND o.date_activated BETWEEN p_startDate AND p_endDate
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    GROUP BY o.patient_id;

    RETURN (result);
END$$ 
DELIMITER ;

-- drugIsProphylaxis

DROP FUNCTION IF EXISTS drugIsProphylaxis;

DELIMITER $$
CREATE FUNCTION drugIsProphylaxis(
    p_drugName VARCHAR(255)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE drugIsProphylaxisUuid VARCHAR(38) DEFAULT "fa7e7514-146b-4add-92ee-95d6e03315e0";
    return _drugIsARV(p_drugName, drugIsProphylaxisUuid);
END$$
DELIMITER ;
