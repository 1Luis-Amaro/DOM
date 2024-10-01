select * from mtl_system_items_b msi 
 where msi.segment1 like 'REEE-%.22' AND --REEE-00003.22
       msi.organization_id = 92
                        and exists (SELECT 1
                                    FROM gmd.fm_form_mst_b ffm,
                                         gmd.fm_matl_dtl ffd,
                                         gmd.fm_matl_dtl ffd2,
                                         apps.mtl_system_items_b msib
                                   WHERE msib.segment1 not like 'WO%'
                                     AND msib.inventory_item_id = ffd2.inventory_item_id
                                     AND ffd2.line_type  = 1
                                     AND ffd2.formula_id = ffd.formula_id
                                     AND ffd.line_type   = -1 
                                     AND ffm.formula_id  = ffd.formula_id
                                     AND ffm.formula_status IN ('700', '900') -- formulas aprovadas ou congeladas
                                     AND ffd.inventory_item_id = msi.inventory_item_id);
                                     
                                     
                                     
select * from mtl_system_items_b msi, gmd.fm_form_mst_b ffm, gmd.fm_matl_dtl ffd 
 where msi.segment1 like 'RCEB-00003.22' AND
       msi.organization_id = 92 and
                        exists (SELECT 1
                                    FROM gmd.fm_form_mst_b ffm,
                                         gmd.fm_matl_dtl ffd
                                   WHERE ffm.formula_id = ffd.formula_id
                                     AND ffm.formula_status IN ('700', '900') -- formulas aprovadas ou congeladas
                                     AND ffd.inventory_item_id = msi.inventory_item_id
                                     AND ffd.organization_id   = msi.organization_id);                                      
                                     
select * from gmd.fm_form_mst_b;                            

select * from gmd.fm_matl_dtl ffd;

          


SELECT CASE
       WHEN 'ACA' in ('ACA','ACARV') AND
            'AUT' IN ('AUT', 'PKG', 'IND') AND
            TRUNC(TO_DATE(sysdate)) - nvl(MAX(TRUNC(mmt.transaction_date)),(sysdate-200)) > 150 THEN
      'PN (BU: AUT, PKG, IND) - For Stock Items: No sales in 5 months or more'
     ELSE
        NULL
     END
       FROM inv.mtl_material_transactions mmt
      WHERE mmt.inventory_item_id = 1017 AND
          ((mmt.organization_id   = 92   AND
            mmt.transaction_type_id = 33) OR --Venda
            
           (mmt.transaction_type_id = 35 AND
               exists (SELECT 1
                         FROM gmd.fm_form_mst_b ffm,
                              gmd.fm_matl_dtl ffd,
                              gmd.fm_matl_dtl ffd2,
                              apps.mtl_system_items_b msib
                        WHERE msib.segment1 not like 'WO%'
                          AND msib.inventory_item_id = ffd2.inventory_item_id
                          AND ffd2.line_type  = 1
                          AND ffd2.formula_id = ffd.formula_id
                          AND ffd.line_type   = -1 
                          AND ffm.formula_id  = ffd.formula_id
                          AND ffm.formula_status IN ('700', '900') -- formulas aprovadas ou congeladas
                          AND ffd.inventory_item_id = 1017))); --Consumo;
     
     
     
---------------------------------

select inventory_item_id from mtl_system_items_b where segment1 = 'RCEB-00010.22';
select segment1 from mtl_system_items_b where inventory_item_id = 235422;

SELECT MAX(TRUNC(mmt.transaction_date))
       FROM inv.mtl_material_transactions mmt
      WHERE mmt.inventory_item_id = 1017 AND
      
          ( (mmt.organization_id   = 92   AND
            mmt.transaction_type_id = 33) OR --Venda
            
           (mmt.transaction_type_id = 35 AND
               exists (SELECT 1
                         FROM gmd.fm_form_mst_b ffm,
                              gmd.fm_matl_dtl ffd,
                              gmd.fm_matl_dtl ffd2,
                              apps.mtl_system_items_b msib
                        WHERE msib.segment1 not like 'WO%'
                          AND msib.inventory_item_id = ffd2.inventory_item_id
                          AND ffd2.line_type  = 1
                          AND ffd2.formula_id = ffd.formula_id
                          AND ffd.line_type   = -1 
                          AND ffm.formula_id  = ffd.formula_id
                          AND ffm.formula_status IN ('700', '900') -- formulas aprovadas ou congeladas
                          AND ffd.inventory_item_id = 1017))); --Consumo; 
     


                   SELECT MAX (NVL(mtl1.Transaction_date
                                       ,TO_DATE('31/01/2015', 'dd/mm/rrrr')))
                      FROM apps.mtl_material_transactions   mtl1
                     WHERE mtl1.inventory_item_id    = 1017
                       AND (mtl1.organization_id     = 92  AND
                            mtl1.TRANSACTION_TYPE_ID = 34,33))
                       OR  (mtl1.transaction_type_id = 35 AND
                           exists (SELECT 1
                                     FROM gmd.fm_form_mst_b ffm,
                                          gmd.fm_matl_dtl ffd,
                                          gmd.fm_matl_dtl ffd2,
                                          apps.mtl_system_items_b msib
                                    WHERE msib.segment1 not like 'WO%'
                                      AND msib.inventory_item_id = ffd2.inventory_item_id
                                      AND ffd2.line_type  = 1
                                      AND ffd2.formula_id = ffd.formula_id
                                      AND ffd.line_type   = -1 
                                      AND ffm.formula_id  = ffd.formula_id
                                      AND ffm.formula_status IN ('700', '900') -- formulas aprovadas ou congeladas
                                      AND ffd.inventory_item_id = 1017)); --Consumo; 
 ; --     ult_venda,














     
                       SELECT *
                         FROM gmd.fm_form_mst_b ffm,
                              gmd.fm_matl_dtl ffd,
                              gmd.fm_matl_dtl ffd2,
                              apps.mtl_system_items_b msib
                        WHERE msib.segment1 not like 'WO%'
                          AND msib.inventory_item_id = ffd2.inventory_item_id
                         -- AND ffd2.line_type         = 1
                          AND ffd2.formula_id        = ffd.formula_id
                          AND ffm.formula_status IN ('700', '900') -- formulas aprovadas ou congeladas
                          AND ffm.formula_id         = ffd.formula_id
                          --AND ffd.line_type          = -1 
                          AND ffd.inventory_item_id  = 1017;
                          
                          
                       SELECT *
                         FROM gmd.fm_form_mst_b ffm,
                              gmd.fm_matl_dtl ffd,
                              gmd.fm_matl_dtl ffd2,
                              apps.mtl_system_items_b msib
                        WHERE msib.segment1 not like 'WO%'
                          AND msib.inventory_item_id = ffd2.inventory_item_id
                         -- AND ffd2.line_type         = 1
                          AND ffd2.formula_id        = ffd.formula_id
                          AND ffm.formula_status IN ('700', '900') -- formulas aprovadas ou congeladas
                          AND ffm.formula_id         = ffd.formula_id
                          --AND ffd.line_type          = -1 
                          AND ffd.inventory_item_id  = 235422;