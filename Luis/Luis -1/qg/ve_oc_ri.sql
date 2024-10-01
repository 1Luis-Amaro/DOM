select pha.segment1
      ,pla.po_line_id
      ,pla.line_num
      ,pla.item_description
      ,pla.quantity
      ,pla.cancel_flag
      ,pla.cancelled_by
      ,pla.cancel_date
      ,pla.cancel_reason
      ,pla.closed_date
      ,pla.closed_reason
      ,pda.po_distribution_id,
      --cfi.*,
      plla.*
  from apps.cll_f189_invoice_lines cfil
      ,apps.cll_f189_invoices      cfi
      ,apps.po_line_locations_all  plla
      ,apps.po_lines_all           pla
      ,apps.po_headers_all         pha
      ,apps.po_distributions_all   pda
where cfi.invoice_num in ('22646') --22646 - 22680
   and cfi.organization_id   = 92
   and cfil.invoice_id       = cfi.invoice_id
   and cfil.organization_id  = cfi.organization_id 
   and plla.line_location_id = cfil.line_location_id
   and pla.po_line_id        = plla.po_line_id
   and pda.line_location_id  = cfil.line_location_id
   and pda.po_line_id        = pla.po_line_id
   and pda.po_header_id      = plla.po_header_id
   and pha.po_header_id      = plla.po_header_id
   and cfi.SERIES = '51';


select * from apps.po_headers_all         pha where po_header_id = 2394012;	1275117

select * from cll.cll_f189_invoices cfi where invoice_num = 9255;
select segment1 from apps.mtl_system_items_b where inventory_item_id = 1775808;
select * from apps.cll_f189_invoice_lines_iface cfl where line_location_id = 2412726;

---- Verificar interface do RI
select pha.segment1, pla.item_id, plla.*, pla.item_id, plla.quantity, plla.QUANTITY_BILLED, cfl.*
  from apps.CLL_F189_INVOICES_INTERFACE  cfii,
       apps.cll_f189_invoice_lines_iface cfl,
       apps.po_line_locations_all        plla,
       apps.po_lines_all                 pla,
       apps.po_headers_all               pha
 where cfii.invoice_num = 22646 and
       cfii.source      = 'SOFTWAY' AND
       --plla.CLOSED_CODE <> 'OPEN' AND
       cfii.interface_invoice_id    = cfl.interface_invoice_id and
       plla.line_location_id(+)     = cfl.line_location_id  and
       pla.po_line_id               = plla.po_line_id       and
       pha.po_header_id             = plla.po_header_id;
       and plla.line_location_id = 1695460;
       
select * from apps.po_line_locations_all        plla where po_header_id = 3501273;       

select * from apps.po_lines_all                 pla;
select * from apps.cll_f189_invoice_lines_iface cfl;

select * from apps.po_line_locations_all        plla where
plla.line_location_id = 2412726

SELECT * from apps.po_line_locations_all;

select * from apps.po_lines_all where po_line_id = 1725637

select segment1, organization_id from apps.mtl_system_items_b where inventory_item_id = 2021782 ;

select * from apps.po_line_locations_all        plla where po_line_id = 1566436

select * from apps.po_headers_all where po_header_id = 2394012

select * /*,quantity_cancelled */ from apps.po_distributions_all where (po_header_id = 104512 and po_line_id = 146066) or (po_header_id = 259395 and po_line_id = 146714);