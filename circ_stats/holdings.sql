-- holdings.sql

SELECT aou.name AS "Library", count(ac.id) AS "COUNT"
  FROM asset.copy ac
  JOIN actor.org_unit aou ON aou.id = ac.circ_lib
  WHERE ac.deleted = false
  --AND ac.active_date < '09/01/2013'
  GROUP by aou.name

UNION

SELECT 'ZZZ Total' AS "Library", count(ac.id) AS "COUNT"
  FROM asset.copy ac
  JOIN actor.org_unit aou ON aou.id = ac.circ_lib
  WHERE ac.deleted = false
  --AND ac.active_date < '09/01/2013'

ORDER BY 1;
