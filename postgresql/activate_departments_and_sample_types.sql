-- psql -U postgres -d clinlims -a -f /bahmni/cameroon-bahmni-metadata/postgresql/activate_departments_and_sample_types.sql
update clinlims.test_section set is_active='N';
update clinlims.test_section set is_active='Y' where description in ('Bacteriology Dept Orders','Haematology Dept Orders','Biochemistry Dept Orders','Parasitology Dept Orders');
update clinlims.type_of_sample set is_active='N';
update clinlims.type_of_sample set is_active='Y' where description in ('Arteriall blood','Blood culture bottle','CSF sample','ESR tube','Plasma EDTA','Plasma Sodium citrate','Puncture liquid sample','Sperm','Serum','Sputum','Stool','Urethral smear sample','Urine sample','Urine Sediments sample','Vaginal Cervical smear sample');