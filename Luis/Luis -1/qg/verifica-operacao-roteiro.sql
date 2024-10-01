

  SELECT gr.recipe_no receita,
         gr.formula_id,
         frh.routing_no,
         oper.ROUTINGSTEP_no
    FROM apps.fm_rout_dtl oper,
         apps.fm_rout_hdr frh,
         apps.gmd_recipes gr
   WHERE frh.routing_id            = gr.routing_id                  AND
         oper.routing_id           = gr.routing_id AND
         gr.owner_organization_id in (181,182) and
         trunc(gr.creation_date) = trunc(sysdate);

select * from MTL_ITEM_CATEGORIES_INTERFACE;

select count(*)
 from XXGMD_STEPMATASSOC_CNV_STG;
 
delete from  XXGMD_STEPMATASSOC_CNV_STG;