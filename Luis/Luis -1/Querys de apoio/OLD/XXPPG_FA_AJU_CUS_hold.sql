WITH tab_header AS (
 SELECT bc.book_type_code,
         bc.accounting_flex_structure,
         bc.distribution_source_book,
         sob.currency_code,
         cur.precision
  FROM   apps.FA_BOOK_CONTROLS bc,
         apps.GL_SETS_OF_BOOKS sob,
         apps.FND_CURRENCIES cur
  WHERE  1=1
  AND    sob.set_of_books_id = bc.set_of_books_id
  AND    cur.currency_code = sob.currency_code)
SELECT ASSET,
       ASSET_TYPE,
       cat_g,
       cat_sg,
       DESCR,
       COMP_CODE1 COMP_CODE,
       ASSET_ACCOUNT,
       COST_CENTER1 COST_CENTER,
       PROD_LINE,
   --    THID,
       SUM(DECODE(UNIT_SUM,
                  UNITS,
                  OLD_COST1 + OLD_COST - OLD_COST_RSUM,
                  OLD_COST1)) OLD_COST,
       SUM(DECODE(UNIT_SUM,
                  UNITS,
                  NEW_COST1 + NEW_COST - NEW_COST_RSUM,
                  NEW_COST1)) NEW_COST,
       SUM(DECODE(UNIT_SUM,
                  UNITS,
                  NEW_COST1 + NEW_COST - NEW_COST_RSUM,
                  NEW_COST1) - DECODE(UNIT_SUM,
                                      UNITS,
                                      OLD_COST1 + OLD_COST - OLD_COST_RSUM,
                                      OLD_COST1)) CHANGE
  FROM (SELECT DHCC.segment1 COMP_CODE1,
               UPS.MEANING ASSET_TYPE,
               DECODE(AH.ASSET_TYPE,
                      'CIP',
                      CB.CIP_COST_ACCT,
                      CB.ASSET_COST_ACCT) ASSET_ACCOUNT,
               DHCC.segment5 COST_CENTER1,
               DHCC.segment6 PROD_LINE,
               AD.ASSET_NUMBER ASSET,
               TH.TRANSACTION_HEADER_ID THID,
               AD.DESCRIPTION DESCR,
               ROUND((BOOKS_OLD.COST * NVL(DH.UNITS_ASSIGNED, AH.UNITS) /
                     AH.UNITS),
                     tab.PRECISION) OLD_COST1,
               (ROUND((BOOKS_OLD.COST * NVL(DH.UNITS_ASSIGNED, AH.UNITS) /
                      AH.UNITS),
                      tab.PRECISION) +
               ROUND(((BOOKS_NEW.COST - BOOKS_OLD.COST) *
                      NVL(DH.UNITS_ASSIGNED, AH.UNITS) / AH.UNITS),
                      tab.PRECISION)) NEW_COST1,
               SUM(ROUND((BOOKS_OLD.COST * NVL(DH.UNITS_ASSIGNED, AH.UNITS) /
                         AH.UNITS),
                         tab.PRECISION)) OVER(PARTITION BY DH.ASSET_ID ORDER BY DH.DISTRIBUTION_ID) OLD_COST_RSUM,
               SUM((ROUND((BOOKS_OLD.COST * NVL(DH.UNITS_ASSIGNED, AH.UNITS) /
                          AH.UNITS),
                          tab.PRECISION) +
                   ROUND(((BOOKS_NEW.COST - BOOKS_OLD.COST) *
                          NVL(DH.UNITS_ASSIGNED, AH.UNITS) / AH.UNITS),
                          tab.PRECISION))) OVER(PARTITION BY DH.ASSET_ID ORDER BY DH.DISTRIBUTION_ID) NEW_COST_RSUM,
               SUM(NVL(DH.UNITS_ASSIGNED, AH.UNITS)) OVER(PARTITION BY DH.ASSET_ID ORDER BY DH.DISTRIBUTION_ID) UNIT_SUM,
               AH.UNITS UNITS,
               BOOKS_OLD.COST OLD_COST,
               BOOKS_NEW.COST NEW_COST,
               cat.segment1 cat_g,
               cat.segment2 cat_sg,
               DP.PERIOD_COUNTER
          FROM apps.FA_ASSET_HISTORY  AH,
               apps.FA_ADDITIONS      AD,
               apps.FA_CATEGORIES     CAT,
               apps.FA_CATEGORY_BOOKS CB,
               apps.FA_BOOKS      BOOKS_OLD, -- commenting for bug 2754132
               apps.FA_BOOKS      BOOKS_NEW, -- commenting for bug 2754132
               apps.FA_LOOKUPS   UPS,
               apps.FA_DEPRN_PERIODS    DP,  -- commented for bug 2754132
               apps.FA_DISTRIBUTION_HISTORY DH,
               apps.GL_CODE_COMBINATIONS    DHCC,
               apps.FA_TRANSACTION_HEADERS  TH,
               --                              
               tab_header    tab
         WHERE 1=1   
           AND DP.BOOK_TYPE_CODE = tab.BOOK_TYPE_CODE
           AND TH.BOOK_TYPE_CODE = DP.BOOK_TYPE_CODE
           AND TH.DATE_EFFECTIVE BETWEEN DP.PERIOD_OPEN_DATE AND
               NVL(DP.PERIOD_CLOSE_DATE, SYSDATE)
           AND TH.TRANSACTION_TYPE_CODE IN ('ADJUSTMENT', 'CIP ADJUSTMENT')
           AND BOOKS_OLD.TRANSACTION_HEADER_ID_OUT =
               TH.TRANSACTION_HEADER_ID
           AND BOOKS_OLD.BOOK_TYPE_CODE = TH.BOOK_TYPE_CODE
           AND BOOKS_NEW.TRANSACTION_HEADER_ID_IN = TH.TRANSACTION_HEADER_ID
           AND BOOKS_NEW.BOOK_TYPE_CODE = TH.BOOK_TYPE_CODE
           AND AD.ASSET_ID = TH.ASSET_ID
           AND UPS.LOOKUP_TYPE = 'ASSET TYPE'
           AND CB.CATEGORY_ID = AH.CATEGORY_ID
           AND CB.BOOK_TYPE_CODE = TH.BOOK_TYPE_CODE
           AND CAT.CATEGORY_ID = CB.CATEGORY_ID
           AND AH.ASSET_ID = AD.ASSET_ID
           AND AH.ASSET_TYPE = UPS.LOOKUP_CODE
           AND TH.TRANSACTION_HEADER_ID >= AH.TRANSACTION_HEADER_ID_IN
           AND TH.TRANSACTION_HEADER_ID <
               NVL(AH.TRANSACTION_HEADER_ID_OUT,
                   TH.TRANSACTION_HEADER_ID + 1)
           AND TH.ASSET_ID = DH.ASSET_ID
           AND tab.BOOK_TYPE_CODE = DH.BOOK_TYPE_CODE
           AND TH.TRANSACTION_HEADER_ID >= DH.TRANSACTION_HEADER_ID_IN
           AND TH.TRANSACTION_HEADER_ID <
               NVL(DH.TRANSACTION_HEADER_ID_OUT,
                   TH.TRANSACTION_HEADER_ID + 1)
           AND DH.CODE_COMBINATION_ID = DHCC.CODE_COMBINATION_ID
           AND ROUND((BOOKS_OLD.COST * NVL(DH.UNITS_ASSIGNED, AH.UNITS) /
                     AH.UNITS),
                     tab.PRECISION) !=
               ROUND((BOOKS_NEW.COST * NVL(DH.UNITS_ASSIGNED, AH.UNITS) /
                     AH.UNITS),
                     tab.PRECISION))
 GROUP BY ASSET_TYPE,
          COMP_CODE1,
          COST_CENTER1,
          PROD_LINE,
          ASSET_ACCOUNT,
          ASSET,
          THID,
          cat_g,
          cat_sg,
          DESCR
 ORDER BY 1, 2, 3, 4, 5, 6