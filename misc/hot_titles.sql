WITH bib_format AS (
select mba.id AS bib, cvm.value AS format
from metabib.record_attr mba, config.coded_value_map cvm
where mba.attrs::hstore -> 'item_type' = cvm.code
and cvm.ctype = 'item_type'
and mba.id in
      (select DISTINCT ahr.target
      FROM action.hold_request ahr
      WHERE ahr.hold_type = 'T'::text AND ahr.fulfillment_time IS NULL
      AND ahr.cancel_time IS NULL
      )
GROUP by mba.id, cvm.value
)

SELECT ahr.target, rmsr.title, rmsr.author, f.format, rmsr.isbn
FROM action.hold_request ahr
JOIN reporter.materialized_simple_record rmsr ON rmsr.id = ahr.target
JOIN bib_format f ON f.bib = ahr.target
WHERE ahr.hold_type = 'T'::text AND ahr.fulfillment_time IS NULL AND ahr.cancel_time IS NULL

GROUP BY ahr.target, rmsr.title, rmsr.author, f.format, rmsr.isbn
ORDER BY count(ahr.target) DESC
LIMIT 100;
