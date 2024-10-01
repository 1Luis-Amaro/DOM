SELECT DISTINCT                                                                      
       hca.cust_account_id,                                                          --1       
       hp.party_name cliente,                                                        --2                                                        
       hca.status "STATUS DA CONTA",                                                 --3
       hcasa.status "STATUS ENDERECO",                                               --3.1
       hcasa.creation_date "DATA CRIACAO",                                           --3.2
       hcasa.last_update_date "DATA ATUALIZACAO",                                    --3.3
       SUBSTR (hcsua.location, 1, INSTR (hcsua.location, '_', 1) - 1) cnpj,          --4       
       a.credit_checking "CREDIT CHECKING",                                          --5 (ADD - AGO/2016)
       hp.party_id "PARTY ID",                                                       --6 (ADD - AGO/2016)
       hca.account_number "ACCOUNT NUMBER",                                          --7 (ADD - AGO/2016)
       (SELECT B.overall_credit_limit
          FROM APPS.HZ_CUSTOMER_PROFILES A,
               APPS.HZ_CUST_PROFILE_AMTS B,
               APPS.HZ_PARTIES HP2
         WHERE     A.CUST_ACCOUNT_PROFILE_ID = B.CUST_ACCOUNT_PROFILE_ID
               AND HP2.PARTY_ID = A.PARTY_ID
               AND B.overall_credit_limit IS NOT NULL
               AND HP.PARTY_NAME = hp2.party_name) "LIM CRD ATUAL",                 --8 (ADD - SET/2016)           
       hps.PARTY_SITE_NUMBER "NUMERO DO LOCAL",                                 --9 (ADD - AGO/2016)
       BANCO.bank_account_num "NUM CONTA BC",                                          --10 (ADD - SET/2016)
       BANCO.CHECK_DIGITS "DIGITO VERIFICAO",                                     --11 (ADD - SET/2016)
       BANCO.branch_number AGENCIA,                                               --12 (ADD - SET/2016)
       (SELECT hzcp.email_address
          FROM apps.hz_contact_points hzcp
         WHERE     hps.party_site_id = hzcp.owner_table_id
               AND NVL (hzcp.primary_flag, 'Y') = 'Y'
               AND NVL (hzcp.contact_point_type, 'EMAIL') = 'EMAIL'
               AND NVL (hzcp.owner_table_name, 'HZ_PARTY_SITES') =
                      'HZ_PARTY_SITES'
               AND ROWNUM = 1) EMAIL,                                             --13 (ADD - AGO/2016)
       (SELECT hzcp2.attribute1
          FROM apps.hz_contact_points hzcp2
         WHERE     hps.party_site_id = hzcp2.owner_table_id
               AND NVL (hzcp2.primary_flag, 'Y') = 'Y'
               AND NVL (hzcp2.contact_point_type, 'EMAIL') = 'PHONE'
               AND NVL (hzcp2.owner_table_name, 'HZ_PARTY_SITES') =
                      'HZ_PARTY_SITES') CONTATO,                                  --14 (ADD - AGO/2016)
       (SELECT HCPF.PHONE_AREA_CODE || '-' || HCPF.PHONE_NUMBER FONE
          FROM APPS.HZ_CUST_SITE_USES_ALL HCSSA,
               APPS.HZ_CUST_ACCT_SITES_ALL HCASA,
               APPS.HZ_PARTY_SITES HPS,
               APPS.HZ_LOCATIONS HZL,
               APPS.HZ_PARTIES HP,
               APPS.HZ_CONTACT_POINTS HCPF
         WHERE     (1 = 1)
               AND HCSSA.SITE_USE_ID = HCSUA.SITE_USE_ID
               AND HCSSA.CUST_ACCT_SITE_ID = HCASA.CUST_ACCT_SITE_ID
               AND HCASA.PARTY_SITE_ID = HPS.PARTY_SITE_ID
               AND HPS.LOCATION_ID = HZL.LOCATION_ID
               AND HPS.PARTY_ID = HP.PARTY_ID
               AND HPS.PARTY_SITE_ID = HCPF.OWNER_TABLE_ID(+)
               AND OWNER_TABLE_NAME = 'HZ_PARTY_SITES'
               AND HCPF.CONTACT_POINT_TYPE(+) = 'PHONE'
               AND HCPF.PRIMARY_FLAG = 'Y'
               AND ROWNUM = 1) TELEFONE,                                           --15 (ADD - AGO/2016)
       (SELECT acol.name
          FROM apps.hz_customer_profiles hprof, apps.ar_collectors acol
         WHERE     hca.cust_account_id = hprof.cust_account_id
               AND hprof.collector_id = acol.collector_id
               AND ROWNUM = 1) COBRADOR,                                           --16 (ADD - AGO/2016)
       HCASA.ATTRIBUTE2 "CODIGO CNAE",                                               --17 (ADD - AGO/2016)
       NVL (
          (SELECT HP2.PARTY_NAME
             FROM apps.hz_cust_acct_relate_all hzcar,
                  apps.hz_cust_accounts hcaa,
                  APPS.hz_parties HP2
            WHERE     hzcar.cust_account_id = hca.cust_account_id
                  AND hcaa.party_id = HP2.party_id
                  AND hcaa.cust_account_id = hzcar.RELATED_CUST_ACCOUNT_ID
                  AND ROWNUM = 1),
          '') COLIGADAS,                                                           --18 (ADD - AGO/2016)
       REC.name METODO,                                                            --19 (ADD - AGO/2016)
       nvl(CUST_REC.primary_flag,'N') "PRIMARY METODO",                              --20 (ADD - AGO/2016)
       (SELECT    gl.segment1
               || '-'
               || gl.segment2
               || '-'
               || gl.segment3
               || '-'
               || gl.segment4
               || '-'
               || gl.segment5
               || '-'
               || gl.segment6
               || '-'
               || gl.segment7 
          FROM apps.gl_code_combinations gl
         WHERE     hcsua.site_use_code = 'BILL_TO'
               AND hcsua.GL_ID_REC = gl.code_combination_id
               AND ROWNUM = 1) "GL ACCOUNT",                                          --21 (ADD - AGO/2016)
       (SELECT    gl.segment1
               || '-'
               || gl.segment2
               || '-'
               || gl.segment3
               || '-'
               || gl.segment4
               || '-'
               || gl.segment5
               || '-'
               || gl.segment6
               || '-'
               || gl.segment7 
          FROM apps.hz_cust_site_uses_all hcsua2,
               apps.gl_code_combinations gl
         WHERE     hcsua.site_use_code = 'BILL_TO'
               AND hcsua.GL_ID_REV = gl.code_combination_id
               AND ROWNUM = 1) "GL RECEITA",                                          --22 (ADD - AGO/2016)
       (SELECT    gl.segment1
               || '-'
               || gl.segment2
               || '-'
               || gl.segment3
               || '-'
               || gl.segment4
               || '-'
               || gl.segment5
               || '-'
               || gl.segment6 
               || '-'
               || gl.segment7
          FROM apps.hz_cust_site_uses_all hcsua2,
               apps.gl_code_combinations gl
         WHERE     hcsua.site_use_code = 'BILL_TO'
               AND hcsua.GL_ID_TAX = gl.code_combination_id
               AND ROWNUM = 1) "GL IMPOSTO",                                          --23 (ADD - AGO/2016)
       (SELECT hprof.global_attribute2
          FROM apps.hz_customer_profiles hprof
         WHERE hca.cust_account_id = hprof.cust_account_id AND ROWNUM = 1)
          "INSTRUÇAO JUROS",                                                      --24 (ADD - AGO/2016)
       (SELECT hprof.global_attribute1
          FROM apps.hz_customer_profiles hprof
         WHERE hca.cust_account_id = hprof.cust_account_id AND ROWNUM = 1)
          "INSTRUÇAO PROTESTO",                                                   --25 (ADD - AGO/2016)
       a.credit_hold,                                                                 --26 
       hcasa.cust_acct_site_id,                                                       --27
       hcasa.party_site_id,                                                           --28
       hcasa.orig_system_reference,                                                   --29
       hcsua.site_use_id,                                                             --30
       hcsua.ship_via,                                                                --31
       hcsua.attribute4,                                                              --32
       hcsua.attribute7,                                                              --33
       hcsua.warehouse_id,                                                            --34
       hcsua.site_use_code,                                                           --35
       hl.city cidade,                                                                --36
       hl.state estado,                                                               --37
       hl.address4 bairro,                                                            --38
       (SELECT name
          FROM apps.ra_terms_tl
         WHERE term_id = hcsua.payment_term_id AND language = 'PTB')
          "CONDICAO PAGAMENTO",                                                       --39                             
       (SELECT description
          FROM apps.ra_terms_tl
         WHERE term_id = hcsua.payment_term_id AND language = 'PTB')
          "DESCRICAO COND PAGAMENTO",                                                 --40
       (SELECT DISTINCT ship_method_code_meaning
          FROM apps.wsh_carrier_ship_methods_v
         WHERE ship_method_code = hcsua.ship_via)
          "METODO ENTREGA",                                                           --41
       (SELECT name
          FROM apps.oe_transaction_types_tl
         WHERE transaction_type_id = hcsua.order_type_id AND language = 'PTB')
          "TIPO ORDEM",                                                               --42
       (SELECT name
          FROM apps.qp_list_headers_all
         WHERE list_header_id = hcsua.price_list_id)
          "LISTA PRECO",                                                              --43
       hcsua.freight_term tipo_frete,
       (SELECT salesrep_number
          FROM apps.jtf_rs_salesreps
         WHERE salesrep_id = hcsua.primary_salesrep_id)
          VENDEDOR,                                                                 --44
       demand_class_code classe_demanda,
       (SELECT organization_code
          FROM apps.mtl_parameters
         WHERE organization_id = hcsua.warehouse_id)
          DEPOSITO,                                                                 --45
       hp.attribute1 "PERFIL PORTE",                                                  --46
       hp.attribute2 "GRUPO CLIENTE",                                                 --47
       hp.attribute3 "RAMO ATIVIDADE",                                                --48
       hp.attribute4 "GRUPO PBC",                                                     --49
       hp.attribute6 CONTRATO,                                                      --50
       SUBSTR (hp.attribute7, 1, 10) "DATA INICIO CONTRATO",                          --51
       hcsua.attribute1 "CANAL VENDAS",                                               --52
       hps.attribute10 "ISENTO CAS",                                                  --53
       hps.attribute1 "CAS 1",                                                        --54
       hps.attribute2 "CAS 2",                                                        --55
       hps.attribute3 "CAS 3",                                                        --56
       hps.attribute4 "CAS 4",                                                        --57
       hps.attribute5 "CAS 5",                                                        --58
       hps.attribute6 "CAS 6",                                                        --59
       hps.attribute7 "CAS 7",                                                        --60
       hps.attribute8 "ASSINATURA CAS",                                               --61
       hps.attribute9 "VALIDADE CAS",                                                 --62
       hps.attribute11 "AREA METROP",                                                 --63
       hps.attribute12 "MICRO IBGE",                                                  --64
       hps.attribute13 "MACRO IBGE",                                                  --65
       hps.attribute14 "REGIAO GEOGRAFICA",                                           --66
       hps.attribute15 "GRUPO COMPRAS",                                               --67
       hps.attribute16 "SUB RAMO ATIV",                                               --68
       hps.attribute17 "REGIAO DEMANDA",                                              --69
       hps.attribute18 "GRUPO PBC1",                                                  --70
       hps.attribute19 REDE,                                                        --71
       hcsua.attribute2 "DATA 1RO FATURAMENTO",                                       --72
       hcsua.attribute3 "PERCENT COMISSAO",                                           --73
       hcsua.attribute4 "LOCAL END TERCEIRO",                                         --74
       SUBSTR (hcsua.attribute6, 1, 10) "DATA IMPLANTACAO",                           --75
       hcsua.attribute7 "PRIORIDADE ENTREGA",                                         --76
       hcsua.attribute8 "VALOR MINIMO FAT",                                           --77
       hcsua.attribute9 "VOL ULTIMO TRIMESTRE",                                       --78
       hcsua.attribute10 "VOL PENULTIMO TRIMESTRE",                                   --79                      
       hcsua.attribute11 "VOL DATA VIGENCIA",                                         --80
       hcsua.attribute12 "VOL MIX PRODUTOS",                                          --81
       hcasa.global_attribute1 "NOME EMPRESA",                                        --82
       hcasa.global_attribute2 "TIPO INSCRICAO",                                      --83
       hcasa.global_attribute3 "NÚMERO INSCRICAO",                                    --84
       hcasa.global_attribute4 "AGÊNCIA INSCRICAO",                                   --85
       hcasa.global_attribute5 "DIGITO INSCRICAO",                                    --86
       hcasa.global_attribute6 "INSCRICAO ESTADUAL",                                  --87
       hcasa.global_attribute7 "INSCRICAO MUNICIPAL",                                 --88
       hcasa.global_attribute8 "CLASSE CONTRIBUINTE",                                 --89
       hcasa.global_attribute9 "USAR PERFIL LOCAL CLIENTE",                           --90
       hcasa.global_attribute10 "NUMERO INSCR SUFRAMA",                               --91
       hcasa.global_attribute11 "INDICADOR NATUREZA RET IMPOSTO",                     --92
       hcasa.global_attribute12 "SUJEITO CFOP ZONA FRANCA",                           --93
       hca.customer_class_code                                                        --94
  FROM apps.hz_parties hp,
       apps.hz_cust_accounts hca,
       apps.hz_cust_site_uses_all hcsua,
       apps.hz_cust_acct_sites_all hcasa,
       apps.hz_party_sites hps,
       apps.hz_locations hl,
       apps.hz_customer_profiles a,
       APPS.AR_RECEIPT_METHODS REC,
       apps.ra_cust_receipt_methods CUST_REC
       ,
       (
SELECT ie.acct_site_use_id,
       eb.bank_account_num,
       eb.CHECK_DIGITS,
       cbb.branch_number
  FROM apps.iby_external_payers_all ie,
       apps.iby_pmt_instr_uses_all ip,
       apps.iby_ext_bank_accounts eb,
       apps.CE_BANK_BRANCHES_V cbb
 WHERE     ie.ext_payer_id = ip.ext_pmt_party_id
       AND ip.instrument_id = eb.ext_bank_account_id
       AND EB.branch_id = cbb.branch_party_id
       ) BANCO
--       
 WHERE     HCSUA.CUST_ACCT_SITE_ID = HCASA.CUST_ACCT_SITE_ID
       AND HCA.CUST_ACCOUNT_ID = A.CUST_ACCOUNT_ID
       AND HCASA.PARTY_SITE_ID = HPS.PARTY_SITE_ID
       AND HPS.PARTY_ID = HP.PARTY_ID
       AND HP.PARTY_ID = HCA.PARTY_ID
       AND HPS.LOCATION_ID = HL.LOCATION_ID
       AND HP.PARTY_ID = A.PARTY_ID
       AND hcsua.site_use_code = 'BILL_TO'     
       AND TRUNC (NVL (CUST_REC.END_DATE, SYSDATE)) >= TRUNC (SYSDATE)
       AND CUST_REC.customer_id = hca.cust_account_id
       AND CUST_REC.RECEIPT_METHOD_ID = REC.RECEIPT_METHOD_ID
       AND CUST_REC.SITE_USE_ID(+) = hcsua.SITE_USE_ID
       --
       AND hcsua.site_use_id = banco.acct_site_use_id (+)       
       --      
--       AND ie.ext_payer_id = ip.ext_pmt_party_id
--       AND ip.instrument_id = eb.ext_bank_account_id
--       AND EB.branch_id = cbb.branch_party_id
   --    AND hp.party_id = banco.party_id
      -- AND NVL(ie.ext_payer_id,0)  = ip.ext_pmt_party_id(+) 
    --   AND NVL(ip.instrument_id,0) = eb.ext_bank_account_id(+)
     --  AND NVL(EB.branch_id,0)     = cbb.branch_party_id(+)
       --AND CUST_REC.primary_flag = 'Y'
   --    AND NVL (CUST_REC.primary_flag, 'N') = 'Y' --AND CUST_REC.primary_flag = 'Y'
       AND (CASE WHEN (SELECT COUNT(*) 
                         FROM apps.ra_cust_receipt_methods 
                        WHERE site_use_id = hcsua.site_use_id 
                          AND primary_flag = 'Y') = 0 
                 THEN 
                      'Y' 
                 ELSE 
                       NVL (CUST_REC.primary_flag, 'N')
                 END ) = 'Y'
                  
-------------------------------------------------------------------------------------------------------------------------------------------
UNION
-------------------------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT                                                                      
       hca.cust_account_id,                                                          --1       
       hp.party_name cliente,                                                        --2                                                        
       hca.status "STATUS DA CONTA",                                                 --3
       hcasa.status "STATUS ENDERECO",                                               --3.1
       hcasa.creation_date "DATA CRIACAO",                                           --3.2
       hcasa.last_update_date "DATA ATUALIZACAO",                                    --3.3
       SUBSTR (hcsua.location, 1, INSTR (hcsua.location, '_', 1) - 1) cnpj,          --4       
       a.credit_checking "CREDIT_CHECKING",                                          --5 (ADD - AGO/2016)
       hp.party_id "PARTY_ID",                                                       --6 (ADD - AGO/2016)
       hca.account_number "ACCOUNT_NUMBER",                                          --7 (ADD - AGO/2016)
       (SELECT B.overall_credit_limit
          FROM APPS.HZ_CUSTOMER_PROFILES A,
               APPS.HZ_CUST_PROFILE_AMTS B,
               APPS.HZ_PARTIES HP2
         WHERE     A.CUST_ACCOUNT_PROFILE_ID = B.CUST_ACCOUNT_PROFILE_ID
               AND HP2.PARTY_ID = A.PARTY_ID
               AND B.overall_credit_limit IS NOT NULL
               AND HP.PARTY_NAME = hp2.party_name) "LIM CRD ATUAL",                 --8 (ADD - SET/2016)           
       hps.PARTY_SITE_NUMBER "NUMERO DO LOCAL",                                 --9 (ADD - AGO/2016)
       '',                   --"NUM CONTA",                                          --10 (ADD - SET/2016)
       '',              -- "DIGITO VERIFICAÇÃO",                                     --11 (ADD - SET/2016)
       '',                --AGENCIA,                                               --12 (ADD - SET/2016)
       (SELECT hzcp.email_address
          FROM apps.hz_contact_points hzcp
         WHERE     hps.party_site_id = hzcp.owner_table_id
               AND NVL (hzcp.primary_flag, 'Y') = 'Y'
               AND NVL (hzcp.contact_point_type, 'EMAIL') = 'EMAIL'
               AND NVL (hzcp.owner_table_name, 'HZ_PARTY_SITES') =
                      'HZ_PARTY_SITES'
               AND ROWNUM = 1) EMAIL,                                             --13 (ADD - AGO/2016)
       (SELECT hzcp2.attribute1
          FROM apps.hz_contact_points hzcp2
         WHERE     hps.party_site_id = hzcp2.owner_table_id
               AND NVL (hzcp2.primary_flag, 'Y') = 'Y'
               AND NVL (hzcp2.contact_point_type, 'EMAIL') = 'PHONE'
               AND NVL (hzcp2.owner_table_name, 'HZ_PARTY_SITES') =
                      'HZ_PARTY_SITES') CONTATO,                                  --14 (ADD - AGO/2016)
       (SELECT HCPF.PHONE_AREA_CODE || '-' || HCPF.PHONE_NUMBER FONE
          FROM APPS.HZ_CUST_SITE_USES_ALL HCSSA,
               APPS.HZ_CUST_ACCT_SITES_ALL HCASA,
               APPS.HZ_PARTY_SITES HPS,
               APPS.HZ_LOCATIONS HZL,
               APPS.HZ_PARTIES HP,
               APPS.HZ_CONTACT_POINTS HCPF
         WHERE     (1 = 1)
               AND HCSSA.SITE_USE_ID = HCSUA.SITE_USE_ID
               AND HCSSA.CUST_ACCT_SITE_ID = HCASA.CUST_ACCT_SITE_ID
               AND HCASA.PARTY_SITE_ID = HPS.PARTY_SITE_ID
               AND HPS.LOCATION_ID = HZL.LOCATION_ID
               AND HPS.PARTY_ID = HP.PARTY_ID
               AND HPS.PARTY_SITE_ID = HCPF.OWNER_TABLE_ID(+)
               AND OWNER_TABLE_NAME = 'HZ_PARTY_SITES'
               AND HCPF.CONTACT_POINT_TYPE(+) = 'PHONE'
               AND HCPF.PRIMARY_FLAG = 'Y'
               AND ROWNUM = 1) TELEFONE,                                           --15 (ADD - AGO/2016)
       (SELECT acol.name
          FROM apps.hz_customer_profiles hprof, apps.ar_collectors acol
         WHERE     hca.cust_account_id = hprof.cust_account_id
               AND hprof.collector_id = acol.collector_id
               AND ROWNUM = 1) COBRADOR,                                           --16 (ADD - AGO/2016)
       HCASA.ATTRIBUTE2 "CODIGO CNAE",                                               --17 (ADD - AGO/2016)
       NVL (
          (SELECT HP2.PARTY_NAME
             FROM apps.hz_cust_acct_relate_all hzcar,
                  apps.hz_cust_accounts hcaa,
                  APPS.hz_parties HP2
            WHERE     hzcar.cust_account_id = hca.cust_account_id
                  AND hcaa.party_id = HP2.party_id
                  AND hcaa.cust_account_id = hzcar.RELATED_CUST_ACCOUNT_ID
                  AND ROWNUM = 1),
          '') COLIGADAS,                                                           --18 (ADD - AGO/2016)
       '', -- REC.name METODO,                                                      --19 (ADD - AGO/2016)
       '' ,                         -- "PRIMARY METODO",                              --20 (ADD - AGO/2016)
       '',                  -- "GL ACCOUNT",                                          --21 (ADD - AGO/2016)
       '',                  -- "GL RECEITA",                                          --22 (ADD - AGO/2016)
       '',                  -- "GL IMPOSTO",                                          --23 (ADD - AGO/2016)
       (SELECT hprof.global_attribute2
          FROM apps.hz_customer_profiles hprof
         WHERE hca.cust_account_id = hprof.cust_account_id AND ROWNUM = 1)
          "INSTRUÇAO JUROS",                                                      --24 (ADD - AGO/2016)
       (SELECT hprof.global_attribute1
          FROM apps.hz_customer_profiles hprof
         WHERE hca.cust_account_id = hprof.cust_account_id AND ROWNUM = 1)
          "INSTRUÇAO PROTESTO",                                                   --25 (ADD - AGO/2016)
       a.credit_hold,                                                                 --26 
       hcasa.cust_acct_site_id,                                                       --27
       hcasa.party_site_id,                                                           --28
       hcasa.orig_system_reference,                                                   --29
       hcsua.site_use_id,                                                             --30
       hcsua.ship_via,                                                                --31
       hcsua.attribute4,                                                              --32
       hcsua.attribute7,                                                              --33
       hcsua.warehouse_id,                                                            --34
       hcsua.site_use_code,                                                           --35
       hl.city cidade,                                                                --36
       hl.state estado,                                                               --37
       hl.address4 bairro,                                                            --38
       (SELECT name
          FROM apps.ra_terms_tl
         WHERE term_id = hcsua.payment_term_id AND language = 'PTB')
          "CONDICAO PAGAMENTO",                                                       --39                             
       (SELECT description
          FROM apps.ra_terms_tl
         WHERE term_id = hcsua.payment_term_id AND language = 'PTB')
          "DESCRICAO COND PAGAMENTO",                                                 --40
       (SELECT DISTINCT ship_method_code_meaning
          FROM apps.wsh_carrier_ship_methods_v
         WHERE ship_method_code = hcsua.ship_via)
          "METODO ENTREGA",                                                           --41
       (SELECT name
          FROM apps.oe_transaction_types_tl
         WHERE transaction_type_id = hcsua.order_type_id AND language = 'PTB')
          "TIPO ORDEM",                                                               --42
       (SELECT name
          FROM apps.qp_list_headers_all
         WHERE list_header_id = hcsua.price_list_id)
          "LISTA PRECO",                                                              --43
       hcsua.freight_term tipo_frete,
       (SELECT salesrep_number
          FROM apps.jtf_rs_salesreps
         WHERE salesrep_id = hcsua.primary_salesrep_id)
          VENDEDOR,                                                                 --44
       demand_class_code classe_demanda,
       (SELECT organization_code
          FROM apps.mtl_parameters
         WHERE organization_id = hcsua.warehouse_id)
          DEPOSITO,                                                                 --45
       hp.attribute1 "PERFIL PORTE",                                                  --46
       hp.attribute2 "GRUPO CLIENTE",                                                 --47
       hp.attribute3 "RAMO ATIVIDADE",                                                --48
       hp.attribute4 "GRUPO PBC",                                                     --49
       hp.attribute6 CONTRATO,                                                      --50
       SUBSTR (hp.attribute7, 1, 10) "DATA INICIO CONTRATO",                          --51
       hcsua.attribute1 "CANAL VENDAS",                                               --52
       hps.attribute10 "ISENTO CAS",                                                  --53
       hps.attribute1 "CAS 1",                                                        --54
       hps.attribute2 "CAS 2",                                                        --55
       hps.attribute3 "CAS 3",                                                        --56
       hps.attribute4 "CAS 4",                                                        --57
       hps.attribute5 "CAS 5",                                                        --58
       hps.attribute6 "CAS 6",                                                        --59
       hps.attribute7 "CAS 7",                                                        --60
       hps.attribute8 "ASSINATURA CAS",                                               --61
       hps.attribute9 "VALIDADE CAS",                                                 --62
       hps.attribute11 "AREA METROP",                                                 --63
       hps.attribute12 "MICRO IBGE",                                                  --64
       hps.attribute13 "MACRO IBGE",                                                  --65
       hps.attribute14 "REGIAO GEOGRAFICA",                                           --66
       hps.attribute15 "GRUPO COMPRAS",                                               --67
       hps.attribute16 "SUB RAMO ATIV",                                               --68
       hps.attribute17 "REGIAO DEMANDA",                                              --69
       hps.attribute18 "GRUPO PBC1",                                                  --70
       hps.attribute19 REDE,                                                        --71
       hcsua.attribute2 "DATA 1RO FATURAMENTO",                                       --72
       hcsua.attribute3 "PERCENT COMISSAO",                                           --73
       hcsua.attribute4 "LOCAL END TERCEIRO",                                         --74
       SUBSTR (hcsua.attribute6, 1, 10) "DATA IMPLANTACAO",                           --75
       hcsua.attribute7 "PRIORIDADE ENTREGA",                                         --76
       hcsua.attribute8 "VALOR MINIMO FAT",                                           --77
       hcsua.attribute9 "VOL ULTIMO TRIMESTRE",                                       --78
       hcsua.attribute10 "VOL PENULTIMO TRIMESTRE",                                   --79                      
       hcsua.attribute11 "VOL DATA VIGENCIA",                                         --80
       hcsua.attribute12 "VOL MIX PRODUTOS",                                          --81
       hcasa.global_attribute1 "NOME EMPRESA",                                        --82
       hcasa.global_attribute2 "TIPO INSCRICAO",                                      --83
       hcasa.global_attribute3 "NÚMERO INSCRICAO",                                    --84
       hcasa.global_attribute4 "AGÊNCIA INSCRICAO",                                   --85
       hcasa.global_attribute5 "DIGITO INSCRICAO",                                    --86
       hcasa.global_attribute6 "INSCRICAO ESTADUAL",                                  --87
       hcasa.global_attribute7 "INSCRICAO MUNICIPAL",                                 --88
       hcasa.global_attribute8 "CLASSE CONTRIBUINTE",                                 --89
       hcasa.global_attribute9 "USAR PERFIL LOCAL CLIENTE",                           --90
       hcasa.global_attribute10 "NUMERO INSCR SUFRAMA",                               --91
       hcasa.global_attribute11 "INDICADOR NATUREZA RET IMPOSTO",                     --92
       hcasa.global_attribute12 "SUJEITO CFOP ZONA FRANCA",                           --93
       hca.customer_class_code                                                        --94
  FROM apps.hz_parties hp,
       apps.hz_cust_accounts hca,
       apps.hz_cust_site_uses_all hcsua,
       apps.hz_cust_acct_sites_all hcasa,
       apps.hz_party_sites hps,
       apps.hz_locations hl,
       apps.hz_customer_profiles a--,
--       APPS.AR_RECEIPT_METHODS REC,
--       apps.ra_cust_receipt_methods CUST_REC    
 WHERE     HCSUA.CUST_ACCT_SITE_ID = HCASA.CUST_ACCT_SITE_ID
       AND HCA.CUST_ACCOUNT_ID = A.CUST_ACCOUNT_ID
       AND HCASA.PARTY_SITE_ID = HPS.PARTY_SITE_ID
       AND HPS.PARTY_ID = HP.PARTY_ID
       AND HP.PARTY_ID = HCA.PARTY_ID
       AND HPS.LOCATION_ID = HL.LOCATION_ID
       AND HP.PARTY_ID = A.PARTY_ID
       AND hcsua.site_use_code = 'SHIP_TO'