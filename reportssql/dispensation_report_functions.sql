DROP FUNCTION IF EXISTS getNumberOfTherapeuticLineARVDispensed;

DELIMITER $$
CREATE FUNCTION getNumberOfTherapeuticLineARVDispensed(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_arvName VARCHAR(255),
    p_protocolLineNumber INT(11)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT count(DISTINCT o.order_id) INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept_name cn ON cn.concept_id = d.concept_id AND cn.locale = "en"
    WHERE o.voided = 0
        AND drugIsARV(d.concept_id)
        AND drugOrderIsDispensed(o.patient_id, o.order_id)
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND cn.name = p_arvName
        AND patientWithTherapeuticLinePickedARVDrugDuringReportingPeriod(o.patient_id, p_startDate, p_endDate, p_protocolLineNumber)
        AND patientAgeIsBetween(o.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS getNumberOfProphylaxisARVDispensed;

DELIMITER $$
CREATE FUNCTION getNumberOfProphylaxisARVDispensed(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_arvName VARCHAR(255)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT count(DISTINCT o.order_id) INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept_name cn ON cn.concept_id = d.concept_id AND cn.locale = "en"
    WHERE o.voided = 0
        AND IF (
            patientIsAdult(o.patient_id),
            drugIsAdultProphylaxis(d.concept_id),
            drugIsChildProphylaxis(d.concept_id))
        AND cn.name = p_arvName
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND drugOrderIsDispensed(o.patient_id, o.order_id)
        AND patientAgeIsBetween(o.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS getNumberOfPunctualAidARVDispensed;

DELIMITER $$
CREATE FUNCTION getNumberOfPunctualAidARVDispensed(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_arvName VARCHAR(255)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT count(DISTINCT o.order_id) INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept_name cn ON cn.concept_id = d.concept_id AND cn.locale = "en"
    WHERE o.voided = 0
        AND patientReasonForConsultationIsUnplannedAid(o.patient_id)
        AND drugIsARV(d.concept_id)
        AND cn.name = p_arvName
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND drugOrderIsDispensed(o.patient_id, o.order_id)
        AND patientAgeIsBetween(o.patient_id, p_startAge, p_endAge, p_includeEndAge);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS getNumberOfARVPrescribed;

DELIMITER $$
CREATE FUNCTION getNumberOfARVPrescribed(
    p_startDate DATE,
    p_endDate DATE,
    p_arvName VARCHAR(255)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT count(DISTINCT o.order_id) INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept_name cn ON cn.concept_id = d.concept_id AND cn.locale = "en"
    WHERE o.voided = 0
        AND drugIsARV(d.concept_id)
        AND cn.name = p_arvName
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate;

    RETURN (result);
END$$ 
DELIMITER ;


DROP FUNCTION IF EXISTS getNumberOfARVDispensed;

DELIMITER $$
CREATE FUNCTION getNumberOfARVDispensed(
    p_startDate DATE,
    p_endDate DATE,
    p_arvName VARCHAR(255)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

    SELECT count(DISTINCT o.order_id) INTO result
    FROM orders o
        JOIN drug_order do ON do.order_id = o.order_id
        JOIN drug d ON d.drug_id = do.drug_inventory_id AND d.retired = 0
        JOIN concept_name cn ON cn.concept_id = d.concept_id AND cn.locale = "en"
    WHERE o.voided = 0
        AND drugIsARV(d.concept_id)
        AND cn.name = p_arvName
        AND o.scheduled_date BETWEEN p_startDate AND p_endDate
        AND drugOrderIsDispensed(o.patient_id, o.order_id);

    RETURN (result);
END$$ 
DELIMITER ;
