SELECT DISTINCT Pv.Segment1 "CODIGO DO FORNECEDOR"
                ,Pv.Vendor_Name "NOME FORNECEDOR"
                ,Aia.Pay_Group_Lookup_Code "GRUPO PAGAMENTO"
                ,Pv.Vendor_Type_Lookup_Code "GRUPO FORNECEDOR"
                ,Aia.Payment_Method_Code "TIPO DOCUMENTO"
                ,Aia.SOURCE "MODULO ORIGEM"
                ,Aia.Invoice_Num "NUMERO DOCUMENTO"
                ,Trunc(Aia.Invoice_Date) "DATA EMISSAO"
                ,Trunc(Aia.Gl_Date) "DATA TRANSACAO"
                ,Info_Ri.LOCAL
                ,Info_Ri.Serie
                ,Info_Ri.Invoice_Id Id_Nota_Ri
                ,Info_Ri.Invoice_Num Numero_Nota_Ri
                ,Aia.Invoice_Currency_Code Moeda
                ,Aia.Exchange_Rate "TAXA IMPLANTACAO"
                ,Ac.Exchange_Rate "TAXA DE PAGAMENTO"
                ,Aia.Invoice_Amount "VALOR ORIGINAL"
                ,Decode(Aia.Invoice_Currency_Code, 'BRL', Aia.Amount_Paid, Ac.Base_Amount) "VALOR PAGO"
                ,Decode(Aia.Exchange_Rate, NULL, 0, Aia.Invoice_Amount * Aia.Exchange_Rate) "VALOR MOEDA LOCAL"
                ,Apsa.Amount_Remaining "VALOR SALDO ORIGINAL"
                ,Decode(Aia.Exchange_Rate, NULL, 0, Apsa.Amount_Remaining * Aia.Exchange_Rate) "VALOR SALDO MOEDA LOCAL"
                ,Apsa.Due_Date "DATA VENCIMENTO"
                ,Trunc(Aipa.Accounting_Date) "DATA DA BAIXA"
                ,Trunc(Ac.Check_Date) "DATA DEBITO"
                ,Ac.Bank_Account_Name Banco
                ,Nvl(Ac.Payment_Method_Code, Apsa.Payment_Method_Code) "FORMA PAGAMENTO"
                ,Ac.Check_Date - Apsa.Due_Date "PRAZO MEDIO AGENDAMENTO"
                ,Aia.Gl_Date - Aia.Invoice_Date "PRAZO MEDIO LANCAMENTO"
                ,Ac.Check_Date - Aia.Invoice_Date "PRAZO MEDIO PAGAMENTO"
                ,Nvl(Po.Segment1
                   ,(SELECT Phall.Segment1
                      FROM Apps.Po_Headers_All Phall
                     WHERE Phall.Po_Header_Id = (SELECT Ailall.Po_Header_Id
                                                   FROM Apps.Ap_Invoice_Lines_All Ailall
                                                  WHERE Ailall.Invoice_Id = Aia.Invoice_Id
                                                    AND Rownum = 1))) "PEDIDO COMPRA"
                ,Nvl((SELECT Papf.Full_Name
                      FROM Apps.Po_Action_History Pah
                          ,Apps.Per_All_People_f  Papf
                     WHERE Pah.Object_Type_Code = 'PO'
                       AND Pah.Action_Code = 'APPROVE'
                       AND Pah.Employee_Id = Papf.Person_Id
                       AND Pah.Object_Id = Po.Po_Header_Id
                       AND Rownum = 1)
                   ,(SELECT Papf.Full_Name
                      FROM Apps.Po_Action_History Pah
                          ,Apps.Per_All_People_f  Papf
                     WHERE Pah.Object_Type_Code = 'PO'
                       AND Pah.Action_Code = 'APPROVE'
                       AND Pah.Employee_Id = Papf.Person_Id
                       AND Pah.Object_Id = (SELECT Ailall.Po_Header_Id
                                              FROM Apps.Ap_Invoice_Lines_All Ailall
                                             WHERE Ailall.Invoice_Id = Aia.Invoice_Id
                                               AND Rownum = 1)
                       AND Rownum = 1)) "APROVADOR PEDIDO"
                ,Nvl((SELECT DISTINCT Gcc.Segment1 || '.' || Gcc.Segment2 || '.' || Gcc.Segment3 || '.' || Gcc.Segment4 || '.' ||
                                    Gcc.Segment5 || '.' || Gcc.Segment6 || '.' || Gcc.Segment7 || '.' || Gcc.Segment8 || '.' ||
                                    Gcc.Segment9
                      FROM Apps.Gl_Code_Combinations Gcc
                     WHERE Gcc.Code_Combination_Id = Po.Dist_Code_Combination_Id
                       AND Rownum = 1)
                   ,(SELECT DISTINCT Gcc.Segment1 || '.' || Gcc.Segment2 || '.' || Gcc.Segment3 || '.' || Gcc.Segment4 || '.' ||
                                    Gcc.Segment5 || '.' || Gcc.Segment6 || '.' || Gcc.Segment7 || '.' || Gcc.Segment8 || '.' ||
                                    Gcc.Segment9
                      FROM Apps.Gl_Code_Combinations Gcc
                     WHERE Gcc.Code_Combination_Id = Aida2.Dist_Code_Combination_Id
                       AND Rownum = 1)) "CODE COMBINATION"
                ,Nvl((SELECT Ffv.Flex_Value || ' - ' || Ffvt.Description
                      FROM Apps.Fnd_Flex_Values      Ffv
                          ,Apps.Fnd_Flex_Values_Tl   Ffvt
                          ,Apps.Gl_Code_Combinations Gcc
                     WHERE Ffv.Flex_Value_Id = Ffvt.Flex_Value_Id
                       AND Ffvt.LANGUAGE = 'PTB'
                       AND Ffv.Flex_Value = Gcc.Segment4
                       AND Gcc.Code_Combination_Id = Aida2.Dist_Code_Combination_Id
                       AND Rownum = 1)
                   ,(SELECT Ffv.Flex_Value || ' - ' || Ffvt.Description
                      FROM Apps.Fnd_Flex_Values      Ffv
                          ,Apps.Fnd_Flex_Values_Tl   Ffvt
                          ,Apps.Gl_Code_Combinations Gcc
                     WHERE Ffv.Flex_Value_Id = Ffvt.Flex_Value_Id
                       AND Ffvt.LANGUAGE = 'PTB'
                       AND Ffv.Flex_Value = Gcc.Segment4
                       AND Gcc.Code_Combination_Id = Aida2.Dist_Code_Combination_Id
                       AND Rownum = 1)) "DESCRICAO CONTA"
                ,Aia.Invoice_Type_Lookup_Code "TIPO DE NOTA"
                ,Apsa.Payment_Status_Flag Status_Pagamento_Nota
  FROM Apps.Ap_Payment_Schedules_All Apsa
      ,Apps.Ap_Invoices_All Aia
      ,Apps.Po_Vendors Pv
      ,Apps.Ap_Invoice_Payments_All Aipa
      ,Apps.Ap_Checks_All Ac
      ,Apps.Ap_Invoice_Distributions_All Aida2
      ,(SELECT Pha.Segment1
              ,Pha.Po_Header_Id
              ,Ainva.Invoice_Id
              ,Aida.Dist_Code_Combination_Id
          FROM Apps.Po_Headers_All               Pha
              ,Apps.Ap_Invoice_Distributions_All Aida
              ,Apps.Ap_Invoice_Lines_All         Aila
              ,Apps.Ap_Invoices_All              Ainva
              ,Apps.Po_Distributions_All         Pda
         WHERE Aida.Invoice_Id = Aila.Invoice_Id
           AND Aida.Invoice_Line_Number = Aila.Line_Number
           AND Ainva.Invoice_Id = Aida.Invoice_Id
           AND Pda.Po_Header_Id = Pha.Po_Header_Id
           AND Pda.Po_Distribution_Id = Aida.Po_Distribution_Id) Po
      ,(SELECT Ri.Invoice_Id Invoice_Id
              ,Ri.Invoice_Num Invoice_Num
              ,Ri.Series Serie
              ,Ri.Organization_Id
              ,Ri.Invoice_Num_Ap
              ,(SELECT Od.Organization_Name
                  FROM Apps.Org_Organization_Definitions Od
                 WHERE Od.Organization_Id = Ri.Organization_Id) LOCAL
          FROM Apps.Cll_F189_Invoices Ri) Info_Ri
 WHERE Aia.Invoice_Id = Apsa.Invoice_Id
   AND Aipa.Invoice_Id(+) = Aia.Invoice_Id
   AND Ac.Check_Id(+) = Aipa.Check_Id
   AND Pv.Vendor_Id = Aia.Vendor_Id
   AND Po.Invoice_Id(+) = Aia.Invoice_Id
   AND Aida2.Invoice_Id(+) = Aia.Invoice_Id
   AND Info_Ri.Invoice_Num_Ap(+) = Aia.Invoice_Num
   AND Info_Ri.invoice_id = Aia.reference_key1
   --AND Trunc(Aipa.Accounting_Date) <= '31-AUG-2015'
   --and Aia.Invoice_Num = '21293'
   
