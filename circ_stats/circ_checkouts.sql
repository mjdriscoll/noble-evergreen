-- circ_checkouts.sql
-- count checkouts by circ_library (checkout library).  Do not include web renewals
-- which don't have a workstation associated with them
-- Staff renewals are counted in this report.
-- 6/1/13 include circs in aged_circulation

SELECT x.library, sum(x.tot)
  FROM (

SELECT aou.name AS library, count(acirc.id) AS tot
  FROM action.circulation acirc
  JOIN actor.workstation aw ON acirc.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  WHERE date_trunc('MONTH'::text, acirc.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE acirc.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND acirc.workstation IS NOT NULL
  --AND aou.shortname = 'EVP'
  GROUP BY 1
 
UNION ALL

SELECT aou.name AS library, count(aged.id) AS tot
  FROM action.aged_circulation aged
  JOIN actor.workstation aw ON aged.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  WHERE date_trunc('MONTH'::text, aged.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE aged.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND aged.workstation IS NOT NULL
  GROUP BY 1
) x

GROUP by 1
ORDER BY 1;
