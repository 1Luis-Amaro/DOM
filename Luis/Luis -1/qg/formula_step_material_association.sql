
select recipe_id,
       recipe_no,
       recipe_version,
       gr.routing_id,
       gr.owner_organization_id,
       (select count(*) 
          from apps.gmd_recipe_step_materials grs
         where grs.recipe_id = gr.recipe_id) nf_step,
       (select count(*)
         from apps.fm_matl_dtl fd
        where fd.formula_id = gr.formula_id)  nr_ing      
  from apps.gmd_recipes gr
 where --gr.formula_id = 4757 and
        (select count(*) 
          from apps.gmd_recipe_step_materials grs
         where grs.recipe_id = gr.recipe_id) <>
       (select count(*)
         from apps.fm_matl_dtl fd
        where fd.formula_id = gr.formula_id) and
        (select count(*) 
          from apps.gmd_recipe_step_materials grs
         where grs.recipe_id = gr.recipe_id)  <> 0 and
        gr.recipe_status in (700, 900) and
        gr.owner_organization_id = 92;     

select * from apps.gmd_recipes gr;
SELECT * from apps.gmd_recipe_step_materials;
select *
  from appg.gmd_form_mst gfm
 where gf
 where 
select * 
  from apps.gmd_recipe_step_materials grs
 where -- grs.recipe_id = 4754 and
       grs.routingstep_id is null;