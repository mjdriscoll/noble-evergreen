-- holdings_added_circmod.sql

SELECT aou.name AS "Library", ccm.name AS "Circ Modifier", count(ac.id) AS "COUNT"
  FROM asset.copy ac
  JOIN actor.org_unit aou ON aou.id = ac.circ_lib
  LEFT OUTER JOIN config.circ_modifier ccm ON ccm.code = ac.circ_modifier
  WHERE ac.create_date between '06/01/2012' and '06/30/2012'
  AND aou.name like 'Merrimack%'
  GROUP by aou.name, ccm.name

UNION

SELECT 'ZZZ Total' AS "Library", '' AS "Circ Modifier", count(ac.id) AS "COUNT"
  FROM asset.copy ac
  JOIN actor.org_unit aou ON aou.id = ac.circ_lib
  LEFT OUTER JOIN config.circ_modifier ccm ON ccm.code = ac.circ_modifier
  WHERE aou.name like 'Merrimack%'
  AND ac.create_date between '06/01/2012' and '06/30/2012'

ORDER BY 1, 2;
