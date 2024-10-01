select * from apps.mtl_system_items_b_ext where inventory_item_id = 2979;

select inventory_item_id from apps.mtl_system_items_b where segment1 = 'F300.20'

select count(*) from apps.mtl_system_items_b_ext msie;

select msi.segment1,
       msi.item_type,
       TRANSLATE(TRANSLATE(SUBSTR(MSI.DESCRIPTION,1,80),'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890—¡…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’ƒÀœ÷‹«Ò·ÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ı‰ÎÔˆ¸Áñ∫™≤∞.-!"''`#$%().:[/]{}®+???ø;ß&¥*<>'
                                                       ,'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890NAEIOUAEIOUAEIOUAOAEIOUCnaeiouaeiouaeiouaoaeiouc-'),CHR(10),' ') "Descricao",
       msi.inventory_item_status_code,
       inventario.categoria,
       msi.global_attribute10 EAN_Item,
       msie.attribute1 EAN_DE,
       msie.attribute2 EAN_PARA,
       xref.CROSS_REFERENCE DUN_ITEM,
       msie.attribute3 DUN_DE,
       msie.attribute4 DUN_PARA
  from apps.mtl_system_items_b_ext msie,
       apps.mtl_system_items_b     msi,
       (SELECT xrf.cross_reference, xrf.inventory_item_id
          FROM APPS.MTL_CROSS_REFERENCES_V XRF
         WHERE xrf.CROSS_REFERENCE_TYPE = 'DUN14') xref,
       (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO
 where --msie.inventory_item_id = 1168 and
       msi.inventory_item_id  = msie.inventory_item_id(+)     and
       msi.organization_id    = 87                            and
       msi.inventory_item_id  = xref.inventory_item_id(+)     and
       msi.global_attribute10 is not null                     and
       MSI.ORGANIZATION_ID    = INVENTARIO.ORGANIZATION_ID(+) and
       MSI.INVENTORY_ITEM_ID  = INVENTARIO.INVENTORY_ITEM_ID(+)
       AND MSI.segment1 IN ('D800.10','C551-9446.17')
       order by 8;
       
select item_type, organization_id from apps.mtl_system_items where segment1 = 'AP14705'       

SELECT * from apps.MTL_SYSTEM_ITEMS_INTERFACE;