select * from apps.fm_matl_dtl;

select * from apps.CM_CMPT_MST_VL;

----- Verifica Custo STD -----
select sum(ccd.CMPNT_COST),
       ccd.COST_ANALYSIS_CODE,
       COST_CMPNTCLS_CODE,
       COST_LEVEL
  from apps.cm_cmpt_dtl ccd,
       apps.CM_CMPT_MST_VL ccm
 where ccd.inventory_item_id = 1462715
   AND ccd.organization_id   = 92
   AND ccd.cost_type_id      = '1005'
      --  AND COST_ANALYSIS_CODE = 'MT'
   AND ccm.COST_CMPNTCLS_ID  = ccd.COST_CMPNTCLS_ID
   AND ccd.period_id         =   (SELECT MAX(cstt.period_id)
                                    FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                   WHERE gps.cost_type_id       = cstt.cost_type_id
                                     AND cstt.period_id         = gps.period_id
                                     AND cstt.delete_mark       = '0'
                                     AND cstt.organization_id   = 92
                                     AND cstt.inventory_item_id = 1462715
                                     AND cstt.cost_type_id      = '1005'
                                     AND cmpnt_cost       <> 0)
        group by ccd.CMPNT_COST,
                 ccd.COST_ANALYSIS_CODE,
                 ccm.COST_CMPNTCLS_CODE,
                 ccd.COST_LEVEL order by 4; 


select * from apps.cm_cmpt_dtl ccd;

----- Verifica Semi x Acabado Ativo (Item, Formula, Receita)
select distinct msi.segment1 item_aca,
       msi.inventory_item_id,
       msis.segment1 item_semi
  from apps.fm_matl_dtl               fd,
       apps.fm_matl_dtl               fds,
       apps.mtl_system_items_b        msi,
       apps.mtl_system_items_b        msis,
       apps.gmd_recipe_validity_rules rv,
       apps.gmd_recipes               gr,
       apps.fm_form_mst               fm
 where msi.organization_id              = 92                    AND
       msi.item_type                 like 'ACA'                 AND
       msi.inventory_item_status_code   = 'Active'              AND
       fd.inventory_item_id             = msi.inventory_item_id AND
       fd.organization_id               = msi.organization_id   AND
       fd.line_type                     = 1                     AND
       fds.formula_id                   = fd.formula_id         AND
       fds.line_type                    = -1                    AND
       msis.organization_id             = msi.organization_id   AND
       msis.inventory_item_id           = fds.inventory_item_id AND
       msis.item_type                  IN ('INT','SEMI')        AND
       rv.recipe_use                    = 0                AND -- 0=Produção  2=Custos
       rv.VALIDITY_RULE_STATUS         IN (700,900)        AND
       gr.recipe_id                     = rv.recipe_id     AND
       gr.recipe_status                IN (700,900)        AND
       fm.formula_id                    = gr.formula_id    AND
       fm.formula_status               in (700,900)        AND
       fm.formula_id                    = fd.formula_id    AND
       msi.inventory_item_id        IN (SELECT MIC.INVENTORY_ITEM_ID
                                          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
                                         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
                                           AND MIC.CATEGORY_SET_ID = 1
                                           AND MIC.SEGMENT1 = 'ACA'
                                           AND MIC.SEGMENT2 = 'AUT')
       order by 1;


--------------------------------------------------------------------------------------

select item.item_aca,
       item.item_semi,
      (select fixed_order_quantity
         from apps.mtl_system_items_b msib
        where msib.segment1 = item.item_semi and
              msib.organization_id = 92) lote,
       sum(ccd.CMPNT_COST),
       ccd.COST_ANALYSIS_CODE,
       COST_CMPNTCLS_CODE,
       COST_LEVEL
  from apps.cm_cmpt_dtl ccd,
       apps.CM_CMPT_MST_VL ccm,
      (select distinct msi.segment1 item_aca,
       msi.inventory_item_id,
       msis.segment1 item_semi
  from apps.fm_matl_dtl               fd,
       apps.fm_matl_dtl               fds,
       apps.mtl_system_items_b        msi,
       apps.mtl_system_items_b        msis,
       apps.gmd_recipe_validity_rules rv,
       apps.gmd_recipes               gr,
       apps.fm_form_mst               fm
 where msi.organization_id              = 92                    AND
       msi.item_type                 like 'ACA'                 AND
       msi.inventory_item_status_code   = 'Active'              AND
       fd.inventory_item_id             = msi.inventory_item_id AND
       fd.organization_id               = msi.organization_id   AND
       fd.line_type                     = 1                     AND
       fds.formula_id                   = fd.formula_id         AND
       fds.line_type                    = -1                    AND
       msis.organization_id             = msi.organization_id   AND
       msis.inventory_item_id           = fds.inventory_item_id AND
       msis.item_type                  IN ('INT','SEMI')        AND
       rv.recipe_use                    = 0                AND -- 0=Produção  2=Custos
       rv.VALIDITY_RULE_STATUS         IN (700,900)        AND
       gr.recipe_id                     = rv.recipe_id     AND
       gr.recipe_status                IN (700,900)        AND
       fm.formula_id                    = gr.formula_id    AND
       fm.formula_status               in (700,900)        AND
       fm.formula_id                    = fd.formula_id    AND
       msi.inventory_item_id        IN (SELECT MIC.INVENTORY_ITEM_ID
                                          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
                                         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
                                           AND MIC.CATEGORY_SET_ID = 1
                                           AND MIC.SEGMENT1 = 'ACA'
                                           AND MIC.SEGMENT2 = 'AUT')
       order by 1) item
 where ccd.inventory_item_id = item.inventory_item_id
   AND ccd.organization_id   = 92
   AND ccd.cost_type_id      = '1005'
      --  AND COST_ANALYSIS_CODE = 'MT'
   AND ccm.COST_CMPNTCLS_ID  = ccd.COST_CMPNTCLS_ID
   AND ccd.period_id         =   (SELECT MAX(cstt.period_id)
                                    FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                   WHERE gps.cost_type_id       = cstt.cost_type_id
                                     AND cstt.period_id         = gps.period_id
                                     AND cstt.delete_mark       = '0'
                                     AND cstt.organization_id   = 92
                                     AND cstt.inventory_item_id = item.inventory_item_id
                                     AND cstt.cost_type_id      = '1005'
                                     AND cmpnt_cost       <> 0)
        group by ccd.CMPNT_COST,
                 ccd.COST_ANALYSIS_CODE,
                 ccm.COST_CMPNTCLS_CODE,
                 ccd.COST_LEVEL, 
                 item.item_aca,
                 item.item_semi 
        order by 1,2,6,4; 

--------------------------------------------------------------------------------------
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