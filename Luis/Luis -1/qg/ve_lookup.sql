SELECT LV.LOOKUP_CODE, LV.MEANING, lv.description, LV.LOOKUP_TYPE, fa.application_short_name
FROM apps.fnd_lookup_values_vl lv, apps.fnd_application fa
WHERE LV.LOOKUP_TYPE = 'XXPPG_GSC_INV_SBU_LOOKUP' and
      fa.application_id = lv.view_application_id 
