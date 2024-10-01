select * from apps.xxppg_mtl_system_items_b 
 where segment1 = 'CF700R-HS.97';
 

 
select distinct
       mp.organization_code,
       gbh.batch_no,
       gbh.*,
       gbh.ACTUAL_CMPLT_DATE,
       gbh.BATCH_CLOSE_DATE,
       gbs.RESOURCES,
       gbs.PLAN_RSRC_USAGE,
       gbs.ACTUAL_RSRC_QTY,
       gbs.ACTUAL_RSRC_USAGE,
      -- gbh.BATCH_STATUS,
       DECODE(gbh.BATCH_STATUS,4,'Fechada',
                              -1,'Cancelada',
                               1,'Pendente',
                               2,'WIP') STATUS
  from apps.GME_BATCH_STEP_RESOURCES gbs,
       apps.gme_batch_header gbh,
       apps.mtl_parameters   mp
  where --gbs.RESOURCES         = 'PIN-101012' and
        gbs.PLAN_START_DATE  >= sysdate - 137 and 
        (gbs.ACTUAL_RSRC_USAGE > 250 or
         gbs.PLAN_RSRC_USAGE   > 250)        and
        gbh.BATCH_STATUS      > 0            and
        gbh.BATCH_STATUS      < 4            and
        gbs.batch_id          = gbh.batch_id and
        mp.organization_id    = gbh.organization_id;
        
select *
  from apps.gmd_recipes                 gr,
       apps.gmd_recipe_validity_rules   rv
 where gr.recipe_id = rv.recipe_id and
 recipe_validity_rule_id = 999859;
           
 select * from apps.GMD_OPERATION_ACTIVITIES goa;
 select * from apps.FM_ROUT_DTL frd where oprn_no = 'EN-A214 - 2H';
 select * from apps.gmd_operations_vl where oprn_id = 8849;
     
 select recipe_no,
  --gor.*,
        gr.* 
   from apps.GMD_OPERATION_RESOURCES   gor,
        apps.GMD_OPERATION_ACTIVITIES  goa,
        apps.GMD_OPERATIONS_VL         gov,
        apps.FM_ROUT_DTL               frd,
        apps.gmd_recipes               gr,
        apps.gmd_recipe_validity_rules vr   
  where --gor.cost_analysis_code  = 'CC'          and
        scale_type              = 1                 and
    --    resources               = 'PIN-101012'  and
      --  vr.recipe_validity_rule_id = 999859 and
        resource_usage          >= 1                and
        process_qty             <= 1                and
        goa.oprn_line_id         = gor.oprn_line_id and
        gov.oprn_id              = goa.oprn_id      and
        frd.oprn_id              = gov.oprn_id      and
        gr.routing_id            = frd.routing_id   and
        gr.recipe_status         in (700,900)       and
        vr.recipe_id             = gr.recipe_id     and
      --  gr.recipe_version = 11 and
      --  vr.delete_mark           = 0                and   
        --vr.recipe_use            = 2               AND -- 0 = Produção - 2=Custos 
        vr.validity_rule_status  in (700,900)       and 
        vr.recipe_id             = gr.recipe_id     and
        vr.start_date           <= sysdate          and
        vr.end_date             is NULL;
        
        
select *
  from apps.gmd_routings gr
 where gr.routing_id in (13680,
6120,
2956,
35295,
41818,
42590,
44282
)        ;

select *
  from apps.fm_form_mst fm
 where fm.formula_no = 'E6503' and
       fm.formula_vers = 1;
       
select msi.segment1, msi.inventory_item_status_code
  from apps.fm_matl_dtl fmd,
       apps.mtl_system_items_b msi
 where fmd.formula_id = 262410 and
       msi.inventory_item_id = fmd.inventory_item_id and
       msi.organization_id = 92;       