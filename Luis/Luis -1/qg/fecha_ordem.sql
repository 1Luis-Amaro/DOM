select po_header_id, cancel_flag from apps.po_headers_all where segment1 = '58993';

select * from apps.po_headers_all WHERE po_header_id = 257990;547183;
select cancel_flag, closed_code, closed_date from apps.po_headers_archive_all WHERE po_header_id = 547183; and cancel_flag = 'Y';
-- Lines updated: 1
select pll.* /*, cancel_flag, cancelled_by, cancel_date, cancel_reason*/ from apps.po_lines_all pll where po_header_id = 257990;
select * /*, cancel_flag, cancelled_by, cancel_date, cancel_reason*/ from apps.po_lines_archive_all where po_header_id = 259395; and po_line_id in (158420); AND CANCEL_FLAG = 'Y';
select * /*,quantity_cancelled */ from apps.po_distributions_all WHERE po_header_id = 259395 AND
       po_line_id   = 159618;
select * /*,quantity_cqncelled, cancel_flag, cancelled_by cancel_date cancel_reason */ from apps.po_line_locations_all where po_header_id = 259395; and po_line_id in (144798,158420);
select gl_cancelled_date from apps.PO_DISTRIBUTIONS_ARCHIVE_ALL where po_header_id = 257990 and gl_cancelled_date is not null and po_line_id in (144798);
select cancel_flag, cancelled_by cancel_date, cancel_reason from apps.PO_LINE_LOCATIONS_ARCHIVE_ALL where po_header_id = 257990 and po_line_id in (144798,158420); and cancel_flag = 'Y';


select closed_reason from apps.po_line_locations_all where po_header_id = 257990 and line_location_id = 309239;


32247 -- Item CMPP3700A.22 - Fechar
2945  -- WC-86-3660 - Quant 180 kg - Linha 6 - Fechar
10431 -- item RM-25-6122 - Quantidade 800 kg não sei se a linha 5 ou 6 - Preciso finalizar até 02/05
9922  -- item TK-62-1200 - Quantidade 720 kg - linha 1
58993 -- Item KCX-8714



-- aqui
update apps.po_line_locations_all
  set closed_code = 'CLOSED FOR RECEIVING',
      closed_date = sysdate
 where po_header_id     = 257990 and
       line_location_id = 309239;
--
UPDATE apps.po_lines_all 
   SET closed_code = 'CLOSED FOR RECEIVING',
      closed_date = sysdate
 WHERE po_header_id = 259395 AND
       po_line_id   = 159618;
/**** 1 line updated ****/

UPDATE apps.po_line_locations_all 
   SET closed_code = 'CLOSED FOR RECEIVING',
      closed_date = sysdate
 WHERE po_header_id = 259395 AND
       po_line_id   = 159618;
/**** 1 line updated ****/



UPDATE apps.po_distributions_all
   SET quantity_cancelled = quantity_ordered,
       gl_cancelled_date  = sysdate
 WHERE po_header_id = 259395 AND
       po_line_id   = 159618;
/**** 1 line updated ****/



select closed_code from apps.po_line_locations_all;

UPDATE apps.po_headers_all
   SET cancel_flag = 'N',
       closed_code = 'OPEN',
       closed_date = NULL
 WHERE po_header_id = 905488;
-- Lines updated: 1

UPDATE apps.po_headers_archive_all
   SET cancel_flag = 'N',
       closed_code = 'OPEN',
       closed_date = NULL
 WHERE po_header_id = 905488
   AND cancel_flag  = 'Y';
-- Lines updated: 1

UPDATE apps.po_lines_all 
   SET cancel_flag   = NULL,
       cancelled_by  = NULL,
       cancel_date   = NULL,
       cancel_reason = NULL
 WHERE po_header_id = 905488;
/**** 1 line updated ****/

UPDATE apps.po_lines_archive_all 
   SET cancel_flag   = NULL,
       cancelled_by  = NULL,
       cancel_date   = NULL,
       cancel_reason = NULL
 WHERE po_header_id = 905488
   AND cancel_flag  = 'Y';
/**** 1 line updated ****/

UPDATE apps.po_distributions_all
   SET quantity_cancelled = NULL,
       gl_cancelled_date = NULL
 WHERE po_header_id = 905488;
/**** 1 line updated ****/

UPDATE apps.po_distributions_archive_all
   SET quantity_cancelled = NULL,
       gl_cancelled_date = NULL
 WHERE po_header_id = 905488 and
       gl_cancelled_date IS NOT NULL;
/**** 1 line update ****/

UPDATE apps.po_line_locations_all
   SET quantity_cancelled = NULL,
       cancel_flag = NULL,
       cancelled_by = NULL,
       cancel_date = NULL,
       cancel_reason = NULL
 WHERE po_header_id = 905488;
/**** 1 line updated ****/

UPDATE apps.po_line_locations_archive_all
   SET quantity_cancelled = NULL,
       cancel_flag = NULL,
       cancelled_by = NULL,
       cancel_date = NULL,
       cancel_reason = NULL
 WHERE po_header_id = 905488 AND
       cancel_flag = 'Y';
/**** 1 line updated ****/


-------------------------------------------------------

select closed_code, closed_date, po_line_id from apps.po_lines_all 
 WHERE po_header_id = 1006306; and po_line_id = 158420; AND
       po_line_id   = 159618;
/**** 1 line updated ****/

select closed_code,closed_date from apps.po_line_locations_all 
 WHERE po_header_id = 1006306; and po_line_id = 158420; AND
       po_line_id   = 159618;
/**** 1 line updated ****/

-----  Teste do Select com Número de linhas.

select closed_code, closed_date, po_line_id from apps.po_lines_all 
 WHERE po_header_id = 727543 or
      (po_header_id = 257990 and po_line_id = 158420) or
      (po_header_id = 259395 and po_line_id = 159618) or
      (po_header_id = 80494 and
       (po_line_id = 50998 or po_line_id = 143743));
/**** 1 line updated ****/

select closed_code,closed_date from apps.po_line_locations_all 
 WHERE po_header_id = 727543 or
      (po_header_id = 257990 and po_line_id = 158420) or
      (po_header_id = 259395 and po_line_id = 159618) or
      (po_header_id = 80494 and
       (po_line_id = 50998 or po_line_id = 143743));
/**** 1 line updated ****/




      po_header_id = 80494 and
      (po_line_id = 50998 or po_line_id = 143743)



----------------- abri datafix


UPDATE apps.po_lines_all 
   SET closed_code = 'CLOSED FOR RECEIVING',
      closed_date = sysdate
 WHERE po_header_id = 727543 or
      (po_header_id = 257990 and po_line_id = 158420) or
      (po_header_id = 259395 and po_line_id = 159618) or
      (po_header_id = 80494 and
       (po_line_id = 50998 or po_line_id = 143743));
/**** 1 line updated ****/

UPDATE apps.po_line_locations_all 
   SET closed_code = 'CLOSED FOR RECEIVING',
      closed_date = sysdate
  WHERE po_header_id = 727543 or
       (po_header_id = 257990 and po_line_id = 158420) or
       (po_header_id = 259395 and po_line_id = 159618) or
       (po_header_id = 80494 and
        (po_line_id = 50998 or po_line_id = 143743));
/**** 1 line updated ****/