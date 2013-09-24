-- circs_to_ILL_patrons.sql
-- These are ILL's going to non-NOBLE, non-virtcat libraries via a checkout to a library card
-- with a permission group of 125, 'ILL Card'

-- Aug circs were to home_ou = 37 and profile = 20 as well as profile = 125

SELECT aou.name AS "Library", pgt.name AS "Permission Group", count(acirc.id) AS "COUNT"
  FROM action.circulation acirc
  JOIN actor.workstation aw ON acirc.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  JOIN actor.usr u ON acirc.usr = u.id
  JOIN permission.grp_tree pgt ON u.profile = pgt.id
  WHERE date_trunc('MONTH'::text, acirc.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --AND acirc.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  --AND aou.name like 'Winthrop%'
  AND u.profile = 125
  --AND u.home_ou = 37
  --AND u.profile = 20
  GROUP by aou.name, pgt.name

UNION

SELECT aou.name AS "Library", pgt.name AS "Permission Group", count(aged.id) AS "COUNT"
  FROM action.aged_circulation aged
  JOIN actor.workstation aw ON aged.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  JOIN permission.grp_tree pgt ON aged.usr_profile = pgt.id
  WHERE date_trunc('MONTH'::text, aged.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE aged.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  --AND aou.name like 'Winthrop%'
  AND aged.usr_profile = 125
  --AND u.home_ou = 37
  --AND u.profile = 20
  GROUP by aou.name, pgt.name


--SELECT 'ZZZ Total' AS "Library", '' AS "Permission Group", count(acirc.id) AS "COUNT"
--  FROM action.circulation acirc
--  JOIN actor.workstation aw ON acirc.workstation = aw.id
--  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
--  JOIN actor.usr u ON acirc.usr = u.id
--  JOIN permission.grp_tree pgt ON u.profile = pgt.id
--  --WHERE date_trunc('MONTH'::text, acirc.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
--  AND acirc.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
--  --AND aou.name like 'Winthrop%'
--  AND u.profile = 125
  --AND u.home_ou = 37
  --AND u.profile = 20

order by 1, 2
