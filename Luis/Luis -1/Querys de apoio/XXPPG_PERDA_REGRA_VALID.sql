SELECT mp.organization_code org
       , grv.orgn_code
       , iim.segment1 produto
       , iim.description descricao
       , rout.routing_class classe_rout
       , ffm.formula_no formula
       , rout.routing_no roteiro
       , gr.recipe_no receita
       , ffm.formula_vers versao_form
       , rout.routing_vers versao_rout
       , gr.recipe_version versao_rec
       , gs.description stat_form
       , gs1.description stat_rout
       , gs2.description stat_recet
       , gs3.description stat_reg_valit
       , flv.meaning uso
       , grv.planned_process_loss perda_planej
       , grv.start_date data_inic
       , grv.end_date   data_fim
       , grv.preference preferencia
    FROM apps.gmd_recipes gr
       , apps.gmd_routings rout
       , apps.fm_form_mst ffm
       , apps.fm_matl_dtl fmd
       , apps.mtl_system_items iim
       , apps.gmd_recipe_validity_rules grv
       , apps.mtl_parameters mp
       , apps.gmd_status gs
       , apps.gmd_status gs1
       , apps.gmd_status gs2
       , apps.gmd_status gs3
       , apps.fnd_lookup_values_vl flv
   WHERE ffm.formula_id = gr.formula_id(+)
     AND fmd.formula_id = ffm.formula_id
     AND fmd.line_type = 1
     AND iim.inventory_item_id = fmd.inventory_item_id
     AND gs.status_code = ffm.formula_status
     AND gs1.status_code = rout.routing_status
     AND gs2.status_code = gr.recipe_status
     AND gs3.status_code = grv.validity_rule_status
     AND iim.organization_id = fmd.organization_id
     AND grv.recipe_id(+) = gr.recipe_id
     AND rout.routing_id(+) = gr.routing_id
     AND ffm.owner_organization_id = mp.organization_id
     AND lookup_type = 'GMD_FORMULA_USE'
     AND flv.lookup_code = grv.recipe_use
     AND grv.validity_rule_status NOT IN (1000)
ORDER BY 2
