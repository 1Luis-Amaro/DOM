SELECT RII.SOURCE
      ,RII.PROCESS_FLAG
      ,to_char(rii.creation_date,'dd/mm/yyyy hh24:mi:ss') dt_hora_criacao
      ,(select mp.organization_code from apps.mtl_parameters mp where mp.organization_id = rii.organization_id) ORG
      ,decode(RII.PROCESS_FLAG,'1','1 Pendente'
                              ,'3','3 Erro de dados'
                              ,'4','4 Erro Fiscal'
                              ,'6','6 Processado',rii.process_flag) Status
      ,rii.invoice_num
      ,rii.series
      ,rii.invoice_date
      ,RII.INVOICE_TYPE_CODE
      ,RIT.DESCRIPTION
      ,RII.GL_DATE
      ,(select ri.operation_id from apps.cll_f189_invoices ri where ri.interface_invoice_id = rii.interface_invoice_id and rownum =1) "RI_Gerado"
      ,(select reo.status from apps.cll_f189_invoices ri ,apps.cll_f189_entry_operations reo where ri.interface_invoice_id = rii.interface_invoice_id and ri.organization_id = reo.organization_id and ri.operation_id = reo.operation_id and rownum =1) "'Status do RI Gerado'"
      ,(SELECT RIE.ERROR_CODE FROM APPS.CLL_F189_INTERFACE_ERRORS RIE WHERE RIE.INTERFACE_OPERATION_ID = RII.INTERFACE_OPERATION_ID AND RIE.INTERFACE_INVOICE_ID = RII.INTERFACE_INVOICE_ID and rownum =1) COD_ERRO
      ,(SELECT RIE.ERROR_MESSAGE FROM APPS.CLL_F189_INTERFACE_ERRORS RIE WHERE RIE.INTERFACE_OPERATION_ID = RII.INTERFACE_OPERATION_ID AND RIE.INTERFACE_INVOICE_ID = RII.INTERFACE_INVOICE_ID and rownum =1) MSG_ERRO
      ,PV.VENDOR_NAME
      ,RII.INVOICE_NUM Num_Invoice
      ,RII.INVOICE_AMOUNT VALOR_LIQUIDO
      ,RII.GROSS_TOTAL_AMOUNT VALOR_BRUTO
      ,RII.DESCRIPTION Descricao
  FROM APPS.CLL_F189_INVOICES_INTERFACE RII
      ,APPS.CLL_F189_FISCAL_ENTITIES_ALL RFEA
      ,APPS.PO_VENDOR_SITES_ALL PVSA
      ,APPS.PO_VENDORS PV
      ,APPS.CLL_F189_INVOICE_TYPES RIT
 WHERE RII.ENTITY_ID  = RFEA.ENTITY_ID(+)
   AND RFEA.VENDOR_SITE_ID = PVSA.VENDOR_SITE_ID(+)
   AND RII.INVOICE_TYPE_ID = RIT.INVOICE_TYPE_ID(+)
   AND RII.ORGANIZATION_ID = RIT.ORGANIZATION_ID(+)
   AND PVSA.VENDOR_ID = PV.VENDOR_ID(+)
   AND RII.SOURCE = 'PSFRETE' 
   AND PROCESS_FLAG <> 6
order by 1, 3 ,6