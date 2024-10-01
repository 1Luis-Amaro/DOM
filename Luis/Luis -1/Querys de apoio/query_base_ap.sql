SELECT DISTINCT PV.SEGMENT1          "CODIGO DO FORNECEDOR",
                PV.VENDOR_NAME       "NOME FORNECEDOR",
                AIA.PAY_GROUP_LOOKUP_CODE "GRUPO PAGAMENTO",
                PV.VENDOR_TYPE_LOOKUP_CODE "GRUPO FORNECEDOR",
                AIA.PAYMENT_METHOD_CODE "TIPO DOCUMENTO",
                AIA.SOURCE "MODULO ORIGEM",                
                AIA.INVOICE_NUM "NUMERO DOCUMENTO",
                TRUNC(AIA.INVOICE_DATE)     "DATA EMISSAO",
				TRUNC(AIA.GL_DATE) "DATA TRANSACAO",
                --TRUNC(AIPA.ACCOUNTING_DATE) "DATA TRANSACAO",         
                INFO_RI.LOCAL, 
                INFO_RI.SERIE,
                INFO_RI.INVOICE_ID ID_NOTA_RI,
                INFO_RI.INVOICE_NUM NUMERO_NOTA_RI,
				
                AIA.INVOICE_CURRENCY_CODE MOEDA,
                AIA.EXCHANGE_RATE "TAXA IMPLANTACAO",
                AIA.INVOICE_AMOUNT "VALOR ORIGINAL",
                DECODE(AIA.EXCHANGE_RATE,NULL,0,AIA.INVOICE_AMOUNT * AIA.EXCHANGE_RATE) "VALOR MOEDA LOCAL",
                APSA.AMOUNT_REMAINING "VALOR SALDO ORIGINAL",
                DECODE(AIA.EXCHANGE_RATE,NULL,0,APSA.AMOUNT_REMAINING * AIA.EXCHANGE_RATE) "VALOR SALDO MOEDA LOCAL",                                                
                APSA.DUE_DATE "DATA VENCIMENTO",
                TRUNC(AIPA.ACCOUNTING_DATE) "DATA DA BAIXA",
                TRUNC(AC.CHECK_DATE) "DATA DEBITO",
                AC.BANK_ACCOUNT_NAME BANCO,
                nvl(AC.PAYMENT_METHOD_CODE,APSA.PAYMENT_METHOD_CODE) "FORMA PAGAMENTO",
                AC.CHECK_DATE - APSA.DUE_DATE "PRAZO MEDIO AGENDAMENTO",
                AIPA.ACCOUNTING_DATE -  AIA.INVOICE_DATE "PRAZO MEDIO LANCAMENTO",
                AC.CHECK_DATE - AIA.INVOICE_DATE "PRAZO MEDIO PAGAMENTO",                                
                PO.SEGMENT1 "PEDIDO COMPRA",
                (SELECT PAPF.FULL_NAME
                   FROM APPS.PO_ACTION_HISTORY PAH, APPS.PER_ALL_PEOPLE_F PAPF
                  WHERE PAH.OBJECT_TYPE_CODE = 'PO'
                    AND PAH.ACTION_CODE = 'APPROVE'
                    AND PAH.EMPLOYEE_ID = PAPF.PERSON_ID
                    AND PAH.OBJECT_ID = PO.PO_HEADER_ID
                    AND ROWNUM = 1) "APROVADOR PEDIDO",
                 
                 NVL((SELECT  DISTINCT GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'||GCC.SEGMENT6
                      ||'.'||GCC.SEGMENT7||'.'||GCC.SEGMENT8||'.'||GCC.SEGMENT9
                     FROM APPS.GL_CODE_COMBINATIONS GCC 
                     WHERE GCC.CODE_COMBINATION_ID = PO.DIST_CODE_COMBINATION_ID
                     AND ROWNUM = 1),
                     (SELECT  DISTINCT GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'||GCC.SEGMENT6
                      ||'.'||GCC.SEGMENT7||'.'||GCC.SEGMENT8||'.'||GCC.SEGMENT9
                     FROM APPS.GL_CODE_COMBINATIONS GCC 
                     WHERE GCC.CODE_COMBINATION_ID = AIDA2.DIST_CODE_COMBINATION_ID
                     AND ROWNUM = 1)) "CODE COMBINATION",
                 NVL((SELECT FFV.FLEX_VALUE||' - '||FFVT.DESCRIPTION   
                          FROM APPS.FND_FLEX_VALUES FFV ,APPS.FND_FLEX_VALUES_TL FFVT, APPS.GL_CODE_COMBINATIONS GCC
                         WHERE FFV.FLEX_VALUE_ID = FFVT.FLEX_VALUE_ID          
                           AND FFVT.LANGUAGE = 'PTB'
                           AND FFV.FLEX_VALUE = GCC.SEGMENT4                            
                           AND GCC.CODE_COMBINATION_ID = AIDA2.DIST_CODE_COMBINATION_ID
                           AND ROWNUM = 1),
                       (SELECT FFV.FLEX_VALUE||' - '||FFVT.DESCRIPTION   
                          FROM APPS.FND_FLEX_VALUES FFV ,APPS.FND_FLEX_VALUES_TL FFVT, APPS.GL_CODE_COMBINATIONS GCC
                         WHERE FFV.FLEX_VALUE_ID = FFVT.FLEX_VALUE_ID          
                           AND FFVT.LANGUAGE = 'PTB'
                           AND FFV.FLEX_VALUE = GCC.SEGMENT4                            
                           AND GCC.CODE_COMBINATION_ID = AIDA2.DIST_CODE_COMBINATION_ID
                           AND ROWNUM = 1))  "DESCRICAO CONTA",

                
                 AIA.INVOICE_TYPE_LOOKUP_CODE "TIPO DE NOTA",
				 APSA.PAYMENT_STATUS_FLAG STATUS_PAGAMENTO_NOTA

  FROM APPS.AP_PAYMENT_SCHEDULES_ALL APSA,
       APPS.AP_INVOICES_ALL          AIA,
       APPS.PO_VENDORS               PV
       --,PO_VENDOR_SITES_ALL PVSA   
      ,
       APPS.AP_INVOICE_PAYMENTS_ALL AIPA,
       APPS.AP_CHECKS_ALL AC,
       APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA2,
       (SELECT PHA.SEGMENT1, 
              PHA.PO_HEADER_ID, 
              AINVA.INVOICE_ID,
              AIDA.DIST_CODE_COMBINATION_ID
          FROM --PO_LINES_ALL                 PLA,
               APPS.PO_HEADERS_ALL               PHA,
               APPS.AP_INVOICE_DISTRIBUTIONS_ALL AIDA,
               APPS.AP_INVOICES_ALL              AINVA,
               APPS.PO_DISTRIBUTIONS_ALL         PDA--,
               --PO_LINE_LOCATIONS_ALL        PLLA
         WHERE --PLA.PO_LINE_ID = PLLA.PO_LINE_ID
           --AND PHA.PO_HEADER_ID = PLA.PO_HEADER_ID
           --AND PLLA.LINE_LOCATION_ID = PDA.LINE_LOCATION_ID
            AIDA.INVOICE_ID = AINVA.INVOICE_ID
            AND PDA.PO_HEADER_ID = PHA.PO_HEADER_ID
           AND PDA.PO_DISTRIBUTION_ID = AIDA.PO_DISTRIBUTION_ID
           /*AND ROWNUM = 1*/) PO
		
		,(select ri.INVOICE_ID  INVOICE_ID,
                 ri.INVOICE_NUM INVOICE_NUM,
                 ri.SERIES SERIE,
                 ri.ORGANIZATION_ID,
				 ri.invoice_num_ap
       ,(select od.organization_name
          from APPS.org_organization_definitions od
         where od.organization_id = ri.ORGANIZATION_ID) LOCAL
          from APPS.cll_f189_invoices ri) INFO_RI

 WHERE AIA.INVOICE_ID = APSA.INVOICE_ID
   AND AIPA.INVOICE_ID(+) = AIA.INVOICE_ID
   AND AC.CHECK_ID(+) = AIPA.CHECK_ID
   AND PV.VENDOR_ID = AIA.VENDOR_ID
      
   AND PO.INVOICE_ID(+) = AIA.INVOICE_ID
   AND AIDA2.INVOICE_ID (+) = AIA.INVOICE_ID
   
   AND INFO_RI.invoice_num_ap (+) = aia.invoice_num
