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
        AND pro.name = "HIV Program"; 

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
        AND pro.name = "HIV Program";

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
        AND pro.name = "HIV Program";

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
        AND cast(o.value_datetime AS DATE) < p_startDate;

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
        AND cast(o.value_datetime AS DATE) BETWEEN p_startDate AND p_endDate;

    RETURN (result );
END$$
DELIMITER ;

-- patientWasOnARVTreatmentDuringEntireReportingPeriod

DROP FUNCTION IF EXISTS patientWasOnARVTreatmentDuringEntireReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientWasOnARVTreatmentDuringEntireReportingPeriod(
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
        AND o.date_activated BETWEEN p_startDate AND p_endDate
        AND drugOrderIsDispensed(p_patientId, o.order_id)
    GROUP BY o.patient_id;

    RETURN (result );
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

    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE uuidDispensedConcept VARCHAR(38) DEFAULT 'ff0d6d6a-e276-11e4-900f-080027b662ec';

    SELECT TRUE INTO result
    FROM obs o
    JOIN concept c ON o.concept_id = c.concept_id AND c.retired = 0
    WHERE voided = 0
        AND o.person_id = p_patientId
        AND o.order_id = p_orderId
        AND c.uuid = uuidDispensedConcept;

    RETURN (result); 
END$$ 

DELIMITER ; 

-- calculateTreatmentEndDate

DROP FUNCTION IF EXISTS calculateTreatmentEndDate;

DELIMITER $$
CREATE FUNCTION calculateTreatmentEndDate(
    p_startDate DATE,
    p_duration INT(11),
    p_uuidDurationUnit INT(11)) RETURNS DATE
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
    return p_drugName IN (
        "TDF+3TC+EFV",
        "AZT/3TC+EFV",
        "AZT+3TC+NVP",
        "TDF/3TC+NVP",
        "ABC+3TC+EFV",
        "ABC+3TC+NVP"
    );
END$$
DELIMITER ;

-- drugIsARVSecondLine

DROP FUNCTION IF EXISTS drugIsARVSecondLine;

DELIMITER $$
CREATE FUNCTION drugIsARVSecondLine(
    p_drugName VARCHAR(255)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    return p_drugName IN (
        "AZT+3TC+LPV/r",
        "AZT+3TC+ATZ/r",
        "ABC+3TC-LPV/r",
        "ABC+3TC+ATZ/r",
        "TDF+3TC+ATZ/r",
        "TDF+3TC+LPVr"
    );
END$$
DELIMITER ;

-- drugIsARVThirdLine

DROP FUNCTION IF EXISTS drugIsARVThirdLine;

DELIMITER $$
CREATE FUNCTION drugIsARVThirdLine(
    p_drugName VARCHAR(255)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    return p_drugName IN (
        "AZT+DRV+RTV",
        "ABC+DRV+RTV"
    );
END$$
DELIMITER ;