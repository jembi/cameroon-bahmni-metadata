update program_attribute_type set description = 'PROGRAM_MANAGEMENT_ART_NUMBER', name = 'PROGRAM_MANAGEMENT_ART_NUMBER', datatype = 'org.openmrs.customdatatype.datatype.FreeTextDatatype', datatype_config = 'NULL' where name = 'ID_Number';
update program_attribute_type set description = 'PROGRAM_MANAGEMENT_PATIENT_STAGE', name = 'PROGRAM_MANAGEMENT_PATIENT_STAGE' where name = 'Stage';
