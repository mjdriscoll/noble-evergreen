These files are used to load patron records into Evergreen.

The order is:
1. load_academic_patrons.sql      - load into staging table
2. update_id.sql                  - add database id to staging table record
3. update_college_users.sql       - update existing records first
4. removed updates from staging table
5. generate_new_college_users.sql - add new records
