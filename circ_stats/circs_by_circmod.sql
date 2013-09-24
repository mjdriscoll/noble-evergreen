-- circs_by_circmod.sql

SELECT aou.name AS "Library", ccm.name AS "Circ Modifier", count(acirc.id) AS "COUNT"
  FROM action.circulation acirc
  JOIN actor.workstation aw ON acirc.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  JOIN asset.copy ac ON ac.id = acirc.target_copy
  LEFT OUTER JOIN config.circ_modifier ccm ON ccm.code = ac.circ_modifier
  WHERE date_trunc('MONTH'::text, acirc.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE acirc.create_time between '07/01/2012' and '06/30/2013'
  --AND aou.name like 'Bunker Hill%'
  GROUP BY aou.name, ccm.name
 
UNION
 
SELECT aou.name AS "Library", ccm.name AS "Circ Modifier", count(aged.id) AS "COUNT"
  FROM action.aged_circulation aged
  JOIN actor.workstation aw ON aged.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  JOIN asset.copy ac ON ac.id = aged.target_copy
  LEFT OUTER JOIN config.circ_modifier ccm ON ccm.code = ac.circ_modifier
  WHERE date_trunc('MONTH'::text, aged.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE aged.create_time between '07/01/2012' and '06/30/2013'
  GROUP BY aou.name, ccm.name

UNION

--Total circulation
SELECT aou.name||' Total'  AS "Library", '' AS "Circ Modifier", count(acirc.id) AS "COUNT"
  FROM action.circulation acirc
  JOIN actor.workstation aw ON acirc.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  JOIN asset.copy ac ON ac.id = acirc.target_copy
  LEFT OUTER JOIN config.circ_modifier ccm ON ccm.code = ac.circ_modifier
  WHERE date_trunc('MONTH'::text, acirc.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE acirc.create_time between '07/01/2012' and '06/30/2013'
  GROUP BY aou.name

UNION

--Total aged.circulation
SELECT aou.name||' Total2'  AS "Library", '' AS "Circ Modifier", count(aged.id) AS "COUNT"
  FROM action.aged_circulation aged
  JOIN actor.workstation aw ON aged.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  JOIN asset.copy ac ON ac.id = aged.target_copy
  LEFT OUTER JOIN config.circ_modifier ccm ON ccm.code = ac.circ_modifier
  WHERE date_trunc('MONTH'::text, aged.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE aged.create_time between '07/01/2012' and '06/30/2013'
  GROUP BY aou.name

ORDER BY 1, 2;
