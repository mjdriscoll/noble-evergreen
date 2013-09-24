-- holdings_aris.sql

SELECT aou.name AS "Library", sce.value AS "Aris Format", sce2.value AS "Aris Age", count(ac.id) AS "COUNT"
  FROM asset.copy ac
  JOIN actor.org_unit aou ON aou.id = ac.circ_lib
  JOIN asset.stat_cat_entry_copy_map scecm ON 
    (scecm.owning_copy = ac.id and scecm.stat_cat = 1)
  JOIN asset.stat_cat_entry_copy_map scecm2 ON 
    (scecm2.owning_copy = ac.id and scecm2.stat_cat = 2)
  JOIN asset.stat_cat_entry sce ON sce.id = scecm.stat_cat_entry
  JOIN asset.stat_cat_entry sce2 ON sce2.id = scecm2.stat_cat_entry
  WHERE ac.deleted = false
  AND aou.name like 'Lynnfie%'
  AND ac.active_date < '07/01/2013'
  GROUP by aou.name, sce.value, sce2.value

ORDER BY 1, 2, 3;
