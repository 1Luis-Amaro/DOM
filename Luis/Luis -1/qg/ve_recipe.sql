           select grb.recipe_id
                 ,grb.recipe_no
                 ,grb.recipe_version
                 ,ffmb.formula_id
                 ,fmd.qty
                 ,fmd.scale_type
                 ,fmd.organization_id
                 ,fmd.inventory_item_id
                 ,decode(instr(grb.recipe_no,'/'),0,grb.recipe_no,substr(grb.recipe_no,1,instr(grb.recipe_no,'/')-1)) item
                 ,fmd.line_no
             from fm_form_mst_b ffmb
                 ,gmd_recipes_b grb
                 ,(select max(recipe_id) recipe_id
                         ,max(recipe_version) recipe_version
                         ,decode(instr(recipe_no,'/'),0,recipe_no,substr(recipe_no,1,instr(recipe_no,'/')-1)) item
                     from gmd_recipes_b
                     group by decode(instr(recipe_no,'/'),0,recipe_no,substr(recipe_no,1,instr(recipe_no,'/')-1))
                              ) tab_grb
                 ,fm_matl_dtl   fmd
            where grb.formula_id = ffmb.formula_id
              and fmd.formula_id = ffmb.formula_id
              and fmd.line_type  = -1
              --
              and tab_grb.recipe_id = grb.recipe_id
              --
              and ffmb.formula_status in(700,900)
              --
              and grb.recipe_no like 'PPG9201-809A%'
              --and decode(instr(grb.recipe_no,'/'),0,grb.recipe_no,substr(grb.recipe_no,1,instr(grb.recipe_no,'/')-1)) = 'PPG9201-809A'
