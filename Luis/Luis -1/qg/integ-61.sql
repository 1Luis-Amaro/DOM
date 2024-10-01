select gbh.batch_id, msi.segment1, MC1.segment1 -- xxppg_inv_oper_preactor_pkg.get_category_segment(msi.inventory_item_id,msi.organization_id) 
   from gme_batch_header gbh,
                     gme_material_details gmd,
                     mtl_system_items_b msi,
                     mtl_parameters mp,
                     mtl_item_categories mic1,
                     mtl_categories mc1,
                     mtl_category_sets mcs1
   where mp.organization_code    = 'GVT'                 AND
         gbh.batch_no            = 7                     AND
         gbh.organization_id     = mp.organization_id    AND
         gmd.batch_id            = gbh.batch_id          AND
         gmd.organization_id     = mp.organization_id    AND
         gmd.line_type           = -1                    AND
         msi.inventory_item_id   = gmd.inventory_item_id AND
         msi.organization_id     = mp.organization_id    AND
         mic1.inventory_item_id  = msi.INVENTORY_ITEM_ID AND
         mic1.organization_id    = msi.ORGANIZATION_ID  AND
      --   msib1.organization_id   = mic1.organization_id  AND
      --   msib1.inventory_item_id = mic1.inventory_item_id AND
         mc1.category_id         = mic1.category_id            AND
         mcs1.category_set_id    = 1                    AND
         mcs1.category_set_id    = mic1.category_set_id
         
         
         /*AND
         xxppg_inv_oper_preactor_pkg.get_category_segment(msi.inventory_item_id,msi.organization_id) = 'EMB'*/
         
         
         
         CURSOR c_category ( PX_INVENTORY_ITEM_ID  IN NUMBER
                   ,PX_ORGANIZATION_ID    IN NUMBER) IS
    SELECT  mc1.segment1
    FROM mtl_item_categories mic1
       , mtl_categories mc1
       , mtl_system_items_b msib1
       , mtl_category_sets mcs1
    WHERE 1 = 1
     AND  mic1.inventory_item_id = PX_INVENTORY_ITEM_ID
     AND mic1.organization_id    = PX_ORGANIZATION_ID
     AND msib1.organization_id = mic1.organization_id
     AND msib1.inventory_item_id = mic1.inventory_item_id
     AND mc1.category_id = mic1.category_id
     AND mcs1.category_set_id   = 1--'Inventory' --en Inventory puedo ver si es acabado o intermediario
     AND mcs1.category_set_id   = mic1.category_set_id
     AND MC1.segment1 IN ( 'ACA', 'INT','SEMI');
 l_category   VARCHAR2(20):='ACA';
 lMessage     VARCHAR2(4000):=null;
         
         
   