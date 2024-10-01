select * from SFWPPG.oif_export OIF
 where id_evento = 6101
   and id_parceiro = 502  
   and pk_number_01=4944; 
   
   
   
update oif_export OIF set oif.status=454673
 where oif.id_evento = 6101
 and oif.id_parceiro = 502 
 and oif.pk_number_01=4944; 

   