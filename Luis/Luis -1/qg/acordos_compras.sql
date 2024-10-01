SELECT pha.segment1 "Item",
       msi.segment1 "Acordo",
       mp.organization_code,
       msi.global_attribute2 "Tipo Transacao ITEM",
       hlv.inventory_organization_id,
       transaction_reason_code "Tipo Transacao Acordo",
       pha.end_date
  FROM apps.po_headers_all     pha,
       apps.po_lines_all       pla,
       apps.hr_locations_v     hlv,
       apps.mtl_system_items_b msi,
       apps.mtl_parameters     mp
 WHERE pla.po_header_id               = pha.po_header_id              AND
       mp.organization_id             = msi.organization_id           AND
       msi.inventory_item_id          = pla.item_id                   AND
       msi.organization_id            = hlv.inventory_organization_id AND
       pla.cancel_flag                = 'N'                           AND
       pha.cancel_flag                = 'N'                           AND
     --  pha.closed_code                = 'OPEN'                        AND
       NVL(pha.end_date,SYSDATE + 1) >= SYSDATE                       AND
       hlv.location_id                = pha.ship_to_location_id       AND
       pha.type_lookup_code           = 'BLANKET';
       
select * from HR_LOCATIONS_V ;       