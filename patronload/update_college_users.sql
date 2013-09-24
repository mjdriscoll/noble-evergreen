/*
 * Copyright (C) 2011 C/W MARS.
 * Created by Tim Spindler
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */
 
BEGIN;

--Do this if library did not include institution code in id
--UPDATE staging.academic_patrons SET ident_value = ident_value||'pan';

--Update existing records matching on ident_value

--Set usr.id in staging table for on-file users
--UPDATE staging.academic_patrons SET id=u.id FROM actor.usr AS u 
--   WHERE academic_patrons.ident_value=u.ident_value;

--Update name
UPDATE actor.usr SET first_given_name = s.first_name, second_given_name=s.middle_name, family_name=s.family_name FROM staging.academic_patrons AS s WHERE actor.usr.id=s.id;

--Update suffix
UPDATE actor.usr SET suffix=s.suffix 
FROM staging.academic_patrons AS s 
WHERE usr.id=s.id AND s.suffix IS NOT NULL;

--Update password if library supplies it in file
--GOR: don't update passwords
--UPDATE actor.usr SET passwd=s.password FROM staging.academic_patrons AS s
--   WHERE usr.id=s.id AND s.password != '';

--Update profile
UPDATE actor.usr SET profile=s.profile FROM staging.academic_patrons AS s WHERE usr.id=s.id AND s.profile IS NOT NULL;

--Update ident_type
UPDATE actor.usr SET ident_type=102 FROM staging.academic_patrons AS s WHERE usr.id=s.id;

--Update phone
UPDATE actor.usr SET day_phone=s.day_phone FROM staging.academic_patrons AS s WHERE usr.id=s.id AND s.day_phone != '' AND s.day_phone IS NOT NULL;
UPDATE actor.usr SET other_phone=s.evening_phone 
FROM staging.academic_patrons AS s 
WHERE usr.id=s.id AND s.evening_phone != '' AND s.evening_phone IS NOT NULL;

--Update email. SSU does not want email updated
UPDATE actor.usr SET email=s.email FROM staging.academic_patrons AS s 
  WHERE usr.id=s.id AND s.email != '';

--Update dob
UPDATE actor.usr SET dob=date(s.dob) FROM staging.academic_patrons AS s 
  WHERE usr.id=s.id AND s.dob != '' and s.dob IS NOT NULL;  

--Update expire date
UPDATE actor.usr SET expire_date=date(s.expire_date) 
  FROM staging.academic_patrons AS s 
  WHERE usr.id=s.id AND s.expire_date != '';

--Update mailing address, don't blank on-file if incoming is blank
UPDATE actor.usr_address SET street1=s.st1, street2=s.st2, city=s.city,
  state=s.state, post_code=s.postal_code
  FROM staging.academic_patrons AS s
  JOIN actor.usr u ON u.id = s.id
  WHERE (s.id = usr_address.usr AND usr_address.id = u.mailing_address)
  AND s.country != '' AND s.country2 IS NOT NULL;

--Update alternate address, don't blank on-file if incoming is blank
UPDATE actor.usr_address SET street1=s.st1_2, street2=s.st2_2, city=s.city2,
state=s.state2, post_code=s.postal_code2, country=s.country2
FROM staging.academic_patrons AS s
WHERE (s.id = usr_address.usr AND usr_address.address_type = 'ALTERNATE')
AND s.country2 != '' AND s.country2 IS NOT NULL;

--Update barcode. SSU can't load barcode because there could be multiple
UPDATE actor.card SET barcode=s.barcode
  FROM staging.academic_patrons AS s
  WHERE card.usr=s.id 
  and s.barcode != ''
  and actor.card.active = true;

--Delete the on-file users and leave only new in the staging table
--DELETE FROM staging.academic_patrons WHERE id IS NOT NULL;

COMMIT;
