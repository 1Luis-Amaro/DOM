select ood.organization_name                                        Es, 
       rcta.trx_number||' - '||rbsa.global_attribute3                              nf_serie,
       ooha.sales_channel_code                                                     Canal_de_Venda, 
       to_char(rcta.trx_date,'DD/MM/YYYY')                                         trx_data,
       trim(to_char(rctla.extended_amount
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))       valor_total,
       'Receita:'||conta_revenue.code_combination||chr(10)||
       'a Receber:'||conta_receivable.code_combination                             flex_contabil_NF,
       trim(to_char(rctla.GROSS_UNIT_SELLING_PRICE
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))       valor_unitario,
       trim(to_char(to_number(nvl(rcta.global_attribute17,0))
                   ,'999G990D99','nls_numeric_characters = '',.'''))               peso_liquido,
       trim(to_char(to_number(nvl(rcta.global_attribute16,0))
                   ,'999G990D99','nls_numeric_characters = '',.'''))               peso_bruto,
       wdd.freight_terms_code                                                      frete,
       decode(
       decode(trim(to_char(round(to_number((apps.inv_convert.inv_um_convert (msi.inventory_item_id,
                                                       0,
                                                       rctla.quantity_invoiced,
                                                       rctla.uom_code,
                                                       'l',
                                                       NULL,
                                                       NULL))),2),'999G990D99','nls_numeric_characters = '',.''')) 
              ,'-99.999,00',trim(to_char(round(to_number((apps.inv_convert.inv_um_convert (msi.inventory_item_id,
                                                       0,
                                                       rctla.quantity_invoiced,
                                                       rctla.uom_code,
                                                       msi.secondary_uom_code,
                                                       NULL,
                                                       NULL))),2),'999G990D99','nls_numeric_characters = '',.''')) 
              ,trim(to_char(round(to_number((apps.inv_convert.inv_um_convert (msi.inventory_item_id,
                                                       0,
                                                       rctla.quantity_invoiced,
                                                       rctla.uom_code,
                                                       'l',
                                                       NULL,
                                                       NULL))),2),'999G990D99','nls_numeric_characters = '',.'''))  )
              ,'-99.999,00',to_char(rctla.quantity_invoiced,'999G990D99','nls_numeric_characters = '',.''')
              ,decode(trim(to_char(round(to_number((apps.inv_convert.inv_um_convert (msi.inventory_item_id,
                                                       0,
                                                       rctla.quantity_invoiced,
                                                       rctla.uom_code,
                                                       'l',
                                                       NULL,
                                                       NULL))),2),'999G990D99','nls_numeric_characters = '',.''')) 
              ,'-99.999,00',trim(to_char(round(to_number((apps.inv_convert.inv_um_convert (msi.inventory_item_id,
                                                       0,
                                                       rctla.quantity_invoiced,
                                                       rctla.uom_code,
                                                       msi.secondary_uom_code,
                                                       NULL,
                                                       NULL))),2),'999G990D99','nls_numeric_characters = '',.''')) 
              ,trim(to_char(round(to_number((apps.inv_convert.inv_um_convert (msi.inventory_item_id,
                                                       0,
                                                       rctla.quantity_invoiced,
                                                       rctla.uom_code,
                                                       'l',
                                                       NULL,
                                                       NULL))),2),'999G990D99','nls_numeric_characters = '',.'''))  )) litros,     
       trim(to_char(xtnb.vl_tota_fret_calc
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))       Vlr_Frete,
       wcsm.freight_code                                                           transportador,
       (select hp.party_name 
          from ar.hz_party_sites         ps
              ,ar.hz_parties             hp
              ,ar.hz_locations           hl1
              ,ar.hz_cust_acct_sites_all cas
         where 1 = 1 
           and hl1.location_id   = ps.location_id
           and cas.party_site_id = ps.party_site_id
           and ps.party_id       = hp.party_id
           and hl1.location_id   = wdd.intmed_ship_to_location_id  )               redespacho,
       (rcta.trx_date + nvl(xtnb.qt_lead_time_entr,0))                             Prev_entrega,
       hcasa.global_attribute3||
     hcasa.global_attribute4||
     hcasa.global_attribute5||' - '|| hp.party_name                              cliente,
       hl.city || ' - '|| hl.state                                                 local_cliente, 
       (select apps.xxppg_qp_sourcing_fields_pkg.get_salesrep_info(ooha.salesrep_id,'srep.name', 'srep.salesrep_id') from dual) Representante, 
       ooha.order_number                                                           pedido, 
       (select trim(to_char(sum((nvl(oola1.ordered_quantity,0) - 
                                (nvl(oola1.shipped_quantity,0) - 
                                 nvl(oola1.cancelled_quantity,0))))
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))             
          from apps.oe_order_lines_all oola1
         where oola1.header_id = ooha.header_id
           and oola1.cancelled_flag = 'N')                                         Saldo_Carteira, 
       (select decode(sum((nvl(oola1.ordered_quantity,0) - 
                          (nvl(oola1.shipped_quantity,0) - 
                           nvl(oola1.cancelled_quantity,0))))
                     ,0, 'Total','Parcial')
          from apps.oe_order_lines_all oola1
         where oola1.header_id = ooha.header_id
           and oola1.cancelled_flag = 'N')                                         Status_Pick,
       to_char(ooha.creation_date,'DD/MM/YYYY HH24:MM')                            Data_Hr_Implant_ped,
       rt.name                                                                     pgto,
       wdd.delivery_id                                                             embarque,
       wdd.date_requested                                                          Dt_Embarque, 
       wdd.subinventory                                                            Local_fisico,
       flv.meaning                                                                 Situacao_NF,
       quantity_invoiced                                                           Nr_items,
       to_char(( select hr.creation_date 
                   from ont.oe_hold_releases    hr
                       ,ont.oe_order_holds_all  oh 
                       ,ont.oe_hold_sources_all hs
                       ,ont.oe_hold_definitions hd
                  where hr.hold_source_id = oh.hold_source_id
                    and oh.header_id      = ooha.header_id
                    and oh.hold_source_id = hs.hold_source_id
                    and hs.hold_id        = hd.hold_id
                    and (upper(hd.type_code) like '%CRED%' or
                         hd.type_code like '%Cred%' )
                    and rownum = 1  ),'DD/MM/YYYY HH24:MI')                        Dt_Hr_Aprov_cred,
       hp.attribute3                                                               ramo_atividade,
       msi.segment1                                                                produto, 
       zldf.product_fisc_classification                                            ncm, 
       (select jzatefa.attribute1 
          from apps.jl_zz_ar_tx_exc_fsc_all   jzatefa
              ,apps.ar_location_values        val
              ,apps.ra_customer_trx_lines_all rctla1
             ,apps.ar_vat_tax_all            avta
         where jzatefa.ship_to_segment_id         = val.location_segment_id
           and rctla1.vat_tax_id                  = avta.vat_tax_id 
           and avta.tax_code                      = jzatefa.tax_code
           and jzatefa.ship_from_code             = upper(hrl.region_2)
           and jzatefa.fiscal_classification_code = zldf.product_fisc_classification
           and val.location_segment_value         = upper(hl.state)
           and rctla1.link_to_cust_trx_line_id    = rctla.customer_trx_line_id 
           and rctla1.extended_amount             > 0 
           and avta.global_attribute10            = 'ICMS-ST'
           and val.location_structure_id          = 2
           and flv.lookup_code                    = 2
           and rownum                             = 1)                             mva,
       (select  
               decode(nvl(flvDeso.attribute1,'N'),'N','Nao','Sim') 
          from apps.fnd_lookup_values flvDeso
         where flvDeso.lookup_type = 'JLZZ_AR_TX_FISCAL_CLASS_CODE'
           and flvDeso.language    = 'PTB' 
           and flvDeso.lookup_code = zldf.product_fisc_classification)             desoneracao,
       (select regexp_replace(replace(fl.meaning,'%',' pp'), '[^0-9 a-z A-Z]')
          from apps.fnd_lookups fl 
         where fl.lookup_type = 'JLBR_ITEM_ORIGIN' 
           and NVL(fl.end_date_active, sysdate + 1) > sysdate 
           and fl.lookup_code = msi.global_attribute3)                             Origem_item,
       rctla.global_attribute1                                                     nat_op,
       rctta.description                                                           Tipo_Nat_op,
       rctla.tax_classification_code                                               Grupo_imposto,
       to_char(oola.schedule_ship_date,'DD/MM/YYYY')                               Dt_Entrega_ped,
       trim(to_char(vlicms.tax_rate
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))       alq_icms,
       trim(to_char(vlicms.extended_amount
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))       vlr_icms,
       trim(to_char(vlicms.taxable_amount
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))       bs_icms,
       'ICMS-C:'||conta_c_icms.code_combination||chr(10)||
       'ICMS-D:'||conta_d_icms.code_combination                                    flex_contabil_icms,
       trim(to_char(vlicmsst.tax_rate
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))       alq_icmsst,
       trim(to_char(vlicmsst.extended_amount
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))       vlr_icmsst,
       trim(to_char(vlicmsst.taxable_amount
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))       bs_icmsst,
       'ICMS_ST-C:'||conta_c_icmsst.code_combination||chr(10)||
       'ICMS_ST-D:'||conta_d_icmsst.code_combination                               flex_contabil_icmsst,
       trim(to_char(vlipi.tax_rate
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))       aql_ipi,
       trim(to_char(vlipi.extended_amount
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))       vlr_ipi,
       trim(to_char(vlipi.taxable_amount
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))       bs_ipi,
       'IPI-C:'||conta_c_ipi.code_combination||chr(10)||
       'IPI-D:'||conta_d_ipi.code_combination                                      flex_contabil_ipi,
       trim(to_char(vlcofins.tax_rate
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))       aql_cofins,
       trim(to_char(vlcofins.extended_amount
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))       vlr_cofins,
       trim(to_char(vlcofins.taxable_amount
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))       bs_cofins,  
       'COFINS-C:'||conta_c_cofins.code_combination||chr(10)||
       'COFINS-D:'||conta_d_cofins.code_combination                                flex_contabil_cofins,
       trim(to_char(vlpis.tax_rate
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))       aql_pis,
       trim(to_char(vlpis.extended_amount
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))       vlr_pis,
       trim(to_char(vlpis.taxable_amount
                   ,'999G999G999G990D99','nls_numeric_characters = '',.'''))       bs_pis,
       'PIS-C:'||conta_c_pis.code_combination||chr(10)||
       'PIS-D:'||conta_d_pis.code_combination                                      flex_contabil_pis, 
       rctla.global_attribute6                                                     IPI_CST,
       rctla.global_attribute7                                                     ICMS_CST,
       vlcofins.COFINS_CST                                                         COFINS_CST,
       vlpis.PIS_CST                                                               PIS_CST
  from apps.ra_customer_trx_all           rcta
      ,apps.ra_customer_trx_lines_all    rctla
      ,apps.ra_batch_sources_all         rbsa
      ,apps.ra_cust_trx_types_all        rctta
      ,apps.ra_terms                     rt
      ,apps.org_organization_definitions ood
      ,apps.hz_cust_site_uses_all        hcsua
      ,apps.hz_cust_acct_sites_all       hcasa
      ,apps.hz_party_sites               hps
      ,apps.hz_parties                   hp
      ,apps.hz_locations                 hl
      ,apps.oe_order_headers_all         ooha
      ,apps.oe_order_lines_all           oola
      ,apps.jl_br_customer_trx_exts      jbcte
      ,apps.fnd_lookup_values            flv
      ,apps.mtl_system_items_b           msi
      ,(select sum(wdd.net_weight)   net_weight
              ,sum(wdd.gross_weight) gross_weight
              ,wdd.freight_terms_code
              ,wdd.intmed_ship_to_location_id
              ,wdd.delivery_id
              ,wdd.date_requested
              ,wdd.subinventory
              ,wdd.source_line_id
              ,wdd.carrier_id
              ,wdd.service_level
              ,wdd.organization_id
          from apps.wsh_deliverables_v wdd
         where wdd.shipped_quantity IS NOT NULL
         group by wdd.freight_terms_code
                 ,wdd.intmed_ship_to_location_id
                 ,wdd.delivery_id
                 ,wdd.date_requested
                 ,wdd.subinventory
                 ,wdd.source_line_id
                 ,wdd.carrier_id
                 ,wdd.service_level
                 ,wdd.organization_id            )      wdd
      ,(select wcsm.freight_code
              ,wcsm.carrier_id
              ,wcsm.service_level
              ,wcsm.organization_id
          from apps.wsh_carrier_ship_methods wcsm
         group by wcsm.freight_code
                 ,wcsm.carrier_id
                 ,wcsm.service_level
                 ,wcsm.organization_id)  wcsm
      ,apps.xxppgbr_tbl_853_notas_bi     xtnb
      ,apps.zx_lines_det_factors         zldf
      ,apps.mtl_parameters               mp
      ,apps.hr_locations                 hrl
      ,(select rctla1.extended_amount
             , rctla1.tax_rate
             , rctla1.taxable_amount
             , rctla1.link_to_cust_trx_line_id customer_trx_line_id
          from apps.ra_customer_trx_lines_all rctla1,
               apps.ar_vat_tax_all avta
         where rctla1.vat_tax_id = avta.vat_tax_id
           and rctla1.line_type = 'TAX'
           and avta.global_attribute10 = 'ICMS'
           and nvl(avta.end_date,sysdate+1) > sysdate
           and rctla1.extended_amount > 0) VLICMS, 
       (select rctla1.extended_amount
             , rctla1.tax_rate
             , rctla1.taxable_amount
             , rctla1.link_to_cust_trx_line_id customer_trx_line_id
          from apps.ra_customer_trx_lines_all rctla1,
               apps.ar_vat_tax_all avta
         where rctla1.vat_tax_id = avta.vat_tax_id
           and rctla1.line_type = 'TAX'
           and avta.global_attribute10 = 'ICMS-ST'
           and nvl(avta.end_date,sysdate+1) > sysdate
           and rctla1.extended_amount > 0) VLICMSST, 
       (select rctla1.extended_amount
             , rctla1.tax_rate
             , rctla1.taxable_amount
             , rctla1.link_to_cust_trx_line_id customer_trx_line_id
          from apps.ra_customer_trx_lines_all rctla1,
               apps.ar_vat_tax_all avta
         where rctla1.vat_tax_id = avta.vat_tax_id
           and rctla1.line_type = 'TAX'
           and avta.global_attribute10 = 'IPI'
           and nvl(avta.end_date,sysdate+1) > sysdate
           and rctla1.extended_amount > 0) VLIPI, 
       (select rctla1.extended_amount
             , rctla1.tax_rate
             , rctla1.taxable_amount
             , rctla1.link_to_cust_trx_line_id customer_trx_line_id
             , avta.GLOBAL_ATTRIBUTE7 COFINS_CST
          from apps.ra_customer_trx_lines_all rctla1,
               apps.ar_vat_tax_all avta
         where rctla1.vat_tax_id = avta.vat_tax_id
           and rctla1.line_type = 'TAX'
           and avta.global_attribute10 = 'COFINS'
           and nvl(avta.end_date,sysdate+1) > sysdate
           and rctla1.extended_amount > 0) VLCOFINS, 
       (select rctla1.extended_amount
             , rctla1.tax_rate
             , rctla1.taxable_amount
             , rctla1.link_to_cust_trx_line_id customer_trx_line_id
             , avta.GLOBAL_ATTRIBUTE6 PIS_CST
          from apps.ra_customer_trx_lines_all rctla1,
               apps.ar_vat_tax_all avta
         where rctla1.vat_tax_id = avta.vat_tax_id
           and rctla1.line_type = 'TAX'
           and avta.global_attribute10 = 'PIS'
           and nvl(avta.end_date,sysdate+1) > sysdate
           and rctla1.extended_amount > 0) VLPIS,
       (Select rctg.customer_trx_id,
               rctg.customer_trx_line_id,
               rctl.link_to_cust_trx_line_id,
               gcc.segment1||'-'||
               gcc.segment2||'-'||
               gcc.segment3||'-'||
               gcc.segment4||'-'||
               gcc.segment5||'-'||
               gcc.segment6||'-'||
               gcc.segment7              code_combination
          From apps.ra_cust_trx_line_gl_dist_all rctg,
               apps.ra_customer_trx_lines_all    rctl,
               apps.ra_customer_trx_all          rct,
               apps.ra_cust_trx_types_all        rctt,
               apps.ar_vat_tax_all_b             avt,
               apps.gl_code_combinations         gcc
         Where rctg.customer_trx_line_id        = rctl.customer_trx_line_id(+)
           and rctl.vat_tax_id                  = avt.vat_tax_id(+)
           and rctg.account_class               = 'TAX'
           and rctg.customer_trx_id             = rct.customer_trx_id
           and rct.cust_trx_type_id             = rctt.cust_trx_type_id
           and rctg.code_combination_id         = gcc.code_combination_id(+)
           and avt.global_attribute10           = 'ICMS'
           and nvl(avt.end_date,sysdate+1)      > sysdate
           and substr(avt.tax_code,length(avt.tax_code),1) = 'C') conta_c_icms,
       (Select rctg.customer_trx_id,
               rctg.customer_trx_line_id,
               rctl.link_to_cust_trx_line_id,
               gcc.segment1||'-'||
               gcc.segment2||'-'||
               gcc.segment3||'-'||
               gcc.segment4||'-'||
               gcc.segment5||'-'||
               gcc.segment6||'-'||
               gcc.segment7              code_combination
          From apps.ra_cust_trx_line_gl_dist_all rctg,
               apps.ra_customer_trx_lines_all    rctl,
               apps.ra_customer_trx_all          rct,
               apps.ra_cust_trx_types_all        rctt,
               apps.ar_vat_tax_all_b             avt,
               apps.gl_code_combinations         gcc
         Where rctg.customer_trx_line_id        = rctl.customer_trx_line_id(+)
           and rctl.vat_tax_id                  = avt.vat_tax_id(+)
           and rctg.account_class               = 'TAX'
           and rctg.customer_trx_id             = rct.customer_trx_id
           and rct.cust_trx_type_id             = rctt.cust_trx_type_id
           and rctg.code_combination_id         = gcc.code_combination_id(+)
           and avt.global_attribute10           = 'ICMS'
           and nvl(avt.end_date,sysdate+1)      > sysdate
           and substr(avt.tax_code,length(avt.tax_code),1) = 'D') conta_d_icms,
       (Select rctg.customer_trx_id,
               rctg.customer_trx_line_id,
               rctl.link_to_cust_trx_line_id,
               gcc.segment1||'-'||
               gcc.segment2||'-'||
               gcc.segment3||'-'||
               gcc.segment4||'-'||
               gcc.segment5||'-'||
               gcc.segment6||'-'||
               gcc.segment7              code_combination
          From apps.ra_cust_trx_line_gl_dist_all rctg,
               apps.ra_customer_trx_lines_all    rctl,
               apps.ra_customer_trx_all          rct,
               apps.ra_cust_trx_types_all        rctt,
               apps.ar_vat_tax_all_b             avt,
               apps.gl_code_combinations         gcc
         Where rctg.customer_trx_line_id        = rctl.customer_trx_line_id(+)
           and rctl.vat_tax_id                  = avt.vat_tax_id(+)
           and rctg.account_class               = 'TAX'
           and rctg.customer_trx_id             = rct.customer_trx_id
           and rct.cust_trx_type_id             = rctt.cust_trx_type_id
           and rctg.code_combination_id         = gcc.code_combination_id(+)
           and avt.global_attribute10           = 'IPI'
           and nvl(avt.end_date,sysdate+1)      > sysdate
           and substr(avt.tax_code,length(avt.tax_code),1) = 'C') conta_c_ipi,
       (Select rctg.customer_trx_id,
               rctg.customer_trx_line_id,
               rctl.link_to_cust_trx_line_id,
               gcc.segment1||'-'||
               gcc.segment2||'-'||
               gcc.segment3||'-'||
               gcc.segment4||'-'||
               gcc.segment5||'-'||
               gcc.segment6||'-'||
               gcc.segment7              code_combination
          From apps.ra_cust_trx_line_gl_dist_all rctg,
               apps.ra_customer_trx_lines_all    rctl,
               apps.ra_customer_trx_all          rct,
               apps.ra_cust_trx_types_all        rctt,
               apps.ar_vat_tax_all_b             avt,
               apps.gl_code_combinations         gcc
         Where rctg.customer_trx_line_id        = rctl.customer_trx_line_id(+)
           and rctl.vat_tax_id                  = avt.vat_tax_id(+)
           and rctg.account_class               = 'TAX'
           and rctg.customer_trx_id             = rct.customer_trx_id
           and rct.cust_trx_type_id             = rctt.cust_trx_type_id
           and rctg.code_combination_id         = gcc.code_combination_id(+)
           and avt.global_attribute10           = 'IPI'
           and nvl(avt.end_date,sysdate+1)      > sysdate
           and substr(avt.tax_code,length(avt.tax_code),1) = 'D') conta_d_ipi,
       (Select rctg.customer_trx_id,
               rctg.customer_trx_line_id,
               rctl.link_to_cust_trx_line_id,
               gcc.segment1||'-'||
               gcc.segment2||'-'||
               gcc.segment3||'-'||
               gcc.segment4||'-'||
               gcc.segment5||'-'||
               gcc.segment6||'-'||
               gcc.segment7              code_combination
          From apps.ra_cust_trx_line_gl_dist_all rctg,
               apps.ra_customer_trx_lines_all    rctl,
               apps.ra_customer_trx_all          rct,
               apps.ra_cust_trx_types_all        rctt,
               apps.ar_vat_tax_all_b             avt,
               apps.gl_code_combinations         gcc
         Where rctg.customer_trx_line_id        = rctl.customer_trx_line_id(+)
           and rctl.vat_tax_id                  = avt.vat_tax_id(+)
           and rctg.account_class               = 'TAX'
           and rctg.customer_trx_id             = rct.customer_trx_id
           and rct.cust_trx_type_id             = rctt.cust_trx_type_id
           and rctg.code_combination_id         = gcc.code_combination_id(+)
           and avt.global_attribute10           = 'ICMS-ST'
           and nvl(avt.end_date,sysdate+1)      > sysdate
           and substr(avt.tax_code,length(avt.tax_code),1) = 'C') conta_c_icmsst,
       (Select rctg.customer_trx_id,
               rctg.customer_trx_line_id,
               rctl.link_to_cust_trx_line_id,
               gcc.segment1||'-'||
               gcc.segment2||'-'||
               gcc.segment3||'-'||
               gcc.segment4||'-'||
               gcc.segment5||'-'||
               gcc.segment6||'-'||
               gcc.segment7              code_combination
          From apps.ra_cust_trx_line_gl_dist_all rctg,
               apps.ra_customer_trx_lines_all    rctl,
               apps.ra_customer_trx_all          rct,
               apps.ra_cust_trx_types_all        rctt,
               apps.ar_vat_tax_all_b             avt,
               apps.gl_code_combinations         gcc
         Where rctg.customer_trx_line_id        = rctl.customer_trx_line_id(+)
           and rctl.vat_tax_id                  = avt.vat_tax_id(+)
           and rctg.account_class               = 'TAX'
           and rctg.customer_trx_id             = rct.customer_trx_id
           and rct.cust_trx_type_id             = rctt.cust_trx_type_id
           and rctg.code_combination_id         = gcc.code_combination_id(+)
           and avt.global_attribute10           = 'ICMS-ST'
           and nvl(avt.end_date,sysdate+1)      > sysdate
           and substr(avt.tax_code,length(avt.tax_code),1) = 'D') conta_d_icmsst,
       (Select rctg.customer_trx_id,
               rctg.customer_trx_line_id,
               rctl.link_to_cust_trx_line_id,
               gcc.segment1||'-'||
               gcc.segment2||'-'||
               gcc.segment3||'-'||
               gcc.segment4||'-'||
               gcc.segment5||'-'||
               gcc.segment6||'-'||
               gcc.segment7              code_combination
          From apps.ra_cust_trx_line_gl_dist_all rctg,
               apps.ra_customer_trx_lines_all    rctl,
               apps.ra_customer_trx_all          rct,
               apps.ra_cust_trx_types_all        rctt,
               apps.ar_vat_tax_all_b             avt,
               apps.gl_code_combinations         gcc
         Where rctg.customer_trx_line_id        = rctl.customer_trx_line_id(+)
           and rctl.vat_tax_id                  = avt.vat_tax_id(+)
           and rctg.account_class               = 'TAX'
           and rctg.customer_trx_id             = rct.customer_trx_id
           and rct.cust_trx_type_id             = rctt.cust_trx_type_id
           and rctg.code_combination_id         = gcc.code_combination_id(+)
           and avt.global_attribute10           = 'COFINS'
           and nvl(avt.end_date,sysdate+1)      > sysdate
           and substr(avt.tax_code,length(avt.tax_code),1) = 'C') conta_c_cofins,
       (Select rctg.customer_trx_id,
               rctg.customer_trx_line_id,
               rctl.link_to_cust_trx_line_id,
               gcc.segment1||'-'||
               gcc.segment2||'-'||
               gcc.segment3||'-'||
               gcc.segment4||'-'||
               gcc.segment5||'-'||
               gcc.segment6||'-'||
               gcc.segment7              code_combination
          From apps.ra_cust_trx_line_gl_dist_all rctg,
               apps.ra_customer_trx_lines_all    rctl,
               apps.ra_customer_trx_all          rct,
               apps.ra_cust_trx_types_all        rctt,
               apps.ar_vat_tax_all_b             avt,
               apps.gl_code_combinations         gcc
         Where rctg.customer_trx_line_id        = rctl.customer_trx_line_id(+)
           and rctl.vat_tax_id                  = avt.vat_tax_id(+)
           and rctg.account_class               = 'TAX'
           and rctg.customer_trx_id             = rct.customer_trx_id
           and rct.cust_trx_type_id             = rctt.cust_trx_type_id
           and rctg.code_combination_id         = gcc.code_combination_id(+)
           and avt.global_attribute10           = 'COFINS'
           and nvl(avt.end_date,sysdate+1)      > sysdate
           and substr(avt.tax_code,length(avt.tax_code),1) = 'D') conta_d_cofins,
       (Select rctg.customer_trx_id,
               rctg.customer_trx_line_id,
               rctl.link_to_cust_trx_line_id,
               gcc.segment1||'-'||
               gcc.segment2||'-'||
               gcc.segment3||'-'||
               gcc.segment4||'-'||
               gcc.segment5||'-'||
               gcc.segment6||'-'||
               gcc.segment7              code_combination
          From apps.ra_cust_trx_line_gl_dist_all rctg,
               apps.ra_customer_trx_lines_all    rctl,
               apps.ra_customer_trx_all          rct,
               apps.ra_cust_trx_types_all        rctt,
               apps.ar_vat_tax_all_b             avt,
               apps.gl_code_combinations         gcc
         Where rctg.customer_trx_line_id        = rctl.customer_trx_line_id(+)
           and rctl.vat_tax_id                  = avt.vat_tax_id(+)
           and rctg.account_class               = 'TAX'
           and rctg.customer_trx_id             = rct.customer_trx_id
           and rct.cust_trx_type_id             = rctt.cust_trx_type_id
           and rctg.code_combination_id         = gcc.code_combination_id(+)
           and avt.global_attribute10           = 'PIS'
           and nvl(avt.end_date,sysdate+1)      > sysdate
           and substr(avt.tax_code,length(avt.tax_code),1) = 'C') conta_c_pis,
       (Select rctg.customer_trx_id,
               rctg.customer_trx_line_id,
               rctl.link_to_cust_trx_line_id,
               gcc.segment1||'-'||
               gcc.segment2||'-'||
               gcc.segment3||'-'||
               gcc.segment4||'-'||
               gcc.segment5||'-'||
               gcc.segment6||'-'||
               gcc.segment7              code_combination
          From apps.ra_cust_trx_line_gl_dist_all rctg,
               apps.ra_customer_trx_lines_all    rctl,
               apps.ra_customer_trx_all          rct,
               apps.ra_cust_trx_types_all        rctt,
               apps.ar_vat_tax_all_b             avt,
               apps.gl_code_combinations         gcc
         Where rctg.customer_trx_line_id        = rctl.customer_trx_line_id(+)
           and rctl.vat_tax_id                  = avt.vat_tax_id(+)
           and rctg.account_class               = 'TAX'
           and rctg.customer_trx_id             = rct.customer_trx_id
           and rct.cust_trx_type_id             = rctt.cust_trx_type_id
           and rctg.code_combination_id         = gcc.code_combination_id(+)
           and avt.global_attribute10           = 'PIS'
           and nvl(avt.end_date,sysdate+1)      > sysdate
           and substr(avt.tax_code,length(avt.tax_code),1) = 'D') conta_d_pis,
       (Select rctg.customer_trx_id,
               rctg.customer_trx_line_id,
               rctl.link_to_cust_trx_line_id,
               gcc.segment1||'-'||
               gcc.segment2||'-'||
               gcc.segment3||'-'||
               gcc.segment4||'-'||
               gcc.segment5||'-'||
               gcc.segment6||'-'||
               gcc.segment7              code_combination
          From apps.ra_cust_trx_line_gl_dist_all rctg,
               apps.ra_customer_trx_lines_all    rctl,
               apps.gl_code_combinations         gcc
         Where rctg.account_class               = 'REV'
           and rctg.customer_trx_line_id        = rctl.customer_trx_line_id(+)
           and rctg.code_combination_id         = gcc.code_combination_id(+) ) conta_revenue,
       (Select rctg.customer_trx_id,
               gcc.segment1||'-'||
               gcc.segment2||'-'||
               gcc.segment3||'-'||
               gcc.segment4||'-'||
               gcc.segment5||'-'||
               gcc.segment6||'-'||
               gcc.segment7              code_combination
          From apps.ra_cust_trx_line_gl_dist_all rctg,
               apps.ra_customer_trx_all          rct,
               apps.gl_code_combinations         gcc
         Where rctg.account_class               = 'REC'
           and rctg.code_combination_id         = gcc.code_combination_id
           and rctg.customer_trx_line_id is null
           and rctg.customer_trx_id = rct.customer_trx_id  ) conta_receivable
   where rcta.customer_trx_id       = rctla.customer_trx_id 
     and rctla.line_type            = 'LINE'
     and rbsa.batch_source_id       = rcta.batch_source_id 
     and rbsa.org_id                = rcta.org_id
     and rctta.cust_trx_type_id     = rcta.cust_trx_type_id 
     and rctta.org_id               = rcta.org_id
     and rctta.type                 = 'INV'  
     and hcsua.site_use_id          = rcta.ship_to_site_use_id
     and hcsua.org_id               = rcta.org_id 
     and hcsua.cust_acct_site_id    = hcasa.cust_acct_site_id 
     and hcasa.org_id               = hcsua.org_id  
     and hcasa.party_site_id        = hps.party_site_id  
     and hps.party_id               = hp.party_id  
     and hl.location_id             = hps.location_id  
     and oola.line_id               = to_number(nvl(rctla.interface_line_attribute6,0))
     and rcta.interface_header_context = 'ORDER ENTRY'
     and oola.header_id             = ooha.header_id 
     and rt.term_id                 = rcta.term_id  
     and ood.organization_id        = rctla.warehouse_id 
     and jbcte.customer_trx_id      = rcta.customer_trx_id 
     and flv.language     (+)       = 'PTB'  
     and flv.Lookup_type  (+)       = 'JLBR_EI_STATUS'  
     and flv.lookup_code  (+)       = jbcte.electronic_inv_status  
     and msi.inventory_item_id      = rctla.inventory_item_id 
     and msi.organization_id        = ood.organization_id
     and wdd.source_line_id (+)     = oola.line_id 
     and wdd.carrier_id             = wcsm.carrier_id  (+)
     and wdd.service_level          = wcsm.service_level (+)
     and wdd.organization_id        = wcsm.organization_id (+)
     and rctla.customer_trx_line_id = vlicms.customer_trx_line_id(+) 
     --  
     and rctla.customer_trx_line_id = conta_c_icms.link_to_cust_trx_line_id(+)   
     and rctla.customer_trx_line_id = conta_d_icms.link_to_cust_trx_line_id(+)   
     and rctla.customer_trx_line_id = conta_c_ipi.link_to_cust_trx_line_id(+)   
     and rctla.customer_trx_line_id = conta_d_ipi.link_to_cust_trx_line_id(+)   
     and rctla.customer_trx_line_id = conta_c_icmsst.link_to_cust_trx_line_id(+)   
     and rctla.customer_trx_line_id = conta_d_icmsst.link_to_cust_trx_line_id(+)   
     and rctla.customer_trx_line_id = conta_c_cofins.link_to_cust_trx_line_id(+)   
     and rctla.customer_trx_line_id = conta_d_cofins.link_to_cust_trx_line_id(+)   
     and rctla.customer_trx_line_id = conta_c_pis.link_to_cust_trx_line_id(+)   
     and rctla.customer_trx_line_id = conta_d_pis.link_to_cust_trx_line_id(+)   
     and rctla.customer_trx_line_id = conta_revenue.customer_trx_line_id (+)
     and rcta.customer_trx_id       = conta_receivable.customer_trx_id (+)
     --
     and rctla.customer_trx_line_id = vlicmsst.customer_trx_line_id(+) 
     and rctla.customer_trx_line_id = vlipi.customer_trx_line_id(+) 
     and rctla.customer_trx_line_id = vlpis.customer_trx_line_id(+) 
     and rctla.customer_trx_line_id = vlcofins.customer_trx_line_id(+)  
     and rctla.customer_trx_id      = xtnb.customer_trx_id(+)  
     and rctla.customer_trx_line_id = xtnb.customer_trx_line_id(+)  
     and rctla.customer_trx_id      = zldf.trx_id (+)  
     and rctla.customer_trx_line_id = zldf.trx_line_id (+)  
     and rcta.org_id                = ood.operating_unit
     and mp.organization_id         = ood.organization_id  
     and mp.Organization_Id         = Hrl.Inventory_Organization_Id
     --
     and hp.party_id                      = nvl(69821,hp.party_id)
     and nvl(wcsm.freight_code,'x')       = nvl(NULL,nvl(wcsm.freight_code,'x'))
     and nvl(ooha.sales_channel_code,'x') = nvl('AUT',nvl(ooha.sales_channel_code,'x'))
     and rctta.description                = nvl(NULL,rctta.description)
     and nvl(rbsa.global_attribute3,'X')  = nvl(NULL,nvl(rbsa.global_attribute3,'X'))
     and ood.organization_id              = nvl(89,ood.organization_id)
     and rcta.trx_number                 >= nvl(NULL,rcta.trx_number)
     and rcta.trx_number                 <= nvl(NULL,rcta.trx_number)
     and rcta.trx_date                   >= to_date('26/01/2023','dd/mm/yyyy')--nvl(:p_data_nf_de,rcta.trx_date)
     and rcta.trx_date                   <= to_date('27/01/2023','dd/mm/yyyy')--nvl(:p_data_nf_ate,rcta.trx_date)
   --
   and 'A' <> 'S'
     --
   order by trunc(rcta.trx_date), to_number(rcta.trx_number)||' - '||rbsa.global_attribute3;
