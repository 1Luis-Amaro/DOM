

--WITH cteMenuNivel(id,Nome,Nivel,NomeCompleto)
--AS
--(
--    -- Ancora
--    SELECT id,Nome,1 AS 'Nivel',CAST(Nome AS VARCHAR(255)) AS 'NomeCompleto' 
--    FROM tbMenu WHERE idPai IS NULL
--    
--    UNION ALL
    
--    -- Parte RECURSIVA
--    SELECT 
--        m.id,m.Nome,c.Nivel + 1 AS 'Nivel',
--        CAST((c.NomeCompleto + '/' + m.Nome) AS VARCHAR(255)) 'NomeCompleto' 
--    FROM tbMenu m INNER JOIN cteMenuNivel c ON m.idPai = c.id
    
--)
--SELECT Nivel,NomeCompleto FROM cteMenuNivel




WITH cteMenuNivel(segment1,inventory_item_id,qty, formula_id, recipe_id, organization_id, Nivel)
AS
(
    -- Ancora
    SELECT msi.segment1,
           fmd.inventory_item_id,
           CASE
              WHEN msip.planning_make_buy_code  = 1 THEN
                 1
              WHEN fmd.scale_type = 0 THEN
                 (fmd.qty / fm.qty) / vr.std_qty
              WHEN fmd.scale_type = 1 THEN
                 (fmd.qty / fm.qty)
              ELSE
                 (fmd.qty / fm.qty)
           END qty ,
           fmd.formula_id,
           gr.recipe_id,
           fmd.organization_id,
           0 as Nivel
      FROM apps.fm_form_mst_b fms,
           apps.fm_matl_dtl   fm,
           apps.fm_matl_dtl   fmd,
           apps.gmd_recipes_b gr,
           apps.gmd_recipe_validity_rules vr,
           apps.mtl_system_items_b msi,
           apps.mtl_system_items_b msip
     WHERE fmd.line_type              = -1                   AND           
           fmd.formula_id             = fm.formula_id        AND
           fmd.organization_id        = fm.organization_id   AND
--           
           /**** performance ****/
           vr.preference                  = 1               AND   
           vr.delete_mark                 = 0               AND   
           vr.recipe_use                  = 0               AND --Custos 
           vr.validity_rule_status       in (700,900)       AND 
           vr.recipe_id                   = gr.recipe_id    AND
           vr.start_date                 <= sysdate         AND
           vr.end_date                   is NULL            AND           
           /**** performance ****/
--           
           gr.recipe_id                 = (select max(gr1.recipe_id)
                                             FROM apps.gmd_recipes_b gr1,
                                                  apps.gmd_recipe_validity_rules vr1
                                            WHERE /**** Performance ****/
                                                  vr1.delete_mark           = 0                  AND
                                                  vr1.preference            = 1                  AND      
                                                  vr1.recipe_use            = 0 /*Custos*/      AND
                                                  vr1.validity_rule_status in (700,900)          AND
                                                  vr1.start_date           <= sysdate            AND
                                                  vr1.end_date             is null               AND
                                                  vr1.organization_id       = fm.organization_id AND
                                                  vr1.recipe_id             = gr1.recipe_id      AND
                                                  /**** Performance ****/
                                                  gr1.recipe_status        in (700,900)          AND
                                                  gr1.formula_id            = fm.formula_id) AND
--                                                  
           gr.recipe_status            in (700,900)             AND
           gr.formula_id                = fm.formula_id         AND
--           
           NVL(fms.formula_class,'SM') <> 'TING-PMC'            AND
           fms.formula_id               = fm.formula_id         AND
           fm.line_type                 = 1                     AND
           fm.inventory_item_id         = msi.inventory_item_id AND
           fm.organization_id           = msi.organization_id   AND
           msip.inventory_item_id       = fmd.inventory_item_id AND
           msip.organization_id         = msi.organization_id   AND
           --MSI.SEGMENT1 = 'BP-01.01'
           --           
           msi.segment1 in ('ZM463.01',
                            'ZM424.01',
                            'ZM423.01',
                            'ZM422.01',
                            'UY988.45',
                            'UY988.04',
                            'UY988.01',
                            'UY8200.45',
                            'UY8200.01',
                            'UY6200.45',
                            'UY6200.01',
                            'UY5300.45',
                            'UY5100.45',
                            'UY5100.01',
                            'UY3988.45',
                            'UY3988.01',
                            'UY3902.45',
                            'UY3901.45',
                            'UT95WP.77',
                            'TOPC-33ARC.48',
                            'TOPB-070PZ.46',
                            'TOEE-6355Z.C6',
                            'TOEE-6279Z.C6',
                            'TOEA-6356Z.57',
                            'TOEA-6247Z.79',
                            'TOBC-4W9SZ.51',
                            'TOBC-4W9MZ.51',
                            'TOBC-3T6SZ.51',
                            'TOBC-3T6MZ.51',
                            'TG300.37',
                            'TG200.37',
                            'TG140.37',
                            'TF803.51',
                            'TF803.01',
                            'TF600.01',
                            'TF501.01',
                            'TF401.01',
                            'TF1105.63',
                            'T494.63',
                            'T4018.16',
                            'RV8872.5',
                            'RV4493.01',
                            'RV4492.01',
                            'RV4491.01',
                            'RV4490.01',
                            'RV3992.50',
                            'RV2991.04',
                            'RV2593.0',
                            'RV1993.01',
                            'RV1992.01',
                            'RV1893.01',
                            'RV1892.01',
                            'RV1293.02',
                            'RV1290.02',
                            'RE8838.04',
                            'RE8801.50',
                            'RE6001.50',
                            'RE6001.01',
                            'RE2920.01',
                            'RC496.48',
                            'PPG9203-802.C6',
                            'PPG7940-309A.52',
                            'PPG5079-301A.51',
                            'PPG5079-004A.53',
                            'PPG5079-004A.52',
                            'PPG5078-804A.52',
                            'PPG5078-804A.49',
                            'PPG2954-806A.49',
                            'PPG2953-602A.52',
                            'PPG2613-810A.T6',
                            'PPG2534-601A.B96',
                            'PPG2092-823A.T92',
                            'PPG2066-813A.T90',
                            'PPG2004-846A.T92',
                            'PPG2004-846A.52',
                            'PPG2004-845A.52',
                            'PPG2004-845A.49',
                            'PPG0122-006A.53',
                            'PIT999.01',
                            'PIT900.45',
                            'PIT900.01',
                            'PIT7476.45',
                            'PIT7424.45',
                            'PIT7400.45',
                            'PIT7110.01',
                            'PIT7109.01',
                            'PIT7108.45',
                            'PIT7108.01',
                            'PIT7107.45',
                            'PIT7107.01',
                            'PIT7106.01',
                            'PIT7104.45',
                            'PIT7104.01',
                            'PIT7102.45',
                            'PIT7102.01',
                            'PIT7100.45',
                            'PIT7100.01',
                            'PIT692.45',
                            'PIT692.01',
                            'PIT6683.45',
                            'PIT6683.01',
                            'PIT6682.45',
                            'PIT6682.01',
                            'PIT6681.45',
                            'PIT6681.01',
                            'PIT6680.01',
                            'PIT6483.45',
                            'PIT6483.01',
                            'PIT6482.45',
                            'PIT6482.01',
                            'PIT6481.45',
                            'PIT6481.01',
                            'PIT6480.01',
                            'PIT5183.01',
                            'PIT5181.01',
                            'PIT5180.01',
                            'PIT5174.04',
                            'PIT5164.01',
                            'PIT5162.01',
                            'PIT5157.01',
                            'PIT5156.04',
                            'PIT5156.01',
                            'PIT5155.01',
                            'PIT5154.01',
                            'PIT5149.01',
                            'PIT5144.01',
                            'PIT5141.01',
                            'PIT5132.01',
                            'PIT5100.04',
                            'PIT5100.01',
                            'PIT4795.45',
                            'PIT4795.01',
                            'PIT4780.45',
                            'PIT4780.01',
                            'PIT4762.45',
                            'PIT4762.01',
                            'PIT4735.45',
                            'PIT4728.45',
                            'PIT4724.45',
                            'PIT4724.01',
                            'PIT4717.45',
                            'PIT4717.01',
                            'PIT4715.45',
                            'PIT4715.01',
                            'PIT4713.45',
                            'PIT4713.01',
                            'PIT4709.45',
                            'PIT4709.01',
                            'PIT4708.45',
                            'PIT4708.01',
                            'PIT4706.45',
                            'PIT4706.01',
                            'PIT4705.45',
                            'PIT4705.01',
                            'PIT4704.45',
                            'PIT4704.01',
                            'PIT4703.45',
                            'PIT4703.01',
                            'PIT4702.45',
                            'PIT4702.01',
                            'PIT4701.45',
                            'PIT4701.01',
                            'PIT4686.50',
                            'PIT4686.45',
                            'PIT4686.01',
                            'PIT4292.04',
                            'PIT3993.45',
                            'PIT3993.04',
                            'PIT3993.01',
                            'PIT3992.45',
                            'PIT3992.04',
                            'PIT3992.01',
                            'PIT3991.45',
                            'PIT3991.04',
                            'PIT3991.01',
                            'PIT3990.45',
                            'PIT3990.04',
                            'PIT3990.01',
                            'PIT3793.45',
                            'PIT3793.04',
                            'PIT3793.01',
                            'PIT3792.45',
                            'PIT3792.04',
                            'PIT3792.01',
                            'PIT3791.45',
                            'PIT3791.04',
                            'PIT3791.01',
                            'PIT3790.45',
                            'PIT3790.04',
                            'PIT3790.01',
                            'PIT372002.03',
                            'PIT3700.45',
                            'PIT3700.01',
                            'PIT3077.01',
                            'PIT3067.45',
                            'PIT3067.01',
                            'PIT3066.01',
                            'PIT3062.01',
                            'PIT3055.45',
                            'PIT3055.01',
                            'PIT3053.01',
                            'PIT3052.01',
                            'PIT305110.45',
                            'PIT3051.01',
                            'PIT3048.01',
                            'PIT3047.01',
                            'PIT3044.01',
                            'PIT3034.01',
                            'PIT3033.01',
                            'PIT3028.45',
                            'PIT3022.01',
                            'PIT3012.01',
                            'PIT3010.45',
                            'PIT3010.01',
                            'PIT3001.01',
                            'PIT2901.04',
                            'PIT2901.01',
                            'PIT288110.50',
                            'PIT288110.45',
                            'PIT288110.01',
                            'PIT2793.01',
                            'PIT2792.01',
                            'PIT2791.01',
                            'PIT2790.01',
                            'PIT26120.01',
                            'PIT25110.50',
                            'PIT25110.45',
                            'PIT25110.01',
                            'PIT250.01',
                            'PIT245.04',
                            'PIT245.01',
                            'PIT22002.03',
                            'PIT2001.45',
                            'PIT200.04',
                            'PIT200.01',
                            'PIT190.04',
                            'PIT190.01',
                            'PIT1193.01',
                            'PIT1191.01',
                            'PIT1184.04',
                            'PIT1183.04',
                            'PIT1183.01',
                            'PIT1182.04',
                            'PIT1181.04',
                            'PIT1181.01',
                            'PIT1180.04',
                            'PIT1179.04',
                            'PIT1174.04',
                            'PIT1172.04',
                            'PIT1170.04',
                            'PIT1166.04',
                            'PIT1166.01',
                            'PIT1164.04',
                            'PIT1162.04',
                            'PIT1159.04',
                            'PIT1159.01',
                            'PIT1157.04',
                            'PIT1157.01',
                            'PIT1156.04',
                            'PIT1155.04',
                            'PIT1154.04',
                            'PIT1153.04',
                            'PIT1153.01',
                            'PIT1149.04',
                            'PIT1144.04',
                            'PIT1144.01',
                            'PIT1141.04',
                            'PIT1134.04',
                            'PIT1134.01',
                            'PIT1132.04',
                            'PIT1128.04',
                            'PIT1128.01',
                            'PIT1100.04',
                            'PIT1100.01',
                            'PCT9G-9502.4P',
                            'PCT1T-0140.4P',
                            'PCT1N-0122.4P',
                            'PCT1G-6022.4P',
                            'PCT1G-4522B.4P',
                            'PCT1G-4516.4P',
                            'PCT1G-1084B.4P',
                            'PCS1N-1147.4P',
                            'PCM3N:96010.4D',
                            'PCF7P-1157.4P',
                            'PCF7N-8012.4P',
                            'PCF7N-1056.4P',
                            'PCF7K-7017.4P',
                            'PCF7K-1158.4P',
                            'PCF7K-1156.4P',
                            'PCF7K-1155.4P',
                            'PCF7G-7009.4P',
                            'PCF7G-6020.4P',
                            'PCF7G-5037.4P',
                            'PCF7G-4535.4P',
                            'PCF7G-1070.4P',
                            'PCF7G-0108.4P',
                            'PALA-00056.01',
                            'PALA-00055.01',
                            'PALA-00054.01',
                            'PALA-00053.01',
                            'PALA-00052.01',
                            'PALA-00045.01',
                            'PALA-00032.01',
                            'P425-EB02.11',
                            'OTEE-00008.57',
                            'MJ6870.04',
                            'MJ6870.01',
                            'MJ6860.04',
                            'MJ6860.01',
                            'MJ6825.04',
                            'MJ6820.04',
                            'MJ6811.01',
                            'MJ6802.04',
                            'MJ6749.04',
                            'MJ6745.04',
                            'MJ6742.04',
                            'MJ6741.04',
                            'MJ6740.04',
                            'MJ6740.01',
                            'MJ6735.04',
                            'MJ6735.01',
                            'MI59800.45',
                            'MI59800.01',
                            'LT6906SSA.51',
                            'LT5728SDD.50',
                            'LT5715SDD.50',
                            'LT13513SSA.48',
                            'LT13504SSA.51',
                            'LT13014SSA.51',
                            'LT13013SSA.51',
                            'LT13001SSA-D.51',
                            'LT0082SSA.51',
                            'LT0034SSA.51',
                            'LT0019SSA.51',
                            'LT0003SSA.51',
                            'INT7940.49',
                            'INRO-00001.97',
                            'INRC-00012.57',
                            'INRC-00010.63',
                            'INRC-00006.57',
                            'INRC-00004.63',
                            'INRC-00003.63',
                            'INRB-00001.63',
                            'INRA-00001.4P',
                            'IND7717.01',
                            'IN512.48',
                            'IN502.01',
                            'IN501.01',
                            'ID5200.25',
                            'FIVC-00001.22',
                            'FISB-00002.22',
                            'FBR551.20',
                            'FBR525.20',
                            'FBR516.77',
                            'FBR515.20',
                            'FBR515.01',
                            'FBR455.20',
                            'FBR300.48',
                            'FBR004.11',
                            'FBR004.10',
                            'F393.05',
                            'F366.11',
                            'DV7493.04',
                            'DV7492.04',
                            'DV7491.04',
                            'DUL626.11',
                            'DR4780.01',
                            'DR4762.45',
                            'DR4762.01',
                            'DR4717.45',
                            'DR4717.01',
                            'DR4715.45',
                            'DR4713.45',
                            'DR4713.01',
                            'DR4709.01',
                            'DR4708.45',
                            'DR4708.01',
                            'DR4706.45',
                            'DR4706.01',
                            'DR4705.01',
                            'DR4704.45',
                            'DR4704.01',
                            'DR4703.45',
                            'DR4703.01',
                            'DR4702.45',
                            'DR4701.52',
                            'DR4701.45',
                            'CR691B.57',
                            'CR-377.11',
                            'CR-338.11',
                            'CR-332.11',
                            'CR-315.11',
                            'CR-311.11',
                            'CR-309.11',
                            'CR-303.11',
                            'CP524.79',
                            'CM-117.11',
                            'CM-116.11',
                            'CM-112.11',
                            'CM-110.11',
                            'CM-008.11',
                            'CL-560.11',
                            'CL-513.11',
                            'CA2901.01',
                            'CA2701.01',
                            'CA1701.01',
                            'CA1301.01',
                            'C950-9441.01',
                            'C850-5000.11',
                            'C850-3800.10',
                            'C850-3800.04',
                            'C850-1100.04',
                            'C565-7041.04',
                            'C565-7041.01',
                            'C562-1141.04',
                            'C551-9800.17',
                            'C271-0100.04',
                            'C210-3087.16',
                            'C210-0020.32',
                            'C210-0020.11',
                            'C210-0010.11',
                            'C190-1021.08',
                            'C190-1021.04',
                            'C100-9305.16',
                            'C084-6419.01',
                            'BUF.77',
                            'BU-04.01',
                            'BS-02.11',
                            'BP-10.01',
                            'BP-01.20',
                            'BP-01.01',
                            'AT45H-BL.04',
                            'AT285-BL.20',
                            'AT285-BL.01',
                            'AT285-0004L.20',
                            'AT285-0004L.01',
                            'APBD-00010.51',
                            'APBD-00009.51',
                            'APBD-00003.51',
                            'APBC-00012.51',
                            'APBC-00011.51',
                            'APBC-00010.51',
                            'APBB-00013.51',
                            'APBB-00012.51',
                            'APBB-00004.51',
                            'AK2-T2L.01',
                            'AK2-BL.01',
                            'AK2-0055L.01',
                            'AK2-0004L.01',
                            'AK00043L.01',
                            'AK-0BL.01',
                            'AK-0AL.01',
                            'A400.48',
                            '999.50',
                            '9800.45',
                            '9247090.33',
                            '9217090.33',
                            '900I.52',
                            '900G.52',
                            '8918080.33',
                            '8800113L.20',
                            '819.93',
                            '818.93',
                            '817.93',
                            '816.93',
                            '815.93',
                            '814.93',
                            '813.93',
                            '812.93',
                            '811.93',
                            '7470.50',
                            '7470.01',
                            '7465.50',
                            '7465.01',
                            '7424.50',
                            '7424.01',
                            '7418.50',
                            '7412.50',
                            '7412.01',
                            '7300.33',
                            '7200.33',
                            '7110.50',
                            '7107.50',
                            '59800.45',
                            '5184.04',
                            '5179.04',
                            '5172.04',
                            '5170.04',
                            '5164.04',
                            '5159.04',
                            '5159.01',
                            '5157.04',
                            '5156.04',
                            '5149.04',
                            '5142.01',
                            '5141.04',
                            '5132.04',
                            '4680.26',
                            '4400.01',
                            '358780L.20',
                            '350.33',
                            '3207.01',
                            '318205L.20',
                            '318046L.10',
                            '3091.45',
                            '3087.45',
                            '3077.45',
                            '3077.01',
                            '3076.45',
                            '3067.45',
                            '3066.45',
                            '3066.01',
                            '3055.45',
                            '3053.45',
                            '3052.45',
                            '3052.01',
                            '3051.45',
                            '3049.45',
                            '3048.45',
                            '3046.45',
                            '3044.45',
                            '3038.45',
                            '3036.45',
                            '3036.01',
                            '3034.45',
                            '3033.45',
                            '3033.01',
                            '3028.45',
                            '3028.01',
                            '3022.45',
                            '3022.01',
                            '3017.45',
                            '3012.45',
                            '3012.01',
                            '3010.45',
                            '269558L.20',
                            '269554L.20',
                            '238849L.20',
                            '238847L.20',
                            '231785L.01',
                            '231302L.10',
                            '1900.01',
                            '1800.01',
                            '1749.83',
                            '155.04',
                            '155.01',
                            '121186L.10',
                            '1184.04',
                            '1182.01',
                            '1181.01',
                            '1170.01',
                            '1156.01',
                            '1149.04',
                            '1132.01',
                            '1128.04',
                            '102670L.10',
                            'TOBB-1GSZ.51',
                            'TK-51-2939',
                            'RZ-41-9426',
                            'PIT2701.04',
                            'PIT2701.01',
                            'PIT1037.01',
                            'PCT1N-10047.4',
                            'PCT1N-0122.4',
                            'PCM1G-8029.4P',
                            'PCF0N-2015.4P',
                            'P433-XR18.3',
                            'P429-980',
                            'P429-976',
                            'P429-937',
                            'P426-PP65',
                            'P426-PP63',
                            'P426-PP60',
                            'P426-PP05',
                            'P426-HE04',
                            'P426-HE03',
                            'P426-HE01',
                            'P425-998',
                            'P425-989',
                            'P425-987.11',
                            'P425-987',
                            'P425-971',
                            'P425-954',
                            'P425-941',
                            'P425-921',
                            'P420-982',
                            'P420-978',
                            'P420-960',
                            'P420-938',
                            'P420-910',
                            'P420-908',
                            'P420-907',
                            'P420-904',
                            'P420-902',
                            'P273-901',
                            'P210-844.11',
                            'MJ7050.04',
                            'KH-87-1682',
                            'KH-45-2646',
                            'FBR560.11',
                            'D717.1',
                            'CX-11.3B',
                            'CT1G-10009.4P',
                            'CM-118.11',
                            'CF6G-1991.4P',
                            'AF-58-5517',
                            '7462.01',
                            '7418.01',
                            '5500124L.20',
                            '5010003L.20',
                            '318709L.20',
                            '279795L.20',
                            '240471L.20',
                            '220294L.20',
                            '202389L.20',
                            '154017L.20',
                            '141347L.20',
                            '0480123L.20')
           --
           --msi.segment1 = '8201144982.99' --'TOEA-6247Z.79' --'8201144996.99' --'8201540330.99' --'TOEA-6247Z.79'
           --msi.inventory_item_id        = 2701
--           
    UNION ALL
--    
    -- Parte RECURSIVA
--
--
    SELECT c.segment1,
           fmdi.inventory_item_id,
--    
           case 
              when fmdi.scale_type = 0 then
                 ((fmdi.qty / fmi.qty) / vri.std_qty) * c.qty
              when fmdi.scale_type = 1 then
                 (fmdi.qty / fmi.qty) * c.qty
              else
                 (fmdi.qty / fmi.qty) * c.qty
           end qty ,
           fmdi.formula_id,
           gri.recipe_id,
           fmdi.organization_id,      
           c.nivel + 1
--           
      FROM apps.fm_form_mst_b fmsi
      join apps.fm_matl_dtl   fmi  
        on NVL(fmsi.formula_class,'SM') <> 'TING-PMC' AND
           fmsi.formula_id               = fmi.formula_id
--
      join apps.gmd_recipes_b gri
        on gri.recipe_status        in (700,900)            AND
           gri.recipe_id            = (select max(gr1.recipe_id)
                                         FROM apps.gmd_recipes_b gr1,
                                              apps.gmd_recipe_validity_rules vr1
                                        WHERE vr1.delete_mark                 = 0                   AND
                                              vr1.preference                  = 1                   AND      
                                              vr1.recipe_use                  = 0 /*Custos*/       AND
                                              vr1.validity_rule_status       in (700,900)           AND
                                              vr1.start_date                 <= sysdate             AND
                                              vr1.end_date                   is NULL                AND
                                              vr1.organization_id             = fmi.organization_id AND
                                              vr1.recipe_id                   = gr1.recipe_id       AND
                                              gr1.recipe_status              in (700,900)           AND
                                              gr1.formula_id                  = fmi.formula_id)       
--                   
--
      join apps.gmd_recipe_validity_rules vri
        on /**** performance ****/
           vri.preference                  = 1                   AND      
           vri.delete_mark                 = 0                   AND
           vri.recipe_use                  = 0                   AND --Custos 
           vri.validity_rule_status       in (700,900)           AND 
           vri.start_date                 <= sysdate             AND
           NVL(vri.end_date,(SYSDATE + 1)) > sysdate             AND
           vri.organization_id             = fmi.organization_id AND           
           vri.recipe_id                   = gri.recipe_id
           /**** performance ****/
--           
      join apps.fm_matl_dtl fmdi
        on fmdi.line_type           = -1                    AND
           fmdi.formula_id          = fmi.formula_id        AND
           fmdi.formula_id          = gri.formula_id        AND
           fmdi.organization_id     = fmi.organization_id    
--
--           
      join apps.mtl_system_items_b msii
        on fmi.inventory_item_id   = msii.inventory_item_id AND
           fmi.line_type           = 1                      AND
           msii.inventory_item_id  = fmi.inventory_item_id  AND
           msii.organization_id    = fmi.organization_id
--           
      join  cteMenuNivel c 
        on msii.inventory_item_id = c.inventory_item_id AND
           c.nivel                < 20
--
)      
--
--cycle inventory_item_id set is_cycle to '1' default '0'
--
SELECT c.segment1,
       msi.segment1 Ingrediente,
       msi.primary_uom_code,
       msi.item_type,
       --c.formula_id,
       --c.inventory_item_id,
       c.qty,
       --c.Nivel,
--       
       MSI.GLOBAL_ATTRIBUTE2       "Classe da Cond da Transação",
       MSI.GLOBAL_ATTRIBUTE3       "Origem do Item",
       MSI.GLOBAL_ATTRIBUTE4       "Tipo Fiscal do Item",
--       MSI.GLOBAL_ATTRIBUTE6       "Situação Trib Estadual",
--      MSI.GLOBAL_ATTRIBUTE5       "Situação Trib Federal",
--      MSI.GLOBAL_ATTRIBUTE10      "EAN13",
--       MSI.GLOBAL_ATTRIBUTE16      "Importar Conteudo",
--       MSI.GLOBAL_ATTRIBUTE17      "Valor Parcela estrangeira",
--       MSI.GLOBAL_ATTRIBUTE18      "Valor Total Envio Inter",
--       MSI.GLOBAL_ATTRIBUTE19      "Numero FCI",       
       FISCAL_CLASSIFICATION.CATEGORIA "NCM"       
--       
--       
--       
  FROM cteMenuNivel c, apps.mtl_system_items_b msi,
       (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('FISCAL_CLASSIFICATION')) FISCAL_CLASSIFICATION
 WHERE msi.inventory_item_id      = c.inventory_item_id AND
       msi.organization_id        = c.organization_id   AND
       msi.planning_make_buy_code = 2                   AND
       msi.item_type             <> 'INS/EMB'           AND
       msi.item_type             <> 'MISC'           AND
       MSI.ORGANIZATION_ID        = FISCAL_CLASSIFICATION.ORGANIZATION_ID(+) AND
       MSI.INVENTORY_ITEM_ID      = FISCAL_CLASSIFICATION.INVENTORY_ITEM_ID(+)
       ;

select * from apps.mtl_system_items_b where segment1 in ('SRC-75','HE-15-8633');