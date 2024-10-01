-- Supplier Site Level External Bank
 SELECT 'SITE_LVL' as APLVL,
 CAST(APS.VENDOR_ID AS INTEGER) AS AC_Id_Erp
,MTD.PAYMENT_METHOD_CODE
,'OFBRA' || '|' || IEB.BANK_ID || '|' || IEB.BRANCH_ID || '|' || IEB.EXT_BANK_ACCOUNT_ID AS erpnumber
,IEB.BANK_ACCOUNT_NAME AS name
,CASE WHEN ASSA.PAY_SITE_FLAG = 'Y' THEN 'remitto' END type_address
,'OFBRA' || '|' || APS.VENDOR_ID || '|' || ASSA.ORG_ID || '|' || ASSA.VENDOR_SITE_ID AS erpnumber_add
--,REPLACE(REPLACE(REPLACE(REPLACE(iep.REMIT_ADVICE_EMAIL,CHAR(09),''),CHAR(10),''),CHAR(13),''),CHAR(26),'') AS email
,IEB.CURRENCY_CODE
,CASE WHEN IEB.BANK_ACCOUNT_TYPE IS NULL THEN '(null)' ELSE IEB.BANK_ACCOUNT_TYPE END AS BANK_ACCOUNT_TYPE
,IEB.BANK_ACCOUNT_NUM AS bankAccountNumber
,IEB.CHECK_DIGITS AS Digit
,IEB.IBAN as ibanBankAccountNumber
,CASE WHEN IEB.BANK_ACCOUNT_NAME LIKE '%CHECK%' THEN 1 ELSE 0 END AS BanderaName
,BankOrgProfile.HOME_COUNTRY AS Bank_Home_Country
,BankOrgProfile.ORGANIZATION_NAME AS Bank_Name
,BankOrgProfile.BANK_OR_BRANCH_NUMBER AS Bank_Number
,BranchParty.PARTY_NAME AS Bank_Branch_Name
,BranchOrgProfile.BANK_OR_BRANCH_NUMBER AS Branch_Number
,BranchCP.eft_swift_code AS EFT_Swift_Code
,BranchTypeCA.class_code AS Bank_Branch_Type

FROM
    apps.hz_parties hzp
    INNER JOIN
    apps.ap_suppliers aps
        ON hzp.party_id = aps.party_id
    INNER JOIN
    apps.hz_party_sites site_supp
        ON hzp.party_id = site_supp.party_id
    INNER JOIN
    apps.ap_supplier_sites_all assa
        ON site_supp.party_site_id = assa.party_site_id
        AND assa.vendor_id = aps.vendor_id
    INNER JOIN
    apps.iby_external_payees_all iep
        ON iep.payee_party_id = hzp.party_id
        AND iep.party_site_id = site_supp.party_site_id
        AND iep.supplier_site_id = assa.vendor_site_id
    INNER JOIN
    apps.iby_pmt_instr_uses_all ipi
        ON iep.ext_payee_id = ipi.ext_pmt_party_id 
    INNER JOIN
    apps.iby_ext_bank_accounts ieb
        ON ipi.instrument_id = ieb.ext_bank_account_id
    INNER JOIN apps.IBY_EXT_PARTY_PMT_MTHDS MTD
        ON iep.EXT_PAYEE_ID = MTD.EXT_PMT_PARTY_ID
        AND MTD.PRIMARY_FLAG = 'Y'
        --- bank and branch info --
    INNER JOIN apps.HZ_ORGANIZATION_PROFILES BankOrgProfile
        on BankOrgProfile.PARTY_ID = ieb.BANK_ID
    INNER JOIN apps.HZ_CODE_ASSIGNMENTS BankCA
        on BankCA.OWNER_TABLE_ID = BankOrgProfile.PARTY_ID
        AND BankCA.CLASS_CODE = ('BANK')
        AND BankCA.OWNER_TABLE_NAME = 'HZ_PARTIES'
        AND (BankCA.STATUS = 'A' OR BankCA.STATUS IS NULL)
        AND BankCA.CLASS_CATEGORY = 'BANK_INSTITUTION_TYPE'
    INNER JOIN apps.HZ_RELATIONSHIPS         BRRel
        on  BankOrgProfile.PARTY_ID = BRRel.OBJECT_ID
        AND BRRel.RELATIONSHIP_TYPE = 'BANK_AND_BRANCH'
        AND BRRel.RELATIONSHIP_CODE = 'BRANCH_OF'
        AND BRRel.STATUS = 'A'
        AND BRRel.SUBJECT_TABLE_NAME = 'HZ_PARTIES'
        AND BRRel.OBJECT_TABLE_NAME = 'HZ_PARTIES'
        AND BRRel.OBJECT_TYPE = 'ORGANIZATION'
    INNER JOIN apps.HZ_PARTIES  BranchParty
        on BRRel.SUBJECT_ID = BranchParty.PARTY_ID
        and BranchParty.PARTY_ID = IEB.BRANCH_ID
        AND BranchParty.status = 'A'
    INNER JOIN apps.HZ_ORGANIZATION_PROFILES BranchOrgProfile
        on BranchOrgProfile.PARTY_ID = BranchParty.PARTY_ID
    INNER JOIN apps.HZ_CODE_ASSIGNMENTS  BranchCA
        on BranchCA.OWNER_TABLE_ID = BranchParty.PARTY_ID
        AND BranchCA.CLASS_CATEGORY = 'BANK_INSTITUTION_TYPE'
        AND BranchCA.CLASS_CODE = ('BANK_BRANCH')
        AND (BranchCA.STATUS = 'A' OR BranchCA.STATUS IS NULL)
    inner join apps.HZ_CODE_ASSIGNMENTS      BranchTypeCA
        ON BranchTypeCA.OWNER_TABLE_ID = BranchParty.PARTY_ID
          AND BranchTypeCA.CLASS_CATEGORY = 'BANK_BRANCH_TYPE'
          AND BranchTypeCA.PRIMARY_FLAG = 'Y'
          AND BranchTypeCA.OWNER_TABLE_NAME = 'HZ_PARTIES'
          AND BranchTypeCA.STATUS = 'A'
    LEFT JOIN apps.HZ_CONTACT_POINTS  BranchCP
        ON BranchCP.owner_table_id = BranchParty.party_id
        AND BranchCP.contact_point_type = 'EFT'
        AND BranchCP.status = 'A'
        AND BranchCP.owner_table_name = 'HZ_PARTIES'
WHERE 1=1
AND BankOrgProfile.version_number =
    (select max(version_number) from apps.HZ_ORGANIZATION_PROFILES BankOrgProfile2 where BankOrgProfile2.party_id = bankorgprofile.party_id)
and BranchOrgProfile.version_number = 
    (select max(version_number) from apps.HZ_ORGANIZATION_PROFILES BranchOrgProfile2 where BranchOrgProfile2.party_id = BranchOrgProfile.party_id)                              
and ipi.payment_flow = 'DISBURSEMENTS' --50197
    --inactive flags
and (hzp.STATUS = 'A' or hzp.status is null)
and (aps.END_DATE_ACTIVE is null or aps.end_date_active >= SYSDATE)
and (aps.ENABLED_FLAG = 'Y' or aps.enabled_flag is null)
and (iep.INACTIVE_DATE is null or iep.INACTIVE_DATE  >= SYSDATE)
and (ipi.END_DATE is null or ipi.END_DATE >= SYSDATE)
and (ieb.END_DATE is null or ieb.END_DATE >= SYSDATE)
and (MTD.INACTIVE_DATE is null or MTD.INACTIVE_DATE >= SYSDATE)
and (BankOrgProfile.EFFECTIVE_END_DATE is null or BankOrgProfile.EFFECTIVE_END_DATE >= SYSDATE)
and (BankCA.STATUS = 'A' or BankCA.STATUS is null)
and (bankca.END_DATE_ACTIVE is null or bankca.END_DATE_ACTIVE>= SYSDATE)
and (BRRel.STATUS = 'A' or BRRel.STATUS is null)
and (BRRel.END_DATE is null or BRRel.END_DATE>= SYSDATE)
and (BranchParty.STATUS = 'A' or BranchParty.STATUS is null)
and (BranchOrgProfile.EFFECTIVE_END_DATE is null or BranchOrgProfile.EFFECTIVE_END_DATE >= SYSDATE)
and (BranchCA.STATUS = 'A' or BranchCA.STATUS  is null)
and (branchca.END_DATE_ACTIVE is null or branchca.END_DATE_ACTIVE >= SYSDATE)
and (BranchTypeCA.STATUS = 'A' or BranchTypeCA.STATUS is null)
and (branchtypeca.END_DATE_ACTIVE is null or branchtypeca.END_DATE_ACTIVE >= SYSDATE)
and (BranchCP.STATUS = 'A' or BranchCP.STATUS is null);


----inactive site adds
and (site_supp.STATUS = 'A' or site_supp.STATUS is null)
and (site_supp.END_DATE_ACTIVE is null or site_supp.END_DATE_ACTIVE >= SYSDATE)
and (assa.INACTIVE_DATE is null or assa.INACTIVE_DATE >= SYSDATE)