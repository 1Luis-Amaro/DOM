Select jbao.gl_date gl_date,
       jbac.document_id,
      (select meaning
         from apps.fnd_lookup_values
        where lookup_type = 'XLA_EVENT_PROCESS_STATUS'
          and lookup_code = xe.process_status_code
          and language = userenv('lang')) status,
       rct.trx_number,
       aps.terms_sequence_number installment,
       hp.party_name customer_name,
--       jbao.bank_occurrence_code,
       jbao.description occurrence_type,
       xal.entered_dr debit,
       xal.entered_cr credit,
       gcc.segment1||'-'||gcc.segment2||'-'||gcc.segment3||'-'||gcc.segment4||'-'||gcc.segment5||'-'||gcc.segment6||'-'||gcc.segment7 Accounting
  from apps.ra_customer_trx_all rct,
       apps.ar_payment_schedules_all aps,
       apps.jl_br_ar_collection_docs_all jbac,
       apps.jl_br_ar_occurrence_docs_v jbao,
       apps.jl_br_ar_occurrence_docs_all jbao2,
--       xla.XLA_TRANSACTION_ENTITIES xte,
       apps.XLA_EVENTS xe,
       apps.xla_ae_headers xah,
       apps.xla_ae_lines xal,
       apps.gl_code_combinations gcc,
       apps.hz_parties hp,
       apps.hz_cust_accounts hca
 Where 1 = 1
   And rct.customer_trx_id = aps.customer_trx_id
   And aps.payment_schedule_id = jbac.payment_schedule_id
   And jbac.document_id = jbao.document_id
   And jbao.occurrence_id = jbao2.occurrence_id
--   And jbac.document_id = xte.source_id_int_1
   And jbao2.event_id = xe.event_id
   And xe.event_id = xah.event_id
   And xah.ae_header_id = xal.ae_header_id
   And xal.code_combination_id = gcc.code_combination_id
   And rct.set_of_books_id = xah.ledger_id
   And rct.bill_to_customer_id = hca.cust_account_id
   And hca.party_id = hp.party_id
--   And entity_code in  ('JL_BR_AR_COLL_DOC_OCCS','REMIT_COLL_DOC','CANCEL_COLL_DOC')
--   And rct.trx_number = '8'
--   And aps.terms_sequence_number = '1'
Order by xe.event_date,
         rct.trx_number,
         aps.terms_sequence_number