                SELECT trunc(CONVERSION_RATE,4)
                   FROM APPS.GL_DAILY_RATES
                  WHERE TO_CURRENCY = 'BRL'
                    AND CONVERSION_TYPE = ( SELECT CONVERSION_TYPE
                                              FROM APPS.GL_DAILY_CONVERSION_TYPES
                                             WHERE USER_CONVERSION_TYPE = 'BCB Venda')
                    AND FROM_CURRENCY = 'USD'
                    AND CONVERSION_DATE = ( SELECT MAX(CONVERSION_DATE)
                                              FROM APPS.GL_DAILY_RATES
                                             WHERE TO_CURRENCY = 'BRL'
                                               AND CONVERSION_TYPE = ( SELECT CONVERSION_TYPE
                                                                         FROM APPS.GL_DAILY_CONVERSION_TYPES
                                                                        WHERE USER_CONVERSION_TYPE = 'BCB Venda'
                                                                     )
                                               AND FROM_CURRENCY = 'USD'
                                               AND TO_CHAR(CONVERSION_DATE,'YYYYMMDD') <= TO_CHAR(SYSDATE,'YYYYMMDD'));
                                               
                                               
SELECT  * --USER_CONVERSION_TYPE --CONVERSION_TYPE
 FROM apps.GL_DAILY_CONVERSION_TYPES;
WHERE USER_CONVERSION_TYPE = 'BCB Compra'


SELECT  TO_CURRENCY --MAX(CONVERSION_DATE)
  FROM apps.GL_DAILY_RATES;
 WHERE TO_CURRENCY = 'BRL'
                                                                     )
                                                                     
                                                                     
select 'Y'
  from apps.po_requisition_Headers_all prh,
       apps.per_all_people_f           pap,
       apps.per_all_assignments_f      paa
 where pap.person_id = prh.preparer_id
   and pap.person_id = paa.person_id
   and sysdate between paa.effective_start_date and paa.effective_end_date
   and sysdate between pap.effective_start_date and pap.effective_end_date
   and nvl(paa.ass_attribute26,'N') = 'N'
   and 300 * (SELECT trunc(CONVERSION_RATE,4)
                   FROM APPS.GL_DAILY_RATES
                  WHERE TO_CURRENCY = 'BRL'
                    AND CONVERSION_TYPE = ( SELECT CONVERSION_TYPE
                                              FROM APPS.GL_DAILY_CONVERSION_TYPES
                                             WHERE USER_CONVERSION_TYPE = 'BCB Venda')
                    AND FROM_CURRENCY = 'USD'
                    AND CONVERSION_DATE = ( SELECT MAX(CONVERSION_DATE)
                                              FROM APPS.GL_DAILY_RATES
                                             WHERE TO_CURRENCY = 'BRL'
                                               AND CONVERSION_TYPE = ( SELECT CONVERSION_TYPE
                                                                         FROM APPS.GL_DAILY_CONVERSION_TYPES
                                                                        WHERE USER_CONVERSION_TYPE = 'BCB Venda'
                                                                     )
                                               AND FROM_CURRENCY = 'USD'
                                               AND TO_CHAR(CONVERSION_DATE,'YYYYMMDD') = TO_CHAR(SYSDATE,'YYYYMMDD'))) < 
               (SELECT SUM((X.QUANTITY - NVL(X.QUANTITY_CANCELLED, 0)) * X.UNIT_PRICE)
          FROM APPS.PO_REQUISITION_LINES_ALL X
         WHERE X.REQUISITION_HEADER_ID = PRH.REQUISITION_HEADER_ID)
and prh.requisition_header_id = 814169
                                                                                                                    