select asa.* /*,
       assa.vendor_id,
       assa.vendor_site_id,
       asa.vendor_type_lookup_code,
       asa.attribute1,
       asa.segment1,
       assa.vendor_site_code,
       Assa.Global_Attribute10,
       Assa.Global_Attribute11,
       Assa.Global_Attribute12,
       asa.vendor_name,
       assa.city,
       assa.state,
       assa.address_line1,
       assa.address_lines_alt,
       assa.address_line2,
       assa.address_line3, 
       assa.zip,
       Hp.Party_Name,
       asa.Party_Id,
       Assa.party_site_id,
       Assa.Global_Attribute9,
       Assa.Global_Attribute10,
       Assa.Global_Attribute11,
       Assa.Global_Attribute12,
       Assa.Global_Attribute13,
       Assa.Global_Attribute14,
       Assa.Global_Attribute15,
       DECODE(Assa.Global_Attribute9
             ,2,(lpad(Assa.Global_Attribute10,9,'0') || Assa.Global_Attribute11 || Assa.Global_Attribute12)
             ,3,'E'||lpad(SUBSTR(Assa.Global_Attribute10,4,6),6,'0')||'000100'
             ,1,lpad(Assa.Global_Attribute10,9,'0')||Assa.Global_Attribute12) CNPJ,
       (select 'S' from apps.hz_party_site_uses where party_site_id = Assa.party_site_id and site_use_type = 'PAY' and status = 'A') PAY,
       (select 'S' from apps.hz_party_site_uses where party_site_id = Assa.party_site_id and site_use_type = 'PURCHASING' and status = 'A') PURCHASING
       */
--
From   APPS.Ap_Supplier_Sites_All Assa,
       APPS.Ap_Suppliers          Asa,
       APPS.Hz_Parties            Hp,
       APPS.Hz_Party_sites  Hps,
       hz_cust_accounts hca,
       HZ_CUSTOMER_PROFILES hcp,
       ap_terms apt
--       
Where  Assa.Vendor_Id = Asa.Vendor_Id
       AND ASSA.TERMS_ID = apt.TERM_ID
       And Asa.Party_Id = Hp.Party_Id(+)
       And Assa.Org_Id = 82
       and hp.party_id = hps.party_id
       and Assa.PARTY_SITE_ID = Hps.PARTY_SITE_ID
       and hca.party_id = hp.party_id
       and hcp.cust_account_id = hca.cust_account_id 
       and asa.segment1 = '029512332'

---------------------------------------------

select * from cll_f189_states;  -- Estado
select * from cll_f189_cities;  -- Cidades

SELECT distinct(meaning)
  FROM fnd_lookups fl,
       PO_Vendor_Sites_All pvsa
 WHERE fl.lookup_type = 'JLBR_INSCRIPTION_TYPE'
   AND fl.lookup_code = pvsa.Global_Attribute9
   AND NVL(fl.start_date_active, SYSDATE) <= SYSDATE
   AND NVL(fl.end_date_active, SYSDATE)   >= SYSDATE
   AND fl.enabled_flag = 'Y';

---------------------------------------------   
       
select * from ap_terms;       
--- Dados bancários Fornecedor ---

select * from APPS.Ap_Supplier_Sites_All Assa;

select * from APPS.PO_Vendor_Sites_All;

select * from apps.po_vendors;



SELECT instrument.*
FROM apps.iby_pmt_instr_uses_all instrument,
apps.iby_account_owners owners,
apps.iby_external_payees_all payees,
apps.iby_ext_bank_accounts ieb,
apps.ap_supplier_sites_all asa,
apps.ap_suppliers asp,
apps.ce_bank_branches_v cbbv
WHERE owners.ext_bank_account_id =ieb.ext_bank_account_id
AND owners.ext_bank_account_id=instrument.instrument_id
AND payees.ext_payee_id=instrument.ext_pmt_party_id
AND cbbv.branch_party_id=ieb.branch_id
AND payees.payee_party_id=owners.account_owner_party_id
AND payees.supplier_site_id=asa.vendor_site_id
AND asa.vendor_id=asp.vendor_id
and payees.party_site_id = asa.party_site_id
and asa.vendor_id = 1167908 

select * from fnd_lookupS where lookup_code like '%VENDOR%';

SELECT instrument.*, cbbv.*, owners.account_owner_party_id,
  asp.segment1 vendor_num,
  asp.vendor_name,
  (SELECT NAME
  FROM apps.hr_operating_units hou
  WHERE 1                 = 1
  AND hou.organization_id = asa.org_id
  ) ou_name,
  asa.vendor_site_code,
  ieb.country_code,
  cbbv.bank_name,
  cbbv.bank_number,
  cbbv.bank_branch_name,
  cbbv.branch_number,
  cbbv.bank_branch_type,
  cbbv.eft_swift_code,
  ieb.bank_account_num,
  ieb.currency_code,
  ieb.iban,
  ieb.foreign_payment_use_flag,
  ieb.bank_account_name
FROM apps.iby_pmt_instr_uses_all instrument,
     apps.iby_account_owners owners,
     apps.iby_external_payees_all payees,
     apps.iby_ext_bank_accounts ieb,
     apps.ap_supplier_sites_all asa,
     apps.ap_suppliers asp,
     apps.ce_bank_branches_v cbbv
WHERE owners.primary_flag      = 'Y'
AND owners.ext_bank_account_id = ieb.ext_bank_account_id
AND owners.ext_bank_account_id = instrument.instrument_id
AND payees.ext_payee_id        = instrument.ext_pmt_party_id
AND payees.payee_party_id      = owners.account_owner_party_id
AND payees.supplier_site_id    = asa.vendor_site_id
AND asa.vendor_id              = asp.vendor_id
AND cbbv.branch_party_id(+)    = ieb.branch_id
  --and asp.vendor_name like '%ABC Emp, Name'
AND asp.vendor_id =  1167908; 

--- Dados bancários do Fornecedor ---       
       
select PAYMENT_METHOD_LOOKUP_CODE from apps.AP_SUPPLIERs where PAYMENT_METHOD_LOOKUP_CODE is not null;       
       
SELECT * from PO_Vendors where segment1 = '029512332';
       
       
select * from PO_Vendor_Contacts;       

select count(*) --to_char(trunc(LAST_UPDATE_DATE),'mm-yyyy')
  from APPS.Ap_Suppliers asa
 where END_DATE_ACTIVE is null;
 
select * from cll_f189_states;  -- Estado
select * from cll_f189_cities;  -- Cidades

SELECT distinct(meaning)
  FROM fnd_lookups fl,
       PO_Vendor_Sites_All pvsa
 WHERE fl.lookup_type = 'JLBR_INSCRIPTION_TYPE'
   AND fl.lookup_code = pvsa.Global_Attribute9
   AND NVL(fl.start_date_active, SYSDATE) <= SYSDATE
   AND NVL(fl.end_date_active, SYSDATE)   >= SYSDATE
   AND fl.enabled_flag = 'Y';

SELECT meaning
  FROM fnd_lookups fl
 WHERE /*fl.lookup_type = 'JLBR_INSCRIPTION_TYPE'
   AND*/ fl.meaning like 'Fornecedor';
   AND NVL(fl.start_date_active, SYSDATE) <= SYSDATE
   AND NVL(fl.end_date_active, SYSDATE)   >= SYSDATE
   AND fl.enabled_flag = 'Y';

 
select count(*) from APPS.Ap_Supplier_Sites_All Assa where END_DATE_ACTIVE is null; 

select count(*) from APPS.Ap_Supplier_Sites_All Assa where INACTIVE_DATE is null;

select to_char(trunc(CREATION_DATE),'mm-yyyy') from apps.po_headers_all where TYPE_LOOKUP_CODE <> 'BLANKET';

select to_char(trunc(CREATION_DATE),'mm-yyyy') from cll.cll_f189_invoices cfi where AP_INTERFACE_FLAG = 'Y' and FISCAL_DOCUMENT_MODEL = '55';

select * from cll.cll_f189_invoices cfi where AP_INTERFACE_FLAG = 'Y' and FISCAL_DOCUMENT_MODEL = '55';ce_bank_branches_v




select TERRITORY_CODE,TERRITORY_SHORT_NAME,DESCRIPTION
 from APPS.FND_TERRITORIES_VL;

select ORGANIZATION_ID,NAME,SHORT_CODE
 from APPS. HR_OPERATING_UNITS;

select CURRENCY_CODE,ISSUING_TERRITORY_CODE,NAME,DESCRIPTION
 from APPS. FND_CURRENCIES_VL;

select LANGUAGE_CODE,NLS_LANGUAGE,NLS_TERRITORY
 from APPLSYS.FND_LANGUAGES;
 
 select GEOGRAPHY_TYPE,GEOGRAPHY_NAME,GEOGRAPHY_CODE,COUNTRY_CODE, GEOGRAPHY_ELEMENT2_CODE
 from APPS.HZ_GEOGRAPHIES where GEOGRAPHY_TYPE = 'STATE';

select INCOME_TAX_TYPE,DESCRIPTION
 from AP. AP_INCOME_TAX_TYPES;

select LOOKUP_TYPE,LOOKUP_CODE,ENABLED_FLAG,MEANING,DESCRIPTION
     from APPS.FND_LOOKUP_VALUES_VL where LOOKUP_TYPE= 'JLBR_INSCRIPTION_TYPE';
 
 select LOOKUP_TYPE,LOOKUP_CODE,ENABLED_FLAG,MEANING,DESCRIPTION
 from APPS.FND_LOOKUP_VALUES_VL where LOOKUP_TYPE= 'PAY DATE BASIS';

 select LOOKUP_TYPE,LOOKUP_CODE,ENABLED_FLAG,MEANING,DESCRIPTION
 from APPS.FND_LOOKUP_VALUES_VL where LOOKUP_TYPE= 'TERMS DATE BASIS';
 
 
 
select LOOKUP_TYPE,LOOKUP_CODE,ENABLED_FLAG,MEANING,DESCRIPTION
 from APPS.FND_LOOKUP_VALUES_VL where LOOKUP_TYPE= 'PAY GROUP';
 
select LOOKUP_TYPE,LOOKUP_CODE,ENABLED_FLAG,MEANING,DESCRIPTION
 from aPPS.FND_LOOKUP_VALUES_VL where LOOKUP_TYPE = 'ORGANIZATION TYPE';
 
 
select LOOKUP_TYPE,LOOKUP_CODE,ENABLED_FLAG,MEANING,DESCRIPTION
 from aPPS.FND_LOOKUP_VALUES_VL where LOOKUP_TYPE = 'VENDOR TYPE';
 
select LOOKUP_TYPE,LOOKUP_CODE,ENABLED_FLAG,MEANING,DESCRIPTION
 from aPPS.FND_LOOKUP_VALUES_VL where LOOKUP_TYPE = 'IBY_DELIVERY_METHODS'; 
 
select LOOKUP_TYPE,LOOKUP_CODE,ENABLED_FLAG,MEANING,DESCRIPTION
 from aPPS.FND_LOOKUP_VALUES_VL where LOOKUP_TYPE = 'TITLE';  
 
select LOOKUP_TYPE,LOOKUP_CODE,ENABLED_FLAG,MEANING,DESCRIPTION
 from aPPS.FND_LOOKUP_VALUES_VL where LOOKUP_TYPE = 'FREIGHT TERMS';  
  
select LOOKUP_TYPE,LOOKUP_CODE,ENABLED_FLAG,MEANING,DESCRIPTION
     from aPPS.FND_LOOKUP_VALUES_VL where LOOKUP_TYPE = 'FOB';   
 
select PAYMENT_METHOD_LOOKUP_CODE from 

