select 
  closed_code
, closed_date
 from apps.po_headers_all pha where po_header_id = 1052815; 
 

select 
  closed_code
, closed_by
, closed_date
, CLOSED_REASON, pla.*
from  apps.po_lines_all pla
WHERE po_header_id in (1052815)
and org_id = 82;


select closed_code
     , closed_date
     , closed_by
     , closed_reason  
  from apps.po_line_locations_all plla
where po_header_id in (1052815);


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
where po_header_id in (1458805);











--1 Script
UPDATE apps.po_headers_all
  SET authorization_status = 'APPROVED'
    , approved_flag = 'Y'
    , user_hold_flag = NULL
    , closed_code = NULL
    ,closed_date = NULL
 WHERE po_header_id in (1482835);
--- 1 line update

--2 Script
UPDATE apps.po_lines_all
   SET cancel_flag = NULL
     , cancelled_by = NULL
     , cancel_date = NULL
     , cancel_reason = NULL
     , closed_code = NULL
     , closed_by = NULL
 WHERE po_header_id = 1482835;
--- 1 Line Update

--3 Script
UPDATE apps.po_line_locations_all
   SET approved_flag = 'Y'
     , cancel_flag = NULL
     , cancelled_by = NULL
     , cancel_date = NULL
     , cancel_reason = NULL
     , closed_code = NULL
     , closed_date = NULL
     , closed_by = NULL
 where po_header_id = 1482835;
--1 Line update










--1 Script
select COMMENTS,
       CLOSED_DATE,
       CLOSED_CODE
 from apps.po_headers_all
 WHERE po_header_id in (1052815);
--- 1 line update

--2 Script
select CLOSED_CODE,
       CLOSED_REASON,
       CLOSED_DATE from apps.po_lines_all
 WHERE po_header_id = 1052815;
--- 1 Line Update

--3 Script
select CLOSED_CODE,
       CLOSED_REASON,
       CLOSED_DATE,
       SHIPMENT_CLOSED_DATE,
       CLOSED_FOR_RECEIVING_DATE  from apps.po_line_locations_all
 where po_header_id = 1052815;
--1 Line update



-------- Reabre pedido fechado pela rotina que fecha por ter mais de 13 meses da abertura da OC -----

--1 Script
UPDATE apps.po_headers_all
   SET COMMENTS    = NULL,
       CLOSED_DATE = NULL,
       CLOSED_CODE = 'OPEN'
 WHERE po_header_id in (1052815);
--- 1 line update

--2 Script
UPDATE apps.po_lines_all
   SET CLOSED_CODE   = 'OPEN',
       CLOSED_REASON = NULL,
       CLOSED_DATE   = NULL
 WHERE po_header_id = 1052815;
--- 1 Line Update

--3 Script
UPDATE apps.po_line_locations_all
   SET CLOSED_CODE               = 'OPEN',   
       CLOSED_REASON             = NULL,
       CLOSED_DATE               = NULL,
       SHIPMENT_CLOSED_DATE      = NULL,
       CLOSED_FOR_RECEIVING_DATE = NULL
 where po_header_id = 1052815;
--1 Line update
CLL_F189_HOLDS_CUSTOM_PKG

----


UPDATE apps.po_headers_all
   SET cancel_flag = 'N',
       closed_code = 'OPEN',
       closed_date = NULL
WHERE po_header_id in (1010428, 1052815);
-- Lines updated: 1
 
UPDATE apps.po_headers_archive_all
   SET cancel_flag = 'N',
       closed_code = 'OPEN',
       closed_date = NULL
WHERE po_header_id in (1010428, 1052815)
   AND cancel_flag  = 'Y';
-- Lines updated: 1
 
UPDATE apps.po_lines_all
   SET cancel_flag   = NULL,
       cancelled_by  = NULL,
       cancel_date   = NULL,
       cancel_reason = NULL
WHERE po_header_id in (1010428, 1052815)
   AND cancel_flag  = 'Y';
/**** 2 lines updated ****/
 
UPDATE apps.po_lines_archive_all
   SET cancel_flag   = NULL,
       cancelled_by  = NULL,
       cancel_date   = NULL,
       cancel_reason = NULL
WHERE po_header_id in (1010428, 1052815)
   AND cancel_flag  = 'Y';
/**** 2 lines updated ****/
 
UPDATE apps.po_distributions_all
   SET quantity_cancelled = NULL,
       gl_cancelled_date = NULL
WHERE po_header_id in (1010428, 1052815);
/**** 2 line updated ****/
 
UPDATE apps.po_distributions_archive_all
   SET quantity_cancelled = NULL,
       gl_cancelled_date = NULL
WHERE po_header_id in (1010428, 1052815) and
       gl_cancelled_date IS NOT NULL;
/**** 2 lines update ****/
 
UPDATE apps.po_line_locations_all
   SET quantity_cancelled = NULL,
       cancel_flag = NULL,
       cancelled_by = NULL,
       cancel_date = NULL,
       cancel_reason = NULL
WHERE po_header_id in (1010428, 1052815)
   AND cancel_flag  = 'Y';
/**** 2 lines updated ****/
 
UPDATE apps.po_line_locations_archive_all
   SET quantity_cancelled = NULL,
       cancel_flag = NULL,
       cancelled_by = NULL,
       cancel_date = NULL,
       cancel_reason = NULL
WHERE po_header_id in (1010428, 1052815) AND
       cancel_flag = 'Y';
/**** 2 lines updated ****/


------

select * from apps.po_headers_all
WHERE po_header_id in (1010428, 1052815);
-- Lines updated: 1
 
select * from  apps.po_headers_archive_all
WHERE po_header_id in (1010428, 1052815) AND
      cancel_flag  = 'Y';
-- Lines updated: 1
 
select * from  apps.po_lines_all
WHERE po_header_id in (1010428, 1052815);
   AND cancel_flag  = 'Y';
/**** 2 lines updated ****/
 
select * from  apps.po_lines_archive_all
WHERE po_header_id in (1010428, 1052815);
   AND cancel_flag  = 'Y';
/**** 2 lines updated ****/
 
select * from  apps.po_distributions_all
WHERE po_header_id in (1010428, 1052815);
/**** 2 line updated ****/
 
select * from  apps.po_distributions_archive_all
WHERE po_header_id in (1010428, 1052815) and
       gl_cancelled_date IS NOT NULL;
/**** 2 lines update ****/
 
select * from  apps.po_line_locations_all
WHERE po_header_id in (1010428, 1052815)
   AND cancel_flag  = 'Y';
/**** 2 lines updated ****/
 
select * from  apps.po_line_locations_archive_all
WHERE po_header_id in (1010428, 1052815) AND
       cancel_flag = 'Y';
/**** 2 lines updated ****/
