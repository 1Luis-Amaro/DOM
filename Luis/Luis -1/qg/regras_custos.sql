select recipe_no,
       recipe_version,
       decode(recipe_status,700,'Aprovado Uso Geral',900,'Congelado') "Status Receita",
       mp.organization_code,
       min_qty,
       max_qty,
       std_qty,
       decode(VALIDITY_RULE_STATUS,700,'Aprovado Uso Geral',900,'Congelado') "Status Regra Validade",
       vr.PLANNED_PROCESS_LOSS,
       msi.segment1 Produto,
       rt.routing_no,
       rt.routing_class  
  from apps.gmd_recipes_b             gr,
       apps.gmd_recipe_validity_rules vr,
       apps.mtl_system_items_b        msi,
       apps.mtl_parameters            mp,
       apps.gmd_routings              rt
 where vr.recipe_use                  = 2               AND -- 0 = Produção - 2=Custos 
       vr.validity_rule_status       in (700,900)       AND 
       vr.recipe_id                   = gr.recipe_id    AND
       vr.start_date                 <= sysdate         AND
       vr.end_date                   is NULL            AND
       msi.inventory_item_id          = vr.inventory_item_id AND
       msi.organization_id            = gr.OWNER_ORGANIZATION_ID AND
       mp.organization_id             = msi.organization_id      and
       rt.routing_id                  = gr.routing_id;
       
select * from apps.gmd_routings;       