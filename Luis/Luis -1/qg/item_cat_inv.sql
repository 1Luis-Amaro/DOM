select msi.segment1 item_code,
       mic.CATEGORY_CONCAT_SEGS category_set_name,
       msi.inventory_item_id,
   ---- Segment1 is the Item Type ie: Finished goods, Raw Material, Intermediate ----
       mic.segment1,
      (SELECT ffv.description--, ffv.parent_flex_value_low, ffv.flex_value
         FROM apps.fnd_id_flexs              fif,
              apps.fnd_id_flex_structures_vl fifs,
              apps.fnd_id_flex_segments_vl   fifse,
              apps.fnd_flex_value_sets       ffvs,
              apps.fnd_flex_values_vl        ffv
        WHERE     fif.id_flex_code              = fifs.id_flex_code
              AND fifs.enabled_flag             = 'Y'
              AND fif.id_flex_code              = fifse.id_flex_code
              AND fifs.id_flex_num              = fifse.id_flex_num
              AND fif.application_id            = fifs.application_id
              AND fif.application_id            = fifse.application_id
              AND fifse.flex_value_set_id       = ffvs.flex_value_set_id
              AND fifs.id_flex_structure_code   = 'ITEM_CATEGORIES'
              AND fifse.application_column_name = 'SEGMENT1'
              AND fif.id_flex_name              = 'Item Categories'
              AND ffvs.flex_value_set_id        = ffv.flex_value_set_id
              AND TRUNC (SYSDATE) BETWEEN (DECODE (TRUNC (ffv.start_date_active),
                                                   NULL, TRUNC (SYSDATE),
                                                   TRUNC (ffv.start_date_active)))
                                      AND (DECODE (TRUNC (ffv.end_date_active),
                                                   NULL, TRUNC (SYSDATE),
                                                   TRUNC (ffv.end_date_active)))
              AND ffv.enabled_flag = 'Y'
              AND ffv.flex_value = mic.segment1) "ITEM TYPE-SEGMENT1 DESCRIPTION",
   ---- Segment2 is Business Unit ie: Refinish, Industrial, etc ----
       mic.segment2,
      (SELECT ffv.description --, ffv.parent_flex_value_low, ffv.flex_value
         FROM apps.fnd_id_flexs              fif,
              apps.fnd_id_flex_structures_vl fifs,
              apps.fnd_id_flex_segments_vl   fifse,
              apps.fnd_flex_value_sets       ffvs,
              apps.fnd_flex_values_vl        ffv
        WHERE     fif.id_flex_code              = fifs.id_flex_code
              AND fifs.enabled_flag             = 'Y'
              AND fif.id_flex_code              = fifse.id_flex_code
              AND fifs.id_flex_num              = fifse.id_flex_num
              AND fif.application_id            = fifs.application_id
              AND fif.application_id            = fifse.application_id
              AND fifse.flex_value_set_id       = ffvs.flex_value_set_id
              AND fifs.id_flex_structure_code   = 'ITEM_CATEGORIES'
              AND fifse.application_column_name = 'SEGMENT2'
              AND fif.id_flex_name              = 'Item Categories'
              AND ffvs.flex_value_set_id        = ffv.flex_value_set_id
              AND TRUNC (SYSDATE) BETWEEN (DECODE (TRUNC (ffv.start_date_active),
                                                   NULL, TRUNC (SYSDATE),
                                                   TRUNC (ffv.start_date_active)))
                                      AND (DECODE (TRUNC (ffv.end_date_active),
                                                   NULL, TRUNC (SYSDATE),
                                                   TRUNC (ffv.end_date_active)))
              AND ffv.enabled_flag = 'Y'
              AND ffv.flex_value = mic.segment2) "BU - SEGMENT2 DESCRIPTION",
   ---- Segment3 is Product Line ie 1191 (Automotive Others), 1291 (Toyota), etc ----
       mic.segment3,
      (SELECT min(ffv.description) --, ffv.parent_flex_value_low, ffv.flex_value
         FROM apps.fnd_id_flexs              fif,
              apps.fnd_id_flex_structures_vl fifs,
              apps.fnd_id_flex_segments_vl   fifse,
              apps.fnd_flex_value_sets       ffvs,
              apps.fnd_flex_values_vl        ffv
        WHERE     fif.id_flex_code              = fifs.id_flex_code
              AND fifs.enabled_flag             = 'Y'
              AND fif.id_flex_code              = fifse.id_flex_code
              AND fifs.id_flex_num              = fifse.id_flex_num
              AND fif.application_id            = fifs.application_id
              AND fif.application_id            = fifse.application_id
              AND fifse.flex_value_set_id       = ffvs.flex_value_set_id
              AND fifs.id_flex_structure_code   = 'ITEM_CATEGORIES'
              AND fifse.application_column_name = 'SEGMENT3'
              AND fif.id_flex_name              = 'Item Categories'
              AND ffvs.flex_value_set_id        = ffv.flex_value_set_id
              AND TRUNC (SYSDATE) BETWEEN (DECODE (TRUNC (ffv.start_date_active),
                                                   NULL, TRUNC (SYSDATE),
                                                   TRUNC (ffv.start_date_active)))
                                      AND (DECODE (TRUNC (ffv.end_date_active),
                                                   NULL, TRUNC (SYSDATE),
                                                   TRUNC (ffv.end_date_active)))
              AND ffv.enabled_flag = 'Y'
              AND ffv.flex_value = mic.segment3) "PL - SEGMENT3 DESCRIPTION"
   from apps.mtl_system_items_b     msi,
        apps.mtl_item_categories_v mic
  where msi.segment1 like 'TO%' AND
        mic.organization_id   = msi.organization_id AND
        mic.inventory_item_id = msi.inventory_item_id AND
        mic.category_set_id   = 1;
                        
select msi.segment1,
       msi.description,
       msi.item_type,
       msi.INVENTORY_ITEM_STATUS_CODE,
       mic.CATEGORY_CONCAT_SEGS  "PPG_BR_ETIQUETAS_MED_PREV",
       mic2.CATEGORY_CONCAT_SEGS "PPG_BR_ETIQUETAS_RISCO"
  from apps.mtl_item_categories_v mic,
       apps.mtl_item_categories_v mic2,
       apps.mtl_system_items_b    msi 
 where mic.category_set_name  = 'PPG_BR_ETIQUETAS_MED_PREV' AND
       mic2.category_set_name = 'PPG_BR_ETIQUETAS_RISCO'    AND
       msi.inventory_item_id  = mic.inventory_item_id       AND
       msi.organization_id    = mic.organization_id         AND
       msi.inventory_item_id  = mic2.inventory_item_id      AND
       msi.organization_id    = mic2.organization_id        AND
       msi.organization_id    = 86;
                 
                                SELECT ffv.description, ffv.parent_flex_value_low, ffv.flex_value
                           FROM apps.fnd_id_flexs fif,
                                apps.fnd_id_flex_structures_vl fifs,
                                apps.fnd_id_flex_segments_vl fifse,
                                apps.fnd_flex_value_sets ffvs,
                                apps.fnd_flex_values_vl ffv
                          WHERE     fif.id_flex_code = fifs.id_flex_code
                                AND fifs.enabled_flag = 'Y'
                                AND fif.id_flex_code = fifse.id_flex_code
                                AND fifs.id_flex_num = fifse.id_flex_num
                                AND fif.application_id = fifs.application_id
                                AND fif.application_id = fifse.application_id
                                AND fifse.flex_value_set_id = ffvs.flex_value_set_id
                                AND fifs.id_flex_structure_code = 'ITEM_CATEGORIES'
                                AND fifse.application_column_name = 'SEGMENT1'
                                AND fif.id_flex_name = 'Item Categories'
                                AND ffvs.flex_value_set_id = ffv.flex_value_set_id
                                AND TRUNC (SYSDATE) BETWEEN (DECODE (TRUNC (ffv.start_date_active),
                                                                     NULL, TRUNC (SYSDATE),
                                                                     TRUNC (ffv.start_date_active)))
                                                        AND (DECODE (TRUNC (ffv.end_date_active),
                                                                     NULL, TRUNC (SYSDATE),
                                                                     TRUNC (ffv.end_date_active)))
                                AND ffv.enabled_flag = 'Y';

select moq.inventory_item_id,
       moq.lot_number,        
      (select min(mtl.transaction_date)
         from apps.mtl_transaction_lot_numbers  mtl,
              apps.mtl_material_transactions    mmt
        where mmt.organization_id      = moq.organization_id   and
              mmt.inventory_item_id    = moq.inventory_item_id and
              mtl.lot_number           = moq.lot_number        and
              mtl.organization_id      = moq.organization_id   and
              mtl.inventory_item_id    = moq.inventory_item_id and
              mmt.transaction_type_id IN (18, 44,40, 41, 42)   and
              mmt.transaction_id       = mtl.transaction_id) RECEIVED_DATE
  from apps.mtl_onhand_quantities_detail moq;


apps.mtl_transaction_lot_numbers  mtl

select mic.inventory_item_id,
       mic.segment1,
       mic.segment2,
       mic.segment3
  from mtl_item_categories_v mic
 where category_set_id = 1;
 
select * from FND_FLEX_VALUES_VL ; 


/* Formatted on 22/03/2021 10:58:43 (QP5 v5.294) */
  SELECT FLEX_VALUE,
         FLEX_VALUE_MEANING,
         DESCRIPTION,
         ENABLED_FLAG,
         START_DATE_ACTIVE,
         END_DATE_ACTIVE,
         SUMMARY_FLAG,
         HIERARCHY_LEVEL,
         FLEX_VALUE_SET_ID,
         PARENT_FLEX_VALUE_LOW,
         PARENT_FLEX_VALUE_HIGH,
         FLEX_VALUE_ID,
         LAST_UPDATE_DATE,
         LAST_UPDATED_BY,
         STRUCTURED_HIERARCHY_LEVEL,
         COMPILED_VALUE_ATTRIBUTES,
         VALUE_CATEGORY,
         ATTRIBUTE1,
         ATTRIBUTE2,
         ATTRIBUTE3,
         ATTRIBUTE4,
         ATTRIBUTE5,
         ATTRIBUTE6,
         ATTRIBUTE7,
         ATTRIBUTE8,
         ATTRIBUTE9,
         ATTRIBUTE10,
         CREATED_BY,
         CREATION_DATE,
         LAST_UPDATE_LOGIN,
         ATTRIBUTE11,
         ATTRIBUTE12,
         ATTRIBUTE13,
         ATTRIBUTE14,
         ATTRIBUTE15,
         ATTRIBUTE16,
         ATTRIBUTE17,
         ATTRIBUTE18,
         ATTRIBUTE19,
         ATTRIBUTE20,
         ATTRIBUTE21,
         ATTRIBUTE22,
         ATTRIBUTE23,
         ATTRIBUTE24,
         ATTRIBUTE25,
         ATTRIBUTE26,
         ATTRIBUTE27,
         ATTRIBUTE28,
         ATTRIBUTE29,
         ATTRIBUTE30,
         ATTRIBUTE31,
         ATTRIBUTE32,
         ATTRIBUTE33,
         ATTRIBUTE34,
         ATTRIBUTE35,
         ATTRIBUTE36,
         ATTRIBUTE37,
         ATTRIBUTE38,
         ATTRIBUTE39,
         ATTRIBUTE40,
         ATTRIBUTE41,
         ATTRIBUTE42,
         ATTRIBUTE43,
         ATTRIBUTE44,
         ATTRIBUTE45,
         ATTRIBUTE46,
         ATTRIBUTE47,
         ATTRIBUTE48,
         ATTRIBUTE49,
         ATTRIBUTE50,
         ATTRIBUTE_SORT_ORDER,
         ROW_ID
    FROM FND_FLEX_VALUES_VL
   WHERE     (   ('' IS NULL)
              OR (structured_hierarchy_level IN
                     (SELECT hierarchy_id
                        FROM fnd_flex_hierarchies_vl h
                       WHERE     h.flex_value_set_id = 1016123
                             AND h.hierarchy_name LIKE '')))
         AND (FLEX_VALUE_SET_ID = 1016123)
ORDER BY flex_value;



select *
    FROM FND_FLEX_VALUES_VL
   WHERE     (   ('' IS NULL)
              OR (structured_hierarchy_level IN
                     (SELECT hierarchy_id
                        FROM fnd_flex_hierarchies_vl h
                       WHERE     h.flex_value_set_id = 1016123
                             AND h.hierarchy_name LIKE '')))
         AND (FLEX_VALUE_SET_ID = 1016123)
         
         
         
/* Formatted on 22/03/2021 14:42:48 (QP5 v5.294) */
  SELECT INVENTORY_ITEM_ID,
         ROW_ID,
         INV_ITEM_DESCRIPTION,
         ORGANIZATION_ID,
         CATEGORY_SET_ID,
         LAST_UPDATE_DATE,
         CATEGORY_ID,
         LAST_UPDATED_BY,
         CREATION_DATE,
         CREATED_BY,
         LAST_UPDATE_LOGIN,
         REQUEST_ID,
         PROGRAM_APPLICATION_ID,
         PROGRAM_ID,
         PROGRAM_UPDATE_DATE,
         INV_ITEM_PADDED_CONCAT_SEGS,
         INV_ITEM_CONCAT_SEGS
    FROM MTL_ITEM_CATEGORIES_VIEW
   WHERE ORGANIZATION_ID = 87 AND (CATEGORY_SET_ID = 1)
ORDER BY inv_item_padded_concat_segs         
       MTL_CATEGORY_SET_VALID_CATS_V 
       
       
       
       
       
       
       
       
select msi.segment1 item_code,
       mic.CATEGORY_CONCAT_SEGS category_set_name,
       msi.inventory_item_id,
   ---- Segment1 is the Item Type ie: Finished goods, Raw Material, Intermediate ----
       mic.segment1,
      (SELECT ffv.description--, ffv.parent_flex_value_low, ffv.flex_value
         FROM apps.fnd_id_flexs              fif,
              apps.fnd_id_flex_structures_vl fifs,
              apps.fnd_id_flex_segments_vl   fifse,
              apps.fnd_flex_value_sets       ffvs,
              apps.fnd_flex_values_vl        ffv
        WHERE     fif.id_flex_code              = fifs.id_flex_code
              AND fifs.enabled_flag             = 'Y'
              AND fif.id_flex_code              = fifse.id_flex_code
              AND fifs.id_flex_num              = fifse.id_flex_num
              AND fif.application_id            = fifs.application_id
              AND fif.application_id            = fifse.application_id
              AND fifse.flex_value_set_id       = ffvs.flex_value_set_id
              AND fifs.id_flex_structure_code   = 'ITEM_CATEGORIES'
              AND fifse.application_column_name = 'SEGMENT1'
              AND fif.id_flex_name              = 'Item Categories'
              AND ffvs.flex_value_set_id        = ffv.flex_value_set_id
              AND TRUNC (SYSDATE) BETWEEN (DECODE (TRUNC (ffv.start_date_active),
                                                   NULL, TRUNC (SYSDATE),
                                                   TRUNC (ffv.start_date_active)))
                                      AND (DECODE (TRUNC (ffv.end_date_active),
                                                   NULL, TRUNC (SYSDATE),
                                                   TRUNC (ffv.end_date_active)))
              AND ffv.enabled_flag = 'Y'
              AND ffv.flex_value = mic.segment1) "ITEM TYPE-SEGMENT1 DESCRIPTION",
   ---- Segment2 is Business Unit ie: Refinish, Industrial, etc ----
       mic.segment2,
      (SELECT ffv.description --, ffv.parent_flex_value_low, ffv.flex_value
         FROM apps.fnd_id_flexs              fif,
              apps.fnd_id_flex_structures_vl fifs,
              apps.fnd_id_flex_segments_vl   fifse,
              apps.fnd_flex_value_sets       ffvs,
              apps.fnd_flex_values_vl        ffv
        WHERE     fif.id_flex_code              = fifs.id_flex_code
              AND fifs.enabled_flag             = 'Y'
              AND fif.id_flex_code              = fifse.id_flex_code
              AND fifs.id_flex_num              = fifse.id_flex_num
              AND fif.application_id            = fifs.application_id
              AND fif.application_id            = fifse.application_id
              AND fifse.flex_value_set_id       = ffvs.flex_value_set_id
              AND fifs.id_flex_structure_code   = 'ITEM_CATEGORIES'
              AND fifse.application_column_name = 'SEGMENT2'
              AND fif.id_flex_name              = 'Item Categories'
              AND ffvs.flex_value_set_id        = ffv.flex_value_set_id
              AND TRUNC (SYSDATE) BETWEEN (DECODE (TRUNC (ffv.start_date_active),
                                                   NULL, TRUNC (SYSDATE),
                                                   TRUNC (ffv.start_date_active)))
                                      AND (DECODE (TRUNC (ffv.end_date_active),
                                                   NULL, TRUNC (SYSDATE),
                                                   TRUNC (ffv.end_date_active)))
              AND ffv.enabled_flag = 'Y'
              AND ffv.flex_value = mic.segment2) "BU - SEGMENT2 DESCRIPTION",
   ---- Segment3 is Product Line ie 1191 (Automotive Others), 1291 (Toyota), etc ----
       mic.segment3,
      (SELECT min(ffv.description) --, ffv.parent_flex_value_low, ffv.flex_value
         FROM apps.fnd_id_flexs              fif,
              apps.fnd_id_flex_structures_vl fifs,
              apps.fnd_id_flex_segments_vl   fifse,
              apps.fnd_flex_value_sets       ffvs,
              apps.fnd_flex_values_vl        ffv
        WHERE     fif.id_flex_code              = fifs.id_flex_code
              AND fifs.enabled_flag             = 'Y'
              AND fif.id_flex_code              = fifse.id_flex_code
              AND fifs.id_flex_num              = fifse.id_flex_num
              AND fif.application_id            = fifs.application_id
              AND fif.application_id            = fifse.application_id
              AND fifse.flex_value_set_id       = ffvs.flex_value_set_id
              AND fifs.id_flex_structure_code   = 'ITEM_CATEGORIES'
              AND fifse.application_column_name = 'SEGMENT3'
              AND fif.id_flex_name              = 'Item Categories'
              AND ffvs.flex_value_set_id        = ffv.flex_value_set_id
              AND TRUNC (SYSDATE) BETWEEN (DECODE (TRUNC (ffv.start_date_active),
                                                   NULL, TRUNC (SYSDATE),
                                                   TRUNC (ffv.start_date_active)))
                                      AND (DECODE (TRUNC (ffv.end_date_active),
                                                   NULL, TRUNC (SYSDATE),
                                                   TRUNC (ffv.end_date_active)))
              AND ffv.enabled_flag = 'Y'
              AND ffv.flex_value = mic.segment3) "PL - SEGMENT3 DESCRIPTION"
   from apps.mtl_system_items_b     msi,
        apps.mtl_item_categories_v mic
  where msi.segment1 like 'TO%' AND
        mic.organization_id   = msi.organization_id AND
        mic.inventory_item_id = msi.inventory_item_id AND
        mic.category_set_id   = 1;
                                
                                SELECT ffv.description, ffv.parent_flex_value_low, ffv.flex_value
                           FROM apps.fnd_id_flexs fif,
                                apps.fnd_id_flex_structures_vl fifs,
                                apps.fnd_id_flex_segments_vl fifse,
                                apps.fnd_flex_value_sets ffvs,
                                apps.fnd_flex_values_vl ffv
                          WHERE     fif.id_flex_code = fifs.id_flex_code
                                AND fifs.enabled_flag = 'Y'
                                AND fif.id_flex_code = fifse.id_flex_code
                                AND fifs.id_flex_num = fifse.id_flex_num
                                AND fif.application_id = fifs.application_id
                                AND fif.application_id = fifse.application_id
                                AND fifse.flex_value_set_id = ffvs.flex_value_set_id
                                AND fifs.id_flex_structure_code = 'ITEM_CATEGORIES'
                                AND fifse.application_column_name = 'SEGMENT1'
                                AND fif.id_flex_name = 'Item Categories'
                                AND ffvs.flex_value_set_id = ffv.flex_value_set_id
                                AND TRUNC (SYSDATE) BETWEEN (DECODE (TRUNC (ffv.start_date_active),
                                                                     NULL, TRUNC (SYSDATE),
                                                                     TRUNC (ffv.start_date_active)))
                                                        AND (DECODE (TRUNC (ffv.end_date_active),
                                                                     NULL, TRUNC (SYSDATE),
                                                                     TRUNC (ffv.end_date_active)))
                                AND ffv.enabled_flag = 'Y';