  select cash.CASH_RECEIPT_ID,cash.RECEIPT_NUMBER,cash.RECEIPT_DATE,cash.gl_date,cash.AMOUNT,
  cash.RECEIPT_STATUS,cash.CURRENCY_CODE,PAYMENT_METHOD_DSP,cash.customer_name
    from (  SELECT 
             CR.ROWID ROW_ID,
              CR.CASH_RECEIPT_ID CASH_RECEIPT_ID,
              CRH_CURRENT.CASH_RECEIPT_HISTORY_ID CASH_RECEIPT_HISTORY_ID,
              CR.AMOUNT AMOUNT,
              CRH_CURRENT.ACCTD_AMOUNT FUNCTIONAL_AMOUNT,
              CRH_CURRENT.AMOUNT NET_AMOUNT,
              CR.CURRENCY_CODE CURRENCY_CODE,
              CR.RECEIPT_NUMBER RECEIPT_NUMBER,
              CR.RECEIPT_DATE RECEIPT_DATE,
              CR.ANTICIPATED_CLEARING_DATE ANTICIPATED_CLEARING_DATE,
              CR.ACTUAL_VALUE_DATE ACTUAL_VALUE_DATE,
              CR.TYPE TYPE,
              CR.STATUS RECEIPT_STATUS,
              CR.COMMENTS COMMENTS,
              CR.MISC_PAYMENT_SOURCE MISC_PAYMENT_SOURCE,
              CR.EXCHANGE_RATE EXCHANGE_RATE,
              CR.EXCHANGE_DATE EXCHANGE_RATE_DATE,
              CR.EXCHANGE_RATE_TYPE EXCHANGE_RATE_TYPE,
              GL_DCT.USER_CONVERSION_TYPE EXCHANGE_RATE_TYPE_DSP,
              CR.DOC_SEQUENCE_ID DOC_SEQUENCE_ID,
              CR.DOC_SEQUENCE_VALUE DOCUMENT_NUMBER,
              CR.USSGL_TRANSACTION_CODE USSGL_TRANSACTION_CODE,
              CR.CUSTOMER_RECEIPT_REFERENCE CUSTOMER_RECEIPT_REFERENCE,
              REC_METHOD.NAME PAYMENT_METHOD_DSP,
              REC_METHOD.PAYMENT_CHANNEL_CODE PAYMENT_TYPE_CODE,
              REC_METHOD.RECEIPT_METHOD_ID RECEIPT_METHOD_ID,
              RC.NAME RECEIPT_CLASS_DSP,
              RC.BILL_OF_EXCHANGE_FLAG BILL_OF_EXCHANGE_FLAG,
              RC.CREATION_METHOD_CODE CREATION_METHOD_CODE,
              CR.PAY_FROM_CUSTOMER CUSTOMER_ID,
              RTRIM (RTRIM (SUBSTRB (PARTY.PARTY_NAME, 1, 50)),
                     TO_MULTI_BYTE (' '))
                 CUSTOMER_NAME,
              CUST.ACCOUNT_NUMBER CUSTOMER_NUMBER,
              SITE_USES.LOCATION LOCATION,
              CR.CUSTOMER_SITE_USE_ID CUSTOMER_SITE_USE_ID,
              CR.CUSTOMER_BANK_ACCOUNT_ID CUSTOMER_BANK_ACCOUNT_ID,
              CR.CUSTOMER_BANK_BRANCH_ID CUSTOMER_BANK_BRANCH_ID,
              DECODE (RC.CREATION_METHOD_CODE,
                      'MANUAL', EBA.BANK_ACCOUNT_NUMBER,
                      NULL)
                 CUSTOMER_BANK_ACCOUNT,
              DECODE (RC.CREATION_METHOD_CODE,
                      'MANUAL', EBA.BANK_ACCOUNT_NUMBER,
                      NULL)
                 CUSTOMER_BANK_ACCOUNT_NUM,
              DECODE (RC.CREATION_METHOD_CODE, 'MANUAL', EBA.BANK_NAME, NULL)
                 CUSTOMER_BANK_NAME,
              DECODE (RC.CREATION_METHOD_CODE,
                      'MANUAL', EBA.BANK_BRANCH_NAME,
                      NULL)
                 CUSTOMER_BANK_BRANCH,
              CRH_FIRST_POSTED.BATCH_ID BATCH_ID,
              DECODE (RC.CREATION_METHOD_CODE, 'BR', BAT_BR.NAME, BAT.NAME)
                 BATCH_NAME,
              DIST_SET.DISTRIBUTION_SET_NAME DISTRIBUTION_SET,
              CR.DISTRIBUTION_SET_ID DISTRIBUTION_SET_ID,
              CR.DEPOSIT_DATE DEPOSIT_DATE,
              CR.REFERENCE_TYPE REFERENCE_TYPE,
              CR.VAT_TAX_ID VAT_TAX_ID,
              VAT.TAX_RATE_CODE TAX_CODE,
              CR.TAX_RATE TAX_RATE,
              VAT.ALLOW_ADHOC_TAX_RATE_FLAG ADHOC_FLAG,
              L_REF_TYPE.MEANING REFERENCE_TYPE_DSP,
              CR.REFERENCE_ID REFERENCE_ID,
              CR.REMIT_BANK_ACCT_USE_ID REMIT_BANK_ACCT_USE_ID,
              BB.BANK_NAME REMIT_BANK_NAME,
              BB.BRANCH_PARTY_ID REMITTANCE_BANK_BRANCH_ID,
              BB.BANK_BRANCH_NAME REMIT_BANK_BRANCH,
              CBA.CURRENCY_CODE REMIT_BANK_CURRENCY,
              CRH_CURRENT.FACTOR_DISCOUNT_AMOUNT FACTOR_DISCOUNT_AMOUNT,
              PS.DUE_DATE MATURITY_DATE,
              PS.PAYMENT_SCHEDULE_ID PAYMENT_SCHEDULE_ID,
              CRH_CURRENT.STATUS STATE,
              CRH_CURRENT.GL_POSTED_DATE POSTED_DATE,
              REC_TRX.NAME ACTIVITY,
              REC_TRX.TAX_CODE_SOURCE TAX_CODE_SOURCE,
              CR.RECEIVABLES_TRX_ID RECEIVABLES_TRX_ID,
              CRH_CURRENT.GL_POSTED_DATE GL_POSTED_DATE,
              CRH_CURRENT.POSTING_CONTROL_ID POSTING_CONTROL_ID,
              CRH_FIRST_POSTED.GL_DATE GL_DATE,
              CR.ATTRIBUTE1 ATTRIBUTE1,
              CR.ATTRIBUTE2 ATTRIBUTE2,
              CR.ATTRIBUTE3 ATTRIBUTE3,
              CR.ATTRIBUTE4 ATTRIBUTE4,
              CR.ATTRIBUTE5 ATTRIBUTE5,
              CR.ATTRIBUTE6 ATTRIBUTE6,
              CR.ATTRIBUTE7 ATTRIBUTE7,
              CR.ATTRIBUTE8 ATTRIBUTE8,
              CR.ATTRIBUTE9 ATTRIBUTE9,
              CR.ATTRIBUTE10 ATTRIBUTE10,
              CR.ATTRIBUTE11 ATTRIBUTE11,
              CR.ATTRIBUTE12 ATTRIBUTE12,
              CR.ATTRIBUTE13 ATTRIBUTE13,
              CR.ATTRIBUTE14 ATTRIBUTE14,
              CR.ATTRIBUTE15 ATTRIBUTE15,
              CR.ATTRIBUTE_CATEGORY ATTRIBUTE_CATEGORY,
              CR.REVERSAL_DATE REVERSAL_DATE,
              DECODE (CR.REVERSAL_CATEGORY, NULL, NULL, L_REV_CAT.MEANING)
                 REVERSAL_CATEGORY_DSP,
              CR.REVERSAL_CATEGORY REVERSAL_CATEGORY,
              DECODE (CR.REVERSAL_CATEGORY, NULL, NULL, L_REV_CAT.DESCRIPTION)
                 CATEGORY_DESCRIPTION,
              CR.REVERSAL_COMMENTS REVERSAL_COMMENTS,
              DECODE (CR.REVERSAL_REASON_CODE, NULL, NULL, L_REV_REASON.MEANING)
                 REVERSAL_REASON,
              CR.REVERSAL_REASON_CODE REVERSAL_REASON_CODE,
              DECODE (CR.REVERSAL_REASON_CODE,
                      NULL, NULL,
                      L_REV_REASON.DESCRIPTION)
                 REVERSAL_REASON_DESCRIPTION,
              REM_BAT.NAME REMIT_BATCH,
              REM_BAT.BATCH_ID REMIT_BATCH_ID,
              NVL (CR.OVERRIDE_REMIT_ACCOUNT_FLAG, 'Y') OVERRIDE_REMIT_BANK,
              NVL (- (PS.AMOUNT_APPLIED), 0) APPLIED_AMOUNT,
              CR.CREATED_BY CREATED_BY,
              CR.CREATION_DATE CREATION_DATE,
              CR.LAST_UPDATED_BY LAST_UPDATED_BY,
              CR.LAST_UPDATE_DATE LAST_UPDATE_DATE,
              CR.LAST_UPDATE_LOGIN LAST_UPDATE_LOGIN,
              CR.REQUEST_ID REQUEST_ID,
              CR.PROGRAM_APPLICATION_ID PROGRAM_APPLICATION_ID,
              CR.PROGRAM_ID PROGRAM_ID,
              CR.PROGRAM_UPDATE_DATE PROGRAM_UPDATE_DATE,
              CR.GLOBAL_ATTRIBUTE_CATEGORY GLOBAL_ATTRIBUTE_CATEGORY,
              CR.GLOBAL_ATTRIBUTE1 GLOBAL_ATTRIBUTE1,
              CR.GLOBAL_ATTRIBUTE2 GLOBAL_ATTRIBUTE2,
              CR.GLOBAL_ATTRIBUTE3 GLOBAL_ATTRIBUTE3,
              CR.GLOBAL_ATTRIBUTE4 GLOBAL_ATTRIBUTE4,
              CR.GLOBAL_ATTRIBUTE5 GLOBAL_ATTRIBUTE5,
              CR.GLOBAL_ATTRIBUTE6 GLOBAL_ATTRIBUTE6,
              CR.GLOBAL_ATTRIBUTE7 GLOBAL_ATTRIBUTE7,
              CR.GLOBAL_ATTRIBUTE8 GLOBAL_ATTRIBUTE8,
              CR.GLOBAL_ATTRIBUTE9 GLOBAL_ATTRIBUTE9,
              CR.GLOBAL_ATTRIBUTE10 GLOBAL_ATTRIBUTE10,
              CR.GLOBAL_ATTRIBUTE11 GLOBAL_ATTRIBUTE11,
              CR.GLOBAL_ATTRIBUTE12 GLOBAL_ATTRIBUTE12,
              CR.GLOBAL_ATTRIBUTE13 GLOBAL_ATTRIBUTE13,
              CR.GLOBAL_ATTRIBUTE14 GLOBAL_ATTRIBUTE14,
              CR.GLOBAL_ATTRIBUTE15 GLOBAL_ATTRIBUTE15,
              CR.GLOBAL_ATTRIBUTE16 GLOBAL_ATTRIBUTE16,
              CR.GLOBAL_ATTRIBUTE17 GLOBAL_ATTRIBUTE17,
              CR.GLOBAL_ATTRIBUTE18 GLOBAL_ATTRIBUTE18,
              CR.GLOBAL_ATTRIBUTE19 GLOBAL_ATTRIBUTE19,
              CR.GLOBAL_ATTRIBUTE20 GLOBAL_ATTRIBUTE20,
              DECODE (
                 NVL (CR.CONFIRMED_FLAG, 'Y'),
                 'Y', DECODE (
                         CR.REVERSAL_DATE,
                         NULL, DECODE (
                                  CRH_CURRENT.STATUS,
                                  'REVERSED', 'N',
                                  DECODE (
                                     CRH_CURRENT.FACTOR_FLAG,
                                     'Y', DECODE (CRH_CURRENT.STATUS,
                                                  'RISK_ELIMINATED', 'N',
                                                  'Y'),
                                     DECODE (CRH_CURRENT.STATUS,
                                             'CLEARED', 'N',
                                             'Y'))),
                         'N'),
                 'N')
                 AT_RISK,
              REM_BAT.REMIT_METHOD_CODE REMITTANCE_METHOD,
              CR.ISSUER_NAME,
              CR.ISSUE_DATE,
              CR.ISSUER_BANK_BRANCH_ID,
              NotesBankParty.party_name,
              NotesBranchParty.party_name,
              CRH_CURRENT.NOTE_STATUS,
              CRH_NOTE_STATUS.MEANING,
              CRH_NOTE_STATUS.DESCRIPTION,
              RC.NOTES_RECEIVABLE,
              CR.PAYMENT_SERVER_ORDER_NUM,
              CR.APPROVAL_CODE,
              CR.ADDRESS_VERIFICATION_CODE,
              PS.CONS_INV_ID,
              CR.POSTMARK_DATE POSTMARK_DATE,
              CR.APPLICATION_NOTES APPLICATION_NOTES,
              CR.ORG_ID,
              CR.REC_VERSION_NUMBER REC_VERSION_NUMBER,
              CR.LEGAL_ENTITY_ID,
              CR.PAYMENT_TRXN_EXTENSION_ID,
              REC_METHOD.PAYMENT_CHANNEL_CODE,
              cr.automatch_set_id,
              cr.autoapply_flag
         FROM apps.CE_BANK_ACCOUNTS CBA,
              apps.CE_BANK_ACCT_USES_OU REMIT_BANK,
              apps.ZX_RATES_B VAT,
              apps.ZX_ACCOUNTS ACCOUNTS,
              apps.HZ_CUST_ACCOUNTS CUST,
              apps.HZ_PARTIES PARTY,
              apps.AR_RECEIPT_METHODS REC_METHOD,
              apps.AR_RECEIPT_CLASSES RC,
              apps.HZ_CUST_SITE_USES_ALL SITE_USES,
              apps.AR_LOOKUPS CRH_NOTE_STATUS,
              apps.AR_LOOKUPS L_REV_CAT,
              apps.AR_LOOKUPS L_REV_REASON,
              apps.AR_LOOKUPS L_REF_TYPE,
              apps.GL_DAILY_CONVERSION_TYPES GL_DCT,
              apps.AR_CASH_RECEIPT_HISTORY_ALL CRH_REM,
              apps.AR_BATCHES_ALL REM_BAT,
              apps.AR_RECEIVABLES_TRX_ALL REC_TRX,
              apps.AR_DISTRIBUTION_SETS_ALL DIST_SET,
              apps.AR_PAYMENT_SCHEDULES_ALL PS,
              apps.AR_CASH_RECEIPT_HISTORY_ALL CRH_CURRENT,
              apps.AR_BATCHES_ALL BAT,
              apps.AR_BATCHES_ALL BAT_BR,
              apps.AR_CASH_RECEIPTS_all CR,
              apps.AR_CASH_RECEIPT_HISTORY_ALL CRH_FIRST_POSTED,
              apps.HZ_PARTIES NotesBranchParty,
              apps.HZ_PARTIES NotesBankParty,
              apps.HZ_RELATIONSHIPS NotesBRRel,
              apps.CE_BANK_BRANCHES_V BB,
              apps.IBY_EXT_BANK_ACCOUNTS_V EBA
        WHERE     CR.PAY_FROM_CUSTOMER = CUST.CUST_ACCOUNT_ID(+)
              AND CUST.PARTY_ID = PARTY.PARTY_ID(+)
              AND CRH_NOTE_STATUS.LOOKUP_TYPE(+) = 'AR_NOTE_STATUS'
              AND CRH_NOTE_STATUS.LOOKUP_CODE(+) = CRH_CURRENT.NOTE_STATUS
              AND REMIT_BANK.BANK_ACCT_USE_ID(+) = CR.REMIT_BANK_ACCT_USE_ID
              AND REMIT_BANK.ORG_ID(+) = CR.ORG_ID
              AND VAT.TAX_RATE_ID(+) = CR.VAT_TAX_ID
              AND ACCOUNTS.TAX_ACCOUNT_ENTITY_ID(+) = CR.VAT_TAX_ID
              AND accounts.tax_account_entity_code(+) = 'RATES'
              AND CR.RECEIPT_METHOD_ID = REC_METHOD.RECEIPT_METHOD_ID
              AND REC_METHOD.RECEIPT_CLASS_ID = RC.RECEIPT_CLASS_ID
              AND CR.CUSTOMER_SITE_USE_ID = SITE_USES.SITE_USE_ID(+)
              AND CR.ORG_ID = SITE_USES.ORG_ID(+)
              AND CR.RECEIVABLES_TRX_ID = REC_TRX.RECEIVABLES_TRX_ID(+)
              AND CR.ORG_ID = REC_TRX.ORG_ID(+)
              AND CR.DISTRIBUTION_SET_ID = DIST_SET.DISTRIBUTION_SET_ID(+)
              AND CR.ORG_ID = DIST_SET.ORG_ID(+)
              AND L_REV_CAT.LOOKUP_TYPE(+) = 'REVERSAL_CATEGORY_TYPE'
              AND L_REV_CAT.LOOKUP_CODE(+) = CR.REVERSAL_CATEGORY
              AND L_REV_REASON.LOOKUP_TYPE(+) = 'CKAJST_REASON'
              AND L_REV_REASON.LOOKUP_CODE(+) = CR.REVERSAL_REASON_CODE
              AND L_REF_TYPE.LOOKUP_CODE(+) = CR.REFERENCE_TYPE
              AND L_REF_TYPE.LOOKUP_TYPE(+) = 'CB_REFERENCE_TYPE'
              AND GL_DCT.CONVERSION_TYPE(+) = CR.EXCHANGE_RATE_TYPE
              AND CRH_REM.CASH_RECEIPT_ID(+) = CR.CASH_RECEIPT_ID
              AND CRH_REM.ORG_ID(+) = CR.ORG_ID
              AND NOT EXISTS
                     (SELECT  
                             CASH_RECEIPT_HISTORY_ID
                        FROM apps.AR_CASH_RECEIPT_HISTORY_ALL CRH3
                       WHERE     CRH3.STATUS = 'REMITTED'
                             AND CRH3.CASH_RECEIPT_ID = CR.CASH_RECEIPT_ID
                             AND CRH3.CASH_RECEIPT_HISTORY_ID <
                                    CRH_REM.CASH_RECEIPT_HISTORY_ID)
              AND CRH_REM.STATUS(+) = 'REMITTED'
              AND CRH_REM.BATCH_ID = REM_BAT.BATCH_ID(+)
              AND CRH_REM.ORG_ID = REM_BAT.ORG_ID(+)
              AND REM_BAT.TYPE(+) = 'REMITTANCE'
              AND PS.CASH_RECEIPT_ID(+) = CR.CASH_RECEIPT_ID
              AND PS.ORG_ID(+) = CR.ORG_ID
              AND CRH_CURRENT.CASH_RECEIPT_ID = CR.CASH_RECEIPT_ID
              AND CRH_CURRENT.ORG_ID = CR.ORG_ID
              AND CRH_CURRENT.CURRENT_RECORD_FLAG = NVL ('Y', CR.RECEIPT_NUMBER)
              AND CRH_FIRST_POSTED.BATCH_ID = BAT.BATCH_ID(+)
              AND CRH_FIRST_POSTED.ORG_ID = BAT.ORG_ID(+)
              AND BAT.TYPE(+) = 'MANUAL'
              AND CRH_FIRST_POSTED.CASH_RECEIPT_ID(+) = CR.CASH_RECEIPT_ID
              AND CRH_FIRST_POSTED.ORG_ID(+) = CR.ORG_ID
              AND CRH_FIRST_POSTED.FIRST_POSTED_RECORD_FLAG(+) = 'Y'
              AND CRH_FIRST_POSTED.BATCH_ID = BAT_BR.BATCH_ID(+)
              AND CRH_FIRST_POSTED.ORG_ID = BAT_BR.ORG_ID(+)
              AND BAT_BR.TYPE(+) = 'BR'
              AND NotesBranchParty.party_id(+) = CR.issuer_bank_branch_id
              AND NotesBRRel.object_id = NotesBankParty.party_id(+)
              AND NotesBRRel.subject_id(+) = NotesBranchParty.party_id
              AND NotesBRRel.relationship_type(+) = 'BANK_AND_BRANCH'
              AND NotesBRRel.relationship_code(+) = 'BRANCH_OF'
              AND NotesBRRel.subject_table_name(+) = 'HZ_PARTIES'
              AND NotesBRRel.subject_type(+) = 'ORGANIZATION'
              AND NotesBRRel.object_table_name(+) = 'HZ_PARTIES'
              AND NotesBRRel.object_type(+) = 'ORGANIZATION'
              AND remit_bank.bank_account_id = CBA.bank_account_id(+)
              AND BB.BRANCH_PARTY_ID(+) = CBA.BANK_BRANCH_ID
              AND EBA.ext_bank_account_id(+) = CR.CUSTOMER_BANK_ACCOUNT_ID
              AND cr.org_id = accounts.internal_organization_id(+)) cash
             order by 2,1