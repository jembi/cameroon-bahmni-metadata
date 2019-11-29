
-- patientHIVTestedPriorToEnrolOnANCFormWithinReportingPeriod

DROP FUNCTION IF EXISTS patientHIVTestedPriorToEnrolOnANCFormWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHIVTestedPriorToEnrolOnANCFormWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE hivTestedWithinReportingPeriod TINYINT(1) DEFAULT 0;
    DECLARE uuidHIVTested VARCHAR(38) DEFAULT "dbfbf26c-a236-40f7-812a-4171b0daac4c";
    DECLARE uuidYes VARCHAR(38) DEFAULT "a2065636-5326-40f5-aed6-0cc2cca81ccc";
    DECLARE priorToANCEnrolmentObsGroupId INT(11) DEFAULT getPriorToANCEnrolmentObsGroupId(p_patientId, p_startDate, p_endDate);

    SELECT
        TRUE INTO hivTestedWithinReportingPeriod
    FROM obs o
    JOIN concept c ON c.concept_id = o.concept_id AND c.retired = 0
    WHERE priorToANCEnrolmentObsGroupId IS NOT NULL
        AND o.obs_group_id = priorToANCEnrolmentObsGroupId
        AND o.voided = 0
        AND o.person_id = p_patientId
        AND c.uuid = uuidHIVTested
        AND o.value_coded IS NOT NULL
        AND o.value_coded = (SELECT concept_id FROM concept WHERE uuid = uuidYes)
        LIMIT 1;

    RETURN (hivTestedWithinReportingPeriod);
END$$
DELIMITER ;

-- patientHIVTestedAtEnrolOnANCFormWithinReportingPeriod

DROP FUNCTION IF EXISTS patientHIVTestedAtEnrolOnANCFormWithinReportingPeriod;

DELIMITER $$
CREATE FUNCTION patientHIVTestedAtEnrolOnANCFormWithinReportingPeriod(
    p_patientId INT(11),
    p_startDate DATE,
    p_endDate DATE) RETURNS TINYINT(1)
    DETERMINISTIC
BEGIN
    DECLARE hivTestDateWithinReportingPeriod TINYINT(1) DEFAULT 0;
    DECLARE uuidHIVTestDate VARCHAR(38) DEFAULT "c6c08cdc-18dc-4f42-809c-959621bc9a6c";
    DECLARE atANCEnrolmentObsGroupId INT(11) DEFAULT getAtEnrolOnANCFormObsGroupId(p_patientId, p_startDate, p_endDate);

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

    RETURN (hivTestDateWithinReportingPeriod);
END$$
DELIMITER ;
