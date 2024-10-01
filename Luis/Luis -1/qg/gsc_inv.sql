SELECT  ood.organization_code orgn_code,         --wm.orgn_code,
                    NULL  whse_code,     --d.whse_code, ood.organization_code
                    NULL  whse_name,    --wm.whse_name, ood.organization_name
                    xxinv_global_sc_extract_pkg.xxinv_get_sbu(msi.organization_id,msi.inventory_item_id,msi.item_type,mp.organization_code,'INV') sbu,
                    msi.segment1  item_no,                    --item_no,
                    msi.inventory_item_id item_id,--d.item_id,
                    msi.item_type inv_type,            --i.inv_type,
                    msi.primary_uom_code item_um,--item_um,
                    msi.description  item_desc,    --item_desc1,
                    msi.inventory_item_id inventory_item_id,
                    msi.organization_id organization_id,
                    msi.planning_make_buy_code planning_make_buy_code,
                    msi.fixed_lead_time fixed_lead_time,
                    msi.full_lead_time full_lead_time,
                    NULL inventory_status,
                    (
                    SELECT  --  mms.status_code
                            decode((mms.RESERVABLE_TYPE + mms.AVAILABILITY_TYPE)
                                  ,2,'Disponivel','Interditado')
                    FROM    mtl_material_statuses  mms
                    WHERE   mln.status_id = mms.status_id
                    )   inventory_status_regional,      --d.lot_status "REGION INV STAT",
                    NULL onhand_kg,   --d.loct_onhand,
                    --mil.inventory_location_id   -- OSM 18/03/2015
                    NULL locator_id,              -- OSM 18/03/2015
                    --mil.segment1||'.'||mil.segment2||'.'||mil.segment3||'.'||mil.segment4||'.'||mil.segment5  -- OSM 18/03/2015
                    NULL location, ---d.location,  -- OSM 18/03/2015
                    mln.lot_number lot_no,        --lm.lot_no,
                    mln.creation_date  lot_creation_date,    --lm.lot_created,
                    mln.expiration_date lot_expiration_date,    --lm.expire_date,
                    NULL cost_currency,
                    pgc.segment1 inv_category_regional,
                    pgc.description inv_category_regional_desc,
                    NULL mto_mts,
                    -- OSM 13/05/2015 Inicio
                   nvl( (
                       SELECT flv_mto.description
                       FROM  mtl_system_items_b msib
                            ,fnd_lookup_values  flv_mto
                       WHERE flv_mto.lookup_type     = 'XXPPG_BR_GSC_MTO'
                       AND   flv_mto.lookup_code     = msi.planner_code
                       AND   flv_mto.language        = 'PTB'
                       AND   msi.inventory_item_id   = msib.inventory_item_id
                       AND   msi.organization_id     = msib.organization_id
                    ),'MTS') mto_mts_regional,
                    nvl((  SELECT flv.description
                       FROM  mtl_system_items_b msib
                            ,fnd_lookup_values  flv
                       WHERE flv.lookup_type       = 'XXPPG_BR_GSC_CONSIGNADO'
                       AND   flv.lookup_code       = msib.planner_code
                       AND   flv.language          = 'PTB'
                       AND   msi.inventory_item_id = msib.inventory_item_id
                       AND   msi.organization_id   = msib.organization_id
                     ),'NO') consignment_indicator,
                     -- OSM 13/05/2015 Fim
                    NULL total_in_process_kg,
                    NULL total_in_process_lit,
                    NULL total_in_process_con,
                    NULL safety_stock_kg,
                    NULL safety_stock_lit,
                    NULL safety_stock_con,
                    NULL mtd_receipts_kg ,
                    NULL mtd_receipts_lit,
                    NULL mtd_receipts_con,
                    NULL std_cost,
                    NULL mtd_cons_sales,
                    NULL fcst_3month_usage_kg,
                    NULL hist_3month_usage,
                    NULL consum_sales_90_days_kg,
                    NULL consum_sales_90_days_lit,
                    NULL consum_sales_90_days_con,
                    NULL lead_time_in_days,
                    NULL storage_address,
                    NULL extract_data_source,
                    NULL date_for_extract_compilation,
                    NULL processed_flag,
                    SYSDATE creation_date,
                    lv_user_id  created_by,            ---lv_user_id "CREATED_BY",
                    SYSDATE last_update_date,
                    lv_user_id   last_updated_by,    --lv_user_id "last_updated_by",
                    lv_request_id request_id  --lv_request_id "REQUEST_ID"
            FROM    (
                        SELECT  flv.meaning segment1,
                                flv.description,
                                icats.inventory_item_id,
                                icats.organization_id
                        FROM     mtl_item_categories icats,
                                 mtl_category_sets_tl mcst,
                                 mtl_category_sets_b mcs,
                                 mtl_categories mcats,
                                 fnd_lookup_values flv
                        WHERE   icats.category_set_id = mcs.category_set_id
                        AND     mcs.structure_id      = mcats.structure_id
                        and     mcs.category_set_id   = mcst.category_set_id
                        and     mcst.language         = 'US' --userenv('LANG')
                        AND     icats.category_id     = mcats.category_id
                        AND     category_set_name     = 'Inventory'
                        AND     flv.lookup_type       = 'XXPPG_BR_GSC_INV_CATEG'
                        AND     flv.lookup_code       = mcats.segment1
                        AND     flv.language          = 'PTB'
                    ) pgc,
                    mtl_system_items_b msi,
                    org_organization_definitions ood, --ic_whse_mst wm,
                    mtl_lot_numbers mln,    --ic_lots_mst lm=
                    mtl_parameters mp
                    --mtl_item_locations mil  -- OSM 18/03/2015
            WHERE    1 = 1
               -- changes for performance.
            AND     msi.inventory_item_id     = pgc.inventory_item_id(+)
            AND     msi.organization_id       = pgc.organization_id(+)
            AND     msi.organization_id       = ood.organization_id     --AND wm.mtl_organization_id = msi.organization_id
            AND        msi.organization_id    = mp.organization_id
            ---------------------------------
            AND     msi.inventory_item_id     = mln.inventory_item_id
            AND     msi.organization_id       = mln.organization_id
            AND     msi.enabled_flag          = 'Y'        --AND i.delete_mark = 0
            AND     msi.costing_enabled_flag  = 'Y' -- OSM 10/03/2015
--            AND     mil.organization_id   (+) = msi.organization_id -- OSM 10/03/2015
--            AND     mil.inventory_item_id (+) = msi.inventory_item_id -- OSM 10/03/2015
            AND    EXISTS(
                        SELECT    'X'
                        FROM    mtl_onhand_quantities_detail moqd
                        WHERE    moqd.transaction_quantity >= 0.005
                        AND     moqd.inventory_item_id     = mln.inventory_item_id
                        AND     moqd.organization_id       = mln.organization_id
                        AND     moqd.lot_number            = mln.lot_number
--                        AND     ( moqd.locator_id          = mil.inventory_location_id   -- OSM 18/03/2015
--                                   OR mil.inventory_location_id IS NULL                  -- OSM 18/03/2015
--                                 )                                                       -- OSM 18/03/2015
                    )
            AND    xxinv_global_sc_extract_pkg.xxinv_check_valid_item(msi.organization_id,msi.inventory_item_id,msi.item_type,'INV') = 'Y'
            AND    mp.process_enabled_flag = 'Y'
            --
            AND EXISTS (SELECT    'X'
                          FROM mtl_item_categories icats,
                               mtl_category_sets   cats,
                               mtl_categories      mcats
                         WHERE icats.category_set_id   = cats.category_set_id
                           AND cats.structure_id       = mcats.structure_id
                           AND icats.category_id       = mcats.category_id
                           AND icats.inventory_item_id = msi.inventory_item_id
                           AND icats.organization_id   = msi.organization_id
                           AND cats.category_set_id    = 1 -- in  'Inventory'
                           AND mcats.segment1         <> 'SEMI'
                        )
            --
            UNION
            SELECT --PUSH_PRED(PGC)
                    ood.organization_code orgn_code, ---wm.orgn_code,
                    ood.organization_code whse_code,  ---wm.whse_code,
                    ood.organization_name  whse_name,  ---wm.whse_name,
                       xxinv_global_sc_extract_pkg.xxinv_get_sbu(msi.organization_id,msi.inventory_item_id,msi.item_type,mp.organization_code,'INV') sbu,
                    msi.segment1  item_no,            --item_no,
                    msi.inventory_item_id item_id,    --i.item_id,
                    msi.item_type inv_type,            --i.inv_type,
                    msi.primary_uom_code item_um,    --item_um,
                    msi.description item_desc,        --item_desc1,
                    msi.inventory_item_id inventory_item_id,
                    msi.organization_id  organization_id,
                    msi.planning_make_buy_code planning_make_buy_code,
                    msi.fixed_lead_time,
                    msi.full_lead_time,
                    NULL inventory_status,
                    NULL inventory_status_regional,
                    NULL onhand_kg,
                    mil.inventory_location_id locator_id ,
                    DECODE( mil.inventory_location_id,NULL,NULL,mil.segment1||'.'||mil.segment2||'.'||mil.segment3||'.'||mil.segment4||'.'||mil.segment5 ) location, ---d.location, location,
                    NULL lot_no,
                    NULL lot_creation_date,
                    NULL lot_expiration_date,
                    NULL cost_currency,
                    pgc.segment1 inv_category_regional,
                    pgc.description inv_category_regional_desc,
                    NULL mto_mts,
                    -- OSM 13/05/2015 Inicio
                    nvl( (
                       SELECT flv_mto.description
                       FROM  mtl_system_items_b msib
                            ,fnd_lookup_values  flv_mto
                       WHERE flv_mto.lookup_type     = 'XXPPG_BR_GSC_MTO'
                       AND   flv_mto.lookup_code     = msi.planner_code
                       AND   flv_mto.language        = 'PTB'
                       AND   msi.inventory_item_id   = msib.inventory_item_id
                       AND   msi.organization_id     = msib.organization_id
                    ),'MTS') mto_mts_regional,
                    nvl((  SELECT flv.description
                       FROM  mtl_system_items_b msib
                            ,fnd_lookup_values  flv
                       WHERE flv.lookup_type       = 'XXPPG_BR_GSC_CONSIGNADO'
                       AND   flv.lookup_code       = msib.planner_code
                       AND   flv.language          = 'PTB'
                       AND   msi.inventory_item_id = msib.inventory_item_id
                       AND   msi.organization_id   = msib.organization_id
                     ),'NO') consignment_indicator,
                     -- OSM 13/05/2015 Fim
                    NULL total_in_process_kg,
                    NULL total_in_process_lit,
                    NULL total_in_process_con,
                    NULL safety_stock_kg,
                    NULL safety_stock_lit,
                    NULL safety_stock_con,
                    NULL mtd_receipts_kg,
                    NULL mtd_receipts_lit,
                    NULL mtd_receipts_con,
                    NULL std_cost,
                    NULL mtd_cons_sales,
                    NULL fcst_3month_usage_kg,
                    NULL hist_3month_usage,
                    NULL consum_sales_90_days_kg,
                    NULL consum_sales_90_days_lit,
                    NULL consum_sales_90_days_con,
                    NULL lead_time_in_days,
                    NULL storage_address,
                    NULL extract_data_source,
                    NULL date_for_extract_compilation,
                    NULL processed_flag,
                    SYSDATE creation_date,
                    lv_user_id created_by,    --lv_user_id "CREATED_BY",
                    SYSDATE LAST_UPDATE_DATE,
                    lv_user_id   LAST_UPDATED_BY, ---lv_user_id "LAST_UPDATED_BY",
                    lv_request_id  REQUEST_ID    --lv_request_id "REQUEST_ID"
            FROM    (
                        SELECT  flv.meaning segment1,
                                flv.description,
                                icats.inventory_item_id,
                                icats.organization_id
                        FROM     mtl_item_categories icats,
                                 mtl_category_sets_tl mcst,
                                 mtl_category_sets_b mcs,
                                 mtl_categories mcats,
                                 fnd_lookup_values flv
                        WHERE   icats.category_set_id = mcs.category_set_id
                        AND     mcs.structure_id      = mcats.structure_id
                        and     mcs.category_set_id   = mcst.category_set_id
                        and     mcst.language         = 'US' --userenv('LANG')
                        AND     icats.category_id     = mcats.category_id
                        AND     category_set_name     = 'Inventory'
                        AND     flv.lookup_type       = 'XXPPG_BR_GSC_INV_CATEG'
                        AND     flv.lookup_code       = mcats.segment1
                        AND     flv.language          = 'PTB'
                    ) pgc,    --AND category_set_name = 'PPG_GL_CLASS') pgc,
                    org_organization_definitions ood, --ic_whse_mst wm,
                    mtl_system_items_b msi,
                    mtl_parameters mp,
                    mtl_item_locations mil
            WHERE   1 = 1
            AND     msi.inventory_item_id = pgc.inventory_item_id(+)
            AND     msi.organization_id = pgc.organization_id(+)
            AND        msi.enabled_flag = 'Y'
            AND     ood.organization_id = msi.organization_id
            AND     msi.organization_id = mp.organization_id
            AND     msi.organization_id = mil.organization_id(+)
            AND     msi.inventory_item_id = mil.inventory_item_id(+)
            AND     xxinv_global_sc_extract_pkg.xxinv_check_valid_item(msi.organization_id,msi.inventory_item_id,msi.item_type,'INV') = 'Y'
            AND     msi.costing_enabled_flag  = 'Y' -- OSM 10/03/2015
            AND     msi.lot_control_code = 1
           AND    mp.process_enabled_flag = 'Y'
            --
            AND EXISTS (SELECT    'X'
                          FROM mtl_item_categories icats,
                               mtl_category_sets   cats,
                               mtl_categories      mcats
                         WHERE icats.category_set_id   = cats.category_set_id
                           AND cats.structure_id       = mcats.structure_id
                           AND icats.category_id       = mcats.category_id
                           AND icats.inventory_item_id = msi.inventory_item_id
                           AND icats.organization_id   = msi.organization_id
                           AND cats.category_set_id    = 1 -- in  'Inventory'
                           AND mcats.segment1         <> 'SEMI'
                        );
