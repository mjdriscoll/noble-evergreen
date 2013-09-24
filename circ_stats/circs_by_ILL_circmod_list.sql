--circs_by_ILL_circmod_list.sql
--use this to see the actual circs and whether a stat_cat was set for these
--out of system ILL's circulated by a given library

SELECT acirc.target_copy, scecm.stat_cat_entry, ou.shortname
  FROM action.circulation acirc
  JOIN actor.workstation aw ON acirc.workstation = aw.id
  JOIN asset.copy ac ON ac.id = acirc.target_copy
  JOIN actor.org_unit ou ON ou.id = ac.circ_lib
  LEFT OUTER JOIN asset.stat_cat_entry_copy_map scecm ON scecm.owning_copy = acirc.target_copy
  WHERE acirc.create_time between '07/01/2012 00:00:01' and '06/30/2013 23:59:59'
  AND aw.owning_lib in (30)
  AND ac.circ_modifier = 'ill'
