/* Formatted on 01/07/2015 14:18:12 (QP5 v5.227.12220.39724) */
  SELECT mp.organization_code,
         i1.segment1,
         a.line_no,
         ffm.formula_vers--, a.formulaline_id
         ,
         i.segment1,
         a.qty,
         INVENTARIO.CATEGORIA,
         ftt.text                                                    --, ftt.*
    FROM apps.fm_matl_dtl a,
         apps.fm_text_tbl ftt,
         apps.mtl_system_items i,
         apps.fm_matl_dtl c,
         apps.mtl_system_items i1,
         apps.mtl_parameters mp,
         apps.fm_form_mst ffm,
         (SELECT MIC.INVENTORY_ITEM_ID,
                       MIC.ORGANIZATION_ID,
                       MIC.CATEGORY_SET_NAME,
                       MIC.CATEGORY_CONCAT_SEGS CATEGORIA
                  FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
                 WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
                   AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO         
   WHERE     1 = 1
         AND a.text_code = ftt.text_code(+)
         AND ffm.formula_id = a.formula_id
         AND i.inventory_item_id = a.inventory_item_id
         AND i.organization_id = a.organization_id
         AND c.formula_id = a.formula_id
         AND c.inventory_item_id = i1.inventory_item_id
         AND mp.organization_id = i1.organization_id
         AND c.organization_id = i1.organization_id
         AND a.line_type = -1
         AND c.line_type = 1
         /*AND a.formula_id IN (SELECT formula_id
                                FROM apps.fm_matl_dtl fmd, apps.fm_text_tbl ftt
                               WHERE fmd.text_code = ftt.text_code)*/
         AND ftt.line_no(+) > 0
         --and formula_id  =  12590
         AND mp.organization_code = 'GVT'
         
         AND inventario.categoria like 'SEMI%'
         AND i1.ORGANIZATION_ID   = INVENTARIO.ORGANIZATION_ID(+)
         AND i1.INVENTORY_ITEM_ID = INVENTARIO.INVENTORY_ITEM_ID(+)
         --AND i1.segment1  like 'D800%'



ORDER BY i1.segment1, a.line_no, ftt.line_no