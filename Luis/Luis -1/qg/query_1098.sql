
--- Regra de validade --- Extação custos e planejamento ----
select (select mic.segment2
          from apps.mtl_item_categories_v mic
         where mic.category_set_id = 1 and
               mic.inventory_item_id = msi.inventory_item_id and
               mic.organization_id   = 87)  "BU",
       mp.organization_code                 "ORG",
       msi.segment1                         "PRODUTO",
       msi.item_type                        "TIPO ITEM",
       recipe_no                            "RECEITA",
       recipe_version                       "VERSAO RECEITA",
       decode(gr.recipe_status,100, 'NEW',
                               400, 'Aprovado em Laboratorio',
                               700, 'Aprovado Uso Geral',
                               800, 'Em Retencao',
                               900, 'Congelado',
                               1000,'Obsoleto') "STATUS RECEITA",
       fm.formula_no                        "FORMULA",
       fm.formula_vers                      "VERSAO FORMUA",
       decode(fm.formula_status,100, 'NEW',
                                400, 'Aprovado em Laboratorio',
                                700, 'Aprovado Uso Geral',
                                800, 'Em Retencao',
                                900, 'Congelado',
                                1000,'Obsoleto') "STATUS FORMULA",
       rout.routing_no                      "ROTEIRO",
       decode(vr1.recipe_use,2,'Custos',0,'Producao') "USO RECEITA",
       decode(validity_rule_status,100, 'NEW',
                                   400, 'Aprovado em Laboratorio',
                                   700, 'Aprovado Uso Geral',
                                   800, 'Em Retencao',
                                   900, 'Congelado',
                                   1000,'Obsoleto') "STATUS REGRA",
       msi.primary_uom_code                 "UDM",
       vr1.planned_process_loss             "PERDA PLANEJADA",
       vr1.preference                       "PREFERENCIA",
       vr1.start_date                       "DATA INICIAL",
       vr1.end_date                         "DATA FINAL",
       vr1.min_qty                          "QTD MINIMA",
       vr1.max_qty                          "QTD MAXIMA",
       vr1.std_qty                          "QTD STD",
       rout.routing_class                   "CLASSE ROTEIRO"
  from apps.gmd_recipes gr,
       apps.gmd_recipe_validity_rules vr1,
       apps.fm_form_mst fm,
       apps.mtl_system_items_b msi,
       apps.mtl_parameters mp,
       apps.gmd_routings rout
 where gr.OWNER_ORGANIZATION_ID = 92                       AND
       vr1.recipe_id            = gr.recipe_id             AND
       fm.formula_id            = gr.formula_id            AND
       msi.organization_id      = gr.OWNER_ORGANIZATION_ID AND
       msi.inventory_item_id    = vr1.inventory_item_id    AND
       mp.organization_id       = msi.organization_id      AND
       rout.routing_id          = gr.routing_id;
