SELECT DISTINCT
         HCA.ACCOUNT_NUMBER                      "COD CLIENTE", 
         HP.PARTY_NAME                           "NOME DO CLIENTE", 
         hca.status STATUS,
         HP.ATTRIBUTE2                           "GRUPO  DO CLIENTE", 
         HCA.SALES_CHANNEL_CODE                 "DETAIL SBU", 
        -- Hca.Cust_Account_Id,                 
(SELECT  objectparty.party_name --||' - '||REPLACE (reltype.ROLE,'PARENTOFSUB','Subsidiaria'
    FROM apps.hz_relationships      HzPuiRelationshipsEO, 
         apps.hz_relationship_types reltype,
         apps.hz_parties            relparty,
         apps.hz_parties            subjectparty,
         apps.hz_parties            objectparty,
         apps.HZ_CUST_ACCOUNTS      HCA2,                            -- novo
         apps.fnd_lookup_values     subjectpartytypelu,
         apps.fnd_lookup_values     objectpartytypelu,
         apps.fnd_lookup_values     relationshiprolelu
 WHERE HzPuiRelationshipsEO.subject_table_name = 'HZ_PARTIES'
       AND HzPuiRelationshipsEO.object_table_name = 'HZ_PARTIES'
       AND HzPuiRelationshipsEO.party_id = relparty.party_id
       AND hca2.party_id = objectparty.party_id                      -- novo
       and hca2.status = 'A'                                         -- novo
       AND HzPuiRelationshipsEO.status = 'A'                         -- novo
--       AND HzPuiRelationshipsEO.status IN ('A', 'I')
       AND HzPuiRelationshipsEO.subject_id = subjectparty.party_id
       AND HzPuiRelationshipsEO.object_id = objectparty.party_id
       AND HzPuiRelationshipsEO.relationship_type = reltype.relationship_type
       AND HzPuiRelationshipsEO.relationship_code = reltype.forward_rel_code
       AND HzPuiRelationshipsEO.subject_type = reltype.subject_type
       AND HzPuiRelationshipsEO.object_type = reltype.object_type
       AND subjectpartytypelu.view_application_id = 222
       AND subjectpartytypelu.lookup_type = 'PARTY_TYPE'
       AND subjectpartytypelu.language = USERENV ('LANG')
       AND subjectpartytypelu.lookup_code = HzPuiRelationshipsEO.subject_type
       AND objectpartytypelu.view_application_id = 222
       AND objectpartytypelu.lookup_type = 'PARTY_TYPE'
       AND objectpartytypelu.language = USERENV ('LANG')
       AND objectpartytypelu.lookup_code = HzPuiRelationshipsEO.object_type
       AND relationshiprolelu.view_application_id = 222
       AND relationshiprolelu.lookup_type = 'HZ_RELATIONSHIP_ROLE'
       --AND relationshiprolelu.language = userenv('LANG')
       AND relationshiprolelu.lookup_code = reltype.role
       AND subjectparty.party_name = HP.PARTY_NAME--'UNITINTAS COM DE TINTAS LTDA'
       AND subjectparty.PARTY_ID = HP.PARTY_ID
       AND objectparty.party_type = 'ORGANIZATION'
       AND ROWNUM = 1) COLIGADAS,  
         (nvl (hcsua.attribute6,'')) "DATA IMPLANTACAO CLIENTE",   --substr(hcsua.attribute6,1,10)     
         TO_CHAR (HCA.CREATION_DATE, 'DD/MM/RRRR')"DATA IMPLANTACAO SISTEMA",
        (SELECT A.LAST_CREDIT_REVIEW_DATE
          FROM APPS.HZ_CUSTOMER_PROFILES A,
               APPS.HZ_CUST_PROFILE_AMTS B
         WHERE     A.CUST_ACCOUNT_PROFILE_ID = B.CUST_ACCOUNT_PROFILE_ID
               AND HP.PARTY_ID = A.PARTY_ID
               and A.cust_account_id = -1  -- CONTA
               and A.site_use_id is null -- Para pegar somente da conta
               AND B.overall_credit_limit IS NOT NULL
        )"DT ULTIMA VERIF. PROG." ,--                  
         (SELECT A.NEXT_CREDIT_REVIEW_DATE
          FROM APPS.HZ_CUSTOMER_PROFILES A,
               APPS.HZ_CUST_PROFILE_AMTS B
         WHERE     A.CUST_ACCOUNT_PROFILE_ID = B.CUST_ACCOUNT_PROFILE_ID
               AND HP.PARTY_ID = A.PARTY_ID
               and A.cust_account_id = -1  -- CONTA
               and A.site_use_id is null -- Para pegar somente da conta
               AND B.overall_credit_limit IS NOT NULL
               ) "DT PROX VERIF. PROGRAMADA",
               (SELECT B.overall_credit_limit
          FROM APPS.HZ_CUSTOMER_PROFILES A,
               APPS.HZ_CUST_PROFILE_AMTS B,
               APPS.HZ_PARTIES HP2
         WHERE     A.CUST_ACCOUNT_PROFILE_ID = B.CUST_ACCOUNT_PROFILE_ID
               AND HP2.PARTY_ID = A.PARTY_ID
               and A.cust_account_id = -1  -- CONTA
               AND B.overall_credit_limit IS NOT NULL
               and A.site_use_id is null -- Para pegar somente da conta
               AND HP.PARTY_NAME = hp2.party_name) "VALOR LIMITE CREDITO ATUAL",
         (SELECT hprof.CREDIT_CLASSIFICATION
          FROM apps.hz_customer_profiles hprof, apps.ar_collectors acol
         WHERE     hprof.PARTY_ID = HP.PARTY_ID
               AND hprof.collector_id = acol.collector_id
               and hprof.cust_account_id = -1  -- CONTA
              -- and hprof.site_use_id is null -- Para pegar somente da conta
               AND ROWNUM = 1) "CLASSIFICACAO CREDITO",  
         HCA.CUSTOMER_CLASS_CODE   CLASSIFICACAO,                                                 
        (SELECT MIN (CREATION_DATE)
               FROM apps.Ar_Payment_Schedules_All
              WHERE Customer_Id =  Hca.Cust_Account_Id
              and class = 'INV') "DATA PRIMEIRA COMPRA",            
   (select sum (Amount_due_Original) FROM apps.Ar_Payment_Schedules_All
                                where customer_trx_id in (
                                SELECT DISTINCT MIN (customer_trx_id) FROM Apps.Ar_Payment_Schedules_All Apsa 
                                WHERE Apsa.Customer_Id =   Hca.Cust_Account_Id
                                AND CREATION_DATE = (SELECT MIN (CREATION_DATE)
                                                   FROM apps.Ar_Payment_Schedules_All
                                                  WHERE Customer_Id =   Hca.Cust_Account_Id
                                                  and class = 'INV')
                               AND  apsa.class = 'INV')
                               )         "VALOR PRIMEIRA COMPRA",                              
 (SELECT MAX (CREATION_DATE)
               FROM apps.Ar_Payment_Schedules_All
              WHERE Customer_Id =  Hca.Cust_Account_Id
              and class = 'INV') "DATA ULTIMA COMPRA", 
   (select sum (Amount_due_Original) FROM apps.Ar_Payment_Schedules_All
                                where customer_trx_id in (
                                SELECT DISTINCT MAX (customer_trx_id) FROM Apps.Ar_Payment_Schedules_All Apsa 
                                WHERE Apsa.Customer_Id =   Hca.Cust_Account_Id
                                AND CREATION_DATE = (SELECT MAX (CREATION_DATE)
                                                   FROM apps.Ar_Payment_Schedules_All
                                                  WHERE Customer_Id =   Hca.Cust_Account_Id
                                                  and class = 'INV')
                               AND  apsa.class = 'INV')
                               )         "VALOR ULTIMA COMPRA",                                
   (SELECT SUM (Amount_due_REMAINING) FROM apps.Ar_Payment_Schedules_All WHERE Customer_Id =   Hca.Cust_Account_Id and class = 'CM'
                               AND STATUS = 'OP') "AVISO DE CRÉDITO",
   (SELECT SUM (Amount_due_REMAINING) FROM apps.Ar_Payment_Schedules_All WHERE Customer_Id =   Hca.Cust_Account_Id and class = 'DM'
                               AND STATUS = 'OP') "AVISO DE DÉBITO", 
   (SELECT SUM (Amount_due_REMAINING) FROM apps.Ar_Payment_Schedules_All WHERE Customer_Id =   Hca.Cust_Account_Id and class = 'INV'
                               AND STATUS = 'OP') "NFS TOTAL" ,   
   (SELECT SUM (Amount_due_REMAINING) FROM apps.Ar_Payment_Schedules_All WHERE Customer_Id =   Hca.Cust_Account_Id and class = 'PMT'
                               AND STATUS = 'OP') RECEBIMENTO,                                  
   (SELECT SUM (Amount_due_REMAINING) FROM apps.Ar_Payment_Schedules_All WHERE Customer_Id =   Hca.Cust_Account_Id and class = 'INV'
                               AND STATUS = 'OP' and trunc (due_date) >= trunc (sysdate)) "NFS A VENCER", 
   (SELECT SUM (Amount_due_REMAINING) FROM apps.Ar_Payment_Schedules_All WHERE Customer_Id =   Hca.Cust_Account_Id and class = 'INV'
                               AND STATUS = 'OP' and TRUNC (due_date) < TRUNC (sysdate)) "NFS VENCIDAS", --REGEXP_REPLACE
    CASE WHEN to_date(xaclus.load_date)  IS NULL OR  to_date(xaclus.load_date) < to_date((select ACCR.DATE_OPENED
     from apps.ar_cmgt_case_folders accf,apps.ar_cmgt_cf_anl_notes ACCR 
    where  accf.party_id = HP.PARTY_ID 
      AND ACCR.CASE_FOLDER_ID = accf.CASE_FOLDER_ID 
      AND accf.LAST_UPDATE_DATE IN (select MAX (accf.LAST_UPDATE_DATE)
                                from apps.ar_cmgt_case_folders accf
                               where  accf.party_id = HP.PARTY_ID 
                                and accf.review_type = 'NEW_CREDIT_LIMIT')
     and accf.review_type = 'NEW_CREDIT_LIMIT'
     AND ROWNUM = 1)) THEN
       (select ACCR.DATE_OPENED
     from apps.ar_cmgt_case_folders accf,apps.ar_cmgt_cf_anl_notes ACCR 
    where  accf.party_id = HP.PARTY_ID 
      AND ACCR.CASE_FOLDER_ID = accf.CASE_FOLDER_ID 
      AND accf.LAST_UPDATE_DATE IN (select MAX (accf.LAST_UPDATE_DATE)
                                from apps.ar_cmgt_case_folders accf
                               where  accf.party_id = HP.PARTY_ID 
                                and accf.review_type = 'NEW_CREDIT_LIMIT')
     and accf.review_type = 'NEW_CREDIT_LIMIT'
     AND ROWNUM = 1)
     ELSE
       to_date(xaclus.load_date)
     END "DATA ULTIMA OBS",                               
 CASE WHEN to_date(xaclus.load_date)  IS NULL OR  to_date(xaclus.load_date) < to_date((select ACCR.DATE_OPENED
     from apps.ar_cmgt_case_folders accf,apps.ar_cmgt_cf_anl_notes ACCR 
    where  accf.party_id = HP.PARTY_ID 
      AND ACCR.CASE_FOLDER_ID = accf.CASE_FOLDER_ID 
      AND accf.LAST_UPDATE_DATE IN (select MAX (accf.LAST_UPDATE_DATE)
                                from apps.ar_cmgt_case_folders accf
                               where  accf.party_id = HP.PARTY_ID 
                                and accf.review_type = 'NEW_CREDIT_LIMIT')
     and accf.review_type = 'NEW_CREDIT_LIMIT'
     AND ROWNUM = 1)) THEN
       (select REPLACE (ACCR.NOTES,chr(10), ' ')
     from apps.ar_cmgt_case_folders accf,apps.ar_cmgt_cf_anl_notes ACCR 
    where hp.party_id = accf.party_id 
      AND ACCR.CASE_FOLDER_ID = accf.CASE_FOLDER_ID 
      AND accf.LAST_UPDATE_DATE IN (select MAX (accf.LAST_UPDATE_DATE)
                                from apps.ar_cmgt_case_folders accf
                               where hp.party_id = accf.party_id 
                                and accf.review_type = 'NEW_CREDIT_LIMIT')
     and accf.review_type = 'NEW_CREDIT_LIMIT'
     AND ROWNUM = 1)
     ELSE
       xaclus.attribute1
     END "OBS ULTIMA ANALISE DE CREDITO"
---------------------------------------------------------------                                                                                                                                                                                    
    FROM   
         apps.HZ_CUST_ACCT_SITES_ALL HCASA, 
         apps.HZ_CUST_ACCOUNTS      HCA, 
         apps.HZ_PARTIES            HP, 
         apps.HZ_CUST_SITE_USES_ALL HCSUA,
         (SELECT DISTINCT xocb.party_id,
                          xocb.sales_channel,
                          JRR.SOURCE_NAME,
                          JRR.SOURCE_MGR_NAME,
                          BILL_TO_SITE_USE_ID                 
            FROM APPS.XXPPG_OM_CROSS_BU_V XOCB,
                 apps.JTF_RS_SALESREPS    JRS,
                 apps.JTF_RS_RESOURCE_EXTNS JRR,
                 apps.HZ_CUST_SITE_USES_ALL HCSUA              
           WHERE     JRS.RESOURCE_ID = JRR.RESOURCE_ID
                 AND XOCB.SALESREP_ID = JRS.SALESREP_ID
                 AND JRR.CATEGORY = 'EMPLOYEE'
                 AND XOCB.SITE_USE_ID = HCSUA.SITE_USE_ID      
                 AND jrr.object_version_number =
                        (SELECT MAX (jrr.object_version_number)
                           FROM APPS.XXPPG_OM_CROSS_BU_V XOCB1,
                                apps.JTF_RS_SALESREPS    JRS1,
                                apps.JTF_RS_RESOURCE_EXTNS JRR1
                          WHERE     XOCB1.PARTY_ID = XOCB.PARTY_ID
                                AND XOCB1.SALESREP_ID = JRS1.SALESREP_ID
                                AND JRS1.RESOURCE_ID = JRR1.RESOURCE_ID
                                AND JRR1.CATEGORY = 'EMPLOYEE')) XOCB  
,(select max(load_date) load_date, max(attribute1) attribute1 , cust_account_number
from apps.XXPPG_AR_CUST_LIMIT_UPDATE_STG
group by cust_account_number) xaclus                                                                 
   WHERE HP.PARTY_ID = HCA.PARTY_ID
         AND HCASA.CUST_ACCT_SITE_ID = HCSUA.CUST_ACCT_SITE_ID(+)
         AND HCASA.CUST_ACCOUNT_ID = HCA.CUST_ACCOUNT_ID
         --AND HP.PARTY_NAME like '%ODEBRECHT OLEO E GAS SA%'
--         AND HP.PARTY_NAME like '%ARUMA PROD%'
       -- AND TRX_NUMBER = 38278
         AND XOCB.PARTY_ID(+) = HP.PARTY_ID                          
         AND hcsua.site_use_code = 'BILL_TO'
         AND HCA.ACCOUNT_NUMBER = xaclus.cust_account_number(+)
ORDER BY HP.PARTY_NAME
