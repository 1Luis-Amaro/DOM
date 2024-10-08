SELECT   FALRI.BOOK_TYPE_CODE
        ,FALRI.SET_OF_BOOKS_ID
        ,FALRI.PERIOD_NAME
        ,FALRI.COMPANY_DESCRIPTION
        ,FALRI.ORGANIZATION_NAME
        ,FALRI.COMPANY
        ,FALRI.ASSET_NUMBER
        ,FALRI.TAG_NUMBER
        ,FALRI.DESCRIPTION
        ,FALRI.SERIAL_NUMBER
        ,FALRI.ASSET_COST_ACCT
        ,FALRI.ACCOUNT_DESCRIPTION
        ,FALRI.DEPRN_EXPENSE_ACCT
        ,FALRI.EXPENSE_ACCT_DESCRIPTION
        ,FALRI.ACCUM_DEPRN_ACCT
        ,FALRI.CATEGORY
        ,FALRI.MAJOR_CATEGORY
        ,FALRI.MINOR_CATEGORY
        ,GCC.CONCATENATED_SEGMENTS
        ,FALRI.LOCATION	
        ,FALRI.DATE_PLACED_IN_SERVICE
        ,FALRI.UNITS
        ,FDH.UNITS_ASSIGNED
        ,FALRI.COST
        ,FALRI.DEPRN_AMOUNT
        ,FALRI.LTD_DEPRN
        ,FALRI.NBV
        ,FALRI.DEPRN_METHOD
        ,FALRI.LIFE_YR_MO
        ,FALRI.BOOK_DEPRN_FLAG
        ,FALRI.CATEGORY_DEPRN_FLAG
        ,FALRI.ASSET_KEY
        ,FALRI.CREATION_DATE
  FROM APPS.FA_ASSET_LISTING_REP_ITF FALRI,
       APPS.FA_DISTRIBUTION_HISTORY FDH,
       APPS.GL_CODE_COMBINATIONS_KFV GCC
 WHERE TO_CHAR (FALRI.ASSET_NUMBER) = TO_CHAR (FDH.ASSET_ID)
   AND FALRI.UNITS = FDH.UNITS_ASSIGNED
   AND FDH.CODE_COMBINATION_ID = GCC.CODE_COMBINATION_ID
   --AND FALRI.PERIOD_NAME = '06-17'
   ORDER BY FALRI.ASSET_NUMBER, FALRI.BOOK_TYPE_CODE, FALRI.CREATION_DATE;