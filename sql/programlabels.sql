update program_attribute_type set description = 'PROGRAM_MANAGEMENT_ART_NUMBER', name = 'PROGRAM_MANAGEMENT_ART_NUMBER', datatype = 'org.openmrs.customdatatype.datatype.FreeTextDatatype', datatype_config = 'NULL' where name = 'ID_Number';
update program_attribute_type set description = 'PROGRAM_MANAGEMENT_PATIENT_STAGE', name = 'PROGRAM_MANAGEMENT_PATIENT_STAGE' where name = 'Stage';
update program_attribute_type set description = 'PROGRAM_MANAGEMENT_PATIENT_TREATMENT_DATE', name = 'PROGRAM_MANAGEMENT_PATIENT_TREATMENT_DATE' where name = 'Date';
update program_attribute_type set description = 'PROGRAM_MANAGEMENT_PATIENT_COMORBIDITES', name = 'PROGRAM_MANAGEMENT_PATIENT_COMORBIDITES' where name = 'Co-morbidites';
update program_attribute_type set description = 'PROGRAM_MANAGEMENT_PATIENT_DOCTOR_IN_CHARGE', name = 'PROGRAM_MANAGEMENT_PATIENT_DOCTOR_IN_CHARGE' where name = 'Doctor';
insert into program_attribute_type(name, description, datatype,creator, date_created, uuid) values("PROGRAM_MANAGEMENT_LABEL_THERAPEUTIC_LINE","PROGRAM_MANAGEMENT_LABEL_THERAPEUTIC_LINE","org.bahmni.module.bahmnicore.customdatatype.datatype.CodedConceptDatatype", 1, NOW(), "a8bc4608-eaae-4610-a842-d83d6261ea49");
update program_attribute_type set datatype_config=(select concept_id from concept where uuid="a8bc4608-eaae-4610-a842-d83d6261ea49") where uuid="a8bc4608-eaae-4610-a842-d83d6261ea49";
update program set name = 'HIV_PROGRAM_KEY' where name = 'HIV Program';
update program set name = 'TB_PROGRAM_KEY' where name = 'TB Program';