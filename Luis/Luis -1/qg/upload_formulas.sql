select * from gmd_recipes where recipe_no = '5500003L.01/ALUMINIO RAL 9006'

select * from XXPPG_FORMULA_STG;
select * from XXGMD_RECIPE_HDR_CNV_STG where STG_PROCESS_STATUS <> 'P';
select * from XXGMD_RECIPE_VR_STG;
select * from XXGMD_STEPMATASSOC_CNV_STG;

SELECT * FROM DBA_objects where object_name like '%XX%FORMULA%' AND object_type = 'TABLE'

select * from XXPPG_FORMULA_STG;            --
select * from XXPPG_GMD_RESULT_FORMULA_TMP; 
select * from XXPPG_EXPLODE_FORMULA;
select * from XXGMD_FORMULA_HOLD_TABLE;
select * from XXGMD_FORMULA_HOLD_TABLE_ARC;
select * from XXGMD_FORMULA_IMPORT_STG_TAB;

xxppg_formula_pkg

select * from gmd_recipes;