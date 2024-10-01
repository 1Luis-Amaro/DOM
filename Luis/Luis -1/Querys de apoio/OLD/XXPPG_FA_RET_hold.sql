WITH TAB_PERIODS AS
 (SELECT PERIOD_COUNTER PERIOD_PC,
         PERIOD_OPEN_DATE PERIOD_POD,
         NVL(PERIOD_CLOSE_DATE, SYSDATE) PERIOD_PCD,
         FISCAL_YEAR PERIOD_FY,
         BOOK_TYPE_CODE BOOK,
         PERIOD_NAME
    FROM APPS.FA_DEPRN_PERIODS)
SELECT *
  FROM (SELECT /*+ ordered */
         TH.BOOK_TYPE_CODE LIVRO,
         TAB_PERIODS_1.PERIOD_NAME PERIODO1,
         TAB_PERIODS_2.PERIOD_NAME PERIODO2,
         DHCC.SEGMENT1  COMP_CODE,
         FALU.MEANING ASSET_TYPE,
         DECODE(AH.ASSET_TYPE, 'CIP', CB.CIP_COST_ACCT, CB.ASSET_COST_ACCT) ACCOUNT,
         DHCC.SEGMENT2 MINOR,
         DHCC.SEGMENT5 COST_CENTER,
         DHCC.segment6 PL,
         AD.ASSET_NUMBER,
         RET.DATE_RETIRED,
         AD.ASSET_NUMBER ASSET_NUM,
         AD.DESCRIPTION ASSET_NUM_DESC,
         TH.TRANSACTION_TYPE_CODE,
         TH.ASSET_ID,
         BOOKS.DATE_PLACED_IN_SERVICE,
         SUM(DECODE(AJ.ADJUSTMENT_TYPE, 'COST', 1, 'CIP COST', 1, 0) *
             DECODE(AJ.DEBIT_CREDIT_FLAG, 'DR', -1, 'CR', 1, 0) *
             AJ.ADJUSTMENT_AMOUNT) COST,         
         (select sum(deprn_reserve)
            from apps.fa_deprn_detail dd
           where dd.asset_id = TH.ASSET_ID
             and dd.book_type_code = TH.BOOK_TYPE_CODE--some('BRPPG FISCAL')
             and TH.TRANSACTION_TYPE_CODE = 'FULL RETIREMENT'
             and deprn_source_code = 'D'
             and dd.period_counter = (select max(period_counter)
                                      from apps.fa_deprn_detail
                                      where book_type_code = dd.book_type_code
                                        and asset_id = dd.asset_id
                                        and deprn_reserve > 0)) DEPRN_RESERVE,     
         SUM(DECODE(AJ.ADJUSTMENT_TYPE, 'NBV RETIRED', -1, 0) *
             DECODE(AJ.DEBIT_CREDIT_FLAG, 'DR', -1, 'CR', 1, 0) *
             AJ.ADJUSTMENT_AMOUNT) NBV,
         SUM(DECODE(AJ.ADJUSTMENT_TYPE, 'PROCEEDS CLR', 1, 'PROCEEDS', 1, 0) *
             DECODE(AJ.DEBIT_CREDIT_FLAG, 'DR', 1, 'CR', -1, 0) *
             AJ.ADJUSTMENT_AMOUNT) PROCEEDS,
         SUM(DECODE(AJ.ADJUSTMENT_TYPE, 'REMOVALCOST', -1, 0) *
             DECODE(AJ.DEBIT_CREDIT_FLAG, 'DR', -1, 'CR', 1, 0) *
             AJ.ADJUSTMENT_AMOUNT) REMOVAL,
         SUM(DECODE(AJ.ADJUSTMENT_TYPE, 'REVAL RSV RET', 1, 0) *
             DECODE(AJ.DEBIT_CREDIT_FLAG, 'DR', -1, 'CR', 1, 0) *
             AJ.ADJUSTMENT_AMOUNT) REVAL_RSV_RET,
         TH.TRANSACTION_HEADER_ID,
         DECODE(TH.TRANSACTION_TYPE_CODE,
                'REINSTATEMENT',
                '*',
                'PARTIAL RETIREMENT',
                'P',
                TO_CHAR(NULL)) CODE
          FROM apps.FA_TRANSACTION_HEADERS  TH,
               apps.FA_ADDITIONS            AD,
               apps.FA_BOOKS            BOOKS,
               apps.FA_RETIREMENTS      RET,
               apps.FA_ADJUSTMENTS      AJ,
               apps.FA_DISTRIBUTION_HISTORY DH,
               apps.GL_CODE_COMBINATIONS    DHCC,
               apps.FA_ASSET_HISTORY        AH,
               apps.FA_CATEGORY_BOOKS       CB,
               apps.FA_LOOKUPS              FALU,
               TAB_PERIODS             TAB_PERIODS_1,
               TAB_PERIODS             TAB_PERIODS_2
         WHERE 1=1
           AND TAB_PERIODS_1.BOOK = TH.BOOK_TYPE_CODE
           AND TAB_PERIODS_2.BOOK = TH.BOOK_TYPE_CODE  
           AND TH.DATE_EFFECTIVE >= TAB_PERIODS_1.PERIOD_POD
           AND TH.DATE_EFFECTIVE <= TAB_PERIODS_2.PERIOD_PCD
           AND TH.TRANSACTION_KEY = 'R'
           AND RET.ASSET_ID = BOOKS.ASSET_ID
           AND DECODE(TH.TRANSACTION_TYPE_CODE,
                      'REINSTATEMENT',
                      RET.TRANSACTION_HEADER_ID_OUT,
                      RET.TRANSACTION_HEADER_ID_IN) =
               TH.TRANSACTION_HEADER_ID
           AND AD.ASSET_ID = TH.ASSET_ID
           AND AJ.ASSET_ID = RET.ASSET_ID
           AND AJ.BOOK_TYPE_CODE = TH.BOOK_TYPE_CODE
           AND AJ.ADJUSTMENT_TYPE NOT IN
               (SELECT 'PROCEEDS'
                  FROM apps.FA_ADJUSTMENTS AJ1
                 WHERE AJ1.BOOK_TYPE_CODE = AJ.BOOK_TYPE_CODE
                   AND AJ1.ASSET_ID = AJ.ASSET_ID
                   AND AJ1.TRANSACTION_HEADER_ID = AJ.TRANSACTION_HEADER_ID
                   AND AJ1.ADJUSTMENT_TYPE = 'PROCEEDS CLR')
           AND AJ.TRANSACTION_HEADER_ID = TH.TRANSACTION_HEADER_ID
           AND AH.ASSET_ID = AD.ASSET_ID
           AND AH.DATE_EFFECTIVE <= TH.DATE_EFFECTIVE
           AND NVL(AH.DATE_INEFFECTIVE, TH.DATE_EFFECTIVE + 1) >
               TH.DATE_EFFECTIVE
           AND FALU.LOOKUP_CODE = AH.ASSET_TYPE
           AND FALU.LOOKUP_TYPE = 'ASSET TYPE'
           AND BOOKS.TRANSACTION_HEADER_ID_OUT = TH.TRANSACTION_HEADER_ID
           AND BOOKS.BOOK_TYPE_CODE = TH.BOOK_TYPE_CODE
           AND BOOKS.ASSET_ID = AD.ASSET_ID
           AND CB.CATEGORY_ID = AH.CATEGORY_ID
           AND CB.BOOK_TYPE_CODE =  TH.BOOK_TYPE_CODE
           AND DH.DISTRIBUTION_ID = AJ.DISTRIBUTION_ID
           AND TH.ASSET_ID = DH.ASSET_ID
           AND DHCC.CODE_COMBINATION_ID = DH.CODE_COMBINATION_ID
         GROUP BY TAB_PERIODS_1.PERIOD_NAME,
                  TAB_PERIODS_2.PERIOD_NAME,
                  TH.BOOK_TYPE_CODE,
                  FALU.MEANING,
                  DHCC.SEGMENT1,
                  DHCC.SEGMENT2,
                  DHCC.SEGMENT5,
                  DHCC.SEGMENT6,
                  TH.TRANSACTION_TYPE_CODE,
                  TH.ASSET_ID,
                  CB.ASSET_COST_ACCT,
                  CB.CIP_COST_ACCT,
                  AD.ASSET_NUMBER,
                  AD.DESCRIPTION,
                  BOOKS.DATE_PLACED_IN_SERVICE,
                  RET.DATE_RETIRED,
                  TH.TRANSACTION_HEADER_ID,
                  AH.ASSET_TYPE,
                  RET.GAIN_LOSS_AMOUNT
        UNION
        SELECT /*+ ordered */ --added query for bug10255794
         TH.BOOK_TYPE_CODE LIVRO,
         TAB_PERIODS_1.PERIOD_NAME PERIODO1,
         TAB_PERIODS_2.PERIOD_NAME PERIODO2,
         DHCC.SEGMENT1 COMP_CODE,
         FALU.MEANING ASSET_TYPE,
         DECODE(AH.ASSET_TYPE, 'CIP', CB.CIP_COST_ACCT, CB.ASSET_COST_ACCT) ACCOUNT,
         DHCC.SEGMENT2 MINOR,
         DHCC.SEGMENT5 COST_CENTER,
         DHCC.segment6 PL,
         AD.ASSET_NUMBER,
         RET.DATE_RETIRED,
         AD.ASSET_NUMBER ASSET_NUM,
         AD.DESCRIPTION ASSET_NUM_DESC,
         TH.TRANSACTION_TYPE_CODE,
         TH.ASSET_ID,
         BOOKS.DATE_PLACED_IN_SERVICE,
         0 COST,
         0 DEPRN_RESERVE,
         0 NBV,
         NVL(RET.PROCEEDS_OF_SALE, 0) PROCEEDS,
         NVL(RET.COST_OF_REMOVAL, 0) REMOVAL,
         0 REVAL_RSV_RET,
         TH.TRANSACTION_HEADER_ID,
         DECODE(RET.STATUS, 'DELETED', '*', TO_CHAR(NULL)) CODE
          FROM apps.FA_TRANSACTION_HEADERS TH,
               apps.FA_ADDITIONS AD,
               apps.FA_BOOKS BOOKS,
               apps.FA_RETIREMENTS RET,
               (SELECT DH.*,
                       TH1.BOOK_TYPE_CODE LIVRO
                  FROM apps.FA_TRANSACTION_HEADERS  TH1,
                       apps.FA_DISTRIBUTION_HISTORY DH,
                       apps.FA_BOOK_CONTROLS        BC,
                       apps.FA_TRANSACTION_HEADERS  TH2,
                       TAB_PERIODS             TAB_PERIODS_1,
                       TAB_PERIODS             TAB_PERIODS_2
                 WHERE 1=1
                   AND TAB_PERIODS_1.BOOK = TH1.BOOK_TYPE_CODE
                   AND TAB_PERIODS_2.BOOK = TH1.BOOK_TYPE_CODE
                   AND TH1.TRANSACTION_TYPE_CODE = 'FULL RETIREMENT'
                   AND TH1.DATE_EFFECTIVE BETWEEN TAB_PERIODS_1.PERIOD_POD AND TAB_PERIODS_2.PERIOD_PCD
                   AND TH1.ASSET_ID = DH.ASSET_ID
                   AND BC.BOOK_TYPE_CODE = TH1.BOOK_TYPE_CODE
                   AND BC.DISTRIBUTION_SOURCE_BOOK = DH.BOOK_TYPE_CODE
                   AND TH1.DATE_EFFECTIVE <=
                       NVL(DH.DATE_INEFFECTIVE, TH1.DATE_EFFECTIVE)
                   AND TH1.ASSET_ID = TH2.ASSET_ID
                   AND TH2.BOOK_TYPE_CODE = TH1.BOOK_TYPE_CODE
                   AND TH2.TRANSACTION_TYPE_CODE = 'REINSTATEMENT'
                   AND TH2.DATE_EFFECTIVE BETWEEN TAB_PERIODS_1.PERIOD_POD AND TAB_PERIODS_2.PERIOD_PCD
                   AND TH2.DATE_EFFECTIVE >= DH.DATE_EFFECTIVE) DH,
               apps.GL_CODE_COMBINATIONS DHCC,
               apps.FA_ASSET_HISTORY AH,
               apps.FA_CATEGORY_BOOKS CB,
               apps.FA_LOOKUPS FALU,
               TAB_PERIODS             TAB_PERIODS_1,
               TAB_PERIODS             TAB_PERIODS_2
         WHERE 1=1
           AND TAB_PERIODS_1.BOOK = TH.BOOK_TYPE_CODE
           AND TAB_PERIODS_2.BOOK = TH.BOOK_TYPE_CODE
           AND TH.DATE_EFFECTIVE >= TAB_PERIODS_1.PERIOD_POD
           AND TH.DATE_EFFECTIVE <= TAB_PERIODS_2.PERIOD_PCD
           AND TH.BOOK_TYPE_CODE = DH.LIVRO
           AND TH.TRANSACTION_KEY = 'R'
           AND RET.BOOK_TYPE_CODE = TH.BOOK_TYPE_CODE
           AND RET.ASSET_ID = BOOKS.ASSET_ID
           AND RET.TRANSACTION_HEADER_ID_OUT = TH.TRANSACTION_HEADER_ID
           AND AD.ASSET_ID = TH.ASSET_ID
           AND AH.ASSET_ID = AD.ASSET_ID
           AND AH.DATE_EFFECTIVE <= TH.DATE_EFFECTIVE
           AND NVL(AH.DATE_INEFFECTIVE, TH.DATE_EFFECTIVE + 1) >
               TH.DATE_EFFECTIVE
           AND FALU.LOOKUP_CODE = AH.ASSET_TYPE
           AND FALU.LOOKUP_TYPE = 'ASSET TYPE'
           AND BOOKS.TRANSACTION_HEADER_ID_OUT = TH.TRANSACTION_HEADER_ID
           AND BOOKS.BOOK_TYPE_CODE = TH.BOOK_TYPE_CODE
           AND BOOKS.ASSET_ID = AD.ASSET_ID
           AND CB.CATEGORY_ID = AH.CATEGORY_ID
           AND CB.BOOK_TYPE_CODE = TH.BOOK_TYPE_CODE
           AND TH.ASSET_ID = DH.ASSET_ID
           AND DHCC.CODE_COMBINATION_ID = DH.CODE_COMBINATION_ID
           AND TH.TRANSACTION_TYPE_CODE = 'REINSTATEMENT'
           AND RET.COST_RETIRED = 0
           AND RET.COST_OF_REMOVAL = 0
           AND RET.PROCEEDS_OF_SALE = 0
         GROUP BY TAB_PERIODS_1.PERIOD_NAME,
                  TAB_PERIODS_2.PERIOD_NAME, 
                  TH.BOOK_TYPE_CODE,
                  FALU.MEANING,
                  DHCC.SEGMENT1,
                  DHCC.SEGMENT2,
                  DHCC.SEGMENT5,
                  DHCC.SEGMENT6,
                  TH.TRANSACTION_TYPE_CODE,
                  TH.ASSET_ID,
                  CB.ASSET_COST_ACCT,
                  CB.CIP_COST_ACCT,
                  AD.ASSET_NUMBER,
                  AD.DESCRIPTION,
                  BOOKS.DATE_PLACED_IN_SERVICE,
                  RET.DATE_RETIRED,
                  TH.TRANSACTION_HEADER_ID,
                  AH.ASSET_TYPE,
                  RET.GAIN_LOSS_AMOUNT,
                  RET.STATUS,
                  RET.PROCEEDS_OF_SALE,
                  RET.COST_OF_REMOVAL
        )
 ORDER BY 1, 2, 3, 4, 5, 6