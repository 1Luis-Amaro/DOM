delete from XXPPG_FORMULA_STG;

select * from XXPPG_FORMULA_STG where STG_PROCESS_STATUS <> 'P';

select organization_id, segment1, shelf_life_code from mtl_system_items_b where ORGANIZATION_ID > 180 and shelf_life_code = 2

delete from XXGMD_RECIPE_HDR_CNV_STG;

delete from XXGMD_RECIPE_VR_STG