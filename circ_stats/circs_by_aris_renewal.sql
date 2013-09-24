--circs_by_aris_renewal.sql
-- circs by ARIS Format renewals, count by copy owning library and workstation is NULL

SELECT aou.name AS "Library", sce.value AS "Aris Format", sce2.value AS "Aris Age", count(acirc.id) AS "RENEWALS"
  FROM action.circulation acirc
  JOIN asset.copy ac ON acirc.target_copy = ac.id
  JOIN actor.org_unit aou ON acirc.circ_lib = aou.id
  JOIN asset.stat_cat_entry_copy_map scecm ON 
    (scecm.owning_copy = acirc.target_copy and scecm.stat_cat = 1)
  JOIN asset.stat_cat_entry sce ON sce.id = scecm.stat_cat_entry
  JOIN asset.stat_cat_entry_copy_map scecm2 ON
    (scecm2.owning_copy = acirc.target_copy and scecm2.stat_cat = 2)
  JOIN asset.stat_cat_entry sce2 ON sce2.id = scecm2.stat_cat_entry
  WHERE acirc.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND aou.name like 'Lynnfiel%'
  AND acirc.workstation IS NULL
  GROUP by aou.name, sce.value, sce2.value

UNION

SELECT aou.name AS "Library", sce.value AS "Aris Format", sce2.value AS "Aris Age", count(aged.id) AS "RENEWALS"
  FROM action.aged_circulation aged
  JOIN asset.copy ac ON aged.target_copy = ac.id
  JOIN actor.org_unit aou ON aged.circ_lib = aou.id
  JOIN asset.stat_cat_entry_copy_map scecm ON
    (scecm.owning_copy = aged.target_copy and scecm.stat_cat = 1)
  JOIN asset.stat_cat_entry sce ON sce.id = scecm.stat_cat_entry
  JOIN asset.stat_cat_entry_copy_map scecm2 ON
    (scecm2.owning_copy = aged.target_copy and scecm2.stat_cat = 2)
  JOIN asset.stat_cat_entry sce2 ON sce2.id = scecm2.stat_cat_entry
  WHERE aged.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND aou.name like 'Lynnfiel%'
  AND aged.workstation IS NULL
  GROUP by aou.name, sce.value, sce2.value

--SELECT 'ZZZ Total' AS "Library", '' AS "Aris Format", '' AS "Aris Age", count(acirc.id) AS "RENEWALS"
--  FROM action.circulation acirc
--  JOIN asset.copy ac ON acirc.target_copy = ac.id
--  JOIN actor.org_unit aou ON acirc.circ_lib = aou.id
--  JOIN asset.stat_cat_entry_copy_map scecm ON 
--    (scecm.owning_copy = acirc.target_copy and scecm.stat_cat = 1)
--  JOIN asset.stat_cat_entry sce ON sce.id = scecm.stat_cat_entry
--  JOIN asset.stat_cat_entry_copy_map scecm2 ON
--    (scecm2.owning_copy = acirc.target_copy and scecm2.stat_cat = 2)
--  JOIN asset.stat_cat_entry sce2 ON sce2.id = scecm2.stat_cat_entry
--  WHERE acirc.create_time between '05/29/2012 00:00:01' and '06/30/2012 23:59:59'
--  --AND aou.name like 'Winthrop%'
--  AND acirc.workstation IS NULL

ORDER BY 1, 3, 2;
