select gbh.batch_no
from   gme_batch_groups_association gba,
       gme_batch_groups_b gbg,
       gme_batch_header gbh
where gbg.group_id = gba.group_id
and     gba.batch_id = gbh.batch_id
and     gbg.group_name = '3'


select * from
       gme_batch_groups_association gba,
       gme_batch_groups_b gbg,
       gme_batch_header gbh,
       gme_batch_groups_association gba2,
       gme_batch_header gbh2
       
where  gbh.batch_no = 3
and    gbg.group_id = gba.group_id
and    gba.batch_id = gbh.batch_id
and    gba2.group_id = gba.group_id
and    gbh2.batch_id = gba2.batch_id

select * from gme_batch_header;
select * from gme_batch_groups_b;
select * from gme_material_details gmd;
select * from gmd_recipe_validity_rules;
select * from fm_form_mst;
SELECT mp.organization_code,
       gbh.batch_type,
       gbh.batch_no, 
       gbh.batch_status,
       gbg.group_name,
       gbh.firmed_ind,
       msi.segment1,
       msi.description,
       inv.categoria,
       gmd.plan_qty,
       gmd.actual_qty,
       gmd.plan_qty - gmd.actual_qty "Saldo",
       l_cst,
       NVL(lv.description,grvl.routing_class),
       msi.primary_uom_code,
       gbh.plan_start_date,
       gbh.plan_cmplt_date,
       gbh.actual_start_date,
       gbh.actual_cmplt_date,
       fm.formula_no,
       fm.formula_vers,
       gr.recipe_no,
       gr.recipe_version,
       rh.routing_no,
       rh.routing_vers
  FROM gme_batch_header             gbh,
       gme_material_details         gmd,
       mtl_system_items_b           msi,
       mtl_parameters               mp,
       gme_batch_groups_association gba,
       gme_batch_groups_b           gbg,
       gmd_recipes                  gr,
       gmd_recipe_validity_rules    grv,
       fm_form_mst                  fm,
       fm_rout_hdr                  rh,
       gmd_routings_vl              grvl,
       fnd_lookup_values_vl         lv,
       (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_id = 1) inv
  WHERE gbh.organization_id         = 92                          AND
        gbh.batch_no                = 12345                       AND
        gmd.batch_id                = gbh.batch_id                AND
        gmd.line_type               = 1                           AND
        gba.batch_id                = gbh.batch_id                AND
        gbg.group_id                = gba.group_id                AND
        grv.recipe_validity_rule_id = gbh.recipe_validity_rule_id AND
        gr.recipe_id                = grv.recipe_id               AND
        fm.formula_id               = gbh.formula_id              AND
        rh.routing_id               = gbh.routing_id              AND
        grvl.routing_id             = rh.routing_id               AND
        LV.LOOKUP_CODE(+)           = grvl.routing_class          AND
        LV.LOOKUP_TYPE(+)           = 'XXPPG_CLASSE_ROTEIRO'      AND
        lv.enabled_flag(+)          = 'Y'                         AND        
        SYSDATE BETWEEN NVL (lv.start_date_active, SYSDATE)       AND
                        NVL (lv.end_date_active, SYSDATE)         AND        
        msi.organization_id         = gbh.organization_id         AND
        msi.inventory_item_id       = gmd.inventory_item_id       AND
        mp.organization_id          = msi.organization_id         AND
        inv.organization_id         = msi.organization_id         AND
        inv.inventory_item_id       = msi.inventory_item_id; 
       
       
select * from gme_batch_header             gbh;       

                 SELECT MIC.INVENTORY_ITEM_ID,
                        MIC.SEGMENT2,
                        MIC.ORGANIZATION_ID,
                        MIC.CATEGORY_SET_NAME,
                        MIC.CATEGORY_CONCAT_SEGS CATEGORIA
                   FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
                  WHERE MC.CATEGORY_ID      = MIC.CATEGORY_ID AND
                        MIC.CATEGORY_SET_id = 1

select to_date(substr(NVL('01-04-2018',to_char(trunc(sysdate - 1),'yyyy/mm/dd')),1,10)) from dual;

select to_date(substr('2018-04-01 10:15:15',1,10),'rrrr/mm/dd') from dual;

select to_date('2018-04-01','') from dual;

'Org.'
'Tipo'
'Documento'
'Status'
'Grupo'
'Firmado'
'Produto'
'Descrição do Produto'
'Categoria Inventário'
'Quantidade Planejada'
'Quantidade Real'
'Saldo UN/kg'
'Custo STD'
'Saldo STD'
'CLASSE ROTEIRO'
'UN'
'Data Inicial Planejada'
'Data de Conclusão Planejada'
'Data Inicial Real'
'Data de Conclusão Real'
'Versão da Fórmula'
'Fórmula'
'Versão da Receita'
'Receita'
'Roteiro'
'Versão do Roteiro'

