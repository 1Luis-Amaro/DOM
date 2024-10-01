Select rctg.gl_date ,
       (select distinct l.interface_line_context
          from ra_customer_trx_lines_all l,
               ra_customer_trx_all h
         where l.customer_trx_id = h.customer_trx_id
           and h.customer_trx_id = rct.customer_trx_id
           and l.line_type = 'LINE') context,
       (select meaning
          from fnd_lookup_values
         where lookup_type = 'XLA_EVENT_PROCESS_STATUS'
           and lookup_code = xe.process_status_code
           and language = userenv('lang')) status,
       rct.trx_number transaction_number,
       (select organization_code from mtl_parameters a,
          ra_customer_trx_lines_all b 
        where a.organization_id = b.warehouse_id and b.customer_trx_id = rct.customer_trx_id and b.line_type = 'LINE'
          and rownum = 1) filial,
       jrr.source_name Salesrep_name,
--       jrs.salesrep_number,
       (select segment5 from gl_code_combinations
        where code_combination_id = jrs.gl_id_rev) salesrep_cost_center,
       (select segment6 from gl_code_combinations
        where code_combination_id = jrs.gl_id_rev) salesrep_product_line,
       rctt.name trx_type,
       /*(select distinct event_class_code
          from zx_lines
             where (trx_line_id = rctl.customer_trx_line_id
                or rctl.tax_line_id = tax_line_id)) event_class, */
       (select distinct event_class_code
          from zx_lines
             where (trx_id = rct.customer_trx_id)) event_class,
       xal.accounting_class_code accounting_class,
       avt.global_attribute10 tax,
       xdl.unrounded_entered_dr debit,
       xdl.unrounded_entered_cr credit,
       gcc.segment1||'-'||gcc.segment2||'-'||gcc.segment3||'-'||gcc.segment4||'-'||gcc.segment5||'-'||gcc.segment6||'-'||gcc.segment7 code_combination,
       (select ct_reference from ra_customer_trx_all a where a.customer_trx_id = rct.customer_trx_id) source_doc,
       hp.party_name customer_name,
       ppg_ar_custom_sources_pk.get_customer_group(rct.batch_source_id, rct.trx_number, rct.org_id) customer_group,
       ppg_ar_custom_sources_pk.get_order_sales_channel(rctl.inventory_item_id, rctl.line_number, rct.batch_source_id,
                                                        rct.trx_number, rct.org_id, rctl.tax_line_id, rctg.account_class,
                                                        rct.interface_header_context) sales_channel,
       ppg_ar_custom_sources_pk.get_item_sbu(rctl.inventory_item_id, rctl.line_number, rct.batch_source_id,
                                                        rct.trx_number, rct.org_id, rctl.tax_line_id, rctg.account_class) SBU_item,
       ppg_ar_custom_sources_pk.get_item_product_line(rctl.inventory_item_id, rctl.line_number, rct.batch_source_id,
                                                        rct.trx_number, rct.org_id, rctl.tax_line_id, rctg.account_class) PL_item,
--       xal.description journal_line_desc,
       (select encoded_msg from xla_accounting_errors
        where event_id = xah.event_id and ledger_id = xah.ledger_id
        and ae_line_num = xal.ae_line_num and rownum = 1) error_msg,
        gcc.segment1 location,
        gcc.segment2 minor,
        gcc.segment3 prime,
        gcc.segment4 subaccount,
        gcc.segment5 cost_center,
        gcc.segment6 product_line,
        gcc.segment7 interloc
  From ra_cust_trx_line_gl_dist_all rctg,
       ra_customer_trx_lines_all rctl,
       ra_customer_trx_all rct,
       ra_cust_trx_types_all rctt,
       ar_vat_tax_all_b avt,
       hz_cust_accounts hca,
       hz_parties hp,
       xla_ae_headers xah,
       xla_ae_lines xal,
       xla_distribution_links xdl,
       gl_code_combinations gcc,
       xla_events xe,
       jtf_rs_salesreps jrs,
       jtf_rs_resource_extns jrr
 Where 1 = 1
   and rctg.customer_trx_line_id = rctl.customer_trx_line_id(+)
   and rctl.vat_tax_id = avt.vat_tax_id(+)
   and rctg.customer_trx_id = rct.customer_trx_id
   and rct.cust_trx_type_id = rctt.cust_trx_type_id
   and rct.bill_to_customer_id = hca.cust_account_id
   and hca.party_id = hp.party_id
   and rctg.event_id = xah.event_id
   and rctg.set_of_books_id = xah.ledger_id
   and xah.ae_header_id = xal.ae_header_id
   and xal.ae_header_id = xdl.ae_header_id
   and xal.ae_line_num = xdl.ae_line_num
   and xdl.source_distribution_id_num_1 = rctg.cust_trx_line_gl_dist_id
   and xal.code_combination_id = gcc.code_combination_id(+)
   and xah.event_id = xe.event_id
   and rct.primary_salesrep_id = jrs.salesrep_id(+)
   and jrs.resource_id = jrr.resource_id(+)
--   and rct.trx_number = '271'
--   and xal.ae_line_num = xae.ae_line_num(+)
--   and xah.ledger_id = xae.ledger_id
--   and rctg.CUSTOMER_TRX_ID = 77536
--   and rctg.event_id = 78871
--   and rctg.gl_date <= '01-AGO-2014'
   --and nvl(rctl.interface_line_context, 'OUTRO') <> 'CARGA_EMS'
   order by rctg.gl_date, rct.trx_number, filial, xal.accounting_class_code, avt.global_attribute10