select * from apps.cll_f255_notifications where
     EVENT_NAME = 'oracle.apps.cll.ap_supplier_sites_all' and
     TRUNC(CREATION_DATE) = TRUNC(SYSDATE); and
     
     
      ISV_NAME = 'SFTCMX' AND parameter_value3 IN ('525780');