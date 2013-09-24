-- circ_by_age_web_renewals.sql
-- count circs that have no workstation (web renewal) but count Salem's items
-- and patron's between age 11-18

SELECT count(acirc.id) AS "COUNT"
  FROM action.circulation acirc
  INNER JOIN asset.copy ac ON acirc.target_copy = ac.id 
  INNER JOIN asset.call_number acn ON ac.call_number = acn.id
  INNER JOIN actor.org_unit aou ON acn.owning_lib = aou.id   
  JOIN actor.usr u ON acirc.usr = u.id
  WHERE date_trunc('MONTH'::text, acirc.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE acirc.create_time between '08/01/2012 00:00:01' and '08/31/2012 23:59:59'
  AND acirc.workstation IS NULL
  AND aou.name like 'Salem%'
  AND u.dob between '01/01/1995 00:00:01' and '12/31/2002 23:59:59'
