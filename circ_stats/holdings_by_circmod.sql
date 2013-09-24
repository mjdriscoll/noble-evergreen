-- holdings_by_circmod.sql

SELECT aou.shortname AS "Library", ccm.name AS "Circ Modifier", count(ac.id) AS "COUNT"
  FROM ((asset.copy ac
  JOIN actor.org_unit aou ON (aou.id = ac.circ_lib))
  FULL OUTER JOIN config.circ_modifier ccm ON (ccm.code = ac.circ_modifier))
  WHERE ac.deleted = false
  AND ac.create_date < '07/01/2013'
  AND aou.name like 'Lynnfield%'
  GROUP by aou.shortname, ccm.name

UNION

SELECT 'ZZZ Total' AS "Library", '' AS "Circ Modifier", count(ac.id) AS "COUNT"
  FROM ((asset.copy ac
  JOIN actor.org_unit aou ON (aou.id = ac.circ_lib))
  FULL OUTER JOIN config.circ_modifier ccm ON (ccm.code = ac.circ_modifier))
  WHERE ac.deleted = false
  AND aou.shortname like 'Lynnfield%'
  AND ac.create_date < '07/01/2013'

ORDER BY 1, 2;
