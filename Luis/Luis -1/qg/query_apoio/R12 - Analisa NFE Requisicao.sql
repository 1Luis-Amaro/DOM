SELECT CAMPO_1
,CAMPO_2
,CAMPO_3
,CAMPO_4
,CAMPO_7
,CAMPO_8
,CAMPO_9
,CAMPO_10
,CAMPO_11
,CAMPO_12
,CAMPO_13
,CAMPO_14
,CAMPO_15
,CAMPO_16
,CAMPO_17
,CAMPO_18
,CAMPO_19
,CAMPO_20
,CAMPO_21
,CAMPO_22
,CAMPO_23
,CAMPO_24
,CAMPO_25
,CAMPO_26
,CAMPO_27
,CAMPO_28
,CAMPO_29
,CAMPO_30
,CAMPO_31
,CAMPO_32
,CAMPO_33
,CAMPO_34
,CAMPO_35
,CAMPO_36
,CAMPO_37
,CAMPO_38
,CAMPO_39
,CAMPO_40
,CAMPO_41
,CAMPO_42 
,CAMPO_43
,CAMPO_44
,CAMPO_45
,CAMPO_46
,CAMPO_47
,CAMPO_48
,CAMPO_49
,DIA
,VALOR_1
,VALOR_2 
,VALOR_3
,VALOR_4
,VALOR_5 
 FROM(
 SELECT  le.codigoestabelecimento
      , le.loteentrada, 
    (SELECT HRL.LOCATION_CODE
       FROM APPS.PO_HEADERS_ALL HEA,
            APPS.PO_LINE_LOCATIONS_ALL LOC,
            APPS.HR_LOCATIONS HRL
      WHERE HEA.PO_HEADER_ID = LOC.PO_HEADER_ID 
        AND HEA.BILL_TO_LOCATION_ID = HRL.LOCATION_ID
        AND LOC.LINE_LOCATION_ID = CFIL.LINE_LOCATION_ID) CAMPO_3
      --, big_tbl.campo_7
      --, big_tbl.campo_8
      --, big_tbl.campo_9
      --, big_tbl.CAMPO_29
      --, big_tbl.CAMPO_24
      --, big_tbl.CAMPO_21
      ,(SELECT xle.name 
          FROM apps.org_organization_definitions org,
               apps.hr_operating_units hro,
               apps.xle_entity_profiles xle
         WHERE org.operating_unit = hro.organization_id
           AND hro.default_legal_context_id = xle.legal_entity_id
           AND org.organization_id = cfi.organization_id) CAMPO_1
      ,( SELECT hrl.location_code
           FROM apps.po_headers_all hea,
                apps.po_line_locations_all loc,
                apps.hr_locations hrl
          WHERE hea.po_header_id = loc.po_header_id 
            AND hea.bill_to_location_id = hrl.location_id
            AND loc.line_location_id = cfil.line_location_id ) CAMPO_4  
      ,( SELECT UPPER(reg.territory_short_name)
           FROM apps.hr_organization_units_v org,
                apps.fnd_territories_tl reg
          WHERE reg.territory_code = org.country
            AND org.organization_id = cfi.organization_id
            AND reg.language = 'PTB') CAMPO_2       
      , reo.receive_date                                     CAMPO_29
      , mtl.creation_date                                    CAMPO_39             
      , ((SELECT to_date(creation_date,'DD/MM/RRRR HH24:MI')
            FROM apps.RCV_VRC_TXS_V 
            WHERE receipt_num = cfi.operation_id 
              AND item_id = msi.inventory_item_id
              AND organization_id = msi.organization_id
              AND transaction_id = rcv.transaction_id
              AND transaction_type = 'DELIVER') - (to_date(reo.CREATION_date,'DD/MM/RRRR HH24:MI'))) VALOR_5  
      , CASE WHEN (((SELECT TO_DATE(creation_date,'DD/MM/RRRR HH24:MI')
                       FROM apps.RCV_VRC_TXS_V 
                      WHERE receipt_num = cfi.operation_id 
                        AND item_id = msi.inventory_item_id
                        AND organization_id = msi.organization_id
                        AND transaction_id = rcv.transaction_id
                        AND transaction_type = 'DELIVER') - (TO_DATE(reo.CREATION_date,'DD/MM/RRRR HH24:MI'))) * 24 )= 0 THEN 
                   ROUND(((SELECT creation_date
                             FROM apps.RCV_VRC_TXS_V 
                            WHERE receipt_num = cfi.operation_id 
                              AND item_id = msi.inventory_item_id
                              AND organization_id = msi.organization_id
                              AND transaction_id = rcv.transaction_id
                              AND transaction_type = 'DELIVER') - (reo.CREATION_date))* 1440)
             ELSE     
                  (((SELECT to_date(creation_date,'DD/MM/RRRR HH24:MI')
                      FROM apps.RCV_VRC_TXS_V 
                      WHERE receipt_num = cfi.operation_id 
                        AND item_id = msi.inventory_item_id
                        AND organization_id = msi.organization_id
                        AND transaction_id = rcv.transaction_id
                        AND transaction_type = 'DELIVER') - (TO_DATE(reo.CREATION_date,'DD/MM/RRRR HH24:MI'))) * 24 )    
        end VALOR_4                                 
      , (select agent_name from apps.po_agents_v where agent_id = msi.buyer_id) campo_10
      , (select distinct usr.description 
         from apps.fnd_user usr,
              apps.po_headers_all hea,
              apps.po_line_locations_all lin
         where hea.created_by = usr.user_id
         and hea.po_header_id = lin.po_header_id
         and lin.line_location_id = cfil.line_location_id 
         and rownum = 1 )campo_11
     , (SELECT papf.full_name 
        FROM apps.po_headers_all hea,
             apps.po_line_locations_all lin,
             apps.po_action_history pah,
             apps.fnd_user fu,
             apps.per_all_people_f papf  
        WHERE hea.po_header_id = lin.po_header_id
        AND lin.line_location_id = cfil.line_location_id
        AND pah.object_type_code = 'PO'
        AND pah.action_code = 'APPROVE'
        AND pah.employee_id = fu.employee_id
        AND fu.employee_id = papf.person_id
        AND pah.sequence_num = (SELECT MAX(sequence_num)
                                            FROM po.po_action_history pah1
                                           WHERE pah1.object_id = pah.object_id
                                             AND pah1.object_type_code = 'PO'
                                             AND pah1.action_code = 'APPROVE')
        AND rownum = 1 ) campo_12  
      , mtl.subinventory_code campo_13 
      , (decode(msi.global_attribute3, '1',  'Foreign - Direct import',
                                 '7',  'Foreign, acquired in the domestic market',
                                 '2',  'Foreign, acquired on domestic market',
                                 '6',  'Foreign, acquired overboard',
                                 '8',  'Nacional, mercadoria ou bem com conteúdo de importação superior a 70%',
                                 '0',  'National',
                                 '4',  'National, compliant with local production rules',
                                 '3', 'National, over 40% of imported content',
                                 '5',  'National, under 40% of imported content')) CAMPO_16
      , (SELECT ven.ATTRIBUTE1 
           FROM apps.PO_VENDORS VEN, 
                apps.po_headers_all hea,
                apps.po_line_locations_all lin
          WHERE hea.vendor_id = ven.vendor_id
            AND hea.po_header_id = lin.po_header_id
            AND lin.line_location_id = cfil.line_location_id) CAMPO_17 
      ,(SELECT utilization_code 
          FROM apps.CLL_F189_ITEM_UTILIZATIONS 
         WHERE utilization_id = cfil.utilization_id) CAMPO_22 
      ,(SELECT location_code 
          FROM apps.hr_locations 
         WHERE location_id = cfi.location_id) CAMPO_23 
      ,(SELECT TO_CHAR (creation_date,'HH24:MI:SS') 
          FROM apps.RCV_VRC_TXS_V 
         WHERE receipt_num = cfi.operation_id 
          AND item_id = msi.inventory_item_id
          AND organization_id = msi.organization_id
          AND transaction_id = rcv.transaction_id
          AND transaction_type = 'DELIVER') CAMPO_31
       , '.'  CAMPO_33
       , '.'  CAMPO_34 
       ,(SELECT receiver 
           FROM apps.RCV_VRC_TXS_V 
          WHERE receipt_num = cfi.operation_id 
            AND item_id = msi.inventory_item_id
            AND organization_id = msi.organization_id
            AND transaction_id = rcv.transaction_id
            AND transaction_type = 'DELIVER') CAMPO_35
       ,(SELECT description 
           FROM apps.fnd_user 
          WHERE user_id = cfil.created_by) CAMPO_36
       ,(
         SELECT MC.segment2 BU
         FROM  APPS.MTL_ITEM_CATEGORIES MIC, 
               APPS.MTL_CATEGORIES MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID   
         AND MIC.inventory_item_id =  msi.inventory_item_id 
         AND MIC.organization_id = msi.organization_id 
         AND MIC.CATEGORY_SET_ID = 1        
        ) CAMPO_32
       ,(SELECT hea.segment1 
        FROM apps.po_headers_all hea,
             apps.po_line_locations_all lin
        WHERE hea.po_header_id = lin.po_header_id
        AND lin.line_location_id = cfil.line_location_id
         ) CAMPO_37       
       , NVL(les.quantidadeinicial,NVL(MTLN.PRIMARY_QUANTITY,MTL.PRIMARY_QUANTITY)) VALOR_2     
       , CASE WHEN ROUND((inv_convert.inv_um_convert( cfil.item_id
                                                    , rcv.uom_code 
                                                    , 'kg')),3)< 0 THEN 0 
              ELSE ROUND((inv_convert.inv_um_convert( cfil.item_id
                                                    , rcv.uom_code 
                                                    , 'kg')),3) *  NVL(les.quantidadeinicial,NVL(MTLN.PRIMARY_QUANTITY,MTL.PRIMARY_QUANTITY)) END VALOR_3
     , TO_CHAR(rcv.creation_date,'dd/mm/yy')       DIA
     , ROUND((cfil.COST_AMOUNT/cfil.quantity ) * NVL(les.quantidadeinicial,NVL(MTLN.PRIMARY_QUANTITY,MTL.PRIMARY_QUANTITY)),2)  VALOR_1
     ,(SELECT trunc(lin.promised_date) 
           FROM apps.po_line_locations_all lin
          WHERE lin.line_location_id = cfil.line_location_id) CAMPO_38       
     , mtl.transaction_id              
     , mtln.lot_number           
     , msi.segment1                                         CAMPO_15
     , msi.description                                      CAMPO_14
     , msi.primary_uom_code                                 CAMPO_25
     , msi.primary_unit_of_measure  
     , cfi.operation_id                                     CAMPO_28
     , mtl.attribute15                                      integrado_wmas         
     , mp.organization_code                                 org
     ,(NVL(mtln.primary_quantity,mtl.primary_quantity))     primary_quantity           
     , mtl.transaction_uom                                  transaction_uom                        
     , mtln.lot_number                                      CAMPO_27
     , mtl.transaction_id                                   transaction_id                        
     , TO_CHAR(cfi.invoice_num)                             CAMPO_26   
     , mtl.transaction_uom                                  CAMPO_49
     , mtl.creation_date
     , cfil.REQUISITION_LINE_ID --'REQ'
     , cfil.line_location_id -- 'PO'
     , cfil.rma_interface_id -- 'RMA'
     , le.numeropedidoseparacao
     , le.dadologistico       CAMPO_41
     , r.codigoromaneio
     , r.numeroromaneio
     , de.documentoentrada
     , r.tiporomaneio
     , r.estadoromaneio
     , le.codigoproduto       CAMPO_40
     , les.quantidadeinicial
     , r.dataemissao
     , r.datamovimento
     , r.usuario               
     , les.codigoua           CAMPO_45
     , le.numeropedidoseparacao
     , TO_CHAR((select datamovimento
         from wmas.lotesequenciamovimento@WMAS_LINK lsm
        where lsm.numerolote                 = les.loteentrada  and 
              lsm.codigouabase               = les.codigouabase and
              lsm.tipolotesequenciamovimento = 1
              and ROWNUM = 1) ,'dd/mm/yy') CAMPO_43
     , TO_CHAR((select datamovimento
         from wmas.lotesequenciamovimento@WMAS_LINK lsm
        where lsm.numerolote                 = les.loteentrada  and 
              lsm.codigouabase               = les.codigouabase and
              lsm.tipolotesequenciamovimento = 1
              and ROWNUM = 1) ,'hh24:mi:ss')CAMPO_44
     , (select usuariomovimento
         from wmas.lotesequenciamovimento@WMAS_LINK lsm
        where lsm.numerolote                 = les.loteentrada  and 
              lsm.codigouabase               = les.codigouabase and
              lsm.tipolotesequenciamovimento = 1
              and ROWNUM = 1) CAMPO_42            
     , TO_CHAR((select MAX(datamovimento) 
         from wmas.lotesequenciamovimento@WMAS_LINK lsm
        where lsm.numerolote                 = les.loteentrada  and 
              lsm.codigouabase               = les.codigouabase and
              lsm.tipolotesequenciamovimento = 20),'hh24:mi:ss')  CAMPO_47
      , TO_CHAR((select MAX(datamovimento) 
         from wmas.lotesequenciamovimento@WMAS_LINK lsm
        where lsm.numerolote                 = les.loteentrada  and 
              lsm.codigouabase               = les.codigouabase and
              lsm.tipolotesequenciamovimento = 20),'dd/mm/yy' )  CAMPO_46
     , (select usuariomovimento
         from wmas.lotesequenciamovimento@WMAS_LINK lsm
        where lsm.numerolote                 = les.loteentrada  and 
              lsm.codigouabase               = les.codigouabase and
              lsm.tipolotesequenciamovimento = 20
              and ROWNUM = 1) CAMPO_48  
    ,(SELECT LINE_ID FROM apps.oe_order_lines_all WHERE LINE_ID = mtl.TRX_SOURCE_LINE_ID)  LINE_ID
       --
     , NVL (pv.vendor_name, cfcv.customer_name)     CAMPO_7
     , NVL (pv.segment1, cfcv.customer_number)      CAMPO_8
     , NVL (pv.segment1, cfcv.customer_number)||' - '||NVL (pv.vendor_name, cfcv.customer_name) CAMPO_9
     , pvsa.city                                   CAMPO_20--Cidade_Fornecedor
     , pvsa.country                                CAMPO_18 --Pais_Fornecedor
     , pvsa.state                                  CAMPO_19 --UF_Fornecedor     
     , to_char(reo.receive_date,'hh24:mi:ss')      CAMPO_30
     , cfi.invoice_date                            Data_Emissao_NF
     , cfi.invoice_num                             nota_fiscal
     , cfit.invoice_type_code                      tipo_nf
     , cfi.INVOICE_AMOUNT                          vlr_liquido_nf
     , cfi.gross_total_amount                      vlr_bruto_nf
     , cfi.first_payment_date                      dt_pagamento
     , cfi.invoice_weight                          peso_bruto
     , cfi.attribute2                              peso_liquido
     , (SELECT classification_code
          FROM apps.cll_f189_fiscal_class
         WHERE classification_id = cfil.classification_id
         )  CAMPO_24         
     , DECODE (reo.FREIGHT_FLAG,  'C', 'CIF',  'F', 'FOB',  'Sem Frete') CAMPO_21
     
     
------ Verificando amarração ------     
SELECT pla.*  

select * from apps.RCV_VRC_TXS_V ;

SELECT prha.segment1          "Requisicao",
       prha.creation_date     "Data Req",
       prha.WF_ITEM_KEY       "Item",
       prha.APPROVED_DATE     "Aprov Req",
       pha.segment1           "Pedido",
       pha.creation_date      "Data Pedido",
       pha.approved_date      "Aprov Pedido",
       cfi.invoice_num        nota_fiscal,
       cfi.invoice_date       Data_Emissao_NF,
       cfi.INVOICE_AMOUNT     vlr_liquido_nf,
       cfi.gross_total_amount vlr_bruto_nf,
       cfi.first_payment_date dt_pagamento,
       (SELECT max(creation_date) 
          FROM apps.RCV_VRC_TXS_V 
         WHERE receipt_num    = cfi.operation_id 
          AND item_id         = pla.item_id
          AND organization_id = cfil.organization_id) "Data Receb"
          --AND transaction_id = rcv.transaction_id
          --AND transaction_type = 'DELIVER')
        --
          --
  FROM apps.cll_f189_invoices            cfi
     , apps.cll_f189_invoice_lines       cfil
     , apps.cll_f189_invoice_types       cfit
     , apps.cll_f189_entry_operations    reo
     , apps.cll_f189_customers_v         cfcv
     , apps.cll_f189_fiscal_entities_all rfea
     , apps.ap_supplier_sites_all        pvsa
     , apps.ap_suppliers                 pv
     , apps.mtl_parameters               mp
     , apps.po_line_locations_all        plla
     , apps.po_lines_all                 pla
     , apps.po_headers_all               pha
     , apps.po_requisition_lines_all     prla
     , apps.po_requisition_headers_all   prha
 WHERE cfcv.entity_id(+)        = cfi.entity_id
   AND cfi.invoice_type_id      = cfit.invoice_type_id
   AND cfi.organization_id      = cfit.organization_id      
   AND cfil.invoice_id          = cfi.invoice_id
   AND rfea.entity_id(+)        = cfi.entity_id
   AND pvsa.vendor_site_id(+)   = rfea.vendor_site_id
   AND pv.vendor_id(+)          = pvsa.vendor_id
   AND cfi.organization_id      = reo.organization_id
   AND cfi.operation_id         = reo.operation_id
   AND mp.organization_id       = cfi.organization_id
   AND pv.SEGMENT1              = '061600839'
   AND prha.requisition_header_id = prla.requisition_header_id
   AND prla.line_location_id    = cfil.line_location_id
   AND plla.line_location_id    = cfil.line_location_id
   AND pla.po_line_id           = plla.po_line_id
   AND pha.po_header_id         = pla.po_header_id;
   AND prl.requisition_line_id = cfil.requisition_line_id;
   -------------
select * from apps.po_requisition_headers_all;   
select * from APPS.PO_REQUISITION_HEADERS_ALL where requisition_header_id =  543876;   
select * from apps.cll_f189_invoice_lines       cfil;   
   
   061600839
   
select * from apps.ap_suppliers pv.SEGMENT1 = '061600839';
select * /*, cancel_flag, cancelled_by, cancel_date, cancel_reason*/ from apps.po_lines_all where po_header_id = 1035461;
select * /*, cancel_flag, cancelled_by, cancel_date, cancel_reason*/ from apps.po_lines_archive_all where po_header_id = 905488 AND CANCEL_FLAG = 'Y';
select * /*,quantity_cancelled */ from apps.po_distributions_all where po_header_id = 905488;
select * /*,quantity_cqncelled, cancel_flag, cancelled_by cancel_date cancel_reason */ from apps.po_line_locations_all where po_header_id = 905488;
select gl_cancelled_date from apps.PO_DISTRIBUTIONS_ARCHIVE_ALL where po_header_id = 905488 and gl_cancelled_date is not null;
select cancel_flag, cancelled_by cancel_date, cancel_reason from apps.PO_LINE_LOCATIONS_ARCHIVE_ALL where po_header_id = 905488 and cancel_flag = 'Y';



-----------------------

select * from apps.gme_batch_header
 where batch_no = 75704 and 
       organization_id = 92;
       
       
SELECT DISTINCT
  PPF.FULL_NAME,
  PRD.DISTRIBUTION_ID,
  PRL.DESTINATION_ORGANIZATION_ID,
  PRL.CREATION_DATE,
  PRL.ATTRIBUTE1,
  prl.destination_organization_id,
  prl.SOURCE_ORGANIZATION_ID,
  PRL.ITEM_ID,
  PRL.CANCEL_FLAG,
  PRL.CANCEL_DATE,
  PRL.CANCEL_REASON,
  PRL.ITEM_REVISION,
  PRH.ATTRIBUTE10 ORCAMENTO,
  PRH.REQUISITION_HEADER_ID,
  PRL.REQUISITION_LINE_ID,
  PRH.SEGMENT1 NUMERO_REQ,
  PRL.LINE_NUM,
  PRL.ITEM_REVISION,
  PRL.UNIT_PRICE,
  PRL.QUANTITY,
  PRL.QUANTITY_DELIVERED,
  MSI.SEGMENT1  CODIGO_ITEM,
  PRD.REQ_LINE_QUANTITY,
  SECONDARY_UNIT_OF_MEASURE,
  SECONDARY_QUANTITY,
  PRL.QUANTITY,PRL.UNIT_PRICE,PRL.BASE_UNIT_PRICE,
  FU.USER_NAME MATRICULA_REQUISITANTE,
  PPF.FULL_NAME NOME_REQUISITANTE,
  PRH.AUTHORIZATION_STATUS,
  PRH.TYPE_LOOKUP_CODE,
  PRL.DESTINATION_TYPE_CODE,
  PRH.TRANSFERRED_TO_OE_FLAG,
  PRH.ATTRIBUTE10 ORÇAMENTO,
  PRH.INTERFACE_SOURCE_CODE,
  PRH.APPS_SOURCE_CODE,
  PRH.WF_ITEM_KEY,
  PRH.APPROVED_DATE,
  PRL.REQUISITION_LINE_ID,
  PRL.CATEGORY_ID,   --2002.10722442002442002442002442002442002
  --mcsv.CATEGORY_CONCAT_SEGMENTS CATEGORIA,
  HOU.NAME ORGANIZACAO_DESTINO,
  MP.ORGANIZATION_CODE,
  PRL.ITEM_DESCRIPTION,
  PRL.UNIT_MEAS_LOOKUP_CODE,
  PRL.DELIVER_TO_LOCATION_ID,
  PRL.SOURCE_TYPE_CODE,
  --PRL.ITEM_ID,
  --PRL.SUGGESTED_BUYER_ID,
  PPFF.FULL_NAME COMPRADOR_SUGERIDO,
  PRL.NEED_BY_DATE,
  --PRL.BLANKET_PO_HEADER_ID,
  PHA.SEGMENT1 NUMERO_CONTRATO,
  PRL.BLANKET_PO_LINE_NUM,
  PRL.SUGGESTED_VENDOR_NAME,
  PRL.DESTINATION_TYPE_CODE,
  PRL.SOURCE_SUBINVENTORY,
  --PRL.DESTINATION_ORGANIZATION_ID,
  PRL.SOURCE_ORGANIZATION_ID ORGANIZACAO_ORIGEM,
  PRL.SOURCE_SUBINVENTORY,
  HOU.NAME ORGANIZACAO_DESTINO,
  DESTINATION_SUBINVENTORY,
  PRL.DESTINATION_CONTEXT,
  PRL.TRANSACTION_REASON_CODE,
  PRL.AUCTION_HEADER_ID,
  PRL.AUCTION_LINE_NUMBER,
  PRL.REQS_IN_POOL_FLAG,
  PRL.BID_NUMBER,
  PRL.BID_LINE_NUMBER,
  PRD.PROJECT_ID,
  PRD.TASK_ID,
  PRD.CODE_COMBINATION_ID
--  PRD.*
  --GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'||GCC.SEGMENT6 CONTA_CONTABIL
  FROM apps.po_requisition_headers_all  prh,
       apps.po_requisition_lines_all    prl,
       apps.po_req_distributions_all    prd,
       apps.fnd_user                    fu,
       apps.per_people_f                ppf,
       apps.hr_organization_units_v     hou,
       apps.po_headers_all              pha,
    --   apps.gl_code_combinations_v      gcc,
       apps.per_people_f                ppff,
       apps.mtl_system_items_b          msi,
       apps.mtl_parameters              mp
  WHERE prh.requisition_header_id       = prl.requisition_header_id
    AND prl.requisition_line_id         = prd.requisition_line_id
    AND prh.preparer_id                 = ppf.person_id(+)
    AND PPF.PERSON_ID                   = FU.EMPLOYEE_ID(+)
  --AND prl.category_id = mcsv.category_id
    AND prl.destination_organization_id = hou.organization_id
    AND prl.blanket_po_header_id        = pha.po_header_id(+)
  --  AND prd.code_combination_id         = gcc.code_combination_id(+)
    AND Nvl(prl.suggested_buyer_id,0)   = ppff.person_id(+)
    AND Nvl(prl.item_id,0)              = msi.inventory_item_id(+)
    AND prl.destination_organization_id = mp.organization_id(+)
   -- AND prl.destination_organization_id = prl.SOURCE_ORGANIZATION_ID
    --AND PRH.TYPE_LOOKUP_CODE            = 'INTERNAL' 
    --AND NVL(QUANTITY_DELIVERED,0)       > 0;
    --AND prh.segment1 ='54555'

