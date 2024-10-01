     SELECT (SELECT user_name
               FROM apps.fnd_user
              WHERE user_id = reo.last_updated_by)
               usuario,
            reo.last_updated_by,
            reo.organization_id,
            rit.invoice_type_code,
            rit.invoice_type_id,
            reo.creation_date                     hr_inicio_ri,
            reo.last_update_date                  hr_termino_ri,
            reo.status                            Status_RI,
            hl.location_code                      Estabelecimento,
            reo.operation_id                      RI,
            (SELECT a.operation_id
               FROM apps.cll_f189_invoices a, apps.cll_f189_entry_operations b
              WHERE     a.invoice_parent_id = ri.invoice_id
                    AND a.organization_id = ri.organization_id
                    AND a.invoice_parent_id = a.invoice_id
                    AND a.organization_id = b.organization_id
                    AND b.reversion_flag = 'R')
               RI_Reversao,
            rfea.DOCUMENT_NUMBER                  CPF_CNPJ,
            NVL (pv.vendor_name, rcv.customer_name) Fornecedor,
            rfea.IE,
            DECODE (
               rfea.entity_type_lookup_code,
               'VENDOR_SITE',    pvsa.address_line1
                              || ' - '
                              || pvsa.address_line2
                              || ' - '
                              || pvsa.address_line4,
               'CUSTOMER_SITE',    hzl.address1
                                || ' - '
                                || hzl.address2
                                || ' - '
                                || hzl.address4)
               ENDERECO,
            NVL (pvsa.state, hzl.state)           UF_Fornecedor,
            reo.receive_date                      Data_Entrada_NF,
            ri.invoice_date                       Data_Emissao_NF,
            ri.invoice_num                        nota_fiscal,
            (SELECT cfo_code
               FROM apps.cll_f189_fiscal_operations
              WHERE cfo_id = ril.cfo_id)
               cfop,
            rit.invoice_type_code                 tipo_nf,
            (SELECT utilization_code
               FROM apps.cll_f189_item_utilizations
              WHERE utilization_id = ril.utilization_id)
               utilizacao,
            (SELECT meaning
               FROM apps.fnd_lookup_values_vl
              WHERE     lookup_type = 'CLL_F189_INVOICE_SERIES'
                    AND lookup_code = ri.series)
               serie,
            ri.INVOICE_AMOUNT                     vlr_liquido_nf,
            ri.gross_total_amount                 vlr_bruto_nf,
            ri.first_payment_date                 dt_pagamento,
            ri.invoice_weight                     peso_bruto,
            ri.attribute2                         peso_liquido,
            msi.segment1                          produto,
            ril.invoice_line_id                   invoice_line_id,
            CASE
               WHEN pvsa.state = 'EX' AND NVL (ril.icms_base, 0) > 0
               THEN
                  ril.icms_base
               ELSE
                  ril.total_amount
            END
               vlr_total,
            ril.cost_freight                      vlr_custo_frete,
            ril.uom                               unidade_medida,
            (SELECT classification_code
               FROM apps.cll_f189_fiscal_class
              WHERE classification_id = ril.classification_id)
               ncm,
            ril.unit_price                        valor_unitario,
            DECODE (reo.FREIGHT_FLAG,  'C', 'CIF',  'F', 'FOB',  'Sem Frete')
               Frete,
            ri.attribute6                         RI_Referencia,
            (SELECT document_number
               FROM apps.cll_f189_fiscal_entities_all
              WHERE entity_id = cff.entity_id)
               CNPJ_Transportador,
            (SELECT aps.vendor_name
               FROM apps.cll_f189_fiscal_entities_all cffe,
                    apps.ap_supplier_sites_all      ass,
                    apps.ap_suppliers               aps
              WHERE     cffe.entity_id = cff.entity_id
                    AND cffe.vendor_site_id = ass.vendor_site_id(+)
                    AND aps.vendor_id = ass.vendor_id)
               Nome_Tranportadora,
            (SELECT jrre.source_name
               FROM apps.jtf_rs_salesreps jrs, apps.jtf_rs_resource_extns jrre
              WHERE     jrs.resource_id = jrre.resource_id
                    AND jrs.salesrep_id = ool.salesrep_id)
               representante,
            cff.invoice_amount                    vlr_frete,
            cff.invoice_num                       nf_frete,
            ril.icms_base                         bs_icms,
            ril.icms_tax                          alq_icms,
            ril.icms_amount                       vlr_icms,
            ril.icms_amount_recover               vlr_icms_recuperacao,
            ril.deferred_icms_amount              vlr_icms_diferido,
            DECODE (ril.icms_tax_code,
                    1, '1 - Com Credito',
                    2, '2 - Isento',
                    3, '3 - Outros')
               codigo_icms,
            ril.Tributary_Status_Code             cst_icms,
            (SELECT 'ICMS: ' || kfv.concatenated_segments
               FROM apps.cll_f189_distributions_v    a,
                    apps.gl_code_combinations_kfv kfv
              WHERE     a.code_combination_id = kfv.code_combination_id
                    AND invoice_id = ri.invoice_id
                    AND reference IN ('ICMS RECOVER INV', 'ICMS RECOVER FRT')
                    AND ROWNUM = 1)
               flex_contabil_icms,
            ril.icms_st_base                      Bs_Icms_ST,
            ril.icms_st_amount                    Vlr_Icms_ST,
            (SELECT 'ICMS ST: ' || kfv.concatenated_segments
               FROM apps.cll_f189_distributions_v    a,
                    apps.gl_code_combinations_kfv kfv
              WHERE     a.code_combination_id = kfv.code_combination_id
                    AND invoice_id = ri.invoice_id
                    AND reference LIKE 'ICMS%ST%'
                    AND ROWNUM = 1)
               Flex_Contabil_Icms_st,
            ril.ipi_base_amount                   Bs_Ipi,
            ril.ipi_tax                           Alq_Ipi,
            ril.ipi_amount_recover                Vlr_Ipi,
            DECODE (ril.ipi_tax_code,
                    1, '1 - Com Credito',
                    2, '2 - Isento',
                    3, '3 - Outros')
               codigo_ipi,
            ril.ipi_tributary_code                Cst_Ipi,
            (SELECT 'IPI: ' || kfv.concatenated_segments
               FROM apps.cll_f189_distributions_v    a,
                    apps.gl_code_combinations_kfv kfv
              WHERE     a.code_combination_id = kfv.code_combination_id
                    AND invoice_id = ri.invoice_id
                    AND reference = 'IPI TO RECOVER'
                    AND ROWNUM = 1)
               Flex_Contabil_Ipi                                            --
                                ,
            ril.pis_base_amount                   bs_pis,
            ril.pis_tax_rate                      alq_pis,
            ril.pis_amount                        vlr_pis,
            ril.pis_tributary_code                cst_pis,
            (SELECT 'PIS: ' || kfv.concatenated_segments
               FROM apps.cll_f189_distributions_v    a,
                    apps.gl_code_combinations_kfv kfv
              WHERE     a.code_combination_id = kfv.code_combination_id
                    AND invoice_id = ri.invoice_id
                    AND reference = 'PIS RECOVER NFF'
                    AND ROWNUM = 1)
               flex_contabil_pis,
            ril.cofins_base_amount                Bs_cofins,
            ril.cofins_tax_rate                   Alq_cofins,
            ril.cofins_amount                     Vlr_cofins,
            ril.cofins_tributary_code             Cst_cofins,
            (SELECT 'COFINS: ' || kfv.concatenated_segments
               FROM apps.cll_f189_distributions_v    a,
                    apps.gl_code_combinations_kfv kfv
              WHERE     a.code_combination_id = kfv.code_combination_id
                    AND invoice_id = ri.invoice_id
                    AND reference = 'COFINS RECOVER NFF'
                    AND ROWNUM = 1)
               Flex_Contabil_cofins,
            ri.ir_base                            bs_ir,
            ri.ir_tax                             alq_ir,
            ri.ir_amount                          vlr_ir,
            ri.ir_vendor                          ir_tipo_contribuicao,
            ri.ir_categ                           ir_categoria,
            ri.inss_base                          bs_inss,
            ri.inss_amount                        vlr_inss,
            ri.inss_tax                           alq_inss,
            (SELECT city_service_type_rel_code
               FROM apps.cll_f189_city_srv_type_rels
              WHERE city_service_type_rel_id = ri.dflt_city_service_type_rel_id)
               tipo_servico,
            (SELECT name
               FROM apps.AP_AWT_GROUPS
              WHERE GROUP_ID = ril.awt_group_id)
               grupo_ret_imposto,
            ril.iss_base_amount                   bs_iss,
            ril.iss_tax_amount                    vlr_iss,
            ril.iss_tax_rate                      alq_iss --,'!!!!!!' Dif_Aliquota
                                                         --
            ,
            (SELECT order_number
               FROM apps.oe_order_headers_all
              WHERE header_id = ool.header_id)
               RMA,
            (SELECT creation_date
               FROM apps.oe_order_headers_all
              WHERE header_id = ool.header_id)
               dt_RMA,
            ool.ordered_quantity * ool.unit_selling_price + ool.tax_value
               vlr_RMA,
            (SELECT h.trx_number
               FROM apps.ra_customer_trx_all     h,
                    apps.ra_customer_trx_lines_all l
              WHERE     h.customer_trx_id = l.customer_trx_id
                    AND l.interface_line_attribute6 = TO_CHAR (ool.line_id)
                    AND l.line_type = 'LINE'
                    AND h.interface_header_context = 'ORDER ENTRY'
                    AND ROWNUM = 1)
               aviso_credito,
            (SELECT h.creation_date
               FROM apps.ra_customer_trx_all     h,
                    apps.ra_customer_trx_lines_all l
              WHERE     h.customer_trx_id = l.customer_trx_id
                    AND l.interface_line_attribute6 = TO_CHAR (ool.line_id)
                    AND l.line_type = 'LINE'
                    AND h.interface_header_context = 'ORDER ENTRY'
                    AND ROWNUM = 1)
               dt_aviso_credito,
            (SELECT SUM (l.quantity_credited * l.unit_selling_price)
               FROM apps.ra_customer_trx_lines_all l
              WHERE     l.interface_line_attribute6 = TO_CHAR (ool.line_id)
                    AND l.line_type = 'LINE'
                    AND interface_line_context = 'ORDER ENTRY')
               vlr_aviso_credito,
            (SELECT h.trx_number
               FROM apps.ra_customer_trx_all     h,
                    apps.ra_customer_trx_lines_all l
              WHERE     h.customer_trx_id = l.customer_trx_id
                    AND l.customer_trx_line_id =
                           ool.reference_customer_trx_line_id
                    AND l.line_type = 'LINE'
                    AND h.interface_header_context = 'ORDER ENTRY'
                    AND ROWNUM = 1)
               NF_Origem,
            (SELECT h.creation_date
               FROM apps.ra_customer_trx_all     h,
                    apps.ra_customer_trx_lines_all l
              WHERE     h.customer_trx_id = l.customer_trx_id
                    AND l.customer_trx_line_id =
                           ool.reference_customer_trx_line_id
                    AND l.line_type = 'LINE')
               dt_nf_origem,
            (SELECT l.sales_order
               FROM apps.ra_customer_trx_lines_all l
              WHERE     l.customer_trx_line_id =
                           ool.reference_customer_trx_line_id
                    AND l.line_type = 'LINE')
               Ordem_Venda,
            msi.global_attribute3                 Origem_Item,
            ri.eletronic_invoice_key,
            ril.quantity                          qtde,
            ri.attribute4
               Descricao_Embalagem_Transporte,
            ri.attribute5                         Origem_do_Frete,
            (SELECT meaning
               FROM apps.fnd_lookup_values_vl
              WHERE     lookup_type = 'CLL_F189_FISCAL_DOCUMENT_MODEL'
                    AND lookup_code = ri.fiscal_document_model)
               Especie,
            ri.INCOME_CODE                        codigo_pagamento,
            ril.freight_internacional             frete_internacional,
            ril.importation_tax_amount            imposto_importacao,
            ril.fob_amount                        valor_fob,
            ril.importation_insurance_amount      valor_seguro,
            ril.pis_amount_recover                valor_pis_recuperacao,
            ril.cofins_amount_recover             valor_cofins_recuperacao,
            ril.importation_pis_cofins_base       base_importacao_pis_cofins,
            ril.importation_pis_amount            pis_importacao,
            ril.importation_cofins_amount         cofins_importacao,
            ril.import_other_val_included_icms    outras_desp_inc_base_icms,
            ril.import_other_val_not_icms
               outras_desp_not_inc_base_icms,
            ri.attribute3                         processo_import
       --
       FROM apps.cll_f189_entry_operations  reo,
            apps.cll_f189_invoices          ri,
            apps.cll_f189_invoice_types     rit,
            apps.cll_f189_fiscal_entities_all rfea,
            apps.ap_supplier_sites_all      pvsa,
            apps.ap_suppliers               pv,
            apps.cll_f189_invoice_lines     ril,
            apps.mtl_system_items_b         msi,
            apps.hr_locations               hl,
            apps.cll_f189_customers_v       rcv,
            apps.hz_cust_acct_sites_all     hcas,
            apps.hz_party_sites             hps,
            apps.hz_locations               hzl,
            apps.cll_f189_freight_invoices  cff,
            apps.oe_order_lines_all         ool
      WHERE     ri.organization_id = reo.organization_id
            AND ri.operation_id = reo.operation_id
            AND rit.invoice_type_id = ri.invoice_type_id
            AND rfea.entity_id(+) = ri.entity_id
            AND pvsa.vendor_site_id(+) = rfea.vendor_site_id
            AND pv.vendor_id(+) = pvsa.vendor_id
            AND ril.invoice_id(+) = ri.invoice_id
            AND msi.inventory_item_id(+) = ril.item_id
            AND msi.organization_id(+) = ril.organization_id
            AND hl.location_id(+) = reo.location_id
            AND rcv.entity_id(+) = ri.entity_id
            AND cff.operation_id(+) = reo.operation_id
            AND cff.organization_id(+) = reo.organization_id
            AND rfea.cust_acct_site_id = hcas.cust_acct_site_id(+)
            AND hcas.party_site_id = hps.party_site_id(+)
            AND hps.location_id = hzl.location_id(+)
            AND rfea.vendor_site_id = pvsa.vendor_site_id(+)
            AND ool.line_id(+) = ril.rma_interface_id
            AND trunc(reo.receive_date) >= trunc(to_date('01-feb-2020'))
            AND reo.receive_date        <= trunc(to_date('29-feb-2020'))
            AND rit.invoice_type_code LIKE 'E_FRETE IMP%'; 
   
SELECT * from CLL_F189_INVOICE_PARENTS;   