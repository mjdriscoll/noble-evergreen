WITH circs AS (
SELECT
  aou.name AS library,
  sce.value AS format,
  sce2.value as age,
  count(acirc.id) AS tot
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
  AND aou.name like 'Winthrop%'
  GROUP by 1,2,3)

SELECT
  library, format, age, tot
  FROM circs
  --WHERE a.age in ('Adult', 'Young Adult')
  --WHERE age in ('Childrens')
  --GROUP by 1,2
  ORDER by 1,2
;
