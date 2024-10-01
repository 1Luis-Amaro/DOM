SELECT MP.ORGANIZATION_CODE ||' - ' || HOU.NAME Org_Inv
        , MSI.SEGMENT1 Cod_Item
        , MSI.DESCRIPTION Desc_Item
        , grb.recipe_no
        , MOQ.SUBINVENTORY_CODE Subinv
        , MIL.SEGMENT1||'.'||MIL.SEGMENT2||'.'||MIL.SEGMENT3||'.'||MIL.SEGMENT4||'.'||MIL.SEGMENT5 Endereco
        , MOQ.LOT_NUMBER lote
        , MSI.PRIMARY_UOM_CODE Unidade
        , SUM(MOQ.PRIMARY_TRANSACTION_QUANTITY)  Saldo
        , MIC.Categoria_Inventario
        , MIC.BU
        , MIC.SBU
        , MIC.tipo_item
        , MLN.expiration_date
       /* ,apps.XXPPG_INV_CONSIG_PKG.get_available_qty_p ( 'R'
                                                   , MOQ.SUBINVENTORY_CODE
                                                   , MOQ.LOT_NUMBER
                                                   , MOQ.ORGANIZATION_ID
                                                   , MOQ.INVENTORY_ITEM_ID) Qtde_Reservar
        ,apps.XXPPG_INV_CONSIG_PKG.get_available_qty_p ( 'T'
                                                   , MOQ.SUBINVENTORY_CODE
                                                   , MOQ.LOT_NUMBER
                                                   , MOQ.ORGANIZATION_ID
                                                   , MOQ.INVENTORY_ITEM_ID) Qtde_Transacionar   */                                                     
    FROM apps.mtl_onhand_quantities_detail moq,
         apps.mtl_lot_numbers              mln,
         apps.mtl_item_locations           mil,
         apps.mtl_system_items_b           msi,
         apps.mtl_parameters               mp,
         apps.hr_all_organization_units    hou,
         apps.mtl_transaction_lot_numbers  mtln,
         apps.gme_batch_header             gbh,
         apps.gmd_recipes_b                     grb,
         apps.gmd_recipe_validity_rules         grvr,
         (SELECT MC.segment1 tipo_item,  
                 MC.segment2 BU, 
                 MC.segment3 SBU, 
                 MIC.organization_id ORGANIZATION_ID, 
                 MIC.inventory_item_id INVENTORY_ITEM_ID,
                 MC.segment1||'.'||MC.segment2||'.'||MC.segment3 Categoria_Inventario
           FROM APPS.MTL_ITEM_CATEGORIES MIC, 
                APPS.MTL_CATEGORIES MC
          WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
            AND MIC.CATEGORY_SET_ID = 1              
          ) MIC
    WHERE MOQ.LOCATOR_ID                     = MIL.INVENTORY_LOCATION_ID(+)
      AND MOQ.ORGANIZATION_ID                = MIL.ORGANIZATION_ID(+)
      AND MOQ.ORGANIZATION_ID                = HOU.ORGANIZATION_ID
      AND MOQ.INVENTORY_ITEM_ID              = MSI.INVENTORY_ITEM_ID
      AND MOQ.ORGANIZATION_ID                = MSI.ORGANIZATION_ID
      AND MOQ.ORGANIZATION_ID                = MP.ORGANIZATION_ID
      AND MOQ.ORGANIZATION_ID                = MLN.ORGANIZATION_ID(+)
      AND MOQ.INVENTORY_ITEM_ID              = MLN.INVENTORY_ITEM_ID(+) 
      AND MOQ.LOT_NUMBER                     = MLN.LOT_NUMBER(+)        
      AND MSI.ORGANIZATION_ID                = MIC.ORGANIZATION_ID (+)
      AND MSI.INVENTORY_ITEM_ID              = MIC.INVENTORY_ITEM_ID (+)   
      AND MP.ORGANIZATION_ID                 = NVL('', MP.ORGANIZATION_ID)
      AND MOQ.SUBINVENTORY_CODE              = NVL('', MOQ.SUBINVENTORY_CODE)
      AND MIC.BU                             = NVL('', MIC.BU)
      --AND MSI.INVENTORY_ITEM_ID              = NVL(4651, MSI.INVENTORY_ITEM_ID)
      AND MSI.ORGANIZATION_ID                = MP.ORGANIZATION_ID
      AND MSI.ITEM_TYPE      LIKE NVL('ACA%', MSI.ITEM_TYPE)
      and mtln.organization_id(+)            = MOQ.organization_id
      AND mtln.inventory_item_id(+)          = MOQ.inventory_item_id
      AND mtln.lot_number(+)                 = MOQ.lot_number
      AND mtln.transaction_source_type_id(+) = 5
      AND gbh.organization_id(+)             = mtln.organization_id
      AND gbh.batch_id(+)                    = mtln.transaction_source_id
      AND grvr.recipe_validity_rule_id(+)    = gbh.recipe_validity_rule_id
      AND grb.recipe_id(+)                   = grvr.recipe_id
    GROUP BY MP.ORGANIZATION_CODE ||' - ' || HOU.NAME
        , MSI.SEGMENT1 
        , MSI.DESCRIPTION 
        , grb.recipe_no
        , MOQ.SUBINVENTORY_CODE 
        , MIL.SEGMENT1||'.'||MIL.SEGMENT2||'.'||MIL.SEGMENT3||'.'||MIL.SEGMENT4||'.'||MIL.SEGMENT5 
        , MOQ.LOT_NUMBER
        , MLN.expiration_date
        , MSI.PRIMARY_UOM_CODE 
        , MIC.Categoria_Inventario
        , MIC.BU
        , MIC.SBU
        , MIC.tipo_item;
        ,apps.XXPPG_INV_CONSIG_PKG.get_available_qty_p ( 'R'
                                                   , MOQ.SUBINVENTORY_CODE
                                                   , MOQ.LOT_NUMBER
                                                   , MOQ.ORGANIZATION_ID
                                                   , MOQ.INVENTORY_ITEM_ID)
        ,apps.XXPPG_INV_CONSIG_PKG.get_available_qty_p ( 'T'
                                                   , MOQ.SUBINVENTORY_CODE
                                                   , MOQ.LOT_NUMBER
                                                   , MOQ.ORGANIZATION_ID
                                                   , MOQ.INVENTORY_ITEM_ID);
      
select * from apps.mtl_onhand_quantities_detail moq;
SELECT inventory_item_id from apps.mtl_system_items_b where segment1 = 'D800.11';

select * from apps.mtl_lot_numbers_ALL;

SELECT * from apps.mtl_transaction_lot_numbers where inventory_item_id = 4651 and organization_id = 92 and lot_number = 'SUM000021';

select * from gme_material_details where batch_id = 731751; 

select * from gme_batch_header
 where batch_id = 731751;  

select recipe_no 
  from gmd_recipes_b             grb,
       gmd_recipe_validity_rules grvr
 WHERE grvr.recipe_validity_rule_id = 3017
   AND grb.recipe_id = grvr.recipe_id;



select * from  gme_batch_header                   gbh
               ,apps.gme_batch_groups_association gbga
               ,apps.gme_batch_groups_b           gbgb
               ,apps.gme_material_details         gmd
               ,apps.mtl_system_items_b           msib
               ,apps.mtl_item_categories_v        micv
          WHERE gbh.batch_id           = gbga.batch_id
            AND gbga.group_id          = gbgb.group_id
            AND gbh.batch_id           = gmd.batch_id
            AND gmd.inventory_item_id  = msib.inventory_item_id
            AND gmd.organization_id    = msib.organization_id
            AND msib.inventory_item_id = micv.inventory_item_id
            AND msib.organization_id   = micv.organization_id
            AND micv.segment1          = 'SEMI' --categoria de inventario semi
            AND micv.category_set_id   = 1      --categoria inventory
            AND gmd.line_type          = 1      --producto
            AND gbgb.group_name = 'D800/61089'; (SELECT max(gbgb.group_name)
                                     FROM apps.gme_batch_header             gbh
                                         ,apps.gme_batch_groups_association gbga
                                         ,apps.gme_batch_groups_b           gbgb
                                    WHERE gbh.batch_id  = gbga.batch_id
                                      AND gbga.group_id = gbgb.group_id
                                      AND gbh.batch_id  = 731751); --ordem de ACA parametro ejemplo

select * from apps.gme_batch_groups_b  where group_name = 'D800/61089';
select * from apps.gme_batch_groups_association gbga where group_id = 10417070;






select batch_no, lot_number
  from apps.mtl_transaction_lot_numbers mtln,
       apps.gme_batch_header            gbh
 where gbh.organization_id             = mtln.organization_id       and
       gbh.batch_id                    = mtln.transaction_source_id and
       mtln.inventory_item_id          = 4651                       and
       mtln.organization_id            = 92                         and
       mtln.transaction_source_type_id = 5;                          and
       mtln.transaction_source_id is not null;

/* Formatted on 17/11/2017 13:37:16 (QP5 v5.294) */
SELECT INVENTORY_ITEM_ID,
       ROW_ID,
       ORGANIZATION_ID,
       LOT_NUMBER,
       LOT_DESCRIPTION,
       VENDOR_ID,
       VENDOR_NAME,
       SUPPLIER_LOT_NUMBER,
       TERRITORY_CODE,
       GRADE_CODE,
       ORIGINATION_DATE,
       DATE_CODE,
       STATUS_ID,
       STATUS_CODE,
       CHANGE_DATE,
       AGE,
       RETEST_DATE,
       MATURITY_DATE,
       LOT_ATTRIBUTE_CATEGORY,
       ITEM_SIZE,
       COLOR,
       VOLUME,
       VOLUME_UOM,
       PLACE_OF_ORIGIN,
       BEST_BY_DATE,
       LENGTH,
       LENGTH_UOM,
       RECYCLED_CONTENT,
       THICKNESS,
       THICKNESS_UOM,
       WIDTH,
       WIDTH_UOM,
       CURL_WRINKLE_FOLD,
       C_ATTRIBUTE1,
       C_ATTRIBUTE2,
       C_ATTRIBUTE3,
       C_ATTRIBUTE4,
       C_ATTRIBUTE5,
       C_ATTRIBUTE6,
       C_ATTRIBUTE7,
       C_ATTRIBUTE8,
       C_ATTRIBUTE9,
       C_ATTRIBUTE10,
       C_ATTRIBUTE11,
       C_ATTRIBUTE12,
       C_ATTRIBUTE13,
       C_ATTRIBUTE14,
       C_ATTRIBUTE15,
       C_ATTRIBUTE16,
       C_ATTRIBUTE17,
       C_ATTRIBUTE18,
       C_ATTRIBUTE19,
       C_ATTRIBUTE20,
       D_ATTRIBUTE1,
       D_ATTRIBUTE2,
       D_ATTRIBUTE3,
       D_ATTRIBUTE4,
       D_ATTRIBUTE5,
       D_ATTRIBUTE6,
       D_ATTRIBUTE7,
       D_ATTRIBUTE8,
       D_ATTRIBUTE9,
       D_ATTRIBUTE10,
       N_ATTRIBUTE1,
       N_ATTRIBUTE2,
       N_ATTRIBUTE3,
       N_ATTRIBUTE4,
       N_ATTRIBUTE5,
       N_ATTRIBUTE6,
       N_ATTRIBUTE7,
       N_ATTRIBUTE8,
       N_ATTRIBUTE9,
       N_ATTRIBUTE10,
       GEN_OBJECT_ID,
       ATTRIBUTE_CATEGORY,
       ATTRIBUTE1,
       ATTRIBUTE2,
       ATTRIBUTE3,
       ATTRIBUTE4,
       ATTRIBUTE5,
       ATTRIBUTE6,
       ATTRIBUTE7,
       ATTRIBUTE8,
       ATTRIBUTE9,
       ATTRIBUTE10,
       ATTRIBUTE11,
       ATTRIBUTE12,
       ATTRIBUTE13,
       ATTRIBUTE14,
       ATTRIBUTE15,
       HOLD_DATE,
       EXPIRATION_DATE,
       PARENT_LOT_NUMBER,
       origination_type
  FROM MTL_LOT_NUMBERS_ALL_v
 WHERE     (INVENTORY_ITEM_ID = '4651')
       AND (ORGANIZATION_ID = '92')
       AND (LOT_NUMBER = 'SUM000021')