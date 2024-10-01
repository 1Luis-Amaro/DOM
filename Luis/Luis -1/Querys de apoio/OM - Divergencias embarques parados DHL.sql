SELECT i.DELIVERY_ID "EMBARQUE_DHL",   
         ohl.SALES_CHANNEL_CODE "BU",       
        -- wdd.SHIPMENT_PRIORITY_CODE "Prioridade de entrega", 
         wdd.SOURCE_HEADER_TYPE_NAME "TIPO DE ORDEM",  
         i.creation_date "DT_CRIACAO_DHL",     
         ohl.order_number,
         ool.line_number || '.' || ool.shipment_number  "LINHA_ORDEM",
         ool.FLOW_STATUS_CODE "STATUS LINHA ORDEM",         
         wda.delivery_id "NOVO EMBARQUE ASSOCIADO",
           (SELECT distinct (h.trx_number)         
           FROM APPS.RA_CUSTOMER_TRX_ALL H, APPS.RA_CUSTOMER_TRX_LINES_ALL J  -- MOSTRAR NA QUERY HUGECLOB
           WHERE  H.INTERFACE_HEADER_ATTRIBUTE3 = TO_CHAR (wda.delivery_id)
           AND H.CUSTOMER_TRX_ID = J.CUSTOMER_TRX_ID
           and J.interface_line_attribute6 = ool.line_id)  "FATURADO (NOTA FISCAL)",                         
         CASE 
         WHEN wdd.released_status = 'B'
         THEN 'BACKORDER'
         WHEN wdd.released_status = 'S'
         THEN 'MOVE ORDER'
         WHEN wdd.released_status = 'C'
         THEN 'SHIPPED'
          WHEN wdd.released_status = 'D'
         THEN 'CANCELLED'
          WHEN wdd.released_status = 'N'
         THEN 'NOT READY FOR RELEASE'
         WHEN wdd.released_status = 'R'
         THEN 'READY TO RELEASE'
         WHEN wdd.released_status = 'X'
         THEN 'NOT APPLICABLE'
         WHEN wdd.released_status = 'Y'
         THEN 'LINE HAS BEEN PICKED'
         ELSE ''
          END "STATUS DO EMBARQUE",      
         i.ITEM_CODE,
         ool.ordered_quantity "QTD_ORDER",
         i.LOT_NUMBER "LOT_DHL",
         i.QTY "QTD_DHL",
         wdd.seal_code "PPG STATUS",
         i.STATUS "STATUS DHL",  
        -- DBMS_LOB.SUBSTR(ERROR_MESSAGE), 
         TRIM (DBMS_LOB.SUBSTR(ERROR_MESSAGE,155,1)) "MESSAGEM DE ERRO DHL", 
         (SELECT wts.trip_id
       FROM APPS.wsh_new_deliveries wnd, 
            APPS.wsh_delivery_legs  wdl, 
            APPS.wsh_trip_stops     wts 
       WHERE wnd.organization_id = wnd.organization_id 
       AND wdl.pick_up_stop_id = wts.stop_id 
       AND wnd.delivery_id = wdl.delivery_id 
       AND wnd.initial_pickup_location_id = wts.stop_location_id
       and  wdl.delivery_id   =wda.delivery_id ) "TRIP ASSOCIADA",
       (SELECT fu.description 
       FROM APPS.wsh_new_deliveries wnd, 
            apps.fnd_user fu 
       WHERE wnd.delivery_id = i.delivery_id
       and wnd.created_by = fu.user_id ) "CREATED_BY",
        (SELECT wnd.confirmed_by 
       FROM APPS.wsh_new_deliveries wnd, 
            apps.fnd_user fu 
       WHERE wnd.delivery_id = i.delivery_id
       and wnd.created_by = fu.user_id ) "CONFIRMED_BY",
       CASE 
         WHEN i.line_type = 'O'
         THEN 'Oracle para DHL'
         WHEN i.line_type = 'I'
         THEN 'DHL para Oracle'
       ELSE ''
          END "ENVIO EMBARQUE" ,
          I.DATA_FILE "NOME ARQUIVO"    
   FROM apps.XXPPG_BR_WSH_DHL_INT_WORK I,
         apps.wsh_delivery_details wdd,
         apps.oe_order_headers_all ohl,
         apps.oe_order_lines_all ool 
         ,apps.wsh_delivery_assignments wda
   WHERE    -- i.line_type = 'I'
          TRUNC (i.CREATION_DATE) >= SYSDATE - 2
         AND i.STATUS in ('ERROR','DIF')
      --   AND I.DELIVERY_ID = '29042403'
         AND wdd.delivery_detail_id = i.delivery_detail_id
         AND ool.line_id = wdd.source_line_id
         AND ool.header_id = ohl.header_id
         and wdd.delivery_detail_id = wda.delivery_detail_id
         --and wda.delivery_id is not null
ORDER BY i.creation_date;