/* Formatted on 29/7/2015 15:36:46 (QP5 v5.267.14150.38573) */
SELECT hca.cust_account_id,
       hcasa.cust_acct_site_id,
       hcasa.party_site_id,
       hcasa.orig_system_reference,
       hcsua.site_use_id,
       hcsua.ship_via,
       hcsua.attribute4,
       hcsua.attribute7,
       hcsua.warehouse_id,
       hp.party_name cliente,
       SUBSTR (hcsua.location, 1, INSTR (hcsua.location, '_', 1) - 1) cnpj,
       hcsua.site_use_code,
       hl.address1||' '||hl.address2||' '||hl.address3||' '||hl.address4 endereco,       
       hl.postal_code,
       hl.city cidade,
       hl.state estado,
              (SELECT name
          FROM apps.ra_terms_tl
         WHERE term_id = hcsua.payment_term_id AND language = 'PTB')
          condicao_pagamento,
       (SELECT description
          FROM apps.ra_terms_tl
         WHERE term_id = hcsua.payment_term_id AND language = 'PTB')
          descricao_cond_pagamento,
       (SELECT DISTINCT ship_method_code_meaning
          FROM apps.wsh_carrier_ship_methods_v
         WHERE ship_method_code = hcsua.ship_via)
          metodo_entrega,
       (SELECT name
          FROM apps.oe_transaction_types_tl
         WHERE transaction_type_id = hcsua.order_type_id AND language = 'PTB')
          tipo_ordem,
       (SELECT name
          FROM apps.qp_list_headers_all
         WHERE list_header_id = hcsua.price_list_id)
          lista_preco,
       hcsua.freight_term tipo_frete,
       (SELECT salesrep_number
          FROM apps.jtf_rs_salesreps
         WHERE salesrep_id = hcsua.primary_salesrep_id)
          vendedor,
       demand_class_code classe_demanda,
       (SELECT organization_code
          FROM apps.mtl_parameters
         WHERE organization_id = hcsua.warehouse_id)
          deposito,
       hp.attribute1 perfil_porte,
       hp.attribute2 grupo_cliente,
       hp.attribute3 ramo_atividade,
       hp.attribute4 grupo_pbc,
       hp.attribute6 contrato,
       SUBSTR (hp.attribute7, 1, 10) data_inicio_contrato,
       hcsua.attribute1 canal_vendas,
       hps.attribute10 isento_cas,
       hps.attribute1 cas_1,
       hps.attribute2 cas_2,
       hps.attribute3 cas_3,
       hps.attribute4 cas_4,
       hps.attribute5 cas_5,
       hps.attribute6 cas_6,
       hps.attribute7 cas_7,
       hps.attribute8 assinatura_cas,
       hps.attribute9 validade_cas,
       hps.attribute11 area_metrop,
       hps.attribute12 micro_ibge,
       hps.attribute13 macro_ibge,
       hps.attribute14 regiao_geografica,
       hps.attribute15 grupo_compras,
       hps.attribute16 sub_ramo_ativ,
       hps.attribute17 regiao_demanda,
       hps.attribute18 grupo_pbc,
       hps.attribute19 rede,
       hcsua.attribute2 data_1ro_faturamento,
       hcsua.attribute3 percent_comissao,
       hcsua.attribute4 local_end_terceiro,
       SUBSTR (hcsua.attribute6, 1, 10) data_implantacao,
       hcsua.attribute7 prioridade_entrega,
       hcsua.attribute8 valor_minimo_fat,
       hcsua.attribute9 vol_ultimo_trimestre,
       hcsua.attribute10 vol_penultimo_trimestre,
       hcsua.attribute11 vol_data_vigencia,
       hcsua.attribute12 vol_mix_produtos,
       hcp.global_attribute1 remit_protest_instructions,
       hcp.global_attribute2 remit_interest_instructions,
       hcasa.global_attribute1 nome_empresa,
       hcasa.global_attribute2 tipo_inscrição,
       hcasa.global_attribute3 número_inscrição,
       hcasa.global_attribute4 agência_inscrição,
       hcasa.global_attribute5 dígito_inscrição,
       hcasa.global_attribute6 inscrição_estadual,
       hcasa.global_attribute7 inscrição_municipal,
       hcasa.global_attribute8 classe_contribuinte,
       hcasa.global_attribute9 usar_perfil_local_cliente,
       hcasa.global_attribute10 número_inscr_suframa,
       hcasa.global_attribute11 indicador_natureza_ret_imposto,
       hcasa.global_attribute12 sujeito_cfop_zona_franca
  FROM apps.hz_parties hp,
       apps.hz_cust_accounts hca,
       apps.hz_cust_site_uses_all hcsua,
       apps.hz_cust_acct_sites_all hcasa,
       apps.hz_party_sites hps,
       apps.hz_locations hl,
       apps.hz_customer_profiles hcp
 WHERE     hcsua.cust_acct_site_id = hcasa.cust_acct_site_id
       AND hcasa.party_site_id = hps.party_site_id
       AND hps.party_id = hp.party_id
       AND hp.party_id = hca.party_id
       AND hps.location_id = hl.location_id
       AND hca.cust_account_id = hcp.cust_account_id
       AND hcsua.site_use_code = 'SHIP_TO'
       --and hp.party_name like 'MR 7%'
;
