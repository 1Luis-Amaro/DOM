SELECT primary_unit_of_measure, SECONDARY_UOM_CODE from apps.mtl_system_items_b where segment1 = ',D800.11',;
DPSZ-2S.57
select decode(0,0,1) from dual;

select * from apps.mtl_parameters;

SELECT distinct msi.segment1,
       inventario.categoria,
       msi.description,
      -- msie.segment1 "Container",
       msi.primary_uom_code             "UN",
       msi.secondary_uom_code           "UN secundaria",
       (1 / nvl(cv.CONVERSION_RATE,1))  "Envase",
       cv.to_unit_of_measure            "UN Envase",
       nvl(1 / cv2.CONVERSION_RATE,null) "Volume",
       nvl(wci.max_load_quantity,1)    "Multiplo Embalagem",
       msi.minimum_license_quantity    "Multiplo Venda",
       nvl(msie.unit_weight,0)         "Peso Container",
       nvl(msi.unit_weight,0)          "Peso Liquido",
       msie.segment1,
       msie.unit_weight                "Peso Container",
       case 
          when nvl(wci.max_load_quantity,0) > 0 then
               ROUND((nvl(msie.unit_weight,0) / nvl(wci.max_load_quantity,1)) + nvl(msi.unit_weight,0),3)
          else ROUND(nvl(msie.unit_weight,0) + nvl(msi.unit_weight,0),3)
       end "Peso Bruto"
--       
       FROM apps.MTL_UOM_CLASS_CONVERSIONS cv,
            apps.MTL_UOM_CLASS_CONVERSIONS cv2,
            apps.mtl_system_items_b        msi,
            inv.mtl_system_items_b         msie,
            wsh.wsh_container_items        wci,
           (SELECT MIC.INVENTORY_ITEM_ID,
                   MIC.ORGANIZATION_ID,
                   MIC.CATEGORY_SET_NAME,
                   MIC.CATEGORY_CONCAT_SEGS CATEGORIA
              FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
             WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
               AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO
--
 where cv.inventory_item_id(+)        = msi.inventory_item_id           AND
       cv.to_uom_code(+)              = msi.secondary_uom_code          AND
       cv2.inventory_item_id(+)       = msi.inventory_item_id           AND
       cv2.to_uom_code(+)             = 'l'                             AND       
       wci.load_item_id  (+)          = msi.inventory_item_id           AND
       wci.preferred_flag (+)         = 'Y'                             AND
       msie.organization_id (+)       = wci.master_organization_id      AND
       msie.inventory_item_id (+)     = wci.container_item_id           AND
       wci.master_organization_id (+) = msi.organization_id             AND
       msi.ORGANIZATION_ID            = INVENTARIO.ORGANIZATION_ID(+)   AND
       msi.INVENTORY_ITEM_ID          = INVENTARIO.INVENTORY_ITEM_ID(+) AND
       --msi.organization_id            = 92                              AND
       --msi.secondary_uom_code         = 'kg'                            and
       MSI.inventory_item_status_code <> 'Obsoleto'                     and
       MSI.inventory_item_status_code <> 'Inactive'                     and
      -- MSI.inventory_item_status_code <> 'Esgotamto'                    and
       --msi.segment1 like 'DPSZ-2S.57' AND
       msi.organization_id = 86 and
       msi.item_type like 'ACA%'; AND MSI.SEGMENT1 IN ('BP-01.20',
'A400.20',
'A400.48',
'F420.20',
'F398.05',
'D839.20',
'F341.20',
'F390.05',
'D800.20',
'D9022.3D',
'D9023.3D',
'F380.05',
'T494.63',
'T409.63',
'T413.75',
'T430.75',
'T432.75',
'T435.75',
'T444.75',
'T448.75',
'T456.75',
'T459.75',
'T490.75',
'T491.75',
'T406.75',
'T411.75',
'T412.75',
'T420.75',
'T427.75',
'T431.75',
'T438.75',
'T443.75',
'T447.75',
'T453.75',
'T454.75',
'T462.75',
'T471.63',
'T473.63',
'T474.75',
'T475.63',
'T476.63',
'T477.75',
'T479.75',
'F300.20',
'PRLX1.3A',
'PRLX2.3A',
'PRLX3.3A',
'PRLX4.3A',
'PRLX5.3A',
'PRLX6.3A',
'PRLX7.3A',
'C551-0220.18',
'C551-9446.17',
'C551-9800.17',
'DUL1800.17',
'DUL1800.18',
'A242.15',
'A652.18',
'A722.18',
'D8401.65',
'T497.65',
'C562-1143.06',
'C562-1150.17',
'F372.20',
'F372.48',
'F373.20',
'D807.20',
'T499.74');

       
       
       
SELECT msi.segment1
       --       
       FROM apps.mtl_system_items_b        msi
            --
 where msi.organization_id            = 92                              AND
       msi.segment1 like ',%.22', AND
       msi.item_type like ',ACA%',;       