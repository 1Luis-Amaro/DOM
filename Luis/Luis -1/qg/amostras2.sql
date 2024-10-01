
                         SELECT DISTINCT 
                                mln.lot_number,
                                msi.segment1,
                                gs.sample_no,
                                to_char(trunc(gs.date_drawn),'dd/mm/yyyy') date_drawn,
                                gs.source,
                                mln.origination_date,
                                gbh.batch_no,
                                flv.meaning disposition_no,
                                GS.SAMPLING_EVENT_ID SAMPLING_EVENT_ID
                           FROM apps.gmd_recipes                      gr,
                                apps.gme_batch_header                 gbh,
                                apps.gme_material_details             gmd,
                                apps.gmd_recipe_validity_rules        vr,
                                apps.mtl_transaction_lot_numbers mtln,
                                apps.mtl_material_transactions   mmt,
                                apps.mtl_lot_numbers                  mln,
                                apps.mtl_system_items_b               msi,
                                apps.mtl_system_items_b               msis,
                                apps.GME_BATCH_HEADER                 gbhs,
                                apps.GMD_SAMPLES                      gs,
                                apps.GMD_SAMPLE_SPEC_DISP             gssd,
                                apps.GMD_SAMPLING_EVENTS              GSE,
                                apps.GMD_SPECIFICATIONS               GSF,
                                apps.GMD_ALL_SPEC_VRS                 GASV, 
                                apps.GME_BATCH_GROUPS_ASSOCIATION     gbga,
                                apps.GME_BATCH_GROUPS_B               gbgb,
                                apps.GME_BATCH_GROUPS_ASSOCIATION     gbgas,
                                apps.fnd_lookup_values                flv
                          WHERE mtln.lot_number                 = mln.LOT_NUMBER              AND
                                mtln.inventory_item_id          = MSI.INVENTORY_ITEM_ID       AND
                                mtln.TRANSACTION_SOURCE_TYPE_ID = 5  /*Producao*/             AND  
                                mmt.transaction_type_id         = 44 /* Wip Completion*/      AND 
                                mmt.transaction_id              = mtln.transaction_id         AND
                                GASV.SPEC_VR_ID                 = GSE.ORIGINAL_SPEC_VR_ID    and
                                GASV.SPEC_ID                    = GSF.SPEC_ID                 and
                                GSE.SAMPLING_EVENT_ID           = GS.SAMPLING_EVENT_ID        and                         
                                gbh.batch_id                    = mmt.TRANSACTION_SOURCE_ID   AND
                                vr.recipe_validity_rule_id      = gbh.recipe_validity_rule_id AND
                                gr.recipe_id                    = vr.recipe_id                AND
                                --msi.inventory_item_id           = 'D800'                   AND
                                msi.organization_id             = 92                    AND
                                mln.inventory_item_id           = msi.inventory_item_id       AND
                                gbga.batch_id                   = gbh.batch_id                AND
                                gbgb.group_id                   = gbga.group_id               AND
                                gbgas.group_id                  = gbga.group_id               AND
                                gbhs.batch_id                   = gbgas.batch_id              AND
                                gbgas.batch_id                  = gs.batch_id                 AND
                                gs.sample_id                    = gssd.sample_id (+)          AND
                                gmd.batch_id                    = gbhs.batch_id               AND
                                gmd.line_type                   = 1                           AND
                                msis.inventory_item_id          = gmd.inventory_item_id       AND
                                msis.organization_id            = gmd.organization_id         AND
                                FLV.lookup_code                 = gssd.disposition            AND
                                FLV.lookup_type                 = 'GMD_QC_SAMPLE_DISP'        AND
                                FLV.LANGUAGE                    = 'PTB'                       AND
                                ((msi.item_type   = 'ACA'                                     AND 
                                  msis.item_type  = 'SEMI') OR
                                  msi.item_type <> 'ACA')                                     AND
                                gssd.delete_mark                = 0                           AND
                                gssd.disposition               IN ('4A', '5AV', '6RJ')
                               ORDER BY mln.origination_date desc;
                               
select * from apps.GMD_SPECIFICATIONS               GSF;

select * from apps.GMD_SAMPLE_SPEC_DISP;                               




SELECT GS.SAMPLE_NO
       ,GSF.SPEC_NAME || ' - ' ||  GS.SAMPLE_DESC  DESPEC
       ,GR.SEQ
       ,GST.PRINT_RESULT_IND
       ,NVL(GST.TEST_DISPLAY, GQT.TEST_CODE)  ETESTS
       ,GTM.TEST_METHOD_CODE            METOD
       ,NVL ( DECODE( GSR.ADDITIONAL_TEST_IND, 'Y',NULL, GST.TARGET_VALUE_CHAR ) ,'-')        E_COL1    -- TARGET
       ,NVL ( DECODE( GSR.ADDITIONAL_TEST_IND, 'Y',NULL, DECODE (GQT.TEST_TYPE, 'T' , GST.MIN_VALUE_CHAR ,  NVL( LTRIM(TO_CHAR( NVL( GST.MIN_VALUE_NUM, GQT.MIN_VALUE_NUM ),'999999999999990D'||TO_CHAR(power(10, NVL(GST.DISPLAY_PRECISION,  NVL(GQT.DISPLAY_PRECISION , GTM.DISPLAY_PRECISION))   )-1))) , GST.MIN_VALUE_CHAR ))  ) , '-' ) E_COL2    -- MIN VALUE
       ,NVL ( DECODE( GSR.ADDITIONAL_TEST_IND, 'Y',NULL, DECODE (GQT.TEST_TYPE, 'T' , GST.MAX_VALUE_CHAR ,  NVL( LTRIM(TO_CHAR( NVL( GST.MAX_VALUE_NUM, GQT.MAX_VALUE_NUM ),'999999999999990D'||TO_CHAR(power(10, NVL(GST.DISPLAY_PRECISION,  NVL(GQT.DISPLAY_PRECISION , GTM.DISPLAY_PRECISION))   )-1))) , GST.MAX_VALUE_CHAR ))  ) , '-' ) E_COL3    -- MAX VALUE
       ,NVL( LTRIM(TO_CHAR( GR.RESULT_VALUE_NUM,'999999999999990D'||TO_CHAR(power(10, NVL(GST.DISPLAY_PRECISION,  NVL(GQT.DISPLAY_PRECISION , GTM.DISPLAY_PRECISION))  )-1))) , NVL( TO_CHAR( TARGET_VALUE_NUM) , TARGET_VALUE_CHAR))      RVALNUM
       ,DECODE (GQT.TEST_TYPE, 'T' , GR.RESULT_VALUE_CHAR , NVL( LTRIM(TO_CHAR( GR.RESULT_VALUE_NUM,'999999999999990D'||TO_CHAR(power(10, NVL(GST.DISPLAY_PRECISION,  NVL(GQT.DISPLAY_PRECISION , GTM.DISPLAY_PRECISION))  )-1))) ,GR.RESULT_VALUE_CHAR) ) RESULT
       ,REPLACE(GQT.TEST_UNIT,'?','3')  TUNIT
       ,GR.TEST_REPLICATE_CNT           REPLI
       ,GST.TEST_PRIORITY               PRIORI
       ,NULL                            RVALID
    FROM apps.GMD_SAMPLES                   GS
       , apps.GMD_RESULTS                   GR
       , apps.GMD_QC_TESTS                  GQT
       , apps.GMD_TEST_METHODS              GTM
       , apps.GMD_SAMPLING_EVENTS           GSE
       , apps.GMD_SPECIFICATIONS            GSF
       , apps.GMD_ALL_SPEC_VRS              GASV
       , apps.GMD_SPEC_TESTS                GST
       , apps.GMD_SAMPLE_SPEC_DISP          GSSD
       , apps.GMD_SPEC_RESULTS              GSR
   WHERE GR.TEST_ID         = GQT.TEST_ID
     AND GR.TEST_METHOD_ID  = GTM.TEST_METHOD_ID
     AND GASV.SPEC_VR_ID    = GSE.ORIGINAL_SPEC_VR_ID
     AND GASV.SPEC_ID       = GSF.SPEC_ID
     AND GSF.SPEC_ID        = GST.SPEC_ID
     AND GST.TEST_ID        = GQT.TEST_ID
     AND GST.TEST_METHOD_ID = GTM.TEST_METHOD_ID
     AND GS.SAMPLE_ID       = GR.SAMPLE_ID
     AND GS.SAMPLE_ID       = GSSD.SAMPLE_ID
     AND GS.SAMPLING_EVENT_ID = GSE.SAMPLING_EVENT_ID
     AND GR.DELETE_MARK     = 0
     AND GS.DELETE_MARK     = 0
     AND GSSD.DISPOSITION IN ('4A', '5AV')
     AND NVL(GST.PRINT_RESULT_IND,'N')  = 'Y'
     AND GSSD.EVENT_SPEC_DISP_ID = GSR.EVENT_SPEC_DISP_ID
     AND GR.RESULT_ID = GSR.RESULT_ID
     --AND GS.SAMPLE_ID =  v_SAMPLE_ID
    ORDER BY GR.SEQ;



                         SELECT DISTINCT 
                                mln.lot_number,
                                msi.segment1,
                                gs.sample_no,
                                gs.SAMPLE_ID,
                                to_char(trunc(gs.date_drawn),'dd/mm/yyyy') date_drawn,
                                gs.source,
                                mln.origination_date,
                                gbh.batch_no,
                                gbh.organization_id,
                                flv.meaning disposition_no,
                                GS.SAMPLING_EVENT_ID SAMPLING_EVENT_ID
                           FROM apps.gmd_recipes                      gr,
                                apps.gme_batch_header                 gbh,
                                apps.gme_material_details             gmd,
                                apps.gmd_recipe_validity_rules        vr,
                                apps.mtl_transaction_lot_numbers      mtln,
                                apps.mtl_material_transactions        mmt,
                                apps.mtl_lot_numbers                  mln,
                                apps.mtl_system_items_b               msi,
                                apps.mtl_system_items_b               msis,
                                apps.GME_BATCH_HEADER                 gbhs,
                                apps.GMD_SAMPLES                      gs,
                                apps.GMD_SAMPLE_SPEC_DISP             gssd,
                                apps.GME_BATCH_GROUPS_ASSOCIATION     gbga,
                                apps.GME_BATCH_GROUPS_B               gbgb,
                                apps.GME_BATCH_GROUPS_ASSOCIATION     gbgas,
                                apps.fnd_lookup_values                flv
                          WHERE mtln.lot_number                 = mln.LOT_NUMBER              AND
                                mtln.inventory_item_id          = MSI.INVENTORY_ITEM_ID       AND
                                mtln.TRANSACTION_SOURCE_TYPE_ID = 5  /*Producao*/             AND  
                                mmt.transaction_type_id         = 44 /* Wip Completion*/      AND 
                                mmt.transaction_id              = mtln.transaction_id         AND
                                gbh.ACTUAL_CMPLT_DATE          >= to_date ('01/jan/2024')     and
                                gbh.batch_id                    = mmt.TRANSACTION_SOURCE_ID   AND
                                vr.recipe_validity_rule_id      = gbh.recipe_validity_rule_id AND
                                gr.recipe_id                    = vr.recipe_id                AND
                                --msi.inventory_item_id           = 'D800'                   AND
                                msi.organization_id             = 92                    AND
                                gbh.organization_id             = 92                    AND
                                gbhs.organization_id             = 92                    AND
                                mmt.organization_id             = 92                    AND
                                mln.inventory_item_id           = msi.inventory_item_id       AND
                                gbga.batch_id                   = gbh.batch_id                AND
                                gbgb.group_id                   = gbga.group_id               AND
                                gbgas.group_id                  = gbga.group_id               AND
                                gbhs.batch_id                   = gbgas.batch_id              AND
                                gbgas.batch_id                  = gs.batch_id                 AND
                                gs.sample_id                    = gssd.sample_id (+)          AND
                                gmd.batch_id                    = gbhs.batch_id               AND
                                gmd.line_type                   = 1                           AND
                                msis.inventory_item_id          = gmd.inventory_item_id       AND
                                msis.organization_id            = gmd.organization_id         AND
                                FLV.lookup_code                 = gssd.disposition            AND
                                FLV.lookup_type                 = 'GMD_QC_SAMPLE_DISP'        AND
                                FLV.LANGUAGE                    = 'PTB'                       AND
                                ((msi.item_type   = 'ACA'                                     AND 
                                  msis.item_type  = 'SEMI') OR
                                  msi.item_type <> 'ACA')                                     AND
                                gssd.delete_mark                = 0                           AND
                                gssd.disposition               IN ('4A', '5AV', '6RJ')
                               ORDER BY mln.origination_date desc;
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
                               
select * from apps.GMD_SAMPLES                   GS where LAST_UPDATE_DATE >= sysdate - 250; 
select * from apps.GMD_SAMPLE_SPEC_DISP          GSSD;    
select * from apps.GMD_SAMPLING_EVENTS           GSE;                
                               
                               
SELECT GS.SAMPLE_NO
       ,GSF.SPEC_NAME || ' - ' ||  GS.SAMPLE_DESC  DESPEC
       ,GR.SEQ
       ,GST.PRINT_RESULT_IND
       ,NVL(GST.TEST_DISPLAY, GQT.TEST_CODE)  ETESTS
       ,GTM.TEST_METHOD_CODE            METOD
       ,NVL ( DECODE( GSR.ADDITIONAL_TEST_IND, 'Y',NULL, GST.TARGET_VALUE_CHAR ) ,'-')        E_COL1    -- TARGET
       ,NVL ( DECODE( GSR.ADDITIONAL_TEST_IND, 'Y',NULL, DECODE (GQT.TEST_TYPE, 'T' , GST.MIN_VALUE_CHAR ,  NVL( LTRIM(TO_CHAR( NVL( GST.MIN_VALUE_NUM, GQT.MIN_VALUE_NUM ),'999999999999990D'||TO_CHAR(power(10, NVL(GST.DISPLAY_PRECISION,  NVL(GQT.DISPLAY_PRECISION , GTM.DISPLAY_PRECISION))   )-1))) , GST.MIN_VALUE_CHAR ))  ) , '-' ) E_COL2    -- MIN VALUE
       ,NVL ( DECODE( GSR.ADDITIONAL_TEST_IND, 'Y',NULL, DECODE (GQT.TEST_TYPE, 'T' , GST.MAX_VALUE_CHAR ,  NVL( LTRIM(TO_CHAR( NVL( GST.MAX_VALUE_NUM, GQT.MAX_VALUE_NUM ),'999999999999990D'||TO_CHAR(power(10, NVL(GST.DISPLAY_PRECISION,  NVL(GQT.DISPLAY_PRECISION , GTM.DISPLAY_PRECISION))   )-1))) , GST.MAX_VALUE_CHAR ))  ) , '-' ) E_COL3    -- MAX VALUE
       ,NVL( LTRIM(TO_CHAR( GR.RESULT_VALUE_NUM,'999999999999990D'||TO_CHAR(power(10, NVL(GST.DISPLAY_PRECISION,  NVL(GQT.DISPLAY_PRECISION , GTM.DISPLAY_PRECISION))  )-1))) , NVL( TO_CHAR( TARGET_VALUE_NUM) , TARGET_VALUE_CHAR))      RVALNUM
       ,DECODE (GQT.TEST_TYPE, 'T' , GR.RESULT_VALUE_CHAR , NVL( LTRIM(TO_CHAR( GR.RESULT_VALUE_NUM,'999999999999990D'||TO_CHAR(power(10, NVL(GST.DISPLAY_PRECISION,  NVL(GQT.DISPLAY_PRECISION , GTM.DISPLAY_PRECISION))  )-1))) ,GR.RESULT_VALUE_CHAR) ) RESULT
       ,REPLACE(GQT.TEST_UNIT,'?','3')  TUNIT
       ,GR.TEST_REPLICATE_CNT           REPLI
       ,GST.TEST_PRIORITY               PRIORI
       ,NULL                            RVALID
    FROM apps.GMD_SAMPLES                   GS
       , apps.GMD_RESULTS                   GR
       , apps.GMD_QC_TESTS                  GQT
       , apps.GMD_TEST_METHODS              GTM
       , apps.GMD_SAMPLING_EVENTS           GSE
       , apps.GMD_SPECIFICATIONS            GSF
       , apps.GMD_ALL_SPEC_VRS              GASV
       , apps.GMD_SPEC_TESTS                GST
       , apps.GMD_SAMPLE_SPEC_DISP          GSSD
       , apps.GMD_SPEC_RESULTS              GSR
   WHERE GR.TEST_ID         = GQT.TEST_ID
     AND GR.TEST_METHOD_ID  = GTM.TEST_METHOD_ID
     AND GASV.SPEC_VR_ID    = GSE.ORIGINAL_SPEC_VR_ID
     AND GASV.SPEC_ID       = GSF.SPEC_ID
     AND GSF.SPEC_ID        = GST.SPEC_ID
     AND GST.TEST_ID        = GQT.TEST_ID
     AND GST.TEST_METHOD_ID = GTM.TEST_METHOD_ID
     AND GS.SAMPLE_ID       = GR.SAMPLE_ID
     AND GS.SAMPLE_ID       = GSSD.SAMPLE_ID
     AND GS.SAMPLING_EVENT_ID = GSE.SAMPLING_EVENT_ID
     AND GR.DELETE_MARK     = 0
     AND GS.DELETE_MARK     = 0
     AND GSSD.DISPOSITION IN ('4A', '5AV')
     AND NVL(GST.PRINT_RESULT_IND,'N')  = 'Y'
     AND GSSD.EVENT_SPEC_DISP_ID = GSR.EVENT_SPEC_DISP_ID
     AND GR.RESULT_ID = GSR.RESULT_ID
     AND GS.SAMPLE_ID in (SELECT DISTINCT 
                                gs.SAMPLE_ID
                           FROM apps.gmd_recipes                      gr,
                                apps.gme_batch_header                 gbh,
                                apps.gme_material_details             gmd,
                                apps.gmd_recipe_validity_rules        vr,
                                apps.mtl_transaction_lot_numbers mtln,
                                apps.mtl_material_transactions   mmt,
                                apps.mtl_lot_numbers                  mln,
                                apps.mtl_system_items_b               msi,
                                apps.mtl_system_items_b               msis,
                                apps.GME_BATCH_HEADER                 gbhs,
                                apps.GMD_SAMPLES                      gs,
                                apps.GMD_SAMPLE_SPEC_DISP             gssd,
                                apps.GME_BATCH_GROUPS_ASSOCIATION     gbga,
                                apps.GME_BATCH_GROUPS_B               gbgb,
                                apps.GME_BATCH_GROUPS_ASSOCIATION     gbgas,
                                apps.fnd_lookup_values                flv
                          WHERE mtln.lot_number                 = mln.LOT_NUMBER              AND
                                mtln.inventory_item_id          = MSI.INVENTORY_ITEM_ID       AND
                                mtln.TRANSACTION_SOURCE_TYPE_ID = 5  /*Producao*/             AND  
                                mmt.transaction_type_id         = 44 /* Wip Completion*/      AND 
                                mmt.transaction_id              = mtln.transaction_id         AND
                                gbh.batch_id                    = mmt.TRANSACTION_SOURCE_ID   AND
                                gbh.ACTUAL_CMPLT_DATE              >= to_date ('01/jan/2024')     and
                                vr.recipe_validity_rule_id      = gbh.recipe_validity_rule_id AND
                                gr.recipe_id                    = vr.recipe_id                AND
                                --msi.inventory_item_id           = 'D800'                   AND
                                msi.organization_id             = 92                    AND
                                mln.inventory_item_id           = msi.inventory_item_id       AND
                                gbga.batch_id                   = gbh.batch_id                AND
                                gbgb.group_id                   = gbga.group_id               AND
                                gbgas.group_id                  = gbga.group_id               AND
                                gbhs.batch_id                   = gbgas.batch_id              AND
                                gbgas.batch_id                  = gs.batch_id                 AND
                                gs.sample_id                    = gssd.sample_id (+)          AND
                                gmd.batch_id                    = gbhs.batch_id               AND
                                gmd.line_type                   = 1                           AND
                                msis.inventory_item_id          = gmd.inventory_item_id       AND
                                msis.organization_id            = gmd.organization_id         AND
                                FLV.lookup_code                 = gssd.disposition            AND
                                FLV.lookup_type                 = 'GMD_QC_SAMPLE_DISP'        AND
                                FLV.LANGUAGE                    = 'PTB'                       AND
                                ((msi.item_type   = 'ACA'                                     AND 
                                  msis.item_type  = 'SEMI') OR
                                  msi.item_type <> 'ACA')                                     AND
                                gssd.delete_mark                = 0                           AND
                                gssd.disposition               IN ('4A', '5AV', '6RJ'))
    ORDER BY GR.SEQ;                               
                               
                               
                             select * from apps.gme_batch_header where ACTUAL_CMPLT_DATE >= to_date ('01/jan/2024');  
                                                      
                             
                             
(SELECT DISTINCT 
                                mln.lot_number,
                                msi.segment1,
                                gs.sample_no,
                                gs.SAMPLE_ID,
                                to_char(trunc(gs.date_drawn),'dd/mm/yyyy') date_drawn,
                                gs.source,
                                mln.origination_date,
                                gbh.batch_no,
                                flv.meaning disposition_no,
                                GS.SAMPLING_EVENT_ID SAMPLING_EVENT_ID
                           FROM apps.gmd_recipes                      gr,
                                apps.gme_batch_header                 gbh,
                                apps.gme_material_details             gmd,
                                apps.gmd_recipe_validity_rules        vr,
                                apps.mtl_transaction_lot_numbers mtln,
                                apps.mtl_material_transactions   mmt,
                                apps.mtl_lot_numbers                  mln,
                                apps.mtl_system_items_b               msi,
                                apps.mtl_system_items_b               msis,
                                apps.GME_BATCH_HEADER                 gbhs,
                                apps.GMD_SAMPLES                      gs,
                                apps.GMD_SAMPLE_SPEC_DISP             gssd,
                                apps.GME_BATCH_GROUPS_ASSOCIATION     gbga,
                                apps.GME_BATCH_GROUPS_B               gbgb,
                                apps.GME_BATCH_GROUPS_ASSOCIATION     gbgas,
                                apps.fnd_lookup_values                flv
                          WHERE mtln.lot_number                 = mln.LOT_NUMBER              AND
                                mtln.inventory_item_id          = MSI.INVENTORY_ITEM_ID       AND
                                mtln.TRANSACTION_SOURCE_TYPE_ID = 5  /*Producao*/             AND  
                                mmt.transaction_type_id         = 44 /* Wip Completion*/      AND 
                                mmt.transaction_id              = mtln.transaction_id         AND
                                gbh.batch_id                    = mmt.TRANSACTION_SOURCE_ID   AND
                                gs.LAST_UPDATE_DATE
                                gbh.ACTUAL_CMPLT_DATE              >= to_date ('01/jan/2024')     and
                                vr.recipe_validity_rule_id      = gbh.recipe_validity_rule_id AND
                                gr.recipe_id                    = vr.recipe_id                AND
                                --msi.inventory_item_id           = 'D800'                   AND
                                msi.organization_id             = 92                    AND
                                mln.inventory_item_id           = msi.inventory_item_id       AND
                                gbga.batch_id                   = gbh.batch_id                AND
                                gbgb.group_id                   = gbga.group_id               AND
                                gbgas.group_id                  = gbga.group_id               AND
                                gbhs.batch_id                   = gbgas.batch_id              AND
                                gbgas.batch_id                  = gs.batch_id                 AND
                                gs.sample_id                    = gssd.sample_id (+)          AND
                                gmd.batch_id                    = gbhs.batch_id               AND
                                gmd.line_type                   = 1                           AND
                                msis.inventory_item_id          = gmd.inventory_item_id       AND
                                msis.organization_id            = gmd.organization_id         AND
                                FLV.lookup_code                 = gssd.disposition            AND
                                FLV.lookup_type                 = 'GMD_QC_SAMPLE_DISP'        AND
                                FLV.LANGUAGE                    = 'PTB'                       AND
                                ((msi.item_type   = 'ACA'                                     AND 
                                  msis.item_type  = 'SEMI') OR
                                  msi.item_type <> 'ACA')                                     AND
                                gssd.delete_mark                = 0                           AND
                                gssd.disposition               IN ('4A', '5AV', '6RJ')
                               ORDER BY mln.origination_date desc) tab                             ;
                               
                               
SELECT GS.SAMPLE_NO,
       gs.sample_id
       ,GSF.SPEC_NAME || ' - ' ||  GS.SAMPLE_DESC  DESPEC
       ,GR.SEQ
       ,GST.PRINT_RESULT_IND
       ,NVL(GST.TEST_DISPLAY, GQT.TEST_CODE)  ETESTS
       ,GTM.TEST_METHOD_CODE            METOD
       ,NVL ( DECODE( GSR.ADDITIONAL_TEST_IND, 'Y',NULL, GST.TARGET_VALUE_CHAR ) ,'-')        E_COL1    -- TARGET
       ,NVL ( DECODE( GSR.ADDITIONAL_TEST_IND, 'Y',NULL, DECODE (GQT.TEST_TYPE, 'T' , GST.MIN_VALUE_CHAR ,  NVL( LTRIM(TO_CHAR( NVL( GST.MIN_VALUE_NUM, GQT.MIN_VALUE_NUM ),'999999999999990D'||TO_CHAR(power(10, NVL(GST.DISPLAY_PRECISION,  NVL(GQT.DISPLAY_PRECISION , GTM.DISPLAY_PRECISION))   )-1))) , GST.MIN_VALUE_CHAR ))  ) , '-' ) E_COL2    -- MIN VALUE
       ,NVL ( DECODE( GSR.ADDITIONAL_TEST_IND, 'Y',NULL, DECODE (GQT.TEST_TYPE, 'T' , GST.MAX_VALUE_CHAR ,  NVL( LTRIM(TO_CHAR( NVL( GST.MAX_VALUE_NUM, GQT.MAX_VALUE_NUM ),'999999999999990D'||TO_CHAR(power(10, NVL(GST.DISPLAY_PRECISION,  NVL(GQT.DISPLAY_PRECISION , GTM.DISPLAY_PRECISION))   )-1))) , GST.MAX_VALUE_CHAR ))  ) , '-' ) E_COL3    -- MAX VALUE
       ,NVL( LTRIM(TO_CHAR( GR.RESULT_VALUE_NUM,'999999999999990D'||TO_CHAR(power(10, NVL(GST.DISPLAY_PRECISION,  NVL(GQT.DISPLAY_PRECISION , GTM.DISPLAY_PRECISION))  )-1))) , NVL( TO_CHAR( TARGET_VALUE_NUM) , TARGET_VALUE_CHAR))      RVALNUM
       ,DECODE (GQT.TEST_TYPE, 'T' , GR.RESULT_VALUE_CHAR , NVL( LTRIM(TO_CHAR( GR.RESULT_VALUE_NUM,'999999999999990D'||TO_CHAR(power(10, NVL(GST.DISPLAY_PRECISION,  NVL(GQT.DISPLAY_PRECISION , GTM.DISPLAY_PRECISION))  )-1))) ,GR.RESULT_VALUE_CHAR) ) RESULT
       ,REPLACE(GQT.TEST_UNIT,'?','3')  TUNIT
       ,GR.TEST_REPLICATE_CNT           REPLI
       ,GST.TEST_PRIORITY               PRIORI
       ,NULL                            RVALID
    FROM apps.GMD_SAMPLES                   GS
       , apps.GMD_RESULTS                   GR
       , apps.GMD_QC_TESTS                  GQT
       , apps.GMD_TEST_METHODS              GTM
       , apps.GMD_SAMPLING_EVENTS           GSE
       , apps.GMD_SPECIFICATIONS            GSF
       , apps.GMD_ALL_SPEC_VRS              GASV
       , apps.GMD_SPEC_TESTS                GST
       , apps.GMD_SAMPLE_SPEC_DISP          GSSD
       , apps.GMD_SPEC_RESULTS              GSR
   WHERE GR.TEST_ID         = GQT.TEST_ID
     AND GR.TEST_METHOD_ID  = GTM.TEST_METHOD_ID
     AND GASV.SPEC_VR_ID    = GSE.ORIGINAL_SPEC_VR_ID
     AND GASV.SPEC_ID       = GSF.SPEC_ID
     AND GSF.SPEC_ID        = GST.SPEC_ID
     AND GST.TEST_ID        = GQT.TEST_ID
     AND GST.TEST_METHOD_ID = GTM.TEST_METHOD_ID
     AND GS.SAMPLE_ID       = GR.SAMPLE_ID
     AND GS.SAMPLE_ID       = GSSD.SAMPLE_ID
     AND GS.SAMPLING_EVENT_ID = GSE.SAMPLING_EVENT_ID
     AND GR.DELETE_MARK     = 0
     AND GS.DELETE_MARK     = 0
     AND GSSD.DISPOSITION IN ('4A', '5AV')
     AND NVL(GST.PRINT_RESULT_IND,'N')  = 'Y'
     AND GSSD.EVENT_SPEC_DISP_ID = GSR.EVENT_SPEC_DISP_ID
     AND GR.RESULT_ID            = GSR.RESULT_ID
     AND GS.LAST_UPDATE_DATE    >= to_date ('01/jan/2024');


select * from apps.GMD_SAMPLES                   GS where sample_id = 460283;

select organization_id from apps.gme_batch_header where batch_id = 365549;
                                