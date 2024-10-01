Select rct.trx_date data_emissao,
       hp.party_name nome_cliente,
       rct.trx_number numero_nf,
       aps.amount_due_original valor_nf,
       rt.name cond_pagto,
      (Select name
         From apps.ra_terms
        Where term_id = rt.attribute8) cond_pagto_vendor,
       rt.description desc_cond_pagto
  From apps.ra_customer_trx_all rct,
       apps.ar_payment_schedules_all aps,
       apps.ra_terms rt,
       apps.hz_cust_accounts hca,
       apps.hz_parties hp
 Where rct.customer_trx_id = aps.customer_trx_id
   And rct.term_id = rt.term_id
   And rct.bill_to_customer_id = hca.cust_account_id
   And hca.party_id = hp.party_id
   And nvl(rt.attribute7, 'N') = 'Y'
   And aps.amount_due_original = aps.amount_due_remaining
order by rct.trx_date,
         hp.party_name,
         rct.trx_number
