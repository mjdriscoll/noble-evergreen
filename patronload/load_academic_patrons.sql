-- load_academic_patrons.sql

BEGIN;

-- Empty Staging Table First:
TRUNCATE staging.academic_patrons;

-- Copy from text files
--COPY staging.academic_patrons(barcode, profile, email, first_name, middle_name, family_name, day_phone, evening_phone, home_ou, dob, st1, st2, city, state, country, postal_code, st1_2, st2_2, city2, state2, country2, postal_code2, ident_value, expire_date, password, stat_cat)

-- BHCC
--COPY staging.academic_patrons(barcode, profile, email, first_name, middle_name, family_name, day_phone, evening_phone, home_ou, dob, st1, st2, city, state, country, postal_code, st1_2, st2_2, city2, state2, country2, postal_code2, ident_value, expire_date, password)

-- BHCC Barcodes
COPY staging.academic_patrons(ident_value, barcode, password)
--COPY staging.academic_patrons(barcode)

--END
--COPY staging.academic_patrons(barcode, profile, email, first_name, middle_name, family_name, day_phone, evening_phone, home_ou, dob, st1, st2, city, state, country, postal_code, st1_2, st2_2, city2, state2, country2, postal_code2, ident_value, expire_date, password)

-- MERR Students
--COPY staging.academic_patrons(barcode, profile, email, first_name, middle_name, family_name, day_phone, evening_phone, home_ou, dob, st1, st2, city, state, country, postal_code, st1_2, st2_2, city2, state2, country2, postal_code2, ident_value, expire_date, password,stat_cat,ident_value2)

--MON Student
--COPY staging.academic_patrons(barcode, profile, email, first_name, middle_name, family_name, day_phone, home_ou, st1, city, state, country, postal_code, st1_2, st2_2, city2, state2, country2, postal_code2, ident_value, expire_date)

--NSCC 
--COPY staging.academic_patrons(barcode, profile, email, first_name, middle_name, family_name, day_phone, evening_phone, home_ou, dob, st1, st2, city, state, country, postal_code, ident_value, expire_date, password)

--NECC Student
--COPY staging.academic_patrons(barcode, profile, email, home_ou, expire_date, ident_value, family_name, first_name, st1, city, state, country, postal_code, day_phone, dob)

--PAN Students
--COPY staging.academic_patrons(barcode, profile, email, first_name, middle_name, family_name, day_phone, evening_phone, home_ou, st1, st2, city, state, country, postal_code, ident_value, expire_date, ident_value2)

--PAN Staff/Faculty
--COPY staging.academic_patrons(barcode, profile, email, first_name, middle_name, family_name, day_phone, evening_phone, home_ou, st1, st2, city, state, country, postal_code, ident_value, expire_date)

-- SSU
--COPY staging.academic_patrons(barcode, profile, email, first_name, middle_name, family_name, day_phone, evening_phone, home_ou, dob, st1, st2, city, state, country, postal_code, st1_2, st2_2, city2, state2, country2, postal_code2, ident_value, expire_date, password)

FROM '/var/noble_backups/bhcc-barcodes-2013-09-20.txt'
DELIMITER ','
CSV
;

COMMIT;
