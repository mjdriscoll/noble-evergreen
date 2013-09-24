--circs_by_aris.sql
-- circs by ARIS Format
-- includes staff renewals, not web renewals
-- 7/1/13 include circs in aged_circulation

SELECT aou.name AS "Library", sce.value AS "Aris Format", sce2.value as "Aris Age", count(acirc.id) AS "CHECKOUTS"
  FROM action.circulation acirc
  JOIN actor.workstation aw ON acirc.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  JOIN asset.stat_cat_entry_copy_map scecm ON
    (scecm.owning_copy = acirc.target_copy and scecm.stat_cat = 1)
  JOIN asset.stat_cat_entry sce ON sce.id = scecm.stat_cat_entry
  JOIN asset.stat_cat_entry_copy_map scecm2 ON
    (scecm2.owning_copy = acirc.target_copy and scecm2.stat_cat = 2)
  JOIN asset.stat_cat_entry sce2 ON sce2.id = scecm2.stat_cat_entry
  WHERE acirc.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  --AND aou.name like 'Winthrop%'
  GROUP by aou.name, sce.value, sce2.value

UNION

SELECT aou.name AS "Library", sce.value AS "Aris Format", sce2.value as "Aris Age", count(aged.id) AS "CHECKOUTS"
  FROM action.aged_circulation aged
  JOIN actor.workstation aw ON aged.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  JOIN asset.stat_cat_entry_copy_map scecm ON
    (scecm.owning_copy = aged.target_copy and scecm.stat_cat = 1)
  JOIN asset.stat_cat_entry sce ON sce.id = scecm.stat_cat_entry
  JOIN asset.stat_cat_entry_copy_map scecm2 ON
    (scecm2.owning_copy = aged.target_copy and scecm2.stat_cat = 2)
  JOIN asset.stat_cat_entry sce2 ON sce2.id = scecm2.stat_cat_entry
  WHERE aged.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  --AND aou.name like 'Winthrop%'
  GROUP by aou.name, sce.value, sce2.value

--SELECT 'ZZZ Total' AS "Library", '' AS "Aris Format", '' AS "Aris Age", count(acirc.id) AS "CHECKOUTS"
--  FROM action.circulation acirc
--  JOIN actor.workstation aw ON acirc.workstation = aw.id
--  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
--  JOIN asset.stat_cat_entry_copy_map scecm ON
--    (scecm.owning_copy = acirc.target_copy and scecm.stat_cat = 1)
--  JOIN asset.stat_cat_entry sce ON sce.id = scecm.stat_cat_entry
--  JOIN asset.stat_cat_entry_copy_map scecm2 ON
--    (scecm2.owning_copy = acirc.target_copy and scecm2.stat_cat = 2)
--  JOIN asset.stat_cat_entry sce2 ON sce2.id = scecm2.stat_cat_entry
--  WHERE acirc.create_time between '05/29/2012 00:00:01' and '06/30/2013 23:59:59'
--  --AND aou.name like 'Winthrop%'

ORDER BY 1, 3, 2;
