declare
   m_id     integer;
   l_count  integer;
   l_count2 integer;
   l_reg    integer;

   cursor r_c is
      SELECT (SELECT MAX(message_id) + 1 FROM XXPPG_PRINTER_MESSAGES_v) x_id,
                      msi.inventory_item_id,
                      msi.segment1,
                      'PPG - Attributos do Item' att,
                      msii.description 
                 FROM APPS.MTL_SYSTEM_ITEMS_INTERFACE MSII,
                      apps.mtl_system_items_b         msi
                WHERE msi.segment1        = msii.segment1 AND
                      msi.organization_id = 87;
begin 
   SELECT MAX(message_id) into m_id FROM XXPPG_PRINTER_MESSAGES_v;
   l_count  := 0;
   l_count2 := 0;
   for c_c in r_c loop
      l_reg := 0;
      
      begin
         select 1 into l_reg
           from XXPPG_PRINTER_MESSAGES xpm
          where xpm.message_name = 'INFORMACAO_ADICIONAL_ITEM - ' || c_c.segment1;
         
         exception when no_data_found then
            l_reg := 0;
         
      end;
      if l_reg = 0 then                   
          m_id := m_id + 1;
          begin
             insert into XXPPG_PRINTER_MESSAGES 
                         (message_id,
                          message_name,
                          message_item_id,
                          MESSAGE_TYPE,
                          message_text,
                          ATTRIBUTE_CATEGORY,
                          ATTRIBUTE26)
                    values 
                         (m_id,
                          'INFORMACAO_ADICIONAL_ITEM - ' || c_c.segment1,
                          c_c.inventory_item_id,
                          'INFORMACAO_ADICIONAL_ITEM',
                          'NA',
                          c_c.att,
                          c_c.description);
              l_count := l_count + 1;
          end;
      else
          update XXPPG_PRINTER_MESSAGES xpm
             set xpm.ATTRIBUTE26 = c_c.description
           where xpm.message_name = 'INFORMACAO_ADICIONAL_ITEM - ' || c_c.segment1;
           l_count2 := l_count2 + 1;
      end if; 
   end loop;
   DBMS_OUTPUT.put_line('Lines created : ' || l_count);
   DBMS_OUTPUT.put_line('Lines updated : ' || l_count2);   
end;
