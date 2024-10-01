declare

 l_interface_invoice_id NUMBER; 
 l_count           number;
 l_siscomex_real   number;
 l_siscomex_dollar number;
 l_net             apps.cll_f189_invoice_lines_iface.net_amount%TYPE;
 l_rateio          apps.cll_f189_invoice_lines_iface.net_amount%TYPE;
 l_valor_rateio    apps.cll_f189_invoice_lines_iface.net_amount%TYPE;
 l_valor_rateio_total apps.cll_f189_invoice_lines_iface.net_amount%TYPE;
 l_net_amount      apps.cll_f189_invoice_lines_iface.net_amount%TYPE;
 l_contador        number;
 
 CURSOR C_NF IS
  select * from apps.cll_f189_invoices_interface
  where source = 'SOFTWAY' and process_flag in(1,3) and SISCOMEX_AMOUNT <> 0;

 
begin
   
   begin 
     select nvl(count(*),0) into l_count from apps.cll_f189_invoices_interface
     where source = 'SOFTWAY' and process_flag in(1,3) and SISCOMEX_AMOUNT <> 0;
   exception
     when others then
       l_count := 0;
   end; 
   
   if l_count > 0 then
     
     FOR l_invoice in c_nf LOOP
     
         l_siscomex_real   := l_invoice.SISCOMEX_AMOUNT;
         l_siscomex_dollar := l_invoice.DOLLAR_SISCOMEX_AMOUNT;
         dbms_output.put_line('-------------------------------------------------------------------');
         dbms_output.put_line('NF:'||l_invoice.invoice_num);
         dbms_output.put_line('INTERFACE_OPERATION_ID: '||l_invoice.interface_operation_id);
         dbms_output.put_line('IMPORT_OTHER_VAL_INCLUDED_ICMS: '||l_invoice.import_other_val_included_icms);
         dbms_output.put_line('IMPORT_OTHER_VAL_NOT_ICMS: '||l_invoice.import_other_val_not_icms);
         dbms_output.put_line('DOLLAR_OTHER_VAL_INCLUDED_ICMS: '||l_invoice.dollar_other_val_included_icms);
         dbms_output.put_line('DOLLAR_OTHER_VAL_NOT_ICMS: '||l_invoice.dollar_other_val_not_icms);
         dbms_output.put_line('SISCOMEX_AMOUNT: '||l_siscomex_real);
         dbms_output.put_line('DOLLAR_SISCOMEX_AMOUNT: '||l_siscomex_dollar);
         
         l_count := 0;
         l_net  := 0;
         l_rateio := 0;
         l_contador := 0;
         l_valor_rateio := 0;
         l_valor_rateio_total := 0;
        
         begin 
                     
             select nvl(count(*),0),sum(net_amount) into l_count,l_net from apps.cll_f189_invoice_lines_iface
             where interface_invoice_id = l_invoice.interface_invoice_id;
                 
         exception
           when others then
              l_count := 0;
         end;
        
        dbms_output.put_line('');
        dbms_output.put_line('l_count: '||l_count);         
        dbms_output.put_line('l_net: '||l_net);
        dbms_output.put_line('');
      
         FOR l_invoice_lines in (select * from apps.cll_f189_invoice_lines_iface where interface_invoice_id = l_invoice.interface_invoice_id) LOOP
        
                     
             l_contador := l_contador + 1;
             
             if l_siscomex_real = 0 then
                
                l_rateio := 0;
                l_valor_rateio := l_siscomex_real;
                dbms_output.put_line('INTERFACE_INVOICE_LINE_ID: '||l_invoice_lines.interface_invoice_line_id || '  VALOR_RATEIO: '||l_valor_rateio);
                
             else
                
                if l_net > 0 then
                   l_rateio := l_invoice_lines.net_amount/l_net;
                else
                   l_rateio := 1;
                end if;
                
                l_valor_rateio := round(l_siscomex_real * l_rateio,2);
             
             end if;
             
             l_valor_rateio_total := l_valor_rateio_total+ l_valor_rateio;

             if l_contador = l_count then
                
                if l_siscomex_real - l_valor_rateio_total <> 0 then
                   l_valor_rateio := l_valor_rateio + (l_siscomex_real - l_valor_rateio_total);
                end if;
                
             end if;
             
             l_net_amount:= l_invoice_lines.fob_amount + l_invoice_lines.freight_internacional + l_invoice_lines.importation_tax_amount;
             
            dbms_output.put_line('NET_AMOUNT: '||l_invoice_lines.net_amount);            
            dbms_output.put_line('l_valor_rateio: '||l_valor_rateio);
            dbms_output.put_line('l_valor_rateio_total: '||l_valor_rateio_total);
            dbms_output.put_line('');
            dbms_output.put_line('INTERFACE_INVOICE_LINE_ID: '||l_invoice_lines.interface_invoice_line_id ||' --> ' 
                                                             ||'  IMPORT_OTHER_VAL_INCLUDED_ICMS: '||l_valor_rateio||' -->'
                                                             ||'  IMPORT_OTHER_VAL_NOT_ICMS: '||0||' -->'
                                                             ||'  NET_AMOUNT: '||l_net_amount||' --> '
                                                             ||'  VALOR_RATEIO: '||l_valor_rateio||' --> '
                                                             ||'  VALOR_TOT_RATEIO: '||l_valor_rateio_total
                                                             );               
         
             
             update apps.cll_f189_invoice_lines_iface 
               set import_other_val_included_icms = l_valor_rateio
                  ,import_other_val_not_icms      = 0
                  ,net_amount = l_net_amount
             where interface_invoice_line_id = l_invoice_lines.interface_invoice_line_id;
                                   
         END LOOP; 
         
         update apps.cll_f189_invoices_interface 
            set IMPORT_OTHER_VAL_INCLUDED_ICMS = l_invoice.siscomex_amount
               ,IMPORT_OTHER_VAL_NOT_ICMS      = 0
               ,DOLLAR_OTHER_VAL_INCLUDED_ICMS = l_invoice.dollar_siscomex_amount
               ,DOLLAR_OTHER_VAL_NOT_ICMS      = 0
               ,SISCOMEX_AMOUNT                = 0
               ,DOLLAR_SISCOMEX_AMOUNT         = 0
               ,GL_DATE = TRUNC(SYSDATE)
               ,RECEIVE_DATE = TRUNC(SYSDATE)
         where interface_operation_id = l_invoice.interface_operation_id;
         
         
         dbms_output.put_line(''''||l_invoice.invoice_num);
         dbms_output.put_line('INTERFACE_OPERATION_ID: '||l_invoice.interface_operation_id);
         dbms_output.put_line('IMPORT_OTHER_VAL_INCLUDED_ICMS: '||l_siscomex_real);
         dbms_output.put_line('IMPORT_OTHER_VAL_NOT_ICMS: '||0);
         dbms_output.put_line('DOLLAR_OTHER_VAL_INCLUDED_ICMS: '||l_siscomex_dollar);
         dbms_output.put_line('DOLLAR_OTHER_VAL_NOT_ICMS: '||0);
         dbms_output.put_line('SISCOMEX_AMOUNT: '||0);
         dbms_output.put_line('DOLLAR_SISCOMEX_AMOUNT: '||0);
         dbms_output.put_line('');
         dbms_output.put_line('Update Realizado com Sucesso');         
         dbms_output.put_line('-------------------------------------------------------------------');
         dbms_output.put_line('');
         commit;
         
     END LOOP;
     
   end if;
   
end;

