SELECT distinct
       rct.trx_number NUMERO_NF,
       rct.trx_date DATA_NF,
       rct.customer_trx_id,
       (select name from apps.ra_cust_trx_types_all where cust_trx_type_id = rct.cust_trx_type_id) Tipo,
       (select name from apps.ra_batch_sources_all  where batch_source_id = rct.batch_source_id) batch_source
       ,xl1.meaning Status_Contabil 
 FROM apps.ra_cust_trx_line_gl_dist_all rctg
    , apps.ra_customer_trx_lines_all    rctl
    , apps.ra_customer_trx_all          rct
    , apps.ra_cust_trx_types_all        rctt
    , apps.ar_vat_tax_all_b             avt
    , apps.hz_cust_accounts             hca
    , apps.hz_parties                   hp
    , apps.xla_ae_headers               xah
    , apps.xla_ae_lines                 xal
    , apps.xla_distribution_links       xdl
    , apps.gl_code_combinations         gcc
    , apps.xla_events                   xe
    , apps.xla_lookups xl1
    
WHERE 1 = 1
  AND rctg.customer_trx_line_id        = rctl.customer_trx_line_id (+)
  AND rctl.vat_tax_id                  = avt.vat_tax_id            (+)
  AND xal.code_combination_id          = gcc.code_combination_id   (+)
  AND rctg.customer_trx_id             = rct.customer_trx_id
  AND rct.cust_trx_type_id             = rctt.cust_trx_type_id
  AND rct.bill_to_customer_id          = hca.cust_account_id
  AND hca.party_id                     = hp.party_id
  AND rctg.event_id                    = xah.event_id
  AND rctg.set_of_books_id             = xah.ledger_id
  AND xah.ae_header_id                 = xal.ae_header_id
  AND xal.ae_header_id                 = xdl.ae_header_id
  AND xal.ae_line_num                  = xdl.ae_line_num
  AND xdl.source_distribution_id_num_1 = rctg.cust_trx_line_gl_dist_id
  AND xah.event_id                     = xe.event_id
  --AND rctg.CUSTOMER_TRX_ID             = 121344
  AND xl1.lookup_type = 'XLA_ACCOUNTING_ENTRY_STATUS'
  AND xl1.lookup_code = xah.accounting_entry_status_code