select po_header_id, cancel_flag from apps.po_headers_all where segment1 IN ('56044','56007');

select po_header_id, CURRENCY_CODE, RATE, RATE_DATE  from apps.po_headers_all WHERE po_header_id IN (986171,986208);
select CURRENCY_CODE, RATE, RATE_DATE from apps.po_headers_archive_all WHERE po_header_id IN (986208);
-- Lines updated: 1
select po_header_id from apps.po_lines_all where po_header_id IN (986208);
select * /*, cancel_flag, cancelled_by, cancel_date, cancel_reason*/ from apps.po_lines_archive_all where po_header_id IN (986208);


select * from apps.po_line_locations_all where po_header_id IN (986208);

select po_header_id, RATE, RATE_DATE from apps.PO_DISTRIBUTIONS_ALL where po_header_id IN (986171,986208);



UPDATE apps.po_headers_all
   SET CURRENCY_CODE = 'EUR',
       RATE = 3.6925,
       RATE_DATE = to_date('23/05/2017','dd/mm/rrrr')
 WHERE po_header_id IN (986208);
/* 1 Line updated */
        
UPDATE apps.po_distributions_all
   SET RATE = 3.6925,
       RATE_DATE = to_date('23/05/2017','dd/mm/rrrr')
 WHERE po_header_id IN (986208);
/* 1 Line updated */		