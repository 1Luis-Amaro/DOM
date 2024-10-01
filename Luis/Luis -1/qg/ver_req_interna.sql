select a.segment1,d.organization_code origem,e.organization_code destino,b.line_num,c.segment1,b.quantity,unit_price,base_unit_price,b.*
from apps.po_requisition_headers_all a,
    apps.po_requisition_lines_all b,
    apps.mtl_system_items c,
    apps.mtl_parameters d,
    apps.mtl_parameters e
where a.segment1 in ('23237')
and a.requisition_header_id = b.requisition_header_id
and b.item_id = c.inventory_item_id
and b.destinatioN_organizatioN_id = c.organization_id
and b.source_organization_id = d.organization_id
and b.destinatioN_organizatioN_id = e.organization_id 