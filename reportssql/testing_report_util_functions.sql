-- getLatestPriorToANCEnrolmentObsGroupIdForPatient

DROP FUNCTION IF EXISTS getLatestPriorToANCEnrolmentObsGroupIdForPatient;

DELIMITER $$
CREATE FUNCTION getLatestPriorToANCEnrolmentObsGroupIdForPatient(
    p_patientId INT(11)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE priorToANCEnrolmentObsGroupId INT(11) DEFAULT NULL;
    DECLARE uuidPriorToANCEnrolment VARCHAR(38) DEFAULT "130e05df-8283-453b-a611-d4f884fac8e0";

    SELECT
        o.obs_id INTO priorToANCEnrolmentObsGroupId
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidPriorToANCEnrolment
        ORDER BY o.obs_datetime DESC
        LIMIT 1;
    RETURN priorToANCEnrolmentObsGroupId;
END$$
DELIMITER ;

-- patientHIVPosPriorToEnrolOnANCForm

DROP FUNCTION IF EXISTS patientHIVPosPriorToEnrolOnANCForm;

DELIMITER $$
CREATE FUNCTION patientHIVPosPriorToEnrolOnANCForm(
    p_patientId INT(11)) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE patientHIVResultIsPositive TINYINT(1) DEFAULT 0;
    DECLARE uuidHIVTestResult VARCHAR(38) DEFAULT "85dadffe-5714-4210-8632-6fb51ef593b6";
    DECLARE uuidHIVTestResultPositive VARCHAR(38) DEFAULT "7acfafa4-f19b-485e-97a7-c9e002dbe37a";
    DECLARE priorToANCEnrolmentObsGroupId INT(11) DEFAULT getLatestPriorToANCEnrolmentObsGroupIdForPatient(p_patientId);
    
    SELECT
        TRUE INTO patientHIVResultIsPositive
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE priorToANCEnrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = priorToANCEnrolmentObsGroupId
        AND o.voided = 0 
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestResult
        AND o.value_coded IS NOT NULL
        AND o.value_coded = (SELECT concept_id FROM concept WHERE uuid = uuidHIVTestResultPositive)
        LIMIT 1;

    RETURN (patientHIVResultIsPositive);
END$$
DELIMITER ;

-- patientHadANCVisitWithinReportingPeriod

DROP FUNCTION IF EXISTS patientHadANCVisitWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHadANCVisitWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE uuidvisitTypeANC VARCHAR(38) DEFAULT "a71de1a2-aa43-496a-a533-13f47fad0129";

    SELECT
        TRUE INTO result
    FROM visit v
    JOIN visit_type vt ON vt.visit_type_id = v.visit_type_id AND vt.retired = 0
    WHERE v.voided = 0
        AND v.patient_id = p_patientId
        AND vt.uuid = uuidvisitTypeANC
        AND v.date_started IS NOT NULL
        AND DATE(v.date_started) BETWEEN p_startDate AND p_endDate;

    RETURN (result );
END$$
DELIMITER ;

-- patientHIVRetestPosPriorToEnrolOnANCFormWithinReportingPeriod

DROP FUNCTION IF EXISTS patientHIVRetestPosPriorToEnrolOnANCFormWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHIVRetestPosPriorToEnrolOnANCFormWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE patientHIVRetestResultIsPositive TINYINT(1) DEFAULT 0;
    DECLARE patientRepeatTestDateIsBetweenReportingPeriod TINYINT(1) DEFAULT 0;
    DECLARE uuidRepeatTestResult VARCHAR(38) DEFAULT "7682c09b-8e81-4e30-8afd-636fb9fcd4a1";
    DECLARE uuidRepeatTestResultIsPositive VARCHAR(38) DEFAULT "7acfafa4-f19b-485e-97a7-c9e002dbe37a";
    DECLARE uuidRepeatTestDate VARCHAR(38) DEFAULT "541d9f7b-f622-4ebc-a3a3-50c970d4cce0";
    DECLARE priorToANCEnrolmentObsGroupId INT(11) DEFAULT getLatestPriorToANCEnrolmentObsGroupIdForPatient(p_patientId);
    
    SELECT
        TRUE INTO patientHIVRetestResultIsPositive
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE priorToANCEnrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = priorToANCEnrolmentObsGroupId
        AND o.voided = 0 
        AND o.person_id = p_patientId
        AND c.uuid = uuidRepeatTestResult
        AND o.value_coded IS NOT NULL
        AND o.value_coded = (SELECT concept_id FROM concept WHERE uuid = uuidRepeatTestResultIsPositive)
        LIMIT 1;

    SELECT
        TRUE INTO patientRepeatTestDateIsBetweenReportingPeriod
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE priorToANCEnrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = priorToANCEnrolmentObsGroupId
        AND o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidRepeatTestDate
        AND DATE(o.value_datetime) BETWEEN p_startDate AND p_endDate
        LIMIT 1;

    RETURN (patientHIVRetestResultIsPositive && patientRepeatTestDateIsBetweenReportingPeriod);
END$$
DELIMITER ;

-- patientHIVDatePriorToEnrolOnANCFormMoreThan3MBeforeReportEndDate

DROP FUNCTION IF EXISTS patientHIVDatePriorToEnrolOnANCFormMoreThan3MBeforeReportEndDate;

DELIMITER $$
CREATE FUNCTION patientHIVDatePriorToEnrolOnANCFormMoreThan3MBeforeReportEndDate(
    p_patientId INT(11),
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE uuidHIVTestDate VARCHAR(38) DEFAULT "c6c08cdc-18dc-4f42-809c-959621bc9a6c";
    DECLARE priorToANCEnrolmentObsGroupId INT(11) DEFAULT getLatestPriorToANCEnrolmentObsGroupIdForPatient(p_patientId);

    SELECT
        TRUE INTO result
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE priorToANCEnrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = priorToANCEnrolmentObsGroupId
        AND o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestDate
        AND o.value_datetime IS NOT NULL
        AND timestampdiff(MONTH, CAST(o.value_datetime AS DATE), p_endDate) > 3
        LIMIT 1;

    RETURN (result );
END$$
DELIMITER ;

-- patientHIVDatePriorToEnrolOnANCForm3MOrLessBeforeReportEndDate

DROP FUNCTION IF EXISTS patientHIVDatePriorToEnrolOnANCForm3MOrLessBeforeReportEndDate;

DELIMITER $$
CREATE FUNCTION patientHIVDatePriorToEnrolOnANCForm3MOrLessBeforeReportEndDate(
    p_patientId INT(11),
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE result TINYINT(1) DEFAULT 0;
    DECLARE uuidHIVTestDate VARCHAR(38) DEFAULT "c6c08cdc-18dc-4f42-809c-959621bc9a6c";
    DECLARE priorToANCEnrolmentObsGroupId INT(11) DEFAULT getLatestPriorToANCEnrolmentObsGroupIdForPatient(p_patientId);
    
    SELECT
        TRUE INTO result
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE priorToANCEnrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = priorToANCEnrolmentObsGroupId
        AND o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestDate
        AND o.value_datetime IS NOT NULL
        AND timestampdiff(MONTH, CAST(o.value_datetime AS DATE), p_endDate) BETWEEN 0 AND 3
        LIMIT 1;

    RETURN (result );
END$$
DELIMITER ;

-- patientAlreadyOnARTOnANCFormBeforeReportEndDate

DROP FUNCTION IF EXISTS patientAlreadyOnARTOnANCFormBeforeReportEndDate;

DELIMITER $$
CREATE FUNCTION patientAlreadyOnARTOnANCFormBeforeReportEndDate(
    p_patientId INT(11),
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE ARTStartedBeforeReportEndDate TINYINT(1) DEFAULT 0;
    DECLARE uuidARTStatus VARCHAR(38) DEFAULT "f961ec41-cd5d-4b45-91e0-0f5a408fea4b";
    DECLARE uuidAlreadyOnART VARCHAR(38) DEFAULT "6122279f-93a8-4e5a-ac5e-b347b60c989b";
    DECLARE uuidARTStartDate VARCHAR(38) DEFAULT "d986e715-14fd-4ae1-9ef2-7a60e3a6a54e";
    DECLARE uuidArvsArt VARCHAR(38) DEFAULT "89b1cd66-c33a-4ef4-b208-5d86502f14ec";
    DECLARE arvsArtObsGroupId INT(11) DEFAULT NULL;

    SELECT
        o.obs_group_id INTO arvsArtObsGroupId
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidARTStatus
        AND o.value_coded = (SELECT concept_id FROM concept WHERE uuid = uuidAlreadyOnART)
    LIMIT 1;

    SELECT
        TRUE INTO ARTStartedBeforeReportEndDate
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE arvsArtObsGroupId IS NOT NULL
        AND o.obs_group_id = arvsArtObsGroupId
        AND o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidARTStartDate
        AND DATE(o.value_datetime) < p_endDate
        LIMIT 1;

    RETURN ARTStartedBeforeReportEndDate;
END$$
DELIMITER ;

-- getLatestAtEnrolOnANCFormObsGroupIdForPatient

DROP FUNCTION IF EXISTS getLatestAtEnrolOnANCFormObsGroupIdForPatient;

DELIMITER $$
CREATE FUNCTION getLatestAtEnrolOnANCFormObsGroupIdForPatient(
    p_patientId INT(11)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE atANCEnrolmentObsGroupId INT(11) DEFAULT NULL;
    DECLARE uuidAtToANCEnrolment VARCHAR(38) DEFAULT "d6cc3709-ffa0-42eb-b388-d7def4df30cf";

    SELECT
        o.obs_id INTO atANCEnrolmentObsGroupId
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidAtToANCEnrolment
        ORDER BY o.obs_datetime DESC
        LIMIT 1;
    RETURN atANCEnrolmentObsGroupId;
END$$
DELIMITER ;

-- patientHIVPosAtEnrolOnANCFormWithinReportingPeriod

DROP FUNCTION IF EXISTS patientHIVPosAtEnrolOnANCFormWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHIVPosAtEnrolOnANCFormWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE patientHIVResultIsPositive TINYINT(1) DEFAULT 0;
    DECLARE hivTestDateWithinReportingPeriod TINYINT(1) DEFAULT 0;
    DECLARE uuidHIVTestResult VARCHAR(38) DEFAULT "85dadffe-5714-4210-8632-6fb51ef593b6";
    DECLARE uuidHIVTestResultPositive VARCHAR(38) DEFAULT "7acfafa4-f19b-485e-97a7-c9e002dbe37a";
    DECLARE uuidHIVTestDate VARCHAR(38) DEFAULT "c6c08cdc-18dc-4f42-809c-959621bc9a6c";
    DECLARE atANCEnrolmentObsGroupId INT(11) DEFAULT getLatestAtEnrolOnANCFormObsGroupIdForPatient(p_patientId);
    
    SELECT
        TRUE INTO patientHIVResultIsPositive
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE atANCEnrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = atANCEnrolmentObsGroupId
        AND o.voided = 0 
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestResult
        AND o.value_coded IS NOT NULL
        AND o.value_coded = (SELECT concept_id FROM concept WHERE uuid = uuidHIVTestResultPositive)
        LIMIT 1;

    SELECT
        TRUE INTO hivTestDateWithinReportingPeriod
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE atANCEnrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = atANCEnrolmentObsGroupId
        AND o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestDate
        AND DATE(o.value_datetime) BETWEEN p_startDate AND p_endDate
        LIMIT 1;

    RETURN (patientHIVResultIsPositive && hivTestDateWithinReportingPeriod);
END$$
DELIMITER ;

-- patientDateOfFirstANCVisitOnANCFormWithinReportingPeriod

DROP FUNCTION IF EXISTS patientDateOfFirstANCVisitOnANCFormWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientDateOfFirstANCVisitOnANCFormWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE dateOfANC1WithinReportingPeriod TINYINT(1) DEFAULT 0;
    DECLARE uuiddateOfANC1 VARCHAR(38) DEFAULT "57d91463-1b95-4e4d-9448-ee4e88c53cb9";
    
    SELECT
        TRUE INTO dateOfANC1WithinReportingPeriod
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0 
        AND o.person_id = p_patientId
        AND c.uuid = uuiddateOfANC1
        AND DATE(o.value_datetime) BETWEEN p_startDate AND p_endDate
        LIMIT 1;

    RETURN (dateOfANC1WithinReportingPeriod);
END$$
DELIMITER ;

-- patientHIVNegAtEnrolOnANCFormWithinReportingPeriod

DROP FUNCTION IF EXISTS patientHIVNegAtEnrolOnANCFormWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHIVNegAtEnrolOnANCFormWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE patientHIVResultIsNegative TINYINT(1) DEFAULT 0;
    DECLARE hivTestDateWithinReportingPeriod TINYINT(1) DEFAULT 0;
    DECLARE uuidHIVTestResult VARCHAR(38) DEFAULT "85dadffe-5714-4210-8632-6fb51ef593b6";
    DECLARE uuidHIVTestResultNegative VARCHAR(38) DEFAULT "718b4589-2a11-4355-b8dc-aa668a93e098";
    DECLARE uuidHIVTestDate VARCHAR(38) DEFAULT "c6c08cdc-18dc-4f42-809c-959621bc9a6c";
    DECLARE atANCEnrolmentObsGroupId INT(11) DEFAULT getLatestAtEnrolOnANCFormObsGroupIdForPatient(p_patientId);
    
    SELECT
        TRUE INTO patientHIVResultIsNegative
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE atANCEnrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = atANCEnrolmentObsGroupId
        AND o.voided = 0 
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestResult
        AND o.value_coded IS NOT NULL
        AND o.value_coded = (SELECT concept_id FROM concept WHERE uuid = uuidHIVTestResultNegative)
        LIMIT 1;

    SELECT
        TRUE INTO hivTestDateWithinReportingPeriod
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE atANCEnrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = atANCEnrolmentObsGroupId
        AND o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestDate
        AND DATE(o.value_datetime) BETWEEN p_startDate AND p_endDate
        LIMIT 1;

    RETURN (patientHIVResultIsNegative && hivTestDateWithinReportingPeriod);
END$$
DELIMITER ;

-- patientHIVNegPriorToEnrolOnANCFormBeforeReportEndDate

DROP FUNCTION IF EXISTS patientHIVNegPriorToEnrolOnANCFormBeforeReportEndDate;

DELIMITER $$
CREATE FUNCTION patientHIVNegPriorToEnrolOnANCFormBeforeReportEndDate(
    p_patientId INT(11),
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE patientHIVResultIsNegative TINYINT(1) DEFAULT 0;
    DECLARE hivTestDateBeforeReportEndDate TINYINT(1) DEFAULT 0;
    DECLARE uuidHIVTestResult VARCHAR(38) DEFAULT "85dadffe-5714-4210-8632-6fb51ef593b6";
    DECLARE uuidHIVTestResultNegative VARCHAR(38) DEFAULT "718b4589-2a11-4355-b8dc-aa668a93e098";
    DECLARE uuidHIVTestDate VARCHAR(38) DEFAULT "c6c08cdc-18dc-4f42-809c-959621bc9a6c";
    DECLARE priorToANCEnrolmentObsGroupId INT(11) DEFAULT getLatestPriorToANCEnrolmentObsGroupIdForPatient(p_patientId);
    
    SELECT
        TRUE INTO patientHIVResultIsNegative
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE priorToANCEnrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = priorToANCEnrolmentObsGroupId
        AND o.voided = 0 
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestResult
        AND o.value_coded IS NOT NULL
        AND o.value_coded = (SELECT concept_id FROM concept WHERE uuid = uuidHIVTestResultNegative)
        LIMIT 1;

    SELECT
        TRUE INTO hivTestDateBeforeReportEndDate
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE priorToANCEnrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = priorToANCEnrolmentObsGroupId
        AND o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTestDate
        AND DATE(o.value_datetime) < p_endDate
        LIMIT 1;

    RETURN (patientHIVResultIsNegative && hivTestDateBeforeReportEndDate);
END$$
DELIMITER ;

-- patientNotEligibleForHIVRetestOnANCFormWithinReportingPeriod

DROP FUNCTION IF EXISTS patientNotEligibleForHIVRetestOnANCFormWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientNotEligibleForHIVRetestOnANCFormWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE patientNotEligibleWithinReportingPeriod TINYINT(1) DEFAULT 0;
    DECLARE uuidRetestEligibleQuestion VARCHAR(38) DEFAULT "9fda317c-9fd4-4423-a09b-dd4ba86a8a61";
    DECLARE uuidNo VARCHAR(38) DEFAULT "b497171e-0410-4d8d-bbd4-7e1a8f8b504e";

    SELECT
        TRUE INTO patientNotEligibleWithinReportingPeriod
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE o.voided = 0 
        AND o.person_id = p_patientId
        AND c.uuid = uuidRetestEligibleQuestion
        AND o.value_coded IS NOT NULL
        AND o.value_coded = (SELECT concept_id FROM concept WHERE uuid = uuidNo)
        AND DATE(o.obs_datetime) BETWEEN p_startDate AND p_endDate
        LIMIT 1;

    RETURN patientNotEligibleWithinReportingPeriod;
END$$
DELIMITER ;
