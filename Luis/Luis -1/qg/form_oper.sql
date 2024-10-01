/* Formatted on 04/08/2015 09:34:56 (QP5 v5.227.12220.39724) 
SELECT *            --routing_no, rd.routingstep_no, recipe_no, recipe_version
  FROM apps.gmd_operation_resources  gor,
       apps.gmd_operation_activities goa,
       apps.gmd_operations gop,
       apps.fm_rout_hdr rh,
       apps.fm_rout_dtl rd,
       apps.gmd_recipe_routing_steps rs,
       apps.gmd_recipes r,
       apps.gmd_recipe_validity_rules vr
 WHERE gor.oprn_line_id      = goa.oprn_line_id  AND
       gor.COST_CMPNTCLS_ID  = 3                 AND
       goa.oprn_id           = rd.oprn_id        AND
       gop.oprn_id           = rd.oprn_id        AND
       rh.routing_id         = rd.routing_id     AND
       rd.routingstep_id     = rs.routingstep_id AND
       rd.routing_id         = r.routing_id      AND
       rs.recipe_id          = r.recipe_id       AND
       vr.recipe_id          = r.recipe_id       AND
       r.recipe_no like 'C086-6405/30000';*/
select * from  apps.gmd_recipes ;
/* Formatted on 04/08/2015 09:34:56 (QP5 v5.227.12220.39724) */
SELECT msi.segment1,
       msi.item_type,
       mic.segment2,
       fm.formula_no,
       fm.formula_vers,
       r.recipe_no,
       r.recipe_version,
       decode(vr.recipe_use, 0, 'Producao',1,'Planej',2,'Custo',3,'Normativo',4,'Tecnico') "Uso Receita",
       routing_no,
       routing_vers,
       activity,
       resources,
       resource_usage,
       resource_count,
       gor.resource_usage_uom
  FROM apps.gmd_operation_resources  gor,
       apps.gmd_operation_activities goa,
       apps.gmd_operations           gop,
       apps.mtl_item_categories_v   mic,
       apps.mtl_categories_v mc,
       apps.mtl_system_items_b msi,
       apps.fm_rout_hdr rh,
       apps.fm_rout_dtl rd,
       apps.fm_matl_dtl fmd,
       apps.fm_form_mst fm,
       apps.gmd_recipes r,
       apps.gmd_recipe_validity_rules vr
 WHERE gor.oprn_line_id        = goa.oprn_line_id        AND
       gor.COST_CMPNTCLS_ID    = 3                       AND
       goa.oprn_id             = rd.oprn_id              AND
       gop.oprn_id             = rd.oprn_id              AND
       rh.routing_id           = rd.routing_id           AND
       rd.routing_id           = r.routing_id            AND
       mc.category_id          = MIC.CATEGORY_ID         AND
       mic.category_set_name IN ('Inventory')            AND
       mic.organization_id     = msi.organization_id     AND       
       mic.inventory_item_id   = msi.inventory_item_id   AND
       msi.organization_id     = r.owner_organization_id AND
       msi.inventory_item_id   = fmd.inventory_item_id   AND
       fmd.formula_id          = fm.formula_id           AND
       fmd.line_type           = 1                       AND
       fm.formula_class       <> 'TING_PMC'              AND
       fm.formula_id           = r.formula_id            AND
       vr.recipe_use           = 2                       AND
       vr.recipe_id            = r.recipe_id             AND
       vr.validity_rule_status in (700,900)              AND   
       vr.delete_mark          = 0                       AND   
       vr.start_date          <= sysdate                 AND
       vr.end_date            is NULL                    AND                   
       r.owner_organization_id = 92                      AND
       --msi.segment1 = '0280095L' and
       r.recipe_status        >= 700       /*        AND
       r.recipe_no like 'C086-6405/30000'*/
       order by fm.formula_no, r.recipe_no, routing_no, activity, resources;

select * from APPS.MTL_ITEM_CATEGORIES_V MIC where mic.category_set_name IN ('Inventory');

SELECT * from APPS.fm_matl_dtl;



       (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO,
