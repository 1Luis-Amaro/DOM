CREATE OR REPLACE PACKAGE BODY PKG_R12_DBL_EXP_NOTA_FISCAL_RI is
--
C_ID_DESP_TX_SISCOMEX constant varchar2(20) := 'Taxa Emissão DI';
--
   -- BUSCA DIAS PAGAMENTO
   -- =================================================================
   FUNCTION FNC_CAIBR_RI_DIAS(p_n_PoHeaderId   IN NUMBER) RETURN NUMBER IS
   -- =================================================================
   Result number;
   --
   BEGIN
      IF NVL(FNC_R12_DBL_REGRA_CONFIGURACAO('ORACLE_MULTILINGUAGEM', null), 'S') = 'S' THEN
         SELECT AP.DIAS
         INTO   Result
         FROM   SFWBR_PO_PED_COMPRAS_V PO,
                SFWBR_AP_COND_PAGTO_V AP
         WHERE  AP.TERM_ID      = PO.ID_TERMO
         AND    PO.PO_HEADER_ID = p_n_PoHeaderId
         AND    PO.SEQUENCE_NUM = (SELECT MAX(SEQUENCE_NUM)
                                   FROM   SFWBR_PO_PED_COMPRAS_V
                                   WHERE  PO_HEADER_ID = p_n_PoHeaderId
                                  )
         AND    rownum          = 1;
      ELSE
         SELECT AP.DUE_DAYS
         INTO   Result
         FROM   SFWBR_PO_PED_COMPRAS_V PO,
                SFWBR_AP_TERMS_LINES_V AP
         WHERE  AP.TERM_ID      = PO.ID_TERMO
         AND    PO.PO_HEADER_ID = p_n_PoHeaderId
         AND    PO.SEQUENCE_NUM = (SELECT MAX(SEQUENCE_NUM)
                                   FROM   SFWBR_PO_PED_COMPRAS_V
                                   WHERE  PO_HEADER_ID = p_n_PoHeaderId
                                  )
         AND    rownum          = 1;
      END IF;
      --
      return(Result);
      --
   END FNC_CAIBR_RI_DIAS;

   -- BUSCAL O ID FORNECEDOR "ENTITY_ID"
   -- =================================================================
   FUNCTION FNC_CAIBR_RI_ENTITY_ID(p_n_PoHeaderId   IN NUMBER,
                                   p_n_VendorSiteId IN NUMBER DEFAULT NULL) RETURN NUMBER IS
   -- =================================================================
   Result number;
   --
   BEGIN
      if (p_n_PoHeaderId is not null) then
         SELECT RFE.ENTITY_ID
         INTO   Result
         FROM   SFWBR_REC_FISCAL_ENTITIES_V RFE,
                SFWBR_PO_PED_COMPRAS_V PO
         WHERE  PO.ID_SITE = RFE.VENDOR_SITE_ID
         AND    PO.PO_HEADER_ID = p_n_PoHeaderId
         AND    PO.SEQUENCE_NUM = (SELECT MAX(SEQUENCE_NUM)
                                   FROM   SFWBR_PO_PED_COMPRAS_V
                                   WHERE PO_HEADER_ID = p_n_PoHeaderId
                                  );
      elsif (p_n_VendorSiteId is not null) then
            Begin
               SELECT RFE.ENTITY_ID
               INTO   Result
               FROM   SFWBR_REC_FISCAL_ENTITIES_V RFE
               WHERE  RFE.VENDOR_SITE_ID = p_n_VendorSiteId
               AND    RFE.ENTITY_TYPE_LOOKUP_CODE = 'VENDOR_SITE';
               --
               Exception
                  When OTHERS Then
                     null;
            End;
      end if;
      --
      return(Result);
      --
   END FNC_CAIBR_RI_ENTITY_ID;

   -- =================================================================
   FUNCTION FNC_TAXA_SISCOMEX(p_ID_NF    IN NUMBER,
                              p_SEQ_ITEM IN NUMBER) RETURN NUMBER IS
   -- =================================================================
   /*
   * Function para retornar o valor de Taxa Siscomex
   *
   */
   Result    number;
   v_n_Valor number;
   --
   BEGIN
      begin
         select /*+ ordered use_nl(IAD) use_nl(MI) use_nl(IMI) use_nl(DIF) +*/
                nvl(round(sum(DIF.VALOR), 2), 0)
         into   v_n_Valor
         from   BS_ITENS_NF              INF,
                BS_ITEM_ADICAO           IAD,
                IS_MACRO_ITEM            MI,
                IS_ITEM_MACRO_ITEM       IMI,
                IS_DESPESAS_ITENS_FATURA DIF
         where  DIF.ID_INVOICE_MACRO = IMI.ID_INVOICE_MACRO
         and    DIF.COD_PECA_MACRO   = IMI.COD_PECA_MACRO
         and    DIF.NUM_ITEM_MACRO   = IMI.NUM_ITEM_MACRO
         and    DIF.NUM_ORDEM        = IMI.NUM_ORDEM
         and    DIF.COD_PECA         = IMI.COD_PECA
         and    DIF.NUM_ITEM         = IMI.NUM_ITEM
         and    DIF.ID_INVOICE       = IMI.ID_INVOICE
         and    DIF.ID_DESPESA       = C_ID_DESP_TX_SISCOMEX
         and    IMI.ID_INVOICE_MACRO = MI.ID_INVOICE_MACRO
         and    IMI.COD_PECA_MACRO   = MI.COD_PECA_MACRO
         and    IMI.NUM_ITEM_MACRO   = MI.NUM_ITEM_MACRO
         and    MI.ID_ITEM_FATURA    = IAD.ID_ITEM_REF
         and    IAD.PROCESSO_DI      = INF.PROCESSO_DI
         and    IAD.ID_ADICAO        = INF.ID_ADICAO
         and    IAD.ID_ITEM_ADICAO   = INF.ID_ITEM_ADICAO
         and    INF.ID_NOTAFISCAL    = p_ID_NF
         and    INF.SEQ_ITEM         = nvl(p_SEQ_ITEM, INF.SEQ_ITEM);
         --
         exception
            when others then
               return(-1);
      end;
      --
      begin
         select /*+ ordered use_nl(IDSI) use_nl(MI) use_nl(IMI) use_nl(DIF) +*/
                v_n_Valor + nvl(round(sum(DIF.VALOR), 2), 0)
         into   Result
         from   BS_ITENS_NF              INF,
                BS_ITEM_DSI              IDSI,
                IS_MACRO_ITEM            MI,
                IS_ITEM_MACRO_ITEM       IMI,
                IS_DESPESAS_ITENS_FATURA DIF
         where  DIF.ID_INVOICE_MACRO = IMI.ID_INVOICE_MACRO
         and    DIF.COD_PECA_MACRO   = IMI.COD_PECA_MACRO
         and    DIF.NUM_ITEM_MACRO   = IMI.NUM_ITEM_MACRO
         and    DIF.NUM_ORDEM        = IMI.NUM_ORDEM
         and    DIF.COD_PECA         = IMI.COD_PECA
         and    DIF.NUM_ITEM         = IMI.NUM_ITEM
         and    DIF.ID_INVOICE       = IMI.ID_INVOICE
         and    DIF.ID_DESPESA       = C_ID_DESP_TX_SISCOMEX
         and    IMI.ID_INVOICE_MACRO = MI.ID_INVOICE_MACRO
         and    IMI.COD_PECA_MACRO   = MI.COD_PECA_MACRO
         and    IMI.NUM_ITEM_MACRO   = MI.NUM_ITEM_MACRO
         and    MI.ID_ITEM_FATURA    = IDSI.ID_FATURA
         and    IDSI.PROCESSO_DSI    = INF.PROCESSO_DI
         and    IDSI.ID_ITEM_DSI     = INF.ID_ITEM_ADICAO
         and    INF.ID_NOTAFISCAL    = p_ID_NF
         and    INF.SEQ_ITEM         = nvl(p_SEQ_ITEM, INF.SEQ_ITEM);
         --
         exception
            when others then
               return(-1);
      end;
      --
      return(Result);
      --
   END FNC_TAXA_SISCOMEX;

   -- BUSCA ID DO ESTADO DO FORNECEDOR / IMPORTADOR
   -- =================================================================
   FUNCTION FNC_CAIBR_RI_STATE_ID(p_n_PoHeaderId IN NUMBER,
                                  p_n_LocationId IN NUMBER DEFAULT NULL) RETURN NUMBER IS
   -- =================================================================
   Result NUMBER;
   --
   BEGIN
      IF (p_n_PoHeaderId IS NOT NULL) THEN
         BEGIN
            SELECT RFE.STATE_ID
            INTO   Result
            FROM   SFWBR_REC_FISCAL_ENTITIES_V RFE,
                   SFWBR_PO_PED_COMPRAS_V PO
            WHERE  PO.ID_SITE                  = RFE.VENDOR_SITE_ID
            AND    RFE.ENTITY_TYPE_LOOKUP_CODE = 'VENDOR_SITE'
            AND    PO.PO_HEADER_ID             = p_n_PoHeaderId
            AND    PO.SEQUENCE_NUM             = (SELECT MAX(SEQUENCE_NUM)
                                                  FROM   SFWBR_PO_PED_COMPRAS_V
                                                  WHERE  PO_HEADER_ID = p_n_PoHeaderId
                                                 );
            --
            EXCEPTION
               WHEN OTHERS THEN
                  Result := NULL;
         END;
      ELSIF (p_n_LocationId IS NOT NULL) THEN
            BEGIN
               SELECT RFE.STATE_ID
               INTO   Result
               FROM   SFWBR_REC_FISCAL_ENTITIES_V RFE
               WHERE  RFE.LOCATION_ID             = p_n_LocationId
               AND    RFE.ENTITY_TYPE_LOOKUP_CODE = 'LOCATION';
               --
               EXCEPTION
                  WHEN OTHERS THEN
                     Result := NULL;
            END;
      END IF;
      --
      RETURN(Result);
      --
   END FNC_CAIBR_RI_STATE_ID;

   -- =================================================================
   PROCEDURE MAPEAMENTO_NOTA_FISCAL_RI(p_n_ID_IMPORTACAO IN NUMBER,
                                       p_n_ID_NOTAFISCAL IN NUMBER) IS
   -- =================================================================
   r_V_BS_API_NFE_NFC             V_BS_API_NFE_NFC%ROWTYPE;
   r_EBS_REC_INVOICES_INTERFACE   SFWBR_REC_INVO_INTER%ROWTYPE;
   r_EBS_REC_INVOICE_LINES_INT    SFWBR_REC_INVO_LINES_INTER%ROWTYPE;
   r_EBS_REC_INVO_PAR_INT         SFWBR_REC_INVO_PAR_INT%rowtype;
   r_EBS_REC_INVO_LINE_PAR_INT    SFWBR_REC_INVO_LINE_PAR_INT%rowtype;
   --
   v_n_PO_HEADER_ID               NUMBER;
   v_n_PO_LINE_ID                 NUMBER;
   v_s_PO_NUMBER                  V_BS_API_ITEM_NFE_NFC.NF_ITE_PEDIDO%TYPE;
   v_s_NUM_ORDEM                  V_BS_API_ITEM_NFE_NFC.NF_ITE_PEDIDO%TYPE;
   v_n_cod_peca                   NUMBER;
   v_s_Complementar               BS_NOTA_FISCAL.COMPLEMENTAR%TYPE;
   --
   v_s_RECOVER_PIS_FLAG_CNPJ      SFWBR_REC_UTIL_FISCAL_V.RECOVER_PIS_FLAG_CNPJ%TYPE;
   v_s_RECOVER_COFINS_FLAG_CNPJ   SFWBR_REC_UTIL_FISCAL_V.RECOVER_COFINS_FLAG_CNPJ%TYPE;
   v_s_RECUPERA_IPI               SFWBR_REC_UTIL_FISCAL_V.RECUPERA_IPI%TYPE;
   v_s_RECUPERA_ICMS              SFWBR_REC_UTIL_FISCAL_V.RECUPERA_ICMS%TYPE;
   --
   v_n_TxSiscomex                 NUMBER;
   v_n_TxSiscomexUSD              NUMBER;
   v_TxSiscomexCompoe_VrTotNF     CHAR(1);
   v_s_CFOP_COMP                  VARCHAR2(100);
   v_s_CFOP_COMP_original         BS_NOTA_FISCAL.CFOP_COMPLEMENTAR%TYPE;
   v_s_TP_ORDEM                   VARCHAR2(100);
   v_s_InvoiceTypeCode            VARCHAR2(100);
   --
   v_s_flag_incoterm_frete        CHAR(1);
   v_s_flag_incoterm_seguro       CHAR(1);
   --
   v_n_precisao_decimal           NUMBER := 2;
   --
   v_n_exit_return                varchar2(4000);
   --
   v_n_VENDOR_SITE_ID             NUMBER;
   --
   v_s_ELETRONIC_INVOICE_KEY      V_BS_API_NFE_NFC.NF_NFE_SEFAZ_CHAVE_ACESSO%TYPE;
   --
   v_s_flag_despesas_com_pis      varchar2(1);
   v_s_flag_despesas_com_cofins   varchar2(1);
   v_s_gera_nf_vmle               varchar2(1);
   v_s_soma_desp_vlr_unit_nf      varchar2(1);
   v_s_gera_nf_vmld               varchar2(1);
   --
   v_n_tot_desp_compoe_icms     number := 0;
   v_n_tot_desp_n_compoe_icms   number := 0;
   v_n_aux                      number := 0;
   v_n_tot_desp_compoe_icms_h   number := 0;
   v_n_tot_desp_n_compoe_icms_h number := 0;
   --
   v_s_ii_valor_unit              varchar2(1);
   v_s_ii_outras_desp             varchar2(1);
   v_s_ii_outras_desp_comp        varchar2(1);
   BEGIN
      -- ponto de customizacao
      pkg_it_user_exit.call_user_exits(p_s_exit_name => 'PKG_R12_DBL_EXP_NOTA_FISCAL_RI.MAPEAMENTO_NOTA_FISCAL_RI.BEGIN',
                                       param_in_1    => to_char(p_n_ID_IMPORTACAO),
                                       param_in_2    => to_char(p_n_ID_NOTAFISCAL),
                                       param_out_1   => v_n_exit_return);
      --
      begin
         select *
         into   r_V_BS_API_NFE_NFC
         from   V_BS_API_NFE_NFC
         where  nf_id = p_n_ID_NOTAFISCAL;
         --
         exception
            when OTHERS then
               raise_application_error(-20000,
                                'Erro ao recuperar a nota fiscal da view V_IS_IT_NFE_NFC onde NF_ID = ' ||
                                NVL(TO_CHAR(p_n_ID_NOTAFISCAL), 'NULL') || '. ' ||
                                sqlerrm);
      end;
      --
      begin
         Begin
            select complementar
            Into   v_s_Complementar
            from   bs_nota_fiscal
            where  id_notafiscal = p_n_ID_NOTAFISCAL;
            --
            Exception
               When OTHERS THEN
                  raise_application_error(-20000,
                                  'Erro ao recuperar a nota fiscal da tabela BS_NOTA_FISCAL onde NF_ID = ' ||
                                  NVL(TO_CHAR(p_n_ID_NOTAFISCAL), 'NULL') || '. ' ||
                                  sqlerrm);
         End;
         --
         -- Busca o Ato para informar ao RI quando for Drawback
         iF r_V_BS_API_NFE_NFC.NF_NATOPE = '3127' Then
            Begin
               Select IO.REFERENCIA_ATO_DB
               into   r_EBS_REC_INVOICES_INTERFACE.PROCESS_INDICATOR
               from   IS_ITENS_ORDEM IO
               where  IO.NUM_ORDEM = (Select INF.NF_ITE_PEDIDO
                                      from   V_BS_API_ITEM_NFE_NFC INF
                                      where  INF.NF_ITE_NFID = p_n_ID_NOTAFISCAL
                                      and    rownum          = 1
                                     )
               and    ROWNUM       = 1;
               --
               exception
                  When NO_DATA_FOUND then
                     raise_application_error(-20000,
                                    'Erro ao recuperar o Ato concessório nos itens da Ordem. ' ||
                                    sqlerrm);
            end;
         End if;
         --
         SELECT SFWBR_REC_INVO_INTER_S.nextval
         INTO   r_EBS_REC_INVOICES_INTERFACE.INTERFACE_INVOICE_ID
         FROM   DUAL;
         --
         r_EBS_REC_INVOICES_INTERFACE.INTERFACE_OPERATION_ID         := r_EBS_REC_INVOICES_INTERFACE.INTERFACE_INVOICE_ID;
         -- campos fixos
         r_EBS_REC_INVOICES_INTERFACE.CREATED_BY                     := -1;
         r_EBS_REC_INVOICES_INTERFACE.LAST_UPDATED_BY                := -1;
         r_EBS_REC_INVOICES_INTERFACE.ADDITIONAL_AMOUNT              := 0;
         r_EBS_REC_INVOICES_INTERFACE.ADDITIONAL_TAX                 := 0;
         r_EBS_REC_INVOICES_INTERFACE.DIFF_ICMS_AMOUNT               := 0;
         r_EBS_REC_INVOICES_INTERFACE.DIFF_ICMS_AMOUNT_RECOVER       := 0;
         r_EBS_REC_INVOICES_INTERFACE.DIFF_ICMS_TAX                  := 0;
         r_EBS_REC_INVOICES_INTERFACE.DOLLAR_CUSTOMS_EXPENSE         := 0;
         r_EBS_REC_INVOICES_INTERFACE.CUSTOMS_EXPENSE_FUNC           := 0;
         r_EBS_REC_INVOICES_INTERFACE.FREIGHT_AMOUNT                 := 0;
         r_EBS_REC_INVOICES_INTERFACE.ICMS_TAX                       := 0;
         r_EBS_REC_INVOICES_INTERFACE.IMPORTATION_EXPENSE_DOL        := 0;
         r_EBS_REC_INVOICES_INTERFACE.INSS_AMOUNT                    := 0;
         r_EBS_REC_INVOICES_INTERFACE.INSS_AUTONOMOUS_AMOUNT         := 0;
         r_EBS_REC_INVOICES_INTERFACE.INSS_AUTONOMOUS_INVOICED_TOTAL := 0;
         r_EBS_REC_INVOICES_INTERFACE.INSS_AUTONOMOUS_TAX            := 0;
         r_EBS_REC_INVOICES_INTERFACE.INSS_BASE                      := 0;
         r_EBS_REC_INVOICES_INTERFACE.INSS_TAX                       := 0;
         r_EBS_REC_INVOICES_INTERFACE.INSURANCE_AMOUNT               := 0;
         r_EBS_REC_INVOICES_INTERFACE.IR_AMOUNT                      := 0;
         r_EBS_REC_INVOICES_INTERFACE.IR_BASE                        := 0;
         r_EBS_REC_INVOICES_INTERFACE.IR_TAX                         := 0;
         r_EBS_REC_INVOICES_INTERFACE.ISS_AMOUNT                     := 0;
         r_EBS_REC_INVOICES_INTERFACE.ISS_BASE                       := 0;
         r_EBS_REC_INVOICES_INTERFACE.ISS_TAX                        := 0;
         r_EBS_REC_INVOICES_INTERFACE.PAYMENT_DISCOUNT               := 0;
         r_EBS_REC_INVOICES_INTERFACE.SOURCE_ITEMS                   := 1;
         r_EBS_REC_INVOICES_INTERFACE.PROCESS_FLAG                   := '1';
         r_EBS_REC_INVOICES_INTERFACE.IR_VENDOR                      := '4';
         r_EBS_REC_INVOICES_INTERFACE.FREIGHT_FLAG                   := 'N';
         --
         -- Tratamento ST ICMS
         begin
            select nvl(sum(Nf_Ite_Base_Icms_St), 0),
                   nvl(sum(Nf_Ite_Valor_Icms_St), 0)
            into   r_EBS_REC_INVOICES_INTERFACE.icms_st_base,
                   r_EBS_REC_INVOICES_INTERFACE.icms_st_amount
            from   V_BS_API_ITEM_NFE_NFC
            where  NF_ITE_NFID = r_V_BS_API_NFE_NFC.NF_ID;
            --
            Exception
               When OTHERS Then
                  raise_application_error(-20000,
                                    'Não foi possível recuperar o valor total do ICMS ST na View do Broker (V_BS_API_ITEM_NFE_NFC) ID_notafiscal: ' ||
                                    r_V_BS_API_NFE_NFC.NF_ID||
                                    ' num_nf: '||r_V_BS_API_NFE_NFC.NF_NUMNF||
                                    ' Serie: '||r_V_BS_API_NFE_NFC.NF_SERIE||
                                    ' Error: '||sqlerrm );
         End;
    begin
      select a.gera_nf_vmld_ii
        into v_s_gera_nf_vmld
        from bs_importadores a, sfw_parceiro b
       where a.id_informante = b.id_parceiro
         and b.cod_parceiro = r_V_BS_API_NFE_NFC.nf_empresa;
      exception
      when others then
        v_s_gera_nf_vmld := 'S';
    end;
         --
         r_EBS_REC_INVOICES_INTERFACE.ICMS_ST_AMOUNT_RECOVER         := 0;
         -- Fim Tratamento ST ICMS
         --
         r_EBS_REC_INVOICES_INTERFACE.FISCAL_DOCUMENT_MODEL          := FNC_R12_DBL_GET_DE_PARA('FISCAL_DOCUMENT_MODEL','IS_OUT_NF_RI');
         r_EBS_REC_INVOICES_INTERFACE.SOURCE                         := FNC_R12_DBL_GET_DE_PARA('SOURCE','IS_OUT_NF_RI');
         r_EBS_REC_INVOICES_INTERFACE.CREATION_DATE                  := SYSDATE;
         r_EBS_REC_INVOICES_INTERFACE.GL_DATE                        := SYSDATE;
         r_EBS_REC_INVOICES_INTERFACE.LAST_UPDATE_DATE               := SYSDATE;
         --
         IF NVL(FNC_R12_DBL_REGRA_CONFIGURACAO('ENVIA_RECEIVE_DATE_PARA_RI',NULL),'N') = 'S' THEN
            r_EBS_REC_INVOICES_INTERFACE.RECEIVE_DATE                   := SYSDATE;
         ELSE
            r_EBS_REC_INVOICES_INTERFACE.RECEIVE_DATE                   := NULL;
         END IF;
         --
         -- campos extraidos diretamente da view
         r_EBS_REC_INVOICES_INTERFACE.INVOICE_DATE                   := r_V_BS_API_NFE_NFC.NF_DTEMIS;
         r_EBS_REC_INVOICES_INTERFACE.TERMS_DATE                     := r_V_BS_API_NFE_NFC.NF_DTEMIS;
         r_EBS_REC_INVOICES_INTERFACE.SERIES                         := r_V_BS_API_NFE_NFC.NF_SERIE;
         r_EBS_REC_INVOICES_INTERFACE.DOCUMENT_NUMBER                := NULL;
         r_EBS_REC_INVOICES_INTERFACE.IMPORTATION_NUMBER             := r_V_BS_API_NFE_NFC.NF_NUMERO_DI; --'DI: ' ||r_V_BS_API_NFE_NFC.NF_NUMERO_DI ||' PROCESSO: ' ||r_V_BS_API_NFE_NFC.NF_COD_PROCESSO;
         --
         If r_EBS_REC_INVOICES_INTERFACE.IMPORTATION_NUMBER is null then
            r_EBS_REC_INVOICES_INTERFACE.IMPORTATION_NUMBER           := '9999999999';
            r_EBS_REC_INVOICES_INTERFACE.ALTERNATE_CURRENCY_CONV_RATE := r_V_BS_API_NFE_NFC.NF_TAXA_FOB;
         end if;
         --
         r_EBS_REC_INVOICES_INTERFACE.INVOICE_WEIGHT                 := r_V_BS_API_NFE_NFC.NF_PESOBR;
         r_EBS_REC_INVOICES_INTERFACE.PO_CONVERSION_RATE             := 1 /r_V_BS_API_NFE_NFC.NF_TAXA_DI;
         --
         r_EBS_REC_INVOICES_INTERFACE.INVOICE_NUM                    := PKG_R12_DBL_EXP.STR_SIGNIFIC(r_V_BS_API_NFE_NFC.NF_NUMNF,15);
         r_EBS_REC_INVOICES_INTERFACE.CIN_ATTRIBUTE1                 := r_V_BS_API_NFE_NFC.NF_ID;
         r_EBS_REC_INVOICES_INTERFACE.CIN_ATTRIBUTE2                 := r_V_BS_API_NFE_NFC.NF_FOB_MO;
         r_EBS_REC_INVOICES_INTERFACE.di_date                        := r_V_BS_API_NFE_NFC.NF_DATA_REGISTRO_DI;
         r_EBS_REC_INVOICES_INTERFACE.clearance_date                 := r_V_BS_API_NFE_NFC.NF_DATA_DESEMBARACO;
         r_EBS_REC_INVOICES_INTERFACE.CIN_ATTRIBUTE3                 := r_V_BS_API_NFE_NFC.NF_COD_PROCESSO;
         --
         r_EBS_REC_INVOICES_INTERFACE.CIN_ATTRIBUTE_CATEGORY         := 'SOFTWAY';
         --
         r_EBS_REC_INVOICES_INTERFACE.ELETRONIC_INVOICE_KEY          := r_V_BS_API_NFE_NFC.NF_NFE_SEFAZ_CHAVE_ACESSO;
         --
         -- Verifica se deve mandar a NF para o AR
         if nvl(FNC_R12_DBL_REGRA_CONFIGURACAO('ENVIA_NF_IMPORTACAO_PARA_AR',null),'N') = 'S' then
           r_EBS_REC_INVOICES_INTERFACE.ceo_attribute1 := p_n_id_importacao;
           r_EBS_REC_INVOICES_INTERFACE.ceo_attribute2 := FNC_R12_DBL_GET_DE_PARA('CONTEXT', 'IS_OUT_NF_AR');
         end if;
         --
         Begin
            Select FLAG_FRETE,
                   FLAG_SEGURO
            into   v_s_flag_incoterm_frete,
                   v_s_flag_incoterm_seguro
            From   SFW_TAB_INCOTERMS_VENDA_SISCOM
            Where  CODIGO = r_V_BS_API_NFE_NFC.NF_INCOTERM;
            --
            Exception
               When OTHERS Then
                  raise_application_error(-20000,'Não foi possível identificar o Incoterm a partir do código da View do Broker (): '|| r_V_BS_API_NFE_NFC.NF_INCOTERM);
         End;
         -- campos calculados
         r_EBS_REC_INVOICES_INTERFACE.TOTAL_CIF_AMOUNT               := round(is_calculavalormoeda(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                                                                   r_V_BS_API_NFE_NFC.NF_MOEDA,
                                                                                                   'REAL',
                                                                                                   r_V_BS_API_NFE_NFC.NF_FOB_MO) +
                                                                              is_calculavalormoeda(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                                                                   r_V_BS_API_NFE_NFC.NF_MOEDA,
                                                                                                   'REAL',
                                                                                                   r_V_BS_API_NFE_NFC.NF_FRETE_MO) +
                                                                              is_calculavalormoeda(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                                                                   r_V_BS_API_NFE_NFC.NF_MOEDA,
                                                                                                   'REAL',
                                                                                                   r_V_BS_API_NFE_NFC.NF_SEGURO_MO),
                                                                              v_n_precisao_decimal);
         r_EBS_REC_INVOICES_INTERFACE.DOLLAR_TOTAL_CIF_AMOUNT        := round(is_calculavalormoeda(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                                                                   'REAL',
                                                                                                   'USD',
                                                                                                   r_EBS_REC_INVOICES_INTERFACE.TOTAL_CIF_AMOUNT),
                                                                              v_n_precisao_decimal);
         r_EBS_REC_INVOICES_INTERFACE.IMPORTATION_COFINS_AMOUNT      := nvl(round(r_V_BS_API_NFE_NFC.NF_VRT_COFINS,
                                                                                  v_n_precisao_decimal),
                                                                            0);
         r_EBS_REC_INVOICES_INTERFACE.DOLLAR_IMPORT_COFINS_AMOUNT    := nvl(round(is_calculavalormoeda(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                                                                       'REAL',
                                                                                                       'USD',
                                                                                                       r_EBS_REC_INVOICES_INTERFACE.IMPORTATION_COFINS_AMOUNT),
                                                                                  v_n_precisao_decimal),
                                                                            0);
         r_EBS_REC_INVOICES_INTERFACE.TOTAL_FOB_AMOUNT               := round(is_calculavalormoeda(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                                                                   r_V_BS_API_NFE_NFC.NF_MOEDA,
                                                                                                   'REAL',
                                                                                                   r_V_BS_API_NFE_NFC.NF_FOB_MO),
                                                                              v_n_precisao_decimal);
         r_EBS_REC_INVOICES_INTERFACE.DOLLAR_TOTAL_FOB_AMOUNT        := round(is_calculavalormoeda(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                                                                   'REAL',
                                                                                                   'USD',
                                                                                                   r_EBS_REC_INVOICES_INTERFACE.TOTAL_FOB_AMOUNT),
                                                                              v_n_precisao_decimal);
         --
-- Início Alteração - Marcos R. Carneiro - Chamado: 429944...
--         IF r_V_BS_API_NFE_NFC.NF_TPNOTA <> 'ND' then
         -- ND - Nota Fiscal de Entrada Complementar.
         -- NC - Nota Fiscal de Entrada Complementar Manual.
         IF r_V_BS_API_NFE_NFC.NF_TPNOTA NOT IN ('ND','NC') THEN
-- Final Alteração - Marcos R. Carneiro - Chamado: 429944...
            r_EBS_REC_INVOICES_INTERFACE.FREIGHT_INTERNATIONAL        := round(is_calculavalormoeda(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                                                             r_V_BS_API_NFE_NFC.NF_MOEDA_FRETE,
                                                                                             'REAL',
                                                                                             r_V_BS_API_NFE_NFC.NF_FRETE_MO),
                                                                        v_n_precisao_decimal);
            r_EBS_REC_INVOICES_INTERFACE.IMPORTATION_INSURANCE_AMOUNT := round(is_calculavalormoeda(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                                                                    r_V_BS_API_NFE_NFC.NF_MOEDA_SEGURO,
                                                                                                    'REAL',
                                                                                                    r_V_BS_API_NFE_NFC.NF_SEGURO_MO),
                                                                               v_n_precisao_decimal);
         ELSE
            r_EBS_REC_INVOICES_INTERFACE.FREIGHT_INTERNATIONAL        := 0;
            r_EBS_REC_INVOICES_INTERFACE.IMPORTATION_INSURANCE_AMOUNT := 0;
         END IF;
         --
         r_EBS_REC_INVOICES_INTERFACE.DOLLAR_FREIGHT_INTERNATIONAL   := round(is_calculavalormoeda(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                                                                    'REAL',
                                                                                                    'USD',
                                                                                                    r_EBS_REC_INVOICES_INTERFACE.FREIGHT_INTERNATIONAL),
                                                                              v_n_precisao_decimal);
         r_EBS_REC_INVOICES_INTERFACE.DOLLAR_INSURANCE_AMOUNT        := round(is_calculavalormoeda(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                                                                    'REAL',
                                                                                                    'USD',
                                                                                                    r_EBS_REC_INVOICES_INTERFACE.IMPORTATION_INSURANCE_AMOUNT),
                                                                              v_n_precisao_decimal);
         --
         r_EBS_REC_INVOICES_INTERFACE.IMPORTATION_TAX_AMOUNT        := round(r_V_BS_API_NFE_NFC.NF_II,
                                                                          v_n_precisao_decimal);
         r_EBS_REC_INVOICES_INTERFACE.DOLLAR_IMPORTATION_TAX_AMOUNT := round(is_calculavalormoeda(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                                                               'REAL',
                                                                                               'USD',
                                                                                               r_EBS_REC_INVOICES_INTERFACE.IMPORTATION_TAX_AMOUNT),
                                                                          v_n_precisao_decimal);
         r_EBS_REC_INVOICES_INTERFACE.IMPORTATION_PIS_AMOUNT        := nvl(round(r_V_BS_API_NFE_NFC.NF_VRT_PIS,
                                                                              v_n_precisao_decimal),
                                                                        0);
         r_EBS_REC_INVOICES_INTERFACE.DOLLAR_IMPORTATION_PIS_AMOUNT := nvl(round(is_calculavalormoeda(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                                                                   'REAL',
                                                                                                   'USD',
                                                                                                   r_EBS_REC_INVOICES_INTERFACE.IMPORTATION_PIS_AMOUNT),
                                                                              v_n_precisao_decimal),
                                                                        0);
         --ICMS
         if r_V_BS_API_NFE_NFC.NF_VRICMS is null or
            r_V_BS_API_NFE_NFC.NF_VRICMS = 0 Then
            r_EBS_REC_INVOICES_INTERFACE.ICMS_AMOUNT := 0;
            r_EBS_REC_INVOICES_INTERFACE.ICMS_BASE   := 0;
         Else
            r_EBS_REC_INVOICES_INTERFACE.ICMS_AMOUNT := nvl(round(r_V_BS_API_NFE_NFC.NF_VRICMS,
                                                              v_n_precisao_decimal),
                                                        0);
            r_EBS_REC_INVOICES_INTERFACE.ICMS_BASE   := NVL(r_V_BS_API_NFE_NFC.NF_BASEICMS,
                                                        0);
         End If;
         --
         --IPI
         if r_V_BS_API_NFE_NFC.NF_VRIPI is null or
            r_V_BS_API_NFE_NFC.NF_VRIPI = 0 Then
            r_EBS_REC_INVOICES_INTERFACE.IPI_AMOUNT := 0;
         Else
            r_EBS_REC_INVOICES_INTERFACE.IPI_AMOUNT := nvl(round(r_V_BS_API_NFE_NFC.NF_VRIPI,
                                                             v_n_precisao_decimal),
                                                       0);
         End If;
         --
         r_EBS_REC_INVOICES_INTERFACE.INVOICE_AMOUNT        := round(r_V_BS_API_NFE_NFC.NF_VRTOTAL,
                                                                  v_n_precisao_decimal);
         r_EBS_REC_INVOICES_INTERFACE.DOLLAR_INVOICE_AMOUNT := round(is_calculavalormoeda(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                                                       'REAL',
                                                                                       'USD',
                                                                                       r_EBS_REC_INVOICES_INTERFACE.INVOICE_AMOUNT),
                                                                  v_n_precisao_decimal);
         r_EBS_REC_INVOICES_INTERFACE.GROSS_TOTAL_AMOUNT    := round(r_V_BS_API_NFE_NFC.NF_VRTOTAL,
                                                                  v_n_precisao_decimal);
-- Início Alteração - Marcos R. Carneiro - Chamado: 429944...
--         if r_V_BS_API_NFE_NFC.NF_TPNOTA = 'ND' Then
         -- ND - Nota Fiscal de Entrada Complementar.
         -- NC - Nota Fiscal de Entrada Complementar Manual.
         if r_V_BS_API_NFE_NFC.NF_TPNOTA IN ('ND','NC') THEN
-- Final Alteração - Marcos R. Carneiro - Chamado: 429944...
            r_EBS_REC_INVOICES_INTERFACE.OTHER_EXPENSES := 0;
         Else
            r_EBS_REC_INVOICES_INTERFACE.OTHER_EXPENSES := nvl(round(r_V_BS_API_NFE_NFC.NF_VRDESPESA,
                                                                 v_n_precisao_decimal),
                                                           0);
      if NVL(FNC_R12_DBL_GET_DE_PARA('PACK_16', 'PATCH_RI'), 'N') = 'S' then
        r_EBS_REC_INVOICES_INTERFACE.siscomex_amount := nvl(r_EBS_REC_INVOICES_INTERFACE.other_expenses,0);
        r_EBS_REC_INVOICES_INTERFACE.OTHER_EXPENSES := 0;
      end if;
         End If;
         --
         --  Fim subtrair PIS e COFINS de despesas para chegar ao valor de SISCOMEX
         --Tipo do Documento
         If r_V_BS_API_NFE_NFC.NF_TIPO_DI = 'S' then
            -- Se for DSI
            r_EBS_REC_INVOICES_INTERFACE.IMPORT_DOCUMENT_TYPE := 1;
         elsif r_V_BS_API_NFE_NFC.NF_TIPO_DI = 'N' then
               -- se for DI
               r_EBS_REC_INVOICES_INTERFACE.IMPORT_DOCUMENT_TYPE := 0;
         end if;
         --
         r_EBS_REC_INVOICES_INTERFACE.Importation_Freight_Weight := r_V_BS_API_NFE_NFC.NF_PESOBR;
         -- TAXA_SISCOMEX
         select decode(nvl(COMPOE_VLR_NF, 'N'),
                    'N',
                    nvl(OBRIGATORIA_NFE, 'N'),
                    'S')
         into   v_TxSiscomexCompoe_VrTotNF
         from   SFW_IMPORTADOR_DESPESA
         where  ID_INFORMANTE in (SELECT ID_PARCEIRO
                                  FROM   SFW_PARCEIRO
                                  WHERE  COD_PARCEIRO = r_V_BS_API_NFE_NFC.NF_EMPRESA
                                 )
         and    ID_DESPESA = C_ID_DESP_TX_SISCOMEX;
         --
         v_n_TxSiscomex    := round(FNC_TAXA_SISCOMEX(p_n_ID_NOTAFISCAL,
                                                   to_number(NULL)),
                                 v_n_precisao_decimal);
         v_n_TxSiscomexUSD := round(IS_CALCULAVALORMOEDA(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                      'REAL',
                                                      'USD',
                                                      v_n_TxSiscomex),
                                 v_n_precisao_decimal);
         --
         r_EBS_REC_INVOICES_INTERFACE.IMPORTATION_EXPENSE_FUNC  := 0; --r_EBS_REC_INVOICES_INTERFACE.OTHER_EXPENSES - r_EBS_REC_INVOICES_INTERFACE.SISCOMEX_AMOUNT;
         --
         r_EBS_REC_INVOICES_INTERFACE.DESCRIPTION := NVL(FNC_R12_DBL_GET_DE_PARA(r_V_BS_API_NFE_NFC.NF_TPNOTA,'IS_OUT_TIPO_NF_RI'),'TIPO DE NOTA FISCAL NAO CONFIGURADO NO DE_PARA: [IS_OUT_TIPO_NF_RI]');
         --
         if r_V_BS_API_NFE_NFC.NF_TAXA_DI <> 0 then
            r_EBS_REC_INVOICES_INTERFACE.ALTERNATE_CURRENCY_CONV_RATE := r_V_BS_API_NFE_NFC.NF_TAXA_DI ;
         end if;
         --
         if r_V_BS_API_NFE_NFC.NF_ISENTAICMS <> 0 then
            r_EBS_REC_INVOICES_INTERFACE.ICMS_TYPE := 'ISENTO';
         else
            r_EBS_REC_INVOICES_INTERFACE.ICMS_TYPE := 'NORMAL';
         end if;
         --
         BEGIN
            SELECT SUBSTR(INF.NF_ITE_PEDIDO,1,INSTR(INF.NF_ITE_PEDIDO,'.')-1),
                   INF.NF_ITE_PEDIDO
            INTO   v_s_PO_NUMBER,
                   v_s_NUM_ORDEM
            FROM   V_BS_API_ITEM_NFE_NFC INF
            WHERE  INF.NF_ITE_NFID = r_V_BS_API_NFE_NFC.NF_ID
            AND    ROWNUM = 1;
            --
            EXCEPTION
               WHEN OTHERS THEN
                  raise_application_error(-20000,'Erro ao recuperar NUM_ORDEM / PO_NUMBER da NF NUM: ' || r_V_BS_API_NFE_NFC.NF_NUMNF ||
                                  ', ID: '  || r_V_BS_API_NFE_NFC.NF_ID ||
                                  '. msg: ' || SQLERRM);
         END;
         --
         BEGIN
            SELECT NF.CFOP_COMPLEMENTAR
            INTO   v_s_CFOP_COMP
            FROM   BS_NOTA_FISCAL NF
            WHERE  NF.ID_NOTAFISCAL = r_V_BS_API_NFE_NFC.NF_ID;
            --
            EXCEPTION
               WHEN OTHERS THEN
                  raise_application_error(-20000,'Erro ao recuperar o CFOP Complementar da NF NUM: ' || r_V_BS_API_NFE_NFC.NF_NUMNF ||
                                                 ', ID: '  || r_V_BS_API_NFE_NFC.NF_ID ||
                                                 '. msg: ' || SQLERRM);
         END;
         --
         BEGIN
            SELECT DECODE(T.DESCRICAO,'INTERNAL_REQUISITION','OE','PO')
            INTO   v_s_TP_ORDEM
            FROM   IS_TIPOS_ORDEM T
            WHERE  T.TIPO = (SELECT OI.TIPO
                             FROM   IS_ORDENS_IMPORTACAO OI
                             WHERE  OI.NUM_ORDEM = v_s_NUM_ORDEM
                            );
            --
            EXCEPTION
               WHEN OTHERS THEN
                  raise_application_error(-20000,'Erro ao recuperar o Tipo de Ordem para NUM_ORDEM: ' || v_s_NUM_ORDEM ||
                                                 ', para NF NUM: ' || r_V_BS_API_NFE_NFC.NF_NUMNF ||
                                                 ', ID: '          || r_V_BS_API_NFE_NFC.NF_ID    ||
                                                 '. msg: '         || SQLERRM);
         END;
         --
         IF v_s_TP_ORDEM = 'OE' THEN
            BEGIN
               SELECT REQUISITION_HEADER_ID
               INTO   v_n_PO_HEADER_ID
               FROM   SFWBR_PO_REQ_HEADERS_V
               WHERE  SEGMENT1 = v_s_PO_NUMBER;
               --
               EXCEPTION
                  WHEN OTHERS THEN
                     raise_application_error(-20000,'Erro ao recuperar PO_HEADER_ID da Ordem: ' || v_s_PO_NUMBER               ||
                                                    ', do Tipo: [OE], para NF NUM: '            || r_V_BS_API_NFE_NFC.NF_NUMNF ||
                                                    ', ID: '  || r_V_BS_API_NFE_NFC.NF_ID ||
                                                    '. msg: ' || SQLERRM);
            END;
            --
            BEGIN
               SELECT DISTINCT L.DESTINATION_ORGANIZATION_ID,
                      L.DELIVER_TO_LOCATION_ID
               INTO   r_EBS_REC_INVOICES_INTERFACE.ORGANIZATION_ID,
                      r_EBS_REC_INVOICES_INTERFACE.LOCATION_ID
               FROM   SFWBR_PO_REQ_LINES_V L
               WHERE  L.REQUISITION_HEADER_ID = v_n_PO_HEADER_ID;
               --
               EXCEPTION
                  WHEN TOO_MANY_ROWS THEN
                     r_EBS_REC_INVOICES_INTERFACE.LOCATION_ID := NULL;
                  WHEN NO_DATA_FOUND THEN
                     raise_application_error(-20000,'O Pedido: '           || v_s_PO_NUMBER    ||
                                                    ', PO_HEADER_ID: '     || v_n_PO_HEADER_ID ||
                                                    ', Tipo: [OE], não foi encontrado no Oracle EBS para recuperar a Organização/Localização' ||
                                                    ', Referente NF NUM: ' || r_V_BS_API_NFE_NFC.NF_NUMNF ||
                                                    ', ID: '               || r_V_BS_API_NFE_NFC.NF_ID    ||
                                                    '. msg: '              || SQLERRM);
                  WHEN OTHERS THEN
                     raise_application_error(-20000,'Erro ao recuperar a Organização/Localização do Pedido: ' || v_s_PO_NUMBER ||
                                                    ', PO_HEADER_ID: ' || v_n_PO_HEADER_ID         ||
                                                    ', do Tipo: [OE], para NF NUM: ' || r_V_BS_API_NFE_NFC.NF_NUMNF ||
                                                    ', ID: '           || r_V_BS_API_NFE_NFC.NF_ID ||
                                                    '. msg: '          || SQLERRM);
            END;
         ELSE
            BEGIN
               SELECT TO_NUMBER(FLEX_FIELD1)
               INTO   v_n_PO_HEADER_ID
               FROM   IS_ITENS_ORDEM
               WHERE  NUM_ORDEM = v_s_NUM_ORDEM
               AND    ROWNUM    = 1;
               --
               EXCEPTION
                  WHEN OTHERS THEN
                     raise_application_error(-20000,'Erro ao recuperar PO_HEADER_ID da Ordem: ' || v_s_NUM_ORDEM ||
                                                    ', do Tipo: [PO]' ||
                                                    ', para NF NUM: ' || r_V_BS_API_NFE_NFC.NF_NUMNF ||
                                                    ', ID: '          || r_V_BS_API_NFE_NFC.NF_ID    ||
                                                    '. msg: '         || SQLERRM);
            END;
            --
            BEGIN
               SELECT DISTINCT I.ORGANIZATION_ID,
                      I.LOCATION_ID,
                      I.LOCATION_CODE
               INTO   r_EBS_REC_INVOICES_INTERFACE.ORGANIZATION_ID,
                      r_EBS_REC_INVOICES_INTERFACE.LOCATION_ID,
                      r_EBS_REC_INVOICES_INTERFACE.LOCATION_CODE
               FROM   SFWBR_PO_ITENS_COMPRAS_EXP_V I,
                      SFWBR_PO_PED_COMPRAS_V P
               WHERE (I.CANCELADO    <> 'Y' OR I.CANCELADO IS NULL)
               AND    I.PO_HEADER_ID = P.PO_HEADER_ID
               AND    I.PO_HEADER_ID = v_n_PO_HEADER_ID
               AND    I.LOCATION_ID  = P.SHIP_TO_LOCATION_ID
               AND    I.LOCATION_ID  IN (SELECT LOCATION_ID
                                         FROM   R12_DBL_EBS_HIERARQUIA
                                         WHERE  TIPO       = 'LOCATION'
                                         AND    HABILITADO = 'S'
                                        );
               --
               EXCEPTION
                  WHEN TOO_MANY_ROWS THEN
                     raise_application_error(-20000,'O Pedido: '           || v_s_NUM_ORDEM               ||
                                                    ', PO_HEADER_ID: '     || v_n_PO_HEADER_ID            ||
                                                    ', Referente NF NUM: ' || r_V_BS_API_NFE_NFC.NF_NUMNF ||
                                                    ', ID: '               || r_V_BS_API_NFE_NFC.NF_ID    ||
                                                    ', contém mais de uma Organização/Localização no Oracle EBS!. msg: '|| SQLERRM);
                  WHEN NO_DATA_FOUND THEN
                     raise_application_error(-20000,'O Pedido: '           || v_s_NUM_ORDEM               ||
                                                    ', PO_HEADER_ID: '     || v_n_PO_HEADER_ID            ||
                                                    ', Tipo: [PO], não foi encontrado no Oracle EBS para recuperar a Organização/Localização' ||
                                                    ', Referente NF NUM: ' || r_V_BS_API_NFE_NFC.NF_NUMNF ||
                                                    ', ID: '               || r_V_BS_API_NFE_NFC.NF_ID    ||
                                                    '. msg: '              || SQLERRM);
                  WHEN OTHERS THEN
                     raise_application_error(-20000,'Erro ao recuperar a Organização/Localização do Pedido: ' || v_s_NUM_ORDEM ||
                                                    ', PO_HEADER_ID: '     || v_n_PO_HEADER_ID            ||
                                                    ', do Tipo: [PO]'      ||
                                                    ', para NF NUM: '      || r_V_BS_API_NFE_NFC.NF_NUMNF ||
                                                    ', ID: '               || r_V_BS_API_NFE_NFC.NF_ID    ||
                                                    '. msg: '              || SQLERRM);
            END;
         END IF;
        --
        Begin
          Select DPV.PARA
            into v_s_InvoiceTypeCode
            from SFW_DP_VALORES DPV
           where DPV.DE_01 = substr(r_V_BS_API_NFE_NFC.NF_TPNOTA, 2, 1)
             and DPV.DE_03 = r_V_BS_API_NFE_NFC.NF_NATOPE
             and DPV.DE_04 = r_EBS_REC_INVOICES_INTERFACE.ORGANIZATION_ID
             and DPV.DE_02 = v_s_CFOP_COMP
             and DPV.DE_05 = v_s_TP_ORDEM
             and DPV.ID_GRUPO =
                 (SELECT DPG.ID_GRUPO
                    FROM SFW_DP_GRUPO DPG
                   WHERE DPG.NOME_GRUPO = 'IS_OUT_CFOP');
        EXCEPTION
          when NO_DATA_FOUND then
            begin
              Select DPV.PARA
                into v_s_InvoiceTypeCode
                from SFW_DP_VALORES DPV
               where DPV.DE_01 = substr(r_V_BS_API_NFE_NFC.NF_TPNOTA, 2, 1)
                 and DPV.DE_03 = r_V_BS_API_NFE_NFC.NF_NATOPE
                 and DPV.DE_04 =
                     r_EBS_REC_INVOICES_INTERFACE.ORGANIZATION_ID
                 and DPV.DE_02 in
                     (Select C.CODIGO_EXTERNO
                        from BS_NOTA_FISCAL NF, BS_CFOP_COMPLEMENTAR C
                       where NF.ID_COMPLEM = C.ID_COMPLEM
                         AND NF.ID_NOTAFISCAL = r_V_BS_API_NFE_NFC.NF_ID)
                 and DPV.DE_05 = v_s_TP_ORDEM
                 and DPV.ID_GRUPO =
                     (SELECT DPG.ID_GRUPO
                        FROM SFW_DP_GRUPO DPG
                       WHERE DPG.NOME_GRUPO = 'IS_OUT_CFOP');
            exception
              when others then
                raise_application_error(-20000,
                                  ' Erro ao buscar o Invoice Type NO DEPARA onde a tipo de NF(DE_01)= ' ||substr(r_V_BS_API_NFE_NFC.NF_TPNOTA, 2, 1)||' CFOP(DE_03): '||
                                  r_V_BS_API_NFE_NFC.NF_NATOPE||' ORGANIZATION_ID(DE_04): '||r_EBS_REC_INVOICES_INTERFACE.ORGANIZATION_ID||'  CFOP Complementar(DE_02): '||
                                  v_s_CFOP_COMP||' Tipo de Ordem(DE_05): '||v_s_TP_ORDEM||' NUM_NF: '||
                                  r_V_BS_API_NFE_NFC.NF_NUMNF ||' '|| SQLERRM);
            end;
          when others then
            raise_application_error(-20000,
                                  ' Erro ao buscar o Invoice Type NO DEPARA onde a tipo de NF(DE_01)= ' ||substr(r_V_BS_API_NFE_NFC.NF_TPNOTA, 2, 1)||' CFOP(DE_03): '||
                                  r_V_BS_API_NFE_NFC.NF_NATOPE||' ORGANIZATION_ID(DE_04): '||r_EBS_REC_INVOICES_INTERFACE.ORGANIZATION_ID||'  CFOP Complementar(DE_02): '||
                                  v_s_CFOP_COMP||' Tipo de Ordem(DE_05): '||v_s_TP_ORDEM||' NUM_NF: '||
                                  r_V_BS_API_NFE_NFC.NF_NUMNF ||' '|| SQLERRM);
        end;
         --
         Begin
            SELECT INVOICE_TYPE_ID
            INTO   r_EBS_REC_INVOICES_INTERFACE.INVOICE_TYPE_ID
            FROM   SFWBR_REC_TIPOS_NF_V
            WHERE  INVOICE_TYPE_CODE = v_s_InvoiceTypeCode
            AND    ORGANIZATION_ID   = r_EBS_REC_INVOICES_INTERFACE.ORGANIZATION_ID;
            --
            EXCEPTION
               when NO_DATA_FOUND then
                  raise_application_error(-20000,'Invoice Type ID não encontrado na view SFWBR_REC_TIPOS_NF_V onde o Invoice_Type_Code: ' || v_s_InvoiceTypeCode ||
                                                 ', ORGANIZATION_ID: ' || r_EBS_REC_INVOICES_INTERFACE.ORGANIZATION_ID ||
                                                 ', NUM_NF: '          || r_V_BS_API_NFE_NFC.NF_NUMNF || SQLERRM);
         end;
         --
         BEGIN
            SELECT TO_NUMBER(FLEX_FIELD3)
            INTO   v_n_VENDOR_SITE_ID
            FROM   SFW_PARCEIRO
            WHERE  COD_PARCEIRO = r_V_BS_API_NFE_NFC.NF_EMPRESA;
            --
            EXCEPTION
               WHEN OTHERS THEN
                  raise_application_error(-20000,
                                    'Erro ao recuperar o valor para o campo FLEX_FIELD3, da tabela: SFW_PARCEIRO para o Parceiro Importador: (' ||
                                    r_V_BS_API_NFE_NFC.NF_EMPRESA || '). ' || SQLERRM);
         END;
         --
         If v_s_TP_ORDEM = 'OE' then
            begin
               SELECT RFE.ENTITY_ID,
                      RFE.STATE_ID
               INTO   r_EBS_REC_INVOICES_INTERFACE.ENTITY_ID,
                      r_EBS_REC_INVOICES_INTERFACE.SOURCE_STATE_ID
               FROM   SFWBR_REC_FISCAL_ENTITIES_V RFE
               WHERE  RFE.VENDOR_SITE_ID = v_n_VENDOR_SITE_ID;
               --
               exception
                  when others then
                     raise_application_error(-20000,
                                    'Erro ao recuperar o valor para o campo ENTITY_ID e STATE_ID para o VENDOR_SITE_ID: (' ||
                                    NVL(TO_CHAR(v_n_VENDOR_SITE_ID), 'NULL') || '). ' || SQLERRM);
            end;
            --
            -- Utiliza a condição de venda padrão da Internal Requisition
            Begin
               Select r_V_BS_API_NFE_NFC.NF_DTEMIS + DIAS
               into   r_EBS_REC_INVOICES_INTERFACE.FIRST_PAYMENT_DATE
               from   SFWBR_AP_COND_PAGTO_V
               where  NOME = FNC_R12_DBL_GET_DE_PARA('IR_TERM','IS_IN_CONDPGTO_INT_REQ');
               --
               exception
                  when others then
                     raise_application_error(-20000,
                                    'Erro ao calcular o valor para o campo FIRST_PAYMENT_DATE. PO_HEADER_ID: (' ||
                                    NVL(TO_CHAR(v_n_PO_HEADER_ID), 'NULL') || '). ' || SQLERRM);
            end;
         else
            BEGIN
               r_EBS_REC_INVOICES_INTERFACE.ENTITY_ID := FNC_CAIBR_RI_ENTITY_ID(v_n_PO_HEADER_ID,v_n_VENDOR_SITE_ID);
               --
               exception
                  when others then
                     raise_application_error(-20000,
                                    'Erro ao recuperar o valor para o campo ENTITY_ID. FNC_CAIBR_RI_ENTITY_ID(' ||
                                    NVL(TO_CHAR(v_n_PO_HEADER_ID), 'NULL') || ',' || NVL(TO_CHAR(v_n_VENDOR_SITE_ID),'NULL') ||
                                    '). ' || SQLERRM);
            END;
            --
            begin
               r_EBS_REC_INVOICES_INTERFACE.SOURCE_STATE_ID := FNC_CAIBR_RI_STATE_ID(v_n_PO_HEADER_ID);
               --
               exception
                  when others then
                     raise_application_error(-20000,
                                    'Erro ao recuperar o valor para o campo SOURCE_STATE_ID. FNC_CAIBR_RI_STATE_ID(' ||
                                    nvl(to_char(v_n_PO_HEADER_ID), 'null') ||
                                    '). ' || SQLERRM);
            end;
            --
            begin
               r_EBS_REC_INVOICES_INTERFACE.FIRST_PAYMENT_DATE := r_V_BS_API_NFE_NFC.NF_DTEMIS +
                                                                  FNC_CAIBR_RI_DIAS(v_n_PO_HEADER_ID);
               --
               exception
                  when others then
                     raise_application_error(-20000,
                                    'Erro ao calcular o valor para o campo FIRST_PAYMENT_DATE. FNC_CAIBR_RI_DIAS(' ||
                                    nvl(to_char(v_n_PO_HEADER_ID), 'null') ||
                                    '). ' || SQLERRM);
            end;
            --
         end if;
         --
         begin
            --
            r_EBS_REC_INVOICES_INTERFACE.DESTINATION_STATE_ID := FNC_CAIBR_RI_STATE_ID(null,r_EBS_REC_INVOICES_INTERFACE.LOCATION_ID);
            --
            exception
               when others then
                  raise_application_error(-20000,
                                  'Erro ao calcular o valor para o campo DESTINATION_STATE_ID. FNC_CAIBR_RI_STATE_ID(null,' ||
                                  nvl(to_char(r_EBS_REC_INVOICES_INTERFACE.LOCATION_ID),
                                      'null') || '). ' || SQLERRM);
         end;
         --
         BEGIN
            SELECT A.DESCRICAO
            INTO   r_EBS_REC_INVOICES_INTERFACE.TERMS_NAME
            FROM   BS_PROFILE_BROKER    A,
                   IS_ORDENS_IMPORTACAO B
            WHERE  A.ID_PROFILE = B.COD_CONDICAO
            AND    B.NUM_ORDEM  = v_s_NUM_ORDEM;
            --
            EXCEPTION
               WHEN OTHERS THEN
                  raise_application_error(-20000,'Erro ao recuperar a Condicao de Pagamento no Import Sys!, para o Pedido: ' || v_s_NUM_ORDEM ||
                                                 ', Referente NF NUM: ' || r_V_BS_API_NFE_NFC.NF_NUMNF ||
                                                 ', ID: '               || r_V_BS_API_NFE_NFC.NF_ID    ||
                                                 '. msg: '              || SQLERRM);
         END;
         --
         r_EBS_REC_INVOICES_INTERFACE.TERMS_ID := FNC_R12_DBL_BUSCA_TERMS_ID_AP(r_EBS_REC_INVOICES_INTERFACE.TERMS_NAME);
         --
         IF NVL(r_EBS_REC_INVOICES_INTERFACE.TERMS_ID,0) < 0 THEN
            raise_application_error(-20000,'Erro ao tentar recuperar a TERM_ID da Condição de Pagamento: ' || r_EBS_REC_INVOICES_INTERFACE.TERMS_NAME ||
                                           ' no Oracle EBS. ');
         ELSE
            r_EBS_REC_INVOICES_INTERFACE.TERMS_NAME := NULL;
         END IF;
         begin
            PKG_R12_DBL_EXP_INSERT.EBS_REC_INVOICES_INTERFACE(r_EBS_REC_INVOICES_INTERFACE);
            --
            exception
               when others then
                  raise_application_error(-20000,
                                  'Inserindo na REC_INVOICES_INTERFACE. Erro ' ||
                                  SQLERRM);
         end;
         --
         -- Nota Fiscal Complementar
-- Início Alteração - Marcos R. Carneiro - Chamado: 429944...
--         if r_V_BS_API_NFE_NFC.NF_TPNOTA = 'ND' then
         -- ND - Nota Fiscal de Entrada Complementar.
         -- NC - Nota Fiscal de Entrada Complementar Manual.
         if r_V_BS_API_NFE_NFC.NF_TPNOTA IN ('ND','NC') THEN
-- Final Alteração - Marcos R. Carneiro - Chamado: 429944...
            SELECT SFWBR_REC_INVO_PAR_INT_S.nextval
            INTO   r_EBS_REC_INVO_PAR_INT.INTERFACE_PARENT_ID
            FROM   DUAL;
            --
            -- Chave de Acesso Nota Fiascal PAI...
            BEGIN
               SELECT NF_PAI.NF_NFE_SEFAZ_CHAVE_ACESSO
               INTO   v_s_ELETRONIC_INVOICE_KEY
               FROM   V_BS_API_NFE_NFC NF_PAI
               WHERE  NF_PAI.NF_ID = r_V_BS_API_NFE_NFC.NF_ID_NFE;
               --
               Exception
                  When OTHERS Then
                     raise_application_error(-20000,
                                             'Não foi possivel recuperar a chave de acesso da nota pai. numero Nota:' ||
                                             r_V_BS_API_NFE_NFC.NF_NUMNF || sqlerrm);
            END;
            --
            begin
               SELECT A.INVOICE_ID,
                      A.NUM_DOCFIS,
                      A.ENTITY_ID,
                      A.DATA_EMISSAO
               INTO   r_EBS_REC_INVO_PAR_INT.INVOICE_PARENT_ID,
                      r_EBS_REC_INVO_PAR_INT.INVOICE_PARENT_NUM,
                      r_EBS_REC_INVO_PAR_INT.ENTITY_ID,
                      r_EBS_REC_INVO_PAR_INT.INVOICE_DATE
               FROM   SFWBR_REC_NFE_V A
               WHERE  A.ELETRONIC_INVOICE_KEY = v_s_ELETRONIC_INVOICE_KEY
               AND    A.NF_DC      = 'D'
               AND    not exists  (select 1
                                   from   SFWBR_REC_NFE_V B
                                   where  B.NF_DC       = 'C'
                                   and    B.ID_NOTA_PAI = A.INVOICE_ID
                                  )
               AND    exists      (select 1
                                   from   SFWBR_REC_ENTRY_OPERATIONS_V C
                                   where  C.ORGANIZATION_ID = A.ORGANIZATION_ID
                                   and    C.OPERATION_ID    like (A.OPERATION_ID || '%')
                                   and    C.STATUS          = 'COMPLETE'
                                  );
               --
               exception
                  when others then
                     raise_application_error(-20000,
                                    'Erro ao recuperar a nota fiscal de entrada "' ||
                                    r_V_BS_API_NFE_NFC.NF_NUM_NF_NFE ||
                                    '" no Oracle EBS. ' || sqlerrm);
            end;
            --
            r_EBS_REC_INVO_PAR_INT.CREATION_DATE        := SYSDATE;
            r_EBS_REC_INVO_PAR_INT.CREATED_BY           := -1;
            r_EBS_REC_INVO_PAR_INT.LAST_UPDATE_DATE     := SYSDATE;
            r_EBS_REC_INVO_PAR_INT.LAST_UPDATED_BY      := -1;
            r_EBS_REC_INVO_PAR_INT.INTERFACE_INVOICE_ID := r_EBS_REC_INVOICES_INTERFACE.INTERFACE_INVOICE_ID;
            --
            begin
               PKG_R12_DBL_EXP_INSERT.EBS_REC_INVO_PAR_INT(r_EBS_REC_INVO_PAR_INT);
               --
               exception
                  when others then
                     raise_application_error(-20000,
                                    'Inserindo na REC_INVO_PAR_INT. Erro ' ||
                                    SQLERRM);
            end;
         end if;
         --
         -- itens da nota fiscal
         for r_V_IS_IT_ITEM_NFE_NFC in (select *
                                        from   V_BS_API_ITEM_NFE_NFC
                                        where  NF_ITE_NFID = r_V_BS_API_NFE_NFC.NF_ID) loop
             begin
                select SFWBR_REC_INVO_LINES_INTER_S.nextval
                into   r_EBS_REC_INVOICE_LINES_INT.INTERFACE_INVOICE_LINE_ID
                from   dual;
                --
                r_EBS_REC_INVOICE_LINES_INT.INTERFACE_INVOICE_ID := r_EBS_REC_INVOICES_INTERFACE.INTERFACE_INVOICE_ID;
                --
                -- campos fixos
                r_EBS_REC_INVOICE_LINES_INT.CREATED_BY               := -1;
                r_EBS_REC_INVOICE_LINES_INT.LAST_UPDATED_BY          := -1;
                r_EBS_REC_INVOICE_LINES_INT.DIFF_ICMS_AMOUNT         := 0;
                r_EBS_REC_INVOICE_LINES_INT.DIFF_ICMS_AMOUNT_RECOVER := 0;
                r_EBS_REC_INVOICE_LINES_INT.DIFF_ICMS_TAX            := 0;
                r_EBS_REC_INVOICE_LINES_INT.DISCOUNT_AMOUNT          := 0;
                r_EBS_REC_INVOICE_LINES_INT.DOLLAR_CUSTOMS_EXPENSE   := 0;
                r_EBS_REC_INVOICE_LINES_INT.FREIGHT_AMOUNT           := 0;
                r_EBS_REC_INVOICE_LINES_INT.INSURANCE_AMOUNT         := 0;
                r_EBS_REC_INVOICE_LINES_INT.COFINS_AMOUNT_RECOVER    := 0;
                r_EBS_REC_INVOICE_LINES_INT.PIS_AMOUNT_RECOVER       := 0;
                r_EBS_REC_INVOICE_LINES_INT.RECEIPT_FLAG             := 'S';
                r_EBS_REC_INVOICE_LINES_INT.CREATION_DATE            := sysdate;
                r_EBS_REC_INVOICE_LINES_INT.LAST_UPDATE_DATE         := sysdate;
                -- Tratamento ST ICMS
                r_EBS_REC_INVOICE_LINES_INT.ICMS_ST_BASE             := r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Base_Icms_St;
                r_EBS_REC_INVOICE_LINES_INT.ICMS_ST_AMOUNT           := r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Valor_Icms_St;
                r_EBS_REC_INVOICE_LINES_INT.ICMS_ST_AMOUNT_RECOVER   := 0;
                --
                -- campos extraidos diretamente da view
                r_EBS_REC_INVOICE_LINES_INT.line_num := r_V_IS_IT_ITEM_NFE_NFC.nf_ite_numite;

                r_EBS_REC_INVOICE_LINES_INT.ICMS_TAX := NVL(r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_PERICMS,
                                                            0);
                r_EBS_REC_INVOICE_LINES_INT.IPI_TAX := NVL(r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_PERIPI,
                                                           0);
                --
                -- Busca PO_HEADER_ID e PO_LINE_ID...
                --
                BEGIN
                   SELECT TO_NUMBER(IO.FLEX_FIELD1),
                          TO_NUMBER(IO.FLEX_FIELD2),
                          IO.FLEX_FIELD10
                   INTO   v_n_PO_HEADER_ID,
                          v_n_PO_LINE_ID,
                          v_s_CFOP_COMP_original
                   FROM   IS_ITENS_ORDEM IO
                   WHERE  IO.NUM_ORDEM = r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_PEDIDO
                   AND    IO.NUM_ITEM  = r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_ITEM_PED;
                   --
                   EXCEPTION
                      WHEN OTHERS THEN
                         raise_application_error(-20000,'Erro ao recuperar PO_HEADER_ID e PO_LINE_ID dos Campos FLEXs: FLEX_FIELD1 e FLEX_FIELD2. da Tabela: IS_ITENS_ORDEM, para o Pedido: ' || r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_PEDIDO ||
                                                        ', Item: ' || r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_ITEM_PED || '.' || SQLERRM);
                END;
        --
         Begin
          Select OPERATION_FISCAL_TYPE
          Into   r_EBS_REC_INVOICE_LINES_INT.OPERATION_FISCAL_TYPE
          From   SFWBR_REC_TIPOS_NF_V
          Where  INVOICE_TYPE_ID = r_EBS_REC_INVOICES_INTERFACE.INVOICE_TYPE_ID
          AND    ORGANIZATION_ID = r_EBS_REC_INVOICES_INTERFACE.ORGANIZATION_ID;
          --
          Exception
             When OTHERS Then
              r_EBS_REC_INVOICE_LINES_INT.OPERATION_FISCAL_TYPE := null;
         End;
         --
         begin
          if nvl(FNC_R12_DBL_GET_DE_PARA('UTILIZA_CLL_F189_CFO_UTILIZATIONS','IS_OUT_NF_RI'),'N') = 'S' then
            execute immediate 'begin select CFOU.OPERATION_FISCAL_TYPE
                      into :OPERATION_FISCAL_TYPE
                      from CLL_F189_FISCAL_OPERATIONS FO,
                         CLL_F189_CFO_UTILIZATIONS  CFOU,
                         CLL_F189_ITEM_UTILIZATIONS IU
                       where iu.UTILIZATION_CODE = :UTILIZATION_CODE
                       and replace(fo.cfo_code, ''.'', '''') = :CFO_CODE
                       and iu.UTILIZATION_ID = cfou.UTILIZATION_ID
                       and fo.CFO_ID = cfou.CFO_ID; end;'
            using out r_EBS_REC_INVOICE_LINES_INT.OPERATION_FISCAL_TYPE,
				  in v_s_CFOP_COMP_original, r_V_IS_IT_ITEM_NFE_NFC.nf_ite_natope;
          end if;
         end;
         if r_EBS_REC_INVOICE_LINES_INT.OPERATION_FISCAL_TYPE is null then
          raise_application_error(-20000,
                      'Não foi possivel definir o Tipo de Operação Fiscal no Oracle a partir do Invoice Type ID:' ||
                      to_char(r_EBS_REC_INVOICES_INTERFACE.INVOICE_TYPE_ID) ||
                      ', Organizacão de Inventario:' ||
                      r_EBS_REC_INVOICES_INTERFACE.ORGANIZATION_ID);
         end if;
                --
                -- Busca a unidade de medida da po no Oracle
                --
                IF v_s_TP_ORDEM = 'OE' THEN
                   BEGIN
                      SELECT RL.UNIT_MEAS_LOOKUP_CODE
                      INTO   r_EBS_REC_INVOICE_LINES_INT.UOM
                      FROM   SFWBR_PO_REQ_LINES_V RL
                      WHERE  RL.REQUISITION_HEADER_ID = v_n_PO_HEADER_ID
                      AND    RL.REQUISITION_LINE_ID   = v_n_PO_LINE_ID;
                      --
                      EXCEPTION
                         WHEN OTHERS THEN
                            raise_application_error(-20000,'Erro ao recuperar a Unidade de Medida do Item da Internal Requisition para o Pedido: ' || r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_PEDIDO ||
                                                           ', Item: ' || r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_ITEM_PED || ' no Oracle EBS.' || SQLERRM);
                   END;
                   --
                   r_EBS_REC_INVOICE_LINES_INT.REQUISITION_LINE_ID := v_n_PO_LINE_ID;
                   --
                ELSE
                   BEGIN
                      SELECT PI.UNID_MEDIDA
                      INTO   r_EBS_REC_INVOICE_LINES_INT.UOM
                      FROM   SFWBR_PO_ITENS_PED_COMPRAS_V PI
                      WHERE  PI.PO_HEADER_ID = v_n_PO_HEADER_ID
                      AND    PI.PO_LINE_ID   = v_n_PO_LINE_ID;
                      --
                      EXCEPTION
                         WHEN OTHERS THEN
                            raise_application_error(-20000,'Erro ao recuperar a Unidade de Medida do Item da PO para o Pedido: ' || r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_PEDIDO ||
                                                           ', Item: ' || r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_ITEM_PED || ' no Oracle EBS.' || SQLERRM);
                   END;
                END IF;
                --
                r_EBS_REC_INVOICE_LINES_INT.UTILIZATION_CODE := v_s_CFOP_COMP_original;
                r_EBS_REC_INVOICE_LINES_INT.DESCRIPTION      := SUBSTR(r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Descricao,
                                                                       1,
                                                                       140);
                --CST
                --descomentar / falta patche do Oracle na Softway
                r_EBS_REC_INVOICE_LINES_INT.Tributary_Status_Code := r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Cst;
                r_EBS_REC_INVOICE_LINES_INT.PIS_TRIBUTARY_CODE    := r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_CST_PIS_COFINS;
                r_EBS_REC_INVOICE_LINES_INT.COFINS_TRIBUTARY_CODE := r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_CST_PIS_COFINS;
                r_EBS_REC_INVOICE_LINES_INT.IPI_TRIBUTARY_CODE    := r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_CST_IPI;
                --
                r_EBS_REC_INVOICE_LINES_INT.CFO_CODE            := r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Natope;
                r_EBS_REC_INVOICE_LINES_INT.QUANTITY            := r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Qtde;
                r_EBS_REC_INVOICE_LINES_INT.CLASSIFICATION_CODE := r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Clafis;
                --
                if r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Nm_Externo_Cfop is null Then
                   raise_application_error(-20000,
                                    'Utilização do Item / CodExternoCfop não pode ser nulo para o item da po "' ||
                                    r_V_IS_IT_ITEM_NFE_NFC.nf_ite_pedido ||
                                    '" no Oracle EBS. ' || sqlerrm);
                End If;
                --
                r_EBS_REC_INVOICE_LINES_INT.IMPORTATION_COFINS_AMOUNT     := nvl(r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Vrcofins,
                                                                                 0);
                r_EBS_REC_INVOICE_LINES_INT.FOB_AMOUNT                    := round(r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Fob,
                                                                             v_n_precisao_decimal);
                r_EBS_REC_INVOICE_LINES_INT.DOLLAR_FOB_AMOUNT             := round(is_calculavalormoeda(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                                                                  'REAL',
                                                                                                  'USD',
                                                                                                  r_EBS_REC_INVOICE_LINES_INT.FOB_AMOUNT),
                                                                             v_n_precisao_decimal);
                r_EBS_REC_INVOICE_LINES_INT.FREIGHT_INTERNACIONAL         := round(r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Vl_Frete_Rateado,
                                                                             v_n_precisao_decimal);
                r_EBS_REC_INVOICE_LINES_INT.DOLLAR_FREIGHT_INTERNACIONAL  := round(is_calculavalormoeda(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                                                                  'REAL',
                                                                                                  'USD',
                                                                                                  r_EBS_REC_INVOICE_LINES_INT.FREIGHT_INTERNACIONAL),
                                                                             v_n_precisao_decimal);
                r_EBS_REC_INVOICE_LINES_INT.IMPORTATION_TAX_AMOUNT        := NVL(round(r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Vrii,
                                                                                 v_n_precisao_decimal),
                                                                           0);
                r_EBS_REC_INVOICE_LINES_INT.DOLLAR_IMPORTATION_TAX_AMOUNT := round(is_calculavalormoeda(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                                                                  'REAL',
                                                                                                  'USD',
                                                                                                  r_EBS_REC_INVOICE_LINES_INT.IMPORTATION_TAX_AMOUNT),
                                                                             v_n_precisao_decimal);
                r_EBS_REC_INVOICE_LINES_INT.IMPORTATION_PIS_COFINS_BASE   := nvl(round(nvl(r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Basepis,
                                                                                     r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Basecofins),
                                                                                 v_n_precisao_decimal),
                                                                           0);
                r_EBS_REC_INVOICE_LINES_INT.IMPORTATION_PIS_AMOUNT        := nvl(round(r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Vrpis,
                                                                                 v_n_precisao_decimal),
                                                                           0);
                r_EBS_REC_INVOICE_LINES_INT.IMPORTATION_INSURANCE_AMOUNT  := nvl(round(r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Vl_Seguro_Rateado,
                                                                                 v_n_precisao_decimal),
                                                                           0);
                r_EBS_REC_INVOICE_LINES_INT.DOLLAR_INSURANCE_AMOUNT       := round(is_calculavalormoeda(r_V_BS_API_NFE_NFC.NF_COD_PROCESSO,
                                                                                                  'REAL',
                                                                                                  'USD',
                                                                                                  r_EBS_REC_INVOICE_LINES_INT.IMPORTATION_INSURANCE_AMOUNT),
                                                                             v_n_precisao_decimal);
                --
                r_EBS_REC_INVOICE_LINES_INT.IPI_AMOUNT  := nvl(round(R_V_IS_IT_ITEM_NFE_NFC.NF_ITE_VRIPI,
                                                               v_n_precisao_decimal),
                                                         0);
                r_EBS_REC_INVOICE_LINES_INT.ICMS_AMOUNT := nvl(round(R_V_IS_IT_ITEM_NFE_NFC.NF_ITE_VRICMS,
                                                               v_n_precisao_decimal),
                                                         0);
                --
                --ICMS
                If r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Baseicms is null or
                   r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Baseicms = 0 Then
                   r_EBS_REC_INVOICE_LINES_INT.ICMS_BASE := 0;
                Else
                   r_EBS_REC_INVOICE_LINES_INT.ICMS_BASE := nvl(round(r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Baseicms,
                                                               v_n_precisao_decimal),
                                                         0);
                End If;
                --
                --IPI
                If r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_VRIPI is null or
                   r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_VRIPI = 0 Then
                   r_EBS_REC_INVOICE_LINES_INT.IPI_BASE_AMOUNT := 0;
                Else
                   r_EBS_REC_INVOICE_LINES_INT.IPI_BASE_AMOUNT := nvl(round(r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Baseipi,
                                                                     v_n_precisao_decimal),
                                                               0);
                End If;
                --
                if NVL(FNC_R12_DBL_GET_DE_PARA('TRATA_TIPO_IMPOSTO','IT_TIPO_IMPOSTO'),'S') = 'S'  then
                   -- Novo tratamento tipo para imposto e recuperação
                   begin
                      select b.flag_credito_icms,
                             b.flag_credito_ipi,
                             b.flag_credito_pis,
                             b.flag_credito_cofins
                      into   v_s_RECUPERA_ICMS,
                             v_s_RECUPERA_IPI,
                             v_s_RECOVER_PIS_FLAG_CNPJ,
                             v_s_RECOVER_COFINS_FLAG_CNPJ
                      from   bs_nota_fiscal a,
                             bs_cfop_complementar b
                      where  a.id_notafiscal = p_n_ID_NOTAFISCAL
                      and    a.id_complem    = b.id_complem;
                      --
                      exception
                         when others then
                            raise_application_error(-20000,'Erro ao recuperar os impostos a recuperar da view bs_cfop_complementar(CFOP Complementar). Nota fiscal: '|| r_V_BS_API_NFE_NFC.NF_NUMNF ||
                                                           ' CFOP Complementar: ' || v_s_CFOP_COMP ||
                                                           ' Erro: '              || sqlerrm);
                   end;
                   -- RI
                   --ICMS_TAX_CODE TRIBUTATION_CODE REC_LOOKUP_CODES
                   -------------------------------------------------
                   --              1                Tributável
                   --              2                Isento
                   --              3                Outros
                   -------------------------------------------------
                   -- SOFTWAY
                   -------------------------------------------------
                   -- 1 - Recolhimento Integral
                   -- 2 - Imunidade
                   -- 3 - Isenção
                   -- 4 - Redução
                   -- 5 - Suspensão
                   -- 6 - Não Incidência
                   -------------------------------------------------
                   if r_V_IS_IT_ITEM_NFE_NFC.nf_ite_cdicms in ('3', '5', '6') then
                      -- Isento
                      r_EBS_REC_INVOICE_LINES_INT.icms_tax_code       := '2';
                      r_EBS_REC_INVOICE_LINES_INT.icms_amount_recover := 0;
                   elsif v_s_RECUPERA_ICMS = 'S' then
                         -- Tributavel - com credito de ICMS
                      r_EBS_REC_INVOICE_LINES_INT.icms_tax_code       := '1';
                      r_EBS_REC_INVOICE_LINES_INT.icms_amount_recover := r_EBS_REC_INVOICE_LINES_INT.icms_amount;
                   else
                      -- Outras - sem credito de ICMS
                      r_EBS_REC_INVOICE_LINES_INT.icms_tax_code       := '3';
                      r_EBS_REC_INVOICE_LINES_INT.icms_amount_recover := 0;
                   end if;
                   --IPI_TAX_CODE FEDERAL TRIBUTATION_CODE REC_LOOKUP_CODES
                   --                     1                Tributável
                   --                     2                Isento
                   --                     3                Outros
                   -- SOFTWAY
                   -------------------------------------------------
                   -- 1 - Isenção
                   -- 2 - Redução
                   -- 3 - Não Tributável
                   -- 4 - Integral (Sem Benefício)
                   -- 5 - Suspensão
                   -------------------------------------------------
                   if r_V_IS_IT_ITEM_NFE_NFC.nf_ite_cdipi in ('1', '3', '5') then
                      -- Isento
                      r_EBS_REC_INVOICE_LINES_INT.ipi_tax_code       := '2';
                      r_EBS_REC_INVOICE_LINES_INT.ipi_amount_recover := 0;
                   elsif r_V_IS_IT_ITEM_NFE_NFC.nf_ite_cdipi in ('2', '4') then
                         -- Tributavel - com credito de IPI
                         r_EBS_REC_INVOICE_LINES_INT.ipi_tax_code       := '1';
                         --
                         if v_s_RECUPERA_IPI = 'S' then
                            r_EBS_REC_INVOICE_LINES_INT.ipi_amount_recover := r_EBS_REC_INVOICE_LINES_INT.ipi_amount;
                         else
                            r_EBS_REC_INVOICE_LINES_INT.ipi_amount_recover := 0;
                         end if;
                   else
                      -- Outras - sem credito de ICMS
                      r_EBS_REC_INVOICE_LINES_INT.ipi_tax_code       := '3';
                      r_EBS_REC_INVOICE_LINES_INT.ipi_amount_recover := 0;
                   end if;
                   --
                   if v_s_RECOVER_PIS_FLAG_CNPJ    = 'S' and
-- Início Alteração - Marcos R. Carneiro - Chamado: 429944...
--                      r_v_bs_api_nfe_nfc.nf_tpnota not in ('D', 'ND') then
                      -- ND - Nota Fiscal de Entrada Complementar.
                      -- NC - Nota Fiscal de Entrada Complementar Manual.
                      r_V_BS_API_NFE_NFC.NF_TPNOTA NOT IN ('ND','NC') THEN
-- Final Alteração - Marcos R. Carneiro - Chamado: 429944...
                      r_EBS_REC_INVOICE_LINES_INT.pis_amount_recover := r_EBS_REC_INVOICE_LINES_INT.importation_pis_amount;
                   else
                      r_EBS_REC_INVOICE_LINES_INT.pis_amount_recover := 0;
                   end if;
                   --
                   if v_s_RECOVER_COFINS_FLAG_CNPJ = 'S' and
-- Início Alteração - Marcos R. Carneiro - Chamado: 429944...
--                      r_v_bs_api_nfe_nfc.nf_tpnota not in ('D', 'ND') then
                      -- ND - Nota Fiscal de Entrada Complementar.
                      -- NC - Nota Fiscal de Entrada Complementar Manual.
                      r_V_BS_API_NFE_NFC.NF_TPNOTA NOT IN ('ND','NC') THEN
-- Final Alteração - Marcos R. Carneiro - Chamado: 429944...
                      r_EBS_REC_INVOICE_LINES_INT.cofins_amount_recover := FNC_BK_REC_COFINS_MP563_ITNF(r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_NFID,
                                                                                                        r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_SEQ_ITEM_NF,
                                                                                                        'Cofins Imp Crédito'); -- Alteração MP 563/2012
                   else
                      r_EBS_REC_INVOICE_LINES_INT.cofins_amount_recover := 0;
                   end if;
                   -- Fim Novo tratamento tipo para imposto e recuperação
                else
                   -- Busca os tipos de imposto de ICMS e IPI
                   -- 1 - Tributado
                   -- 2 - Isento
                   -- 3 - Outros
                   r_EBS_REC_INVOICE_LINES_INT.ICMS_TAX_CODE := FNC_R12_DBL_IPI_ICMS_TAX_CODE(r_V_BS_API_NFE_NFC.NF_NATOPE,'ICMS',
                                                                                              v_s_CFOP_COMP,
                                                                                              substr(r_V_BS_API_NFE_NFC.NF_TPNOTA,2,1),
                                                                                              r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Numite,
                                                                                              r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Nfid,
                                                                                              r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Cdicms);
                   r_EBS_REC_INVOICE_LINES_INT.IPI_TAX_CODE  := FNC_R12_DBL_IPI_ICMS_TAX_CODE(r_V_BS_API_NFE_NFC.NF_NATOPE,'IPI',
                                                                                              v_s_CFOP_COMP,
                                                                                              substr(r_V_BS_API_NFE_NFC.NF_TPNOTA,2,1),
                                                                                              r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Numite,
                                                                                              r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Nfid,
                                                                                              r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Cdipi);
                   --
                   BEGIN
                      select RECOVER_PIS_FLAG_CNPJ,
                             RECOVER_COFINS_FLAG_CNPJ,
                             RECUPERA_IPI,
                             RECUPERA_ICMS
                      into   v_s_RECOVER_PIS_FLAG_CNPJ,
                             v_s_RECOVER_COFINS_FLAG_CNPJ,
                             v_s_RECUPERA_IPI,
                             v_s_RECUPERA_ICMS
                      from   SFWBR_REC_UTIL_FISCAL_V
                      where  nat_transacao = v_s_CFOP_COMP_original;
                      --
                      Exception
                         When OTHERS Then
                            raise_application_error(-20000,'Erro ao buscar o Tipo de Utilização no Oracle para o Código: ' || UPPER(r_EBS_REC_INVOICE_LINES_INT.UTILIZATION_CODE) ||
                                                           ' Invoice_type_id = ' || r_EBS_REC_INVOICES_INTERFACE.INVOICE_TYPE_ID ||
                                                           ' Erro: '             || sqlerrm);
                   END;
                   --
                   --IPI RECOVER
                   If v_s_RECUPERA_IPI = 'S' Then
                      r_EBS_REC_INVOICE_LINES_INT.IPI_AMOUNT_RECOVER := r_EBS_REC_INVOICE_LINES_INT.IPI_AMOUNT;
                   Else
                      r_EBS_REC_INVOICE_LINES_INT.IPI_AMOUNT_RECOVER := 0;
                   End If;
                   --
                   --ICMS RECOVER
                   If v_s_RECUPERA_ICMS = 'S' Then
                      r_EBS_REC_INVOICE_LINES_INT.ICMS_AMOUNT_RECOVER := r_EBS_REC_INVOICE_LINES_INT.ICMS_AMOUNT;
                   Else
                      r_EBS_REC_INVOICE_LINES_INT.ICMS_AMOUNT_RECOVER := 0;
                   End If;
                   --
                   --PIS RECOVER
                   If v_s_RECOVER_PIS_FLAG_CNPJ = 'S' Then
                      r_EBS_REC_INVOICE_LINES_INT.PIS_AMOUNT_RECOVER := r_EBS_REC_INVOICE_LINES_INT.IMPORTATION_PIS_AMOUNT;
                   Else
                      r_EBS_REC_INVOICE_LINES_INT.PIS_AMOUNT_RECOVER := 0;
                   End If;
                   --
                   --COFINS RECOVER
                   If v_s_RECOVER_COFINS_FLAG_CNPJ = 'S' Then
                      r_EBS_REC_INVOICE_LINES_INT.COFINS_AMOUNT_RECOVER := FNC_BK_REC_COFINS_MP563_ITNF(r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_NFID,
                                                                                                        r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_SEQ_ITEM_NF,
                                                                                                        'Cofins Imp Crédito'); -- Alteração MP 563/2012
                   Else
                      r_EBS_REC_INVOICE_LINES_INT.COFINS_AMOUNT_RECOVER := 0;
                   End If;
                End if; -- 21/08/2014 Tratamento tipo de imposto
                --
                begin
                   select A.FLEX_FIELD4,
                          to_number(A.COD_PECA)
                   into   r_EBS_REC_INVOICE_LINES_INT.LINE_LOCATION_ID,
                          v_n_cod_peca
                   from   is_itens_ordem a
                   where  a.num_ordem = r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Pedido
                   and    a.num_item  = r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Item_Ped;
                   --
                   exception
                      when others then
                         raise_application_error(-20000,
                                      'Erro ao localizar o item "' ||
                                      r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Item_Ped ||
                                      '" do pedido "' ||
                                      r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Pedido ||
                                      '". ' || sqlerrm);
                end;
                --
                begin
                   select TO_NUMBER(a.flex_field2)
                   into   r_EBS_REC_INVOICE_LINES_INT.ITEM_ID
                   from   sfw_produto a
                   where  a.id_produto = v_n_cod_peca;
                   --
                   exception
                      when others then
                         raise_application_error(-20000,
                                      'Erro ao recuperar o produto "' ||
                                      nvl(to_char(v_n_cod_peca), 'NULL') || '" ' ||
                                      sqlerrm);
                end;
                --
                -- Nota Fiscal Filhote
                -- Não tem relação com Ordem de Compra
                IF v_s_Complementar = 'K' THEN
                   r_EBS_REC_INVOICE_LINES_INT.LINE_LOCATION_ID := NULL;
                   r_EBS_REC_INVOICE_LINES_INT.ITEM_ID          := NULL;
                   --
                   -- Busca a Conta Contábil Obrigatória para NF FILHOTE
                   --
                   BEGIN
                      SELECT DISTINCT CODE_COMBINATION_ID
                      INTO   r_EBS_REC_INVOICE_LINES_INT.DB_CODE_COMBINATION_ID
                      FROM   SFWBR_PO_DISTRIBUTIONS_V
                      WHERE  PO_HEADER_ID = v_n_po_HEADER_ID
                      AND    PO_LINE_ID   = v_n_po_LINE_ID;
                      --
                      EXCEPTION
                         WHEN OTHERS THEN
                            raise_application_error(-20001,'Não foi Lozalizado a Conta Contábil para o Pedido: ' || r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_PEDIDO ||
                                                           ', Item: '         || r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_ITEM_PED ||
                                                           ', PO_HEADER_ID: ' || v_n_po_HEADER_ID ||
                                                           ', PO_LINE_ID: '   || v_n_po_LINE_ID ||
                                                           ' no Oracle EBS.'  || SQLERRM);
                   END;
                END IF;
                --
-- Início Alteração - Marcos R. Carneiro - Chamado: 429944...
/*
                if r_V_BS_API_NFE_NFC.NF_TPNOTA in ('ND','NK','NC') then
                   -- item de Nota Fiscal Complementar
                   --Valor do Item com ICMS
                   r_EBS_REC_INVOICE_LINES_INT.UNIT_PRICE := round(R_V_IS_IT_ITEM_NFE_NFC.NF_ITE_VRTTITE,
                                                                   v_n_precisao_decimal);
                Else
                   -- Tratamento especifico por conta do RI
                   r_EBS_REC_INVOICE_LINES_INT.UNIT_PRICE := round(r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Baseipi / r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Qtde,v_n_precisao_decimal);
                End If;
*/
                r_EBS_REC_INVOICE_LINES_INT.UNIT_PRICE := r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_PRUNIT;
-- Final Alteração - Marcos R. Carneiro - Chamado: 429944...
                --
                -- busca configuracao do importador
                begin
                   select a.gera_nf_vmle
                   into   v_s_gera_nf_vmle
                   from   bs_importadores a,
                          sfw_parceiro b
                   where  a.id_informante = b.id_parceiro
                   and    b.cod_parceiro  = r_v_bs_api_nfe_nfc.nf_empresa;
                   --
                   exception
                      when others then
                         v_s_gera_nf_vmle := 'N';
                end;
                --
                begin
                   select a.soma_desp_vlr_unit_nf
                   into   v_s_soma_desp_vlr_unit_nf
                   from   bs_importadores_despesas a,
                          sfw_parceiro b
                   where  a.id_informante    = b.id_parceiro
                   and    b.cod_parceiro     = r_v_bs_api_nfe_nfc.nf_empresa
                   and    a.id_despesa       = 'II'
                   and    a.cod_sistema_desp = 9;
                   --
                   exception
                      when others then
                         v_s_soma_desp_vlr_unit_nf := 'N';
                end;
        if v_s_gera_nf_vmld = 'N' then --Se não estiver configurado para VMLD+II
                  BEGIN --Verifica se II compoe OUTRAS DESPESAS ou VALOR TOTAL do Item.
                    select a.soma_desp_vlr_unit_nf, a.compoe_nfe, a.compoe_nfc
                      into v_s_ii_valor_unit, v_s_ii_outras_desp, v_s_ii_outras_desp_comp
                      from sfw_importador_despesa a, sfw_parceiro b
                     where a.id_informante = b.id_parceiro
                       and b.cod_parceiro = r_v_bs_api_nfe_nfc.nf_empresa
                       and a.id_despesa = 'II'
                       and a.cod_sistema_desp = 9;
                  exception
                    when others then
                      v_s_ii_valor_unit := 'N';
                      v_s_ii_outras_desp := 'N';
                  end;
                else --Se estiver configurado para VMLD+II
                  --Considera que o valor do II está rateado no VALOR TOTAL do Item
                  v_s_ii_valor_unit := 'S';
                end if;
                --
        r_EBS_REC_INVOICE_LINES_INT.TOTAL_AMOUNT := round(R_V_IS_IT_ITEM_NFE_NFC.nf_ite_vrttite,
                                                                     v_n_precisao_decimal);
                --
        if R_V_IS_IT_ITEM_NFE_NFC.nf_ite_vripi is not null
                then
                    r_EBS_REC_INVOICE_LINES_INT.total_amount := r_EBS_REC_INVOICE_LINES_INT.total_amount +
                                                                round(R_V_IS_IT_ITEM_NFE_NFC.nf_ite_vripi,
                                                                      v_n_precisao_decimal);
                end if;
        --
        if r_v_bs_api_nfe_nfc.nf_tpnota NOT IN ('NF','NK') then
                   if v_s_gera_nf_vmld = 'N' then --Se não estiver configurado para VMLD+II
                      -- frete e seguro NAO estao embutidos no valor do item
                      r_EBS_REC_INVOICE_LINES_INT.total_amount := r_EBS_REC_INVOICE_LINES_INT.total_amount +
                                                                     r_EBS_REC_INVOICE_LINES_INT.freight_internacional +
                                                                     r_EBS_REC_INVOICE_LINES_INT.importation_insurance_amount;
                   end if;
                   --
                   if v_s_ii_valor_unit = 'N' and (v_s_ii_outras_desp = 'N' or v_s_ii_outras_desp_comp = 'N') then
                      --Se II não compoe Valor Unitario do Item e não Compoe Outras despesas de NFE ou NFC
                      --II NAO está embutido no valor do item e sera somado ao total amount.
                      r_EBS_REC_INVOICE_LINES_INT.total_amount := r_EBS_REC_INVOICE_LINES_INT.total_amount +
                                                                     r_EBS_REC_INVOICE_LINES_INT.importation_tax_amount;
                   end if;
                end if;
        --
                if r_V_BS_API_NFE_NFC.NF_TPNOTA IN ('NF','NK','NM') then
                   r_EBS_REC_INVOICE_LINES_INT.other_expenses := R_V_IS_IT_ITEM_NFE_NFC.nf_ite_vrdespesa;
                else
                   r_EBS_REC_INVOICE_LINES_INT.other_expenses := R_V_IS_IT_ITEM_NFE_NFC.NF_ITE_OUTRAS_DESP_ACESSORIAS;
                end if;
                --
                -- colocado o round para o other_expenses depois dos cálculos acima
                --
                r_EBS_REC_INVOICE_LINES_INT.other_expenses := round(r_EBS_REC_INVOICE_LINES_INT.other_expenses, v_n_precisao_decimal);
                --
                r_EBS_REC_INVOICE_LINES_INT.NET_AMOUNT     := round(R_V_IS_IT_ITEM_NFE_NFC.NF_ITE_VRTTITE,
                                                              v_n_precisao_decimal);
                -- 
                if NVL(FNC_R12_DBL_GET_DE_PARA('PACK_16', 'PATCH_RI'), 'N') = 'S' then
                   r_EBS_REC_INVOICE_LINES_INT.total_amount   := r_EBS_REC_INVOICE_LINES_INT.total_amount + nvl(r_EBS_REC_INVOICE_LINES_INT.other_expenses,0);
                   r_EBS_REC_INVOICE_LINES_INT.NET_AMOUNT     := r_EBS_REC_INVOICE_LINES_INT.NET_AMOUNT + nvl(r_EBS_REC_INVOICE_LINES_INT.other_expenses,0);
                   r_EBS_REC_INVOICE_LINES_INT.other_expenses  := 0;
                end if;
                --
                r_EBS_REC_INVOICE_LINES_INT.ATTRIBUTE14    := r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_ID_ADICAO;
                --
-- Início Alteração - Marcos R. Carneiro - Chamado: 429944...
--                if r_V_BS_API_NFE_NFC.NF_TPNOTA != 'NK' then
                -- NF - Nota Fiscal Filhote.
                -- NK - Nota Fiscal Filhote (Manual).
                if r_V_BS_API_NFE_NFC.NF_TPNOTA NOT IN ('NF','NK') then
-- Final Alteração - Marcos R. Carneiro - Chamado: 429944...
                   r_EBS_REC_INVOICE_LINES_INT.ATTRIBUTE15    := r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_ID_ITEM_ADICAO;
                else
                   r_EBS_REC_INVOICE_LINES_INT.ATTRIBUTE15    := null;
                end if;
                --
                IF r_EBS_REC_INVOICE_LINES_INT.CUSTOMS_EXPENSE_FUNC IS NULL THEN
                   r_EBS_REC_INVOICE_LINES_INT.CUSTOMS_EXPENSE_FUNC    := 0;
                END IF;
                --
                IF r_EBS_REC_INVOICE_LINES_INT.IMPORTATION_EXPENSE_FUNC IS NULL THEN
                   r_EBS_REC_INVOICE_LINES_INT.IMPORTATION_EXPENSE_FUNC := 0;
                END IF;
                --
                Begin
                   PKG_R12_DBL_EXP_INSERT.EBS_REC_INVOICE_LINES_INT(r_EBS_REC_INVOICE_LINES_INT);
                   --
                   exception
                      when others then
                         raise_application_error(-20000,
                                      'Inserindo na REC_INVOICE_LINES_INTERFACE. Erro ' ||
                                      SQLERRM);
                end;
        --Patch Other Custom Expenses
        if NVL(FNC_R12_DBL_GET_DE_PARA('PACK_16', 'PATCH_RI'), 'N') = 'S' then
        --Zera variáveis
                v_n_aux := 0;
                v_n_tot_desp_compoe_icms := 0;
                v_n_tot_desp_n_compoe_icms := 0;
                --
                --Não Somar PIS ou Cofins pois ambos já possuem campos proprios.
                for r_despesas_compoe_icms_item in (select *
                                                      from sfw_importador_despesa impd,
                                                           sfw_parceiro           p
                                                     where impd.compoe_nfe = 'S'
                                                       and impd.compoe_icms = 'S'
                                                       and impd.id_informante =
                                                           p.id_parceiro
                                                       and impd.id_despesa not in ('PIS Importação','COFINS Importação')
                                                       and p.cod_parceiro =
                                                           r_v_bs_api_nfe_nfc.nf_empresa) loop
                  begin
                  select round(valor, 2)
                    into v_n_aux
                    from is_despesas_itens_fatura
                   where num_item = r_V_IS_IT_ITEM_NFE_NFC.nf_ite_item_ped
                     and id_invoice = r_V_IS_IT_ITEM_NFE_NFC.nf_ite_nm_id_invoice
                     and num_item_macro = r_V_IS_IT_ITEM_NFE_NFC.nf_ite_num_item_macro
                     and num_ordem = r_V_IS_IT_ITEM_NFE_NFC.nf_ite_pedido
                     and id_despesa = r_despesas_compoe_icms_item.id_despesa
                     and cod_processo = r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_COD_PROCESSO;
                  exception
                    when no_data_found then
                      v_n_aux := 0;
                     end;
                  v_n_tot_desp_compoe_icms := v_n_tot_desp_compoe_icms + v_n_aux;
                --
                end loop;
                v_n_aux := 0;
                --Não Somar PIS ou Cofins pois ambos já possuem campos proprios.
                for r_despesas_n_compoe_icms_item in (select *
                                                        from sfw_importador_despesa impd,
                                                             sfw_parceiro           p
                                                       where impd.compoe_nfe = 'S'
                                                         and impd.compoe_icms = 'N'
                                                         and impd.id_informante =
                                                             p.id_parceiro
                                                         and impd.id_despesa not in ('PIS Importação','COFINS Importação')
                                                         and p.cod_parceiro =
                                                             r_v_bs_api_nfe_nfc.nf_empresa) loop
                  begin
                  select round(valor, 2)
                    into v_n_aux
                    from is_despesas_itens_fatura
                   where num_item = r_V_IS_IT_ITEM_NFE_NFC.nf_ite_item_ped
                     and id_invoice = r_V_IS_IT_ITEM_NFE_NFC.nf_ite_nm_id_invoice
                     and num_item_macro = r_V_IS_IT_ITEM_NFE_NFC.nf_ite_num_item_macro
                     and num_ordem = r_V_IS_IT_ITEM_NFE_NFC.nf_ite_pedido
                     and id_despesa = r_despesas_n_compoe_icms_item.id_despesa
                     and cod_processo = r_V_IS_IT_ITEM_NFE_NFC.NF_ITE_COD_PROCESSO;
                  exception
                    when no_data_found then
                      v_n_aux := 0;
                     end;
                  v_n_tot_desp_n_compoe_icms := v_n_tot_desp_n_compoe_icms + v_n_aux;
                --
                end loop;
        --update dinamico
                execute immediate 'begin
                   update SFWBR_REC_INVO_LINES_INTER
                    set import_other_val_included_icms = :v_n_tot_desp_compoe_icms,
                      import_other_val_not_icms      = :v_n_tot_desp_n_compoe_icms
                    where INTERFACE_INVOICE_LINE_ID = :r_EBS_REC_INVOICE_LINES_INT.INTERFACE_INVOICE_LINE_ID
                    and INTERFACE_INVOICE_ID = :r_EBS_REC_INVOICE_LINES_INT.INTERFACE_INVOICE_ID;
                   end;'
            using in round(v_n_tot_desp_compoe_icms,2), 
                 round(v_n_tot_desp_n_compoe_icms,2), 
                 r_EBS_REC_INVOICE_LINES_INT.INTERFACE_INVOICE_LINE_ID, 
                 r_EBS_REC_INVOICE_LINES_INT.INTERFACE_INVOICE_ID;
        -- 
        v_n_tot_desp_compoe_icms_h       := v_n_tot_desp_compoe_icms_h + v_n_tot_desp_compoe_icms;
                v_n_tot_desp_n_compoe_icms_h       := v_n_tot_desp_n_compoe_icms_h + v_n_tot_desp_n_compoe_icms;
                v_n_tot_desp_compoe_icms := 0;
                v_n_tot_desp_n_compoe_icms := 0;
                --
        --Patch Other Custom Expenses
        end if;
                -- item de Nota Fiscal Complementar
-- Início Alteração - Marcos R. Carneiro - Chamado: 429944...
--                if r_V_BS_API_NFE_NFC.NF_TPNOTA = 'ND' then
                -- ND - Nota Fiscal de Entrada Complementar.
                -- NC - Nota Fiscal de Entrada Complementar Manual.
                if r_V_BS_API_NFE_NFC.NF_TPNOTA IN ('ND','NC') then
-- Final Alteração - Marcos R. Carneiro - Chamado: 429944...
                   SELECT SFWBR_REC_INVO_LINE_PAR_INT_S.nextval
                   INTO   r_EBS_REC_INVO_LINE_PAR_INT.INTERFACE_PARENT_LINE_ID
                   FROM   DUAL;
                   --
                   r_EBS_REC_INVO_LINE_PAR_INT.INTERFACE_PARENT_ID := r_EBS_REC_INVO_PAR_INT.INVOICE_PARENT_ID;
                   --
                   begin
                      SELECT NUM_ITEM
                      INTO   r_EBS_REC_INVO_LINE_PAR_INT.INVOICE_PARENT_LINE_ID
                      FROM   SFWBR_REC_ITENS_NFE_V I,
                             SFWBR_REC_NFE_V N
                      WHERE  I.INVOICE_ID  = N.INVOICE_ID
                      AND    I.ATTRIBUTE14 = r_EBS_REC_INVOICE_LINES_INT.ATTRIBUTE14
                      AND    I.ATTRIBUTE15 = r_EBS_REC_INVOICE_LINES_INT.ATTRIBUTE15
                      AND    N.NF_DC       = 'D'
                      AND    N.NF_PAI      = 'N'
                      AND    SUBSTR(N.NUM_DOCFIS,
                             1,
                             LENGTH(r_V_BS_API_NFE_NFC.NF_NUM_NF_NFE)) = r_V_BS_API_NFE_NFC.NF_NUM_NF_NFE
                      AND    not exists    (select 1
                                            from   SFWBR_REC_NFE_V B
                                            where  B.NF_DC       = 'C'
                                            and    B.ID_NOTA_PAI = N.INVOICE_ID
                                           );
                      --
                      exception
                         when others then
                            raise_application_error(-20000,
                                        'Erro ao recuperar o item da nota fiscal de entrada no Oracle EBS (CAIBR_REC_ITENS_NFE_V). ' ||
                                        sqlerrm);
                   end;
                   --
                   r_EBS_REC_INVO_LINE_PAR_INT.INTERFACE_PARENT_ID       := r_EBS_REC_INVO_PAR_INT.INTERFACE_PARENT_ID;
                   r_EBS_REC_INVO_LINE_PAR_INT.INTERFACE_INVOICE_LINE_ID := r_EBS_REC_INVOICE_LINES_INT.INTERFACE_INVOICE_LINE_ID;
                   r_EBS_REC_INVO_LINE_PAR_INT.CREATION_DATE             := sysdate;
                   r_EBS_REC_INVO_LINE_PAR_INT.CREATED_BY                := -1;
                   r_EBS_REC_INVO_LINE_PAR_INT.LAST_UPDATE_DATE          := sysdate;
                   r_EBS_REC_INVO_LINE_PAR_INT.LAST_UPDATED_BY           := -1;
                   --
                   Begin
                      PKG_R12_DBL_EXP_INSERT.EBS_REC_INVO_LINE_PAR_INT(r_EBS_REC_INVO_LINE_PAR_INT);
                      --
                      exception
                         when others then
                            raise_application_error(-20000,
                                        'Inserindo na REC_INVOICE_LINE_PARENTS_INT. Erro ' ||
                                        SQLERRM);
                   end;
                end if;
                --
                exception
                   when others then
                      raise_application_error(-20000,
                                    ' item "' ||
                                    r_V_IS_IT_ITEM_NFE_NFC.Nf_Ite_Numite ||
                                    '" . ' || sqlerrm);
             end;
         end loop;
         --
     if NVL(FNC_R12_DBL_GET_DE_PARA('PACK_16', 'PATCH_RI'), 'N') = 'S' then
     execute immediate 'begin
               update SFWBR_REC_INVO_INTER
                set import_other_val_included_icms = :v_n_tot_desp_compoe_icms_h,
                  import_other_val_not_icms      = :v_n_tot_desp_n_compoe_icms_h,
                  dollar_other_val_included_icms = :dollar_other_val_included_icms,
                  dollar_other_val_not_icms     = :dollar_other_val_not_icms
                where INTERFACE_INVOICE_ID = :r_EBS_REC_INVOICE_LINES_INT.INTERFACE_INVOICE_ID;
                end;'
        using in round(v_n_tot_desp_compoe_icms_h,2), 
             round(v_n_tot_desp_n_compoe_icms_h,2), 
             round(is_calculavalormoeda(r_v_bs_api_nfe_nfc.nf_cod_processo,
                  'REAL',
                  'USD',
                  v_n_tot_desp_compoe_icms_h),2),
             round(is_calculavalormoeda(r_v_bs_api_nfe_nfc.nf_cod_processo,
                  'REAL',
                  'USD',
                  v_n_tot_desp_n_compoe_icms_h),2),
             r_EBS_REC_INVOICE_LINES_INT.INTERFACE_INVOICE_ID;
    end if;
     AJUSTE_NOTA_FISCAL_RI(r_EBS_REC_INVOICES_INTERFACE.INTERFACE_INVOICE_ID);
         --
         exception
            when others then
               raise_application_error(-20000,'Problema ao Processar a Nota Fiscal: [' || r_V_BS_API_NFE_NFC.NF_NUMNF ||
                                              '], Série: ['   || r_V_BS_API_NFE_NFC.NF_SERIE ||
                                              '], ID: ['      || r_V_BS_API_NFE_NFC.NF_ID    ||
                                              '], Tipo: ['    || NVL(FNC_R12_DBL_GET_DE_PARA(r_V_BS_API_NFE_NFC.NF_TPNOTA,'IS_OUT_TIPO_NF_RI'),'TIPO DE NOTA FISCAL NAO CONFIGURADO NO DE_PARA: [IS_OUT_TIPO_NF_RI]') ||
                                              ']. Msg.Erro: ' || SQLERRM);
      end;
      -- ponto de customizacao
      pkg_it_user_exit.call_user_exits(p_s_exit_name => 'PKG_R12_DBL_EXP_NOTA_FISCAL_RI.MAPEAMENTO_NOTA_FISCAL_RI.END',
                                       param_in_1    => to_char(p_n_ID_IMPORTACAO),
                                       param_in_2    => to_char(p_n_ID_NOTAFISCAL),
                                       param_out_1   => v_n_exit_return);
   END MAPEAMENTO_NOTA_FISCAL_RI;

   -- =================================================================
   PROCEDURE AJUSTE_NOTA_FISCAL_RI(p_n_INTERFACE_INVOICE_ID IN NUMBER) IS
   -- =================================================================
   v_n_dollar_fob_amount         number;
   v_n_dollar_freight_internacio number;
   v_n_dollar_importation_tax_am number;
   v_n_dollar_insurance_amount   number;
   v_n_fob_amount                number;
   v_n_freight_internacional     number;
   v_n_icms_amount               number;
   v_n_icms_base                 number;
   v_n_importation_cofins_amount number;
   v_n_importation_insurance_amo number;
   v_n_importation_pis_amount    number;
   v_n_importation_tax_amount    number;
   v_n_ipi_amount                number;
   v_n_other_expenses            number;
   v_n_invoice_amount            number;
   v_n_icms_flag                 varchar(1);
   --
   BEGIN
      begin
         -- Header X Lines Adjustments
         select sum(DOLLAR_FOB_AMOUNT),
                sum(DOLLAR_FREIGHT_INTERNACIONAL),
                sum(DOLLAR_IMPORTATION_TAX_AMOUNT),
                sum(DOLLAR_INSURANCE_AMOUNT),
                sum(FOB_AMOUNT),
                sum(FREIGHT_INTERNACIONAL),
                sum(ICMS_AMOUNT),
                sum(ICMS_BASE),
                sum(IMPORTATION_COFINS_AMOUNT),
                sum(IMPORTATION_INSURANCE_AMOUNT),
                sum(IMPORTATION_PIS_AMOUNT),
                sum(IMPORTATION_TAX_AMOUNT),
                sum(IPI_AMOUNT),
                sum(OTHER_EXPENSES)
         into   v_n_dollar_fob_amount,
                v_n_dollar_freight_internacio,
                v_n_dollar_importation_tax_am,
                v_n_dollar_insurance_amount,
                v_n_fob_amount,
                v_n_freight_internacional,
                v_n_icms_amount,
                v_n_icms_base,
                v_n_importation_cofins_amount,
                v_n_importation_insurance_amo,
                v_n_importation_pis_amount,
                v_n_importation_tax_amount,
                v_n_ipi_amount,
                v_n_other_expenses
         FROM   SFWBR_REC_INVO_LINES_INTER
         where  interface_invoice_id = p_n_INTERFACE_INVOICE_ID;
         --
         select DOLLAR_TOTAL_FOB_AMOUNT - v_n_dollar_fob_amount,
                DOLLAR_FREIGHT_INTERNATIONAL - v_n_dollar_freight_internacio,
                DOLLAR_IMPORTATION_TAX_AMOUNT - v_n_dollar_importation_tax_am,
                DOLLAR_INSURANCE_AMOUNT - v_n_dollar_insurance_amount,
                TOTAL_FOB_AMOUNT - v_n_fob_amount,
                FREIGHT_INTERNATIONAL - v_n_freight_internacional,
                ICMS_AMOUNT - v_n_icms_amount,
                ICMS_BASE - v_n_icms_base,
                IMPORTATION_COFINS_AMOUNT - v_n_importation_cofins_amount,
                IMPORTATION_INSURANCE_AMOUNT - v_n_importation_insurance_amo,
                IMPORTATION_PIS_AMOUNT - v_n_importation_pis_amount,
                IMPORTATION_TAX_AMOUNT - v_n_importation_tax_amount,
                IPI_AMOUNT - v_n_ipi_amount,
                OTHER_EXPENSES - v_n_other_expenses
         into   v_n_dollar_fob_amount,
                v_n_dollar_freight_internacio,
                v_n_dollar_importation_tax_am,
                v_n_dollar_insurance_amount,
                v_n_fob_amount,
                v_n_freight_internacional,
                v_n_icms_amount,
                v_n_icms_base,
                v_n_importation_cofins_amount,
                v_n_importation_insurance_amo,
                v_n_importation_pis_amount,
                v_n_importation_tax_amount,
                v_n_ipi_amount,
                v_n_other_expenses
         FROM   SFWBR_REC_INVO_INTER
         where  interface_invoice_id = p_n_INTERFACE_INVOICE_ID;
         --
         if v_n_dollar_fob_amount <> 0 then
            UPDATE SFWBR_REC_INVO_LINES_INTER
            set DOLLAR_FOB_AMOUNT = DOLLAR_FOB_AMOUNT + v_n_dollar_fob_amount
            where interface_invoice_line_id =
               (select interface_invoice_line_id
                  FROM SFWBR_REC_INVO_LINES_INTER
                 where DOLLAR_FOB_AMOUNT =
                       (select max(DOLLAR_FOB_AMOUNT)
                          FROM SFWBR_REC_INVO_LINES_INTER
                         where interface_invoice_id =
                               p_n_INTERFACE_INVOICE_ID)
                   and interface_invoice_id = p_n_INTERFACE_INVOICE_ID
                   and rownum = 1);
         end if;
         --
         if v_n_dollar_freight_internacio <> 0 then
            UPDATE SFWBR_REC_INVO_LINES_INTER
            set DOLLAR_FREIGHT_INTERNACIONAL = DOLLAR_FREIGHT_INTERNACIONAL +
                                              v_n_dollar_freight_internacio
            where interface_invoice_line_id =
               (select interface_invoice_line_id
                  FROM SFWBR_REC_INVO_LINES_INTER
                 where DOLLAR_FREIGHT_INTERNACIONAL =
                       (select max(DOLLAR_FREIGHT_INTERNACIONAL)
                          FROM SFWBR_REC_INVO_LINES_INTER
                         where interface_invoice_id =
                               p_n_INTERFACE_INVOICE_ID)
                   and interface_invoice_id = p_n_INTERFACE_INVOICE_ID
                   and rownum = 1);
         end if;
         --
         if v_n_dollar_importation_tax_am <> 0 then
            UPDATE SFWBR_REC_INVO_LINES_INTER
            set DOLLAR_IMPORTATION_TAX_AMOUNT = DOLLAR_IMPORTATION_TAX_AMOUNT +
                                               v_n_dollar_importation_tax_am
            where interface_invoice_line_id =
               (select interface_invoice_line_id
                  FROM SFWBR_REC_INVO_LINES_INTER
                 where DOLLAR_IMPORTATION_TAX_AMOUNT =
                       (select max(DOLLAR_IMPORTATION_TAX_AMOUNT)
                          FROM SFWBR_REC_INVO_LINES_INTER
                         where interface_invoice_id =
                               p_n_INTERFACE_INVOICE_ID)
                   and interface_invoice_id = p_n_INTERFACE_INVOICE_ID
                   and rownum = 1);
         end if;
         --
         if v_n_dollar_insurance_amount <> 0 then
            UPDATE SFWBR_REC_INVO_LINES_INTER
            set DOLLAR_INSURANCE_AMOUNT = DOLLAR_INSURANCE_AMOUNT +
                                         v_n_dollar_insurance_amount
            where interface_invoice_line_id =
               (select interface_invoice_line_id
                  FROM SFWBR_REC_INVO_LINES_INTER
                 where DOLLAR_INSURANCE_AMOUNT =
                       (select max(DOLLAR_INSURANCE_AMOUNT)
                          FROM SFWBR_REC_INVO_LINES_INTER
                         where interface_invoice_id =
                               p_n_INTERFACE_INVOICE_ID)
                   and interface_invoice_id = p_n_INTERFACE_INVOICE_ID
                   and rownum = 1);
         end if;
         --
         if v_n_fob_amount <> 0 then
            UPDATE SFWBR_REC_INVO_LINES_INTER
            set FOB_AMOUNT = FOB_AMOUNT + v_n_fob_amount
            where interface_invoice_line_id =
               (select interface_invoice_line_id
                  FROM SFWBR_REC_INVO_LINES_INTER
                 where FOB_AMOUNT =
                       (select max(FOB_AMOUNT)
                          FROM SFWBR_REC_INVO_LINES_INTER
                         where interface_invoice_id =
                               p_n_INTERFACE_INVOICE_ID)
                   and interface_invoice_id = p_n_INTERFACE_INVOICE_ID
                   and rownum = 1);
         end if;
         --
         if v_n_freight_internacional <> 0 then
            UPDATE SFWBR_REC_INVO_LINES_INTER
            set FREIGHT_INTERNACIONAL = FREIGHT_INTERNACIONAL +
                                       v_n_freight_internacional
            where interface_invoice_line_id =
               (select interface_invoice_line_id
                  FROM SFWBR_REC_INVO_LINES_INTER
                 where FREIGHT_INTERNACIONAL =
                       (select max(FREIGHT_INTERNACIONAL)
                          FROM SFWBR_REC_INVO_LINES_INTER
                         where interface_invoice_id =
                               p_n_INTERFACE_INVOICE_ID)
                   and interface_invoice_id = p_n_INTERFACE_INVOICE_ID
                   and rownum = 1);
         end if;
         --
         if v_n_icms_amount <> 0 then
            UPDATE SFWBR_REC_INVO_LINES_INTER
            set ICMS_AMOUNT = ICMS_AMOUNT + v_n_icms_amount
            where interface_invoice_line_id =
               (select interface_invoice_line_id
                  FROM SFWBR_REC_INVO_LINES_INTER
                 where ICMS_AMOUNT =
                       (select max(ICMS_AMOUNT)
                          FROM SFWBR_REC_INVO_LINES_INTER
                         where interface_invoice_id =
                               p_n_INTERFACE_INVOICE_ID)
                   and interface_invoice_id = p_n_INTERFACE_INVOICE_ID
                   and rownum = 1);
         end if;
         --
         if v_n_icms_base <> 0 then
            UPDATE SFWBR_REC_INVO_LINES_INTER
            set ICMS_BASE = ICMS_BASE + v_n_icms_base
            where interface_invoice_line_id =
               (select interface_invoice_line_id
                  FROM SFWBR_REC_INVO_LINES_INTER
                 where ICMS_BASE =
                       (select max(ICMS_BASE)
                          FROM SFWBR_REC_INVO_LINES_INTER
                         where interface_invoice_id =
                               p_n_INTERFACE_INVOICE_ID)
                   and interface_invoice_id = p_n_INTERFACE_INVOICE_ID
                   and rownum = 1);
         end if;
         --
         if v_n_importation_cofins_amount <> 0 then
            UPDATE SFWBR_REC_INVO_LINES_INTER
            set IMPORTATION_COFINS_AMOUNT = IMPORTATION_COFINS_AMOUNT +
                                           v_n_importation_cofins_amount
            where interface_invoice_line_id =
               (select interface_invoice_line_id
                  FROM SFWBR_REC_INVO_LINES_INTER
                 where IMPORTATION_COFINS_AMOUNT =
                       (select max(IMPORTATION_COFINS_AMOUNT)
                          FROM SFWBR_REC_INVO_LINES_INTER
                         where interface_invoice_id =
                               p_n_INTERFACE_INVOICE_ID)
                   and interface_invoice_id = p_n_INTERFACE_INVOICE_ID
                   and rownum = 1);
         end if;
         --
         if v_n_importation_insurance_amo <> 0 then
            UPDATE SFWBR_REC_INVO_LINES_INTER
            set IMPORTATION_INSURANCE_AMOUNT = IMPORTATION_INSURANCE_AMOUNT +
                                              v_n_importation_insurance_amo
            where interface_invoice_line_id =
               (select interface_invoice_line_id
                  FROM SFWBR_REC_INVO_LINES_INTER
                 where IMPORTATION_INSURANCE_AMOUNT =
                       (select max(IMPORTATION_INSURANCE_AMOUNT)
                          FROM SFWBR_REC_INVO_LINES_INTER
                         where interface_invoice_id =
                               p_n_INTERFACE_INVOICE_ID)
                   and interface_invoice_id = p_n_INTERFACE_INVOICE_ID
                   and rownum = 1);
         end if;
         --
         if v_n_importation_pis_amount <> 0 then
            UPDATE SFWBR_REC_INVO_LINES_INTER
            set IMPORTATION_PIS_AMOUNT = IMPORTATION_PIS_AMOUNT +
                                        v_n_importation_pis_amount
            where interface_invoice_line_id =
               (select interface_invoice_line_id
                  FROM SFWBR_REC_INVO_LINES_INTER
                 where IMPORTATION_PIS_AMOUNT =
                       (select max(IMPORTATION_PIS_AMOUNT)
                          FROM SFWBR_REC_INVO_LINES_INTER
                         where interface_invoice_id =
                               p_n_INTERFACE_INVOICE_ID)
                   and interface_invoice_id = p_n_INTERFACE_INVOICE_ID
                   and rownum = 1);
         end if;
         --
         if v_n_importation_tax_amount <> 0 then
            UPDATE SFWBR_REC_INVO_LINES_INTER
            set IMPORTATION_TAX_AMOUNT = IMPORTATION_TAX_AMOUNT +
                                        v_n_importation_tax_amount
            where interface_invoice_line_id =
               (select interface_invoice_line_id
                  FROM SFWBR_REC_INVO_LINES_INTER
                 where IMPORTATION_TAX_AMOUNT =
                       (select max(IMPORTATION_TAX_AMOUNT)
                          FROM SFWBR_REC_INVO_LINES_INTER
                         where interface_invoice_id =
                               p_n_INTERFACE_INVOICE_ID)
                   and interface_invoice_id = p_n_INTERFACE_INVOICE_ID
                   and rownum = 1);
         end if;
         --
         if v_n_ipi_amount <> 0 then
            UPDATE SFWBR_REC_INVO_LINES_INTER
            set IPI_AMOUNT = IPI_AMOUNT + v_n_ipi_amount
            where interface_invoice_line_id =
               (select interface_invoice_line_id
                  FROM SFWBR_REC_INVO_LINES_INTER
                 where IPI_AMOUNT =
                       (select max(IPI_AMOUNT)
                          FROM SFWBR_REC_INVO_LINES_INTER
                         where interface_invoice_id =
                               p_n_INTERFACE_INVOICE_ID)
                   and interface_invoice_id = p_n_INTERFACE_INVOICE_ID
                   and rownum = 1);
         end if;
         --
         if v_n_other_expenses <> 0 then
            UPDATE SFWBR_REC_INVO_LINES_INTER
            set OTHER_EXPENSES = OTHER_EXPENSES + v_n_other_expenses
            where interface_invoice_line_id =
               (select interface_invoice_line_id
                  FROM SFWBR_REC_INVO_LINES_INTER
                 where OTHER_EXPENSES =
                       (select max(OTHER_EXPENSES)
                          FROM SFWBR_REC_INVO_LINES_INTER
                         where interface_invoice_id =
                               p_n_INTERFACE_INVOICE_ID)
                   and interface_invoice_id = p_n_INTERFACE_INVOICE_ID
                   and rownum = 1);
         end if;
         --
     update SFWBR_REC_INVO_LINES_INTER
           set unit_price = net_amount / quantity
         where interface_invoice_id = p_n_interface_invoice_id;
     if nvl(FNC_R12_DBL_GET_DE_PARA('PACK_16', 'PATCH_RI'), 'N') = 'N' then
        update SFWBR_REC_INVO_LINES_INTER
           set net_amount = unit_price * quantity
         where interface_invoice_id = p_n_interface_invoice_id;
    end if;
          -- Invoice Amount Ajustment
          select decode(count(1), 1, 'S', 'N')
            into v_n_icms_flag
            from sfw_tipo_despesa       d,
                 sfw_importador_despesa s,
                 sfw_parceiro           p,
                 SFWBR_REC_INVO_INTER   h,
                 v_bs_api_nfe_nfc       bs
           where d.id_despesa = s.id_despesa(+)
             and s.compoe_vlr_nf = 'S'
             and d.id_despesa = 'ICMS'
             and s.id_informante = p.id_parceiro
             and p.cod_parceiro = bs.nf_empresa
             and h.cin_attribute1 = bs.NF_ID
             and h.interface_invoice_id = p_n_interface_invoice_id;
        if NVL(FNC_R12_DBL_GET_DE_PARA('PACK_16', 'PATCH_RI'), 'N') = 'S' then
              if v_n_icms_flag = 'S' then
                --ICMS compoe o Header, portanto soma nos itens pra fazer a validação
                select sum(total_amount /*+ other_expenses*/
                           +importation_cofins_amount + importation_pis_amount +
                           icms_amount)
                  into v_n_invoice_amount
                  from SFWBR_REC_INVO_LINES_INTER
                 where interface_invoice_id = p_n_interface_invoice_id;
              else
                -- ICMS nao compoe header, nao soma nos itens
                select sum(total_amount /*+ other_expenses*/
                           +importation_cofins_amount + importation_pis_amount)
                  into v_n_invoice_amount
                  from SFWBR_REC_INVO_LINES_INTER
                 where interface_invoice_id = p_n_interface_invoice_id;
              end if; -- icms
              --
            else
              -- patch
              if v_n_icms_flag = 'S' then
                --ICMS compoe o Header, portanto soma nos itens pra fazer a validação
                select sum(total_amount + other_expenses +
                           importation_cofins_amount + importation_pis_amount +
                           icms_amount)
                  into v_n_invoice_amount
                  from SFWBR_REC_INVO_LINES_INTER
                 where interface_invoice_id = p_n_interface_invoice_id;
              else
                -- ICMS nao compoe header, nao soma nos itens
                select sum(total_amount + other_expenses +
                           importation_cofins_amount + importation_pis_amount)
                  into v_n_invoice_amount
                  from SFWBR_REC_INVO_LINES_INTER
                 where interface_invoice_id = p_n_interface_invoice_id;
              end if; -- icms
            end if; -- patch
         --
         select INVOICE_AMOUNT - v_n_invoice_amount
         into   v_n_invoice_amount
         FROM   SFWBR_REC_INVO_INTER
         where  interface_invoice_id = p_n_INTERFACE_INVOICE_ID;
         --
         if v_n_invoice_amount <> 0 then
            UPDATE SFWBR_REC_INVO_LINES_INTER
            set TOTAL_AMOUNT = TOTAL_AMOUNT + v_n_invoice_amount
            where interface_invoice_line_id =
               (select interface_invoice_line_id
                  FROM SFWBR_REC_INVO_LINES_INTER
                 where TOTAL_AMOUNT =
                       (select max(TOTAL_AMOUNT)
                          FROM SFWBR_REC_INVO_LINES_INTER
                         where interface_invoice_id =
                               p_n_INTERFACE_INVOICE_ID)
                   and interface_invoice_id = p_n_INTERFACE_INVOICE_ID
                   and rownum = 1);
         end if;
         --
         -- Total FOB Amount
         select sum(importation_cofins_amount + importation_pis_amount +
                 (quantity * unit_price))
         into   v_n_invoice_amount
         FROM   SFWBR_REC_INVO_LINES_INTER
         where  interface_invoice_id = p_n_INTERFACE_INVOICE_ID;
         --
         select (total_fob_amount + freight_international +
                importation_insurance_amount + importation_tax_amount +
                importation_pis_amount + importation_cofins_amount) -
                v_n_invoice_amount
         into   v_n_invoice_amount
         FROM   SFWBR_REC_INVO_INTER
         where interface_invoice_id = p_n_INTERFACE_INVOICE_ID;
         --
         if v_n_invoice_amount <> 0 then
            UPDATE SFWBR_REC_INVO_INTER
            set total_fob_amount = total_fob_amount - v_n_invoice_amount
            where interface_invoice_id = p_n_INTERFACE_INVOICE_ID;
         end if;
         --
         -- Header Adjustments
         UPDATE SFWBR_REC_INVO_INTER
         set total_cif_amount = TOTAL_FOB_AMOUNT +
                                IMPORTATION_INSURANCE_AMOUNT +
                                FREIGHT_INTERNATIONAL
         where interface_invoice_id = p_n_INTERFACE_INVOICE_ID;
         --
         exception
            when others then
               raise_application_error(-20000,
                                'An error occurred on adjustments procedure. ' ||
                                sqlerrm);
      end;
      --
   END AJUSTE_NOTA_FISCAL_RI;
   --
END PKG_R12_DBL_EXP_NOTA_FISCAL_RI;
/