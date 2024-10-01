SELECT F.ASSET_ID,
               B.JE_CATEGORY_NAME CATEGORY,
               TO_CHAR(B.ACCOUNTING_DATE, 'YYYY-MM') PERIOD,
               A.ACCOUNTING_CLASS_CODE CLASS,
               C.SEGMENT1 LOC,
               C.SEGMENT2 MINOR,
               C.SEGMENT3 PRIME,
               C.SEGMENT4 ACCOUNT_CODE,
               C.SEGMENT5 CC,
               C.SEGMENT6 PL,
               C.SEGMENT7 INT_LOC,
               --ACCA.DESCRIPTION ACC_DESCRIPTION,
               SUM(NVL(A.ENTERED_DR, 0) - NVL(A.ENTERED_CR, 0)) SLA_AMOUNT
          FROM XLA.XLA_AE_LINES A,
               XLA.XLA_AE_HEADERS B,
               APPS.GL_CODE_COMBINATIONS C,
               XLA.XLA_EVENTS D,
               XLA.XLA_TRANSACTION_ENTITIES E,
               APPS.FA_DEPRN_EVENTS F
         WHERE A.AE_HEADER_ID = B.AE_HEADER_ID
           AND A.CODE_COMBINATION_ID = C.CODE_COMBINATION_ID
           AND B.EVENT_ID = D.EVENT_ID
           --AND C.SEGMENT3 = ACCA.FLEX_VALUE
           AND D.ENTITY_ID = E.ENTITY_ID(+)
           AND B.EVENT_ID = F.EVENT_ID(+)
           AND B.ACCOUNTING_DATE IS NOT NULL
           AND B.JE_CATEGORY_NAME = 'Depreciation'
           --AND F.ASSET_ID = 112225
         GROUP BY F.ASSET_ID,
                  B.JE_CATEGORY_NAME,
                  C.SEGMENT1,
                  C.SEGMENT2,
                  C.SEGMENT3,
                  C.SEGMENT4,
                  C.SEGMENT5,
                  C.SEGMENT6,
                  C.SEGMENT7,
                  A.ACCOUNTING_CLASS_CODE,
                  --ACCA.DESCRIPTION,
                  TO_CHAR(B.ACCOUNTING_DATE, 'YYYY-MM')