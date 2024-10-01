SELECT DISTINCT
         mp.organization_code org
       , msi.segment1 produto
       , msi.description descricao
       , mic.segment1 tipo_item
       , mic.segment2 origem
       , ffm.formula_no formula
       , gr.recipe_no receita
       , gr.recipe_version versao_rec
       , gr.recipe_status status_rec
       , grv.validity_rule_status status_regra
       , DECODE (grv.recipe_use
               , 0, 'Producao'
               , 1, 'Planejamento'
               , 2, 'Custo'
               , 3, 'Normativo'
               , 4, 'Tecnico')
           uso_receita
       , grt.routing_no roteiro
       , grt.routing_class classe_rout
       , frd.routingstep_no linha
       , gob.oprn_no operacao
       , gor.resources recurso
       , grv.std_qty standart_qty
       , crd.assigned_qty quant_recurso
       , goa.activity atividade
       , gor.process_qty qtd_processo
       , frd.step_qty step_qtd
       , frh.routing_qty qtd_roteiro
       , gor.resource_usage uso_recurso
       , goa.activity_factor fator_atividade
       , DECODE (gor.scale_type
               , 0, 'Fixo'
               , 1, 'Proporcional'
               , 2, 'Por Encargo')
           escala
       , ffm.total_output_qty quant_saida
       , ccm.cost_cmpntcls_code classe_custo
       , DECODE (ccm.product_cost_ind
               , 1, 'INCLUIR NO CALCULO DE CUSTO'
               , 0, 'EXCLUIR NO CALCULO DE CUSTO')
           rec_custeado
    FROM apps.gmd_recipes gr
       , apps.gmd_routings grt
       , apps.fm_form_mst ffm
       , apps.fm_matl_dtl fmd
       , apps.mtl_system_items msi
       , apps.gmd_recipe_validity_rules grv
       , apps.mtl_parameters mp
       , apps.mtl_item_categories_v mic
       , apps.fm_rout_hdr frh
       , apps.gmd_operations_b gob
       , apps.fm_rout_dtl frd
       , apps.gmd_operation_activities goa
       , apps.gmd_operation_resources gor
       , apps.cr_rsrc_dtl crd
       , apps.cm_cmpt_mst ccm
   WHERE ffm.formula_id = gr.formula_id(+)
     AND fmd.formula_id = ffm.formula_id
     AND fmd.line_type = 1                               -- Produto da formula
     AND msi.inventory_item_id = fmd.inventory_item_id
     -------------------------
     AND msi.inventory_item_id = mic.inventory_item_id
     AND msi.organization_id = mic.organization_id
     AND mic.category_set_name = 'Inventory'
     -------------------------
     AND msi.organization_id = fmd.organization_id
     AND grv.recipe_id(+) = gr.recipe_id
     AND grt.routing_id(+) = gr.routing_id
     AND frd.oprn_id = gob.oprn_id
     AND frd.routing_id = grt.routing_id
     ---------
     AND frh.routing_id = grt.routing_id
     ---------
     AND gob.oprn_id = frd.oprn_id
     AND gob.oprn_id = goa.oprn_id
     ---------
     AND frd.oprn_id = goa.oprn_id
     AND frd.routing_id = grt.routing_id
     ---------
     AND gor.oprn_line_id = goa.oprn_line_id
     --------
     AND crd.resources = gor.resources
     -------
     AND gor.cost_cmpntcls_id = ccm.cost_cmpntcls_id
     AND ffm.owner_organization_id = mp.organization_id
     AND ffm.formula_status = 700
     AND grv.validity_rule_status = 700
--  and grv.recipe_use  = 2
--  and msi.segment1  = '543602.79'
ORDER BY frd.routingstep_no