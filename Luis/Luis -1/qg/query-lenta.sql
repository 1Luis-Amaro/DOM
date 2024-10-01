SELECT * FROM (SELECT XXPPG_GRP.group_name ,
                      XXPPG_GRP.group_desc ,
                      XXPPG_GRP.group_id ,
                      XXPPG_GRP.organization_id ,
                      XXPPG_GRP.OP ,
                      XXPPG_GRP.batch_no ,
                      XXPPG_GRP.lebel_security ,
                      XXPPG_GRP.batch_type ,
                      XXPPG_GRP.batch_status ,
                      XXPPG_GRP.batch_status_desc ,
                      XXPPG_GRP.category_segment ,
                      XXPPG_GRP.category_segment as category_segment1 ,
                      XXPPG_GRP.segment1 ,
                      XXPPG_GRP.description ,
                      XXPPG_GRP.recipe_no ,
                      XXPPG_GRP.start_date ,
                      XXPPG_GRP.end_date ,
                      XXPPG_GRP.porc_sobra ,
                      XXPPG_GRP.ltr_sobra ,
                      XXPPG_GRP.POU ,
                      XXPPG_GRP.LIQUIDO ,
                      XXPPG_GRP.switch_att8 ,
                      XXPPG_GRP.switch_att9 ,
                      XXPPG_GRP.batch_id 
                FROM (SELECT DISTINCT gbgv.group_name ,
                             gbgv.group_desc ,
                             gbgv.group_id ,
                             gbgv.organization_id ,
                             gbh.batch_no OP ,
                             gbh.batch_no ,
                             gbh.batch_id ,
                             NVL(fnd_profile.value('XXPPG_BR_PERFIL_ACESSO_GRUPOS'),'PLANEJADOR') lebel_security ,
                             gbh.batch_type ,
                             gbh.batch_status ,
                             flv.meaning batch_status_desc ,
                             XXPPG_GME_API_BATCH_PKG.GET_CATEGORY_SEGMENT(gmd.inventory_item_id, gmd.organization_id) category_segment ,
                             msi.segment1 ,
                             msi.description ,
                             grb.recipe_no ,
                             DECODE (gbh.batch_status, 1, gbh.plan_start_date, gbh.actual_start_date ) as start_date ,
                             DECODE (gbh.batch_status, 1, gbh.plan_cmplt_date, DECODE (gbh.batch_status, 2, to_date(gbh.attribute10,'DD/MM/YYYY HH24:MI:SS'),gbh.actual_cmplt_date)) as end_date ,
                             XXPPG_GME_API_BATCH_PKG.GET_DEVIATION (gbgv.group_id) as porc_sobra ,
                             XXPPG_GME_API_BATCH_PKG.GET_DEVIATION_LTR (gbgv.group_id) as ltr_sobra ,
                             NVL(gbh.attribute8,'N') as POU ,
                             NVL(gbh.attribute9,'N') AS LIQUIDO ,
                             DECODE(gbh.batch_status,2,'EnableAtt8','DisableAtt8') switch_att8 ,
                             DECODE(gbh.batch_status,2,'EnableAtt9','DisableAtt9') switch_att9 
                        FROM gme_batch_header gbh ,
                             gme_batch_groups_vl gbgv ,
                             gme_batch_groups_association gbga ,
                             gme_material_details gmd ,
                             fnd_lookup_values_vl flv ,
                             mtl_system_items msi ,
                             gmd_recipe_validity_rules grvr ,
                             gmd_recipes_b grb 
                       WHERE 1 = 1 AND
                             gbh.organization_id = gbgv.organization_id AND
                             gbgv.group_id = gbga.group_id AND
                             gbh.batch_id = gbga.batch_id AND
                             GMD.organization_id = GBH.organization_id AND
                             GMD.batch_id = GBH.batch_id AND
                             GMD.line_type = 1 AND
                             msi.organization_id = gmd.organization_id AND
                             msi.inventory_item_id = gmd.inventory_item_id AND
                             flv.lookup_code = gbh.batch_status AND
                             grvr.recipe_id = grb.recipe_id AND
                             grvr.recipe_validity_rule_id = gbh.recipe_validity_rule_id AND
                             grvr.inventory_item_id = gmd.inventory_item_id AND
                             grb.delete_mark = 0 AND
                             grvr.delete_mark = 0 AND
                            ( xxppg_gme_api_batch_pkg.get_category_segment ( gmd.inventory_item_id, gmd.organization_id) = 'SEMI' OR
                            ( gbh.attribute20 = 'SINGLE' AND
                    (SELECT count(*) 
                       FROM gme_batch_groups_vl gbgv2 ,
                            gme_batch_groups_association gbga2 ,
                            gme_material_details gmd2 
                            WHERE gbgv2.group_id = gbga2.group_id AND
                            gmd2.batch_id = gbga2.batch_id AND
                            gmd2.line_type = 1 AND
                            gbga2.group_id = gbga.group_id AND
                            xxppg_gme_api_batch_pkg.get_category_segment ( gmd2.inventory_item_id, gmd2.organization_id) = 'SEMI' ) = 0 ) ) AND
                            flv.lookup_type = 'GME_BATCH_STATUS' ) XXPPG_GRP) QRSLT 
                     WHERE (ORGANIZATION_ID = :1 AND
                           ( 'Y' = :2 AND
                           XXPPG_GME_API_BATCH_PKG.GET_STATUS_CANCEL ( GROUP_ID ) = 'N' ) AND
                     GROUP_ID IN
                           (SELECT DISTINCT gbgvs.group_id 
                              FROM gme_batch_header gbhs ,
                                   gme_batch_groups_vl gbgvs ,
                                   gme_batch_groups_association gbgas ,
                                   gme_material_details gmds 
                             WHERE gbhs.organization_id = gbgvs.organization_id AND
                                   gbhs.batch_id = gbgas.batch_id AND
                                   gbgvs.group_id = gbgas.group_id AND
                                   gmds.batch_id = gbhs.batch_id AND
                                   gmds.line_type = 1 AND
                                   gbhs.batch_type = :3 AND
                                   EXISTS (SELECT 1 
                                             FROM gme_batch_header gbhss ,
                                                  gmd_recipe_validity_rules grvrss ,
                                                  gmd_recipes_b grbss ,
                                                  fm_rout_hdr frhss 
                                            WHERE frhss.routing_id = grbss.routing_id AND
                                                  grvrss.recipe_id = grbss.recipe_id AND
                                                  grvrss.recipe_validity_rule_id = gbhss.recipe_validity_rule_id AND
                                                  gbhss.batch_id = gbhs.batch_id AND
                                                  frhss.routing_class = :4 ) )) 
       ORDER BY GROUP_NAME
