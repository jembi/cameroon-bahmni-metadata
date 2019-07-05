UPDATE program_attribute_type
SET
    datatype = 'org.bahmni.module.bahmnicore.customdatatype.datatype.CodedConceptDatatype',
    datatype_config = (
        SELECT concept_id
        FROM concept
        WHERE uuid = '6cf6c41e-9f39-4d92-a78d-18252eba93ff')
WHERE name = 'PROGRAM_MANAGEMENT_PATIENT_COMORBIDITES';