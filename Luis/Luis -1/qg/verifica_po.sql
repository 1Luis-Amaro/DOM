select * --pla.TRANSACTION_reason_code ----pha.segment1
/*      --,pha.organization_id
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
      ,plla.line_location_id 
      ,pla.**/
  from apps.po_line_locations_all  plla
      ,apps.po_lines_all           pla
      ,apps.po_headers_all         pha
      ,apps.po_distributions_all   pda
where  pla.po_line_id        = plla.po_line_id
   and pda.line_location_id  in (424608,399896,378004,369166,378970,267746,371163)
   and pda.po_header_id      = plla.po_header_id
   and pha.po_header_id      = plla.po_header_id;

select * from apps.po_headers_all pha 
             ,apps.po_lines_all pla
             ,apps.po_line_locations_all  plla
        where pla.po_line_id        = plla.po_line_id and 
              pla.po_header_id = pha.po_header_id and 
              pha.segment1     = 'C-13596';

select * from apps.mtl_system_items_b where
       inventory_item_id = 13181;
select * /*,quantity_cancelled */ from apps.po_distributions_all where (po_header_id = 104512 and po_line_id = 146066) or (po_header_id = 259395 and po_line_id = 146714);