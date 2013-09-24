--circs_by_residency.sql
--this counts renewals, but not web renewals
--don't count patrons: non-circ (70), virtcat (115), ill card (125)
--address to check is mailing address
--all cap city so everything groups properly
--remove any leading or trailing spaces

SELECT aou.name AS "Library", trim(both ' ' from upper(ua.city)) AS "Residency", ua.state AS "State", count(acirc.id) AS "CHECKOUTS"
  FROM action.circulation acirc
  JOIN actor.workstation aw ON acirc.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  JOIN actor.usr u ON acirc.usr = u.id
  JOIN actor.usr_address ua ON ua.id = u.mailing_address 
  WHERE acirc.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND u.profile not in (70,115,125) 
  --AND aou.name like 'Winthrop%'
  GROUP by aou.name, ua.city, ua.state

UNION

SELECT aou.name AS "Library", aged.usr_post_code AS "Residency", '' AS "State", count(aged.id) AS "CHECKOUTS"
  FROM action.aged_circulation aged
  JOIN actor.workstation aw ON aged.workstation = aw.id
  JOIN actor.org_unit aou ON aw.owning_lib = aou.id
  WHERE aged.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND aged.usr_profile not in (70,115,125) 
  --AND aou.name like 'Winthrop%'
  GROUP by aou.name, aged.usr_post_code

ORDER BY 1, 3, 2;
