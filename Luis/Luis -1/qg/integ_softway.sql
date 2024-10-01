select * from apps.cll_f255_notifications
     where isv_name = 'SFTCMX' AND
           event_name = 'oracle.apps.cll.ra_customer_trx' and
           PARAMETER_VALUE2 = '642' and
           TRUNC(CREATION_DATE) >= '01-jan-2015';
     
     