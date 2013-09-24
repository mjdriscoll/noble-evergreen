-- circs_by_ILL_circmod.sql
-- These are items that were received from outside NOBLE and input with  the 'ill' 
-- circ modifier.  Virtcat is not included here -- those get NULL as a circ modifier.
-- 6/1/2013 include aged_circulation

SELECT aou.name AS "Library", ccm.description AS "Circ Modifier", count(acirc.id) AS "COUNT"
  FROM action.circulation acirc
  JOIN actor.workstation aw ON acirc.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  JOIN asset.copy ac ON ac.id = acirc.target_copy
  LEFT OUTER JOIN config.circ_modifier ccm ON ccm.code = ac.circ_modifier
  WHERE date_trunc('MONTH'::text, acirc.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE acirc.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  --AND aou.name like 'Bunker Hill%'
  AND ac.circ_modifier = 'ill'
  GROUP BY aou.name, ccm.description
 
UNION

SELECT aou.name AS "Library", ccm.description AS "Circ Modifier", count(aged.id) AS "COUNT"
  FROM action.aged_circulation aged
  JOIN actor.workstation aw ON aged.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  JOIN asset.copy ac ON ac.id = aged.target_copy
  LEFT OUTER JOIN config.circ_modifier ccm ON ccm.code = ac.circ_modifier
  WHERE date_trunc('MONTH'::text, aged.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE aged.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  --AND aou.name like 'Bunker Hill%'
  AND ac.circ_modifier = 'ill'
  GROUP BY aou.name, ccm.description

--total does not include aged_circulation 
--SELECT 'ZZZ Total'  AS "Library", '' AS "Circ Modifier", count(acirc.id) AS "COUNT"
--  FROM action.circulation acirc
--  JOIN actor.workstation aw ON acirc.workstation = aw.id
--  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
--  JOIN asset.copy ac ON ac.id = acirc.target_copy
--  LEFT OUTER JOIN config.circ_modifier ccm ON ccm.code = ac.circ_modifier
--  WHERE date_trunc('MONTH'::text, acirc.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
--  AND ac.circ_modifier = 'ill'

ORDER BY 1, 2;
