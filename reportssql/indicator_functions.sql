DROP FUNCTION IF EXISTS PECG_Indicator2;

DELIMITER $$
CREATE FUNCTION PECG_Indicator2(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_startDate) AND
    patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator3;

DELIMITER $$
CREATE FUNCTION PECG_Indicator3(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatmentDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientPickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator4;

DELIMITER $$
CREATE FUNCTION PECG_Indicator4(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod(pat.patient_id, p_endDate) AND
    IF (
        isOldPatient(pat.patient_id, p_startDate),
        patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0),
        patientPickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0)
    ) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator5;

DELIMITER $$
CREATE FUNCTION PECG_Indicator5(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod(pat.patient_id, p_endDate) AND
    IF (
        isOldPatient(pat.patient_id, p_startDate),
        patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, 1),
        patientPickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 1)
    ) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator6;

DELIMITER $$
CREATE FUNCTION PECG_Indicator6(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod(pat.patient_id, p_endDate) AND
    IF (
        isOldPatient(pat.patient_id, p_startDate),
        patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, 2),
        patientPickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 2)
    ) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator7;

DELIMITER $$
CREATE FUNCTION PECG_Indicator7(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod(pat.patient_id, p_endDate) AND
    IF (
        isOldPatient(pat.patient_id, p_startDate),
        patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, 3),
        patientPickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 3)
    ) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator11;

DELIMITER $$
CREATE FUNCTION PECG_Indicator11(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatment12MonthsAgo(pat.patient_id, p_startDate, p_endDate) AND
    patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator13;

DELIMITER $$
CREATE FUNCTION PECG_Indicator13(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatment12MonthsAgo(pat.patient_id, p_startDate, p_endDate) AND
    patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0) AND
    patientHadViralLoadTest3MonthsBeforeOrAfterReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator15;

DELIMITER $$
CREATE FUNCTION PECG_Indicator15(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatment12MonthsAgo(pat.patient_id, p_startDate, p_endDate) AND
    patientOnARVOrHasPickedUpADrugWithinExtendedPeriod(pat.patient_id, p_startDate, p_endDate, 0, 3) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator17;

DELIMITER $$
CREATE FUNCTION PECG_Indicator17(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_startDate) AND
    patientDidntCollectARV(pat.patient_id, p_startDate, p_endDate, 0, 0) AND
    patientHasScheduledAnARTAppointment(pat.patient_id, p_startDate, p_endDate, 0) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator18;

DELIMITER $$
CREATE FUNCTION PECG_Indicator18(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_startDate) AND
    patientDidntCollectARV(pat.patient_id, p_startDate, p_endDate, 0, -1) AND
    patientHasScheduledAnARTAppointment(pat.patient_id, p_startDate, p_endDate, -1) AND
    patientPickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_DATA_COLLECTION;

DELIMITER $$
CREATE FUNCTION PECG_DATA_COLLECTION(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasEnrolledIntoHivProgramDuringOrBeforeReportingPeriod(pat.patient_id, p_endDate) AND
    patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod(pat.patient_id, p_endDate) AND
    IF (
        isOldPatient(pat.patient_id, p_startDate),
        patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0),
        patientPickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0)
    ) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator14;

DELIMITER $$
CREATE FUNCTION PECG_Indicator14(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatment12MonthsAgo(pat.patient_id, p_startDate, p_endDate) AND
    patientOnARVOrHasPickedUpADrugWithinExtendedPeriod(pat.patient_id, p_startDate, p_endDate, 0, 3) AND
    patientIsVirallySuppressed3MonthsBeforeOrAfterReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator20;

DELIMITER $$
CREATE FUNCTION PECG_Indicator20(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasNotBeenEnrolledIntoHivProgram(pat.patient_id) AND
    patientHasPickedProphylaxisDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS TREATMENT_Indicator2;

DELIMITER $$
CREATE FUNCTION TREATMENT_Indicator2(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasEnrolledIntoHivProgramDuringOrBeforeReportingPeriod(pat.patient_id, p_endDate) AND
    patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod(pat.patient_id, p_endDate) AND
    IF (
        isOldPatient(pat.patient_id, p_startDate),
        patientWasOnARVTreatmentOrHasPickedUpADrugWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0),
        patientPickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0)
    ) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PECG_Indicator19;

DELIMITER $$
CREATE FUNCTION PECG_Indicator19(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasEnrolledIntoHivProgramDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientReasonForConsultationIsUnplannedAid(pat.patient_id) AND
    patientPickedARVDrugDuringReportingPeriodWithNoTherapeuticLine(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ; 

DROP FUNCTION IF EXISTS PECG_Indicator10;

DELIMITER $$
CREATE FUNCTION PECG_Indicator10(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatmentDuringOrBeforeReportingPeriod(pat.patient_id, p_endDate) AND
    patientOnARVOrHasPickedUpADrugWithinExtendedPeriod(pat.patient_id, p_startDate, p_endDate, 0, 0) AND
    patientHadTBExaminationDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS TREATMENT_Indicator1a;

DELIMITER $$
CREATE FUNCTION TREATMENT_Indicator1a(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasEnrolledIntoHivProgramDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientHasStartedARVTreatmentDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNewlyInitiatingART(pat.patient_id, p_startDate, p_endDate) AND
    patientIsPregnant(pat.patient_id) AND
    patientPickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);
    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS TREATMENT_Indicator1b;

DELIMITER $$
CREATE FUNCTION TREATMENT_Indicator1b(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasEnrolledIntoHivProgramBefore(pat.patient_id, p_startDate) AND
    patientHasStartedARVTreatmentBefore(pat.patient_id, p_startDate) AND
    patientAlreadyOnART(pat.patient_id, p_startDate) AND
    patientIsPregnant(pat.patient_id) AND
    patientOnARVOrHasPickedUpADrugWithinExtendedPeriod(pat.patient_id, p_startDate, p_endDate, 0, 0) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);
    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS TREATMENT_Indicator3;

DELIMITER $$
CREATE FUNCTION TREATMENT_Indicator3(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatmentDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientPickedARVDrugDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate, 0) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS viralSuppression_Indicator1c;

DELIMITER $$
CREATE FUNCTION viralSuppression_Indicator1c(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatmentBeforeExtendedEndDate(pat.patient_id, p_endDate, 3) AND
    patientWasOnARVTreatmentAtEndReportingPeriod(pat.patient_id, p_endDate) AND
    mostRecentNotDocumentedViralLoadExamIsBelow(pat.patient_id, p_endDate, 1000) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);
    RETURN (result);
END$$ 
DELIMITER ; 

DROP FUNCTION IF EXISTS viralSuppression_Indicator1a;

DELIMITER $$
CREATE FUNCTION viralSuppression_Indicator1a(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatmentBeforeExtendedEndDate(pat.patient_id, p_endDate, 3) AND
    patientWasOnARVTreatmentAtEndReportingPeriod(pat.patient_id, p_endDate) AND
    mostRecentRoutineViralLoadExamIsBelow(pat.patient_id, p_endDate, 1000) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);
    RETURN (result);
END$$ 
DELIMITER ; 

DROP FUNCTION IF EXISTS viralSuppression_Indicator1b;

DELIMITER $$
CREATE FUNCTION viralSuppression_Indicator1b(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1),
    p_gender VARCHAR(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientGenderIs(pat.patient_id, p_gender) AND
    patientAgeWhenRegisteredForHivProgramIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientHasStartedARVTreatmentBeforeExtendedEndDate(pat.patient_id, p_endDate, 3) AND
    patientWasOnARVTreatmentAtEndReportingPeriod(pat.patient_id, p_endDate) AND
    mostRecentTargetedViralLoadExamIsBelow(pat.patient_id, p_endDate, 1000) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);
    RETURN (result);
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator4a;

DELIMITER $$
CREATE FUNCTION Testing_Indicator4a(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientHIVPosPriorToEnrolOnANCForm(pat.patient_id, p_startDate, p_endDate) AND
    patientHadANCVisitWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND 
    patientGenderIs(pat.patient_id, 'F') AND
    (
        patientHIVDatePriorToEnrolOnANCForm3MOrLessBeforeReportEndDate(pat.patient_id, p_endDate) 
        OR
        (
            patientHIVDatePriorToEnrolOnANCFormMoreThan3MBeforeReportEndDate(pat.patient_id, p_endDate) AND
            patientHIVRetestPosPriorToEnrolOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
            NOT patientAlreadyOnARTOnANCFormBeforeReportEndDate(pat.patient_id, p_endDate) 
        )
        OR
        (
            patientHIVDatePriorToEnrolOnANCFormMoreThan3MBeforeReportEndDate(pat.patient_id, p_endDate) AND
            patientAlreadyOnARTOnANCFormBeforeReportEndDate(pat.patient_id, p_endDate)
        )
    );

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator4b;

DELIMITER $$
CREATE FUNCTION Testing_Indicator4b(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientHIVPosAtEnrolOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    NOT patientHIVPosPriorToEnrolOnANCForm(pat.patient_id, p_startDate, p_endDate) AND
    patientDateOfFirstANCVisitOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND 
    patientGenderIs(pat.patient_id, 'F');

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator4c;

DELIMITER $$
CREATE FUNCTION Testing_Indicator4c(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientHIVNegAtEnrolOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    NOT patientHIVPosPriorToEnrolOnANCForm(pat.patient_id, p_startDate, p_endDate) AND
    patientDateOfFirstANCVisitOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND 
    patientGenderIs(pat.patient_id, 'F');

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator4d;

DELIMITER $$
CREATE FUNCTION Testing_Indicator4d(
    p_startDate DATE,
    p_endDate DATE,
    p_startAge INT(11),
    p_endAge INT (11),
    p_includeEndAge TINYINT(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientHIVNegPriorToEnrolOnANCFormBeforeReportEndDate(pat.patient_id, p_startDate, p_endDate) AND
    patientNotEligibleForHIVRetestOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientDateOfFirstANCVisitOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientAgeIsBetween(pat.patient_id, p_startAge, p_endAge, p_includeEndAge) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND 
    patientGenderIs(pat.patient_id, 'F');

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator2;

DELIMITER $$
CREATE FUNCTION Testing_Indicator2(
    p_startDate DATE,
    p_endDate DATE,
    p_startAgeInMonths INT(11),
    p_endAgeInMonths INT (11),
    p_includeStartAge TINYINT(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    getDateOfVirologicTest(pat.patient_id, p_startDate, p_endDate) IS NOT NULL AND
    patientAgeAtVirologicHIVTestIsBetween(pat.patient_id, p_startAgeInMonths, p_endAgeInMonths, p_startDate, p_endDate, p_includeStartAge) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator3a;

DELIMITER $$
CREATE FUNCTION Testing_Indicator3a(
    p_startDate DATE,
    p_endDate DATE,
    p_startAgeInMonths INT(11),
    p_endAgeInMonths INT (11),
    p_includeStartAge TINYINT(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientHadAPositiveVirologicHIVTestResultDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientMostRecentVirologicHIVTestResultIsPositive(pat.patient_id) AND
    NOT patientHasEnrolledIntoHivProgramBefore(pat.patient_id, getDateOfVirologicTest(pat.patient_id, p_startDate, p_endDate)) AND
    NOT patientHasStartedARVTreatmentBefore(pat.patient_id, getDateOfVirologicTest(pat.patient_id, p_startDate, p_endDate)) AND
    NOT patientWasOnARVTreatmentAtEndReportingPeriod(pat.patient_id, getDateOfVirologicTest(pat.patient_id, p_startDate, p_endDate)) AND
    patientAgeAtVirologicHIVTestIsBetween(pat.patient_id, p_startAgeInMonths, p_endAgeInMonths, p_startDate, p_endDate, p_includeStartAge) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS Testing_Indicator3b;

DELIMITER $$
CREATE FUNCTION Testing_Indicator3b(
    p_startDate DATE,
    p_endDate DATE,
    p_startAgeInMonths INT(11),
    p_endAgeInMonths INT (11),
    p_includeStartAge TINYINT(1)) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientHadAPositiveVirologicHIVTestResultDuringReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientMostRecentVirologicHIVTestResultIsPositive(pat.patient_id) AND
    patientHasEnrolledIntoHivProgramBefore(pat.patient_id, getDateOfVirologicTest(pat.patient_id, p_startDate, p_endDate)) AND
    patientHasStartedARVTreatmentBefore(pat.patient_id, getDateOfVirologicTest(pat.patient_id, p_startDate, p_endDate)) AND
    patientWasOnARVTreatmentAtEndReportingPeriod(pat.patient_id, getDateOfVirologicTest(pat.patient_id, p_startDate, p_endDate)) AND
    patientAgeAtVirologicHIVTestIsBetween(pat.patient_id, p_startAgeInMonths, p_endAgeInMonths, p_startDate, p_endDate, p_includeStartAge) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PMTCT_Indicator1;

DELIMITER $$
CREATE FUNCTION PMTCT_Indicator1(
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    patientDateOfFirstANCVisitOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate);

    RETURN (result);
END$$ 
DELIMITER ;

DROP FUNCTION IF EXISTS PMTCT_Indicator2;

DELIMITER $$
CREATE FUNCTION PMTCT_Indicator2(
    p_startDate DATE,
    p_endDate DATE) RETURNS INT(11)
    DETERMINISTIC
BEGIN
    DECLARE result INT(11) DEFAULT 0;

SELECT
    COUNT(DISTINCT pat.patient_id) INTO result
FROM
    patient pat
WHERE
    NOT patientHIVTestedPriorToEnrolOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientHIVTestedAtEnrolOnANCFormWithinReportingPeriod(pat.patient_id, p_startDate, p_endDate) AND
    patientIsNotDead(pat.patient_id) AND
    patientIsNotLostToFollowUp(pat.patient_id) AND
    patientIsNotTransferredOut(pat.patient_id) AND 
    patientGenderIs(pat.patient_id, 'F');

    RETURN (result);
END$$ 
DELIMITER ;
