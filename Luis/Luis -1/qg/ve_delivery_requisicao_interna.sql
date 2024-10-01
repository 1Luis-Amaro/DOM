--[?03/?02/?2020 15:01]  Duarte, Wellington:  

--WSH_DELIVERIES_PUB.DELIVERY_ACTION  -- with action code 'PICK-RELEASE'.


SELECT prha.segment1
       requisicao,
       ooha.order_number,
       wda.delivery_id,
       oola.line_number || '.' || oola.shipment_number
  FROM oe_order_headers_all       ooha
      ,oe_order_lines_all         oola
      ,wsh_delivery_details       wdd
      ,wsh_delivery_assignments   wda
      ,po_requisition_lines_all   prla
      ,po_requisition_headers_all prha
WHERE  ooha.header_id = oola.header_id
--AND    wdd.source_header_type_name  = 'TRANSFERENCIA'
AND    oola.source_document_line_id = prla.requisition_line_id
AND    prla.requisition_header_id   = prha.requisition_header_id
AND    oola.line_id                 = wdd.source_line_id
AND    wdd.delivery_detail_id       = wda.delivery_detail_id
AND    oola.source_document_id      = prha.requisition_header_id 
and    prha.requisition_header_id   = 870024;
 
select * from po_requisition_headers_all prha


-- requisition_header_id não faz parte do índice, por isto fica lento --
SELECT * /*prha.segment1
       requisicao,
       ooha.order_number,
       wda.delivery_id,
       oola.line_number || '.' || oola.shipment_number*/
  FROM oe_order_headers_all       ooha
      ,oe_order_lines_all         oola
      ,/*wsh_delivery_details       wdd
      ,wsh_delivery_assignments   wda
      ,po_requisition_lines_all   prla
      ,*/ po_requisition_headers_all prha
WHERE  /*ooha.header_id = oola.header_id
--AND    wdd.source_header_type_name  = 'TRANSFERENCIA'
AND    oola.source_document_line_id = prla.requisition_line_id
AND    prla.requisition_header_id   = prha.requisition_header_id
AND    oola.line_id                 = wdd.source_line_id
AND    wdd.delivery_detail_id       = wda.delivery_detail_id
AND*/    oola.source_document_id      = prha.requisition_header_id 
 and   prha.requisition_header_id   = 870024;
 
 /**/
  data VARCHAR2(2000);
  x_msg_count VARCHAR2(2000);

--Standard Parameters.
  p_api_version_number NUMBER;
  init_msg_list VARCHAR2(30);
  x_msg_details VARCHAR2(3000);
  x_msg_summary VARCHAR2(3000);
  p_validation_level NUMBER;
  p_commit VARCHAR2(30);

--Parameters for WSH_DELIVERIES_PUB.Delivery_Action
  p_action_code VARCHAR2(15);
  p_delivery_id NUMBER;
  p_delivery_name VARCHAR2(30);
  p_asg_trip_id NUMBER;
  p_asg_trip_name VARCHAR2(30);
  x_trip_id NUMBER;
  x_trip_name VARCHAR2(30);

--
BEGIN
--
  x_return_status := WSH_UTIL_CORE.G_RET_STS_SUCCESS;

  FND_GLOBAL.APPS_INITIALIZE(
  user_id => 1014841 -- User ID
  , resp_id => 21623 -- Order Management Super User
  , resp_appl_id => 660 -- Oracle Order Management
  );

  --========================================================================
  -- Delivery Action API (Unassign trip from Delivery)
  --========================================================================
  --
  p_action_code := 'UNASSIGN-TRIP';
  p_delivery_id := &delivery_id;
  p_asg_trip_id := &p_asg_trip_id;

  WSH_DELIVERIES_PUB.DELIVERY_ACTION(
  p_api_version_number => 1.0
  , p_init_msg_list => init_msg_list
  , x_return_status => x_return_status
  , x_msg_count => x_msg_count
  , x_msg_data => x_msg_data
  , p_action_code => p_action_code
  , p_delivery_id => p_delivery_id
  , p_delivery_name => p_delivery_name
  , p_asg_trip_id => p_asg_trip_id
  , p_asg_trip_name => p_asg_trip_name
  , x_trip_id => x_trip_id
  , x_trip_name => x_trip_name
  );

  --========================================================================
  -- COMMIT/ROLLBACK
  --========================================================================
  IF x_return_status = WSH_UTIL_CORE.G_RET_STS_SUCCESS THEN
  dbms_output.put_line( l_operation ||' done successfully.' ) ;
  commit;
  ELSE
  dbms_output.put_line('Failure.' );
  dbms_output.put_line('Return Status = '||x_return_status);
  wsh_util_core.get_messages('Y', x_msg_data, x_msg_details, x_msg_count);
  dbms_output.put_line(l_operation ||': ');
  dbms_output.put_line('Summary: '||substrb(x_msg_data,1,200));
  dbms_output.put_line('Detail: '||substrb(x_msg_details,1,200));
  rollback;
  END IF;
END;
/ 

 
 /**/
 select * 
   from apps.oe_order_headers_all       oh,
        apps.po_requisition_headers_all prh
 where prh.requisition_header_id   = 870024 and
       oh.orig_sys_document_ref                  = prh.segment1
       
       
       
       
SELECT * FROM WSH_DELIVERY_TRIPS_V;       
       
SELECT --delivery_id,
       wda.*,
       wdt.*
              --, prha.segment1
       --requisicao,
       --ooha.order_number,
       --wda.delivery_id,
       --oola.line_number || '.' || oola.shipment_number
  FROM oe_order_headers_all       ooha
      ,oe_order_lines_all         oola
      ,wsh_delivery_details       wdd
      ,wsh_delivery_assignments   wda
      ,WSH_DELIVERY_TRIPS_V       wdt
      ,po_requisition_lines_all   prla
      ,po_requisition_headers_all prha
 WHERE ooha.header_id               = oola.header_id             AND
       oola.source_document_line_id = prla.requisition_line_id   AND
       prla.requisition_header_id   = prha.requisition_header_id AND
       oola.line_id                 = wdd.source_line_id         AND
       wdd.delivery_detail_id       = wda.delivery_detail_id     AND
       wdt.delivery_id (+)          = wda.delivery_id            AND
      -- wdt.delivery_detail_id(+)    = wda.delivery_detail_id     AND
       oola.source_document_id      = prha.requisition_header_id AND
       ooha.header_id               = oola.header_id             AND
       prha.TYPE_LOOKUP_CODE        = 'INTERNAL'                 AND
       ooha.orig_sys_document_ref   = prha.segment1              AND
       prha.requisition_header_id   = 1340025 order by 1;       
       
select * from po_requisition_headers_all where segment1 =        139383