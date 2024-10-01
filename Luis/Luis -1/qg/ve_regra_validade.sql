select gr.recipe_no,
       gr.recipe_version,
       msi.segment1,
       fm.formula_no,
       fm.formula_vers,
       rv.orgn_code,
       decode(gr.recipe_status,700,'Aprovado para Uso Geral',900,'Congelado') "Status Receita",
       decode(fm.formula_status,700,'Aprovado para Uso Geral',900,'Congelado') "Status Formula",
       decode(rv.VALIDITY_RULE_STATUS,700,'Aprovado para Uso Geral',900,'Congelado') "Status Regra Validade",
       rv.start_date,
       rv.end_date,
       rv.min_qty,
       rv.max_qty,
       rv.std_qty,
       frh.routing_no,
       frh.routing_class
  from apps.gmd_recipe_validity_rules rv,
       apps.gmd_recipes               gr,
       apps.fm_rout_hdr               frh,
       apps.fm_form_mst               fm,
       apps.mtl_system_items_b        msi
 where gr.OWNER_ORGANIZATION_ID = 181            and
       rv.recipe_use            = 0                and -- 0=Produção  2=Custos
       rv.VALIDITY_RULE_STATUS in (700,900)        and
       gr.recipe_id             = rv.recipe_id     and
       gr.recipe_status        in (700,900)        and
       frh.routing_id           = gr.routing_id    and
       fm.formula_id            = gr.formula_id    and
       fm.formula_status       in (700,900)        and
       msi.inventory_item_id    = rv.inventory_item_id and
       msi.organization_id      = gr.owner_organization_id;