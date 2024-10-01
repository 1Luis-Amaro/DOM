select ara.gl_date,
       acr.attribute_category,
       xal.accounting_class_code,
      (select meaning
         from apps.fnd_lookup_values
        where lookup_type = 'XLA_EVENT_PROCESS_STATUS'
          and lookup_code = xe.process_status_code
          and language = userenv('lang')) status,
       hp.party_name,
       acr.receipt_number doc_number,
       gcc.segment1||'-'||gcc.segment2||'-'||gcc.segment3||'-'||
       gcc.segment4||'-'||gcc.segment5||'-'||gcc.segment6||'-'||
       gcc.segment7 code_combination,
       decode(acr.currency_code, 'BRL', NULL, xal.entered_dr) entered_dr,
       decode(acr.currency_code, 'BRL', NULL, xal.entered_cr) entered_cr,
       xal.accounted_dr,
       xal.accounted_cr ,
       xal.description Orig_trx,
       gcc.segment1 location,
       gcc.segment2 minor,
       gcc.segment3 prime,
       gcc.segment4 subaccount,
       gcc.segment5 cost_center,
       gcc.segment6 product_line,
       gcc.segment7 interlo,
       (select encoded_msg
          from apps.xla_accounting_errors
         where event_id = xah.event_id
           and ledger_id = xah.ledger_id
           and (ae_line_num = xal.ae_line_num or ae_line_num is null)
           and rownum = 1) error_msg
  from apps.ar_cash_receipts_all acr,
       (select distinct event_id, status, cash_receipt_id, set_of_books_id, gl_date
          from apps.ar_receivable_applications_all) ara,
--       apps.ar_receivable_applications_all ara,
       apps.xla_ae_headers xah,
       apps.xla_ae_lines xal,
       apps.xla_events xe,
--       apps.xla_distribution_links xdl,
       apps.gl_code_combinations gcc,
       apps.hz_cust_accounts hca,
       apps.hz_parties hp
 where acr.cash_receipt_id = ara.cash_receipt_id
   and acr.status = ara.status
   and ara.event_id = xah.event_id
   and xah.ae_header_id = xal.ae_header_id
   and xah.event_id = xe.event_id
--   and xal.ae_header_id = xdl.ae_header_id
--   and xal.ae_line_num = xdl.ae_line_num
   and xal.code_combination_id = gcc.code_combination_id(+)
   and acr.pay_from_customer = hca.cust_account_id (+)
   and hca.party_id = hp.party_id(+)
   and xah.ledger_id = ara.set_of_books_id
   and xah.je_category_name = 'Receipts'
   and xal.displayed_line_number > 0
--   and ara.gl_date between '01-JUL-2014' and '31-AUG-2014'
--   and acr.receipt_number = 'CONTRATO 10020140904'
--   and acr.cash_receipt_id = 1005
--order by ara.gl_date, acr.receipt_number, hp.party_name, xal.accounting_class_code

union

select ara.gl_date,
       rct.attribute_category,
       xal.accounting_class_code,
      (select meaning
         from apps.fnd_lookup_values
        where lookup_type = 'XLA_EVENT_PROCESS_STATUS'
          and lookup_code = xe.process_status_code
          and language = userenv('lang')) status,
       hp.party_name,
       rct.trx_number doc_number,
       gcc.segment1||'-'||gcc.segment2||'-'||gcc.segment3||'-'||
       gcc.segment4||'-'||gcc.segment5||'-'||gcc.segment6||'-'||
       gcc.segment7 code_combination,
       decode(rct.invoice_currency_code, 'BRL', NULL, xdl.unrounded_entered_dr) entered_dr,
       decode(rct.invoice_currency_code, 'BRL', NULL, xdl.unrounded_entered_cr) entered_cr,
       xdl.unrounded_accounted_dr accounted_dr,
       xdl.unrounded_accounted_cr accounted_cr,
       xal.description Orig_trx,
       gcc.segment1 location,
       gcc.segment2 minor,
       gcc.segment3 prime,
       gcc.segment4 subaccount,
       gcc.segment5 cost_center,
       gcc.segment6 product_line,
       gcc.segment7 interlo,
       (select encoded_msg
          from apps.xla_accounting_errors
         where event_id = xah.event_id
           and ledger_id = xah.ledger_id
           and (ae_line_num = xal.ae_line_num or ae_line_num is null)
           and rownum = 1) error_msg
  from apps.ra_customer_trx_all rct,
       apps.ar_receivable_applications_all ara,
       apps.xla_ae_headers xah,
       apps.xla_events xe,
       apps.xla_ae_lines xal,
       apps.xla_distribution_links xdl,
       apps.gl_code_combinations gcc,
       apps.hz_cust_accounts hca,
       apps.hz_parties hp
 where rct.customer_trx_id = ara.customer_trx_id
   and ara.event_id = xah.event_id
   and ara.set_of_books_id = xah.ledger_id
   and xah.ae_header_id = xal.ae_header_id
   and xah.event_id = xe.event_id
   and xah.ae_header_id = xdl.ae_header_id
   and xal.ae_line_num = xdl.ae_line_num
   and xal.code_combination_id = gcc.code_combination_id(+)
   and xah.ledger_id = ara.set_of_books_id
   and rct.bill_to_customer_id = hca.cust_account_id
   and hca.party_id = hp.party_id
   and xah.je_category_name = 'Credit Memos'
   and xdl.accounting_line_code in ('PPG_BR_CM_APP_DEF_REC', 'CM_APP_REFUND')
   and xal.displayed_line_number > 0
order by gl_date, doc_number, party_name, accounting_class_code;