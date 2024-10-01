
select po_header_id, cancel_flag from apps.po_headers_all where segment1 = '68807';

select requisition_header_id from 
       apps.po_distributions_all     pd,
       po.po_requisition_lines_all   prl,
--       po.po_requisition_headers_all prh,
       po.po_req_distributions_all   prd
 where pd.req_distribution_id  = prd.distribution_id(+) and
       prd.requisition_line_id = prl.requisition_line_id(+)  and
       pd.po_header_id = 1055046;

po.po_requisition_lines_all prl

452667

pd.req_distribution_id

UPDATE po.po_requisition_lines_all
   SET suggested_buyer_id = 818
 WHERE requisition_header_id = 772701;
