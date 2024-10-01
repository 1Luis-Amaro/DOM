select cancel_flag from apps.po_headers_all where segment1 = '7498';
select * /*, cancel_flag, cancelled_by, cancel_date, cancel_reason*/ from apps.po_lines_all where po_header_id = 198857;
select * /*,quantity_cancelled */ from apps.po_distributions_all where po_header_id = 198857;
select * /*,quantity_cqncelled, cancel_flag, cancelled_by cancel_date cancel_reason */ from apps.po_line_locations where po_header_id = 198857;
select * from apps.po_action_history where object_id = 198857 and sequence_num = 3;

select * /*, cancel_flag, cancelled_by, cancel_date, cancel_reason*/ from apps.requisition_headers_all where requisition_header_id = 37173;
/****/

update apps.po_headers_all set cancel_flag = '' where segment1 = '7498';
update apps.po_lines_all set cancel_flag = null, cancelled_by = null, cancel_date = null, cancel_reason = null where po_header_id = 192935;
update apps.po_distributions_all set quantity_cancelled = null where po_header_id = 192935;
update apps.po_line_locations  set quantity_cancelled = null, cancel_flag = null, cancelled_by = null, cancel_date = null, cancel_reason = null where po_header_id = 192935;
delete apps.po_action_history where object_id = 192935 and sequence_num = 3;




begin
--fnd_global.apps_initialize(:P_USER_ID,:P_RESP_ID,:P_RESP_APPL_ID);
fnd_global.apps_initialize(1353, 50595, 222);
end;