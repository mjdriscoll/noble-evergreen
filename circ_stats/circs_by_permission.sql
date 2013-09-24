-- circs_by_permission.sql
-- 6/1/13 include circs in aged_circulation

SELECT aou.name AS "Library", pgt.name AS "Patron Permission Group", count(acirc.id) AS "COUNT"
  FROM action.circulation acirc
  JOIN actor.workstation aw ON acirc.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  JOIN actor.usr u ON acirc.usr = u.id
  JOIN permission.grp_tree pgt ON u.profile = pgt.id
  WHERE date_trunc('MONTH'::text, acirc.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE acirc.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  --AND aou.name like 'Winthrop%'
  GROUP by aou.name, pgt.name

UNION

SELECT aou.name AS "Library", pgt.name AS "Patron Permission Group", count(aged.id) AS "COUNT"
  FROM action.aged_circulation aged
  JOIN actor.workstation aw ON aged.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  JOIN permission.grp_tree pgt ON aged.usr_profile = pgt.id
  WHERE date_trunc('MONTH'::text, aged.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE aged.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  --AND aou.name like 'Winthrop%'
  GROUP by aou.name, pgt.name

UNION

--Total circulation
SELECT aou.name||' Total' AS "Library", '' AS "Patron Permission Group", count(acirc.id) AS "COUNT"
  FROM action.circulation acirc
  --JOIN actor.workstation aw ON acirc.workstation = aw.id
  --JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  JOIN actor.org_unit aou ON acirc.circ_lib = aou.id
  WHERE date_trunc('MONTH'::text, acirc.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE acirc.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND acirc.workstation IS NOT NULL
  GROUP by aou.name

UNION

--Total aged_circulation
SELECT aou.name||' Total2' AS "Library", '' AS "Patron Permission Group", count(aged.id) AS "COUNT"
  FROM action.aged_circulation aged
  JOIN actor.org_unit aou ON aged.circ_lib = aou.id
  WHERE date_trunc('MONTH'::text, aged.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE aged.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND aged.workstation IS NOT NULL
  GROUP by aou.name

order by 1, 2
