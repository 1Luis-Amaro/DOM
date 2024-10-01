
SELECT hp.party_name,
          SUBSTR (hcas.global_attribute3, 2, 9)
       || hcas.global_attribute4
       || hcas.global_attribute5
          cnpj,
       hl.state,
       hl.city,
       b.name "COND_PAGTO"
  FROM apps.hz_parties hp,
       apps.hz_cust_accounts hca,
       apps.HZ_CUST_ACCT_SITES_ALL hcas,
       apps.HZ_CUST_SITE_USES_ALL hcsua,
       apps.hz_party_sites hps,
       apps.hz_locations hl,
       apps.ra_terms_vl b
 WHERE /*hp.party_name = 'ELECTROLUX DO BRASIL SA'
       AND*/ hp.party_id = hca.party_id
       AND hca.CUST_ACCOUNT_ID = hcas.CUST_ACCOUNT_ID
       AND hcsua.CUST_ACCT_SITE_ID = hcas.CUST_ACCT_SITE_ID
       AND hcsua.site_use_code = 'SHIP_TO'
       AND hps.party_id = hca.party_id
       AND hcas.party_site_id = hps.party_site_id
       AND hps.location_id = hl.location_id
       and sales_channel_code = 'IND'
       and hcsua.payment_term_id = b.term_id(+);