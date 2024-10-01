SELECT
                                                         ORG
         ,                                               OP
         ,                                               GRUPO
         ,                                               CLASSE
         ,                                               PRODUTO
         ,                                               STATUS_ORDEM
         ,                                               DATA_CONCLUSAO
         ,                                               CLASSE_ROTEIRO
         ,  DECODE('D','S',NULL,DATA_TRANSACAO)      DATA_TRANSACAO
         ,  DECODE('D','S',NULL,USUARIO_DE_CADASTRO) USUARIO_DE_CADASTRO
         ,                                               TRANSACAO
         ,  DECODE('D','S',NULL,TRANSACTION_ID)      TRANSACTION_ID
         ,                                               CATEG_TIPO_ITEM
         ,                                               ITEM
         ,                                               SUBINVENTARIO
         ,  DECODE('D','S',NULL, LOTE)               LOTE
         ,  SUM(QTDE_PRIMARIA)                           QTDE_PRIMARIA
         ,                                               UOM_PRIMARIA
         ,  SUM(QUANTIDADE_KG)                           QUANTIDADE_KG
         ,                                               UOM_KG
         ,                                               CONTRIBUI_PARA_RENDIMENTO
         ,  SUM(TOTAL_CONSUMOS_KG)                       TOTAL_CONSUMOS_KG
         ,  SUM(TOTAL_PRODUCAO_KG)                       TOTAL_PRODUCAO_KG
         ,  SUM(PERDA_KG  )                              PERDA_KG
         ,  SUM(PERC_DE_PERDA)                           PERC_DE_PERDA
         ,  SUM(TOTAL_PRODUCAO_LITROS)                   TOTAL_PRODUCAO_LITROS
      FROM (
    SELECT btch.organization_code                                                                                     ORG
         , btch.batch_no                                                                                               OP
         ,(SELECT gbg.group_name
             FROM gme.gme_batch_groups_association  gbga
                 ,gme.gme_batch_groups_b            gbg
            WHERE GBGA.GROUP_ID       = gbg.group_id
              AND gbga.batch_id       = btch.batch_id
              AND gbg.organization_id = btch.organization_id)                                                       GRUPO
         , btch.routing_class                                                                                          CLASSE
         , btch.segment1                                                                                               PRODUTO
         , BTCH.BATCH_STATUS                                                                                           STATUS_ORDEM
         , to_char(btch.actual_cmplt_date,'dd/mm/rrrr')                                                                DATA_CONCLUSAO
         , btch.routing_class                                                                                          CLASSE_ROTEIRO
         , to_char(mmt.transaction_date,'dd/mm/rrrr')                                                                  DATA_TRANSACAO
         , fuc.user_name                                                                                               USUARIO_DE_CADASTRO
         , DECODE(mmt.transaction_type_id,
                  35,  'Saida Consumo',
                  43,  'Estorno Saida Consumo',
                  17,  'Estorno Entrada Producao',
                  44,  'Entrada Producao',
                  1002,'Entrada Sub-Produto',
                  1003,'Estorno Ent Sub-Produto') TRANSACAO
         , mmt.transaction_id                                                                                          TRANSACTION_ID
         , mc.segment1                                                                                                 CATEG_TIPO_ITEM
         , msi.segment1                                                                                                ITEM
         , mmt.subinventory_code                                                                                       SUBINVENTARIO
         , mtln.lot_number                                                                                             LOTE
         , mmt.primary_quantity                                                                                        QTDE_PRIMARIA
         , msi.primary_uom_code                                                                                        UOM_PRIMARIA
         , ROUND(DECODE((
           inv_convert.inv_um_convert (
           mmt.inventory_item_id, 'kg',
           msi.primary_uom_code)), -99999, NULL,
          (mmt.primary_quantity / (
           inv_convert.inv_um_convert (
           mmt.inventory_item_id,'kg',
           msi.primary_uom_code)))),2) QUANTIDADE_KG
         ,'kg'                                                                                                           UOM_kg
         , gmd1.contribute_yield_ind                                                                                     CONTRIBUI_PARA_RENDIMENTO
         , ABS(ROUND((
           SELECT NVL(SUM(DECODE((
                  inv_convert.inv_um_convert (
                  mmt1.inventory_item_id, 'kg',
                  msi1.primary_uom_code)), -99999, NULL,
                 (mmt1.primary_quantity / (inv_convert.inv_um_convert (
                  mmt1.inventory_item_id,'kg',
                  msi1.primary_uom_code))))),0)
             FROM INV.MTL_MATERIAL_TRANSACTIONS MMT1
                 ,INV.MTL_SYSTEM_ITEMS_B        MSI1
                 ,GME.GME_MATERIAL_DETAILS      GMD2
            WHERE mmt1.organization_id          = mmt.organization_id
              AND mmt1.organization_id            = msi1.organization_id
              AND mmt1.inventory_item_id          = msi1.inventory_item_id
              AND mmt1.transaction_source_type_id = 5
              AND MMT1.TRANSACTION_SOURCE_ID      = btch.batch_id
              AND MMT1.TRX_SOURCE_LINE_ID         = gmd2.material_detail_id
              AND gmd2.contribute_yield_ind       = 'Y'
              AND MMT1.TRANSACTION_SOURCE_ID      = gmd2.batch_id
              AND mmt1.transaction_type_id in (35,43)),2)) TOTAL_CONSUMOS_kg
         , ABS(ROUND((
           SELECT NVL(SUM(DECODE((
                  inv_convert.inv_um_convert (
                  mmt1.inventory_item_id, 'kg',
                  msi1.primary_uom_code)), -99999, NULL,
                 (mmt1.primary_quantity / (
                  inv_convert.inv_um_convert (
                  mmt1.inventory_item_id,'kg',
                  msi1.primary_uom_code))))),0)
             FROM INV.MTL_MATERIAL_TRANSACTIONS MMT1
                 ,INV.MTL_SYSTEM_ITEMS_B        MSI1
            WHERE mmt1.organization_id            = mmt.organization_id
              AND mmt1.organization_id            = msi1.organization_id
              AND mmt1.inventory_item_id          = msi1.inventory_item_id
              AND mmt1.transaction_source_type_id = 5
              AND MMT1.TRANSACTION_SOURCE_ID      = btch.batch_id
              AND mmt1.transaction_type_id in (44,17,1002,1003)),2)) TOTAL_PRODUCAO_kg
         , ROUND((
           SELECT NVL(SUM(DECODE((
                  inv_convert.inv_um_convert (
                  mmt1.inventory_item_id, 'kg',
                  msi1.primary_uom_code)), -99999, NULL,
                 (mmt1.primary_quantity / (
                  inv_convert.inv_um_convert (
                  mmt1.inventory_item_id,'kg',
                  msi1.primary_uom_code))))),0)
             FROM INV.MTL_MATERIAL_TRANSACTIONS MMT1
                 ,INV.MTL_SYSTEM_ITEMS_B        MSI1
                 ,GME.GME_MATERIAL_DETAILS      GMD2
            WHERE mmt1.organization_id            = mmt.organization_id
              AND mmt1.organization_id            = msi1.organization_id
              AND mmt1.inventory_item_id          = msi1.inventory_item_id
              AND mmt1.transaction_source_type_id = 5
              AND MMT1.TRANSACTION_SOURCE_ID      = btch.batch_id
              AND MMT1.TRX_SOURCE_LINE_ID         = gmd2.material_detail_id
              AND gmd2.contribute_yield_ind       = 'Y'
              AND MMT1.TRANSACTION_SOURCE_ID      = gmd2.batch_id)*(-1),2) PERDA_kg
          --% de perda = (PERDA / CONSUMO) *100  -- Se consumo = 0 OP SEM CONSUMO se nao calcular a perda
         , CASE WHEN ROUND((
           SELECT NVL(SUM(DECODE((
                  inv_convert.inv_um_convert (
                  mmt1.inventory_item_id, 'kg',
                  msi1.primary_uom_code)), -99999, NULL,
                 (mmt1.primary_quantity / (
                  inv_convert.inv_um_convert (
                  mmt1.inventory_item_id,'kg',
                  msi1.primary_uom_code))))),0)
             FROM INV.MTL_MATERIAL_TRANSACTIONS MMT1
                 ,INV.MTL_SYSTEM_ITEMS_B        MSI1
                 ,GME.GME_MATERIAL_DETAILS      GMD2
            WHERE mmt1.organization_id            = mmt.organization_id
              AND mmt1.organization_id            = msi1.organization_id
              AND mmt1.inventory_item_id          = msi1.inventory_item_id
              AND mmt1.transaction_source_type_id = 5
              AND MMT1.TRANSACTION_SOURCE_ID      = btch.batch_id
              AND MMT1.TRX_SOURCE_LINE_ID         = gmd2.material_detail_id
              AND gmd2.contribute_yield_ind       = 'Y'
              AND MMT1.TRANSACTION_SOURCE_ID      = gmd2.batch_id
              AND mmt1.transaction_type_id in (35,43)),2) = 0 THEN 0
           ELSE ROUND((((
           SELECT SUM(DECODE((
                  inv_convert.inv_um_convert (
                  mmt1.inventory_item_id, 'kg',
                  msi1.primary_uom_code)), -99999, NULL,
                 (mmt1.primary_quantity / (
                  inv_convert.inv_um_convert (
                  mmt1.inventory_item_id,'kg',
                  msi1.primary_uom_code)))))
             FROM INV.MTL_MATERIAL_TRANSACTIONS MMT1
                 ,INV.MTL_SYSTEM_ITEMS_B        MSI1
                 ,GME.GME_MATERIAL_DETAILS      GMD2
            WHERE mmt1.organization_id            = mmt.organization_id
              AND mmt1.organization_id            = msi1.organization_id
              AND mmt1.inventory_item_id          = msi1.inventory_item_id
              AND mmt1.transaction_source_type_id = 5
              AND MMT1.TRANSACTION_SOURCE_ID      = btch.batch_id
              AND MMT1.TRX_SOURCE_LINE_ID         = gmd2.material_detail_id
              AND gmd2.contribute_yield_ind       = 'Y'
              AND MMT1.TRANSACTION_SOURCE_ID      = gmd2.batch_id) / (
           SELECT SUM(DECODE((
                  inv_convert.inv_um_convert (
                  mmt1.inventory_item_id, 'kg',
                  msi1.primary_uom_code)), -99999, NULL,
                 (mmt1.primary_quantity / (
                  inv_convert.inv_um_convert (
                  mmt1.inventory_item_id,'kg',
                  msi1.primary_uom_code)))))
             FROM INV.MTL_MATERIAL_TRANSACTIONS MMT1
                 ,INV.MTL_SYSTEM_ITEMS_B        MSI1
                 ,GME.GME_MATERIAL_DETAILS      GMD2
            WHERE mmt1.organization_id            = mmt.organization_id
              AND mmt1.organization_id            = msi1.organization_id
              AND mmt1.inventory_item_id          = msi1.inventory_item_id
              AND mmt1.transaction_source_type_id = 5
              AND MMT1.TRANSACTION_SOURCE_ID      = btch.batch_id
              AND MMT1.TRX_SOURCE_LINE_ID         = gmd2.material_detail_id
              AND gmd2.contribute_yield_ind       = 'Y'
              AND MMT1.TRANSACTION_SOURCE_ID      = gmd2.batch_id
              AND mmt1.transaction_type_id in (35,43))) * 100),2) -- % de perda
           END PERC_DE_PERDA
         , ABS(ROUND((
           SELECT SUM(DECODE((
                  inv_convert.inv_um_convert (
                  mmt1.inventory_item_id, 'l',
                  msi1.primary_uom_code)), -99999, NULL,
                 (mmt1.primary_quantity / (
                  inv_convert.inv_um_convert (
                  mmt1.inventory_item_id,'l',
                  msi1.primary_uom_code)))))
             FROM INV.MTL_MATERIAL_TRANSACTIONS MMT1
                 ,INV.MTL_SYSTEM_ITEMS_B        MSI1
            WHERE mmt1.organization_id            = mmt.organization_id
              AND mmt1.organization_id            = msi1.organization_id
              AND mmt1.inventory_item_id          = msi1.inventory_item_id
              AND mmt1.transaction_source_type_id = 5
              AND MMT1.TRANSACTION_SOURCE_ID      = btch.batch_id
              AND mmt1.transaction_type_id in (44,17,1002,1003)),2)) TOTAL_PRODUCAO_LITROS
      FROM
   (SELECT gbh.organization_id
         , ood.organization_code
         , gbh.batch_no
         , gbh.batch_id
         , msi.segment1
         , DECODE(GBH.BATCH_STATUS, -1,'CANCELADO',1, 'PENDENTE', 2, 'WIP' ,3, 'CONCLUIDO', 4, 'FECHADO')              BATCH_STATUS
         , gbh.actual_cmplt_date
         , frh.routing_class
         , mc.segment1                                                                                                 CATEG_TIPO_ITEM
     FROM  apps.gme_batch_header                            gbh
         , apps.gme_material_details                        gmd
         , apps.org_organization_definitions                ood
         , apps.fm_rout_hdr                                 frh
         , apps.mtl_item_categories                         mic
         , apps.mtl_category_sets                           mcs
         , apps.mtl_categories_kfv                          mc
         , apps.MTL_DEFAULT_CATEGORY_SETS_FK_V              mdcs
         , apps.mtl_system_items_b                          msi
     WHERE gbh.batch_id              = gmd.batch_id
       AND gmd.line_type             = 1                              --produto da op
       AND gbh.routing_id            = frh.routing_id(+)
       AND gbh.organization_id       = ood.organization_id
       AND (GBH.BATCH_STATUS         = 2
        OR (GBH.BATCH_STATUS in (3,4) -- Status atual WIP, concluído ou  fechado
       AND GBH.ACTUAL_CMPLT_DATE BETWEEN NVL(TRUNC(TO_DATE('2023/01/01','RRRR/MM/DD HH24:MI:SS')), GBH.ACTUAL_CMPLT_DATE)
                                     AND NVL(TRUNC(TO_DATE('2023/12/31','RRRR/MM/DD HH24:MI:SS'))+.99999,GBH.ACTUAL_CMPLT_DATE)))
       AND ood.organization_code     not in ('SUM','AMB')
       AND GBH.BATCH_STATUS          = NVL('',      gbh.batch_status)
       AND gbh.batch_no              = NVL('',         gbh.batch_no)
       AND frh.routing_class(+)      = NVL('',     frh.routing_class(+))
       AND mc.segment1               = NVL('',   mc.segment1)
       AND mic.inventory_item_id     = gmd.inventory_item_id
       AND mic.organization_id       = gmd.ORGANIZATION_ID
       AND mic.category_set_id       = mcs.category_set_id
       AND mic.category_id           = mc.category_id
       AND MDCS.FUNCTIONAL_AREA_ID   = 1        -- INVENTÁRIO
       AND mic.category_set_id       = mdcs.category_set_id
       AND mic.inventory_item_id     = msi.inventory_item_id
       AND mic.organization_id       = msi.organization_id) btch   -- SELECIONA AS OPS A SEREM CONSIDERADAS
         , apps.mtl_system_items_b                          msi
         , apps.mtl_material_transactions                   mmt
         , apps.gme_material_details                        gmd1
         , inv.mtl_transaction_lot_numbers                  mtln
         , apps.mtl_item_categories                         mic
         , apps.mtl_category_sets                           mcs
         , apps.mtl_categories_kfv                          mc
         , apps.MTL_DEFAULT_CATEGORY_SETS_FK_V              mdcs
         , APPS.FND_USER                                    FUC
     WHERE btch.batch_id                   = mmt.transaction_source_id
       AND btch.organization_id            = mmt.organization_id
       AND btch.organization_id            = msi.organization_id
       AND mmt.inventory_item_id           = msi.inventory_item_id
       AND mmt.inventory_item_id           = mic.inventory_item_id
       AND mmt.trx_source_line_id          = gmd1.material_detail_id
     --AND gmd1.contribute_yield_ind       = 'Y' -- RETIRAR  COLOCAR NA COLUNA TOTAL CONSUMO, perda e %perda
       AND mmt.transaction_id              = mtln.transaction_id (+)
       AND MMT.CREATED_BY                  = FUC.USER_ID
       AND btch.organization_id            = mic.organization_id
       AND mic.category_set_id             = mcs.category_set_id
       AND mic.category_id                 = mc.category_id
       AND MDCS.FUNCTIONAL_AREA_ID         = 1 -- INVENTÁRIO
       AND mic.category_set_id             = mdcs.category_set_id
     ORDER BY btch.organization_code, 3 -- grupo
         , btch.batch_no
         , msi.segment1
         , mmt.transaction_date)
     GROUP BY ORG
         , OP
         , GRUPO
         , CLASSE
         , PRODUTO
         , STATUS_ORDEM
         , DATA_CONCLUSAO
         , CLASSE_ROTEIRO
         , DATA_TRANSACAO
         , USUARIO_DE_CADASTRO
         , TRANSACAO
         , TRANSACTION_ID
         , CATEG_TIPO_ITEM
         , ITEM
         , SUBINVENTARIO
         , LOTE
         , UOM_PRIMARIA
         , UOM_KG
         , CONTRIBUI_PARA_RENDIMENTO
     ORDER BY ORG
         , GRUPO
         , OP
         , ITEM
         , DATA_TRANSACAO;