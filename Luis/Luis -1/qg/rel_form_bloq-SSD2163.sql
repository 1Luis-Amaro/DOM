 
--Organização	Receita	Versão da Receita	Status	Descrição	Fórmula	Versão da fórmula	Roteiro	Versão roteiro	Calcular Qtd. Da Etapa	Bloq Impressão Ordem ?	Quantidade de saída total	UDM	UDM da Perda Fixa

                 
 SELECT LV.* --NVL(lv.description,grv.routing_class) --grv.routing_class - FEV-2018 Inclusao lookup XXPPG_CLASSE_ROTEIRO
        FROM gmd_routings_vl      grv,
             fnd_lookup_values_vl lv 
       WHERE 778     = grv.routing_id         AND
             LV.LOOKUP_CODE(+)  = grv.routing_class      AND
             LV.LOOKUP_TYPE(+)  = 'XXPPG_CLASSE_ROTEIRO' AND
             lv.enabled_flag(+) = 'Y'                    AND        
             SYSDATE BETWEEN NVL (lv.start_date_active, SYSDATE) AND
                             NVL (lv.end_date_active, SYSDATE);

select decode (900,700,'Aprovado para Uso Geral',900,'Congelado') from dual;

select * from apps.gmd_recipes gr;
select * from apps.gmd_recipes_b gr;
select * from apps.gmd_recipes_vl gr;
select * from gmd_routings_vl;

select * from apps.fm_form_mst fms;

 SELECT LV.* --NVL(lv.description,grv.routing_class) --grv.routing_class - FEV-2018 Inclusao lookup XXPPG_CLASSE_ROTEIRO
        FROM fnd_lookup_values_vl lv 
       WHERE LV.LOOKUP_TYPE(+)  = 'XXPPG_CLASSE_ROTEIRO' AND
             lv.enabled_flag(+) = 'Y'                    AND        
             SYSDATE BETWEEN NVL (lv.start_date_active, SYSDATE) AND
                             NVL (lv.end_date_active, SYSDATE);


  SELECT 
         mp.organization_code       "Organizacao",
         gr.recipe_no               "Receita",
         gr.recipe_version          "Versao",
         decode(gr.recipe_status,700,'Aprovado para Uso Geral',
                                 900,'Congelado') "Status",
         gr.recipe_description      "Descricao",
         fms.formula_no             "Formula",
         fms.formula_vers           "Vers formula",
         grv.routing_no             "Roteiro",
         grv.routing_vers           "Vers roteiro",
         gr.calculate_step_quantity "Calcular Qtd. Da Etapa",
         fms.yield_uom              "UDM",
         gr.attribute1              "Bloq Impressao",
         fms.total_output_qty,
         routing_class_desc         "Celula",
         msi.segment1               "Item",
         (select max (GBH.batch_no)
            from apps.gme_batch_header gbh
           where gbh.RECIPE_VALIDITY_RULE_ID = VR.RECIPE_VALIDITY_RULE_ID 
             AND (gbh.batch_status = 1
              OR gbh.batch_status = 2)) ordem
    FROM apps.gmd_recipes               gr,
         apps.gmd_recipe_validity_rules vr,
         apps.gmd_routings_vl           grv,
         apps.gmd_routing_class_vl      grcv,
         apps.fm_form_mst               fms,
         apps.fm_matl_dtl               fmd,         
         apps.mtl_system_items_b        msi,
         apps.mtl_parameters            mp
   WHERE vr.delete_mark               = 0                              AND
         vr.recipe_use                = 0 /*Producao*/                 AND --Custos 
      -- vr.validity_rule_status     in (700,900)                      AND
         vr.recipe_id                 = gr.recipe_id                   AND
         vr.start_date               <= sysdate                        AND
         vr.end_date                  is NULL                          AND
         msi.inventory_item_id        = fmd.inventory_item_id          AND
         mp.organization_id           = msi.organization_id            AND
         msi.organization_id          = gr.owner_organization_id       AND
         gr.recipe_status            in (700,900)                      AND
         grcv.routing_class(+)        = grv.routing_class              AND
         grv.routing_id               = gr.routing_id                  AND
         fms.formula_id               = gr.formula_id                  AND
         fmd.line_type                = 1                              AND
         fmd.formula_id               = fms.formula_id                 AND
         NVL(gr.attribute1,'N') = 'S'
ORDER BY recipe_no;

select * from gme_batch_header WHERE batch_no = 19461 and organization_id = 92;
select * from gme_batch_step_items;

select * from gmd_recipes;

select * from fm_rout_hdr;