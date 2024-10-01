SELECT DISTINCT (SELECT Segment6
                   FROM Apps.Gl_Code_Combinations
                  WHERE Code_Combination_Id = Jrs.Gl_Id_Rev) "UNIDADE DE NEGOCIO"
                ,(SELECT NAME
                   FROM Apps.Hr_All_Organization_Units
                  WHERE Organization_Id = Rctla.Warehouse_Id) Estabelecimento
                ,Hca.Account_Number "COD CLIENTE"
                ,Apsa.CLASS
                ,Hp.Party_Name "NOME DO CLIENTE"
                ,(SELECT Decode(Substr(Arm.NAME, -4, 4), 'CART', 'CARTEIRA', 'ESCR', 'ESCRITURAL', 'VEND', 'VENDOR')
                   FROM Apps.Jl_Br_Ar_Collection_Docs_All Jbacda
                       ,Apps.Ar_Receipt_Methods           Arm
                  WHERE Jbacda.Payment_Schedule_Id = Apsa.Payment_Schedule_Id
                    AND Jbacda.Customer_Trx_Id = Rcta.Customer_Trx_Id
                    AND Arm.Receipt_Method_Id = Jbacda.Receipt_Method_Id
                    AND Rownum = 1) Carteira
                ,(SELECT Document_Id
                   FROM Apps.Jl_Br_Ar_Collection_Docs_All
                  WHERE Payment_Schedule_Id = Apsa.Payment_Schedule_Id
                    AND Customer_Trx_Id = Rcta.Customer_Trx_Id
                    AND Rownum = 1) "TITULO BANCO"
                ,Apsa.Invoice_Currency_Code Moeda
                ,(SELECT OUR_NUMBER
                   FROM Apps.Jl_Br_Ar_Collection_Docs_All
                  WHERE Payment_Schedule_Id = Apsa.Payment_Schedule_Id
                    AND Customer_Trx_Id = Rcta.Customer_Trx_Id
                    AND Rownum = 1) "NOSSO NUMERO"
                ,Trunc(Apsa.Creation_Date) "DATA EMISSAO DO TITULO"
                                ,(SELECT Decode(Rctpv.Ctt_Class
                              ,'INV'
                              ,'NFF'
                              ,'CM'
                              ,'Aviso Credito'
                              ,'DM'
                              ,'Aviso de Debito'
                              ,Rctpv.Ctt_Class)
                   FROM Apps.Ra_Customer_Trx_Partial_v Rctpv
                  WHERE Rctpv.Customer_Trx_Id = Rcta.Customer_Trx_Id
                    AND Rownum = 1) "TIPO DE NOTA"
                ,Rbsa.Global_Attribute3 "SERIE DO DOCUMENTO"
                ,Rctta.Description "DESCRICAO DO DOCUMENTO"
                ,Rcta.Trx_Number "TITULO - NUMERO DA NF"
                ,(SELECT SUM(Extended_Amount)
                   FROM Apps.Ra_Customer_Trx_Lines_All Rctll
                  WHERE Rctll.Line_Type = 'LINE'
                    AND Rctll.Customer_Trx_Id = Rcta.Customer_Trx_Id) "VALOR ORIGINAL DO TITULO"
                ,Apsa.Terms_Sequence_Number Parcela
                ,Apsa.Amount_Due_Original "VALOR ORIGINAL DA PARCELA"
                ,Apsa.Amount_Due_Remaining "VALOR SALDO"
                ,Decode((Apsa.Amount_Due_Remaining), 0, Apsa.Amount_Due_Original, NULL) "VALOR LIQUIDACAO"
                ,(Nvl(Apsa.Discount_Original * -1, 0) + Nvl(Apsa.Amount_Adjusted * -1, 0)) "VALOR DO DESCONTO"
                ,((100 * Nvl(Apsa.Discount_Original * -1, 0) + Nvl(Apsa.Amount_Adjusted * -1, 0)) /
                Decode(Apsa.Amount_Due_Original, 0, 1, Apsa.Amount_Due_Original)) "% DESCONTO"
                ,Trunc(Apsa.Due_Date) "DATA DO VENCIMENTO"
                ,Decode((Apsa.Amount_Due_Remaining), 0, Apsa.Gl_Date_Closed, NULL) "DATA DA LIQUIDACAO"
                ,Decode((Apsa.Amount_Due_Remaining), 0, (Apsa.Gl_Date_Closed - Apsa.Due_Date), NULL) "DIAS PAGAMENTO"
                ,SYSDATE - Apsa.Due_Date "DIAS EM ATRASO"
                ,(SELECT SUM(Araa.Global_Attribute3) Juros_Calculados
                   FROM Apps.Ar_Receivable_Applications_All Araa
                  WHERE Araa.Applied_Payment_Schedule_Id = Apsa.Payment_Schedule_Id) "JUROS APLICADOS"
                ,(SELECT SUM(Araa.Global_Attribute4)
                   FROM Apps.Ar_Receivable_Applications_All Araa
                  WHERE Araa.Applied_Payment_Schedule_Id = Apsa.Payment_Schedule_Id) "JUROS RECEBIDOS"
                ,Hp.Attribute2 "GRUPO DO CLIENTE"
                ,(SELECT Arm.NAME
                   FROM Apps.Jl_Br_Ar_Collection_Docs_All Jbacda
                       ,Apps.Ar_Receipt_Methods           Arm
                  WHERE Jbacda.Payment_Schedule_Id = Apsa.Payment_Schedule_Id
                    AND Jbacda.Customer_Trx_Id = Rcta.Customer_Trx_Id
                    AND Arm.Receipt_Method_Id = Jbacda.Receipt_Method_Id
                    AND Rownum = 1) Portador
                ,Apsa.Status Status_Nota_Titulo
                ,(SELECT Jbacdsv.Bank_Instruction_Code1 || '-' || Jbacdsv.Bank_Instruction_Code1_Dsp || ' - ' ||
                        Jbacdsv.Bank_Instruction_Code2 || '-' || Jbacdsv.Bank_Instruction_Code2_Dsp
                   FROM Apps.Jl_Br_Ar_Coll_Docs_Sab_v Jbacdsv
                  WHERE Jbacdsv.Payment_Schedule_Id = Apsa.Payment_Schedule_Id
                    AND Jbacdsv.Customer_Trx_Id = Rcta.Customer_Trx_Id
                    AND Rownum = 1) "INSTRUCAO BANCARIA"
                ,Apsa.Attribute3 "HISTORICO DE COBRANCA 1"
                ,Apsa.Attribute4 "HISTORICO DE COBRANCA 2"
                ,Apsa.Attribute5 "HISTORICO DE COBRANCA 3"
                ,Jrs.Salesrep_Number || ' - ' || Jrs.NAME Representante
                ,Apps.Xxppg_Qp_Sourcing_Fields_Pkg.Get_Salesrep_Manager(Jrs.Salesrep_Id) Gerente
                ,Apsa.Payment_Schedule_Id
  FROM Apps.Ra_Customer_Trx_All       Rcta
      ,Apps.Ra_Customer_Trx_Lines_All Rctla
      ,Apps.Ra_Batch_Sources_All      Rbsa
      ,Apps.Ar_Payment_Schedules_All  Apsa
      ,Apps.Ra_Cust_Trx_Types_All     Rctta
      ,Apps.Jtf_Rs_Salesreps          Jrs
      ,Apps.Hz_Cust_Accounts          Hca
      ,Apps.Hz_Parties                Hp
 WHERE Rctla.Customer_Trx_Id = Rcta.Customer_Trx_Id
   AND Apsa.Customer_Trx_Id(+) = Rcta.Customer_Trx_Id
   AND Rcta.Cust_Trx_Type_Id = Rctta.Cust_Trx_Type_Id
   AND Rbsa.Batch_Source_Id = Rcta.Batch_Source_Id
   AND Rcta.Primary_Salesrep_Id = Jrs.Salesrep_Id(+)
   AND Hp.Party_Id = Hca.Party_Id
   AND Hca.Cust_Account_Id = Apsa.Customer_Id
   AND Rctla.Warehouse_Id IS NOT NULL
 ORDER BY Apsa.Terms_Sequence_Number
