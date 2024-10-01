     SELECT COD_EMPRESA,
            COD_ESTAB,
            DATA_INVENTARIO,
            GRUPO_CONTAGEM,
            COD_NBM,
            TIPO_ITEM,
            IND_PRODUTO,
            COD_PRODUTO,
            COD_UND_PADRAO,
            COD_ALMOX,
            COD_CUSTO,
            COD_NAT_ESTOQUE,
            COD_MEDIDA,
            SUM (QUANTIDADE)QUANTIDADE,
            SUM (VLR_TOT)  VLR_TOT,
            VLR_UNIT,
            ORGANIZATION_ID,
            INVENTORY_ITEM_ID,
            CLASS_FISCAL,
            NATUREZA_ESTOQUE,
            QUANTIDADE_INVENTARIO,
            UNIDADE_MEDIDA,
            MATERIAL_ACCOUNT,
            COD_METODO_CUSTO,
            ID_TIPO_CUSTO,
            RECEIPT_NUM,
            CATEGORY_SET_NAME,
            COD_CONTA,
            COD_SITUACAO_A,
            COD_SITUACAO_B,
            IND_MOT_INV,
            IND_SIT_TRIB,
            VLR_IR,
            AUX01,
            AUX02,
            AUX03,
            AUX04,
            AUX05,
            AUX06,
            AUX07,
            AUX08,
            AUX09,
            AUX10,
            AUX11,
            AUX12,
            AUX13,
            AUX14,
            AUX15,
            AUX16,
            AUX17,
            AUX18,
            AUX19,
            AUX20,
            AUX21,
            AUX22,
            AUX23,
            AUX24,
            AUX25,
            AUX26,
            AUX27,
            AUX28,
            AUX29,
            AUX30
       FROM ( SELECT DECODE (LENGTH (fe.registration_number),
                             15, SUBSTR (fe.registration_number, 2, 9),
                             SUBSTR (fe.registration_number, 1, 8))
                        COD_EMPRESA                /*COD_EMPRESA            */
                                   ,
                     DECODE (LENGTH (fe.registration_number),
                             15, SUBSTR (fe.registration_number, 10, 4),
                             SUBSTR (fe.registration_number, 9, 4))
                        COD_ESTAB                  /*COD_ESTAB              */
                                 ,
                     TRUNC (OAP.SCHEDULE_CLOSE_DATE)          DATA_INVENTARIO /*DATA_INVENTARIO        */
                                                                             ,
                     DECODE (MP.EXPENSE_ACCOUNT,
                             NULL, DECODE (SUB.ATTRIBUTE4, 'Y', 3, 1),
                             2)
                        GRUPO_CONTAGEM             /*GRUPO_CONTAGEM         */
                                      ,
                     (SELECT MCB.SEGMENT1
                        FROM APPS.MTL_ITEM_CATEGORIES MIC,
                             APPS.MTL_CATEGORIES_B MCB
                       WHERE     MCB.CATEGORY_ID = MIC.CATEGORY_ID
                             AND MIC.ORGANIZATION_ID = MSI.ORGANIZATION_ID
                             AND MIC.CATEGORY_SET_ID = 1100000022
                             AND MIC.ORGANIZATION_ID = MSI.ORGANIZATION_ID
                             AND MIC.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID)
                        COD_NBM                    /*COD_NBM                */
                               ,
                     NULL                                     TIPO_ITEM /*TIPO_ITEM              */
                                                                       ,
                     MSI.item_type                            IND_PRODUTO /*IND_PRODUTO            */
                                                                         --Alter? a pedido de Claudio Calori(PPG)e Luis Oliveira(Dtt) - 02/03/2016 / Regina Bonela
                                                                         --MSIB.GLOBAL_ATTRIBUTE2 IND_PRODUTO     /*IND_PRODUTO            */
                                                                         --Solicitado pelo funcional Luis(pegar campo da safx2013)
                     ,
                     MSI.SEGMENT1                             COD_PRODUTO /*COD_PRODUTO            */
                                                                         ,
                     UPPER (MSI.PRIMARY_UOM_CODE)             COD_UND_PADRAO /*COD_UND_PADRAO         */
                                                                            ,
                     MTL.ORGANIZATION_ID || MTL.SUBINVENTORY_CODE COD_ALMOX /*COD_ALMOX              */
                                                                           ,
                     --gl.segment5 COD_CUSTO                  /*COD_CUSTO              */
                     NULL                                     COD_CUSTO /*COD_CUSTO              */
                                                                       ,
                     (SELECT MCB.SEGMENT1
                        FROM APPS.MTL_ITEM_CATEGORIES MIC,
                             APPS.MTL_CATEGORIES_B MCB
                       WHERE     MCB.CATEGORY_ID = MIC.CATEGORY_ID
                             AND MIC.ORGANIZATION_ID = MSI.ORGANIZATION_ID
                             AND MIC.CATEGORY_SET_ID = 1
                             AND MIC.ORGANIZATION_ID = MSI.ORGANIZATION_ID
                             AND MIC.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID)
                        COD_NAT_ESTOQUE            /*COD_NAT_ESTOQUE        */
                                       ,
                     UPPER (MSI.PRIMARY_UOM_CODE)             COD_MEDIDA /*COD_MEDIDA             */
                                                                        ,
                     SUM (MTL.PRIMARY_QUANTITY)               QUANTIDADE /*QUANTIDADE             */
                                                                        ,
                     ROUND (
                          (SELECT ROUND (SUM (CCD.CMPNT_COST), 2)
                             FROM APPS.CM_CMPT_DTL     CCD,
                                  APPS.CM_MTHD_MST     CMM,
                                  APPS.GMF_PERIOD_STATUSES GMF
                            WHERE     CCD.COST_TYPE_ID = CMM.COST_TYPE_ID
                                  AND CCD.COST_TYPE_ID = GMF.COST_TYPE_ID
                                  AND CCD.PERIOD_ID = GMF.PERIOD_ID
                                  AND CMM.COST_MTHD_CODE = 'PMAC'
                                  AND CCD.INVENTORY_ITEM_ID =
                                         MSI.INVENTORY_ITEM_ID
                                  AND CCD.ORGANIZATION_ID =
                                         DECODE (MP.ORGANIZATION_CODE,
                                                 'TGV', 86,
                                                 'TRN', 88,
                                                 'TSM', 92,
                                                 'TBT', 83,
                                                 'SGS', 92,
                                                 MSI.ORGANIZATION_ID)
                                  AND GMF.START_DATE = OAP.PERIOD_START_DATE)
                        * SUM (MTL.PRIMARY_QUANTITY),
                        2)
                        VLR_TOT                    /*VLR_TOT                */
                               ,
                     (SELECT ROUND (SUM (CCD.CMPNT_COST), 5)
                        FROM APPS.CM_CMPT_DTL     CCD,
                             APPS.CM_MTHD_MST     CMM,
                             APPS.GMF_PERIOD_STATUSES GMF
                       WHERE     CCD.COST_TYPE_ID = CMM.COST_TYPE_ID
                             AND CCD.COST_TYPE_ID = GMF.COST_TYPE_ID
                             AND CCD.PERIOD_ID = GMF.PERIOD_ID
                             AND CMM.COST_MTHD_CODE = 'PMAC'
                             AND CCD.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
                             AND CCD.ORGANIZATION_ID =
                                    DECODE (MP.ORGANIZATION_CODE,
                                            'TGV', 86,
                                            'TRN', 88,
                                            'TSM', 92,
                                            'TBT', 83,
                                            'SGS', 92,
                                            MSI.ORGANIZATION_ID)
                             AND GMF.START_DATE = OAP.PERIOD_START_DATE)
                        VLR_UNIT                   /*VLR_UNIT               */
                                --NAO USADOS PELO INSERT
                     ,
                     msi.organization_id                      ORGANIZATION_ID /*ORGANIZATION_ID        */
                                                                             ,
                     msi.inventory_item_id
                        INVENTORY_ITEM_ID          /*INVENTORY_ITEM_ID      */
                                         ,
                     NULL                                     CLASS_FISCAL /*CLASS_FISCAL           */
                                                                          ,
                     NULL
                        NATUREZA_ESTOQUE           /*NATUREZA_ESTOQUE       */
                                        ,
                     NULL
                        QUANTIDADE_INVENTARIO      /*QUANTIDADE_INVENTARIO  */
                                             ,
                     NULL                                     UNIDADE_MEDIDA /*UNIDADE_MEDIDA         */
                                                                            ,
                     NULL
                        MATERIAL_ACCOUNT           /*MATERIAL_ACCOUNT       */
                                        ,
                     NULL
                        COD_METODO_CUSTO           /*COD_METODO_CUSTO       */
                                        ,
                     NULL                                     ID_TIPO_CUSTO /*ID_TIPO_CUSTO          */
                                                                           ,
                     NULL                                     RECEIPT_NUM /*RECEIPT_NUM            */
                                                                         ,
                     NULL
                        CATEGORY_SET_NAME          /*CATEGORY_SET_NAME      */
                                         ,
                     (SELECT (   SUBSTR (KFV.CONCATENATED_SEGMENTS, 1, 4)
                              || '.'
                              || SUBSTR (KFV.CONCATENATED_SEGMENTS, 6, 5)
                              || '.'
                              || MC.ATTRIBUTE1
                              || '.'
                              || MC.ATTRIBUTE2
                              || '.'
                              || SUBSTR (KFV.CONCATENATED_SEGMENTS, 26, 6)
                              || '.'
                              || MC.ATTRIBUTE3
                              || '.'
                              || SUBSTR (KFV.CONCATENATED_SEGMENTS, 38, 4))
                        FROM APPS.MTL_ITEM_CATEGORIES  MIC,
                             APPS.MTL_CATEGORIES       MC,
                             APPS.MTL_PARAMETERS       MP,
                             APPS.GL_CODE_COMBINATIONS_KFV KFV
                       WHERE     MSI.ORGANIZATION_ID = MIC.ORGANIZATION_ID
                             AND MSI.ORGANIZATION_ID = MP.ORGANIZATION_ID
                             AND MSI.INVENTORY_ITEM_ID = MIC.INVENTORY_ITEM_ID
                             AND MC.CATEGORY_ID = MIC.CATEGORY_ID
                             AND MSI.COST_OF_SALES_ACCOUNT =
                                    KFV.CODE_COMBINATION_ID
                             AND MIC.CATEGORY_SET_ID = 1)
                        COD_CONTA                  /*COD_CONTA              */
                                 ,
                     MSI.GLOBAL_ATTRIBUTE3                    COD_SITUACAO_A /*COD_SITUACAO_A         */
                                                                            ,
                     MSI.GLOBAL_ATTRIBUTE6                    COD_SITUACAO_B /*COD_SITUACAO_B         */
                                                                            ,
                     '1'                                      IND_MOT_INV /*IND_MOT_INV            */
                                                                         ,
                     DECODE (MSI.GLOBAL_ATTRIBUTE5,
                             00, '1',
                             01, '1',
                             02, '2',
                             03, '3')
                        IND_SIT_TRIB               /*IND_SIT_TRIB           */
                                    ,
                     NULL                                     VLR_IR,
                     (SELECT DISTINCT vendor_site_id || 'F'
                        FROM apps.ap_supplier_sites_all pvs,
                             apps.hz_cust_site_uses_all hcsua,
                             apps.hz_cust_acct_sites_all hcasa,
                             apps.oe_order_headers_all ooh,
                             apps.oe_transaction_types_all ott
                       WHERE     pvs.global_attribute10 = MIL.SEGMENT2
                             AND hcsua.cust_acct_site_id =
                                    hcasa.cust_acct_site_id
                             AND hcasa.party_site_id = pvs.party_site_id
                             AND ooh.ship_to_org_id = hcsua.site_use_id
                             AND ott.ATTRIBUTE2 IS NOT NULL
                             AND ott.TRANSACTION_TYPE_ID = ooh.order_type_id
                             AND ROWNUM = 1)
                        AUX01                    /*AUX01  -- COD_FIS_JUR    */
                             ,
                     DECODE (MP.EXPENSE_ACCOUNT, NULL, NULL, 1) AUX02 /*AUX02   --IND_FIS_JUR    */
                                                                     ,
                     NULL                                     AUX03 /*AUX03                  */
                                                                   ,
                     NULL                                     AUX04 /*AUX04                  */
                                                                   ,
                     NULL                                     AUX05 /*AUX05                  */
                                                                   ,
                     NULL                                     AUX06 /*AUX06                  */
                                                                   ,
                     NULL                                     AUX07 /*AUX07                  */
                                                                   ,
                     NULL                                     AUX08 /*AUX08                  */
                                                                   ,
                     NULL                                     AUX09 /*AUX09                  */
                                                                   ,
                     NULL                                     AUX10 /*AUX10                  */
                                                                   ,
                     NULL                                     AUX11 /*AUX11                  */
                                                                   ,
                     NULL                                     AUX12 /*AUX12                  */
                                                                   ,
                     NULL                                     AUX13 /*AUX13                  */
                                                                   ,
                     NULL                                     AUX14 /*AUX14                  */
                                                                   ,
                     NULL                                     AUX15 /*AUX15                  */
                                                                   ,
                     NULL                                     AUX16 /*AUX16                  */
                                                                   ,
                     NULL                                     AUX17 /*AUX17                  */
                                                                   ,
                     NULL                                     AUX18 /*AUX18                  */
                                                                   ,
                     NULL                                     AUX19 /*AUX19                  */
                                                                   ,
                     NULL                                     AUX20 /*AUX20                  */
                                                                   ,
                     NULL                                     AUX21 /*AUX21                  */
                                                                   ,
                     NULL                                     AUX22 /*AUX22                  */
                                                                   ,
                     NULL                                     AUX23 /*AUX23                  */
                                                                   ,
                     NULL                                     AUX24 /*AUX24                  */
                                                                   ,
                     NULL                                     AUX25 /*AUX25                  */
                                                                   ,
                     NULL                                     AUX26 /*AUX26                  */
                                                                   ,
                     NULL                                     AUX27 /*AUX27                  */
                                                                   ,
                     NULL                                     AUX28 /*AUX28                  */
                                                                   ,
                     NULL                                     AUX29 /*AUX29                  */
                                                                   ,
                     NULL                                     AUX30 /*AUX30                  */
                /* AUX01 .. AUX30 CAMPOS AUXILIARES PARA CUSTOMIZA?O */
                FROM APPS.MTL_MATERIAL_TRANSACTIONS MTL,
                     APPS.MTL_PARAMETERS        MP,
                     APPS.MTL_SYSTEM_ITEMS_B    MSI,
                     APPS.MTL_TRANSACTION_TYPES MTT,
                     apps.MTL_TXN_SOURCE_TYPES  MTS,
                     apps.MTL_ITEM_LOCATIONS    MIL,
                     APPS.ORG_ACCT_PERIODS      OAP,
                     APPS.CLL_F255_ESTABLISHMENT_V FE,
                     APPS.MTL_SECONDARY_INVENTORIES SUB
               WHERE     (1 = 1)
                     AND MTL.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
                     AND MTL.ORGANIZATION_ID = MSI.ORGANIZATION_ID
                     AND MTL.ORGANIZATION_ID = MP.ORGANIZATION_ID
                     AND MTL.SUBINVENTORY_CODE = SUB.SECONDARY_INVENTORY_NAME
                     AND MTL.ORGANIZATION_ID = SUB.ORGANIZATION_ID
                     AND MTL.TRANSACTION_TYPE_ID = MTT.TRANSACTION_TYPE_ID
                     AND MTL.TRANSACTION_SOURCE_TYPE_ID =
                            MTS.TRANSACTION_SOURCE_TYPE_ID
                     --
                     AND OAP.ORGANIZATION_ID = MTL.ORGANIZATION_ID
                     AND MTL.TRANSACTION_DATE <
                            TO_DATE (OAP.SCHEDULE_CLOSE_DATE + 1)
                     --AND OAP.PERIOD_START_DATE = TO_DATE ('01-AUG-2016')
                     --
                     AND MTT.TRANSACTION_TYPE_NAME NOT IN
                            ('Periodic Cost Update', 'COGS Recognition')
                     --AND MSI.SEGMENT1                   = 'KT-43-2390'
                     --AND SUB.ATTRIBUTE4                 = 'Y'
                     AND DECODE (MP.ORGANIZATION_CODE,
                                 'TGV', 86,
                                 'TRN', 88,
                                 'TSM', 92,
                                 'TBT', 83,
                                 'SGS', 92,
                                 MP.ORGANIZATION_ID) =
                            FE.INVENTORY_ORGANIZATION_ID
                     /*AND ORGANIZATION_CODE              IN ('SGS',
                                                            'TBT',
                                                            'TGV',
                                                            'TRN',
                                                            'TSM','SUM')*/
                     AND MTL.LOCATOR_ID = MIL.INVENTORY_LOCATION_ID(+)
                     AND MTL.ORGANIZATION_ID = MIL.ORGANIZATION_ID(+)
                     and msi.segment1 = 'NIEA-00001.22'
                     --and MP.RESOURCE_ACCOUNT IS NULL
                     AND OAP.PERIOD_START_DATE BETWEEN sysdate - 432 and sysdate - 401
            --
            GROUP BY MP.ORGANIZATION_CODE,
                     MSI.ORGANIZATION_ID,
                     MSI.INVENTORY_ITEM_ID,
                     MSI.SEGMENT1,
                     MTL.SUBINVENTORY_CODE,
                     MIL.SEGMENT2,
                     FE.REGISTRATION_NUMBER,
                     OAP.SCHEDULE_CLOSE_DATE,
                     MP.EXPENSE_ACCOUNT,
                     SUB.ATTRIBUTE4,
                     MSI.PRIMARY_UOM_CODE,
                     MSI.ITEM_TYPE,
                     MTL.ORGANIZATION_ID,
                     MTL.SUBINVENTORY_CODE,
                     OAP.PERIOD_START_DATE,
                     MSI.GLOBAL_ATTRIBUTE3,
                     MSI.GLOBAL_ATTRIBUTE5,
                     MSI.GLOBAL_ATTRIBUTE6,
                     MSI.COST_OF_SALES_ACCOUNT)
      WHERE QUANTIDADE > 0 AND VLR_UNIT > 0
   GROUP BY COD_EMPRESA,
            COD_ESTAB,
            DATA_INVENTARIO,
            GRUPO_CONTAGEM,
            COD_NBM,
            TIPO_ITEM,
            IND_PRODUTO,
            COD_PRODUTO,
            COD_UND_PADRAO,
            COD_ALMOX,
            COD_CUSTO,
            COD_NAT_ESTOQUE,
            COD_MEDIDA,
            -- SUM(QUANTIDADE) QUANTIDADE,
            --SUM(VLR_TOT) VLR_TOT,
            VLR_UNIT,
            ORGANIZATION_ID,
            INVENTORY_ITEM_ID,
            CLASS_FISCAL,
            NATUREZA_ESTOQUE,
            QUANTIDADE_INVENTARIO,
            UNIDADE_MEDIDA,
            MATERIAL_ACCOUNT,
            COD_METODO_CUSTO,
            ID_TIPO_CUSTO,
            RECEIPT_NUM,
            CATEGORY_SET_NAME,
            COD_CONTA,
            COD_SITUACAO_A,
            COD_SITUACAO_B,
            IND_MOT_INV,
            IND_SIT_TRIB,
            VLR_IR,
            AUX01,
            AUX02,
            AUX03,
            AUX04,
            AUX05,
            AUX06,
            AUX07,
            AUX08,
            AUX09,
            AUX10,
            AUX11,
            AUX12,
            AUX13,
            AUX14,
            AUX15,
            AUX16,
            AUX17,
            AUX18,
            AUX19,
            AUX20,
            AUX21,
            AUX22,
            AUX23,
            AUX24,
            AUX25,
            AUX26,
            AUX27,
            AUX28,
            AUX29,
            AUX30
;
