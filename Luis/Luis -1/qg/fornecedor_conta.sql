select a.primary_acct_owner_name,
       a.primary_acct_owner_party_id,
       a.bank_party_id,
       a.bank_name,
       a.bank_branch_name,
       a.bank_account_number,
       a.check_digits,
       a.bank_account_name
   from apps.po_vendors pv,
        apps.po_vendor_sites_all pvs,
        apps.hz_parties hp,
        apps.iby_ext_bank_accounts_v a
  where pv.vendor_id               = pvs.vendor_id
    and vendor_name                = a.primary_acct_owner_name
    and a.account_classification = 'EXTERNAL'
    and pv.party_id              = hp.party_id;
    
    