UPDATE oif_export OIF set oif.status=454673
--SELECT * from  oif_export OIF
 where oif.id_evento = 6101
 and oif.id_parceiro = 502
 and trunc(data_transacao) = trunc(sysdate)
 and pk_vc2_01 = 'SUM0326/16';
  
 and oif.pk_number_01=4944; 
commit;