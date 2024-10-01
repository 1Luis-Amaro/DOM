SELECT FU.USER_NAME,
       FU.DESCRIPTION,
       FPO.profile_option_name,
       FPOV.PROFILE_OPTION_VALUE
  FROM APPS.FND_PROFILE_OPTIONS FPO,
       APPS.FND_PROFILE_OPTION_VALUES FPOV,
       APPS.FND_USER FU
 WHERE FPO.profile_option_id = FPOV.profile_option_id 
   AND FU.USER_ID = FPOV.LEVEL_VALUE
  --AND FU.USER_NAME IN ('CAC7448','CAC9285')
   AND FU.USER_NAME IN ('E230648')
 ORDER BY LEVEL_VALUE

SELECT FPO.profile_option_name, FPOV.PROFILE_OPTION_VALUE, FPOV.*
FROM APPS.FND_PROFILE_OPTIONS FPO
,    APPS.FND_PROFILE_OPTION_VALUES FPOV
WHERE FPO.profile_option_id = FPOV.profile_option_id 
  AND FPO.profile_option_name LIKE '%FRETE%' 
ORDER BY FPO.profile_option_name, LEVEL_VALUE

SELECT * FROM APPS.WF_USERS
WHERE orig_system = 'PER'
   and name IN ('OCS0066','CAC7996','CAR7546')
--  AND notification_preference != 'MAILHTML' 
--Bagatini, seguem as informacoes para vc verificar p mim - Fabio Miguel - cac7996 (DIR) Renato pereira - CAR7546 (Controller)

