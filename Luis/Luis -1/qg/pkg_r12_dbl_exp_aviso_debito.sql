CREATE OR REPLACE PACKAGE BODY PKG_R12_DBL_EXP_AVISO_DEBITO IS

-- ===============================================================
PROCEDURE MAPEAMENTO_AVISO_DEBITO(p_n_ID_TRANSACAO  IN NUMBER,
                                  p_n_ID_IMPORTACAO IN NUMBER,
                                  p_s_NUM_INVOICE   IN VARCHAR2) IS
-- ===============================================================
--
r_invoice                       es_invoices%rowtype;
r_ra_interface_lines_all        sfwbr_ra_interface_lines_all%rowtype;
r_ra_interface_salescredits     sfwbr_ra_inter_salescredits_al%rowtype;
v_n_num_itens                   number;
v_s_local_currency              varchar2(20);
v_n_line_number                 number := 0;
v_n_sum_expenses                number := 0;
v_s_cond_pagto                  es_invoices.cod_cond_pagto_comercial%type;
v_s_cobertura_cambial           sfw_modalidade_transacao.cobertura_cambial_transacao%type;
--
v_s_config_incoterm_x_org       varchar2(1);
v_n_id_organizacao              number;
--
v_n_exit_return                varchar2(4000);
--
v_s_proc_vb                    varchar2(1);
--
BEGIN
   -- ponto de customizacao
   pkg_it_user_exit.call_user_exits(p_s_exit_name => 'PKG_R12_DBL_EXP_AVISO_DEBITO.MAPEAMENTO_AVISO_DEBITO.BEGIN',
                                    param_in_1    => to_char(p_n_ID_TRANSACAO),
                                    param_in_2    => to_char(p_n_ID_IMPORTACAO),
                                    param_in_3    => p_s_NUM_INVOICE,
                                    param_out_1   => v_n_exit_return);
   -- tratamento se processa ou não a Versão Base
   v_s_proc_vb := pkg_it_user_exit.get_processa_versao_base('PKG_R12_DBL_EXP_AVISO_DEBITO.MAPEAMENTO_AVISO_DEBITO.BEGIN');
   --
   if NVL(v_s_proc_vb,'Y') = 'Y' then
   -- selecao da fatura
     begin
        select *
        into   r_invoice
        from   es_invoices a
        where  a.num_invoice = p_s_NUM_INVOICE;
        --
     exception
        when others then
  --         raise_application_error(-20000, 'Unable to retrieve the invoice from Export Sys! Detail: ' || sqlerrm);
           raise_application_error(-20000,'Fatura não encontrada no Export Sys! Detalhe: ' || sqlerrm);
     end;
     --
     select count(1)
     into   v_n_num_itens
     from   es_invoices_itens
     where  num_invoice = p_s_NUM_INVOICE;
     --
     if v_n_num_itens = 0
     then
  --      raise_application_error(-20000, 'Unable to retrieve the invoice lines from Export Sys!');
        raise_application_error(-20000, 'Item(s) da Fatura não encontrado(s) no Export Sys!');
     end if;
     --
     begin
        select id_organizacao
        into   v_n_id_organizacao
        from   es_areas_negocio a
        where  a.cod_area_neg = r_invoice.cod_area_invoice;
        --
        select decode(count(1), 0, 'N', 'S')
        into   v_s_config_incoterm_x_org
        from   es_incoterms_x_despesas c
        where  c.id_organizacao = v_n_id_organizacao;
        --
        exception
           when others then
              raise_application_error(-20000,
  --                                    'Error retrieving the Expenses X Incoterm configuration to this organization. Detail: ' ||
                                      'Erro ao recuperar Despesas X configuração de Fatura para esta organização. Detalhe: ' ||
                                      sqlerrm);
     end;
     --
     begin
        select a.cod_cond_pagto_comercial,
               c.cobertura_cambial_transacao
        into   v_s_cond_pagto,
               v_s_cobertura_cambial
        from   es_invoices              a,
               sfw_cond_pagamento       b,
               sfw_modalidade_transacao c
        where  a.num_invoice              = p_s_NUM_INVOICE
        and    a.cod_cond_pagto_comercial = b.cod_cond_pagto
        and    b.cod_mod_transacao        = c.cod_mod_transacao(+);
        --
        exception
           when others then
              raise_application_error(-20000,
  --                                    'Unable to retrieve the invoice payment term and term transaction type from Export Sys! Detail: ' ||
                                      'Não encontrado a Condição de Pagamento da Fatura e Tipo de Transação no Export Sys! Detalhe: ' ||
                                      sqlerrm);
     end;
     --
     if v_s_cobertura_cambial = 'N' or
        v_s_cobertura_cambial is null
     then
        raise_application_error(-20000,
  /*
                                'Payment term ' || v_s_cond_pagto ||
                                ' is NO_CHARGE. This invoice will not generate receivables!');
  */
                                'Condição de Pagamento ' || v_s_cond_pagto ||
                                ' é NO_CHARGE. Esta fatura não gerará recebimentos! ');
     end if;
     --
     delete sfwbr_ra_interface_lines_all
     where  document_number = p_n_ID_TRANSACAO;
     --
     r_ra_interface_lines_all.document_number           := p_n_ID_TRANSACAO;
     r_ra_interface_lines_all.interface_line_context    := NVL(FNC_R12_DBL_GET_DE_PARA('INTERFACE_LINE_CONTEXT','EX_OUT_CONFIG_AVISO_DEBITO'),'SOFTWAY');
     r_ra_interface_lines_all.interface_line_attribute1 := r_invoice.num_invoice;
     r_ra_interface_lines_all.line_type                 := NVL(FNC_R12_DBL_GET_DE_PARA('LINE_TYPE','EX_OUT_CONFIG_AVISO_DEBITO'),'LINE');
     r_ra_interface_lines_all.term_name                 := r_invoice.cod_cond_pagto_comercial;
     r_ra_interface_lines_all.conversion_type           := NVL(FNC_R12_DBL_GET_DE_PARA('CONVERSION_TYPE','EX_OUT_CONFIG_AVISO_DEBITO'),'User');
     r_ra_interface_lines_all.currency_code             := r_invoice.cod_moeda;
     r_ra_interface_lines_all.comments                  := 'Softway Interface - Export Sys - Invoice: ' || p_s_NUM_INVOICE;
     r_ra_interface_lines_all.tax_exempt_flag           := NVL(FNC_R12_DBL_GET_DE_PARA('TAX_EXEMPT_FLAG','EX_OUT_CONFIG_AVISO_DEBITO'),'S');
     r_ra_interface_lines_all.trx_number                := r_invoice.num_invoice;
     r_ra_interface_lines_all.request_id                := NVL(FNC_R12_DBL_GET_DE_PARA('REQUEST_ID','EX_OUT_CONFIG_AVISO_DEBITO'),-1);
     r_ra_interface_lines_all.batch_source_name         := NVL(FNC_R12_DBL_GET_DE_PARA('BATCH_SOURCE_NAME','EX_OUT_CONFIG_AVISO_DEBITO'),'SOFTWAY');
     --
     r_ra_interface_lines_all.line_gdf_attribute4       := NVL(FNC_R12_DBL_GET_DE_PARA('LINE_GDF_ATTRIBUTE4','EX_OUT_CONFIG_AVISO_DEBITO'),'0');
     r_ra_interface_lines_all.line_gdf_attribute5       := NVL(FNC_R12_DBL_GET_DE_PARA('LINE_GDF_ATTRIBUTE5','EX_OUT_CONFIG_AVISO_DEBITO'),'B');
     r_ra_interface_lines_all.line_gdf_attribute6       := NVL(FNC_R12_DBL_GET_DE_PARA('LINE_GDF_ATTRIBUTE6','EX_OUT_CONFIG_AVISO_DEBITO'),'00');
     r_ra_interface_lines_all.line_gdf_attribute7       := NVL(FNC_R12_DBL_GET_DE_PARA('LINE_GDF_ATTRIBUTE7','EX_OUT_CONFIG_AVISO_DEBITO'),'00');
     r_ra_interface_lines_all.line_gdf_attribute9       := NVL(FNC_R12_DBL_GET_DE_PARA('LINE_GDF_ATTRIBUTE9','EX_OUT_CONFIG_AVISO_DEBITO'),NULL);
     r_ra_interface_lines_all.line_gdf_attribute10      := NVL(FNC_R12_DBL_GET_DE_PARA('LINE_GDF_ATTRIBUTE10','EX_OUT_CONFIG_AVISO_DEBITO'),NULL);
     r_ra_interface_lines_all.line_gdf_attribute11      := NVL(FNC_R12_DBL_GET_DE_PARA('LINE_GDF_ATTRIBUTE11','EX_OUT_CONFIG_AVISO_DEBITO'),NULL);
     --
     select es_get_dt_averbacao_invoice(p_s_NUM_INVOICE)
     into   r_ra_interface_lines_all.trx_date
     from   dual;
     --
     select es_get_dt_averbacao_invoice(p_s_NUM_INVOICE)
     into   r_ra_interface_lines_all.gl_date
     from   dual;
     --
     select es_get_data_embarque_conhecime(p_s_NUM_INVOICE)
     into   r_ra_interface_lines_all.conversion_date
     from   dual;
     --
     if r_ra_interface_lines_all.conversion_date is null
     then
        raise_application_error(-20000,
  --                              'Unable to get the shipment date from Export Sys. The check point "Embarque da Mercadoria" must be finished!');
                                'Não foi possível obter a data da remessa no Export Sys. O Check-Point "Embarque da Mercadoria" deve ser finalizado!');
     end if;
     --
     select es_get_moeda_local
     into   v_s_local_currency
     from   dual;
     --
     select es_fnc_es_taxa_conversao_dia_a(r_invoice.cod_moeda,
                                           v_s_local_currency,
                                           '01',
                                           r_ra_interface_lines_all.conversion_date)
     into   r_ra_interface_lines_all.conversion_rate
     from   dual;
     --
     if r_ra_interface_lines_all.conversion_rate is null
     then
        raise_application_error(-20000,
  /*
                                'Unable to get the conversion rate from Export Sys where source currency code = ''' ||
                                r_invoice.cod_moeda || ''' and target currency code = ''' || v_s_local_currency ||
                                ''' and conversion date = ' ||
                                to_char(r_ra_interface_lines_all.conversion_date, 'dd/mm/yyyy') ||
                                ' and category = ''Comercial Venda''. Detail: ' || sqlerrm);
  */
                                'Não foi possível obter a taxa de conversão no Export Sys para a moeda origem = ''' ||
                                r_invoice.cod_moeda || ''', moeda destino = ''' || v_s_local_currency ||
                                ''', data de conversão = ' ||
                                to_char(r_ra_interface_lines_all.conversion_date, ' dd/mm/yyyy ') ||
                                ' e categoria = ''Comercial Venda''. Detalhe: ' || sqlerrm);
     end if;
     --
     begin
        select a.flex_field3,
               a.flex_field2
        into   r_ra_interface_lines_all.orig_system_bill_customer_id,
               r_ra_interface_lines_all.orig_system_bill_address_id
        from   sfw_parceiro          a,
               es_invoices_parceiros b
        where  a.id_parceiro         = b.id_parceiro_invoice
        and    b.cod_funcao_parceiro = 'EXPG' -- parceiro pagador
        and    b.num_invoice         = r_invoice.num_invoice;
        --
        exception
           when others then
  --            raise_application_error(-20000,'Error retrieving the BILL_TO (EXPG) partner. Detail: ' || sqlerrm);
              raise_application_error(-20000,'Erro ao recuperar o parceiro pagador BILL_TO (EXPG). Detalhe: ' || sqlerrm);
     end;
     --
     begin
        select a.flex_field3,
               a.flex_field2
        into   r_ra_interface_lines_all.orig_system_ship_customer_id,
               r_ra_interface_lines_all.orig_system_ship_address_id
        from   sfw_parceiro a,
               es_invoices_parceiros b
        where  a.id_parceiro         = b.id_parceiro_invoice
        and    b.cod_funcao_parceiro = 'EXRM' -- parceiro receptor
        and    b.num_invoice         = r_invoice.num_invoice;
        --
        exception
           when others then
  --            raise_application_error(-20000, 'Error retrieving the SHIP_TO (EXRM) partner. Detail: ' || sqlerrm);
              raise_application_error(-20000,'Erro ao recuperar o parceiro recebedor SHIP_TO (EXRM). Detalhe: ' || sqlerrm);
     end;
     --
     begin
        select substr(a.cod_parceiro,1,instr(a.cod_parceiro,'.')-1) --a.flex_field3
        into   r_ra_interface_lines_all.orig_system_sold_customer_id
        from   sfw_parceiro a, es_invoices_parceiros b
        where  a.id_parceiro         = b.id_parceiro_invoice
        and    b.cod_funcao_parceiro = 'EXEM' -- parceiro cliente
        and    b.num_invoice         = r_invoice.num_invoice;
        --
        exception
           when others then
  --            raise_application_error(-20000, 'Error retrieving the SOLD_TO (EXEM) partner. Detail: ' || sqlerrm);
              raise_application_error(-20000,'Erro ao recuperar o parceiro cliente SOLD_TO (EXEM). Detalhe: ' || sqlerrm);
     end;
     --
     begin
        select desc_tp_exp
        into   r_ra_interface_lines_all.cust_trx_type_name
        from   es_tipo_exportacao e
        where  e.cod_tp_exportacao = r_invoice.cod_tp_exportacao;
        --
        exception
           when others then
  --            raise_application_error(-20000,'Unable to retrieve the transaction type from Export Sys! Detail: ' || sqlerrm);
              raise_application_error(-20000,'Não encontrado o tipo de transação no Export Sys! Detalhe: ' || sqlerrm);
     end;
     --
     for r_invoice_lines in (select *
                             from   es_invoices_itens
                             where  num_invoice = p_s_NUM_INVOICE)
     loop
         begin
            r_ra_interface_lines_all.interface_line_attribute2 := r_invoice_lines.seq_item_invoice;
            r_ra_interface_lines_all.description               := r_invoice_lines.desc_item_invoice;
            r_ra_interface_lines_all.amount                    := r_invoice_lines.valor_total_vmcv_item_invoice;
            r_ra_interface_lines_all.line_number               := r_invoice_lines.seq_item_invoice;
            r_ra_interface_lines_all.quantity                  := r_invoice_lines.qtde_item_invoice;
            r_ra_interface_lines_all.quantity_ordered          := r_invoice_lines.qtde_item_invoice;
            --r_ra_interface_lines_all.unit_selling_price        := round(r_invoice_lines.valor_unit_vmcv_item_invoice,2);
            --r_ra_interface_lines_all.unit_standard_price       := round(r_invoice_lines.valor_unit_vmcv_item_invoice,2);
            --r_ra_interface_lines_all.uom_code                  := r_invoice_lines.cod_unidade_medida_item_inv;
            r_ra_interface_lines_all.line_gdf_attribute6       := '00';
            r_ra_interface_lines_all.line_gdf_attribute7       := '00';
            --
            begin
               select substr(a.num_ordem_item_proc, 1, instr(a.num_ordem_item_proc, '.') - 1),
                      to_char(b.atrib_flex_number_3),
                      nvl(replace(a.cfop_externo, '.', ''),'7949'),
                      a.cod_ncm_item_proc,
                      b.atrib_flex_vc_string_1, -- header_id --transaction_reason_code
                      b.atrib_flex_number_4,
                      b.atrib_flex_number_2
               into   r_ra_interface_lines_all.interface_line_attribute3,
                      r_ra_interface_lines_all.interface_line_attribute4,
                      r_ra_interface_lines_all.line_gdf_attribute1,
                      r_ra_interface_lines_all.line_gdf_attribute2,
                      r_ra_interface_lines_all.line_gdf_attribute3,
                      r_ra_interface_lines_all.org_id,
                      r_ra_interface_lines_all.interface_line_attribute6
               from   es_processos_itens a,
                      es_ordens_itens    b
               where  a.num_ordem_item_proc      = b.num_ordem
               and    a.seq_item_ordem_item_proc = b.seq_item_ordem
               and    a.seq_item_proc            = r_invoice_lines.seq_item_proc_item_invoice
               and    a.num_processo             = r_invoice_lines.num_processo_item_invoice;
               --
               exception
                  when others then
                     raise_application_error(-20000,
  /*
                                             'Unable to get the related Exportation Process item and Sales Order Item where PROCESSOS_ITENS.SEQ_ITEM_PROC = ' ||
                                             nvl(to_char(r_invoice_lines.seq_item_proc_item_invoice), 'null') ||
                                             '! Detail: ' ||
  */
                                             'Não foi possível relacionar o Item do Processo de Exportação com o Item da Ordem de Venda para o PROCESSOS_ITENS.SEQ_ITEM_PROC = ' ||
                                             nvl(to_char(r_invoice_lines.seq_item_proc_item_invoice), 'null') ||
                                             '! Detalhe: ' ||
                                             sqlerrm);
            end;
            --
            begin
               select to_number(a.flex_field2),
                      unidade_estoque,
                      a.flex_field1
               into   r_ra_interface_lines_all.inventory_item_id,
                      r_ra_interface_lines_all.uom_code,
                      r_ra_interface_lines_all.warehouse_id
               from   sfw_produto a
               where  a.id_produto = r_invoice_lines.id_produto_item_invoice;
               --
               exception
                  when others then
                     raise_application_error(-20000,
  /*
                                             'Unable to get the product Part Number where SFW_PRODUTO.ID_PRODUTO = ' ||
                                             nvl(r_invoice_lines.id_produto_item_invoice, 'NULL') || '! Detail: ' ||
  */
                                             'Não foi possível encontrar o Part Number para o SFW_PRODUTO.ID_PRODUTO = ' ||
                                             nvl(r_invoice_lines.id_produto_item_invoice,'NULL') || '! Detalhe: ' ||
                                             sqlerrm);
            end;
            --
  /*        begin
               select a.atrib_flex_number_2
               into r_ra_interface_lines_all.warehouse_id
               from es_processos a
               where a.num_processo = r_invoice_lines.num_processo_item_invoice;
               --
               exception
                  when others then
                     raise_application_error(-20000,
                                             'Unable to retrieve the ORG_ID trought the Exportation Process where PROCESSOS.NUM_PROCESSO = ' ||
                                             nvl(r_invoice_lines.num_processo_item_invoice, 'NULL') || '! Detail: ' ||
                                             sqlerrm);
            end;
  */
            --
            -- Envio do credito do vendendor
            --
            r_ra_interface_salescredits.interface_line_context     := r_ra_interface_lines_all.interface_line_context;
            r_ra_interface_salescredits.interface_line_attribute1  := r_ra_interface_lines_all.interface_line_attribute1;
            r_ra_interface_salescredits.interface_line_attribute2  := r_ra_interface_lines_all.interface_line_attribute2;
            r_ra_interface_salescredits.interface_line_attribute3  := r_ra_interface_lines_all.interface_line_attribute3;
            r_ra_interface_salescredits.interface_line_attribute4  := r_ra_interface_lines_all.interface_line_attribute4;
            r_ra_interface_salescredits.interface_line_attribute5  := r_ra_interface_lines_all.interface_line_attribute5;
            r_ra_interface_salescredits.interface_line_attribute6  := r_ra_interface_lines_all.interface_line_attribute6;
            r_ra_interface_salescredits.interface_line_attribute7  := r_ra_interface_lines_all.interface_line_attribute7;
            r_ra_interface_salescredits.interface_line_attribute8  := r_ra_interface_lines_all.interface_line_attribute8;
            r_ra_interface_salescredits.interface_line_attribute9  := r_ra_interface_lines_all.interface_line_attribute9;
            r_ra_interface_salescredits.interface_line_attribute10 := r_ra_interface_lines_all.interface_line_attribute10;
            r_ra_interface_salescredits.interface_line_attribute11 := r_ra_interface_lines_all.interface_line_attribute11;
            r_ra_interface_salescredits.interface_line_attribute12 := r_ra_interface_lines_all.interface_line_attribute12;
            r_ra_interface_salescredits.interface_line_attribute13 := r_ra_interface_lines_all.interface_line_attribute13;
            r_ra_interface_salescredits.interface_line_attribute14 := r_ra_interface_lines_all.interface_line_attribute14;
            r_ra_interface_salescredits.interface_line_attribute15 := r_ra_interface_lines_all.interface_line_attribute15;
            r_ra_interface_salescredits.sales_credit_type_id       := NVL(FNC_R12_DBL_GET_DE_PARA('SALES_CREDIT_TYPE_ID','EX_OUT_CONFIG_AVISO_DEBITO'),1);
            r_ra_interface_salescredits.sales_credit_amount_split  := r_ra_interface_lines_all.amount;
            r_ra_interface_salescredits.sales_credit_percent_split := NVL(FNC_R12_DBL_GET_DE_PARA('SALES_CREDIT_PERCENT_SPLIT','EX_OUT_CONFIG_AVISO_DEBITO'),100);
            r_ra_interface_salescredits.attribute1                 := p_n_id_transacao;
            r_ra_interface_salescredits.org_id                     := r_ra_interface_lines_all.org_id;
            --
            -- recupera o salesrep_id
            --
            begin
               select a.primary_salesrep_id
               into   r_ra_interface_salescredits.salesrep_id
  --             from   bck_ra_interface_lines_all a
               from   r12_dbl_bck_ra_inter_lines_all a
               where  a.interface_line_attribute3 = r_invoice_lines.num_processo_item_invoice
               and    rownum = 1;
               --
               exception
                  when no_data_found then
                     null;
                  when others then
                     raise_application_error(-20000,
  /*
                                             'Unable to retrieve the primary_salesrep_id trought the Exportation Process where PROCESSOS.NUM_PROCESSO = ' ||
                                             nvl(r_invoice_lines.num_processo_item_invoice,
                                             'NULL') || '! Detail: ' ||
  */
                                             'Não encontrado o primary_salesrep_id do Processo de Exportação para o PROCESSOS.NUM_PROCESSO = ' ||
                                             nvl(r_invoice_lines.num_processo_item_invoice,
                                             ' NULL') || '! Detalhe: ' ||
                                             sqlerrm);
            end;
            --
            r_ra_interface_lines_all.PRIMARY_SALESREP_ID         := r_ra_interface_salescredits.salesrep_id;
            --
  /*
            insert into ra_interface_lines_all
            values r_ra_interface_lines_all;
            --
            insert into ra_interface_salescredits_all
            values r_ra_interface_salescredits;
  */
            --
            -- Insert RA_INTERFACE_LINES_ALL...
            --
            BEGIN
               PKG_R12_DBL_EXP_INSERT.EBS_RA_INTERFACE_LINES_ALL(r_ra_interface_lines_all);
               --
               exception
                  when others then
                     raise_application_error(-20000,
                                  'Erro ao Inserir a linha de  Aviso de Débito no oracle para o Header_id / Ordem: ' ||
                                  r_ra_interface_lines_all.line_gdf_attribute3 || ' / ' ||
                                  r_ra_interface_lines_all.interface_line_attribute3 ||
                                  ', para a Fatura (ExportSys) nº ' ||
                                  p_s_NUM_INVOICE || '. Erro Oracle: ' ||
                                  SQLERRM);
            END;
            --
            -- Insert EBS_RA_INTERFACE_SALESCREDITS...
            --
            IF NVL(FNC_R12_DBL_REGRA_CONFIGURACAO('AVISO_DEBITO_ENVIA_SALESCREDITS_AR'),'N') = 'S' THEN
               BEGIN
                  PKG_R12_DBL_EXP_INSERT.EBS_RA_INTERFACE_SALESCREDITS(r_ra_interface_salescredits);
                  --
                  exception
                     when others then
                        raise_application_error(-20000,
                                  'Erro ao Inserir a linha de SALESCREDITS no oracle para o Header_id / Ordem: ' ||
                                  r_ra_interface_lines_all.line_gdf_attribute3 || ' / ' ||
                                  r_ra_interface_lines_all.interface_line_attribute3 ||
                                  ', para a Fatura (ExportSys) nº ' ||
                                  p_s_NUM_INVOICE || '. Erro Oracle: ' ||
                                  SQLERRM);
               END;
               --
            END IF;

            --
            if v_n_line_number < r_ra_interface_lines_all.line_number
            then
               v_n_line_number := r_ra_interface_lines_all.line_number;
            end if;
            --
            exception
               when others then
                  raise_application_error(-20000,'Item [' || to_char(r_invoice_lines.seq_item_invoice) || '] ' || sqlerrm);
         end;
         --
     end loop;
     --
     for r_invoice_expenses in (select b.desc_desp   as desc_desp,
                                       a.cod_despesa as cod_despesa,
                                       a.valor_real  as valor_real
                                from   es_despesas_reais a,
                                       es_despesas b
                                where  a.cod_despesa = b.cod_despesa
                                and    cod_entidade  = 'INVOICE'
                                and    num_documento = p_s_NUM_INVOICE
                                and    exists
                                      (select 1
                                       from   es_incoterms_x_despesas c
                                       where  c.cod_incoterm = r_invoice.cod_incoterm
                                       and    c.cod_despesa = a.cod_despesa
                                       and    c.ic_destaca_docto = 'S'
                                       and    c.valor_local_embarque = 'N'
                                       and    c.valor_condicao_venda = 'S'
                                       and  ((v_s_config_incoterm_x_org = 'S' and c.id_organizacao = v_n_id_organizacao) or
                                             (v_s_config_incoterm_x_org = 'N' and id_organizacao is null))))
     loop
         begin
            v_n_sum_expenses := v_n_sum_expenses + r_invoice_expenses.valor_real;
            --
            exception
               when others then
                  raise_application_error(-20000, 'Expense [' || r_invoice_expenses.cod_despesa || '] ' || sqlerrm);
         end;
         --
     end loop;
     --
     if v_n_sum_expenses > 0
     then
        v_n_line_number                                    := v_n_line_number + 1;
        r_ra_interface_lines_all.interface_line_attribute2 := v_n_line_number;
        r_ra_interface_lines_all.description               := 'DESPESAS';
        r_ra_interface_lines_all.amount                    := v_n_sum_expenses;
        r_ra_interface_lines_all.line_number               := v_n_line_number;
        --r_ra_interface_lines_all.line_type                 := 'LINE';
        r_ra_interface_lines_all.memo_line_name            := 'ND EXPORTACAO';
        r_ra_interface_lines_all.quantity                  := 1;
        -- r_ra_interface_lines_all.unit_selling_price        := v_n_sum_expenses;
        r_ra_interface_lines_all.unit_standard_price       := v_n_sum_expenses;
        r_ra_interface_lines_all.quantity_ordered          := null;
        r_ra_interface_lines_all.uom_code                  := 'UN';
        r_ra_interface_lines_all.inventory_item_id         := null;

        -- Insert RA_INTERFACE_LINES_ALL p/ DESPESAS...
        --
        BEGIN
           PKG_R12_DBL_EXP_INSERT.EBS_RA_INTERFACE_LINES_ALL(r_ra_interface_lines_all);
           --
           exception
              when others then
                 raise_application_error(-20000,
                                  'Erro ao Inserir a linha de DESPESA do Aviso de Débito no oracle para para a Fatura (ExportSys) nº ' ||
                                  p_s_NUM_INVOICE || '. Erro Oracle: ' ||
                                  SQLERRM);

        END;
     end if;
   end if; -- tratamento v_s_proc_vb      
   --
   -- ponto de customizacao
   --
   pkg_it_user_exit.call_user_exits(p_s_exit_name => 'PKG_R12_DBL_EXP_AVISO_DEBITO.MAPEAMENTO_AVISO_DEBITO.END',
                                    param_in_1    => to_char(p_n_ID_TRANSACAO),
                                    param_in_2    => to_char(p_n_ID_IMPORTACAO),
                                    param_in_3    => p_s_NUM_INVOICE,
                                    param_out_1   => v_n_exit_return);
   --
   exception
      when others then
--         raise_application_error(-20000, 'Invoice [' || p_s_NUM_INVOICE || '] ' || sqlerrm);
         raise_application_error(-20000, 'Fatura [' || p_s_NUM_INVOICE || '] ' || sqlerrm);
END MAPEAMENTO_AVISO_DEBITO;

END PKG_R12_DBL_EXP_AVISO_DEBITO;
/
