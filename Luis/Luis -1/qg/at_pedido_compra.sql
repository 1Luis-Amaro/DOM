select * from apps.po_headers_all where segment1 = '101406';

select cancel_flag, closed_code, closed_date from apps.po_headers_all WHERE po_header_id = 1062106;
select cancel_flag, closed_code, closed_date from apps.po_headers_archive_all WHERE po_header_id = 1062106;
-- Lines updated: 1
select closed_code, closed_date, closed_by from apps.po_lines_all where po_header_id = 1491800;
select * /*, cancel_flag, cancelled_by, cancel_date, cancel_reason*/ from apps.po_lines_archive_all where po_header_id = 1062106; AND CANCEL_FLAG = 'Y';
select * /*,quantity_cancelled */ from apps.po_distributions_all where po_header_id = 1062106;
select closed_clode, closed_reason, closed_date, closed_by, shipment_closed_date from apps.po_line_locations_all where po_header_id = 1062106;
select gl_cancelled_date from apps.PO_DISTRIBUTIONS_ARCHIVE_ALL where po_header_id = 905488 and gl_cancelled_date is not null;
select cancel_flag, cancelled_by cancel_date, cancel_reason from apps.PO_LINE_LOCATIONS_ARCHIVE_ALL where po_header_id = 905488 and cancel_flag = 'Y';



select closed_code, closed_date, closed_by from apps.po_lines_all where po_header_id = 1062106;
select closed_clode, closed_reason, closed_date, closed_by, shipment_closed_date from apps.po_line_locations_all where po_header_id = 1062106;




select * from apps.po_headers_all where segment1 = '101406';

select cancel_flag, closed_code, closed_date from apps.po_headers_all WHERE po_header_id = 1062106;
select cancel_flag, closed_code, closed_date from apps.po_headers_archive_all WHERE po_header_id = 1062106;
-- Lines updated: 1
select *from apps.po_lines_all where po_header_id = 1491800;
select * /*, cancel_flag, cancelled_by, cancel_date, cancel_reason*/ from apps.po_lines_archive_all where po_header_id = 1062106; AND CANCEL_FLAG = 'Y';
select * /*,quantity_cancelled */ from apps.po_distributions_all where po_header_id = 1491800;
select closed_clode, closed_reason, closed_date, closed_by, shipment_closed_date from apps.po_line_locations_all where po_header_id = 1062106;
select gl_cancelled_date from apps.PO_DISTRIBUTIONS_ARCHIVE_ALL where po_header_id = 905488 and gl_cancelled_date is not null;
select cancel_flag, cancelled_by cancel_date, cancel_reason from apps.PO_LINE_LOCATIONS_ARCHIVE_ALL where po_header_id = 905488 and cancel_flag = 'Y';



select closed_code, closed_date, closed_by from apps.po_lines_all where po_header_id = 1062106;
select closed_clode, closed_reason, closed_date, closed_by, shipment_closed_date from apps.po_line_locations_all where po_header_id = 1062106;UPDATE apps.po_headers_all

select authorization_status
, approved_flag
, user_hold_flag
, closed_code
,closed_date
, pha.*
 from apps.po_headers_all pha where segment1 = '101406'; 
 
select cancel_flag
, cancelled_by
, cancel_date
, cancel_reason
, closed_code
, closed_by
from  apps.po_lines_all
WHERE po_header_id in (1491800)
and org_id = 82;


select approved_flag
, cancel_flag
, cancelled_by
, cancel_date
, cancel_reason
, closed_code
, closed_date
, closed_by from apps.po_line_locations_all
where po_header_id in (1491800);
AND org_id = 82;
commit;

UPDATE apps.po_line_locations_all
SET approved_flag = 'Y'
, cancel_flag = NULL
, cancelled_by = NULL
, cancel_date = NULL
, cancel_reason = NULL
, closed_code = NULL
, closed_date = NULL
, closed_by = NULL
where po_header_id in (1491800);

commit;



commit;

 
 

SET authorization_status = 'APPROVED'
, approved_flag = 'Y'
, user_hold_flag = NULL
, closed_code = NULL
,closed_date = NULL
WHERE po_header_id in (1069113, 1069119,1125242);
AND org_id = 82;
commit;
