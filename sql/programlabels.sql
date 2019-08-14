update program_attribute_type set description = 'PROGRAM_MANAGEMENT_ART_NUMBER', name = 'PROGRAM_MANAGEMENT_ART_NUMBER', datatype = 'org.openmrs.customdatatype.datatype.FreeTextDatatype', datatype_config = 'NULL' where name = 'ID_Number';
update program_attribute_type set description = 'PROGRAM_MANAGEMENT_PATIENT_STAGE', name = 'PROGRAM_MANAGEMENT_PATIENT_STAGE' where name = 'Stage';
update program_attribute_type set description = 'PROGRAM_MANAGEMENT_PATIENT_TREATMENT_DATE', name = 'PROGRAM_MANAGEMENT_PATIENT_TREATMENT_DATE' where name = 'Date';
update program_attribute_type set description = 'PROGRAM_MANAGEMENT_PATIENT_COMORBIDITES', name = 'PROGRAM_MANAGEMENT_PATIENT_COMORBIDITES' where name = 'Co-morbidites';
update program_attribute_type set datatype = 'org.bahmni.module.bahmnicore.customdatatype.datatype.CodedConceptDatatype', datatype_config = (select concept_id from concept where uuid = '6cf6c41e-9f39-4d92-a78d-18252eba93ff') where name = 'PROGRAM_MANAGEMENT_PATIENT_COMORBIDITES';
update program_attribute_type set description = 'PROGRAM_MANAGEMENT_PATIENT_DOCTOR_IN_CHARGE', name = 'PROGRAM_MANAGEMENT_PATIENT_DOCTOR_IN_CHARGE' where name = 'Doctor';
update program set name = 'HIV_PROGRAM_KEY' where name = 'HIV Program';
update program set name = 'TB_PROGRAM_KEY' where name = 'TB Program';