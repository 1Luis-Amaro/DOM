  SELECT mp.organization_code org
       , gr.recipe_no receita
       , gr.recipe_version rec_vers
       , grvr.std_qty qtd_padrao
       , fmm.formula_no formula
       , fmm.formula_vers for_vers
       , fmm.formula_class for_class
       , frh.routing_no roteiro
       , frh.routing_vers rot_vers
       , frh.routing_class rot_class
       , frh.routing_qty rot_qtd
       , frh.routing_uom rot_udm
       , frd.routingstep_no nro_oper
       , gob.oprn_no operacao
       , gob.process_qty_uom ope_qtd
       , goa.activity atividade
       , goa.offset_interval intervalo
       , goa.activity_factor ati_fat
       , msib.segment1 item
       , DECODE (fmd.line_type
               , 1, 'Produto'
               , -1, 'Ingrediente'
               , 0, 'Residual')
           tipo      
       , fmd.qty qtd
       , fmd.detail_uom udm
       , grvr.planned_process_loss perda_custos
       , fmd.contribute_step_qty_ind contr_etapa
       , fmd.contribute_yield_ind contr_aprov
       , decode (fmd.scale_type,0,'Fixo',1,'Proporcional',2,'Inteiro') escala
       , fmd.scale_multiple multiplo_escala
       , fmd.scale_rounding_variance arred
    FROM apps.gmd_recipe_step_materials grsm
       , apps.fm_form_mst fmm
       , apps.fm_matl_dtl fmd
       , apps.gmd_recipes gr
       , apps.mtl_parameters mp
       , apps.mtl_system_items_b msib
       , apps.fm_rout_hdr frh
       , apps.fm_rout_dtl frd
       , apps.gmd_operations_b gob
       , apps.gmd_recipe_validity_rules grvr
       , apps.gmd_operation_activities goa
   WHERE fmm.formula_id = fmd.formula_id
     AND frh.routing_id = frd.routing_id
     AND grsm.formulaline_id(+) = fmd.formulaline_id
     AND grsm.recipe_id = gr.recipe_id
     AND grsm.routingstep_id = frd.routingstep_id
     AND fmd.inventory_item_id = msib.inventory_item_id
     AND grvr.organization_id = msib.organization_id
     AND grvr.organization_id = mp.organization_id(+)
     AND frd.oprn_id = gob.oprn_id
     AND grvr.recipe_id = gr.recipe_id
     AND gr.recipe_id = grsm.recipe_id
     AND gob.oprn_id = goa.oprn_id
     AND gr.routing_id = frh.routing_id(+)
     AND grvr.recipe_use = 2
     AND grvr.preference = 1
     AND grvr.validity_rule_status IN (700,900)
ORDER BY mp.organization_code
       , frd.routingstep_no
       , fmd.line_type