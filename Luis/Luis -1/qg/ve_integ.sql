SELECT NOTIFICATION_ID,
       ISV_NAME,
       EVENT_KEY,
       EVENT_NAME,
       TRANSACTION_TYPE,
       CREATION_DATE,
       CREATED_BY,
       LAST_UPDATE_DATE,
       LAST_UPDATED_BY,
       LAST_UPDATE_LOGIN,
       REQUEST_ID,
       PROGRAM_APPLICATION_ID,
       PROGRAM_ID,
       PROGRAM_UPDATE_DATE,
       EXPORT_STATUS,
       PARAMETER_NAME1,
       PARAMETER_VALUE1,
       PARAMETER_NAME2,
       PARAMETER_VALUE2,
       PARAMETER_NAME3,
       PARAMETER_VALUE3,
       PARAMETER_NAME4,
       PARAMETER_VALUE4,
       PARAMETER_NAME5,
       PARAMETER_VALUE5,
       PARAMETER_NAME6,
       PARAMETER_VALUE6,
       PARAMETER_NAME7,
       PARAMETER_VALUE7,
       PARAMETER_NAME8,
       PARAMETER_VALUE8,
       PARAMETER_NAME9,
       PARAMETER_VALUE9,
       PARAMETER_NAME10,
       PARAMETER_VALUE10,
       RETURN_CODE,
       RETURN_MESSAGE
  FROM CLL_F255_NOTIFICATIONS T WHERE EVENT_NAME = 'oracle.apps.cll.ap_suppliers' AND LAST_UPDATE_DATE > SYSDATE - 151
