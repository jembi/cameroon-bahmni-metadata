INSERT INTO unit_of_measure
SELECT (SELECT id + 1 FROM unit_of_measure ORDER BY id DESC LIMIT 1), 'copies/ml', 'copies/ml', NOW()
FROM unit_of_measure
WHERE (description = 'copies/ml')
HAVING COUNT(*) = 0;
update test set uom_id = (select id from unit_of_measure where description = 'copies/ml') where description = 'Not Documented Viral Load';
update test set uom_id = (select id from unit_of_measure where description = 'copies/ml') where description = 'Targeted Viral Load';
update test set uom_id = (select id from unit_of_measure where description = 'copies/ml') where description = 'Routine Viral Load';