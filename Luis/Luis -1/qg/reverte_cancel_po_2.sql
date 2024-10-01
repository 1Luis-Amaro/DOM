85536
87794 
84706
83571

select po_header_id, cancel_flag from apps.po_headers_all where segment1 in ('99880');

select cancel_flag, closed_code, closed_date from apps.po_headers_all WHERE po_header_id = 1471840;
select cancel_flag, closed_code, closed_date from apps.po_headers_archive_all WHERE po_header_id = 1471840 and cancel_flag = 'Y';
-- Lines updated: 1
select * /*, cancel_flag, cancelled_by, cancel_date, cancel_reason*/ from apps.po_lines_all where po_header_id = 1471840;
select * /*, cancel_flag, cancelled_by, cancel_date, cancel_reason*/ from apps.po_lines_archive_all where po_header_id = 1471840 AND CANCEL_FLAG = 'Y';
select * /*,quantity_cancelled */ from apps.po_distributions_all where po_header_id = 1471840;
select * /*,quantity_cqncelled, cancel_flag, cancelled_by cancel_date cancel_reason */ from apps.po_line_locations_all where po_header_id = 1471840;
select gl_cancelled_date from apps.PO_DISTRIBUTIONS_ARCHIVE_ALL where po_header_id = 1471840 and gl_cancelled_date is not null;
select cancel_flag, cancelled_by cancel_date, cancel_reason from apps.PO_LINE_LOCATIONS_ARCHIVE_ALL where po_header_id = 1471840 and cancel_flag = 'Y';

UPDATE apps.po_headers_all
   SET cancel_flag = 'N',
       closed_code = 'OPEN',
       closed_date = NULL,
       ship_to_organization_id = 92,
       ship_to_location_id     = 142
 WHERE po_header_id in (1471840);
-- Lines updated: 4

UPDATE apps.po_headers_archive_all
   SET cancel_flag = 'N',
       closed_code = 'OPEN',
       closed_date = NULL,
       ship_to_organization_id = 92,
       ship_to_location_id     = 142
 WHERE po_header_id in (1471840)
   AND cancel_flag  = 'Y';
-- Lines updated: 1

UPDATE apps.po_lines_all 
   SET cancel_flag   = NULL,
       cancelled_by  = NULL,
       cancel_date   = NULL,
       cancel_reason = NULL,
       ship_to_organization_id = 92,
       ship_to_location_id     = 142
 WHERE po_header_id in (1471840)
   AND cancel_flag  = 'Y';
/**** 1 line updated ****/

UPDATE apps.po_lines_archive_all 
   SET cancel_flag   = NULL,
       cancelled_by  = NULL,
       cancel_date   = NULL,
       cancel_reason = NULL,
       ship_to_organization_id = 92,
       ship_to_location_id     = 142
 WHERE po_header_id in (1471840)
   AND cancel_flag  = 'Y';
/**** 1 line updated ****/

UPDATE apps.po_distributions_all
   SET quantity_cancelled = NULL,
       gl_cancelled_date = NULL,
       destination_organization_id = 92,
       deliver_to_location_id      = 142
 WHERE po_header_id in (1471840);
/**** 1 line updated ****/

UPDATE apps.po_distributions_archive_all
   SET quantity_cancelled = NULL,
       gl_cancelled_date = NULL,
       destination_organization_id = 92,
       deliver_to_location_id      = 142
 WHERE po_header_id in (1471840) and
       gl_cancelled_date IS NOT NULL;
/**** 1 line update ****/

UPDATE apps.po_line_locations_all
   SET quantity_cancelled = NULL,
       cancel_flag = NULL,
       cancelled_by = NULL,
       cancel_date = NULL,
       cancel_reason = NULL,
       ship_to_organization_id = 92,
       ship_to_location_id     = 142
 WHERE po_header_id in (1471840)
   AND cancel_flag  = 'Y';
/**** 1 line updated ****/

UPDATE apps.po_line_locations_archive_all
   SET quantity_cancelled = NULL,
       cancel_flag = NULL,
       cancelled_by = NULL,
       cancel_date = NULL,
       cancel_reason = NULL,
       ship_to_organization_id = 92,
       ship_to_location_id     = 142
 WHERE po_header_id in (1471840) AND
       cancel_flag = 'Y';
/**** 1 line updated ****/

------------ VERIFICA QUANTIDADE DE LINHAS A SEREM REVERTIDAS EM CADA UPDATE ------------
select cancel_flag,
       closed_code,
       closed_date 
  from apps.po_headers_all
 WHERE po_header_id in (1471840);
-- Lines updated: 1

select cancel_flag,
       closed_code,
       closed_date
  from apps.po_headers_archive_all
 WHERE po_header_id in (1471840)
   AND cancel_flag  = 'Y';
-- Lines updated: 1

select cancel_flag,
       cancelled_by,
       cancel_date,
       cancel_reason
  from apps.po_lines_all 
 WHERE po_header_id in (1471840)
   AND cancel_flag  = 'Y';
/**** 1 line updated ****/

select cancel_flag,
       cancelled_by,
       cancel_date,
       cancel_reason
  from apps.po_lines_archive_all 
 WHERE po_header_id in (1471840)
   AND cancel_flag  = 'Y';
/**** 1 line updated ****/

select quantity_cancelled,
       gl_cancelled_date
  from apps.po_distributions_all
 WHERE po_header_id in (1471840);
/**** 1 line updated ****/

select quantity_cancelled,
       gl_cancelled_date
 from apps.po_distributions_archive_all
 WHERE po_header_id in (1471840) and
       gl_cancelled_date IS NOT NULL;
/**** 1 line update ****/

select quantity_cancelled,
       cancel_flag ,
       cancelled_by,
       cancel_date ,
       cancel_reason
  from apps.po_line_locations_all
 WHERE po_header_id in (1471840)
   AND cancel_flag  = 'Y';
/**** 1 line updated ****/

select quantity_cancelled,
       cancel_flag,
       cancelled_by,
       cancel_date ,
       cancel_reason
  from apps.po_line_locations_archive_all
 WHERE po_header_id in (1471840) AND
       cancel_flag = 'Y';
/**** 1 line updated ****/


----------------- ALTERA LOCAL DE ENTREGA ---------------

UPDATE apps.po_headers_all
   SET cancel_flag = 'N',
       closed_code = 'OPEN',
       closed_date = NULL,
       ship_to_location_id     = 142,
       bill_to_location_id     = 142
 WHERE po_header_id in (1471840);
-- Lines updated: 1

UPDATE apps.po_headers_archive_all
   SET cancel_flag = 'N',
       closed_code = 'OPEN',
       closed_date = NULL,
       ship_to_location_id     = 142,
       bill_to_location_id     = 142
 WHERE po_header_id in (1471840)
   AND cancel_flag  = 'Y';
-- Lines updated: 1

UPDATE apps.po_lines_all 
   SET cancel_flag   = NULL,
       cancelled_by  = NULL,
       cancel_date   = NULL,
       cancel_reason = NULL
 WHERE po_header_id in (1471840)
   AND cancel_flag  = 'Y';
/**** 1 line updated ****/

UPDATE apps.po_lines_archive_all 
   SET cancel_flag   = NULL,
       cancelled_by  = NULL,
       cancel_date   = NULL,
       cancel_reason = NULL
 WHERE po_header_id in (1471840)
   AND cancel_flag  = 'Y';
/**** 1 line updated ****/

UPDATE apps.po_distributions_all
   SET quantity_cancelled = NULL,
       gl_cancelled_date = NULL,
       destination_organization_id = 92,
       deliver_to_location_id      = 142
 WHERE po_header_id in (1471840);
/**** 1 line updated ****/

UPDATE apps.po_distributions_archive_all
   SET quantity_cancelled = NULL,
       gl_cancelled_date = NULL,
       destination_organization_id = 92,
       deliver_to_location_id      = 142
 WHERE po_header_id in (1471840) and
       gl_cancelled_date IS NOT NULL;
/**** 1 line update ****/

UPDATE apps.po_line_locations_all
   SET quantity_cancelled = NULL,
       cancel_flag = NULL,
       cancelled_by = NULL,
       cancel_date = NULL,
       cancel_reason = NULL,
       ship_to_organization_id = 92,
       ship_to_location_id     = 142
 WHERE po_header_id in (1471840)
   AND cancel_flag  = 'Y';
/**** 1 line updated ****/

UPDATE apps.po_line_locations_archive_all
   SET quantity_cancelled = NULL,
       cancel_flag = NULL,
       cancelled_by = NULL,
       cancel_date = NULL,
       cancel_reason = NULL,
       ship_to_organization_id = 92,
       ship_to_location_id     = 142
 WHERE po_header_id in (1471840) AND
       cancel_flag = 'Y';
/**** 1 line updated ****/



































begin
--fnd_global.apps_initialize(:P_USER_ID,:P_RESP_ID,:P_RESP_APPL_ID);
fnd_global.apps_initialize(1353, 50595, 222);
end;


282921
282914

20103





UPDATE apps.po_distributions_all
   SET QUANTITY_CANCELLED = 0,
       GL_CANCELLED_DATE  = NULL
 WHERE po_line_id = 116654 AND quantity_cancelled > 0;
-- Lines updated: 1


UPDATE apps.PO_DISTRIBUTIONS_ARCHIVE_ALL
   SET QUANTITY_CANCELLED = 0,
       GL_CANCELLED_DATE  = NULL
 WHERE po_line_id = 116654 AND QUANTITY_CANCELLED > 0;
-- Lines updated: 1


UPDATE apps.po_line_locations_all
   SET QUANTITY_CANCELLED = 0,
       CANCEL_FLAG    = 'N',
       CANCELLED_BY   = NULL,
       CANCEL_REASON  = NULL,
       CLOSED_CODE    = 'OPEN',
       CLOSED_REASON  = NULL,
       CLOSED_DATE    = NULL,
       CLOSED_BY      = NULL,
       CLOSED_FOR_INVOICE_DATE = NULL,
       SHIPMENT_CLOSED_DATE    = NULL
 WHERE po_line_id = 116654;
-- Lines updated: 1


UPDATE apps.PO_LINE_LOCATIONS_ARCHIVE_ALL
   SET QUANTITY_CANCELLED = 0,
       CANCEL_FLAG   = 'N',
       CANCEL_DATE   = NULL,
       CANCELLED_BY  = NULL,
       CANCEL_REASON = NULL,
       CLOSED_CODE   = 'OPEN',
       CLOSED_REASON = NULL,
       CLOSED_DATE   = NULL,
       CLOSED_BY     = NULL
 WHERE po_line_id = 116654 AND CANCEL_FLAG = 'Y';
-- Lines updated: 1

UPDATE apps.po_lines_all
   SET cancel_flag   = 'N',
       cancelled_by  = NULL,
       cancel_date   = NULL,
       cancel_reason = NULL,
       closed_code   = 'OPEN',
       closed_date   = NULL,
       closed_reason = null,
       closed_by     = null 
 WHERE po_line_id = 116654;
-- Lines updated: 1


UPDATE apps.po_lines_archive_all
   SET cancel_flag   = 'N',
       cancelled_by  = NULL,
       cancel_date   = NULL,
       cancel_reason = NULL,
       closed_code   = 'OPEN',
       closed_date   = NULL,
       closed_reason = null,
       closed_by     = null 
 WHERE po_line_id = 116654 AND CANCEL_FLAG = 'Y';
-- Lines updated: 1


UPDATE apps.po_headers_all
   SET cancel_flag = 'N',
       closed_code = 'OPEN',
       closed_date = NULL
 WHERE po_header_id = 193913;
-- Lines updated: 1


UPDATE apps.po_headers_archive_all
   SET cancel_flag = 'N',
       closed_code = 'OPEN',
       closed_date = NULL
 WHERE po_header_id = 193913 AND cancel_flag = 'Y';
-- Lines updated: 1


