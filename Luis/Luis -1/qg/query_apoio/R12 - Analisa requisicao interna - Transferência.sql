select a.requisition_header_id,
       a.segment1,
       d.organization_code origem,
       e.organization_code destino,
       b.line_num,c.segment1,
       b.quantity,
       unit_price,
       base_unit_price,
       b.*
  from apps.po_requisition_headers_all a,
       apps.po_requisition_lines_all b,
       apps.mtl_system_items c,
       apps.mtl_parameters d,
       apps.mtl_parameters e
 where a.segment1 in ('85039') and -- Colocar o número da requisicao interna --
       a.requisition_header_id       = b.requisition_header_id and
       b.item_id                     = c.inventory_item_id     and 
       b.destinatioN_organizatioN_id = c.organization_id       and
       b.source_organization_id      = d.organization_id       and
       b.destinatioN_organizatioN_id = e.organization_id;

--- Pega número da Requisição Interna ** Campo orig_sys_document_ref deve ter apenas o número da Requisição --
select orig_sys_document_ref, ooh.*
from apps.oe_order_headers_all ooh
where order_number in ('717637');




5540 industrializacao
5437
5523
5409
5253
5561
5465
5464

83

select *
from apps.ra_customer_trx_all
where trx_number in ('108728')

select *
from apps.ra_customer_trx_lines_all
where customer_trx_id = 907920
and line_type = 'LINE'



where orig_sys_document_ref = '42443'

TRANSF_SUM-NTR_USO_DESPESA
TRANSF_SUM-NTR_IND


select *
from apps.oe_order_lines_all
--where order_number in ('704310','704320')
where header_id = 336318

select *
from apps.oe_headers_iface_all
where orig_sys_document_ref = 643700

select *
from apps.mtl_system_items
where inventory_item_id = 9594

704310 - 9/12/2015 09:16:18
704320 - 9/12/2015 16:18:51
