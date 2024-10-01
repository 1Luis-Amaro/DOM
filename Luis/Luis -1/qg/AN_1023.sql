select --ohq.inventory_item_id,
       --ohq.lot_number
       mmt.*
  from apps.mtl_onhand_quantities   ohq
      ,MTL_TRANSACTION_LOT_NUMBERS  MTLN
      ,MTL_SYSTEM_ITEMS_B           MSIB
      ,MTL_LOT_NUMBERS              LOT
      ,MTL_MATERIAL_TRANSACTIONS    MMT
      ,GME_BATCH_HEADER             GBH
 where ohq.subinventory_code = 'SOB' AND
       ohq.lot_number        = '171856' AND
                   MTLN.INVENTORY_ITEM_ID    = MSIB.INVENTORY_ITEM_ID
               AND MTLN.ORGANIZATION_ID      = MSIB.ORGANIZATION_ID
               AND MTLN.TRANSACTION_SOURCE_TYPE_ID IN ( 5,7 )  --Production - Transfer
               AND MSIB.ITEM_TYPE                  IN ('SEMI')
               AND MTLN.INVENTORY_ITEM_ID    = LOT.INVENTORY_ITEM_ID
               AND MTLN.ORGANIZATION_ID      = LOT.ORGANIZATION_ID
               AND MTLN.LOT_NUMBER           = LOT.LOT_NUMBER
               AND MTLN.TRANSACTION_ID       = MMT.TRANSACTION_ID
               AND MMT.TRANSACTION_SOURCE_ID = GBH.BATCH_ID
               AND NVL(GBH.BATCH_STATUS,2)         IN (2,3,4)
               AND LOT.LOT_NUMBER            = OHQ.LOT_NUMBER  (+)
               AND LOT.INVENTORY_ITEM_ID     = OHQ.INVENTORY_ITEM_ID (+)
               AND MTLN.ORGANIZATION_ID      = OHQ.ORGANIZATION_ID
               AND MSIB.INVENTORY_ITEM_ID    = ohq.INVENTORY_ITEM_ID
               AND MSIB.ORGANIZATION_ID      = OHQ.ORGANIZATION_ID;  


              FROM MTL_TRANSACTION_LOT_NUMBERS      MTLN
                  ,MTL_SYSTEM_ITEMS_B               MSIB
                  ,MTL_LOT_NUMBERS                  LOT
                  ,MTL_MATERIAL_TRANSACTIONS        MMT
                  ,GME_BATCH_HEADER                 GBH
                  ,GMD_SAMPLES                      GS
                  ,GMD_SAMPLE_SPEC_DISP             GSSD

                   MTLN.INVENTORY_ITEM_ID    = MSIB.INVENTORY_ITEM_ID
               AND MTLN.ORGANIZATION_ID      = MSIB.ORGANIZATION_ID
               AND MTLN.TRANSACTION_SOURCE_TYPE_ID IN ( 5,7 )  --Production - Transfer
               AND MSIB.ITEM_TYPE                  IN ('ACA','SEMI')
               AND MTLN.INVENTORY_ITEM_ID    = LOT.INVENTORY_ITEM_ID
               AND MTLN.ORGANIZATION_ID      = LOT.ORGANIZATION_ID
               AND MTLN.LOT_NUMBER           = LOT.LOT_NUMBER
               AND MTLN.TRANSACTION_ID       = MMT.TRANSACTION_ID
               AND MMT.TRANSACTION_SOURCE_ID = GBH.BATCH_ID
               AND NVL(GBH.BATCH_STATUS,2)         IN (2,3,4)
               AND LOT.LOT_NUMBER            = GS.LOT_NUMBER  (+)
               AND LOT.INVENTORY_ITEM_ID     = GS.INVENTORY_ITEM_ID (+)
               AND GS.SAMPLE_ID              = GSSD.SAMPLE_ID (+)
               AND GSSD.DELETE_MARK          = 0
               AND GSSD.DISPOSITION                IN ('4A', '5AV')
               AND MTLN.ORGANIZATION_ID      = 92
               AND MSIB.SEGMENT1             = 'PPG2004-899A'
               AND GBH.BATCH_NO              = 56730
            ORDER BY 7, 2 DESC); 
            

SELECT msi.segment1,
       msi.inventory_item_id,
       ohq.lot_number,
       ohq.qtde,
       mln.expiration_date,
      (SELECT distinct gbh.formula_id
         FROM gme_batch_header            gbh,
              mtl_transaction_lot_numbers mtln,
              mtl_material_transactions   mmt
        WHERE mtln.inventory_item_id    = msi.inventory_item_id
          AND mtln.organization_id      = msi.organization_id
          AND mtln.transaction_source_type_id IN ( 5 )
          AND mtln.inventory_item_id    = mln.inventory_item_id
          AND mtln.organization_id      = mln.organization_id
          AND mtln.transaction_id       = mmt.transaction_id
          AND mtln.lot_number           = mln.lot_number
          AND mmt.transaction_source_id = gbh.BATCH_ID
          AND mmt.transaction_type_id   = 44 /*Reporte*/) formula_id,
         (SELECT max ('INTERDITADO')
            FROM mtl_transaction_lot_numbers mtln,
                 mtl_material_transactions   mmt,
                 apps.mtl_parameters         mp,
                 apps.fnd_lookup_values_vl   flv
           WHERE mtln.lot_number        = mln.lot_number
             AND mtln.inventory_item_id = msi.inventory_item_id
             AND mtln.organization_id   = msi.organization_id
             AND mtln.transaction_id    = mmt.transaction_id
             AND mtln.organization_id   = mp.organization_id
             AND mp.organization_code   = flv.description
             AND flv.lookup_type        = 'XXPPG_1023_SUBINV_BLOQ'
             AND mmt.subinventory_code  = flv.tag) status_semi,
       (SELECT max((SELECT max ('INTERDITADO')
                 FROM mtl_transaction_lot_numbers mtln,
                     mtl_material_transactions    mmt,
                     apps.mtl_parameters          mp,
                     apps.fnd_lookup_values_vl    flv
               WHERE mtln.lot_number        = mtlna.lot_number
                 AND mtln.inventory_item_id = mtlna.inventory_item_id
                 AND mtln.organization_id   = mtlna.organization_id
                 AND mtln.transaction_id    = mmt.transaction_id
                 AND mtln.organization_id   = mp.organization_id
                 AND mp.organization_code   = flv.description
                 AND flv.lookup_type        = 'XXPPG_1023_SUBINV_BLOQ'
                 AND mmt.subinventory_code  = flv.tag)) status_aca
          FROM gme_batch_header            gbh,
               mtl_transaction_lot_numbers mtln,
               mtl_transaction_lot_numbers mtlna,
               mtl_material_transactions   mmt,
               mtl_material_transactions   mmta
         WHERE mtln.inventory_item_id     = msi.inventory_item_id
           AND mtln.organization_id       = msi.organization_id
           AND mtln.transaction_source_type_id IN ( 5 )
           AND mtln.inventory_item_id     = mln.inventory_item_id
           AND mtln.organization_id       = mln.organization_id
           AND mtln.transaction_id        = mmt.transaction_id
           AND mtln.lot_number            = mln.lot_number
           AND mmt.transaction_source_id  = gbh.BATCH_ID
           AND mmta.transaction_source_id = gbh.BATCH_ID
           AND mmt.transaction_type_id    = 35
           AND mmta.transaction_type_id   = 44
           AND mtlna.transaction_id       = mmta.transaction_id) status_aca
  FROM XXPPG_INV_ESTOQ_ONHAND_V     ohq,
       apps.mtl_system_items_b      msi,
       apps.mtl_lot_numbers         mln,
       apps.mtl_parameters          mp,
       apps.fnd_lookup_values_vl    flv
 WHERE ohq.subinventory_code = flv.tag
   AND msi.inventory_item_id = ohq.inventory_item_id 
   AND msi.organization_id   = ohq.organization_id
   AND mln.inventory_item_id = msi.inventory_item_id 
   AND mln.organization_id   = ohq.organization_id
   AND mln.lot_number        = ohq.lot_number
   AND mln.attribute5       IS NULL
   AND mp.organization_code  = flv.description
   AND ohq.organization_id   = mp.organization_id
   AND flv.lookup_type       = 'XXPPG_1023_SUBINV_SOB';
   
   
   
          SELECT max ('INTERDITADO')
            FROM mtl_transaction_lot_numbers mtln,
                 mtl_transaction_lot_numbers mtlna,
                 mtl_material_transactions   mmt,
                 mtl_material_transactions   mmta,
                 apps.mtl_parameters         mp,
                 apps.fnd_lookup_values_vl   flv
           WHERE mtln.lot_number            = '175563' --mln.lot_number
             AND mtln.inventory_item_id     = 11212 --msi.inventory_item_id
             AND mtln.organization_id       = 92 --msi.organization_id
             AND mtln.transaction_id        = mmt.transaction_id
             AND mtln.organization_id       = mp.organization_id
             AND mmta.transaction_source_id = gbh.BATCH_ID
             AND mmt.transaction_type_id    = 35
             AND mmta.transaction_type_id   = 44
             AND mtlna.transaction_id       = mmta.transaction_id
             AND mp.organization_code       = flv.description
             AND flv.lookup_type            = 'XXPPG_1023_SUBINV_BLOQ'
             AND mmt.subinventory_code      = flv.tag;   
   
   
      (SELECT (SELECT max ('INTERDITADO')
                 FROM mtl_transaction_lot_numbers mtln,
                     mtl_material_transactions    mmt,
                     apps.mtl_parameters          mp,
                     apps.fnd_lookup_values_vl    flv
               WHERE mtln.lot_number        = mtlna.lot_number
                 AND mtln.inventory_item_id = mtlna.inventory_item_id
                 AND mtln.organization_id   = mtlna.organization_id
                 AND mtln.transaction_id    = mmt.transaction_id
                 AND mtln.organization_id   = mp.organization_id
                 AND mp.organization_code   = flv.description
                 AND flv.lookup_type        = 'XXPPG_1023_SUBINV_BLOQ'
                 AND mmt.subinventory_code  = flv.tag) status_aca
          FROM gme_batch_header            gbh,
               mtl_transaction_lot_numbers mtln,
               mtl_transaction_lot_numbers mtlna,
               mtl_material_transactions   mmt,
               mtl_material_transactions   mmta
         WHERE mtln.inventory_item_id     = msi.inventory_item_id
           AND mtln.organization_id       = msi.organization_id
           AND mtln.transaction_source_type_id IN ( 5 )
           AND mtln.inventory_item_id     = mln.inventory_item_id
           AND mtln.organization_id       = mln.organization_id
           AND mtln.transaction_id        = mmt.transaction_id
           AND mtln.lot_number            = mln.lot_number
           AND mmt.transaction_source_id  = gbh.BATCH_ID
           AND mmta.transaction_source_id = gbh.BATCH_ID
           AND mmt.transaction_type_id    = 35
           AND mmta.transaction_type_id   = 44
           AND mtlna.transaction_id       = mmta.transaction_id) status_aca ;


 
SELECT * FROM FND_LOOKUP_VALUES_VL flv where flv.lookup_type = 'XXPPG_1023_SUBINV_SOB'

select * from mtl_transaction_lot_numbers;

SELECT * FROM MTL_ONHAND_QUANTITIES WHERE subinventory_code     = 'SOB' AND lot_number = '171833';
SELECT * FROM MTL_ONHAND_SUB_V WHERE subinventory_code     = 'SOB' AND lot_number = '171833';
SELECT * FROM MTL_ONHAND_LOCATOR_V WHERE subinventory_code     = 'SOB' AND lot_number = '171833';
SELECT * FROM MTL_ONHAND_LOCATOR_LOT_V WHERE subinventory_code     = 'SOB' AND lot_number = '171833';
SELECT * FROM MTL_ONHAND_LOT_V WHERE subinventory_code     = 'SOB' AND lot_number = '171833';
SELECT * FROM MTL_ONHAND_QTY_COST_V WHERE subinventory_code     = 'SOB' AND lot_number = '171833';
SELECT * FROM MTL_ONHAND_TOTAL_V WHERE subinventory_code     = 'SOB' AND lot_number = '171833';
SELECT * FROM MTL_ONHAND_SERIAL_V WHERE subinventory_code     = 'SOB' AND lot_number = '171833';
SELECT * FROM MTL_ONHAND_LPN_V WHERE subinventory_code     = 'SOB' AND lot_number = '171833';
SELECT * FROM MTL_ONHAND_DUMMY_V WHERE subinventory_code     = 'SOB' AND lot_number = '171833';
SELECT * FROM XXPPG_INV_ESTOQ_ONHAND_V WHERE subinventory_code     = 'SOB' AND lot_number = '171833';

select mic.*
          FROM mtl_item_categories_v mic;
         WHERE mic.organization_id = 87 
           AND mic.category_set_id = 1;

---------------- Relatório de Lotes a Expirar --------------------------
SELECT mp.organization_code  "Org",
       msi.item_type         "Tipo Item",
       (select mic.segment2
          FROM mtl_item_categories_v mic
         WHERE mic.organization_id = 87 
           AND mic.category_set_id = 1
           AND mic.inventory_item_id = msi.inventory_item_id) "BU",
       msi.segment1          "Item",
       ohq.lot_number        "Lote",
       mln.origination_date  "Dt Producao",
       mln.expiration_date   "Dt Validade",
       ohq.qtde              "Quantidade",
       ohq.subinventory_code "Subinv",
       mln.attribute2        "Nr Revalidacoes",
       mln.attribute5        "Ação Sobra"
  FROM XXPPG_INV_ESTOQ_ONHAND_V     ohq,
       apps.mtl_system_items_b      msi,
       apps.mtl_lot_numbers         mln,
       apps.mtl_parameters          mp,
       apps.fnd_lookup_values_vl    flv
 WHERE ohq.subinventory_code = flv.tag
   AND msi.inventory_item_id = ohq.inventory_item_id 
   AND msi.organization_id   = ohq.organization_id
   AND mln.inventory_item_id = msi.inventory_item_id 
   AND mln.organization_id   = ohq.organization_id
   AND mln.lot_number        = ohq.lot_number
   AND mp.organization_code  = flv.description
   AND ohq.organization_id   = mp.organization_id
   AND flv.lookup_type       = 'XXPPG_1023_SUBINV_SOB';



select * from XXPPG_INV_ESTOQ_ONHAND_V     ohq;


            
select distinct GBH.FORMULA_ID, LOT.EXPIRATION_DATE
  from apps.mtl_onhand_quantities   ohq
      ,MTL_TRANSACTION_LOT_NUMBERS  MTLN
      ,MTL_SYSTEM_ITEMS_B           MSIB
      ,MTL_LOT_NUMBERS              LOT
      ,MTL_MATERIAL_TRANSACTIONS    MMT
      ,GME_BATCH_HEADER             GBH
 where ohq.subinventory_code     = 'SOB'                    AND
     --  ohq.lot_number            = '171856'                 AND
       MTLN.INVENTORY_ITEM_ID    = MSIB.INVENTORY_ITEM_ID   AND
       MTLN.ORGANIZATION_ID      = MSIB.ORGANIZATION_ID     AND
       MTLN.TRANSACTION_SOURCE_TYPE_ID IN ( 5 )           AND
       MSIB.ITEM_TYPE                  IN ('SEMI')          AND
       MTLN.INVENTORY_ITEM_ID    = LOT.INVENTORY_ITEM_ID    AND
       MTLN.ORGANIZATION_ID      = LOT.ORGANIZATION_ID      AND
       MTLN.LOT_NUMBER           = LOT.LOT_NUMBER           AND
       MTLN.TRANSACTION_ID       = MMT.TRANSACTION_ID       AND
       MMT.TRANSACTION_SOURCE_ID = GBH.BATCH_ID             AND
       MMT.TRANSACTION_TYPE_ID   = 44 /*Reporte*/           AND
       LOT.LOT_NUMBER            = OHQ.LOT_NUMBER  (+)      AND
       LOT.INVENTORY_ITEM_ID     = OHQ.INVENTORY_ITEM_ID(+) AND
       MTLN.ORGANIZATION_ID      = OHQ.ORGANIZATION_ID      AND
       MSIB.INVENTORY_ITEM_ID    = OHQ.INVENTORY_ITEM_ID    AND
       MSIB.ORGANIZATION_ID      = OHQ.ORGANIZATION_ID;              
       
       
select GBH.FORMULA_ID, LOT.EXPIRATION_DATE, MMT.TRANSACTION_TYPE_ID 
  from apps.mtl_onhand_quantities   ohq
      ,MTL_TRANSACTION_LOT_NUMBERS  MTLN
      ,MTL_SYSTEM_ITEMS_B           MSIB
      ,MTL_LOT_NUMBERS              LOT
      ,MTL_MATERIAL_TRANSACTIONS    MMT
      ,GME_BATCH_HEADER             GBH
 where ohq.subinventory_code     = 'SOB'                    AND
       ohq.lot_number            = '171856'                 AND
       MTLN.INVENTORY_ITEM_ID    = MSIB.INVENTORY_ITEM_ID   AND
       MTLN.ORGANIZATION_ID      = MSIB.ORGANIZATION_ID     AND
       MTLN.TRANSACTION_SOURCE_TYPE_ID IN ( 5 )           AND
       MSIB.ITEM_TYPE                  IN ('SEMI')          AND
       MTLN.INVENTORY_ITEM_ID    = LOT.INVENTORY_ITEM_ID    AND
       MTLN.ORGANIZATION_ID      = LOT.ORGANIZATION_ID      AND
       MTLN.LOT_NUMBER           = LOT.LOT_NUMBER           AND
       MTLN.TRANSACTION_ID       = MMT.TRANSACTION_ID       AND
       MMT.TRANSACTION_SOURCE_ID = GBH.BATCH_ID             AND
       --MMT.TRANSACTION_TYPE_ID   = 44 /*Reporte*/           AND
       LOT.LOT_NUMBER            = OHQ.LOT_NUMBER  (+)      AND
       LOT.INVENTORY_ITEM_ID     = OHQ.INVENTORY_ITEM_ID(+) AND
       MTLN.ORGANIZATION_ID      = OHQ.ORGANIZATION_ID      AND
       MSIB.INVENTORY_ITEM_ID    = OHQ.INVENTORY_ITEM_ID    AND
       MSIB.ORGANIZATION_ID      = OHQ.ORGANIZATION_ID;                   