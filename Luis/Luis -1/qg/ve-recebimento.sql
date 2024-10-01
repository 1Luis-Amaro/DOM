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
  FROM apps.rcv_transactions             rcv       
     , apps.rcv_shipment_lines           rsl
     , apps.rcv_shipment_headers         rsh
     , apps.cll_f189_invoices            cfi
     , apps.cll_f189_invoice_lines       cfil
     , apps.cll_f189_invoice_types       cfit
     , apps.cll_f189_entry_operations    reo
     , apps.mtl_material_transactions    mtl
     , apps.cll_f189_customers_v         cfcv
     , apps.cll_f189_fiscal_entities_all rfea
     , apps.ap_supplier_sites_all        pvsa
     , apps.ap_suppliers                 pv
     , apps.mtl_transaction_lot_numbers  mtln                  
     , apps.mtl_system_items_b           msi
     , apps.mtl_parameters               mp
     , apps.loteentrada                  le
     , apps.documentoentrada             de
     , wmas.romaneio@WMAS_LINK           r
     , wmas.romaneiodocumento@WMAS_LINK  rd       
     , apps.loteentradasequencia         les     
 WHERE cfil.shipment_header_id  = rsl.shipment_header_id
   AND rsl.shipment_line_id     = rcv.shipment_line_id          
   AND cfil.item_id             = msi.inventory_item_id
   AND cfi.organization_id      = msi.organization_id
   AND msi.organization_id      = mp.organization_id
   AND cfcv.entity_id(+)        = cfi.entity_id
   AND cfi.invoice_type_id      = cfit.invoice_type_id
   AND cfi.organization_id      = cfit.organization_id      
   AND cfi.operation_id         = rsh.receipt_num
   AND cfi.organization_id      = rsh.ship_to_org_id
   AND cfil.invoice_id          = cfi.invoice_id
   AND cfil.line_location_id    = rsl.po_line_location_id
   AND rcv.transaction_id       = mtl.rcv_transaction_id(+)
   AND mtl.transaction_id       = mtln.transaction_id(+)
   AND rfea.entity_id(+)        = cfi.entity_id
   AND pvsa.vendor_site_id(+)   = rfea.vendor_site_id
   AND pv.vendor_id(+)          = pvsa.vendor_id
   --
   AND cfi.organization_id      = reo.organization_id
   AND cfi.operation_id         = reo.operation_id
   --
   AND rcv.transaction_type     = 'DELIVER'         
   --AND mtl.creation_date        > SYSDATE - 130
   --AND cfi.operation_id         = '135506'
   --   
   AND mtl.transaction_id       = le.numeropedidoseparacao (+)
   AND msi.segment1             = le.codigoproduto         (+)
   AND mtln.lot_number          = le.dadologistico         (+) 
   AND (NVL(mtln.primary_quantity,mtl.primary_quantity)) = le.quantidadedocumento(+)
   --
   AND le.codigoestabelecimento = de.codigoestabelecimento (+)
   AND le.codigoempresa         = de.codigoempresa         (+)       
   AND le.tipodocumento         = de.tipodocumento         (+)     
   AND le.seriedocumento        = de.seriedocumento        (+)   
   AND le.documentoentrada      = de.documentoentrada      (+)
   AND de.codigoestabelecimento = r.codigoestabelecimento  (+)
   AND r.codigoestabelecimento(+) = '1'   
   AND le.codigoestabelecimento = les.codigoestabelecimento(+)
   AND le.loteentrada           = les.loteentrada          (+)
   AND de.documentoentrada      = rd.numerodocumento       (+)
   AND de.tipodocumento         = rd.tipodocumento         (+)
   AND de.seriedocumento        = rd.seriedocumento        (+)
   AND rd.codigoromaneio        = r.codigoromaneio         (+)
   AND rd.codigoestabelecimento = r.codigoestabelecimento  (+)
   AND pv.SEGMENT1 = '061600839'
   -------------
   )
   
   
   061600839
   
select * from apps.ap_suppliers pv.SEGMENT1 = '061600839'   