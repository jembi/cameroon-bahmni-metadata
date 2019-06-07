-- psql -U clinlims -d clinlims -a -f /bahmni/cameroon-bahmni-metadata/postgresql/activate_departments_and_sample_types.sql
update test_section set is_active='N';
update test_section set is_active='Y' where description in ('Bacteriology Dept Orders','Haematology Dept Orders','Biochemistry Dept Orders','Parasitology Dept Orders');
update type_of_sample set is_active='N';
update type_of_sample set is_active='Y' where description in ('Arteriall blood','Blood culture bottle','CSF sample','ESR tube','Plasma EDTA','Plasma Sodium Citrate','Puncture liquid sample','Sperm','Serum','Sputum','Stool','Urethral smear sample','Urine Sample','Urine Sediments sample','Vaginal Cervical smear sample','Other Samples');