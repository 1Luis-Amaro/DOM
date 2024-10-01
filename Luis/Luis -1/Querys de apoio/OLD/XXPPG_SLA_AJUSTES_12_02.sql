select adj.gl_date,
       hp.party_name customer_name,
       (select meaning
         from apps.fnd_lookup_values
        where lookup_type = 'XLA_EVENT_PROCESS_STATUS'
          and lookup_code = xe.process_status_code
          and language = userenv('lang')) status,
       adj.adjustment_number,
       art.name adj_name,
       art.attribute1 adj_type,
       rct.trx_number invoice_number,
       rbs.name invoice_source,
       xal.accounting_class_code class,
       xal.accounted_dr,
       xal.accounted_cr,
       gcc.segment1||'-'||gcc.segment2||'-'||gcc.segment3||'-'||
       gcc.segment4||'-'||gcc.segment5||'-'||gcc.segment6||'-'||
       gcc.segment7 code_combination,
       (select encoded_msg
          from apps.xla_accounting_errors
         where event_id = xah.event_id
           and ledger_id = xah.ledger_id
           and (ae_line_num = xal.ae_line_num or ae_line_num is null)
           and rownum = 1) error_msg,
       gcc.segment1 location,
       gcc.segment2 minor,
       gcc.segment3 prime,
       gcc.segment4 subaccount,
       gcc.segment5 cost_center,
       gcc.segment6 product_line,
       gcc.segment7 interloc
  from apps.ar_adjustments_all adj,
       apps.ar_receivables_trx_all art,
       apps.xla_ae_headers xah,
       apps.xla_ae_lines xal,
       apps.xla_events xe,
       apps.gl_code_combinations gcc,
       apps.hz_parties hp,
       apps.hz_cust_accounts hca,
       apps.ra_customer_trx_all rct,
       apps.ra_batch_sources_all rbs
 where adj.receivables_trx_id = art.receivables_trx_id
   and adj.event_id = xah.event_id
   and adj.set_of_books_id = xah.ledger_id
   and xah.ae_header_id = xal.ae_header_id
   and xah.event_id = xe.event_id
   and adj.customer_trx_id = rct.customer_trx_id
   and xal.code_combination_id = gcc.code_combination_id(+)
   and hp.party_id = hca.party_id
   and hca.cust_account_id = rct.bill_to_customer_id
   and rct.batch_source_id = rbs.batch_source_id
--   and adj.adjustment_number = '13013'
order by adj.gl_date,
         adj.adjustment_number,
         rct.trx_number,
         hp.party_name