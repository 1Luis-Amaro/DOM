SELECT primary_unit_of_measure, SECONDARY_UOM_CODE from apps.mtl_system_items_b where segment1 = ',D800.11',;

select decode(0,0,1) from dual;

select * from apps.mtl_parameters;

SELECT msi.segment1                    "Codigo do Item",
       mp.organization_code            "Codigo da Organizacao",
       TRANSLATE(TRANSLATE(TRANSLATE(SUBSTR(msi.description,1,180),'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890—¡…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’ƒÀœ÷‹«Ò·ÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ı‰ÎÔˆ¸Áñ|∫™≤∞.-!"''`#$%().:[/]{}®+???ø;ß&¥*<>'
                                                                  ,'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890NAEIOUAEIOUAEIOUAOAEIOUCnaeiouaeiouaeiouaoaeiouc-!'),CHR(10),' '),CHR(13),' ')
                                       "Descricao",
       inventario.segment2             "BU",
       (SELECT min(ffv.description)
          FROM apps.fnd_id_flexs              fif,
               apps.fnd_id_flex_structures_vl fifs,
               apps.fnd_id_flex_segments_vl   fifse,
               apps.fnd_flex_value_sets       ffvs,
               apps.fnd_flex_values_vl        ffv
         WHERE     fif.id_flex_code              = fifs.id_flex_code
               AND fifs.enabled_flag             = 'Y'
               AND fif.id_flex_code              = fifse.id_flex_code
               AND fifs.id_flex_num              = fifse.id_flex_num
               AND fif.application_id            = fifs.application_id
               AND fif.application_id            = fifse.application_id
               AND fifse.flex_value_set_id       = ffvs.flex_value_set_id
               AND fifs.id_flex_structure_code   = 'ITEM_CATEGORIES'
               AND fifse.application_column_name = 'SEGMENT3'
               AND fif.id_flex_name              = 'Item Categories'
               AND ffvs.flex_value_set_id        = ffv.flex_value_set_id
               AND TRUNC (SYSDATE) BETWEEN (DECODE (TRUNC (ffv.start_date_active),
                                                    NULL, TRUNC (SYSDATE),
                                                    TRUNC (ffv.start_date_active)))
                                       AND (DECODE (TRUNC (ffv.end_date_active),
                                                    NULL, TRUNC (SYSDATE),
                                                    TRUNC (ffv.end_date_active)))
               AND ffv.enabled_flag = 'Y'
               AND ffv.flex_value = inventario.segment3) "Prodct Line",
       msi.item_type                   "Tipo Item",
       msi.inventory_item_status_code  "Status do Item",
       msi.primary_uom_code            "UN Principal",
       msi.secondary_uom_code          "UN Secundaria",
       inventario.categoria            "Cat Inventario",
       msi.planner_code                "Planejador",
       DECODE(msi.planning_make_buy_code,2,'Comprado',1,'Fabricado')  "Comprado / Fabricado",
       cv2.CONVERSION_RATE             "Conversao kg",
       cv.CONVERSION_RATE              "Conversao Litro",
      (case inventario.segment1 
         when 'ACA'   then round((1 / nvl(cv2.CONVERSION_RATE ,1)),4)
         else null
       end)   "Envase em kg",
       --
      (case inventario.segment1 
         when 'ACA'   then round((1 / nvl(cv.CONVERSION_RATE ,1)),4)
         else null
       end)   "Envase em Litro"
       
       --(1 / nvl(cv.CONVERSION_RATE ,1))  "Envase Litro"
       
--        
       FROM apps.MTL_UOM_CLASS_CONVERSIONS cv,
            apps.MTL_UOM_CLASS_CONVERSIONS cv2,
            apps.mtl_system_items_b        msi,
            apps.mtl_parameters            mp,
           (SELECT MIC.INVENTORY_ITEM_ID,
                   MIC.ORGANIZATION_ID,
                   MIC.CATEGORY_SET_NAME,
                   MIC.CATEGORY_CONCAT_SEGS CATEGORIA,
                   MIC.SEGMENT1,
                   MIC.SEGMENT2,
                   MIC.SEGMENT3
              FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
             WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
               AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO
--
 where msi.organization_id            = mp.organization_id              AND
       cv.inventory_item_id(+)        = msi.inventory_item_id           AND
       cv.to_uom_code(+)              = 'l'                             AND
       cv2.inventory_item_id(+)       = msi.inventory_item_id           AND
       cv2.to_uom_code(+)             = 'kg'                            AND
       msi.ORGANIZATION_ID            = INVENTARIO.ORGANIZATION_ID(+)   AND
       msi.INVENTORY_ITEM_ID          = INVENTARIO.INVENTORY_ITEM_ID(+) AND
       msi.organization_id            in (92,86);  
       




Planejador
Comprado / Fabricado
fator CONSERV√O KG
CONVERS√O LT
VOLUME ENVASE KG
VOLUME ENVASE LT










                            AND
       --msi.segment1 like ',%.22', AND
       msi.item_type like 'ACA%' AND MSI.SEGMENT1 IN ('BP-01.20',
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