-- generate_new_college_users.pl
-- Add new record if ident_value is not on file

BEGIN;

-- create the usr
INSERT INTO actor.usr (profile, usrname, email, passwd, ident_type,
   ident_value, ident_value2, net_access_level, first_given_name, 
   second_given_name, family_name, suffix, day_phone, evening_phone, home_ou, 
   dob, create_date, 
   expire_date)
      SELECT DISTINCT
	s.profile AS profile,
        CASE
           WHEN s.barcode = '' THEN s.ident_value
           ELSE s.barcode
        END AS usrname,
        CASE
           WHEN s.email != '' THEN s.email
           ELSE NULL
	END AS email,
	CASE
           WHEN s.password IS NULL THEN s.ident_value
  	   ELSE s.password
	END AS passwd,
        102 AS ident_type,
	s.ident_value AS ident_value,
	s.ident_value2 AS ident_value2,
        101 AS net_access_level,
        s.first_name as first_given_name,
        s.middle_name as second_given_name,
        s.family_name AS family_name,
	s.suffix AS suffix,
        s.day_phone AS day_phone,
        s.evening_phone AS evening_phone,
	--s.home_ou::int as home_ou,
        aou.id as home_ou,
        CASE
           WHEN s.dob != '' THEN s.dob::timestamp
           ELSE NULL
        END AS dob,
	now() AS create_date,
	s.expire_date::timestamp AS expire_date

      FROM staging.academic_patrons s
      JOIN actor.org_unit aou on upper(s.home_ou) = aou.shortname
    ;

-- update the staging users with their new usr.id
UPDATE staging.academic_patrons SET id = u.id
     FROM actor.usr as u
     WHERE staging.academic_patrons.ident_value=u.ident_value;
;

-- create the card
INSERT INTO actor.card (usr, barcode)
	SELECT au.id AS usr, 
        CASE
           WHEN s.barcode = '' THEN s.ident_value
           ELSE s.barcode
        END AS barcode

        FROM staging.academic_patrons s
		INNER JOIN actor.usr au
			ON s.ident_value = au.ident_value
   ; 

-- update the usr record with the card id
UPDATE actor.usr 
	SET card = actor.card.id
	FROM actor.card
	WHERE actor.card.usr = actor.usr.id
	AND actor.usr.id in (select id from staging.academic_patrons)
;

-- create the address
INSERT INTO actor.usr_address (usr, address_type, street1, street2, city, state, country, post_code)
   SELECT DISTINCT
	s.id as usr,
	'MAILING' as address_type,
	s.st1 as street1,
	s.st2 as street2,
	s.city as city,
	s.state as state,
	s.country as country,
	s.postal_code as post_code
   FROM staging.academic_patrons s
   WHERE country != '' and country is not null
   ;

-- create address2
INSERT INTO actor.usr_address (usr, address_type, street1, street2, city, state, country, post_code)
   SELECT DISTINCT
	s.id as usr,
	'ALTERNATE' as address_type,
	s.st1_2 as street1,
	s.st2_2 as street2,
	s.city2 as city,
	s.state2 as state,
	s.country2 as country,
	s.postal_code2 as post_code
   FROM staging.academic_patrons s
   WHERE country2 != '' and country2 IS NOT NULL
   ;

-- update user with their address
UPDATE actor.usr 
    SET mailing_address = ua.id, billing_address = ua.id
    FROM actor.usr_address AS ua
    WHERE actor.usr.id = ua.usr
    AND ua.address_type = 'MAILING'
    AND actor.usr.id in (select id from staging.academic_patrons)
    ;

--Add to statcat if valid (in stat_cat_entry)
--s.stat_cat is now text, not int
--INSERT INTO actor.stat_cat_entry_usr_map (stat_cat_entry, stat_cat, target_usr)
--        SELECT DISTINCT
--        (select value from actor.stat_cat_entry sce where sce.id=s.stat_cat)
--           AS stat_cat_entry,
--        (select stat_cat from actor.stat_cat_entry sce where sce.id=s.stat_cat)
--           AS stat_cat,
--        s.id as target_usr
--        FROM staging.academic_patrons s
--	WHERE s.stat_cat != 0
--	AND s.stat_cat IS NOT NULL
--	;

--GORDON statcat text from staging (not in stat_cat_entry)
--INSERT INTO actor.stat_cat_entry_usr_map (stat_cat_entry, stat_cat, target_usr)
--        SELECT DISTINCT
--        s.stat_cat AS stat_cat_entry,
--        5 AS stat_cat,
--        s.id AS target_usr
--        FROM staging.academic_patrons s
--        WHERE s.stat_cat != ''
--        ;

COMMIT;
