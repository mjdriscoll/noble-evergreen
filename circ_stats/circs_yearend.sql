-- circs_yearend.sql
-- circs by ARIS Format and AGE
-- includes staff renewals AND web renewals
-- includes circs in aged_circulation
-- exclude patron profile 70 Non-circulating and 125 ILL Card
-- exclude circ modifier 'part'

SELECT
  x.library, x.format, sum(x.tota) AS "Adult", sum(x.toty) AS "YA", sum(x.totc) AS "Child"
  FROM (

  SELECT
  aou.name AS library,
  CASE
    WHEN sce.value in ('28') THEN 'Virtcat' ELSE sce.value
  END AS format,
  sce2.value as age,
  CASE
    WHEN sce2.value IN ('Adult', '27') 
      THEN count(acirc.id) ELSE 0
    END AS tota,
  CASE
    WHEN sce2.value IN ('Young Adult') 
      THEN count(acirc.id) ELSE 0
    END AS toty,
  CASE
    WHEN sce2.value IN ('Childrens') 
      THEN count(acirc.id) ELSE 0
    END AS totc
  FROM action.circulation acirc
  JOIN actor.usr au ON acirc.usr = au.id
  JOIN asset.copy ac ON acirc.target_copy = ac.id
  JOIN actor.workstation aw ON acirc.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  JOIN asset.stat_cat_entry_copy_map scecm ON
    (scecm.owning_copy = acirc.target_copy and scecm.stat_cat = 1)
  JOIN asset.stat_cat_entry sce ON sce.id = scecm.stat_cat_entry
  JOIN asset.stat_cat_entry_copy_map scecm2 ON
    (scecm2.owning_copy = acirc.target_copy and scecm2.stat_cat = 2)
  JOIN asset.stat_cat_entry sce2 ON sce2.id = scecm2.stat_cat_entry
  WHERE acirc.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND au.profile not in (70,125)
  AND ac.circ_modifier not in ('part')
  --AND aou.name like 'Winthrop%'
  GROUP by 1,2,3

UNION ALL

  SELECT
  aou.name AS library,
  CASE
    WHEN sce.value in ('28') THEN 'Virtcat' ELSE sce.value
  END AS format,
  sce2.value as age,
  CASE
    WHEN sce2.value IN ('Adult', '27')
      THEN count(acirc.id) ELSE 0
    END AS tota,
  CASE
    WHEN sce2.value IN ('Young Adult')
      THEN count(acirc.id) ELSE 0
    END AS toty,
  CASE
    WHEN sce2.value IN ('Childrens')
      THEN count(acirc.id) ELSE 0
    END AS totc
  FROM action.circulation acirc
  JOIN actor.usr au ON acirc.usr = au.id
  JOIN asset.copy ac ON acirc.target_copy = ac.id
  JOIN actor.org_unit aou ON ac.circ_lib = aou.id
  JOIN asset.stat_cat_entry_copy_map scecm ON
    (scecm.owning_copy = acirc.target_copy and scecm.stat_cat = 1)
  JOIN asset.stat_cat_entry sce ON sce.id = scecm.stat_cat_entry
  JOIN asset.stat_cat_entry_copy_map scecm2 ON
    (scecm2.owning_copy = acirc.target_copy and scecm2.stat_cat = 2)
  JOIN asset.stat_cat_entry sce2 ON sce2.id = scecm2.stat_cat_entry
  WHERE acirc.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND au.profile not in (70,125)
  AND ac.circ_modifier not in ('part')
  AND acirc.workstation IS NULL
  --AND aou.name like 'Winthrop%'
  GROUP by 1,2,3

UNION ALL

  SELECT
  aou.name AS library,
  CASE
    WHEN sce.value in ('28') THEN 'Virtcat' ELSE sce.value
  END AS format,
  sce2.value as age,
  CASE
    WHEN sce2.value IN ('Adult', '27')
      THEN count(aged.id) ELSE 0
    END AS tota,
  CASE
    WHEN sce2.value IN ('Young Adult')
      THEN count(aged.id) ELSE 0
    END AS toty,
  CASE
    WHEN sce2.value IN ('Childrens')
      THEN count(aged.id) ELSE 0
    END AS totc
  FROM action.aged_circulation aged
  JOIN asset.copy ac ON aged.target_copy = ac.id
  JOIN actor.org_unit aou ON ac.circ_lib = aou.id
  JOIN asset.stat_cat_entry_copy_map scecm ON
    (scecm.owning_copy = aged.target_copy and scecm.stat_cat = 1)
  JOIN asset.stat_cat_entry sce ON sce.id = scecm.stat_cat_entry
  JOIN asset.stat_cat_entry_copy_map scecm2 ON
    (scecm2.owning_copy = aged.target_copy and scecm2.stat_cat = 2)
  JOIN asset.stat_cat_entry sce2 ON sce2.id = scecm2.stat_cat_entry
  WHERE aged.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND ac.circ_modifier not in ('part')
  AND aged.workstation IS NULL
  AND aged.usr_profile not in (70,125)
  --AND aou.name like 'Winthrop%'
  GROUP by 1,2,3

UNION ALL

SELECT
  aou.name AS library,
  CASE
    WHEN sce.value in ('28') THEN 'Virtcat' ELSE sce.value
  END AS format,
  sce2.value as age,
  CASE
    WHEN sce2.value IN ('Adult', '27') 
      THEN count(aged.id) ELSE 0
    END AS tota,
  CASE
    WHEN sce2.value IN ('Young Adult') 
      THEN count(aged.id) ELSE 0
    END AS toty,
  CASE
    WHEN sce2.value IN ('Childrens') 
      THEN count(aged.id) ELSE 0
    END AS totc
  FROM action.aged_circulation aged
  JOIN asset.copy ac ON aged.target_copy = ac.id
  JOIN actor.workstation aw ON aged.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  JOIN asset.stat_cat_entry_copy_map scecm ON
    (scecm.owning_copy = aged.target_copy and scecm.stat_cat = 1)
  JOIN asset.stat_cat_entry sce ON sce.id = scecm.stat_cat_entry
  JOIN asset.stat_cat_entry_copy_map scecm2 ON
    (scecm2.owning_copy = aged.target_copy and scecm2.stat_cat = 2)
  JOIN asset.stat_cat_entry sce2 ON sce2.id = scecm2.stat_cat_entry
  WHERE aged.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND aged.usr_profile not in (70,125)
  AND ac.circ_modifier not in ('part')
  --AND aou.name like 'Winthrop%'
  GROUP by 1,2,3
)  x

GROUP by 1,2
ORDER by 1,2
;
