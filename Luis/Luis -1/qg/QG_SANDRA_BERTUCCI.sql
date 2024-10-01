SELECT *
  FROM fnd_lookup_values_vl lv
  WHERE lv.view_application_id    = 3 and        
        LV.LOOKUP_TYPE           = 'PPG_BR_INV_ORG_CONT_REQ' AND
        lv.enabled_flag          = 'Y'                       AND
        SYSDATE BETWEEN NVL(lv.start_date_active, SYSDATE)   AND
                        NVL(lv.end_date_active, SYSDATE);        


SELECT segment1, item_type
  FROM apps.mtl_system_items_b   msi,
       apps.fnd_lookup_values_vl lv
 WHERE lv.view_application_id    = 3 and        
        LV.LOOKUP_TYPE           = 'PPG_BR_INV_ORG_CONT_REQ' AND
        lv.enabled_flag          = 'Y'                       AND
        SYSDATE BETWEEN NVL(lv.start_date_active, SYSDATE)   AND
                        NVL(lv.end_date_active, SYSDATE)     AND
        msi.item_type = lv.description;
        
        
        
        PPG_BR_INV_ORG_CONTR_USER_REQ

PPG_BR_INV_ORG_CONT_REQ