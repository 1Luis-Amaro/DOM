select * from wmas.PRODUTO@WMAS_LINK lsm;


SELECT msi.segment1, 
       item.TIPOUCPADRAO,
       fatortipouc,
       emb.* 
  FROM wmas.PRODUTO @WMAS_LINK item,
       oraint.tipouc  @WMAS_link emb,
       apps.mtl_system_items_b msi
 WHERE msi.item_type                  = 'MP'              and
       msi.inventory_item_status_code = 'Active'          and
       msi.organization_id            = 92                and
       msi.segment1 = 'PT-33-2990' and
       item.CODIGOPRODUTO             = msi.segment1      and
       item.codigoempresa             = 1                 and
       emb.tipouc                     = item.TIPOUCPADRAO and
       emb.codigoproduto              = item.codigoproduto; 


SELECT gbh.batch_id,
       (select nvl(gbs.attribute1,TO_NUMBER ((SELECT MAX (NVL (grs.attribute1, 1))
                                                    FROM gmd_recipe_step_materials grs,
                                                         gmd_recipe_validity_rules vr
                                                   WHERE grs.routingstep_id         = gbs.routingstep_id
                                                     AND grs.recipe_id              = vr.recipe_id
                                                     AND vr.recipe_validity_rule_id = gbh.recipe_validity_rule_id
                                                     AND rownum = 1)
                                                ))
                 --  gbs.routingstep_id,
                 --  gbs.batchstep_no,
                 --  gbs.batchstep_id
          from gme_batch_steps gbs
         where gbs.batch_id = gbh.batch_id
           and rownum = 1
           and gbs.routingstep_id in
                                  (select routingstep_id
                                     from gmd_recipe_step_materials grsi
                                    where grsi.routingstep_id = gbs.routingstep_id
                                      and grsi.FORMULALINE_ID in
                                                 (select gmd.FORMULALINE_ID
                                                    from gme_material_details gmd
                                                   where gmd.batch_id = gbh.batch_id
                                                     and gmd.line_type = -1))) etapas
  from apps.gme_batch_header     gbh,
       apps.gme_material_details gmd
 where gbh.organization_id = 92     and
       gbh.batch_no        = 109186 and
       gmd.batch_id        = gbh.batch_id;
       
select * from gmd_recipe_validity_rules vr;       
       
SELECT * FROM apps.gme_material_details gmd      

       
SELECT msi.segment1, 
       item.TIPOUCPADRAO,
      (select fatortipouc
         from oraint.tipouc  @WMAS_link emb
        where emb.tipouc          = item.TIPOUCPADRAO  and
              emb.codigoproduto   = item.codigoproduto and
              emb.codigoempresa   = item.codigoempresa and
              sequenciaintegracao = (select max(sequenciaintegracao)
                                       from oraint.tipouc  @WMAS_link emb
                                      where emb.tipouc          = item.TIPOUCPADRAO and
                                            emb.codigoproduto   = item.codigoproduto and
                                            emb.codigoempresa   = item.codigoempresa)) fatortipouc,
       (nvl(to_char((select fatortipouc
               from oraint.tipouc  @WMAS_link emb
              where emb.tipouc          = item.TIPOUCPADRAO  and
                    emb.codigoproduto   = item.codigoproduto and
                    emb.codigoempresa   = item.codigoempresa and
                    sequenciaintegracao = (select max(sequenciaintegracao)
                                             from oraint.tipouc  @WMAS_link emb
                                            where emb.tipouc          = item.TIPOUCPADRAO  and
                                                  emb.codigoproduto   = item.codigoproduto and
                                                  emb.codigoempresa   = item.codigoempresa))), item.TIPOUCPADRAO)) embalagem
  FROM wmas.PRODUTO @WMAS_LINK item,
       apps.mtl_system_items_b msi
 WHERE msi.item_type                  = 'MP'              and
       msi.inventory_item_status_code = 'Active'          and
       msi.organization_id            = 92                and
       msi.segment1                   = 'PT-33-2990' and
       item.CODIGOPRODUTO             = msi.segment1      and
       item.codigoempresa             = 1;





declare aa number;
begin
   begin
      select to_number('xx') into aa from dual;
      exception WHEN others THEN
          select 'x' into aa from dual;
   end;
end;


      
select emb.*
  from oraint.tipouc  @WMAS_link emb 
 where SEQUENCIAINTEGRACAO = 170490        
 
 
 
 
 
 
 
 
SELECT msi.segment1, 
       item.TIPOUCPADRAO,
      (select fatortipouc
         from oraint.tipouc  @WMAS_link emb
        where emb.tipouc          = item.TIPOUCPADRAO  and
              emb.codigoproduto   = item.codigoproduto and
              emb.codigoempresa   = item.codigoempresa and
              sequenciaintegracao = (select max(sequenciaintegracao)
                                       from oraint.tipouc  @WMAS_link emb
                                      where emb.tipouc          = item.TIPOUCPADRAO and
                                            emb.codigoproduto   = item.codigoproduto and
                                            emb.codigoempresa   = item.codigoempresa)) fatortipouc,
       (nvl(to_char((select fatortipouc
               from oraint.tipouc  @WMAS_link emb
              where emb.tipouc          = item.TIPOUCPADRAO  and
                    emb.codigoproduto   = item.codigoproduto and
                    emb.codigoempresa   = item.codigoempresa and
                    sequenciaintegracao = (select max(sequenciaintegracao)
                                             from oraint.tipouc  @WMAS_link emb
                                            where emb.tipouc          = item.TIPOUCPADRAO  and
                                                  emb.codigoproduto   = item.codigoproduto and
                                                  emb.codigoempresa   = item.codigoempresa))), item.TIPOUCPADRAO)) embalagem
  FROM wmas.PRODUTO @WMAS_LINK item,
       apps.mtl_system_items_b msi
 WHERE msi.item_type                  = 'MP'              and
       msi.inventory_item_status_code = 'Active'          and
       msi.organization_id            = 92                and
       msi.segment1                   = 'PT-33-2990' and
       item.CODIGOPRODUTO             = msi.segment1      and
       item.codigoempresa             = 1;




SELECT gbh.batch_id,
       (select nvl(gbs.attribute1,TO_NUMBER ((SELECT MAX (NVL (grs.attribute1, 1))
                                                    FROM gmd_recipe_step_materials grs,
                                                         gmd_recipe_validity_rules vr
                                                   WHERE grs.routingstep_id         = gbs.routingstep_id
                                                     AND grs.recipe_id              = vr.recipe_id
                                                     AND vr.recipe_validity_rule_id = gbh.recipe_validity_rule_id
                                                     AND rownum = 1)
                                                ))
          from gme_batch_steps gbs
         where gbs.batch_id = gbh.batch_id
           and rownum = 1
           and gbs.routingstep_id in
                                  (select routingstep_id
                                     from gmd_recipe_step_materials grsi
                                    where grsi.routingstep_id = gbs.routingstep_id
                                      and grsi.FORMULALINE_ID in
                                                 (select gmd.FORMULALINE_ID
                                                    from gme_material_details gmd
                                                   where gmd.batch_id = gbh.batch_id
                                                     and gmd.line_type = -1))) etapas,
       (nvl(to_char((select fatortipouc
               from oraint.tipouc  @WMAS_link emb
              where emb.tipouc          = item.TIPOUCPADRAO  and
                    emb.codigoproduto   = item.codigoproduto and
                    emb.codigoempresa   = item.codigoempresa and
                    sequenciaintegracao = (select max(sequenciaintegracao)
                                             from oraint.tipouc  @WMAS_link emb
                                            where emb.tipouc          = item.TIPOUCPADRAO  and
                                                  emb.codigoproduto   = item.codigoproduto and
                                                  emb.codigoempresa   = item.codigoempresa))), item.TIPOUCPADRAO)) embalagem,
       gmd.plan_qty
  from apps.gme_batch_header     gbh,
       apps.gme_material_details gmd,
       wmas.PRODUTO @WMAS_LINK   item,
       apps.mtl_system_items_b   msi
 where gbh.organization_id   = 92           and
       gbh.batch_no          = 109186       and
       gmd.batch_id          = gbh.batch_id and
       msi.organization_id   = gbh.organization_id and
       msi.inventory_item_id = gmd.inventory_item_id and
       item.codigoproduto    = msi.segment1      and
       item.codigoempresa    = 1;
       
SELECT (select nvl(gbs.attribute1,TO_NUMBER ((SELECT MAX (NVL (grs.attribute1, 1))
                                                    FROM gmd_recipe_step_materials grs,
                                                         gmd_recipe_validity_rules vr
                                                   WHERE grs.routingstep_id         = gbs.routingstep_id
                                                     AND grs.recipe_id              = vr.recipe_id
                                                     AND vr.recipe_validity_rule_id = gbh.recipe_validity_rule_id
                                                     AND rownum = 1)
                                                ))
                 --  gbs.routingstep_id,
                 --  gbs.batchstep_no,
                 --  gbs.batchstep_id
          from gme_batch_steps gbs
         where gbs.batch_id = gbh.batch_id
           and rownum = 1
           and gbs.routingstep_id in
                                  (select routingstep_id
                                     from gmd_recipe_step_materials grsi
                                    where grsi.routingstep_id = gbs.routingstep_id
                                      and grsi.FORMULALINE_ID in
                                                 (select gmd.FORMULALINE_ID
                                                    from gme_material_details gmd
                                                   where gmd.batch_id = gbh.batch_id
                                                     and gmd.line_type = -1))) etapas
  from apps.gme_batch_header     gbh
 where gbh.organization_id = 92     and
       gbh.batch_no        = 109186;       