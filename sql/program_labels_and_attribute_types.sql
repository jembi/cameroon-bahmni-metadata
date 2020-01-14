update program_attribute_type set description = 'PROGRAM_MANAGEMENT_ART_NUMBER', name = 'PROGRAM_MANAGEMENT_ART_NUMBER', datatype = 'org.openmrs.customdatatype.datatype.FreeTextDatatype', datatype_config = 'NULL' where name = 'ID_Number';
update program_attribute_type set description = 'PROGRAM_MANAGEMENT_PATIENT_STAGE', name = 'PROGRAM_MANAGEMENT_PATIENT_STAGE' where name = 'Stage';
update program_attribute_type set description = 'PROGRAM_MANAGEMENT_PATIENT_TREATMENT_DATE', name = 'PROGRAM_MANAGEMENT_PATIENT_TREATMENT_DATE' where name = 'Date';
update program_attribute_type set description = 'PROGRAM_MANAGEMENT_PATIENT_COMORBIDITES', name = 'PROGRAM_MANAGEMENT_PATIENT_COMORBIDITES' where name = 'Co-morbidites';
update program_attribute_type set datatype = 'org.bahmni.module.bahmnicore.customdatatype.datatype.CodedConceptDatatype', datatype_config = (select concept_id from concept where uuid = '6cf6c41e-9f39-4d92-a78d-18252eba93ff') where name = 'PROGRAM_MANAGEMENT_PATIENT_COMORBIDITES';
update program_attribute_type set description = 'PROGRAM_MANAGEMENT_PATIENT_DOCTOR_IN_CHARGE', name = 'PROGRAM_MANAGEMENT_PATIENT_DOCTOR_IN_CHARGE' where name = 'Doctor';
insert ignore into program_attribute_type(name, description, datatype,creator, date_created, uuid) values("PROGRAM_MANAGEMENT_LABEL_THERAPEUTIC_LINE","PROGRAM_MANAGEMENT_LABEL_THERAPEUTIC_LINE","org.bahmni.module.bahmnicore.customdatatype.datatype.CodedConceptDatatype", 1, NOW(), "397b7bc7-13ca-4e4e-abc3-bf854904dce3");
update program_attribute_type set datatype_config=(select concept_id from concept where uuid="397b7bc7-13ca-4e4e-abc3-bf854904dce3") where name="PROGRAM_MANAGEMENT_LABEL_THERAPEUTIC_LINE";
update program set name = 'HIV_PROGRAM_KEY' where name = 'HIV Program';
update program set name = 'TB_PROGRAM_KEY' where name = 'TB Program';
update program set name = 'HIV_DEFAULTERS_PROGRAM_KEY' where name = 'HIV Defaulters Program';
insert ignore into program_attribute_type(name, description, datatype,creator, date_created, uuid) values("PROGRAM_MANAGEMENT_DURATION_ON_ART","PROGRAM_MANAGEMENT_DURATION_ON_ART","org.bahmni.module.bahmnicore.customdatatype.datatype.CodedConceptDatatype", 1, NOW(), "27441b69-84bd-4640-8682-92b6c0f449a0");
update program_attribute_type set datatype_config=(select concept_id from concept where uuid="8e259e94-b13d-48c4-a294-261aa243f92e") where name="PROGRAM_MANAGEMENT_DURATION_ON_ART";
insert ignore into program_attribute_type(name, description, datatype,creator, date_created, uuid) values("PROGRAM_MANAGEMENT_REASON_FOR_DEFAULTING","PROGRAM_MANAGEMENT_REASON_FOR_DEFAULTING","org.bahmni.module.bahmnicore.customdatatype.datatype.CodedConceptDatatype", 1, NOW(), "b42a880b-f8c4-4b85-a217-dd6188395d77");
update program_attribute_type set datatype_config=(select concept_id from concept where uuid="e5fe6f30-ea05-47f3-a31d-de81e46e7f3b") where name="PROGRAM_MANAGEMENT_REASON_FOR_DEFAULTING";
insert ignore into program_attribute_type(name, description, datatype,creator, date_created, uuid) values("PROGRAM_MANAGEMENT_LAST_FAILED_APPOINTMENT_DATE","PROGRAM_MANAGEMENT_LAST_FAILED_APPOINTMENT_DATE","org.openmrs.customdatatype.datatype.DateDatatype", 1, NOW(), "88a312a2-51a6-47e4-b725-e5b8b545ac4c");
insert ignore into program_attribute_type(name, description, datatype,creator, date_created, uuid) values("PROGRAM_MANAGEMENT_PRETRACKING_OUTCOME","PROGRAM_MANAGEMENT_PRETRACKING_OUTCOME","org.bahmni.module.bahmnicore.customdatatype.datatype.CodedConceptDatatype", 1, NOW(), "0a51d8d0-c775-48a2-9ca2-42c269d00bc2");
update program_attribute_type set datatype_config=(select concept_id from concept where uuid="7239a3a0-da2a-4940-bfab-8418246988d7") where name="PROGRAM_MANAGEMENT_PRETRACKING_OUTCOME";
insert ignore into program_attribute_type(name, description, datatype,creator, date_created, uuid) values("PROGRAM_MANAGEMENT_RETURNED_TO_TREATMENT_DATE","PROGRAM_MANAGEMENT_RETURNED_TO_TREATMENT_DATE","org.openmrs.customdatatype.datatype.DateDatatype", 1, NOW(), "b04fb0b8-3a1c-46fa-bf83-922513016b6b");
insert ignore into program_attribute_type(name, description, datatype,creator, date_created, uuid) values("PROGRAM_MANAGEMENT_TRACKING_DATE","PROGRAM_MANAGEMENT_TRACKING_DATE","org.openmrs.customdatatype.datatype.DateDatatype", 1, NOW(), "9b4b2dd5-bc5e-44b9-ad95-333a7bbfee3c");
insert ignore into program_attribute_type(name, description, datatype,creator, date_created, uuid) values("PROGRAM_MANAGEMENT_APS_NAME","PROGRAM_MANAGEMENT_APS_NAME","org.openmrs.customdatatype.datatype.FreeTextDatatype", 1, NOW(), "8bb0bdc0-aaf3-4501-8954-d1b17226075b");
insert ignore into program_attribute_type(name, description, datatype,creator, date_created, uuid) values("PROGRAM_MANAGEMENT_TRACKING_OUTCOME","PROGRAM_MANAGEMENT_TRACKING_OUTCOME","org.bahmni.module.bahmnicore.customdatatype.datatype.CodedConceptDatatype", 1, NOW(), "caf6d807-861d-4393-9d6e-940b98fa712d");
update program_attribute_type set datatype_config=(select concept_id from concept where uuid="c76d63ec-b7e2-44a4-88e0-a9961b49b80a") where name="PROGRAM_MANAGEMENT_TRACKING_OUTCOME";
