select *
from apps.oe_order_headers_all
where order_number in ('118467','112366','123106','124765');

update apps.oe_order_headers_all
set flow_status_code = 'BOOKED',
open_flag = 'Y'
where header_id in (78411,102694,115628,124948);