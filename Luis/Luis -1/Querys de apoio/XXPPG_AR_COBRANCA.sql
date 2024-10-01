SELECT DISTINCT 
         (SELECT flv.description
            FROM apps.RA_CUST_TRX_LINE_GL_DIST_ALL rctl,
                 apps.XLA_AE_HEADERS xah,
                 apps.XLA_AE_LINES xal,
                 apps.GL_CODE_COMBINATIONS gcc,
                 apps.FND_LOOKUP_VALUES flv
           WHERE     rcta.CUSTOMER_TRX_ID = rctl.CUSTOMER_TRX_ID
                 AND rctl.account_class = 'REC'
                 AND rctl.EVENT_ID = xah.EVENT_ID
                 AND xah.ledger_id = 2021
                 AND xah.AE_HEADER_ID = xal.AE_HEADER_ID
                 AND xal.accounting_class_code = 'RECEIVABLE'
                 AND xal.ae_line_num = 1
                 AND xal.CODE_COMBINATION_ID = gcc.CODE_COMBINATION_ID
                 AND gcc.SEGMENT6 = flv.LOOKUP_CODE
                 AND flv.LANGUAGE = 'PTB'
                 AND flv.LOOKUP_TYPE = 'PPG_BR_GL_BU'
				 -- begin 02/10/2017 -- chamado 5763733 -- Ticket 247794
				 and rownum = 1
				 -- end 02/10/2017 -- chamado 5763733 -- Ticket 247794
				 ) "DETAIL SBU",
        HCASA.GLOBAL_ATTRIBUTE3||HCASA.GLOBAL_ATTRIBUTE4||HCASA.GLOBAL_ATTRIBUTE5 CNPJ,
        Hp.Party_Name "NOME DO CLIENTE", 
         Rctla.Customer_Trx_Id,
        Apsa.Invoice_Currency_Code MOEDA,         
         (SELECT OUR_NUMBER
            FROM Apps.Jl_Br_Ar_Collection_Docs_All
           WHERE     Payment_Schedule_Id = Apsa.Payment_Schedule_Id
                 AND Customer_Trx_Id = Rcta.Customer_Trx_Id
                 AND ROWNUM = 1) "NOSSO NUMERO", 
        TRUNC (Apsa.Creation_Date) "DT EMISSAO NF",  
        rtv.description "COND PAGTO",
        rtv.name "COD COND PAGTO", 
       (SELECT Decode(Rctta.type
                              ,'INV'
                              ,'NFF'
                              ,'CM'
                              ,'Aviso Credito'
                              ,'DM'
                              ,'Aviso de Debito'
                              ,Rctta.type)
                   FROM apps.ra_cust_trx_types_all Rctta
                  WHERE Rcta.Cust_Trx_Type_Id = Rctta.Cust_Trx_Type_Id
                    AND Rownum = 1) "TIPO DE NOTA",  
         Rbsa.Global_Attribute3 "SERIE DO DOCUMENTO",
         Rctta.Description "DESC DO DOCUMENTO",
         Rcta.Trx_Number "NUM NF",
         Apsa.Terms_Sequence_Number PARCELA,
         Apsa.Amount_due_Original "VLR DA PARCELA",
         Apsa.Amount_due_Remaining "SALDO PARCELA",
        (CASE WHEN Apsa.Invoice_Currency_Code != 'BRL'                        
                 THEN 
                 ((SELECT trunc(CONVERSION_RATE,4)
                   FROM apps.GL_DAILY_RATES
                  WHERE TO_CURRENCY = 'BRL'
                    AND CONVERSION_TYPE = ( SELECT CONVERSION_TYPE
                                              FROM apps.GL_DAILY_CONVERSION_TYPES
                                             WHERE USER_CONVERSION_TYPE = 'BCB Venda'
                                          )
                    AND FROM_CURRENCY = Apsa.INVOICE_CURRENCY_CODE
                    AND CONVERSION_DATE = ( SELECT MAX(CONVERSION_DATE)
                                              FROM apps.GL_DAILY_RATES
                                             WHERE TO_CURRENCY = 'BRL'
                                               AND CONVERSION_TYPE = ( SELECT CONVERSION_TYPE
                                                                         FROM apps.GL_DAILY_CONVERSION_TYPES
                                                                        WHERE USER_CONVERSION_TYPE = 'BCB Venda'
                                                                     )
                                               AND FROM_CURRENCY = Apsa.INVOICE_CURRENCY_CODE
                                               AND TO_CHAR(CONVERSION_DATE,'YYYYMM') = TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM'))) * Apsa.Amount_due_Remaining) 
                 ELSE 
              Apsa.Amount_due_Remaining     
                 END ) "SALDO BRL",   
         (  NVL (Apsa.Discount_Original * 1, 0)
          + NVL (Apsa.Amount_Adjusted * 1, 0))
            "VALOR DO AJUSTE",
         (  (  100 * NVL (Apsa.Discount_Original * 1, 0)
             + NVL (Apsa.Amount_Adjusted * 1, 0))
          / DECODE (Apsa.Amount_Due_Original, 0, 1, Apsa.Amount_Due_Original))
            "% AJUSTE",
         Apsa.amount_adjusted AJUSTES,
         TRUNC (Apsa.Due_Date) "DT VENCIMENTO",        
         DECODE ( (Apsa.Amount_Due_Remaining),
                 0, (Apsa.Gl_Date_Closed - Apsa.Due_Date),
                 NULL) "DIAS PAGAMENTO",
         SYSDATE - Apsa.Due_Date "DIAS EM ATRASO",                                                                                       
            (SELECT description FROM 
              (select  abc.description,JBACDA.PAYMENT_SCHEDULE_ID 
                from apps.JL_BR_AR_OCCURRENCE_DOCS_ALL JLOCC, apps.JL_BR_AR_BANK_OCCURRENCES ABC,APPS.JL_BR_AR_COLLECTION_DOCS_ALL JBACDA 
                where  JLOCC.BANK_OCCURRENCE_CODE = ABC.BANK_OCCURRENCE_CODE
                AND JLOCC.BANK_OCCURRENCE_TYPE = ABC.BANK_OCCURRENCE_TYPE
                AND JLOCC.BANK_PARTY_ID = ABC.BANK_PARTY_ID   
                AND JBACDA.DOCUMENT_ID = JLOCC.DOCUMENT_ID       
                order by JLOCC.CREATION_DATE DESC) bordero
                WHERE BORDERO.PAYMENT_SCHEDULE_ID IN (APSA.PAYMENT_SCHEDULE_ID)AND             
                 rownum = 1) "DESC OCORRENCIA" ,           
                  (select HCPROF.global_attribute1
                    from apps.HZ_CUSTOMER_PROFILES      HCPROF
                    where  HP.PARTY_ID         = HCPROF.PARTY_ID
                    AND hcc.SITE_USE_ID     = HCPROF.SITE_USE_ID 
					-- begin 02/10/2017 -- chamado 5763733 -- Ticket 247794
					and rownum = 1
					-- end 02/10/2017 -- chamado 5763733 -- Ticket 247794
                  ) PROTESTA,
          hca.customer_class_code "CLASSFICACAO CLIENTE", 
         (SELECT hprof.CREDIT_CLASSIFICATION
          FROM apps.hz_customer_profiles hprof, apps.ar_collectors acol
         WHERE     hca.cust_account_id = hprof.cust_account_id
               AND hprof.collector_id = acol.collector_id
               AND ROWNUM = 1) "CLASSIFICACAO CREDITO",         
         Hp.Attribute2 "GRUPO DO CLIENTE",
          (SELECT Arm.NAME
            FROM  Apps.Ar_Receipt_Methods Arm,apps.AR_RECEIPT_CLASSES ARC
           WHERE  ARM.RECEIPT_CLASS_ID = ARC.RECEIPT_CLASS_ID(+)
                 AND RCTA.RECEIPT_METHOD_ID = ARM.RECEIPT_METHOD_ID(+)
                 AND ROWNUM = 1) PORTADOR,
         Apsa.Status "STATUS NF TITULO",
         (SELECT    Jbacdsv.Bank_Instruction_Code1
                 || '-'
                 || Jbacdsv.Bank_Instruction_Code1_Dsp
                 || ' - '
                 || Jbacdsv.Bank_Instruction_Code2
                 || '-'
                 || Jbacdsv.Bank_Instruction_Code2_Dsp
            FROM Apps.Jl_Br_Ar_Coll_Docs_Sab_v Jbacdsv
           WHERE     Jbacdsv.Payment_Schedule_Id = Apsa.Payment_Schedule_Id
                 AND Jbacdsv.Customer_Trx_Id = Rcta.Customer_Trx_Id
                 AND ROWNUM = 1) "INSTRUCAO BANCARIA",
         Apsa.Attribute3 "HISTORICO DE COBRANCA 1",
         Apsa.Attribute4 "HISTORICO DE COBRANCA 2",
         Apsa.Attribute5 "HISTORICO DE COBRANCA 3",
 (SELECT DISTINCT JRGM.RESOURCE_NAME
                 FROM apps.JTF_RS_SALESREPS          JRS,
                      apps.jtf_rs_group_members_vl   JRGM,
                      apps.HZ_CUST_ACCT_SITES_ALL    HCASA,
                      apps.HZ_CUST_SITE_USES_ALL     HCSUA
                WHERE HCASA.CUST_ACCOUNT_ID     = Apsa.CUSTOMER_ID  
                  AND HCASA.PARTY_SITE_ID       = HPS.PARTY_SITE_ID 
                  AND HCSUA.STATUS              = 'A'
                  AND HCSUA.CUST_ACCT_SITE_ID   = HCASA.CUST_ACCT_SITE_ID
                  AND HCSUA.SITE_USE_CODE       = 'SHIP_TO'
                  AND HCSUA.PRIMARY_SALESREP_ID = JRS.SALESREP_ID
                  AND JRS.RESOURCE_ID           = JRGM.RESOURCE_ID) "REPRESENTANTE CADASTRO",
               NVL (
            Apps.Xxppg_Qp_Sourcing_Fields_Pkg.Get_Salesrep_Manager (                                
                 (SELECT DISTINCT JRS.SALESREP_ID
                 FROM apps.JTF_RS_SALESREPS          JRS,
                      apps.jtf_rs_group_members_vl   JRGM,
                      apps.HZ_CUST_ACCT_SITES_ALL    HCASA2,
                      apps.HZ_CUST_SITE_USES_ALL     HCSUA
                WHERE HCASA2.CUST_ACCOUNT_ID     = Apsa.CUSTOMER_ID 
                  AND HCASA2.PARTY_SITE_ID       = HPS.PARTY_SITE_ID
                  AND HCSUA.STATUS              = 'A'
                  AND HCSUA.CUST_ACCT_SITE_ID   = HCASA2.CUST_ACCT_SITE_ID
                  AND HCSUA.SITE_USE_CODE       = 'SHIP_TO'
                  AND HCSUA.PRIMARY_SALESREP_ID = JRS.SALESREP_ID
                  AND JRS.RESOURCE_ID           = JRGM.RESOURCE_ID) 
               ),                
                  null) "GERENTE CADASTRO",
    (SELECT DISTINCT JRGM.RESOURCE_NAME
                 FROM apps.JTF_RS_SALESREPS          JRS,
                      apps.jtf_rs_group_members_vl   JRGM
                WHERE 
                  rcta.PRIMARY_SALESREP_ID = JRS.SALESREP_ID
                  AND JRS.RESOURCE_ID           = JRGM.RESOURCE_ID) "REPRESENTANTE NF",
   NVL (
            Apps.Xxppg_Qp_Sourcing_Fields_Pkg.Get_Salesrep_Manager (                                
                 (SELECT DISTINCT JRS.SALESREP_ID
                 FROM apps.JTF_RS_SALESREPS          JRS,
                      apps.jtf_rs_group_members_vl   JRGM,
                      apps.HZ_CUST_ACCT_SITES_ALL    HCASA2,
                      apps.HZ_CUST_SITE_USES_ALL     HCSUA
                WHERE HCASA2.CUST_ACCOUNT_ID     = Apsa.CUSTOMER_ID 
                  AND HCASA2.PARTY_SITE_ID       = HPS.PARTY_SITE_ID
                  AND HCSUA.STATUS              = 'A'
                  AND HCSUA.CUST_ACCT_SITE_ID   = HCASA2.CUST_ACCT_SITE_ID
                  AND HCSUA.SITE_USE_CODE       = 'SHIP_TO'
                  AND rcta.PRIMARY_SALESREP_ID = JRS.SALESREP_ID
                  AND JRS.RESOURCE_ID           = JRGM.RESOURCE_ID) 
               ),                
                  null) "GERENTE NF",                  
         (SELECT    hcp.phone_country_code
                 || ' '
                 || hcp.phone_area_code
                 || ' '
                 || hcp.phone_number
                    telephone
            FROM apps.hz_contact_points hcp
           WHERE     1 = 1
                 AND owner_table_name = 'HZ_PARTY_SITES'
                 AND contact_point_type = 'PHONE'
                 AND phone_line_type = 'GEN'
                 AND primary_flag = 'Y'
                 AND status = 'A'
                 AND owner_table_id =
                        (SELECT hcsua.party_site_id
                           FROM apps.hz_cust_acct_sites_all hcsua
                          WHERE     hcsua.cust_account_id = hca.cust_account_id
                                AND EXISTS
                                       (SELECT 1
                                          FROM apps.hz_cust_site_uses_all x
                                         WHERE     x.cust_acct_site_id =
                                                      hcsua.cust_acct_site_id
                                               AND rcta.bill_to_site_use_id =
                                                      x.site_use_id))) "SALES REP PHONE",
 ( select
        distinct (loc2.state) 
    from apps.hz_cust_accounts hca2
     , apps.hz_parties       hp2
     , apps.hz_cust_acct_sites_all cas2
     , apps.hz_party_sites         hps2
     , apps.hz_locations           loc2
     , APPS.HZ_CUST_SITE_USES_ALL HCSUA2
 where hca2.cust_account_id   = cas2.cust_account_id
   and cas2.CUST_ACCT_SITE_ID     = HCSUA2.CUST_ACCT_SITE_ID
   AND HCSUA2.SITE_USE_CODE         = 'SHIP_TO'
   and hca2.party_id          = hp2.party_id
   and cas2.party_site_id     = hps2.party_site_id
   and hps2.location_id       = loc2.location_id
   and hp2.PARTY_NAME = hp.party_name
   and hps2.party_site_id  = hps.party_site_id)  ESTADO,                                                 
(SELECT hzcp.email_address
   FROM apps.hz_contact_points hzcp
  WHERE     NVL (hzcp.primary_flag, 'Y') = 'Y'
        AND NVL (hzcp.contact_point_type, 'EMAIL') = 'EMAIL'
        AND NVL (hzcp.owner_table_name, 'HZ_PARTY_SITES') = 'HZ_PARTY_SITES'
        AND owner_table_id =
		       (SELECT hcsua.party_site_id
			      FROM apps.hz_cust_acct_sites_all hcsua
                 WHERE     hcsua.cust_account_id = hca.cust_account_id
				 -- begin 02/10/2017 -- chamado 5763733 -- Ticket 247794
				   and rownum = 1 
				 -- end 02/10/2017 -- chamado 5763733 -- Ticket 247794
                       AND EXISTS
                              (SELECT 1
                                 FROM apps.hz_cust_site_uses_all x
                                WHERE     x.cust_acct_site_id =
                                             hcsua.cust_acct_site_id
                                      AND rcta.bill_to_site_use_id =
                                             x.site_use_id))) EMAIL
    FROM Apps.Ra_Customer_Trx_All Rcta,
         Apps.Ra_Customer_Trx_Lines_All Rctla,  
         Apps.Ra_Batch_Sources_All Rbsa,
         Apps.Ar_Payment_Schedules_All Apsa,
         Apps.Ra_Cust_Trx_Types_All Rctta,
         Apps.Jtf_Rs_Salesreps Jrs,
         Apps.Hz_Cust_Accounts Hca, 
         apps.HZ_CUST_ACCT_SITES_ALL    HCASA,
         Apps.Hz_Parties Hp,
         Apps.ra_terms_vl rtv,
         apps.HZ_CUST_SITE_USES_ALL  hcc,
         apps.hz_party_sites hps
   WHERE     Rctla.Customer_Trx_Id = Rcta.Customer_Trx_Id
         AND HCA.CUST_ACCOUNT_ID = HCASA.CUST_ACCOUNT_ID
         AND Apsa.Customer_Trx_Id(+) = Rcta.Customer_Trx_Id
         AND nvl (Rcta.term_id,1094) = rtv.term_id
         AND Rcta.Cust_Trx_Type_Id = Rctta.Cust_Trx_Type_Id
         AND Rbsa.Batch_Source_Id = Rcta.Batch_Source_Id
         AND Rbsa.org_id = 82
         AND Rcta.Primary_Salesrep_Id = Jrs.Salesrep_Id(+)
         AND Hp.Party_Id = Hca.Party_Id
         AND Hca.Cust_Account_Id = Apsa.Customer_Id
         AND Rctla.Warehouse_Id IS NOT NULL
         and rcta.ship_to_customer_id = hca.cust_account_id --correcao 26_10_16
         and HCASA.cust_acct_site_id = hcc.cust_acct_site_id
         and hcc.site_use_id = rcta.bill_to_site_use_id
         and hcc.SITE_USE_CODE = 'BILL_TO'   
         and Hp.Party_Id = hps.party_id
         and  HPS.PARTY_SITE_ID =  hcasa.PARTY_SITE_ID  
        order by Hp.Party_Name, rcta.trx_number