select gr.recipe_no,
       gr.recipe_version,
       gr.recipe_description,
       fms.formula_no,
       fms.formula_vers,
       msi.segment1,
       fmd.line_no,
       fmd.qty,
       gr.ATTRIBUTE3 Codigo_Cor,
       gr.ATTRIBUTE4 Descricao_cor,
       gr.ATTRIBUTE5
  from apps.gmd_recipes        gr,
      apps.fm_matl_dtl         fmd,
      apps.fm_form_mst_b       fms,
      apps.mtl_system_items_b msi      
 where (gr.recipe_no like '2040001L.01%' or
        gr.recipe_no like '2040003L.01%' or
        gr.recipe_no like '2040001L.20%' or
        gr.recipe_no like '2040003L.20%' or
        gr.recipe_no like '2380001L.20%' or
        gr.recipe_no like '5500001L.01%' or
        gr.recipe_no like '2380003L.20%' or
        gr.recipe_no like '2380001L.20%' or
        gr.recipe_no like '1490001L.20%' or
        gr.recipe_no like '1490003L.20%' or
        gr.recipe_no like '3180001L.20%' or
        gr.recipe_no like '3180003L.20%' or
        gr.recipe_no like '1540001L.20' or
        gr.recipe_no like '1540003L.20')
   and gr.OWNER_ORGANIZATION_ID = 92
   and gr.recipe_status            in (700,900)
   and exists(select 1
                from apps.gmd_recipe_validity_rules vr
               where vr.recipe_id             = gr.recipe_id    AND
                     vr.delete_mark           = 0               AND   
                     vr.recipe_use            = 0               AND -- 0 = Produção - 2=Custos 
                     vr.validity_rule_status in (700,900)       AND 
                     vr.recipe_id             = gr.recipe_id    AND
                     vr.start_date           <= sysdate         AND
                     vr.end_date             is NULL)
   AND fmd.formula_id        = gr.formula_id
   AND fmd.line_type         = -1
   AND fms.formula_id        = gr.formula_id
   and msi.inventory_item_id = fmd.inventory_item_id
   and msi.organization_id   = 92
   and fms.formula_status in (700,900)
   and fms.FORMULA_CLASS     = 'TING-PMC';


select * from apps.fm_form_mst_b fms;

select * 
  from apps.fm_matl_dtl fmd
 where fmd.linte_type = 1 and
       fmd;