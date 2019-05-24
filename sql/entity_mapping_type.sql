INSERT IGNORE INTO entity_mapping_type
    (name,uuid,entity1_type,entity2_type)
VALUES
    ('visit_location',uuid(),'org.openmrs.VisitType','org.openmrs.Location');
