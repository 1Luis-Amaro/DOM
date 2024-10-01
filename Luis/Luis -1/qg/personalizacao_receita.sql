:CONTROL_GMDRVRSM.ROUTING_NO = 'TR.SP6.1912.CQ4(8H)'

select
select distinct msi.segment1       
  from gmd_recipe_step_materials grs,
       fm_matl_dtl fd,
       mtl_system_items_b msi
 where grs.recipe_id = 209347 and
       fd.formulaline_id = grs.formulaline_id and
       fd.contribute_yield_ind = 'Y' and
       msi.inventory_item_id = fd.inventory_item_id and
       msi.organization_id   = fd.organization_id and
       inv_convert.inv_um_convert(fd.inventory_item_id, msi.primary_uom_code,'l') < 0;


select resources, max_capacity from CR_RSRC_MST_VL;

select STD_QTY
  from gmd_recipe_validity_rules
 where recipe_id = 151516;
 
select description
  from fnd_lookup_values_vl flv
 where lookup_type = 'XXPPG_CAPACIDADE_RECURSO' and
       lookup_code = ;

select *
  from gmd_recipe_step_materials grs
 where recipe_id = 151516;
  
select msi.segment1, fd.qty * 47640,
       inv_convert.inv_um_convert(fd.inventory_item_id, msi.primary_uom_code,'l')
  from gmd_recipe_step_materials grs,
       fm_matl_dtl fd,
       mtl_system_items_b msi
 where grs.recipe_id = 209347 and
       fd.formulaline_id = grs.formulaline_id and
       fd.contribute_yield_ind = 'Y' and
       msi.inventory_item_id = fd.inventory_item_id and
       msi.organization_id   = fd.organization_id;
select * 
  from (
select gor.resources,
      (nvl((select sum((fd.qty * 47630) / inv_convert.inv_um_convert(fd.inventory_item_id, msi.primary_uom_code,'l'))
         from gmd_recipe_step_materials grs,
              fm_matl_dtl fd,
              mtl_system_items_b msi
        where grs.recipe_id = gr.recipe_id and
              grs.routingstep_id <= frd.routingstep_id and 
              fd.formulaline_id = grs.formulaline_id and
              fd.contribute_yield_ind = 'Y' and
              fd.line_type = -1 and
              msi.inventory_item_id = fd.inventory_item_id and
              msi.organization_id   = fd.organization_id),0)) uso,
       nvl((select max(attribute1)
               from gmd_recipe_step_materials grs
              where grs.recipe_id = gr.recipe_id and
                    grs.routingstep_id = frd.routingstep_id),1) quebra,
       to_number(nvl((select description
           from fnd_lookup_values_vl flv
          where lookup_type = 'XXPPG_CAPACIDADE_RECURSO' and
                lookup_code = gor.resources),999999)) capacidade,
   ------
   (nvl((select sum((fd.qty * 47640) / inv_convert.inv_um_convert(fd.inventory_item_id, msi.primary_uom_code,'l'))
         from gmd_recipe_step_materials grs,
              fm_matl_dtl fd,
              mtl_system_items_b msi
        where grs.recipe_id = gr.recipe_id and
              grs.routingstep_id <= frd.routingstep_id and 
              fd.formulaline_id = grs.formulaline_id and
              fd.contribute_yield_ind = 'Y' and
              fd.line_type = -1 and
              msi.inventory_item_id = fd.inventory_item_id and
              msi.organization_id   = fd.organization_id),0)) /
       nvl((select max(attribute1)
               from gmd_recipe_step_materials grs
              where grs.recipe_id = gr.recipe_id and
                    grs.routingstep_id = frd.routingstep_id),1) -
       to_number(nvl((select description
           from fnd_lookup_values_vl flv
          where lookup_type = 'XXPPG_CAPACIDADE_RECURSO' and
                lookup_code = gor.resources),999999)) capacidade_t
  from gmd_recipes gr,
       fm_rout_dtl frd,
       GMD_OPERATION_ACTIVITIES fov,
       gmd_operation_resources gor 
  where gr.recipe_id = 209347 and
        frd.routing_id = gr.routing_id and
        fov.oprn_id = frd.oprn_id   and
        gor.oprn_line_id = fov.oprn_line_id and
        gor.cost_cmpntcls_id = 17)
  where capacidade_t > -10000000;      
  
select * from gmd_operation_resources gor;

select * from GMD_OPERATION_ACTIVITIES fo;

----------------------------------------
select /*gor.resources,
      (nvl((select sum((fd.qty * 47640) * inv_convert.inv_um_convert(fd.inventory_item_id, msi.primary_uom_code,'l'))
         from gmd_recipe_step_materials grs,
              fm_matl_dtl fd,
              mtl_system_items_b msi
        where grs.recipe_id = gr.recipe_id and
              grs.routingstep_id <= frd.routingstep_id and 
              fd.formulaline_id = grs.formulaline_id and
              fd.contribute_yield_ind = 'Y' and
              fd.line_type = -1 and
              msi.inventory_item_id = fd.inventory_item_id and
              msi.organization_id   = fd.organization_id),0) /
       nvl((select max(attribute1)
               from gmd_recipe_step_materials grs
              where grs.recipe_id = gr.recipe_id and
                    grs.routingstep_id = frd.routingstep_id),1)) -
       to_number(nvl((select description
           from fnd_lookup_values_vl flv
          where lookup_type = 'XXPPG_CAPACIDADE_RECURSO' and
                lookup_code = gor.resources),999999)) capacidade*/
         --       
    gor.*
  from gmd_recipes gr,
       fm_rout_dtl frd,
       GMD_OPERATION_ACTIVITIES fov,
       gmd_operation_resources gor 
  where gr.recipe_id = 209347 and
        frd.routing_id = gr.routing_id and
        fov.oprn_id = frd.oprn_id   and
        gor.oprn_line_id = fov.oprn_line_id and
        gor.cost_cmpntcls_id = 17

----------------------------------------

-----
select gor.resources,
      (nvl((select sum((fd.qty * 12000) / inv_convert.inv_um_convert(fd.inventory_item_id, msi.primary_uom_code,'l'))
         from gmd_recipe_step_materials grs,
              fm_matl_dtl fd,
              mtl_system_items_b msi
        where grs.recipe_id = gr.recipe_id and
              grs.routingstep_id <= frd.routingstep_id and 
              fd.formulaline_id = grs.formulaline_id and
              fd.contribute_yield_ind = 'Y' and
              fd.line_type = -1 and
              msi.inventory_item_id = fd.inventory_item_id and
              msi.organization_id   = fd.organization_id),0)) QT, 
       nvl((select max(attribute1)
               from gmd_recipe_step_materials grs
              where grs.recipe_id = gr.recipe_id and
                    grs.routingstep_id = frd.routingstep_id),1) qtd,
       to_number(nvl((select description
           from fnd_lookup_values_vl flv
          where lookup_type = 'XXPPG_CAPACIDADE_RECURSO' and
                lookup_code = gor.resources),999999)) capacidade
  from gmd_recipes gr,
       fm_rout_dtl frd,
       GMD_OPERATION_ACTIVITIES fov,
       gmd_operation_resources gor 
  where gr.recipe_id = 151516 and
        frd.routing_id = gr.routing_id and
        fov.oprn_id = frd.oprn_id   and
        gor.oprn_line_id = fov.oprn_line_id and
        gor.cost_cmpntcls_id = 17;
        
        
----- Personalização Primeira tela (sem entrar no Detalhe) ------
1 = (select max(1) 
  from (
select gor.resources,
      (nvl((select sum((fd.qty * :gmd_rcpe_vldty_rules.std_qty) / inv_convert.inv_um_convert(fd.inventory_item_id, msi.primary_uom_code,'l'))
         from gmd_recipe_step_materials grs,
              fm_matl_dtl fd,
              mtl_system_items_b msi
        where grs.recipe_id = gr.recipe_id and
              grs.routingstep_id <= frd.routingstep_id and 
              fd.formulaline_id = grs.formulaline_id and
              fd.contribute_yield_ind = 'Y' and
              fd.line_type = -1 and
              msi.inventory_item_id = fd.inventory_item_id and
              msi.organization_id   = fd.organization_id),0) /
       nvl((select max(attribute1)
               from gmd_recipe_step_materials grs
              where grs.recipe_id = gr.recipe_id and
                    grs.routingstep_id = frd.routingstep_id),1)) -
       to_number(nvl((select description
           from fnd_lookup_values_vl flv
          where lookup_type = 'XXPPG_CAPACIDADE_RECURSO' and
                lookup_code = gor.resources),999999)) capacidade
  from gmd_recipes gr,
       fm_rout_dtl frd,
       gmd_operation_activities fov,
       gmd_operation_resources gor 
  where gr.recipe_id = :gmd_rcpe_vldty_rules.recipe_id and
        frd.routing_id = gr.routing_id and
        fov.oprn_id = frd.oprn_id   and
        gor.oprn_line_id = fov.oprn_line_id and
        gor.cost_cmpntcls_id = 17)
  where capacidade > 0)        
  
  
  
------- Personalização Segunda tela (entrando no Detalhe) ------
1 = (select max(1)  
  from (
select gor.resources,
      (nvl((select sum((fd.qty * :gmd_recp_val_rules.max_qty) / inv_convert.inv_um_convert(fd.inventory_item_id, msi.primary_uom_code,'l'))
         from gmd_recipe_step_materials grs,
              fm_matl_dtl fd,
              mtl_system_items_b msi
        where grs.recipe_id = gr.recipe_id and
              grs.routingstep_id <= frd.routingstep_id and 
              fd.formulaline_id = grs.formulaline_id and
              fd.contribute_yield_ind = 'Y' and
              fd.line_type = -1 and
              msi.inventory_item_id = fd.inventory_item_id and
              msi.organization_id   = fd.organization_id),0) /
       nvl((select max(attribute1)
               from gmd_recipe_step_materials grs
              where grs.recipe_id = gr.recipe_id and
                    grs.routingstep_id = frd.routingstep_id),1)) -
       to_number(nvl((select description
           from fnd_lookup_values_vl flv
          where lookup_type = 'XXPPG_CAPACIDADE_RECURSO' and
                lookup_code = gor.resources),999999)) capacidade
  from gmd_recipes gr,
       fm_rout_dtl frd,
       gmd_operation_activities fov,
       gmd_operation_resources gor 
  where gr.recipe_id = :gmd_recp_val_rules.recipe_id and
        frd.routing_id = gr.routing_id and
        fov.oprn_id = frd.oprn_id   and
        gor.oprn_line_id = fov.oprn_line_id and
        gor.cost_cmpntcls_id = 17)
  where capacidade > 0)
  
  
        23555.00000