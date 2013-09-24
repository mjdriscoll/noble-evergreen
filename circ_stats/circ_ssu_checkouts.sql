-- circ_ssu_checkouts.sql
-- count checkouts by circ_library (checkout library) but list
-- checkouts of ERL items at SSU seperately  
-- Does not include web renewals which don't have a workstation 
-- associated with them.
-- Staff renewals are counted in this report.
-- 6/1/13 include circs in aged_circulation

SELECT aou.name AS "Circ Library", aou2.shortname AS "Owning Library", count(acirc.id) AS "COUNT"
  FROM action.circulation acirc
  JOIN asset.copy ac ON acirc.target_copy = ac.id
  JOIN actor.org_unit aou ON acirc.circ_lib = aou.id
  JOIN actor.org_unit aou2 ON ac.circ_lib = aou2.id
  WHERE date_trunc('MONTH'::text, acirc.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE acirc.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND acirc.workstation IS NOT NULL
  AND aou.name like 'Salem State%'
  AND aou2.shortname = 'SSUE'
  GROUP BY aou.name, aou2.shortname

UNION

SELECT aou.name AS "Circ Library", 'Everyone Else' AS "Owning Library", count(acirc.id) AS "COUNT"
  FROM action.circulation acirc
  JOIN asset.copy ac ON acirc.target_copy = ac.id
  JOIN actor.org_unit aou ON acirc.circ_lib = aou.id
  JOIN actor.org_unit aou2 ON ac.circ_lib = aou2.id
  WHERE date_trunc('MONTH'::text, acirc.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE acirc.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND acirc.workstation IS NOT NULL
  AND aou.name like 'Salem State%'
  AND aou2.shortname != 'SSUE'
  GROUP BY aou.name

order by 1,2;
