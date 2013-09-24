-- virtcat_sent.sql
-- ILL's sent to the virtual catalog (circulating library = 38)
-- 6/1/2013 include aged_circulation

SELECT aou.name AS "Circulating Library", aou2.name AS "Owning Library", COUNT(acirc.id) AS "COUNT"
FROM action.circulation acirc 
  INNER JOIN actor.org_unit aou ON acirc.circ_lib = aou.id 
  INNER JOIN asset.copy ac ON acirc.target_copy = ac.id 
  INNER JOIN actor.org_unit aou2 ON aou2.id = ac.circ_lib 
WHERE acirc.circ_lib = 38 
  AND DATE_TRUNC('MONTH'::text, acirc.create_time) = DATE_TRUNC('MONTH'::text, NOW() - '1 mon'::interval) 
  --AND acirc.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND acirc.desk_renewal IS FALSE 
  AND acirc.opac_renewal IS FALSE 
  AND acirc.phone_renewal IS FALSE 
GROUP BY aou.name, aou2.name

UNION
 
SELECT aou.name AS "Circulating Library", aou2.name AS "Owning Library", COUNT(aged.id) AS "COUNT"
FROM action.aged_circulation aged
  INNER JOIN actor.org_unit aou ON aged.circ_lib = aou.id
  INNER JOIN asset.copy ac ON aged.target_copy = ac.id
  INNER JOIN actor.org_unit aou2 ON aou2.id = ac.circ_lib
WHERE aged.circ_lib = 38
  AND DATE_TRUNC('MONTH'::text, aged.create_time) = DATE_TRUNC('MONTH'::text, NOW() - '1 mon'::interval)
  --AND aged.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND aged.desk_renewal IS FALSE
  AND aged.opac_renewal IS FALSE
  AND aged.phone_renewal IS FALSE
GROUP BY aou.name, aou2.name

--Total does not include aged_circulation
--SELECT 'ZZZ Total' AS "Circulating Library", '' AS "Owning Library", COUNT(acirc.id) AS "COUNT"
--FROM action.circulation acirc 
--  INNER JOIN actor.org_unit aou ON acirc.circ_lib = aou.id 
--  INNER JOIN asset.copy ac ON acirc.target_copy = ac.id 
--  INNER JOIN actor.org_unit aou2 ON aou2.id = ac.circ_lib 
--WHERE acirc.circ_lib = 38 
--  AND DATE_TRUNC('MONTH'::text, acirc.create_time) = DATE_TRUNC('MONTH'::text, NOW() - '1 mon'::interval) 
--  AND acirc.desk_renewal IS FALSE
--  AND acirc.opac_renewal IS FALSE 
--  AND acirc.phone_renewal IS FALSE
--GROUP BY aou.name
 
ORDER BY 1, 2;
