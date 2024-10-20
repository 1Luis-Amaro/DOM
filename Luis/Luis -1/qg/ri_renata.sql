     SELECT USUARIO,
            ORGANIZATION_ID,
            HR_INICIO_RI,
            HR_TERMINO_RI,
            STATUS_RI,
            ESTABELECIMENTO,
            RI,
            RI_REVERSAO,
            CPF_CNPJ,
            FORNECEDOR,
            IE,
            ENDERECO,
            UF_FORNECEDOR,
            DATA_ENTRADA_NF,
            DATA_EMISSAO_NF,
            NOTA_FISCAL,
            TIPO_NF,
            SERIE,
            MAX(VLR_LIQUIDO_NF) VLR_LIQUIDO_NF,
            MAX(VLR_TOTAL_NF)   VLR_TOTAL_NF,
            DT_PAGAMENTO,
            PESO_BRUTO,
            PESO_LIQUIDO,
            FRETE,
            RI_REFERENCIA,
            CNPJ_TRANSPORTADOR,
            NOME_TRANPORTADORA,
            VLR_FRETE,
            NF_FRETE,
            SUM (BS_ICMS)      BS_ICMS,
            MAX (ALQ_ICMS)     ALQ_ICMS,
            SUM (VLR_ICMS)     VLR_ICMS,
            SUM (VLR_ICMS_RECUPERACAO)  VLR_ICMS,
            SUM (VLR_ICMS_DIFERIDO)     VLR_ICMS,
            FLEX_CONTABIL_ICMS,
            SUM (BS_ICMS_ST)   BS_ICMS_ST,
            SUM (VLR_ICMS_ST)  VLR_ICMS_ST,
            FLEX_CONTABIL_ICMS_ST,
            SUM (BS_IPI)       BS_IPI,
            MAX (ALQ_IPI)      ALQ_IPI,
            SUM (VLR_IPI)      VLR_IPI,
            FLEX_CONTABIL_IPI,
            SUM (BS_PIS)       BS_PIS,
            MAX (ALQ_PIS)      ALQ_PIS,
            SUM (VLR_PIS)      VLR_PIS,
            FLEX_CONTABIL_PIS,
            SUM (BS_COFINS)    BS_COFINS,
            MAX (ALQ_COFINS)   ALQ_COFINS,
            SUM (VLR_COFINS)   VLR_COFINS,
            FLEX_CONTABIL_COFINS,
            BS_IR,
            ALQ_IR,
            VLR_IR,
            IR_TIPO_CONTRIBUICAO,
            IR_CATEGORIA,
            BS_INSS,
            VLR_INSS,
            ALQ_INSS,
            TIPO_SERVICO,
            GRUPO_RET_IMPOSTO,
            SUM (BS_ISS)       BS_ISS,
            SUM (VLR_ISS)      VLR_ISS,
            MAX (ALQ_ISS)      ALQ_ISS,
            COUNT (*)          Nr_Items,
            ELETRONIC_INVOICE_KEY,
            DESCRICAO_EMBALAGEM_TRANSPORTE,
            ORIGEM_DO_FRETE,            
            ESPECIE,
            CODIGO_PAGAMENTO,
            SUM(FRETE_INTERNACIONAL),
            SUM(IMPOSTO_IMPORTACAO),
            SUM(VALOR_FOB),
            SUM(VALOR_SEGURO),
            SUM(VALOR_PIS_RECUPERACAO),
            SUM(VALOR_COFINS_RECUPERACAO),
            SUM(BASE_IMPORTACAO_PIS_COFINS),
            SUM(PIS_IMPORTACAO),
            SUM(COFINS_IMPORTACAO),
            SUM(OUTRAS_DESP_INC_BASE_ICMS),
            SUM(OUTRAS_DESP_NOT_INC_BASE_ICMS),
            PROCESSO_IMPORT,
            NOTA_MAE,
            SERIE_MAE
       FROM APPS.XXPPG_CLL_RI_REPORTS_V
GROUP BY USUARIO,
            HR_INICIO_RI,
            HR_TERMINO_RI,
            STATUS_RI,
            ESTABELECIMENTO,
            RI,
            RI_REVERSAO,
            CPF_CNPJ,
            FORNECEDOR,
            IE,
            ENDERECO,
            UF_FORNECEDOR,
            DATA_ENTRADA_NF,
            NOTA_FISCAL,
            TIPO_NF,
            SERIE,
            DT_PAGAMENTO,
            PESO_BRUTO,
            PESO_LIQUIDO,
            FRETE,
            RI_REFERENCIA,
            CNPJ_TRANSPORTADOR,
            NOME_TRANPORTADORA,
            VLR_FRETE,
            NF_FRETE,
            FLEX_CONTABIL_ICMS,
            FLEX_CONTABIL_ICMS_ST,
            FLEX_CONTABIL_IPI,
            FLEX_CONTABIL_PIS,
            FLEX_CONTABIL_COFINS,
            BS_IR,
            ALQ_IR,
            VLR_IR,
            IR_TIPO_CONTRIBUICAO,
            IR_CATEGORIA,
            BS_INSS,
            VLR_INSS,
            ALQ_INSS,
            TIPO_SERVICO,
            GRUPO_RET_IMPOSTO,
            ORGANIZATION_ID,
            ELETRONIC_INVOICE_KEY,
            DATA_EMISSAO_NF,
            DESCRICAO_EMBALAGEM_TRANSPORTE,
            ORIGEM_DO_FRETE,            
            ESPECIE,
            CODIGO_PAGAMENTO,
            PROCESSO_IMPORT,
            NOTA_MAE,
            SERIE_MAE
   ORDER BY RI;
   
   
select pha.segment1 "Ordem Compra"
      ,pla.line_num "Linha"
      ,pla.item_description 
      ,pla.quantity
      ,USUARIO,
            xcl.ORGANIZATION_ID,
            xcl.HR_INICIO_RI,
            xcl.HR_TERMINO_RI,
            xcl.STATUS_RI,
            xcl.ESTABELECIMENTO,
            xcl.RI,
            xcl.RI_REVERSAO,
            xcl.CPF_CNPJ,
            xcl.FORNECEDOR,
            xcl.IE,
            xcl.ENDERECO,
            xcl.UF_FORNECEDOR,
            xcl.DATA_ENTRADA_NF,
            xcl.DATA_EMISSAO_NF,
            xcl.NOTA_FISCAL,
            xcl.TIPO_NF,
            xcl.SERIE,
            MAX(VLR_LIQUIDO_NF) VLR_LIQUIDO_NF,
            MAX(VLR_TOTAL_NF)   VLR_TOTAL_NF,
            DT_PAGAMENTO,
            PESO_BRUTO,
            PESO_LIQUIDO,
            FRETE,
            RI_REFERENCIA,
            CNPJ_TRANSPORTADOR,
            NOME_TRANPORTADORA,
            VLR_FRETE,
            NF_FRETE,
            SUM (BS_ICMS)      BS_ICMS,
            MAX (ALQ_ICMS)     ALQ_ICMS,
            SUM (VLR_ICMS)     VLR_ICMS,
            SUM (VLR_ICMS_RECUPERACAO)  VLR_ICMS,
            SUM (VLR_ICMS_DIFERIDO)     VLR_ICMS,
            FLEX_CONTABIL_ICMS,
            SUM (BS_ICMS_ST)   BS_ICMS_ST,
            SUM (VLR_ICMS_ST)  VLR_ICMS_ST,
            FLEX_CONTABIL_ICMS_ST,
            SUM (BS_IPI)       BS_IPI,
            MAX (ALQ_IPI)      ALQ_IPI,
            SUM (VLR_IPI)      VLR_IPI,
            FLEX_CONTABIL_IPI,
            SUM (BS_PIS)       BS_PIS,
            MAX (ALQ_PIS)      ALQ_PIS,
            SUM (VLR_PIS)      VLR_PIS,
            FLEX_CONTABIL_PIS,
            SUM (BS_COFINS)    BS_COFINS,
            MAX (ALQ_COFINS)   ALQ_COFINS,
            SUM (VLR_COFINS)   VLR_COFINS,
            FLEX_CONTABIL_COFINS,
            BS_IR,
            ALQ_IR,
            VLR_IR,
            IR_TIPO_CONTRIBUICAO,
            IR_CATEGORIA,
            BS_INSS,
            VLR_INSS,
            ALQ_INSS,
            TIPO_SERVICO,
            GRUPO_RET_IMPOSTO,
            SUM (BS_ISS)       BS_ISS,
            SUM (VLR_ISS)      VLR_ISS,
            MAX (ALQ_ISS)      ALQ_ISS,
            COUNT (*)          Nr_Items,
            xcl.ELETRONIC_INVOICE_KEY,
            DESCRICAO_EMBALAGEM_TRANSPORTE,
            ORIGEM_DO_FRETE,            
            ESPECIE,
            CODIGO_PAGAMENTO,
            SUM(FRETE_INTERNACIONAL),
            SUM(IMPOSTO_IMPORTACAO),
            SUM(VALOR_FOB),
            SUM(VALOR_SEGURO),
            SUM(VALOR_PIS_RECUPERACAO),
            SUM(VALOR_COFINS_RECUPERACAO),
            SUM(BASE_IMPORTACAO_PIS_COFINS),
            SUM(PIS_IMPORTACAO),
            SUM(COFINS_IMPORTACAO),
            SUM(OUTRAS_DESP_INC_BASE_ICMS),
            SUM(OUTRAS_DESP_NOT_INC_BASE_ICMS),
            PROCESSO_IMPORT,
            NOTA_MAE,
            SERIE_MAE
  from apps.cll_f189_invoice_lines cfil
      ,apps.cll_f189_invoices      cfi
      ,apps.po_line_locations_all  plla
      ,apps.po_lines_all           pla
      ,apps.po_headers_all         pha
      ,apps.po_distributions_all   pda
      ,APPS.XXPPG_CLL_RI_REPORTS_V xcl
where --cfi.invoice_num in ('16859')
  -- and cfi.organization_id   = 92
       xcl.invoice_line_id   = cfil.invoice_line_id 
   and cfil.invoice_id       = cfi.invoice_id
   and cfil.organization_id  = cfi.organization_id 
   and plla.line_location_id = cfil.line_location_id
   and pla.po_line_id        = plla.po_line_id
   and pda.line_location_id  = cfil.line_location_id
   and pda.po_line_id        = pla.po_line_id
   and pda.po_header_id      = plla.po_header_id
   and pha.po_header_id      = plla.po_header_id
   and DATA_ENTRADA_NF < sysdate - 86 
  -- and DATA_ENTRADA_NF > sysdate - 118
 GROUP BY xcl.USUARIO,
            xcl.HR_INICIO_RI,
            xcl.HR_TERMINO_RI,
            xcl.STATUS_RI,
            xcl.ESTABELECIMENTO,
            xcl.RI,
            xcl.RI_REVERSAO,
            xcl.CPF_CNPJ,
            xcl.FORNECEDOR,
            xcl.IE,
            xcl.ENDERECO,
            xcl.UF_FORNECEDOR,
            xcl.DATA_ENTRADA_NF,
            xcl.NOTA_FISCAL,
            xcl.TIPO_NF,
            xcl.SERIE,
            xcl.DT_PAGAMENTO,
            xcl.PESO_BRUTO,
            xcl.PESO_LIQUIDO,
            xcl.FRETE,
            xcl.RI_REFERENCIA,
            xcl.CNPJ_TRANSPORTADOR,
            xcl.NOME_TRANPORTADORA,
            xcl.VLR_FRETE,
            xcl.NF_FRETE,
            xcl.FLEX_CONTABIL_ICMS,
            xcl.FLEX_CONTABIL_ICMS_ST,
            xcl.FLEX_CONTABIL_IPI,
            xcl.FLEX_CONTABIL_PIS,
            xcl.FLEX_CONTABIL_COFINS,
            xcl.BS_IR,
            xcl.ALQ_IR,
            xcl.VLR_IR,
            xcl.IR_TIPO_CONTRIBUICAO,
            xcl.IR_CATEGORIA,
            xcl.BS_INSS,
            xcl.VLR_INSS,
            xcl.ALQ_INSS,
            xcl.TIPO_SERVICO,
            xcl.GRUPO_RET_IMPOSTO,
            xcl.ORGANIZATION_ID,
            xcl.ELETRONIC_INVOICE_KEY,
            xcl.DATA_EMISSAO_NF,
            xcl.DESCRICAO_EMBALAGEM_TRANSPORTE,
            xcl.ORIGEM_DO_FRETE,            
            xcl.ESPECIE,
            xcl.CODIGO_PAGAMENTO,
            xcl.PROCESSO_IMPORT,
            xcl.NOTA_MAE,
            xcl.SERIE_MAE,
            pha.segment1
           ,pla.line_num
           ,pla.item_description 
           ,pla.quantity
   ORDER BY RI;   
   
   
select sysdate - 86, sysdate - 118 from dual ;
   
select RI from APPS.XXPPG_CLL_RI_REPORTS_V
where DATA_ENTRADA_NF < sysdate - 86 
   and DATA_ENTRADA_NF > sysdate - 118;   
   
   xcl.RI,