select * from po.rcv_shipment_lines rsl;



            SELECT CKS.CHECK_DATE DATA_DO_PAGAMENTO
                   
               FROM AP.AP_INVOICES_ALL INV
                  , AP.AP_PAYMENT_SCHEDULES_ALL SCD
                  , AP.AP_INVOICE_PAYMENTS_ALL PAY
                  , AP.AP_CHECKS_ALL CKS
                  , AP.AP_INVOICE_LINES_ALL LIN
               WHERE INV.INVOICE_ID = SCD.INVOICE_ID
                 AND INV.INVOICE_ID = PAY.INVOICE_ID
                 AND LIN.INVOICE_ID = INV.INVOICE_ID
                 AND PAY.CHECK_ID = CKS.CHECK_ID;



SELECT inv.* 
--INV.INVOICE_NUM NFF,
--                   INV.INVOICE_AMOUNT VALOR_NFF,
--                   SCD.DUE_DATE DATA_VENCIMENTO,
--                   CKS.CHECK_DATE DATA_DO_PAGAMENTO,
--                   CKS.AMOUNT VALOR_PAGO,
--                   LIN.PO_HEADER_ID,
--                   LIN.PO_LINE_ID LINHA_PO,
--                   LIN.PO_LINE_LOCATION_ID PO_LINE_LOCATION
               FROM AP.AP_INVOICES_ALL INV
                  , AP.AP_PAYMENT_SCHEDULES_ALL SCD
                  , AP.AP_INVOICE_PAYMENTS_ALL PAY
                  , AP.AP_CHECKS_ALL CKS
                  , AP.AP_INVOICE_LINES_ALL LIN
               WHERE INV.INVOICE_ID = SCD.INVOICE_ID
                 AND INV.INVOICE_ID = PAY.INVOICE_ID
                 AND LIN.INVOICE_ID = INV.INVOICE_ID
                 AND PAY.CHECK_ID   = CKS.CHECK_ID
                 AND INV.INVOICE_NUM = '76249'
                -- AND PAY.REMIT_TO_SUPPLIER_NAME LIKE '%KANSA%'
                 --and INV.INVOICE_NUM like  '46814%'
                -- GROUP BY INV.INVOICE_NUM,
                --          INV.INVOICE_AMOUNT,
                --          LIN.PO_LINE_ID, 
                --          LIN.PO_LINE_LOCATION_ID,
                --          SCD.DUE_DATE,
                --          CKS.CHECK_DATE,
                --          CKS.AMOUNT,
                --          LIN.PO_HEADER_ID
                
                ;
                
                
       SELECT INV.INVOICE_AMOUNT, INV.INVOICE_NUM,  LIN.*
         FROM AP.AP_INVOICES_ALL inv,
              AP.AP_INVOICE_LINES_ALL LIN,
              AP.AP_PAYMENT_SCHEDULES_ALL SCD
              
        WHERE 
              LIN.INVOICE_ID  = INV.INVOICE_ID AND
              SCD.INVOICE_ID  = INV.INVOICE_ID AND
              exists (select 1
                        from AP.AP_INVOICE_PAYMENTS_ALL PAY
                       where PAY.INVOICE_ID  = INV.INVOICE_ID) AND
              INV.DESCRIPTION like '%SUM0456/15%';
              INV.INVOICE_NUM = '755';               
                
SELECT * from apps.cll_f189_invoices cfi where invoice_num = 76249;  
select * from apps.cll_f189_invoices cfi where invoice_num = 11122519;


select * from apps.po_distributions_all pda
   WHERE pda.po_DISTRIBUTION_ID IN(306213,
306214,
306215,
306216,
306217,
306218,
306219,
306220,
306221,
306222,
306223,
306224,
306225,
306226,
306227,
306228,
306208,
306209,
306210,
306211,
306212);

RCV_VRC_TXS_V 

select * from apps.cll_f189_invoice_lines cfil where invoice_id = 13504;

SELECT * FROM APPS.CLL_F189_INVOICE_LINES_iface;
select * from APPS.CLL_F189_invoice_line_parents;

SELECT * FROM apps.cll_f189_invoice_lines; 

SELECT * FROM AP.AP_INVOICE_PAYMENTS_ALL PAY WHERE  invoicing_vendor_site_id = 7838;


SELECT * FROM           po.rcv_shipment_headers rsh where receipt_num = 628;
SELECT * FROM           po.rcv_shipment_lines rsl where shipment_header_id = 127992;
SELECT * FROM           po.rcv_transactions rt where shipment_header_id = 127992 and transaction_type = 'RECEIVE';

SELECT *
           FROM apps.po_distributions_all pda
          WHERE pda.po_distribution_id in(65667,65668);           
  cfil.total_amount --rt.quantity * rt.po_unit_price




SELECT * from ap.ap_supplier_sites_all pvs WHERE VENDOR_ID = 8482;

select * from ap.ap_suppliers pv where vendor_name like 'KANSAI%';

--cfi.attribute3

       SELECT inv.invoice_num, inv.vendor_id
         FROM AP.AP_INVOICES_ALL inv;
        WHERE
              LIN.INVOICE_ID = INV.INVOICE_ID AND
              SCD.INVOICE_ID = INV.INVOICE_ID AND
              PAY.INVOICE_ID = INV.INVOICE_ID; AND
              INV.VENDOR_ID  = 8482           AND       
              INV.DESCRIPTION like '%SUM0456/15%';
       
       
        
                  , AP.AP_CHECKS_ALL CKS
                  , AP.AP_INVOICE_LINES_ALL LIN
               WHERE INV.INVOICE_ID = SCD.INVOICE_ID
                 AND INV.INVOICE_ID = PAY.INVOICE_ID
                 AND LIN.INVOICE_ID = INV.INVOICE_ID
                 AND PAY.CHECK_ID   = CKS.CHECK_ID;
                 
                 
           
               (SELECT LIN.AMOUNT * INV.EXCHANGE_RATE
                  FROM AP.AP_INVOICES_ALL inv,
                       AP.AP_INVOICE_LINES_ALL LIN,
                       AP.AP_PAYMENT_SCHEDULES_ALL SCD,
                       AP.AP_INVOICE_PAYMENTS_ALL PAY
                 WHERE
                       LIN.INVOICE_ID = INV.INVOICE_ID AND
                       SCD.INVOICE_ID = INV.INVOICE_ID AND
                       PAY.INVOICE_ID = INV.INVOICE_ID AND
                       INV.VENDOR_ID  = 8482           AND       
                       INV.DESCRIPTION like '%' || cfi.attribute3 || '%')
           
                 