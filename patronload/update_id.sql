-- update_id.pl
-- Add usr id to staging table if user is already on file

BEGIN;

-- Add id to staging records if onfile
UPDATE staging.academic_patrons SET id = u.id 
  FROM actor.usr u 
  WHERE staging.academic_patrons.ident_value = u.ident_value;

COMMIT;
