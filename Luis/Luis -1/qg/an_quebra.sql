select gbh.batch_id, gmd.*, (NVL (gmd.wip_plan_qty, gmd.plan_qty))
  from gme_batch_header gbh,
       gme_material_details gmd
 where gbh.batch_no        = 71195 and
       gbh.organization_id = 92    and
       gmd.batch_id        = gbh.batch_id and
       gmd.organization_id = gbh.organization_id;
       
       
SELECT recipe_id 
  FROM apps.gmd_recipe_validity_rules grvr
 WHERE recipe_validity_rule_id = 692876;       
       
select * from gme_material_details gmd; 
select * from gme_batch_steps gbs; 
       
SELECT NVL(gbs.attribute1,TO_NUMBER ((SELECT MAX (NVL (attribute1, 1))
                                                       FROM gmd_recipe_step_materials grs
                                                      WHERE grs.routingstep_id = gbs.routingstep_id
                                                        AND grs.recipe_id      = 133971)
                                              )) repeticao,
       gbs.routingstep_id,
       gbs.batchstep_no
  FROM gme_batch_steps gbs
 WHERE gbs.batch_id = 798673
   and gbs.batchstep_id in (SELECT b.batchstep_id
                              FROM gme_batch_steps b, gme_batch_step_items s, gme_material_details gmd
                             WHERE b.batchstep_id = s.batchstep_id
                               and b.batch_id = gbs.batch_id
                               and s.material_detail_id = gmd.material_detail_id
                               and gmd.line_type = -1);       
                 
/************* Rotina Correta Quebra *****************/
SELECT msi.segment1,
       NVL (gmd.wip_plan_qty, gmd.plan_qty),
       NVL(gbs.attribute1,TO_NUMBER ((SELECT MAX (NVL (attribute1, 1))
                                                       FROM gmd_recipe_step_materials grs
                                                      WHERE grs.routingstep_id = gbs.routingstep_id
                                                        AND grs.recipe_id      = 133971)
                                              )) repeticao,
       NVL (gmd.wip_plan_qty, gmd.plan_qty) / 
       NVL(gbs.attribute1,nvl(TO_NUMBER ((SELECT MAX (NVL (attribute1, 1))
                                                       FROM gmd_recipe_step_materials grs
                                                      WHERE grs.routingstep_id = gbs.routingstep_id
                                                        AND grs.recipe_id      = 133971)
                                              ),1))
       fatortipouc
  FROM gme_batch_step_items   gbsi,
       gme_material_details   gmd,
       gme_batch_steps        gbs,
       mtl_system_items_b     msi,
       wmas.produto@wmas_link prod,
       wmas.tipouc@wmas_link  tpuc
 WHERE gbs.batchstep_id        = gbsi.batchstep_id      and
       gbsi.material_detail_id = gmd.material_detail_id and
       prod.codigoempresa      = 1                      and
       prod.codigoproduto      = msi.segment1           and
       tpuc.codigoempresa      = 1                      and
       tpuc.codigoproduto      = prod.codigoproduto     and
       tpuc.tipouc             = prod.tipoucpadrao      and
       msi.organization_id     = gmd.organization_id    and
       msi.inventory_item_id   = gmd.inventory_item_id  and
       gmd.line_type           = -1                     and
       gbs.batch_id            = 798673;                               
       
select * from apps.produto;

select * from wmas.tipouc@wmas_link;       

select codigoempresa from wmas.produto@wmas_link;

select * from apps.documento;