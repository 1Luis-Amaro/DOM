SELECT DISTINCT /*(SELECT Segment6
                     FROM Apps.Gl_Code_Combinations
                    WHERE Code_Combination_Id = Jrs.Gl_Id_Rev) "UNIDADE DE NEGOCIO" */
         /* commented by ora0086 */
         /* Details SBU */
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
                 AND flv.LOOKUP_TYPE = 'PPG_BR_GL_BU')
            DETAIL_SBU,
         /*(SELECT NAME
            FROM Apps.Hr_All_Organization_Units
           WHERE Organization_Id = Rctla.Warehouse_Id)
            Estabelecimento,
         Hca.Account_Number "COD CLIENTE",*/
         --Apsa.CLASS,
         HCASA.GLOBAL_ATTRIBUTE3||HCASA.GLOBAL_ATTRIBUTE4||HCASA.GLOBAL_ATTRIBUTE5 CNPJ,
         Hp.Party_Name "NOME DO CLIENTE",
         /*(SELECT DECODE (SUBSTR (Arm.NAME, -4, 4),
                         'CART', 'CARTEIRA',
                         'ESCR', 'ESCRITURAL',
                         'VEND', 'VENDOR')
            FROM Apps.Jl_Br_Ar_Collection_Docs_All Jbacda,
                 Apps.Ar_Receipt_Methods Arm
           WHERE     Jbacda.Payment_Schedule_Id = Apsa.Payment_Schedule_Id
                 AND Jbacda.Customer_Trx_Id = Rcta.Customer_Trx_Id
                 AND Arm.Receipt_Method_Id = Jbacda.Receipt_Method_Id
                 AND ROWNUM = 1)
            Carteira,
         (SELECT Document_Id
            FROM Apps.Jl_Br_Ar_Collection_Docs_All
           WHERE     Payment_Schedule_Id = Apsa.Payment_Schedule_Id
                 AND Customer_Trx_Id = Rcta.Customer_Trx_Id
                 AND ROWNUM = 1)
            "TITULO BANCO",*/
         Apsa.Invoice_Currency_Code Moeda,
         (SELECT OUR_NUMBER
            FROM Apps.Jl_Br_Ar_Collection_Docs_All
           WHERE     Payment_Schedule_Id = Apsa.Payment_Schedule_Id
                 AND Customer_Trx_Id = Rcta.Customer_Trx_Id
                 AND ROWNUM = 1)
            "NOSSO NUMERO",
         TRUNC (Apsa.Creation_Date) "DATA EMISSAO DO TITULO",
         rtv.description "Cond Pagto",
         rtv.name "Codigo Cond Pagto",
         /*(SELECT DECODE (Rctpv.Ctt_Class,
                         'INV', 'NFF',
                         'CM', 'Aviso Credito',
                         'DM', 'Aviso de Debito',
                         Rctpv.Ctt_Class)
            FROM Apps.Ra_Customer_Trx_Partial_v Rctpv
           WHERE Rctpv.Customer_Trx_Id = Rcta.Customer_Trx_Id AND ROWNUM = 1)
            "TIPO DE NOTA",*/
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
         Rctta.Description "DESCRICAO DO DOCUMENTO",
         Rcta.Trx_Number "TITULO - NUMERO DA NF",
         /*(SELECT SUM (Extended_Amount)
            FROM Apps.Ra_Customer_Trx_Lines_All Rctll
           WHERE     Rctll.Line_Type = 'LINE'
                 AND Rctll.Customer_Trx_Id = Rcta.Customer_Trx_Id)
            "VALOR ORIGINAL DO TITULO",*/
         Apsa.Terms_Sequence_Number Parcela,
         --Apsa.Amount_line_items_Original "VALOR ORIGINAL DA PARCELA",
         Apsa.Amount_due_Original "VALOR ORIGINAL DA PARCELA",--changed
         --Apsa.Amount_line_items_Remaining "VALOR SALDO",
         Apsa.Amount_due_Remaining "VALOR SALDO",--changed
         Apsa.Amount_applied "VALOR LIQUIDACAO",
         (  NVL (Apsa.Discount_Original * 1, 0)
          + NVL (Apsa.Amount_Adjusted * 1, 0))
            "VALOR DO AJUSTE",
         (  (  100 * NVL (Apsa.Discount_Original * 1, 0)
             + NVL (Apsa.Amount_Adjusted * 1, 0))
          / DECODE (Apsa.Amount_Due_Original, 0, 1, Apsa.Amount_Due_Original))
            "% AJUSTE",
         Apsa.amount_adjusted AJUSTES,
         Apsa.amount_credited CREDITO,
         TRUNC (Apsa.Due_Date) "DATA DO VENCIMENTO",
        -- Apsa.actual_date_closed  "DATA DA LIQUIDACAO",
         DECODE ( to_char(Apsa.actual_date_closed,'DD/MM/RRRR'),'31/12/4712',NULL,Apsa.actual_date_closed) "DATA DA LIQUIDACAO",
         DECODE ( (Apsa.Amount_Due_Remaining),
                 0, (Apsa.Gl_Date_Closed - Apsa.Due_Date),
                 NULL)
            "DIAS PAGAMENTO",
         SYSDATE - Apsa.Due_Date "DIAS EM ATRASO",
         /*(SELECT SUM (Araa.Global_Attribute3) Juros_Calculados
            FROM Apps.Ar_Receivable_Applications_All Araa
           WHERE Araa.Applied_Payment_Schedule_Id = Apsa.Payment_Schedule_Id)
            "JUROS APLICADOS",*/
         /*(SELECT SUM (Araa.Global_Attribute4)
            FROM Apps.Ar_Receivable_Applications_All Araa
           WHERE Araa.Applied_Payment_Schedule_Id = Apsa.Payment_Schedule_Id)
            "JUROS RECEBIDOS",*/
         Hp.Attribute2 "GRUPO DO CLIENTE",
         (SELECT Arm.NAME
            FROM Apps.Jl_Br_Ar_Collection_Docs_All Jbacda,
                 Apps.Ar_Receipt_Methods Arm
           WHERE     Jbacda.Payment_Schedule_Id = Apsa.Payment_Schedule_Id
                 AND Jbacda.Customer_Trx_Id = Rcta.Customer_Trx_Id
                 AND Arm.Receipt_Method_Id = Jbacda.Receipt_Method_Id
                 AND ROWNUM = 1)
            Portador,
         Apsa.Status Status_Nota_Titulo,
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
                 AND ROWNUM = 1)
            "INSTRUCAO BANCARIA",
         Apsa.Attribute3 "HISTORICO DE COBRANCA 1",
         Apsa.Attribute4 "HISTORICO DE COBRANCA 2",
         Apsa.Attribute5 "HISTORICO DE COBRANCA 3",
        (SELECT distinct jbaod1.DESCRIPTION
            FROM Apps.Jl_Br_Ar_Collection_Docs_All Jbacda,
                 Apps.Ar_Receipt_Methods Arm,
                -- Apps.Ra_Customer_Trx_All Rcta,   commented by ora0086
              --   Apps.Ar_Payment_Schedules_All Apsa, commented by ora0086
                 apps.JL_BR_AR_OCCURRENCE_DOCS_V jbaod1
           WHERE Jbacda.Payment_Schedule_Id = Apsa.Payment_Schedule_Id
             AND Jbacda.Customer_Trx_Id = Rcta.Customer_Trx_Id
             AND Arm.Receipt_Method_Id = Jbacda.Receipt_Method_Id
             AND JBACDA.org_id = rcta.org_id
             AND jbaod1.site_use_id(+) = rcta.bill_to_site_use_id
             AND JBACDA.org_id = jbaod1.org_id
             AND jbaod1.customer_id(+) = rcta.bill_to_customer_id
             AND jbaod1.document_id = Jbacda.document_id
             AND jbaod1.occurrence_id = (select max (jbaod2.occurrence_id)
                                           from apps.JL_BR_AR_OCCURRENCE_DOCS_V jbaod2
                                           where jbaod1.document_id = jbaod2.document_id)) "Ocorrencia Bancaria", 
         --,Jrs.Salesrep_Number || ' - ' || Jrs.NAME Representante commented by ora0086
         /* Representative's data altered by ora0086 */
         (SELECT source_name
            FROM apps.JTF_RS_RESOURCE_EXTNS
           WHERE resource_id = jrs.resource_id)
            Representante/* Representative's manager data altered by ora0086 */
         ,
         NVL (
            Apps.Xxppg_Qp_Sourcing_Fields_Pkg.Get_Salesrep_Manager (
               Jrs.Salesrep_Id),
            (SELECT source_mgr_name
               FROM apps.JTF_RS_RESOURCE_EXTNS
              WHERE resource_id = jrs.resource_id))
            Gerente,
         /* Sales Representative's Phone Number */
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
                                                      x.site_use_id)))
            Sales_Rep_Phone
            /*Collection Method */
         /*(SELECT name
            FROM ar_receipt_methods c
           WHERE c.receipt_method_id = rcta.receipt_method_id)
            collection_method
            /* Credit Exposure of the customer */                                               
         -- NOT YET SHIPPED
           /*(SELECT NVL (
                      SUM (
                         (  NVL (ordered_quantity, 0)
                          * NVL (unit_selling_price, 0))),
                      0) 
              FROM apps.oe_order_lines_all a2
             WHERE     flow_status_code IN ('PICKED', 'AWAITING_SHIPPING')
                   AND invoice_to_org_id IN (SELECT site_use_id
                                               FROM hz_cust_site_uses_all a,
                                                    hz_cust_acct_sites_all b
                                              WHERE     a.CUST_ACCT_SITE_ID =
                                                           b.CUST_ACCT_SITE_ID
                                                    AND site_use_code =
                                                           'BILL_TO'
                                                    AND hca.cust_account_id =
                                                           b.cust_account_id))
         + -- SHIPPED
           (SELECT NVL (
                      SUM (
                         (  NVL (shipped_quantity, 0)
                          * NVL (unit_selling_price, 0))),
                      0) 
              FROM apps.oe_order_lines_all a1
             WHERE     flow_status_code IN ('SHIPPED')
                   AND invoice_to_org_id IN (SELECT site_use_id
                                               FROM hz_cust_site_uses_all a,
                                                    hz_cust_acct_sites_all b
                                              WHERE     a.CUST_ACCT_SITE_ID =
                                                           b.CUST_ACCT_SITE_ID
                                                    AND site_use_code =
                                                           'BILL_TO'
                                                    AND hca.cust_account_id =
                                                           b.cust_account_id))
         + -- CLOSED BUT NOT YET IN AR
           (SELECT NVL (
                      SUM (
                         (  NVL (shipped_quantity, 0)
                          * NVL (unit_selling_price, 0))),
                      0) 
              FROM apps.oe_order_lines_all a1
             WHERE     flow_status_code IN ('CLOSED')
                   AND invoice_to_org_id IN (SELECT site_use_id
                                               FROM hz_cust_site_uses_all a,
                                                    hz_cust_acct_sites_all b
                                              WHERE     a.CUST_ACCT_SITE_ID =
                                                           b.CUST_ACCT_SITE_ID
                                                    AND site_use_code =
                                                           'BILL_TO'
                                                    AND hca.cust_account_id =
                                                           b.cust_account_id)
                   AND NOT EXISTS
                          (SELECT 1
                             FROM ra_customer_trx_lines_all r
                            WHERE     a1.org_id = r.org_id
                                  AND TO_NUMBER (
                                         TRIM (r.interface_line_attribute6)) =
                                         a1.line_id))
         + -- AR Unpaid
           (SELECT NVL (SUM (NVL (apsa.amount_due_remaining, 0)), 0)
              FROM AR_PAYMENT_SCHEDULES_all z
             WHERE     z.org_id = rcta.org_id
                   AND z.class IN ('INV',
                                   'DM',
                                   'CM',
                                   'GUAR',
                                   'DEP',
                                   'CB')
                   AND rcta.sold_to_customer_id = z.customer_id)
         + -- Tax Amount
           (SELECT NVL (SUM (NVL (z.tax_amt, 0)), 0)
              FROM zx_lines z, ra_customer_trx_all z1
             WHERE     1 = 1
                   AND rcta.sold_to_customer_id = z1.sold_to_customer_id
                   AND z1.customer_trx_id = z.trx_id)
            SALES_ORD_SUM,*/
         --Apsa.Payment_Schedule_Id
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
         apps.HZ_CUST_SITE_USES_ALL  hcc--added
   WHERE     Rctla.Customer_Trx_Id = Rcta.Customer_Trx_Id
         AND HCA.CUST_ACCOUNT_ID = HCASA.CUST_ACCOUNT_ID
         AND Apsa.Customer_Trx_Id(+) = Rcta.Customer_Trx_Id
         AND nvl (Rcta.term_id,1094) = rtv.term_id
         AND Rcta.Cust_Trx_Type_Id = Rctta.Cust_Trx_Type_Id
         AND Rbsa.Batch_Source_Id = Rcta.Batch_Source_Id
         AND Rbsa.org_id = 82--added
         AND Rcta.Primary_Salesrep_Id = Jrs.Salesrep_Id(+)
         AND Hp.Party_Id = Hca.Party_Id
         AND Hca.Cust_Account_Id = Apsa.Customer_Id
         AND Rctla.Warehouse_Id IS NOT NULL
         and rcta.sold_to_customer_id = hca.cust_account_id--added
         and HCASA.cust_acct_site_id = hcc.cust_acct_site_id--added
         and hcc.site_use_id = rcta.bill_to_site_use_id--added
         and hcc.SITE_USE_CODE = 'BILL_TO'--added
         --and rcta.trx_number like '15517%'
         --and Hp.Party_Name = 'ANDERSON M E NUNES TINTAS ME'
         --and rcta.customer_trx_id = 230940
         --and rcta.trx_number = '485'   --'DB-0018449-04'
order by Hp.Party_Name, rcta.trx_number;
--ORDER BY Apsa.Terms_Sequence_Number;