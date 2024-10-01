select * from apps.cll_f189_invoices_interface cfi;       
       
/*** Acerta NF onde Pis e Cofins maior que 0 ***/       
update apps.cll_f189_invoice_lines_iface cfl      
      set cfl.total_amount = cfl.icms_base - cfl.icms_amount - cfl.importation_pis_amount - cfl.importation_cofins_amount
   where cfl.interface_invoice_id in (select cfl2.interface_invoice_id 
                                        from apps.cll_f189_invoices_interface cfi, apps.cll_f189_invoice_lines_iface cfl2
                                       where cfL2.importation_cofins_amount + cfl2.importation_pis_amount <> 0 AND
                                             cfi.interface_invoice_id = cfl2.interface_invoice_id AND
                                             cfi.source               = 'SOFTWAY'                 AND
                                             cfi.process_flag in(1,3)                             AND
                                            (cfi.description          = 'NOTA FISCAL DE ENTRADA' OR
                                             cfi.description          = 'TIPO DE NOTA FISCAL NAO CONFIGURADO NO DE_PARA: [IS_OUT_TIPO_NF_RI]') AND
                                             cfI.organization_id in (86,92));
                                             
select * from apps.mtl_parameters;                                                     
                                             
/*** Consulta NF onde Pis e Cofinsigual maior que 0 ***/                                             
select cfi2.*, cfi2.source, cfl.interface_invoice_id, cfl.total_amount, cfl.icms_base - cfl.icms_amount - cfl.importation_pis_amount - cfl.importation_cofins_amount
   from apps.cll_f189_invoice_lines_iface cfl, apps.cll_f189_invoices_interface cfi2
   where cfi2.interface_invoice_id = cfl.interface_invoice_id  and
         --cfi2.interface_invoice_id = 1513630 and
         cfl.interface_invoice_id in (select cfl2.interface_invoice_id 
                                        from apps.cll_f189_invoices_interface cfi, apps.cll_f189_invoice_lines_iface cfl2
                                       where cfL2.importation_cofins_amount + cfl2.importation_pis_amount <> 0 AND
                                             cfi.interface_invoice_id = cfl2.interface_invoice_id AND
                                             cfi.source               = 'SOFTWAY'                 AND
                                             cfi.process_flag in(1,3)                             AND
                                            (cfi.description          = 'NOTA FISCAL DE ENTRADA' OR
                                             cfi.description          = 'TIPO DE NOTA FISCAL NAO CONFIGURADO NO DE_PARA: [IS_OUT_TIPO_NF_RI]') AND
                                             cfI.organization_id in (86,92));                                               

                                             
/*** Acerta NF onde Pis e Cofinsigual a 0 ***/       
update apps.cll_f189_invoice_lines_iface cfl      
      set cfl.total_amount = cfl.icms_base -- cfl.icms_amount - cfl.importation_pis_amount - cfl.importation_cofins_amount
   where cfl.interface_invoice_id in (select cfl2.interface_invoice_id 
                                        from apps.cll_f189_invoices_interface cfi, apps.cll_f189_invoice_lines_iface cfl2
                                       where cfL2.importation_cofins_amount + cfl2.importation_pis_amount = 0 AND
                                             cfi.interface_invoice_id = cfl2.interface_invoice_id AND
                                             cfi.source               = 'SOFTWAY'                 AND
                                             cfi.process_flag in(1,3)                             AND
                                            (cfi.description          = 'NOTA FISCAL DE ENTRADA' OR
                                             cfi.description          = 'TIPO DE NOTA FISCAL NAO CONFIGURADO NO DE_PARA: [IS_OUT_TIPO_NF_RI]') AND
                                             cfi.organization_id in (86,92));
                                             
/*** Consulta NF onde Pis e Cofinsigual a 0 ***/                                             
select cfi2.source, cfl.interface_invoice_id, cfl.total_amount, cfl.icms_base
   from apps.cll_f189_invoice_lines_iface cfl, apps.cll_f189_invoices_interface cfi2
   where cfi2.interface_invoice_id = cfl.interface_invoice_id  and
         cfl.interface_invoice_id in (select cfl2.interface_invoice_id 
                                        from apps.cll_f189_invoices_interface cfi, apps.cll_f189_invoice_lines_iface cfl2
                                       where cfL2.importation_cofins_amount + cfl2.importation_pis_amount = 0 AND
                                             cfi.interface_invoice_id = cfl2.interface_invoice_id AND
                                             cfi.source               = 'SOFTWAY'                 AND
                                             cfi.process_flag in(1,3)                             AND
                                            (cfi.description          = 'NOTA FISCAL DE ENTRADA' OR
                                             cfi.description          = 'TIPO DE NOTA FISCAL NAO CONFIGURADO NO DE_PARA: [IS_OUT_TIPO_NF_RI]') AND
                                             cfI.organization_id in (86,92));