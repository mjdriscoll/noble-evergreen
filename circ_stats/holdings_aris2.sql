-- holdings_aris2.sql
-- Holdings by Aris Format with Nulls

SELECT aou.name AS "Library", sce.value AS "Aris Format", count(ac.id) AS "COUNT"
  FROM asset.copy ac
  JOIN actor.org_unit aou ON aou.id = ac.circ_lib
  LEFT OUTER JOIN asset.stat_cat_entry_copy_map scecm ON 
    (scecm.owning_copy = ac.id and scecm.stat_cat = 1)
  LEFT OUTER JOIN asset.stat_cat_entry sce ON sce.id = scecm.stat_cat_entry
  WHERE ac.deleted = false
  AND ac.create_date < '07/01/2013'
  GROUP by aou.name, sce.value

ORDER BY 1, 2;
