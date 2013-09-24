-- circs_by_age.sql
-- Creates count of circs by patron dob age range (age 11-18).

SELECT count(acirc.id) AS "COUNT"
  FROM action.circulation acirc
  JOIN actor.workstation aw ON acirc.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  JOIN actor.usr u ON acirc.usr = u.id
  WHERE date_trunc('MONTH'::text, acirc.create_time) = date_trunc('MONTH'::text, now() - '1 mon'::interval)
  --WHERE acirc.create_time between '12/01/2012 00:00:01' and '12/31/2012 23:59:59'
  AND aou.name like 'Salem%'
  AND u.dob between '01/01/1995 00:00:01' and '12/31/2002 23:59:59'
