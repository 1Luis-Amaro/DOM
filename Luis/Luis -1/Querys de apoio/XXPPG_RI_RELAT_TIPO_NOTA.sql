SELECT OOD.ORGANIZATION_CODE ORGANIZACAO_INVENTARIO,
       RIT.INVOICE_TYPE_CODE CODIGO,
       RIT.INACTIVE_DATE DATA_DE_INATIVACAO,
       RIT.DESCRIPTION DESCRICAO,     
      'Propriedades' separador1,     
      RIT.DOCUMENT_TYPE "Tipo de Documento Fiscal",
       DECODE(RIT.REQUISITION_TYPE,
              'CT',
              'Contrato',
              'NA',
              'Sem Pedido',
              'PO',
              'Compras',
              'RM',
              'rma') "Tipo de Documento (Requisicao)",
       DECODE(RIT.OPERATION_TYPE, 'E', 'Entrada', 'S', 'Saida') "Tipo de Operacao",
       DECODE(RIT.CONTAB_FLAG,
              'I',
              'Somente Imposto',
              'N',
              'Nao se Aplica',
              'P',
              'Compra/Pagamento',
              'S',
              'Compra') "Tipo Contabil",
       DECODE(RIT.CREDIT_DEBIT_FLAG,
              'D',
              'Nota de Debito',
              'C',
              'Nota de Credito') "Credito ou Debito",
       DECODE(RIT.FIXED_ASSETS_FLAG, 'N', 'Nao se aplica') "Interface de Ativos Fixos",
       DECODE(RIT.RETURN_CUSTOMER_FLAG,
              'F',
              'Devolucao ao Fornecedor',
              'N',
              'Nao se Aplica',
              'S',
              'Devolucao de Clientes') "Tipo de Devolucao",
       DECODE(RIT.PROJECT_FLAG, 'N', 'Nao se Aplica') "Interface do Oracle PA",
       DECODE(RIT.ENCUMBRANCE_FLAG, 'N', 'Nao se Aplica') REVERTE_EMPENHO,
       RIT.PARENT_FLAG "Tem NF-Pai",
       rit.RETURN_FLAG "NF de Devolucao",
       RIT.FISCAL_FLAG "Escrituracao",
       RIT.FOREIGN_CURRENCY_USAGE "Moeda Estrangeira",
       rit.PAYMENT_FLAG "Gera NFs de AP",
       RIT.FREIGHT_FLAG "Tipo de NF do Frete",
       RIT.PRICE_ADJUST_FLAG  "Ajuste de Preco",
       RIT.PERMANENT_ACTIVE_CREDIT_FLAG "Credito de Ativo Permanente",
       RIT.TAX_ADJUST_FLAG "Ajuste de Imposto",
       RIT.GENERATE_RETURN_INVOICE "Gera Transacao de Devolucao",
       RIT.COST_ADJUST_FLAG "Ajuste de Custo",
       rit.wms_flag "WMS - Recevbimento Fisico",
       rit.complex_service_flag "OC de Servico Complexo" ,
       RIT.BONUS_FLAG "Bonus",
       rit.utilities_flag  "Utilitarios",    
       'Impostos' separador2,      
       RIT.OPERATION_FISCAL_TYPE "Tipo de Operacao Fiscal", 
       RIT.ICMS_REDUCTION_PERCENT "Red Calc Base do ICMS",
       RIT.INCLUDE_ICMS_FLAG "ICMS Calculado" ,
       DECODE(RIT.IMPORT_ICMS_FLAG,
              'D',
              'Bruto Ate',
              'N',
              'Nao se Aplica') "ICMS de Importacao",
       RIT.INCLUDE_ISS_FLAG "ISS Calculado",
       RIT.INCLUDE_IPI_FLAG "IPI Calculado",
       RIT.PIS_FLAG "PIS Calculado",             
       RIT.EXCLUDE_ICMS_ST_FLAG "Exc ICMS ST valor tot NF",
       RIT.COFINS_FLAG "COFINS Calculado",
       rit.INCLUDE_IR_FLAG "IR calculado",
       RIT.INSS_CALCULATION_FLAG "INSS calculado",
       rit.INCLUDE_SEST_SENAT_FLAG "SEST/SENAT calculado",      
       'Interfaces' separador3,      
       rit.PAY_GROUP_LOOKUP_CODE "Grupo de Pagamento",
       rit.AR_TRANSACTION_TYPE_id "Tipo de Transacao",
       rit.ar_source_id "Origem AR/Faturamento",
       rit.IPI_TRIBUTARY_CODE_FLAG "Codigo Tributario do IPI",
       rit.AR_CRED_IPI_CATEGORY_id "Categoria Credito IPI",
       rit.AR_CRED_ICMS_CATEGORY_id "Categoria de Credito de ICMS",
       rit.AR_CRED_ICMS_ST_CATEGORY_id "Categ de Cred de ICMS ST",
       rit.AR_DEB_IPI_CATEGORY_id "Categoria Debito IPI",
       rit.AR_DEB_ICMS_CATEGORY_id "Categoria de Debito de ICMS",
       rit.AR_DEB_ICMS_ST_CATEGORY_id "Categoria de debito de ICMS ST",      
       'Contas de Passivo' separador4,      
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = CR_CODE_COMBINATION_ID) "Passivo/Transitorio",
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = DIFF_ICMS_CODE_COMBINATION_ID) "ICMS para Cobranca",         
         (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = IPI_LIABILITY_CCID) "IPI para Cobranca",        
            (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = ISS_CODE_COMBINATION_ID) "ISS para Cobranca",
        (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = IR_CODE_COMBINATION_ID) "IR para Cobranca",     
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = INSS_EXPENSE_CCID) "Despesas de INSS",              
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = IMPORT_TAX_CCID) "Encargos de Importacao",         
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = IMPORT_INSURANCE_CCID) "Importando Seguro",         
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = IMPORT_FREIGHT_CCID) "Importando Frete",         
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = IMPORT_EXPENSE_CCID) "Importacao Outras Despesas",         
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = SYMBOLIC_RETURN_CCID) "Devolucao Simbolica",              
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = CUSTOMER_CCID) "rma",
         (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = RMA_IPI_LIABILITY_CCID) "IPI para Cobranca (rma)",         
            (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = RMA_ICMS_LIABILITY_CCID) "ICMS para Cobranca (rma)",         
          (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = RMA_ICMS_ST_LIABILITY_CCID) "ICMS ST para Cobranca (rma)",                  
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = INSS_CODE_COMBINATION_ID) "INSS Substituto" ,     
     (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = siscomex_ccid) "siscomex",       
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = IMPORT_PIS_CCID) "Importando PIS",         
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = IMPORT_COFINS_CCID) "Importando COFINS",         
     (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = CUSTOMS_EXPENSE_CCID) "Despesas Personalizadas",         
     (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = ICMS_ST_ANT_CCID) "ICMS-ST Avanc Cobranca",         
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = FUNRURAL_CCID) "funrural",         
             (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = SEST_SENAT_CCID) "SEST/SENAT",
                         (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = collect_pis_ccid) "PIS a Recolher",
         (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = collect_cofins_ccid) "COFINS a Recolher",
       'Contas de Ativo' separador5,     
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = ICMS_CODE_COMBINATION_ID) "ICMS para Recuperacao",
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = ICMS_ST_CCID) "ICMS ST",
                (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = IPI_CODE_COMBINATION_ID) "IPI para Recuperacao",
              (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = ACCOUNT_RECEIVABLE_CCID) "Contas a Receber (rma)",                   
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = RMA_IPI_REDUCTION_CCID) "Reducao de IPI (rma)",
            (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = RMA_ICMS_REDUCTION_CCID) "Reducao de ICMS (rma)",
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = RMA_ICMS_ST_REDUCTION_CCID) "Reducao de ICMS ST (rma)",                          
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = PIS_CODE_COMBINATION_ID) "PIS para Recuperacao",       
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = VARIATION_COST_DEVOLUTION_CCID) "Variacao de Custo de Devolucao",                           
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = RMA_PIS_REDUCTION_CCID) "Reducao de PIS ST (rma)",         
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = RMA_COFINS_REDUCTION_CCID) "Reducao de COFINS ST (rma)",         
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = COFINS_CODE_COMBINATION_ID) "COFINS para Recuperacao",         
                (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = RMA_PIS_RED_CCID) "Reducao de PIS (rma)",         
       (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
         WHERE CODE_COMBINATION_ID = RMA_COFINS_RED_CCID) "Reducao de COFINS (rma)",         
                (SELECT SEGMENT1 || '-' || SEGMENT2 || '-' || SEGMENT3 || '-' ||
               SEGMENT4 || '-' || SEGMENT5 || '-' || SEGMENT6 || '-' ||
               SEGMENT7
          FROM GL.GL_CODE_COMBINATIONS
           WHERE CODE_COMBINATION_ID = ICMS_ST_ANT_CCID_RECUP) "ICMS-ST Avanc Rec"   ,
           RIT.ATTRIBUTE1 CONSIGNADO ,
           rit.attribute2 terceiros_P_F,
           rit.attribute3 Tipo_de_ordem_de_venda, 
           rit.attribute4  PSFRETE     
          FROM apps.cll_f189_INVOICE_TYPES RIT, APPS.ORG_ORGANIZATION_DEFINITIONS OOD
WHERE RIT.ORGANIZATION_ID = OOD.ORGANIZATION_ID
and  UPPER (RIT.INVOICE_TYPE_CODE) not like UPPER('%TESTE%')
   AND NVL(RIT.INACTIVE_DATE, SYSDATE + 1) > SYSDATE
ORDER BY 1, 2