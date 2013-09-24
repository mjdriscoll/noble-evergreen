-- circs_by_shelfloc.sql
-- uses copy_location that is stored in circulation table, not item

SELECT aou.name AS "Library", acl.name AS "Shelving Loc", count(acirc.id) AS "COUNT"
  FROM action.circulation acirc
  JOIN actor.org_unit aou ON acirc.circ_lib = aou.id
  --JOIN asset.copy ac ON ac.id = acirc.target_copy
  JOIN asset.copy_location acl ON acl.id = acirc.copy_location
  --WHERE date_trunc('MONTH'::text, acirc.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  WHERE acirc.create_time between '12/01/2012 00:00:01' and '12/31/2012 23:59:59'
  AND aou.shortname like 'EV%'
  GROUP BY aou.name, acl.name
 
UNION
 
SELECT 'ZZZ Total' AS "Library", '' AS "Shelving Loc", count(acirc.id) AS "COUNT"
  FROM action.circulation acirc
  JOIN actor.org_unit aou ON acirc.circ_lib = aou.id
  --JOIN asset.copy ac ON ac.id = acirc.target_copy
  JOIN asset.copy_location acl ON acl.id = acirc.copy_location
  --WHERE date_trunc('MONTH'::text, acirc.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  WHERE acirc.create_time between '12/01/2012 00:00:01' and '12/31/2012 23:59:59'
  AND aou.shortname like 'EV%' 
 
ORDER BY 1, 2, 3;
