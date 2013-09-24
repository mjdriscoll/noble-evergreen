-- circ_web_renewals.sql
-- count circs that have no workstation (web renewal) but count by item's owning library
-- not the circulating library in the action.circulation table (which is the patron's
-- home library for web renewals
-- 6/1/13 include circs in aged_circulation

SELECT aou.name AS "Owning Library", count(acirc.id) AS "COUNT"
  FROM action.circulation acirc
  INNER JOIN asset.copy ac ON acirc.target_copy = ac.id 
  INNER JOIN asset.call_number acn ON ac.call_number = acn.id
  INNER JOIN actor.org_unit aou ON acn.owning_lib = aou.id   
  WHERE date_trunc('MONTH'::text, acirc.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE acirc.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND acirc.workstation IS NULL
  GROUP BY aou.name
 
UNION
 
SELECT aou.name AS "Owning Library", count(aged.id) AS "COUNT"
  FROM action.aged_circulation aged
  INNER JOIN asset.copy ac ON aged.target_copy = ac.id
  INNER JOIN asset.call_number acn ON ac.call_number = acn.id
  INNER JOIN actor.org_unit aou ON acn.owning_lib = aou.id
  WHERE date_trunc('MONTH'::text, aged.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE aged.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND aged.workstation IS NULL
  GROUP BY aou.name

--Total does not include aged_circulation
--SELECT 'ZZZ Total' AS "Owning Library", count(acirc.id) AS "COUNT"
--  FROM action.circulation acirc
--  INNER JOIN asset.copy ac ON acirc.target_copy = ac.id 
--  INNER JOIN asset.call_number acn ON ac.call_number = acn.id
--  INNER JOIN actor.org_unit aou ON acn.owning_lib = aou.id  
--  WHERE date_trunc('MONTH'::text, acirc.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
--  AND acirc.workstation IS NULL
 
ORDER BY 1, 2;
