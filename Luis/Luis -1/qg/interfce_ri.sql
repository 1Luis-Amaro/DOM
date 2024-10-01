select mp.organization_code        "Org",
       cfi.interface_invoice_id    "ID Interface",
       cfi.process_flag || ' - ' ||
         DECODE(cfi.process_flag,1,'A processar',
                                 2,'Processando',
                                 3,'Em retenção na Interface',
                                 4,'Retida',
                                 5,'Aprovada',
                                 6,'Processado')  "Status",
       rit.invoice_type_code       "Tipo Nota",
       cfi.DESCRIPTION             "Descricao",
       cfi.invoice_num             "Nota Fiscal",
       cfi.series                  "Serie",
      (SELECT meaning
         FROM apps.fnd_lookup_values_vl
        WHERE lookup_type = 'CLL_F189_FISCAL_DOCUMENT_MODEL'
          AND lookup_code = cfi.fiscal_document_model)
                                   "Especie",
       cfi.gl_date                 "GL Date",
       cfi.source                  "Origem",
       cfi.location_code           "Codigo do Local",
       cfi.IMPORTATION_NUMBER      "Numero do Documento",
       cfi.CIN_ATTRIBUTE3          "Processo Importação",
       cfi.RECEIVE_DATE            "Data Recebimento",
       cfi.GROSS_TOTAL_AMOUNT      "Valor Bruto",
       cfi.invoice_amount          "Valor Nota Fiscal"
  from apps.cll_f189_invoices_interface cfi, --apps.cll_f189_invoice_lines_iface cfl,
       apps.cll_f189_invoice_types      rit,
       apps.mtl_parameters              mp
 where mp.organization_id    = cfi.organization_id AND
       rit.invoice_type_id   = cfi.invoice_type_id AND
       cfi.process_flag     <> 6                   AND
       cfi.source            = 'SOFTWAY'           AND
       rit.invoice_type_code LIKE '%COMPL%';