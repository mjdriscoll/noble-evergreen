-- holdings_del.sql

SELECT aou.name AS "Library", count(ac.id) AS "DELETED"
  FROM asset.copy ac
  JOIN actor.org_unit aou ON aou.id = ac.circ_lib
  WHERE date_trunc('MONTH'::text, ac.edit_date) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  AND ac.deleted = true
  AND ac.status not in (104)
  GROUP by aou.name

UNION

SELECT 'ZZZ Total' AS "Library", count(ac.id) AS "DELETED"
  FROM asset.copy ac
  JOIN actor.org_unit aou ON aou.id = ac.circ_lib
  WHERE date_trunc('MONTH'::text, ac.edit_date) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  AND ac.deleted = true
  AND ac.status not in (104)

ORDER BY 1;
