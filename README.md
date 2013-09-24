noble-evergreen
===============

NOBLE's custom files, scripts, tools, etc. for our Evergreen system.

For easy importing into other programs, scripts are best run unaligned (A), tuples only (t), tab field separator (F).  For example:

psql -U <user> -h <host> -At -F $'\t' -f bib_holds.sql > bib_holds.txt
