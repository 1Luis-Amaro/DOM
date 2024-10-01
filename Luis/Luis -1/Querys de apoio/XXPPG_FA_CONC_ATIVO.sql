SELECT DADOS.ACCOUNT_CODE||' - '||DESC_CONTA.DESCRIPTION "Conta Patrimonial"
      ,FB.ASSET_ID||' - '||FT.DESCRIPTION "Bem Patrimonial"
      ,DADOS.CC CC
      ,DADOS.PL PL
      ,ESTAB.SEGMENT3 ESTABELECIMENTO      
      --descricao do item
      ,fa.tag_number TAG
      ,FB.DATE_PLACED_IN_SERVICE DATA_AQUISICAO
      ,FB.prorate_date "Data Inicio"
      ,sum(fb.original_cost) "Valor Custo"
      ,SUM(DECODE(DADOS.CATEGORY, 'Depreciation', DADOS.SLA_AMOUNT, 0)) "VALOR DEPRECIADO"
      ,sum(fb.original_cost) - SUM(DECODE(DADOS.CATEGORY, 'Depreciation', DADOS.SLA_AMOUNT, 0)) "Valor Liquido"      
  FROM APPS.FA_BOOKS           FB,
       APPS.FA_ADDITIONS_B     FA,
       APPS.FA_ADDITIONS_TL    FT,
       (select ffvt.description,ffv.FLEX_VALUE   
         from fnd_flex_values ffv ,fnd_flex_values_tl ffvt
        where ffv.flex_value_id = ffvt.flex_value_id          
          AND ffvt.LANGUAGE = 'PTB'
          --and ffv.flex_value = DADOS.ACCOUNT_CODE
          /*AND ROWNUM = 1*/) DESC_CONTA,
          (SELECT F.ASSET_ID,
               B.JE_CATEGORY_NAME CATEGORY,
               TO_CHAR(B.ACCOUNTING_DATE, 'YYYY-MM') PERIOD,
               A.ACCOUNTING_CLASS_CODE CLASS,
               C.SEGMENT4 ACCOUNT_CODE,
               C.SEGMENT5 CC,
               C.SEGMENT6 PL,
               --ACCA.DESCRIPTION ACC_DESCRIPTION,
               SUM(NVL(A.ENTERED_DR, 0) - NVL(A.ENTERED_CR, 0)) SLA_AMOUNT
          FROM XLA.XLA_AE_LINES A,
               XLA.XLA_AE_HEADERS B,
               APPS.GL_CODE_COMBINATIONS C,
               XLA.XLA_EVENTS D,
               XLA.XLA_TRANSACTION_ENTITIES E,
               APPS.FA_TRANSACTION_HEADERS F
         WHERE A.AE_HEADER_ID        = B.AE_HEADER_ID
           AND A.CODE_COMBINATION_ID = C.CODE_COMBINATION_ID
           AND B.EVENT_ID = D.EVENT_ID
           --AND C.SEGMENT3 = ACCA.FLEX_VALUE
           AND D.ENTITY_ID = E.ENTITY_ID(+)
           AND E.SOURCE_ID_INT_1 = F.TRANSACTION_HEADER_ID(+)           
           AND B.ACCOUNTING_DATE IS NOT NULL
           AND B.JE_CATEGORY_NAME <> 'Depreciation'
         GROUP BY F.ASSET_ID,
                  B.JE_CATEGORY_NAME,
                  C.SEGMENT4,
                  C.SEGMENT5,
                  C.SEGMENT6,
                  A.ACCOUNTING_CLASS_CODE,
                  --ACCA.DESCRIPTION,
                  TO_CHAR(B.ACCOUNTING_DATE, 'YYYY-MM')        
        UNION ALL        
        SELECT F.ASSET_ID,
               B.JE_CATEGORY_NAME CATEGORY,
               TO_CHAR(B.ACCOUNTING_DATE, 'YYYY-MM') PERIOD,
               A.ACCOUNTING_CLASS_CODE CLASS,
               C.SEGMENT4 ACCOUNT_CODE,
               C.SEGMENT5 CC,
               C.SEGMENT6 PL,
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
         GROUP BY F.ASSET_ID,
                  B.JE_CATEGORY_NAME,
                  C.SEGMENT4,
                  C.SEGMENT5,
                  C.SEGMENT6,
                  A.ACCOUNTING_CLASS_CODE,
                  --ACCA.DESCRIPTION,
                  TO_CHAR(B.ACCOUNTING_DATE, 'YYYY-MM')        
        ) DADOS        
        ,(select DISTINCT FL.SEGMENT3, FDH.ASSET_ID
        from fa_locations FL
          ,FA_DISTRIBUTION_HISTORY FDH
        WHERE FDH.LOCATION_ID = FL.LOCATION_ID        
        /*AND ROWNUM = 1*/) ESTAB                                                       
 WHERE FB.ASSET_ID = FA.ASSET_ID
   AND FB.ASSET_ID = FT.ASSET_ID
   AND FB.ASSET_ID = DADOS.ASSET_ID 
   AND FB.DATE_INEFFECTIVE IS NULL   
   AND DESC_CONTA.FLEX_VALUE (+) = DADOS.ACCOUNT_CODE
   AND FB.ASSET_ID = ESTAB.ASSET_ID   
 GROUP BY DADOS.ACCOUNT_CODE||' - '||DESC_CONTA.DESCRIPTION
          ,FB.ASSET_ID||' - '||FT.DESCRIPTION
          ,DADOS.CC
          ,DADOS.PL
          ,ESTAB.SEGMENT3
          --descricao do item
          ,fa.tag_number
          ,FB.DATE_PLACED_IN_SERVICE
          ,FB.prorate_date          
