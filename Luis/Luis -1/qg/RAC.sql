/* Formatted on 29/7/2015 17:10:26 (QP5 v5.267.14150.38573) */
  SELECT org ORGANIZACAO,
         Item ITEM,
         Descricao DESCRICAO_DO_ITEM,
         UOM,
         COSTING_ENABLED_FLAG  Item_Custeado,
         Cat_Inv CATEGORIA_DE_INVENTARIO,
         Cat_Cst CATEGORIA_DE_CUSTOS,
         Quant QUANTIDADE_ESTOQUE,
         --CMED Custo_medio,
         --CSTD Custo_STD,
         Quant, --* CMED Custo_medio_Tot,
         Quant, --* CSTD Custo_STD_Tot,
         Sub_inv,
         Lote,
         dat_exp,
         TRUNC (nvl(ult_trans,to_date('31/01/2015','dd/mm/rrrr'))) Ultima_mov, 
         round (( trunc (sysdate) - TRUNC (nvl(ult_trans,to_date('31/01/2015','dd/mm/rrrr'))))/30,1) Mes_S_Mov,
         round ( trunc (sysdate) - TRUNC (nvl(ult_trans,to_date('31/01/2015','dd/mm/rrrr')))) Sem_movto,
         
         CASE WHEN tipo = 'ACA'  THEN
              CASE WHEN round ( trunc (sysdate) - TRUNC (nvl(ult_trans,to_date('31/01/2015','dd/mm/rrrr')))) > 5 THEN 'MC' 
              END
              WHEN tipo = 'MP'   THEN 'b'
              CASE WHEN round ( trunc (sysdate) - TRUNC (nvl(ult_trans,to_date('31/01/2015','dd/mm/rrrr')))) > 5 THEN 'MC' 
              END
              WHEN tipo = 'EMB'  THEN 'c'
              CASE WHEN round ( trunc (sysdate) - TRUNC (nvl(ult_trans,to_date('31/01/2015','dd/mm/rrrr')))) > 5 THEN 'MC' 
              END
              WHEN tipo = 'SEMI' THEN 'd'
              CASE WHEN round ( trunc (sysdate) - TRUNC (nvl(ult_trans,to_date('31/01/2015','dd/mm/rrrr')))) > 5 THEN 'MC' 
              END
              WHEN tipo = 'INT'  THEN 'e'
              CASE WHEN round ( trunc (sysdate) - TRUNC (nvl(ult_trans,to_date('31/01/2015','dd/mm/rrrr')))) > 5 THEN 'MC' 
              END
              
         END Magna_Carta
         
         
    FROM (  SELECT mp.organization_code Org,
                   mot.ITEM Item,
                   mot.ITEM_DESCRIPTION Descricao,
                   mot.UOM UOM,
                   msi.COSTING_ENABLED_FLAG,
                   msi.item_type TIPO,
                   mic.category_concat_segs Cat_Inv,
                   mic1.category_concat_segs Cat_Cst,
                   mot.SUBINVENTORY_CODE Sub_inv,
                   mot.LOT_NUMBER Lote,
                   TRUNC (mot.expiration_date) dat_exp,
                   SUM (mot.ON_HAND) Quant,
                  -- NVL (CMED.custo, 0) CMED,
                  -- NVL (CSTD.custo_std, 0) CSTD, --, nvl(CMED.Mes,Null) || nvl(CSTD.Mes,null)                                    mes
                   (SELECT MAX (
                              NVL (mtln.Transaction_date,
                                   NVL (mtl1.Transaction_date, TO_DATE ('31/01/2015', 'dd/mm/rrrr'))))
                              data
                      FROM apps.MTL_MATERIAL_TRANSACTIONS mtl1, apps.MTL_TRANSACTION_LOT_NUMBERS mtln
                     WHERE     1 = 1
                           AND mtl1.transaction_id = mtln.transaction_id(+)
                           AND mtl1.TRANSACTION_TYPE_ID IN (61,
                                                            34,
                                                            63,
                                                            18,
                                                            33,
                                                            44,
                                                            35)
                           AND mtl1.inventory_item_id = msi.inventory_item_id
                           AND MTL1.organization_id = msi.organization_id
                   )
                      ult_trans
              FROM apps.MTL_ONHAND_TOTAL_MWB_V mot,
                   apps.mtl_parameters mp,
                   apps.mtl_item_categories_v mic,
                   apps.mtl_item_categories_v mic1,
                   apps.mtl_system_items msi
                   /*
                   (  SELECT gps.period_code periodo,
                             gcd.inventory_item_id,
                             ROUND (SUM (gcd.cmpnt_cost), 5) custo,
                             gcd.organization_id
                        --  TO_CHAR (start_date, 'mm/yyyy') mes
                        FROM gmf.cm_cmpt_dtl gcd, apps.gmf_period_statuses gps
                       WHERE     1 = 1
                             AND gcd.period_id = gps.period_id
                             AND gps.calendar_code = 'PPG_2015'                                     -- p_calendario
                             AND gps.period_code = '07'                                             --p_periodo_med
                             AND gps.cost_type_id = '1000'
                             AND gcd.delete_mark = '0'
                    GROUP BY gps.period_code, gcd.inventory_item_id, gcd.organization_id -- TO_CHAR (start_date, 'mm-yyyy')
                                                                                        ) CMED,
                   (  SELECT gps.period_code periodo,
                             gcd.inventory_item_id,
                             ROUND (SUM (gcd.cmpnt_cost), 5) custo_std,
                             gcd.organization_id
                        --  TO_CHAR (start_date, 'mm-yyyy') mes
                        FROM gmf.cm_cmpt_dtl gcd, apps.gmf_period_statuses gps
                       WHERE     1 = 1
                             AND gcd.period_id = gps.period_id
                             AND gps.calendar_code = 'PPG_2015'                                     -- p_calendario
                             AND gps.period_code = '07'                                               --p_periodo_std
                             AND gps.cost_type_id = '1005'
                    GROUP BY gps.period_code, gcd.inventory_item_id, gcd.organization_id -- TO_CHAR (start_date, 'mm-yyyy')
                                                                                        ) CSTD*/
             WHERE     1 = 1
                   AND mp.organization_id = mot.organization_id
                   AND mic.inventory_item_id = mot.inventory_item_id
                   AND mic.organization_id = mot.organization_id
                   AND mic.category_set_id = 1
                   AND mic1.inventory_item_id = mot.inventory_item_id
                   AND mot.inventory_item_id = msi.inventory_item_id
                   AND mot.organization_id = msi.organization_id
                   AND msi.PROCESS_COSTING_ENABLED_FLAG = 'Y'
                   AND mic1.organization_id = mot.organization_id
                  -- AND mic1.category_set_id = 1100000061
                /*   AND mot.inventory_item_id = CMED.inventory_item_id(+)
                   AND mot.organization_id = CMED.organization_id(+)
                   AND mot.inventory_item_id = CSTD.inventory_item_id(+)
                   AND mot.organization_id = CSTD.organization_id(+)*/
               --    AND mot.ORGANIZATION_ID = 92                                                 --p_organization_id
          --  AND ((p_item IS NULL) OR
          --      (p_item IS NOT NULL AND
          --      mot.inventory_item_id = p_item)
          --       )
          --  and  ((p_dias_vencimento is null) or
          --         (p_dias_vencimento is not null) and
          --           (mot.expiration_date) <=  TRUNC (sysdate) + p_dias_vencimento)
         GROUP BY mot.ITEM,
                   mot.ITEM_DESCRIPTION,
                   mot.UOM,
                   msi.COSTING_ENABLED_FLAG,
                   msi.item_type,
                   mot.SUBINVENTORY_CODE,
                   mot.LOT_NUMBER,
                   mp.organization_code,
                   mic.category_concat_segs,
                   mic1.category_concat_segs,
                   mot.expiration_date,
                --   NVL (CMED.custo, 0),
                   --NVL (CSTD.custo_std, 0),                                                            --, CMED.Mes
                   --  , CSTD.Mes
                   msi.inventory_item_id,
                   msi.organization_id)
ORDER BY 1, 2

