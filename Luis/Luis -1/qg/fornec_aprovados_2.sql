-- Listagem da Qualidade para avaliaÁ„o dos itens em Skip Lote. ----

select msi.segment1,
       msi.inventory_item_status_code,
       mp.organization_code,
       PV.VENDOR_NAME,
       SUBSTR (PVS.global_attribute10, 2, 2)
       || '.'
       || SUBSTR (PVS.global_attribute10, 4, 3)
       || '.'
       || SUBSTR (PVS.global_attribute10, 7, 3)
       || '/'
       || PVS.global_attribute11
       || '-'
       || PVS.global_attribute12
   CNPJ,       
       ast.STATUS,
       QSC.process_code,
       inventario.categoria,
       armaz.segment2,
       qsc.*,
       TRANSLATE(TRANSLATE(SUBSTR(MSI.DESCRIPTION,1,80),'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890—¡…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’ƒÀœ÷‹«Ò·ÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ı‰ÎÔˆ¸Áñ∫™≤∞.-!"''`#$%().:[/]{}®+???ø;ß&¥*<>'
                                                       ,'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890NAEIOUAEIOUAEIOUAOAEIOUCnaeiouaeiouaeiouaoaeiouc-'),CHR(10),' ') "Descricao"
--
  from apps.PO_VENDORS                   PV,         
       apps.PO_VENDOR_SITES_ALL          PVS,
       apps.PO_APPROVED_SUPPLIER_LIST    PAS,
       apps.PO_ASL_STATUSES              AST,
       apps.MTL_PARAMETERS               MP,
       apps.mtl_system_items_b           msi,
       apps.QA_SL_SP_RCV_CRITERIA_V      qss,
       apps.QA_SL_CRITERIA_ASSOCIATION_V qsc,
       (SELECT mic.inventory_item_id,
               mic.organization_id,
               mic.category_set_name,
               mic.category_concat_segs categoria
          FROM apps.mtl_item_categories_v mic, apps.mtl_categories_v mc
         WHERE mc.category_id = mic.category_id
           AND mic.category_set_name IN ('Inventory')) inventario,
       (SELECT mic.inventory_item_id,
               mic.organization_id,
               mic.category_set_name,
               mic.segment2,
               mic.category_concat_segs categoria
          FROM apps.mtl_item_categories_v mic, apps.mtl_categories_v mc
         WHERE mc.category_id = mic.category_id
           AND mic.category_set_name IN ('FAMILIA ARMAZENAGEM')) armaz
--           
--       
 where
       pv.vendor_id          = pas.vendor_id                   AND
       pvs.vendor_site_id    = pas.vendor_site_id              AND
       mp.organization_id    = msi.organization_id             AND
      -- msi.organization_id   in (92)                           AND
       msi.inventory_item_id = pas.item_id                     AND
       msi.organization_id   = pas.owning_organization_id      AND
       qsc.criteria_id(+)    = qss.criteria_id                 AND
       qss.vendor_id(+)      = pas.vendor_id                   AND
       qss.item_id(+)        = pas.item_id                     AND
       ast.status_id         = pas.asl_status_id               AND
       MSI.ORGANIZATION_ID   = INVENTARIO.ORGANIZATION_ID(+)   AND
       MSI.INVENTORY_ITEM_ID = INVENTARIO.INVENTORY_ITEM_ID(+) AND
       MSI.ORGANIZATION_ID   = ARMAZ.ORGANIZATION_ID(+)   AND
       MSI.INVENTORY_ITEM_ID = ARMAZ.INVENTORY_ITEM_ID(+);

select * from apps.QA_SL_CRITERIA_ASSOCIATION_V ORDER BY CRITERIA_ID; 

FAMILIA ARMAZENAGEM

select * from apps.QA_SL_SP_RCV_CRITERIA_V ORDER BY CRITERIA_ID; 

select * from apps.PO_VENDOR_SITES_all              PVS;

select * from apps.PO_VENDORS              PV;

select count(*) from apps.PO_APPROVED_SUPPLIER_LIST    PAS where owning_organization_id = 86;

select * from apps.PO_ASL_SUPPLIERS_V;


select pas.owning_organization_name,
       pas.vendor_name,
       pas.vendor_business_type_dsp,
       pas.vendor_site_code,
       pas.primary_vendor_item,
       pas.asl_status_dsp,
       pas.vendor_id 
  from apps.PO_ASL_SUPPLIERS_V           pas;
  
select * from apps.PO_ASL_STATUSES;  