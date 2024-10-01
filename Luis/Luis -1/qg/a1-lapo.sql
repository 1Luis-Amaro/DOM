CREATE OR REPLACE PACKAGE BODY APPS.XXPPG_INV_IFACE_WMAS_API_PKG IS
--  $Header: XXPPG_INV_IFACE_WMAS_PK_B.pls 120.19 15/01/05 11:35:03 appldev ship $
--  +=====================================================================+
--  |       Copyright (c) 2012 Oracle Argentina, Buenos Aires             |
--  |                         All rights reserved.                        |
--  +=====================================================================+
--  | FILENAME                                                            |
--  |    XXPPG_INV_IFACE_WMAS_API_PKB.sql                                 |
--  |                                                                     |
--  | DESCRIPTION                                                         |
--  |    Integracao WMAS - Rotinas de interface entre as transacoes do    |
--  |    Oracle Inventory (EBS) e o sistema WMAS PPG (sistema PPG que     |
--  |    gerencia os armazens / depositos de materia prima, semi acabado  |
--  |    e produto acabado).                                              |
--  |                                                                     |
--  | LANGUAGE                                                            |
--  |    PL/SQL                                                           |
--  |                                                                     |
--  | PRODUCT                                                             |
--  |    Oracle Inventory                                                 |
--  |                                                                     |
--  | SOURCE CONTROL                                                      |
--  |    Versao $Revision: $                                              |
--  |    Data  : $Date: $                                                 |
--  |                                                                     |
--  | HISTORY                                                             |
--  |    11-Jun-2014     Renato Furlan    Criacao da rotina.              |
--  |    18-Aug-2014     sjoviano         Add proc Solicitacao_Material_P.|
--  |    12-Nov-2014     Renato Furlan    Ajuste gap 82.2.                |
--  |    19-Nov-2014     Renato Furlan    Ajuste gap 82.8.                |
--  |    27-Nov-2014     Renato Furlan    Cricao da nova procedure        |
--  |                                     Insert_Transactions_Temp_P.     |
--  |    02-Dez-2014     Renato Furlan    Ajuste procedure 82.11.         |
--  |    05-Dez-2014     Renato Furlan    RCR 82.9.                       |
--  |    22-Set-2015     Odair Melo       #07 - Inclusao de organizacao   |
--  |                                                                     |
--  +=====================================================================+

  -- Variaveis API Integra? WMAS
  g_integracao_tbl_type             xxppg_inv_wmas_pub_pkg.g_integracao_tbl_type;
  g_integracao_hist_tbl_type        xxppg_inv_wmas_pub_pkg.g_integracao_hist_tbl_type;
  g_documento_tbl_type              xxppg_inv_wmas_pub_pkg.g_documento_tbl_type;
  g_documentodetalhe_tbl_type       xxppg_inv_wmas_pub_pkg.g_documentodetalhe_tbl_type;
  g_documentodetalheseq_tbl_type    xxppg_inv_wmas_pub_pkg.g_documentodetalheseq_tbl_type;
  g_movimentoestoque_tbl_type       xxppg_inv_wmas_pub_pkg.g_movimentoestoque_tbl_type;
  g_produto_tbl_type                xxppg_inv_wmas_pub_pkg.g_produto_tbl_type;
  g_TipoUC_tbl_type                 xxppg_inv_wmas_pub_pkg.g_TipoUC_tbl_type;

  G_FUNCTION VARCHAR2(75);
  G_ERROR VARCHAR2(4000);
  --

--  +=====================================================================+
--  | DESCRIPTION                                                         |
--  |    Dispara Interfaces Outbound Oracle EBS x WMAS.                   |
--  |                                                                     |
--  | HISTORY                                                             |
--  |    11-Jun-2014     Renato Furlan    Cria? da rotina.              |
--  |                                                                     |
--  +=====================================================================+
  PROCEDURE WMAS_Outbound_P ( Errbuf         Out Varchar2
                            , Retcode        Out Number
                            , p_interface     In Varchar2
                            , p_delivery_id   In Number ) IS

    l_msg_Erro   Varchar2(32000);
    l_erro       Exception;
    p_status     Varchar2(20);
  BEGIN

      -- Disparando Envio de Itens
      IF p_interface IN ('All', '82.1') THEN
          XXPPG_INV_ITEMS_IFACE_PKG.Process_P (p_msg_erro => l_msg_erro);
         IF l_msg_erro IS NOT NULL THEN
            Raise l_erro;
         END IF;
      END IF;

      -- Disparando Interface Notas de Recebimento
      IF p_interface IN ('All', '82.2') THEN
         NF_Recebimento_P (p_msg_erro => l_msg_erro);
         IF l_msg_erro IS NOT NULL THEN
            Raise l_erro;
         END IF;
      END IF;

      -- Disparando Interface Report de Produ?
      IF p_interface IN ('All', '82.4') THEN
         XXPPG_INV_REPPROD_PKG.Rep_prod_p (p_msg_erro => l_msg_erro);
         IF l_msg_erro IS NOT NULL THEN
            Raise l_erro;
         END IF;
      END IF;

      -- Disparando Interface Separa? de Materiais -- Essa integracao dever?er schedulada por organiza?
      IF p_interface = '82.8' THEN
         Separacao_Materiais_P (p_msg_erro    => l_msg_erro
                               ,p_delivery_id => p_delivery_id);
         IF l_msg_erro IS NOT NULL THEN
            Raise l_erro;
         END IF;
      END IF;

      -- Disparando Interface Separa? de Materiais -- Essa integracao dever?er schedulada por organiza?
      IF p_interface = '82.8 NEW' THEN
         Separacao_Materiais_P_New (p_msg_erro    => l_msg_erro
                               ,p_delivery_id => p_delivery_id);
         IF l_msg_erro IS NOT NULL THEN
            Raise l_erro;
         END IF;
      END IF;

      -- Disparando Interface Envio de ordens de produ? para Separa?
      IF p_interface IN ('All', '82.9') THEN
         Send_Ordem_Prod_Separacao_P (p_msg_erro => l_msg_erro);
         IF l_msg_erro IS NOT NULL THEN
            Raise l_erro;
         END IF;
      END IF;

      -- Disparando Interface Solicita? de Materiais
      IF p_interface IN ('All', '82.11') THEN
         Solicitacao_Material_P (p_msg_erro => l_msg_erro);
         IF l_msg_erro IS NOT NULL THEN
            Raise l_erro;
         END IF;
      END IF;

      -- Disparando Interface Devolucao de Materiais
      IF p_interface IN ('All', '82.12') THEN
         XXPPG_INV_MOV_ESTOQUE_WMAS_PKG.Devolucao_Materiais_p (p_msg_erro    => l_msg_erro );
         IF l_msg_erro IS NOT NULL THEN
            Raise l_erro;
         END IF;
      END IF;

  EXCEPTION
     WHEN l_erro THEN
          Fnd_file.put_line(fnd_file.log, 'Erro rotina Outbound - '||l_msg_erro);
          Raise_Application_Error(-20300, 'Erro rotina Outbound - '||l_msg_erro);
     WHEN others THEN
          Fnd_file.put_line(fnd_file.log, 'Erro inesperado rotina Outbound - '||SqlErrm);
          Raise_Application_Error(-20400, 'Erro inesperado rotina Outbound - '||SqlErrm);
  END;


--  +=====================================================================+
--  | DESCRIPTION                                                         |
--  |    Dispara Interfaces Inbound WMAS x Oracle EBS.                    |
--  |                                                                     |
--  | HISTORY                                                             |
--  |    11-Jun-2014     Renato Furlan    Cria? da rotina.              |
--  |                                                                     |
--  +=====================================================================+
  PROCEDURE WMAS_Inbound_P ( Errbuf         Out Varchar2
                           , Retcode        Out Number
                           , p_interface     In Varchar2
                           , p_delivery_id   In Number ) IS

    l_msg_Erro   Varchar2(32000);
    l_erro       Exception;

  BEGIN

       -- Disparando Integracao Consumo de Materiais
      IF p_interface IN ('All', '81.1') THEN
         XXPPG_CONF_RECEBIMENTO_PKG.Processa (p_msg_erro => l_msg_erro);
         IF l_msg_erro IS NOT NULL THEN
            Raise l_erro;
         END IF;
      END IF;

      -- Disparando Integracao Movimentacao Estoque
      IF p_interface IN ('All', '81.3') THEN
         XXPPG_INV_MOV_ESTOQUE_WMAS_PKG.Movimentacao_Materiais_P (p_msg_erro => l_msg_erro);
         IF l_msg_erro IS NOT NULL THEN
            Raise l_erro;
         END IF;
      END IF;

      -- Disparando Integracao Movimenta? de Estoques - Consumo de Materiais
      IF p_interface IN ('All', '81.4') THEN
          --
          XXPPG_INV_CONS_MATERIALS_PKG.Process_P ( p_msg_erro => l_msg_erro ) ;
          IF l_msg_erro IS NOT NULL THEN
              --
              IF SUBSTR(l_msg_erro, 1, 3) = 'ERR' THEN
                  --
                  l_msg_erro := SUBSTR(l_msg_erro, 4) ;
                  Raise l_erro ;
                  --
              ELSE
                  --
                  errbuf  := 'Verifique sa? do concorrente.' ;
                  retcode := 1 ;
                  --
              END IF ;
              --
          END IF ;
          --
      END IF ;

      -- Disparando Integracao Confirmacao de Embarque  -- Essa integra? dever?er schedulada por organiza?
      IF p_interface = '81.5' THEN
         Confirma_Entrega_P (p_delivery_id => p_delivery_id
                            ,p_msg_erro    => l_msg_erro
                            ,p_retcode     => retcode);
         IF l_msg_erro IS NOT NULL THEN
            Raise l_erro;
         END IF;
      END IF;

      IF p_interface = '81.5 NEW' THEN
         Confirma_Entrega_P_New (p_delivery_id => p_delivery_id
                            ,p_msg_erro    => l_msg_erro
                            ,p_retcode     => retcode);
         IF l_msg_erro IS NOT NULL THEN
            Raise l_erro;
         END IF;
      END IF;

      -- Disparando Integracao Solicitacao de Materiais
      IF p_interface IN ('All', '81.7') THEN
         XXPPG_INV_MOV_SOLIC_MAT_PKG.Mov_solicit_p (p_msg_erro => l_msg_erro);
         IF l_msg_erro IS NOT NULL THEN
            Raise l_erro;
         END IF;
      END IF;

  EXCEPTION
     WHEN l_erro THEN
          Fnd_file.put_line(fnd_file.log, 'Erro rotina Inbound - '||l_msg_erro);
          Raise_Application_Error(-20300, 'Erro rotina Inbound - '||l_msg_erro);
     WHEN others THEN
          Fnd_file.put_line(fnd_file.log, 'Erro inesperado rotina Inbound - '||SqlErrm);
          Raise_Application_Error(-20400, 'Erro inesperado rotina Inbound - '||SqlErrm);
  END;

  --  +=====================================================================+
  --  | DESCRIPTION                                                         |
  --  |    Gap 82.2 - Integra? Notas Fiscais de Recebimento               |
  --  |                                                                     |
  --  | HISTORY                                                             |
  --  |    11-Jun-2014     Renato Furlan    Cria? da rotina.              |
  --  |    12-Nov-2014     Renato Furlan    #01- Pegar a quantidade prim?a|
  --  |                                     e nao a da transa?.           |
  --  +=====================================================================+
  PROCEDURE NF_Recebimento_P (p_msg_erro  Out Varchar2) IS
      CURSOR c_Docs IS
         SELECT mp.organization_id
              , mp.attribute7             Cod_Estabelecimento
              , cffe.document_number      CNPJ_Estabelecimento
              , DECODE(assa.global_attribute9,'1',assa.global_attribute10||assa.global_attribute12
                                                 ,SUBSTR(assa.global_attribute10,2)||assa.global_attribute11||assa.global_attribute12)  CNPJ_CPF
              , cfi.series
              , cfeo.operation_id
              , cfi.invoice_num
              , cfi.invoice_id
              , cfil.line_location_id
              , cfit.operation_fiscal_type
              , cfi.gross_total_amount
              , cfi.invoice_amount
              , cfi.invoice_weight
              , cfi.invoice_date
              , asu.segment1          vendor_number
              , asu.vendor_name
              , assa.address_line1||DECODE(assa.address_line2,Null,Null,',')||
                assa.address_line2||DECODE(assa.address_line3,Null,Null,',')||
                assa.address_line3    endereco
              , assa.address_line4    bairro
              , assa.city
              , assa.state
              , assa.zip
              , assa.global_attribute13    IE
              , msib.segment1              Item_Code
              , msib.primary_uom_code
              , msi.attribute2                Endereco_Doca
              , msi.secondary_inventory_name  Subinventory_Code
--            , NVL(mtln.transaction_quantity, mmt.transaction_quantity) transaction_quantity
              , NVL(mtln.primary_quantity    , mmt.primary_quantity)     transaction_quantity     -- #02
              , DECODE(msib.lot_control_code,2,3,1)    tipo_Logistico
              , mtln.lot_number
              , cfil.total_amount   Line_Total_Amount
              , mmt.transaction_id
           FROM mtl_material_transactions    mmt
              , mtl_transaction_lot_numbers  mtln
              , mtl_secondary_inventories    msi
              , mtl_parameters               mp
              , hr_all_organization_units    haou
              , org_organization_definitions ood
              , cll_f189_fiscal_entities_all cffe
              , rcv_transactions             rt
              , rcv_shipment_headers         rsh
              , rcv_shipment_lines           rsl
              , cll_f189_entry_operations    cfeo
              , cll_f189_invoices            cfi
              , cll_f189_invoice_lines       cfil
              , cll_f189_invoice_types       cfit
              , ap_supplier_sites_all        assa
              , ap_suppliers                 asu
              , mtl_system_items_b           msib
          WHERE mmt.source_code              = 'RCV'
            AND mtln.transaction_id (+)      = mmt.transaction_id
            AND mmt.subinventory_code        = msi.secondary_inventory_name
            AND mmt.organization_id          = msi.organization_id
            AND msi.attribute2              IS NOT NULL
            AND NVL(mmt.attribute15,'N')     = 'N'
            AND mp.organization_id           = mmt.organization_id
            AND haou.organization_id         = mmt.organization_id
            AND ood.organization_id          = haou.organization_id
            AND ood.operating_unit           = Fnd_Profile.Value('ORG_ID')
            AND cffe.location_id             = haou.location_id
            AND cffe.entity_type_lookup_code = 'LOCATION'
            AND rt.transaction_id            = mmt.rcv_transaction_id
            AND rsh.shipment_header_id       = rt.shipment_header_id
            AND rsl.shipment_header_id       = rsh.shipment_header_id
            AND rsl.shipment_line_id         = rt.shipment_line_id
            AND cfil.invoice_id              = cfi.invoice_id
            AND cfil.line_location_id        = rsl.po_line_location_id
            AND cfeo.operation_id            = TO_NUMBER(rsh.receipt_num)
            AND cfeo.organization_id         = rsh.ship_to_org_id
            AND cfi.operation_id             = cfeo.operation_id
            AND cfi.organization_id          = cfeo.organization_id
            AND cfit.invoice_type_id         = cfi.invoice_type_id
            AND cfit.organization_id         = cfi.organization_id
            AND assa.vendor_site_id          = rsh.vendor_site_id
            AND asu.vendor_id                = assa.vendor_id
            AND msib.inventory_item_id       = mmt.inventory_item_id
            AND msib.organization_id         = mmt.organization_id
         ORDER BY cfeo.organization_id, cfeo.operation_id, cfi.invoice_id, mmt.transaction_id, mtln.lot_number;

    l_debug                          Varchar2(1000);
    l_seq_integracao                 Number;
    l_seq_documento                  Number := 0;
    l_seq_detalhe                    Number := 0;
    l_index_detalhe                  Number := 0;
    l_return_status                  Varchar2(1);
    l_msg_data                       Varchar2(32000);
    l_invoice_id                     cll_f189_invoices.invoice_id%TYPE;
    l_invoice_id_ant                 cll_f189_invoices.invoice_id%TYPE := 0;
    l_saida_erro                     Exception;
    l_cnpj                           Varchar2(50);
    l_invoice_Num                    cll_f189_invoices.invoice_num%TYPE;

  BEGIN

    fnd_file.put_line(fnd_file.output, '****************************************************************************** ');
    fnd_file.put_line(fnd_file.output, 'Disparando Integra? das Notas de Recebimento                                 ');
    fnd_file.put_line(fnd_file.output, '****************************************************************************** ');

    FOR r_docs IN c_docs LOOP

        l_invoice_id := r_docs.invoice_id;

        IF l_invoice_id_ant <> r_docs.invoice_id THEN

           -- Processa Documento Anterior
           IF l_invoice_id_ant > 0 THEN
              Xxppg_inv_wmas_pub_pkg.Create_wmas_records ( p_integracao_tbl              => g_integracao_tbl_type
                                                         , p_integracao_hist_tbl         => g_integracao_hist_tbl_type
                                                         , p_documento_tbl               => g_documento_tbl_type
                                                         , p_documento_detalhe_tbl       => g_documentodetalhe_tbl_type
                                                         , p_documento_detalhe_seq_tbl   => g_documentodetalheseq_tbl_type
                                                         , p_movimento_estoque_tbl       => g_movimentoestoque_tbl_type
                                                         , p_produto_tbl                 => g_produto_tbl_type
                                                         , p_TipoUC_tbl                  => g_TipoUC_tbl_type
                                                         , p_SequencialIntegracao        => l_seq_integracao
                                                         , p_return_status               => l_return_status
                                                         , p_msg_data                    => l_msg_data );

             IF l_return_status = 'E' THEN
                ROLLBACK;
                Raise l_saida_Erro;
             ELSE
                Fnd_file.put_line(fnd_file.output, 'Sequencial: '||l_seq_integracao||' - CNPJ Fornecedor: '||l_cnpj||' - Nota Fiscal: '||l_invoice_num );
                COMMIT;
             END IF;
           END IF;

           g_integracao_tbl_type.delete;
           g_integracao_hist_tbl_type.delete;
           g_documento_tbl_type.delete;
           g_documentodetalhe_tbl_type.delete;
           g_documentodetalheseq_tbl_type.delete;
           g_movimentoestoque_tbl_type.delete;
           g_produto_tbl_type.delete;
           g_TipoUC_tbl_type.delete;

           l_seq_documento  := 1;
           l_seq_detalhe    := 0;
           l_index_detalhe  := 0;
           l_invoice_id_ant := r_docs.invoice_id;
           l_cnpj           := r_docs.CNPJ_CPF;
           l_invoice_num    := r_docs.invoice_num;

           -- Gravando Integracao
           l_debug                                       := 'Integracao';
           g_integracao_tbl_type(1).TipoIntegracao       := 104;
           g_integracao_tbl_type(1).EstadoIntegracao     := 1;
           g_integracao_tbl_type(1).SequenciaRelacionada := 0;

           -- Gravando Documento
           l_debug                                                         := 'Documento';
           g_documento_tbl_type(l_seq_documento).SequenciaDocumento        := l_seq_documento;
           l_debug                                                         := 'Documento - CodigoEstabelecimento';
           g_documento_tbl_type(l_seq_documento).CodigoEstabelecimento     := r_docs.Cod_Estabelecimento;
           l_debug                                                         := 'Documento - CodigoDepositante';
           g_documento_tbl_type(l_seq_documento).CodigoDepositante         := r_docs.Cod_Estabelecimento;
           l_debug                                                         := 'Documento - CNPJCPFDepositante';
           g_documento_tbl_type(l_seq_documento).CNPJCPFDepositante        := SUBSTR(r_docs.CNPJ_Estabelecimento,1,20);
           l_debug                                                         := 'Documento - TipoDocumento';
           g_documento_tbl_type(l_seq_documento).TipoDocumento             := 'ENT';
           l_debug                                                         := 'Documento - SerieDocumento ';
           g_documento_tbl_type(l_seq_documento).SerieDocumento            := SUBSTR(r_docs.series,1,5);
           l_debug                                                         := 'Documento - NumeroDocumento';
           g_documento_tbl_type(l_seq_documento).NumeroDocumento           := r_docs.operation_id;
           l_debug                                                         := 'Documento - NaturezaOperacao';
           g_documento_tbl_type(l_seq_documento).NaturezaOperacao          := '0000';      ----  SUBSTR(r_docs.operation_fiscal_type,1,15);
           l_debug                                                         := 'Documento - DescricaoNaturezaOperacao';
           g_documento_tbl_type(l_seq_documento).DescricaoNaturezaOperacao := SUBSTR(r_docs.operation_fiscal_type,1,40);
           l_debug                                                         := 'Documento - CFOP';
           g_documento_tbl_type(l_seq_documento).CFOP                      := NULL;
           l_debug                                                         := 'Documento - ValorTotalDocumento';
           g_documento_tbl_type(l_seq_documento).ValorTotalDocumento       := r_docs.gross_total_amount;
           l_debug                                                         := 'Documento - ValorTotalProduto';
           g_documento_tbl_type(l_seq_documento).ValorTotalProduto         := r_docs.invoice_amount;
           l_debug                                                         := 'Documento - PesoBruto';
           g_documento_tbl_type(l_seq_documento).PesoBruto                 := r_docs.invoice_weight;
           l_debug                                                         := 'Documento - PesoLiquido';
           g_documento_tbl_type(l_seq_documento).PesoLiquido               := r_docs.invoice_weight;
           l_debug                                                         := 'Documento - DataPrevisaoMovimento';
           g_documento_tbl_type(l_seq_documento).DataPrevisaoMovimento     := r_docs.invoice_date;
           l_debug                                                         := 'Documento - DataEmissao';
           g_documento_tbl_type(l_seq_documento).DataEmissao               := r_docs.invoice_date;
           l_debug                                                         := 'Documento - CodigoEmpresa';
           g_documento_tbl_type(l_seq_documento).CodigoEmpresa             := SUBSTR(r_docs.vendor_number,1,15);
           l_debug                                                         := 'Documento - CNPJCPFEmpresa';
           g_documento_tbl_type(l_seq_documento).CNPJCPFEmpresa            := SUBSTR(r_docs.CNPJ_CPF,1,20);
           l_debug                                                         := 'Documento - NomeEmpresa';
           g_documento_tbl_type(l_seq_documento).NomeEmpresa               := SUBSTR(r_docs.vendor_name,1,80);
           l_debug                                                         := 'Documento - EnderecoEmpresa';
           g_documento_tbl_type(l_seq_documento).EnderecoEmpresa           := SUBSTR(r_docs.endereco,1,90);
           l_debug                                                         := 'Documento - BairroEmpresa';
           g_documento_tbl_type(l_seq_documento).BairroEmpresa             := SUBSTR(r_docs.bairro,1,25);
           l_debug                                                         := 'Documento - MunicipioEmpresa';
           g_documento_tbl_type(l_seq_documento).MunicipioEmpresa          := SUBSTR(r_docs.city,1,25);
           l_debug                                                         := 'Documento - UFEmpresa';
           g_documento_tbl_type(l_seq_documento).UFEmpresa                 := SUBSTR(r_docs.state,1,2);
           l_debug                                                         := 'Documento - CEPEmpresa';
           g_documento_tbl_type(l_seq_documento).CEPEmpresa                := SUBSTR(r_docs.zip,1,9);
           l_debug                                                         := 'Documento - InscricaoEmpresa';
           g_documento_tbl_type(l_seq_documento).InscricaoEmpresa          := SUBSTR(r_docs.IE,1,20);
           l_debug                                                         := 'Documento - TipoPessoaEmpresa';
           g_documento_tbl_type(l_seq_documento).TipoPessoaEmpresa         := 'J';
           l_debug                                                         := 'Documento - Agrupador';
           g_documento_tbl_type(l_seq_documento).Agrupador                 := r_docs.operation_id;

        END IF;

        -- Gravando DocumentoDetalhe
        l_debug                                                                := 'Documento_Detalhe';
        l_index_detalhe                                                        := l_index_detalhe + 1;
        l_seq_detalhe                                                          := l_seq_detalhe + 1;
        g_documentodetalhe_tbl_type(l_index_detalhe).SequenciaDocumento        := l_seq_documento;
        g_documentodetalhe_tbl_type(l_index_detalhe).SequenciaDetalhe          := l_seq_detalhe;
        l_debug                                                                := 'Documento_Detalhe - CodigoEmpresa';
        g_documentodetalhe_tbl_type(l_index_detalhe).CodigoEmpresa             := SUBSTR(r_docs.Cod_Estabelecimento,1,15);
        l_debug                                                                := 'Documento_Detalhe - CodigoProduto';
        g_documentodetalhe_tbl_type(l_index_detalhe).CodigoProduto             := SUBSTR(r_docs.Item_Code,1,25);
        l_debug                                                                := 'Documento_Detalhe - TipoUC';
        g_documentodetalhe_tbl_type(l_index_detalhe).TipoUC                    := UPPER(SUBSTR(r_docs.primary_uom_code,1,5));
        l_debug                                                                := 'Documento_Detalhe - FatorTipoUC';
        g_documentodetalhe_tbl_type(l_index_detalhe).FatorTipoUC               := 1;
        l_debug                                                                := 'Documento_Detalhe - ClasseProduto';
        g_documentodetalhe_tbl_type(l_index_detalhe).ClasseProduto             := r_docs.subinventory_code;
        l_debug                                                                := 'Documento_Detalhe - QuantidadeMovimento';
        g_documentodetalhe_tbl_type(l_index_detalhe).QuantidadeMovimento       := r_docs.transaction_quantity;
        l_debug                                                                := 'Documento_Detalhe - TipoLogistico';
        g_documentodetalhe_tbl_type(l_index_detalhe).TipoLogistico             := r_docs.Tipo_Logistico;
        l_debug                                                                := 'Documento_Detalhe - DadoLogistico';
        g_documentodetalhe_tbl_type(l_index_detalhe).DadoLogistico             := r_docs.Lot_Number;
        l_debug                                                                := 'Documento_Detalhe - NaturezaOperacao';
        g_documentodetalhe_tbl_type(l_index_detalhe).NaturezaOperacao          := '0000';
        l_debug                                                                := 'Documento_Detalhe - DescricaoNaturezaOperacao';
        g_documentodetalhe_tbl_type(l_index_detalhe).DescricaoNaturezaOperacao := 'SEM VALOR FISCAL';
        l_debug                                                                := 'Documento_Detalhe - ValorUnitario';
        g_documentodetalhe_tbl_type(l_index_detalhe).ValorUnitario             := r_docs.Line_Total_Amount;

        UPDATE mtl_material_transactions
           SET attribute15 = 'Y'
         WHERE transaction_id = r_docs.transaction_id;

    END LOOP;

    -- Processa Ultimo Documento
    IF l_seq_documento > 0 THEN
        Xxppg_inv_wmas_pub_pkg.Create_wmas_records ( p_integracao_tbl              => g_integracao_tbl_type
                                                   , p_integracao_hist_tbl         => g_integracao_hist_tbl_type
                                                   , p_documento_tbl               => g_documento_tbl_type
                                                   , p_documento_detalhe_tbl       => g_documentodetalhe_tbl_type
                                                   , p_documento_detalhe_seq_tbl   => g_documentodetalheseq_tbl_type
                                                   , p_movimento_estoque_tbl       => g_movimentoestoque_tbl_type
                                                   , p_produto_tbl                 => g_produto_tbl_type
                                                   , p_TipoUC_tbl                  => g_TipoUC_tbl_type
                                                   , p_SequencialIntegracao        => l_seq_integracao
                                                   , p_return_status               => l_return_status
                                                   , p_msg_data                    => l_msg_data );

        IF l_return_status = 'E' THEN
           ROLLBACK;
           Raise l_saida_Erro;
        ELSE
           Fnd_file.put_line(fnd_file.output, 'Sequencial: '||l_seq_integracao||' - CNPJ Fornecedor: '||l_cnpj||' - Nota Fiscal: '||l_invoice_num );
           COMMIT;
        END IF;
    END IF;

    Fnd_file.put_line(fnd_file.output, ' ');
    Fnd_file.put_line(fnd_file.output, ' ');

  EXCEPTION
     WHEN l_saida_erro THEN
          p_msg_erro := 'Rotina NF Recebimento - '||l_msg_data;
          Return;
     WHEN others THEN
          p_msg_erro := 'Erro na rotina NF Recebimento - Debug: '||l_debug||' - Invoice Id: '||l_invoice_id||' - '||SqlErrm;
          Return;
  END NF_Recebimento_P;

  FUNCTION f_verify_window(p_delivery_id IN NUMBER) RETURN NUMBER
     IS
       l_service_level VARCHAR2(30);
       l_window_days NUMBER;
       l_cal_code VARCHAR2(150);
       l_qty NUMBER;
       l_actual_day VARCHAR2(15); --- version 1.9

       x_return NUMBER := sys.diutil.bool_to_int(FALSE);
       l_metodo_entrega VARCHAR2(100);
     BEGIN
        Fnd_file.put_line(fnd_file.output, '');
        Fnd_file.put_line(fnd_file.output, '      Verificando a Janela:');

        BEGIN
          --GET_SERVICE_LEVEL/WINDOW_DAYS
          SELECT DISTINCT csm.service_level
                ,TO_NUMBER(csm.attribute2)
                ,csm.ship_method_code_meaning
          INTO   l_service_level
                ,l_window_days
                ,l_metodo_entrega
          FROM   apps.wsh_carrier_ship_methods_v csm
                ,apps.wsh_new_deliveries wdd
          WHERE  1 = 1
            AND wdd.ship_method_code = csm.ship_method_code
            AND csm.enabled_flag = 'Y'
            AND csm.organization_id = wdd.organization_id
            AND wdd.delivery_id = p_delivery_id
            AND ROWNUM = 1
          ;

        EXCEPTION
          WHEN OTHERS THEN
            Fnd_file.put_line(fnd_file.output, '      EXCEPTION: GET_SERVICE_LEVEL/WINDOW_DAYS');
        END;

        --GET_CALENDARIO_JANELA
        BEGIN
          SELECT lv.attribute1
          INTO   l_cal_code
              FROM   APPLSYS.FND_LOOKUP_VALUES lv
          WHERE  LV.LOOKUP_TYPE = 'WSH_SERVICE_LEVELS'
          AND    LV.LOOKUP_CODE =  NVL(l_service_level, '@NA@') --SERVICE_LEVEL
          AND    LV.LANGUAGE = 'PTB'
          ;
        EXCEPTION
          WHEN OTHERS THEN
            Fnd_file.put_line(fnd_file.output, '      EXCEPTION: GET_CALENDARIO_JANELA');
        END;

        --VERIFY_JANELA_DAYS_UTIL
        Fnd_file.put_line(fnd_file.output, '        - Nivel de Servico := '||l_metodo_entrega);
        Fnd_file.put_line(fnd_file.output, '        - Nivel de Servico := '||l_service_level);
        Fnd_file.put_line(fnd_file.output, '        - Dias Pick Janela := '||l_window_days);
        Fnd_file.put_line(fnd_file.output, '        - Calendario       := '||l_cal_code);

        --- version 1.12>>>
        SELECT TRIM(TO_CHAR(SYSDATE,'DAY', 'NLS_DATE_LANGUAGE=SPANISH')) --@ediazIssue545
        INTO   l_actual_day
        FROM   DUAL;
        ----CR 1089
        IF  (SUBSTR(l_cal_code,1,2)  <> 'BR') THEN
            IF (l_actual_day = 'VIERNES' AND SUBSTR(l_cal_code,6,2)  = '00') THEN
                      l_window_days := l_window_days + 2;
                      Fnd_file.put_line(fnd_file.output, '        - Dias Pick Janela Sabado := '||l_window_days);
            END IF;
        ELSE
            IF (l_actual_day = 'VIERNES' AND SUBSTR(l_cal_code,8,2)  = '00') THEN
                 l_window_days := l_window_days + 2;
                 Fnd_file.put_line(fnd_file.output, '        - Dias Pick Janela Sabado := '||l_window_days);
            END IF;
        END IF;

        --- END CR 1089
        --- version 1.12<<<

        SELECT COUNT(*)
        INTO   l_qty
        FROM   BOM.BOM_CALENDAR_DATES bcd
        WHERE  BCD.CALENDAR_CODE  = NVL(l_cal_code, '1111100')
        AND    TO_DATE(BCD.CALENDAR_DATE,'DD-MM-YYYY') = TO_DATE((sysdate + NVL(l_window_days, 1)),'DD-MM-YYYY')
        AND    BCD.SEQ_NUM is not null   --ADDED dacosta 28/08/2014 issue 307
        AND    trunc(BCD.CALENDAR_DATE) NOT IN (select trunc(bce.exception_date)
                                         from bom_calendar_exceptions bce
                                         where  bce.calendar_code = BCD.CALENDAR_CODE
        )
        ;
        IF l_qty > 0 THEN
           x_return := sys.diutil.bool_to_int(TRUE);
        END IF;

        Fnd_file.put_line(fnd_file.output, '        Fim verificacao de Janela := '||x_return);

        RETURN x_return;
     END f_verify_window;

     FUNCTION f_get_delivery_details(p_delivery_id IN NUMBER, p_info IN VARCHAR2) RETURN VARCHAR2
     IS
       x_return_valor VARCHAR2(20);
     BEGIN

         IF p_info = 'VENDOR' THEN

             BEGIN
               SELECT distinct nvl(rt.attribute7,'N')
                   INTO x_return_valor
                 FROM   apps.wsh_deliverables_v wdd
                       ,ont.oe_order_headers_all oha
                       ,ar.ra_terms_b rt
                 WHERE 1 = 1
                 AND   oha.header_id = wdd.source_header_id
                 AND   oha.payment_term_id = rt.term_id
                 AND   wdd.delivery_id = p_delivery_id;
             EXCEPTION
              WHEN no_data_found THEN
                  x_return_valor := 'N';
              WHEN OTHERS THEN
                  x_return_valor := 'N';
             END;

         END IF;

         IF p_info = 'LIB_FMIN' THEN

             BEGIN
                 SELECT distinct nvl(rt.attribute10,'N')
                   INTO x_return_valor
                 FROM   apps.wsh_deliverables_v wdd
                       ,ont.oe_order_headers_all oha
                       ,ar.ra_terms_b rt
                 WHERE 1 = 1
                 AND   oha.header_id = wdd.source_header_id
                 AND   oha.payment_term_id = rt.term_id
                 AND   wdd.delivery_id = p_delivery_id;
             EXCEPTION
              WHEN no_data_found THEN
                  x_return_valor := 'N';
              WHEN OTHERS THEN
                  x_return_valor := 'N';
             END;

         END IF;

         IF p_info = 'VENDOR1FAT' THEN

             BEGIN
                 SELECT TO_NUMBER(lv1.description)
                  INTO x_return_valor
                    FROM   APPLSYS.FND_LOOKUP_VALUES lv1
                 WHERE  lv1.lookup_type = 'PPG_OM_VALOR_MINIMO_VENDOR'
                    AND lv1.lookup_code = 'VENDOR1FAT'
                    AND ROWNUM = 1;
             EXCEPTION
              WHEN no_data_found THEN
                  x_return_valor := 0;
              WHEN OTHERS THEN
                  x_return_valor := 0;
             END;

         END IF;

         IF p_info = 'VENDOR2FAT' THEN

             BEGIN
                 SELECT TO_NUMBER(lv1.description)
                  INTO x_return_valor
                    FROM   APPLSYS.FND_LOOKUP_VALUES lv1
                 WHERE  lv1.lookup_type = 'PPG_OM_VALOR_MINIMO_VENDOR'
                    AND lv1.lookup_code = 'VENDOR2FAT'
                    AND ROWNUM = 1;
             EXCEPTION
              WHEN no_data_found THEN
                  x_return_valor := 0;
              WHEN OTHERS THEN
                  x_return_valor := 0;
             END;

         END IF;

         IF p_info = 'VENDORFAT_ANT' THEN

             BEGIN

               SELECT CASE WHEN qtde > 0 THEN 'Y' ELSE 'N' END
                 INTO   x_return_valor
               FROM(
                     SELECT COUNT(*) qtde
                     FROM   APPS.WSH_DELIVERABLES_V wdd
                     WHERE  1 = 1
                     AND wdd.released_status IN ('Y','C','L','I')
                     AND wdd.source_header_id in(select distinct source_header_id
                                                  from apps.wsh_deliverables_v
                                                 where delivery_id = p_delivery_id)
                    );
             EXCEPTION
              WHEN no_data_found THEN
                  x_return_valor := 'N';
              WHEN OTHERS THEN
                  x_return_valor := 'N';
             END;

         END IF;

         IF p_info = 'FMIN' THEN

             BEGIN
                  SELECT distinct cli.fat_mim
                  INTO   x_return_valor
                  FROM   apps.wsh_deliverables_v wdd
                        ,ont.oe_order_headers_all oha
                        ,(select site_use_id,attribute1 canal,to_number(nvl(attribute8,0)) fat_mim from apps.hz_cust_site_uses_all
                           union
                          select site_use_id,sales_channel canal,nvl(minimum_invoice_value,0) fat_mim from apps.xxppg_om_cross_bu_all xocba
                          ) cli
                  WHERE  1 = 1
                     AND wdd.source_header_id = oha.header_id
                     AND oha.ship_to_org_id = cli.site_use_id(+)
                     AND oha.sales_channel_code = cli.canal(+)
                     AND wdd.delivery_id = p_delivery_id
                     AND ROWNUM = 1;
             EXCEPTION
              WHEN no_data_found THEN
                  x_return_valor := 0;
              WHEN OTHERS THEN
                  x_return_valor := 0;
             END;

         END IF;

         IF p_info = 'CONDPGTO' THEN

             BEGIN

                SELECT CASE WHEN qtde > 1 THEN 'Y' ELSE 'N' END
                 INTO   x_return_valor
                FROM(
                    SELECT COUNT(*) qtde
                    FROM(
                         SELECT payment_term_id
                           FROM apps.oe_order_headers_all wdd
                         WHERE  1 = 1
                           AND header_id in(select distinct source_header_id
                                             from apps.wsh_deliverables_v
                                            where delivery_id = p_delivery_id)
                        GROUP BY payment_term_id)
                 );
             EXCEPTION
              WHEN no_data_found THEN
                  x_return_valor := 'N';
              WHEN OTHERS THEN
                  x_return_valor := 'N';
             END;

         END IF;

         RETURN x_return_valor;

     END f_get_delivery_details;

     FUNCTION f_get_valor_embarque(p_delivery_id IN NUMBER) RETURN NUMBER
     IS
        x_valor_total_embarque NUMBER;
     BEGIN

       BEGIN

         SELECT nvl(SUM(wdv.requested_quantity *  ola.unit_selling_price),0)
           INTO   x_valor_total_embarque
         FROM   apps.wsh_deliverables_v wdv
               ,ont.oe_order_lines_all ola
         WHERE  wdv.source_header_id = ola.header_id
         AND    wdv.source_line_id = ola.line_id
         AND    wdv.delivery_id = p_delivery_id
         AND    wdv.released_status = 'S'
         ;

       EXCEPTION
         WHEN OTHERS THEN
           x_valor_total_embarque := 0;
       END;

       RETURN x_valor_total_embarque;

     END f_get_valor_embarque;

     FUNCTION f_get_valor_ordem(p_delivery_detail_id IN NUMBER) RETURN NUMBER
     IS
        x_valor_total_ordem NUMBER;
     BEGIN

       BEGIN

         SELECT nvl(SUM(wdv.requested_quantity *  ola.unit_selling_price),0)
           INTO   x_valor_total_ordem
         FROM ont.oe_order_lines_all ola,
              apps.wsh_deliverables_v wdv
         WHERE ola.header_id in(select source_header_id
                                  from apps.wsh_deliverables_v
                                where delivery_detail_id = p_delivery_detail_id)
           AND ola.line_id = wdv.source_line_id
           AND wdv.released_status NOT IN ('Y','C','L','I')
           AND ola.flow_status_code IN ('AWAITING_SHIPPING','ENTERED')
          ;

       EXCEPTION
         WHEN OTHERS THEN
           x_valor_total_ordem := 0;
       END;

       RETURN x_valor_total_ordem;

     END f_get_valor_ordem;


   FUNCTION f_verify_excarga(p_delivery_id IN NUMBER) RETURN NUMBER
   IS x_excarga NUMBER;
   BEGIN

        x_excarga := 1;

        BEGIN
          --Tira status das linhas j?ratadas
          UPDATE WSH.WSH_DELIVERY_DETAILS WDDU
          SET    WDDU.SEAL_CODE = NULL
          WHERE  WDDU.DELIVERY_DETAIL_ID IN (SELECT DISTINCT WDD.DELIVERY_DETAIL_ID
                                             FROM   wsh.wsh_delivery_details wdd
                                                   ,wsh.wsh_carrier_ship_methods csm
                                                   ,inv.mtl_system_items_b msi
                                                   ,apps.mtl_parameters mp
                                             WHERE  1 = 1
                                             AND    wdd.released_status IN ('R','S','B')
                                             AND    wdd.ship_method_code = csm.ship_method_code
                                             AND    wdd.organization_id  = csm.organization_id
                                             AND    csm.organization_id  = msi.organization_id
                                             AND    csm.attribute1       = msi.inventory_item_id
                                             AND    wdd.net_weight       <= msi.maximum_load_weight
                                             AND    mp.organization_id   = msi.organization_id
                                             AND    nvl(wdd.seal_code,0)       = 'EXCARGA'
                                             AND    mp.attribute7 <> '1'
                                             AND ( (
                                                      ---- para embarques planejados ---
                                                      wdd.shipment_priority_code in ( SELECT flv1.lookup_code
                                                                                        FROM apps.fnd_lookup_values_vl flv1
                                                                                       WHERE flv1.lookup_type = 'SHIPMENT_PRIORITY'
                                                                                         AND NVL(flv1.attribute2 , 'N') = 'Y'
                                                                                         AND NVL(flv1.attribute3 , 'N') = 'Y'
                                                                                         AND NVL(flv1.attribute4 , 'N') = 'Y')
                                                      AND nvl(wdd.seal_code, '0') NOT IN ( 'SEPARANDO' )

                                                     ) OR
                                                     (
                                                      ---- para embarques manuais ---
                                                      wdd.shipment_priority_code IN ( SELECT flv2.lookup_code
                                                                                        FROM apps.fnd_lookup_values_vl flv2
                                                                                       WHERE flv2.lookup_type = 'SHIPMENT_PRIORITY'
                                                                                         AND nvl(flv2.attribute2 , 'N') = 'N'
                                                                                         AND nvl(flv2.attribute3 , 'N') = 'Y'
                                                                                         AND nvl(flv2.attribute4 , 'N') = 'Y' )
                                                      AND NVL(wdd.seal_code,'0') NOT IN (SELECT flv3.lookup_code
                                                                                           FROM apps.fnd_lookup_values_vl flv3
                                                                                          WHERE flv3.lookup_type = 'PPG - STATUS EMBARQUE'
                                                                                            AND flv3.tag = 'WORK')
                                                     )
                                                   )



                                             );
        EXCEPTION
          WHEN no_data_found THEN
             x_excarga := 0;
          WHEN others THEN
            x_excarga := 0;
        END;
        --
        COMMIT;
        --

        BEGIN
          /*Marca linhas com Excesso de Carga*/
          UPDATE wsh.wsh_delivery_details wddu
          SET    wddu.seal_code = 'EXCARGA'
          WHERE  wddu.delivery_detail_id IN (SELECT DISTINCT wdd.delivery_detail_id
                                             FROM  wsh.wsh_delivery_details wdd
                                                  ,wsh.wsh_carrier_ship_methods csm
                                                  ,inv.mtl_system_items_b msi
                                                  ,apps.mtl_parameters mp
                                             WHERE 1 = 1
                                             AND   wdd.released_status IN ('R','S','B')
                                             AND   wdd.ship_method_code = csm.ship_method_code
                                             AND   wdd.organization_id  = csm.organization_id
                                             AND   csm.organization_id  = msi.organization_id
                                             AND   csm.attribute1       = msi.inventory_item_id /*@ediaz20141112 issue807 attribute2*/
                                             AND   wdd.net_weight       > msi.maximum_load_weight
                                             AND   mp.organization_id   = msi.organization_id
                                             AND   nvl(wdd.seal_code,'0')       <> 'EXCARGA'
                                             AND    mp.attribute7 <> '1'
                                             AND ( (
                                                      ---- para embarques planejados ---
                                                      wdd.shipment_priority_code in ( SELECT flv1.lookup_code
                                                                                        FROM apps.fnd_lookup_values_vl flv1
                                                                                       WHERE flv1.lookup_type = 'SHIPMENT_PRIORITY'
                                                                                         AND NVL(flv1.attribute2 , 'N') = 'Y'
                                                                                         AND NVL(flv1.attribute3 , 'N') = 'Y'
                                                                                         AND NVL(flv1.attribute4 , 'N') = 'Y')
                                                      AND nvl(wdd.seal_code, '0') NOT IN ( 'SEPARANDO' )

                                                     ) OR
                                                     (
                                                      ---- para embarques manuais ---
                                                      wdd.shipment_priority_code IN ( SELECT flv2.lookup_code
                                                                                        FROM apps.fnd_lookup_values_vl flv2
                                                                                       WHERE flv2.lookup_type = 'SHIPMENT_PRIORITY'
                                                                                         AND nvl(flv2.attribute2 , 'N') = 'N'
                                                                                         AND nvl(flv2.attribute3 , 'N') = 'Y'
                                                                                         AND nvl(flv2.attribute4 , 'N') = 'Y' )
                                                      AND NVL(wdd.seal_code,'0') NOT IN (SELECT flv3.lookup_code
                                                                                           FROM apps.fnd_lookup_values_vl flv3
                                                                                          WHERE flv3.lookup_type = 'PPG - STATUS EMBARQUE'
                                                                                            AND flv3.tag = 'WORK')
                                                     )
                                                   )
                                             );


        EXCEPTION
        WHEN no_data_found THEN
            x_excarga := 0;
        WHEN others THEN
            x_excarga := 0;
        END;

        COMMIT;

        RETURN x_excarga;

     END f_verify_excarga;

 FUNCTION f_get_truck_info( p_delivery_id IN NUMBER) RETURN NUMBER
   IS
      x_item_id_truck NUMBER := -1;
      p_organization_id NUMBER;
      p_ship_method_code VARCHAR2(100);
      x_return        NUMBER:=0;
  BEGIN

      BEGIN
        SELECT organization_id,ship_method_code
        INTO   p_organization_id, p_ship_method_code
        FROM   apps.wsh_new_deliveries
        WHERE  1 = 1
        AND    delivery_id = p_delivery_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             NULL;
     WHEN OTHERS THEN
          x_item_id_truck := NULL;
      END;

      BEGIN
        SELECT DISTINCT TO_NUMBER(cs.attribute1)
        INTO   x_item_id_truck
        FROM   wsh.wsh_carrier_services cs
              ,wsh.wsh_carrier_ship_methods csm
              ,mtl_system_items_b msi
        WHERE  1 = 1
        AND    CSM.ORGANIZATION_ID = MSI.ORGANIZATION_ID --added dacosta 25/08/2014 issue 280
        AND    csm.ship_method_code  = cs.ship_method_code
        AND    csm.organization_id   =  p_organization_id--added dacosta 25/08/2014 issue 280
        AND    cs.ship_method_code   = p_ship_method_code
        AND    msi.inventory_item_id = TO_NUMBER(cs.attribute1)
        AND    ROWNUM <= 1
        ;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN

              SELECT msi.inventory_item_id
              INTO   x_item_id_truck
              FROM   applsys.fnd_lookup_values lv
                    ,inv.mtl_system_items_b msi
                    ,inv.mtl_parameters mtp
             WHERE   lv.lookup_type = 'PPG_WSH_VEICULO_DEFAULT'
               AND   lv.lookup_code = 'VEICULO'
               AND   lv.enabled_flag = 'Y'
               AND   NVL(lv.end_date_active,SYSDATE + 1 ) > SYSDATE
               AND   lv.language = 'US'
               AND   msi.segment1 = lv.meaning
               AND   msi.organization_id = mtp.organization_id
               AND   mtp.organization_code = lv.tag
               ;
        WHEN OTHERS THEN
          x_item_id_truck := NULL;
      END;

      BEGIN
        SELECT msi.maximum_load_weight
        INTO   x_return
        FROM   inv.mtl_system_items_b msi
        WHERE  1 = 1
        AND    msi.organization_id   = p_organization_id
        AND    msi.inventory_item_id = x_item_id_truck
        ;
      EXCEPTION
        WHEN OTHERS THEN
          x_return := 0;
      END;

      RETURN x_return;

  END f_get_truck_info;

 FUNCTION f_get_total_weight(p_delivery_id IN NUMBER) RETURN NUMBER
 IS x_return NUMBER;
 BEGIN

        x_return := 0;
        BEGIN
         SELECT SUM(nvl(peso_bruto,0))
          INTO x_return
         FROM(
            SELECT net_weight+(nvl(l_container_weight,0)*nvl(l_max_load,0)) peso_bruto
            FROM   apps.wsh_deliverables_v wd,
                   (select wci.load_item_id
                          ,wci.container_item_id l_container_id
                          ,wci.max_load_quantity l_max_load
                          ,wci.master_organization_id
                          ,msi.unit_weight l_container_weight
                      from apps.wsh_container_items wci
                          ,apps.mtl_system_items_b msi
                    where 1=1
                      AND wci.preferred_flag = 'Y'
                      --
                      AND msi.inventory_item_id = wci.container_item_id
                      AND msi.organization_id = wci.master_organization_id
                   ) wci
            WHERE  wd.delivery_id = p_delivery_id
               AND wd.inventory_item_id = wci.load_item_id(+)
               AND wd.organization_id = wci.master_organization_id(+)
               );
        EXCEPTION
          WHEN no_data_found THEN
             x_return := 0;
          WHEN others THEN
             x_return := 0;
        END;

    RETURN x_return;

 END f_get_total_weight;

 FUNCTION f_monta_carga_embarques(p_delivery_id IN NUMBER) RETURN NUMBER
 IS

    CURSOR c_ship (l_delivery_id NUMBER) IS
      SELECT delivery_id,delivery_detail_id, requested_quantity,net_weight+(nvl(l_container_weight,0)*nvl(l_max_load,0)) peso_bruto
      FROM   apps.wsh_deliverables_v wd,
           (select wci.load_item_id
                  ,wci.container_item_id l_container_id
                  ,wci.max_load_quantity l_max_load
                  ,wci.master_organization_id
                  ,msi.unit_weight l_container_weight
              from apps.wsh_container_items wci
                  ,apps.mtl_system_items_b msi
            where 1=1
              AND wci.preferred_flag = 'Y'
              --
              AND msi.inventory_item_id = wci.container_item_id
              AND msi.organization_id = wci.master_organization_id
           ) wci
      WHERE  wd.delivery_id = l_delivery_id
         AND wd.inventory_item_id = wci.load_item_id(+)
         AND wd.organization_id = wci.master_organization_id(+);
     --
     l_api_version NUMBER := 1.0;
     l_init_msg_list VARCHAR2(1) := FND_API.G_FALSE;
     l_commit VARCHAR2(1) := FND_API.G_TRUE;
     l_validation_level NUMBER := FND_API.G_VALID_LEVEL_FULL;
     x_return_status VARCHAR2(1);
     x_msg_count NUMBER;
     x_msg_data VARCHAR2(4000);
     l_TabOfDelDets WSH_DELIVERY_DETAILS_PUB.ID_TAB_TYPE;
     l_action VARCHAR2(4000);
     l_delivery_id NUMBER;
     l_delivery_Name VARCHAR2(4000);
     l_line_rows          WSH_UTIL_CORE.id_tab_type;
     l_del_rows           WSH_UTIL_CORE.id_tab_type;
     x_detail_id NUMBER;
     l_status_linha_updated NUMBER;
     l_line_rows_without_del WSH_UTIL_CORE.ID_TAB_TYPE;
     --
     x_return NUMBER:= 0;
     l_count NUMBER:=0;
     l_peso_maximo NUMBER:=0;
     l_peso_total NUMBER;
     l_delivery NUMBER;
     l_peso_carga NUMBER:=0;
     l_contador NUMBER :=0;
     l_req_id   NUMBER :=0;
     l_msg_erro CLOB;
     --
 BEGIN

      x_return := 0;
      l_count := 0;
      l_peso_maximo := f_get_truck_info(p_delivery_id);
      l_peso_total  := f_get_total_weight(p_delivery_id);

      IF l_peso_total = 0 THEN
         l_peso_total := 1;
      END IF;

      IF l_peso_maximo = 0 THEN
         l_peso_maximo := l_peso_total;
      END IF;

      l_count := ceil(l_peso_total/l_peso_maximo);

      l_delivery := p_delivery_id;

      fnd_file.put_line(fnd_file.output, '  Montando a Carga!');

      FOR i in 1 .. l_count LOOP

         l_peso_carga := 0;
         l_peso_total  := f_get_total_weight(p_delivery_id);
         IF l_peso_total = 0 THEN
            l_peso_total := 1;
         END IF;

         fnd_file.put_line(fnd_file.output, '  '||i||' - Peso Embarque: '||l_peso_total||' - Peso Veiculo:'||l_peso_maximo);
         IF l_peso_total > l_peso_maximo THEN


             FOR r_ship in c_ship(p_delivery_id) LOOP

                 IF l_peso_carga + r_ship.peso_bruto <= l_peso_maximo THEN

                    l_action := 'UNASSIGN';
                    l_peso_carga := l_peso_carga + r_ship.peso_bruto;

                    l_TabOfDelDets(1) := r_ship.delivery_detail_id;
                    WSH_DELIVERY_DETAILS_PUB.DETAIL_TO_DELIVERY( p_api_version => l_api_version
                                                                ,p_init_msg_list => l_init_msg_list
                                                                ,p_commit => l_commit
                                                                ,p_validation_level => l_validation_level
                                                                ,x_return_status => x_return_status
                                                                ,x_msg_count => x_msg_count
                                                                ,x_msg_data => x_msg_data
                                                                ,p_TabOfDelDets => l_TabOfDelDets
                                                                ,p_action => l_action
                                                                ,p_delivery_id => p_delivery_id
                                                                ,p_delivery_name => p_delivery_id
                                                                );

                    IF x_return_status IN('S','W') THEN

                       l_contador := l_contador + 1;
                       l_line_rows_without_del(l_contador) := r_ship.delivery_detail_id;
                       COMMIT;

                    END IF;

                    l_TabOfDelDets.delete;

                 END IF;

             END LOOP;

             IF l_contador > 0 THEN

                 WSH_DELIVERY_DETAILS_PUB.Autocreate_Deliveries( p_api_version_number => l_api_version
                                                                ,p_init_msg_list => l_init_msg_list
                                                                ,p_commit => l_commit
                                                                ,x_return_status => x_return_status
                                                                ,x_msg_count => x_msg_count
                                                                ,x_msg_data => x_msg_data
                                                                ,p_line_rows => l_line_rows_without_del
                                                                ,x_del_rows => l_del_rows
                                                               );
                 COMMIT;

                 Fnd_file.put_line(fnd_file.output, '  Separando Nova Delivery Criada:'||l_del_rows(1));

                 BEGIN
                    Separacao_Materiais_P_New (p_msg_erro    => l_msg_erro
                               ,p_delivery_id => l_del_rows(1));
                 EXCEPTION
                    WHEN OTHERS
                    THEN
                       fnd_file.put_line (
                          fnd_file.LOG,
                          '     XXPPG - Interface Outbound Oracle EBS x WMAS: Error:' || SQLERRM);
                 END;

                 Fnd_file.put_line(fnd_file.output, '  Delivery procesada!');

             END IF;

             x_return := 1;

         END IF;
         l_contador := 0;
         l_TabOfDelDets.delete;
         l_line_rows_without_del.delete;


      END LOOP;

    RETURN x_return;

 END f_monta_carga_embarques;

 FUNCTION f_add_fmin_to_delivery(p_delivery_detail_id IN NUMBER) RETURN NUMBER
 IS

      l_new_delivery_id         NUMBER;
      l_freight_terms_code      VARCHAR(100);
      l_ship_method_code        VARCHAR(100);
      l_ship_to_org_id          NUMBER;
      l_organization_id         NUMBER;
      l_payment_term_id         NUMBER;
      l_order_type_id           NUMBER;
      l_moeda                   VARCHAR(3);
      l_salesrep_id             NUMBER;
      l_header_id               NUMBER;
      --
      x_return NUMBER;

 BEGIN


      BEGIN

         SELECT distinct
               wnd.delivery_id,
               wnd.freight_terms_code,
               wnd.ship_method_code,
               oeh.ship_to_org_id,
               wdv.organization_id,
               oeh.payment_term_id,
               oeh.order_type_id,
               oeh.transactional_curr_code,
               oeh.salesrep_id,
               oeh.header_id
             INTO l_new_delivery_id,
                  l_freight_terms_code,
                  l_ship_method_code,
                  l_ship_to_org_id,
                  l_organization_id,
                  l_payment_term_id,
                  l_order_type_id,
                  l_moeda,
                  l_salesrep_id,
                  l_header_id
         FROM apps.wsh_new_deliveries wnd,
              apps.wsh_deliverables_v wdv,
              apps.oe_order_headers_all oeh
        WHERE 1=1
          and wdv.delivery_id = wnd.delivery_id
          and wdv.source_header_id = oeh.header_id
          and nvl(wdv.seal_code,'N') <> 'SEPARANDO'
          and wdv.released_status = 'S'
          and wdv.delivery_detail_id = p_delivery_detail_id;

      EXCEPTION
        WHEN no_data_found THEN
          l_new_delivery_id :=0;
          Fnd_file.put_line(fnd_file.output,'   Erro11:');

        WHEN others THEN
          l_new_delivery_id :=0;
          Fnd_file.put_line(fnd_file.output,'   Erro12:');
      END;

      /*Fnd_file.put_line(fnd_file.output,'   l_new_delivery_id: '||l_new_delivery_id);
      Fnd_file.put_line(fnd_file.output,'   l_freight_terms_code: '||l_freight_terms_code);
      Fnd_file.put_line(fnd_file.output,'   l_ship_method_code: '||l_ship_method_code);
      Fnd_file.put_line(fnd_file.output,'   l_ship_to_org_id: '||l_ship_to_org_id);
      Fnd_file.put_line(fnd_file.output,'   l_payment_term_id: '||l_payment_term_id);
      Fnd_file.put_line(fnd_file.output,'   l_organization_id: '||l_organization_id);
      Fnd_file.put_line(fnd_file.output,'   l_order_type_id: '||l_order_type_id);
      Fnd_file.put_line(fnd_file.output,'   l_moeda: '||l_moeda);
      Fnd_file.put_line(fnd_file.output,'   l_salesrep_id: '||l_salesrep_id);
      Fnd_file.put_line(fnd_file.output,'   l_header_id: '||l_header_id); */

      BEGIN

         SELECT distinct
               wnd.delivery_id
          INTO l_new_delivery_id
         FROM apps.wsh_new_deliveries wnd,
              apps.wsh_deliverables_v wdv,
              apps.oe_order_headers_all oeh
        WHERE 1=1
          and wdv.delivery_id = wnd.delivery_id
          and wdv.source_header_id = oeh.header_id
          and nvl(wdv.seal_code,'N') <> 'SEPARANDO'
          and wdv.released_status = 'S'
          and wnd.freight_terms_code = nvl(l_freight_terms_code,wnd.freight_terms_code)
          and wnd.ship_method_code = l_ship_method_code
          and oeh.ship_to_org_id = l_ship_to_org_id
          and wdv.organization_id = l_organization_id
          and oeh.payment_term_id = l_payment_term_id
          and oeh.order_type_id = l_order_type_id
          and oeh.transactional_curr_code = l_moeda
          and oeh.salesrep_id = l_salesrep_id
          and oeh.header_id = l_header_id
          and wdv.delivery_id not in(l_new_delivery_id)
          and ROWNUM = 1
        ORDER BY wnd.delivery_id;
        --Fnd_file.put_line(fnd_file.output,'   Nova Delivery: '||l_new_delivery_id);
      EXCEPTION
        WHEN no_data_found THEN

          BEGIN

             SELECT distinct
                   delivery_id
              INTO l_new_delivery_id
             FROM(SELECT wnd.delivery_id,oeh.header_id
                     FROM apps.wsh_new_deliveries wnd,
                          apps.wsh_deliverables_v wdv,
                          apps.oe_order_headers_all oeh
                     WHERE 1=1
                       and wdv.delivery_id = wnd.delivery_id
                       and wdv.source_header_id = oeh.header_id
                       and nvl(wdv.seal_code,'N') <> 'SEPARANDO'
                       and wdv.released_status = 'S'
                       and wnd.freight_terms_code = nvl(l_freight_terms_code,wnd.freight_terms_code)
                       and wnd.ship_method_code = l_ship_method_code
                       and oeh.ship_to_org_id = l_ship_to_org_id
                       and wdv.organization_id = l_organization_id
                       and oeh.payment_term_id = l_payment_term_id
                       and oeh.order_type_id = l_order_type_id
                       and oeh.transactional_curr_code = l_moeda
                       and oeh.salesrep_id = l_salesrep_id
                       and oeh.header_id not in(l_header_id)
                       and wdv.delivery_id not in(l_new_delivery_id)
                     ORDER BY oeh.header_id
                   )
                WHERE rownum=1;

          EXCEPTION
             WHEN no_data_found THEN
                  Fnd_file.put_line(fnd_file.output,'   Erro1:');
                  l_new_delivery_id :=0;
             WHEN others THEN
                  Fnd_file.put_line(fnd_file.output,'   Erro2:');
                  l_new_delivery_id :=0;
          END;

        WHEN others THEN
          Fnd_file.put_line(fnd_file.output,'   Erro3:');
          l_new_delivery_id :=0;
      END;

      Fnd_file.put_line(fnd_file.output,'');
      x_return := nvl(l_new_delivery_id,0);

    RETURN x_return;

 END f_add_fmin_to_delivery;

 FUNCTION f_add_item_embarque(p_delivery_detail_id IN NUMBER, p_delivery_id NUMBER) RETURN VARCHAR
 IS
     --
     l_api_version NUMBER := 1.0;
     l_init_msg_list VARCHAR2(1) := FND_API.G_FALSE;
     l_commit VARCHAR2(1) := FND_API.G_TRUE;
     l_validation_level NUMBER := FND_API.G_VALID_LEVEL_FULL;
     x_return_status VARCHAR2(1);
     x_msg_count NUMBER;
     x_msg_data VARCHAR2(4000);
     l_TabOfDelDets WSH_DELIVERY_DETAILS_PUB.ID_TAB_TYPE;
     l_action VARCHAR2(4000);
     --
     x_return VARCHAR(1);
     --
 BEGIN

      x_return := 'N';
      --fnd_file.put_line(fnd_file.output, '  Adicionando Item a um Embarque disponivel!');

      l_action := 'UNASSIGN';
      l_TabOfDelDets(1) := p_delivery_detail_id;

      WSH_DELIVERY_DETAILS_PUB.DETAIL_TO_DELIVERY( p_api_version => l_api_version
                                                    ,p_init_msg_list => l_init_msg_list
                                                    ,p_commit => l_commit
                                                    ,p_validation_level => l_validation_level
                                                    ,x_return_status => x_return_status
                                                    ,x_msg_count => x_msg_count
                                                    ,x_msg_data => x_msg_data
                                                    ,p_TabOfDelDets => l_TabOfDelDets
                                                    ,p_action => l_action
                                                    ,p_delivery_id => p_delivery_id
                                                    ,p_delivery_name => p_delivery_id
                                                    );

        l_action := 'ASSIGN';
        l_TabOfDelDets(1) := p_delivery_detail_id;

        WSH_DELIVERY_DETAILS_PUB.DETAIL_TO_DELIVERY( p_api_version => l_api_version
                                                    ,p_init_msg_list => l_init_msg_list
                                                    ,p_commit => l_commit
                                                    ,p_validation_level => l_validation_level
                                                    ,x_return_status => x_return_status
                                                    ,x_msg_count => x_msg_count
                                                    ,x_msg_data => x_msg_data
                                                    ,p_TabOfDelDets => l_TabOfDelDets
                                                    ,p_action => l_action
                                                    ,p_delivery_id => p_delivery_id
                                                    ,p_delivery_name => p_delivery_id
                                                    );

        IF x_return_status IN('S','W') THEN

           x_return := 'Y';
           COMMIT;

        END IF;

        --fnd_file.put_line(fnd_file.output, '    x_return_status: '||x_return_status);
        l_TabOfDelDets.delete;

    RETURN x_return;

 END f_add_item_embarque;

 FUNCTION p_backorder_line( p_move_order_line_id NUMBER
                             , x_error_msg OUT CLOB
                             ,l_msg VARCHAR) RETURN VARCHAR
   IS
      x_msg_count         NUMBER := 0;
      x_return_status     VARCHAR2(2);
      x_msg_data          VARCHAR2(32000);

      l_loop_cnt          NUMBER;
      l_data              VARCHAR2(32000);
      l_dummy_cnt         NUMBER;
      l_order_type        NUMBER;
      l_warehouse_id      NUMBER;
      l_result            BOOLEAN;

   BEGIN

       IF l_msg = 'Y' THEN
         Fnd_file.put_line(fnd_file.output, '     BACKORDER_LINE:'||p_move_order_line_id);
       END IF;

         SELECT organization_id
           INTO l_warehouse_id
          FROM mtl_txn_request_lines
         WHERE line_id = p_move_order_line_id;

      INV_GLOBALS.set_org_id (l_warehouse_id);

      INV_MO_BACKORDER_PVT.backorder(
          p_line_id       => p_move_order_line_id
        , x_return_status => x_return_status
        , x_msg_count     => x_msg_count
        , x_msg_data      => x_msg_data
      );
    IF l_msg = 'Y' THEN
      Fnd_file.put_line(fnd_file.output,'        <- X_RETURN_STATUS : '||FND_API.G_RET_STS_SUCCESS);
    END IF;

      IF x_return_status <> FND_API.G_RET_STS_SUCCESS THEN
         x_error_msg := '      BACKORDER_LINE: '||x_msg_data;
         IF x_msg_count > 0 THEN
             l_loop_cnt  := 1;
            WHILE l_loop_cnt > x_msg_count LOOP
                fnd_msg_pub.get(
                    p_msg_index     => l_loop_cnt,
                    p_data          => l_data,
                    p_encoded       => fnd_api.g_false,
                    p_msg_index_out => l_dummy_cnt
                );
                x_error_msg := x_error_msg || l_data;
                l_loop_cnt  := l_loop_cnt + 1;
            END LOOP;
         END IF;
      IF l_msg = 'Y' THEN
        Fnd_file.put_line(fnd_file.output,'     x_error_msg: '||x_error_msg);
      END IF;

      END IF;

      IF l_msg = 'Y' THEN
        Fnd_file.put_line(fnd_file.output,'     END BACK ORDER: ');
      END IF;

      RETURN x_return_status;

 END p_backorder_line;

 FUNCTION f_backorder_excarga RETURN NUMBER
 IS

     CURSOR c_ship IS
       SELECT delivery_id,delivery_detail_id,move_order_line_id
         FROM   apps.wsh_deliverables_v wdd
                ,apps.mtl_parameters mp
       WHERE seal_code = 'EXCARGA'
         AND released_status = 'S'
         AND mp.organization_id   = wdd.organization_id
         AND    mp.attribute7 <> '1'
         AND ( (
                  ---- para embarques planejados ---
                  wdd.shipment_priority_code in ( SELECT flv1.lookup_code
                                                    FROM apps.fnd_lookup_values_vl flv1
                                                   WHERE flv1.lookup_type = 'SHIPMENT_PRIORITY'
                                                     AND NVL(flv1.attribute2 , 'N') = 'Y'
                                                     AND NVL(flv1.attribute3 , 'N') = 'Y'
                                                     AND NVL(flv1.attribute4 , 'N') = 'Y')
                  AND nvl(wdd.seal_code, '0') NOT IN ( 'SEPARANDO' )

                 ) OR
                 (
                  ---- para embarques manuais ---
                  wdd.shipment_priority_code IN ( SELECT flv2.lookup_code
                                                    FROM apps.fnd_lookup_values_vl flv2
                                                   WHERE flv2.lookup_type = 'SHIPMENT_PRIORITY'
                                                     AND nvl(flv2.attribute2 , 'N') = 'N'
                                                     AND nvl(flv2.attribute3 , 'N') = 'Y'
                                                     AND nvl(flv2.attribute4 , 'N') = 'Y' )
                  AND NVL(wdd.seal_code,'0') NOT IN (SELECT flv3.lookup_code
                                                       FROM apps.fnd_lookup_values_vl flv3
                                                      WHERE flv3.lookup_type = 'PPG - STATUS EMBARQUE'
                                                        AND flv3.tag = 'WORK')
                 )
               )
         ;
     --
     x_return NUMBER:= 0;
     l_error_msg CLOB;
     l_backorder VARCHAR(1):='N';
     --
 BEGIN

      x_return := 0;
      FOR r_ship in c_ship LOOP

          l_backorder := p_backorder_line(r_ship.move_order_line_id, l_error_msg,'N');
          x_return := 1;

      END LOOP;


    RETURN x_return;

 END f_backorder_excarga;

 FUNCTION f_cancel_sales_lines(p_line_id IN NUMBER) RETURN VARCHAR
 IS
        l_user_id                      NUMBER;
        l_resp_id                      NUMBER;
        l_appl_id                      NUMBER;
        l_header_rec_in                oe_order_pub.header_rec_type;
        l_line_tbl_in                  oe_order_pub.line_tbl_type;
        l_action_request_tbl_in        oe_order_pub.request_tbl_type;
        l_header_rec_out               oe_order_pub.header_rec_type;
        l_line_tbl_out                 oe_order_pub.line_tbl_type;
        l_header_val_rec_out           oe_order_pub.header_val_rec_type;
        l_header_adj_tbl_out           oe_order_pub.header_adj_tbl_type;
        l_header_adj_val_tbl_out       oe_order_pub.header_adj_val_tbl_type;
        l_header_price_att_tbl_out     oe_order_pub.header_price_att_tbl_type;
        l_header_adj_att_tbl_out       oe_order_pub.header_adj_att_tbl_type;
        l_header_adj_assoc_tbl_out     oe_order_pub.header_adj_assoc_tbl_type;
        l_header_scredit_tbl_out       oe_order_pub.header_scredit_tbl_type;
        l_header_scredit_val_tbl_out   oe_order_pub.header_scredit_val_tbl_type;
        l_line_val_tbl_out             oe_order_pub.line_val_tbl_type;
        l_line_adj_tbl_out             oe_order_pub.line_adj_tbl_type;
        l_line_adj_val_tbl_out         oe_order_pub.line_adj_val_tbl_type;
        l_line_price_att_tbl_out       oe_order_pub.line_price_att_tbl_type;
        l_line_adj_att_tbl_out         oe_order_pub.line_adj_att_tbl_type;
        l_line_adj_assoc_tbl_out       oe_order_pub.line_adj_assoc_tbl_type;
        l_line_scredit_tbl_out         oe_order_pub.line_scredit_tbl_type;
        l_line_scredit_val_tbl_out     oe_order_pub.line_scredit_val_tbl_type;
        l_lot_serial_tbl_out           oe_order_pub.lot_serial_tbl_type;
        l_lot_serial_val_tbl_out       oe_order_pub.lot_serial_val_tbl_type;
        l_action_request_tbl_out       oe_order_pub.request_tbl_type;
        l_chr_program_unit_name        VARCHAR2 (100);
        l_ret_status               VARCHAR2 (1000)                     := NULL;
        l_msg_count                    NUMBER                                 := 0;
        l_msg_data                     VARCHAR2 (2000);
        l_api_version              NUMBER                               := 1.0;

       CURSOR c_so_details (l_line_id NUMBER) IS
       SELECT oh.order_number, ol.line_number, ol.shipment_number, ol.header_id, ol.line_id, ol.flow_status_code
       FROM oe_order_headers_all oh,
            oe_order_lines_all ol,
            mtl_system_items msi,
            mtl_parameters mp,
            wsh_delivery_details wsh
      WHERE ol.ordered_item = msi.segment1
        AND wsh.organization_id = mp.organization_id
        AND mp.organization_id = msi.organization_id
        AND ol.header_id = oh.header_id
        AND ol.inventory_item_id = msi.inventory_item_id
        AND wsh.source_line_id = ol.line_id
        AND wsh.source_header_id = oh.header_id
        AND wsh.released_status NOT IN ('Y','C','L','I')
        AND ol.flow_status_code IN ('AWAITING_SHIPPING','ENTERED')
        AND oh.flow_status_code IN ('BOOKED', 'ENTERED')
        AND ol.line_id = l_line_id
        ;
 BEGIN

    BEGIN


       SELECT user_id
          INTO l_user_id
          FROM fnd_user
         WHERE user_name = 'BR_SCHEDULER';

       SELECT responsibility_id, application_id
          INTO l_resp_id, l_appl_id
          FROM fnd_responsibility_vl
         WHERE responsibility_name like 'PPG BR OM IT Support';

       fnd_global.apps_initialize (l_user_id, l_resp_id, l_appl_id);

       FOR i IN c_so_details(p_line_id) LOOP
           l_line_tbl_in (1) := oe_order_pub.g_miss_line_rec;
           l_line_tbl_in (1).line_id := i.line_id;
           l_line_tbl_in (1).ordered_quantity := 0;
           l_line_tbl_in (1).change_reason := '1'; --Administrative Reason
           l_line_tbl_in (1).change_comments := '       Saldo da Ordem n?atingiu o faturamento minimo!';
           l_line_tbl_in (1).operation := oe_globals.g_opr_update;
           oe_msg_pub.delete_msg;

          oe_order_pub.process_order
                        (p_api_version_number          => l_api_version,
                         p_init_msg_list               => fnd_api.g_false,
                         p_return_values               => fnd_api.g_false,
                         p_action_commit               => fnd_api.g_false,
                         p_line_tbl                    => l_line_tbl_in,
                         x_header_rec                  => l_header_rec_out,
                         x_header_val_rec              => l_header_val_rec_out,
                         x_header_adj_tbl              => l_header_adj_tbl_out,
                         x_header_adj_val_tbl          => l_header_adj_val_tbl_out,
                         x_header_price_att_tbl        => l_header_price_att_tbl_out,
                         x_header_adj_att_tbl          => l_header_adj_att_tbl_out,
                         x_header_adj_assoc_tbl        => l_header_adj_assoc_tbl_out,
                         x_header_scredit_tbl          => l_header_scredit_tbl_out,
                         x_header_scredit_val_tbl      => l_header_scredit_val_tbl_out,
                         x_line_tbl                    => l_line_tbl_out,
                         x_line_val_tbl                => l_line_val_tbl_out,
                         x_line_adj_tbl                => l_line_adj_tbl_out,
                         x_line_adj_val_tbl            => l_line_adj_val_tbl_out,
                         x_line_price_att_tbl          => l_line_price_att_tbl_out,
                         x_line_adj_att_tbl            => l_line_adj_att_tbl_out,
                         x_line_adj_assoc_tbl          => l_line_adj_assoc_tbl_out,
                         x_line_scredit_tbl            => l_line_scredit_tbl_out,
                         x_line_scredit_val_tbl        => l_line_scredit_val_tbl_out,
                         x_lot_serial_tbl              => l_lot_serial_tbl_out,
                         x_lot_serial_val_tbl          => l_lot_serial_val_tbl_out,
                         x_action_request_tbl          => l_action_request_tbl_out,
                         x_return_status               => l_ret_status,
                         x_msg_count                   => l_msg_count,
                         x_msg_data                    => l_msg_data
                        );
           l_msg_data := NULL;

          IF l_ret_status <> 'S'
           THEN
              FOR iindx IN 1 .. l_msg_count
              LOOP
                 l_msg_data := l_msg_data || '  ' || oe_msg_pub.get (iindx);
              END LOOP;
              Fnd_file.put_line(fnd_file.output,'');
              Fnd_file.put_line(fnd_file.output,'       Sales Order => '|| i.order_number);
              Fnd_file.put_line(fnd_file.output,'       Line ID=> ' || i.line_id || ' Line Cancelation Failed');
              Fnd_file.put_line(fnd_file.output,'       Return Status: ' || l_ret_status);
              Fnd_file.put_line(fnd_file.output,'       Error Message: ' || l_msg_data);
              Fnd_file.put_line(fnd_file.output,'');
          ELSE
              Fnd_file.put_line(fnd_file.output,'');
              Fnd_file.put_line(fnd_file.output,'       Sales Order => '|| i.order_number);
              Fnd_file.put_line(fnd_file.output,'       Line ID=> ' || i.line_id || ' Line Cancelled Successfully');
              Fnd_file.put_line(fnd_file.output,'       Return Status: ' || l_ret_status);
              Fnd_file.put_line(fnd_file.output,'       Error Message: ' || l_msg_data);
              Fnd_file.put_line(fnd_file.output,'');
          END IF;

          COMMIT;

       END LOOP;

    END;

    RETURN l_ret_status;

 END f_cancel_sales_lines;

  --  +=====================================================================+
  --  | DESCRIPTION                                                         |
  --  |    Gap 82.8 - Integra? Separa? de Materiais - Outbound          |
  --  |                                                                     |
  --  | HISTORY                                                             |
  --  |    11-Jun-2014     Renato Furlan    Cria? da rotina.              |
  --  |    19-Nov-2014     Renato Furlan    Clientes do Exterior CNPJ vai   |
  --  |                                     estar nulo, preencher c/ zeros. |
  --  |                                                                     |
  --  +=====================================================================+

  PROCEDURE Separacao_Materiais_P_New (p_msg_erro    OUT Varchar2
                                  ,p_delivery_id  IN Number) IS

        CURSOR c_deliveries (c_delivery_id  In Number) IS
          SELECT DISTINCT wdd.delivery_id
          FROM apps.wsh_new_deliveries               wnd
             , apps.wsh_deliverables_v               wdd
             , apps.mtl_txn_request_lines            trl
             , apps.mtl_transaction_lots_temp        mtlt
             , apps.mtl_material_transactions_temp   mtt
             , apps.mtl_secondary_inventories        msi
             , apps.mtl_parameters                   mp
             , apps.hr_all_organization_units        haou
             , apps.cll_f189_fiscal_entities_all     cffe
             , apps.hz_cust_site_uses_all            hcsua
             , apps.hz_cust_acct_sites_all           hcasa
             , apps.hz_cust_accounts                 hca
             , apps.hz_party_sites                   hps
             , apps.hz_locations                     hl
             , apps.hz_parties                       hp
             , apps.oe_order_lines_all               oola
             , apps.jl_br_ap_operations              jbao
             , apps.mtl_system_items_b               msib
             , apps.wsh_carriers                     wc
             , apps.ap_suppliers                     asu
             , apps.ap_supplier_sites_all            assa
         WHERE wnd.delivery_id                 = NVL(c_delivery_id, wnd.delivery_id)
           AND wnd.delivery_id                 = wdd.delivery_id
           AND trl.txn_source_line_detail_id   = wdd.delivery_detail_id
           AND trl.line_status                IN (3,7)
           AND trl.quantity_delivered         IS NULL
           AND trl.line_id                     = mtt.move_order_line_id
           AND trl.txn_source_line_id          = mtt.trx_source_line_id
           AND mtt.transaction_temp_id         = mtlt.transaction_temp_id(+)
           AND mp.organization_id              = wdd.organization_id
           AND wdd.org_id                      = Fnd_Profile.Value('ORG_ID')
           AND haou.organization_id            = mp.organization_id
           AND cffe.location_id                = haou.location_id
           AND cffe.entity_type_lookup_code    = 'LOCATION'
           AND trl.from_subinventory_code      = msi.secondary_inventory_name(+)
           AND trl.organization_id             = msi.organization_id(+)
           AND NVL(wnd.attribute8,'0')         = '0'
           AND hcsua.site_use_id               = wdd.ship_to_site_use_id
           AND hcasa.cust_acct_site_id         = hcsua.cust_acct_site_id
           AND hca.cust_account_id             = hcasa.cust_account_id
           AND hp.party_id                     = hca.party_id
           AND hps.party_site_id               = hcasa.party_site_id
           AND hl.location_id                  = hps.location_id
           AND oola.line_id                    = wdd.source_line_id
           AND jbao.cfo_code(+)                = oola.global_attribute1
           AND msib.inventory_item_id          = wdd.inventory_item_id
           AND msib.organization_id            = wdd.organization_id
           AND wc.carrier_id(+)                = wdd.carrier_id
           AND asu.vendor_id(+)                = wc.supplier_id
           AND assa.vendor_site_id(+)          = wc.supplier_site_id
           AND wdd.released_status = 'S'
           AND mp.attribute7 <> '1'
           AND ( (
                  ---- para embarques planejados ---
                  wdd.shipment_priority_code in ( SELECT flv1.lookup_code
                                                    FROM fnd_lookup_values_vl flv1
                                                   WHERE flv1.lookup_type = 'SHIPMENT_PRIORITY'
                                                     AND NVL(flv1.attribute2 , 'N') = 'Y'
                                                     AND NVL(flv1.attribute3 , 'N') = 'Y'
                                                     AND NVL(flv1.attribute4 , 'N') = 'Y')
                  AND nvl(wdd.seal_code, '0') NOT IN ( 'SEPARANDO' )

                 ) OR
                 (
                  ---- para embarques manuais ---
                  wdd.shipment_priority_code IN ( SELECT flv2.lookup_code
                                                    FROM fnd_lookup_values_vl flv2
                                                   WHERE flv2.lookup_type = 'SHIPMENT_PRIORITY'
                                                     AND nvl(flv2.attribute2 , 'N') = 'N'
                                                     AND nvl(flv2.attribute3 , 'N') = 'Y'
                                                     AND nvl(flv2.attribute4 , 'N') = 'Y' )
                  AND NVL(wdd.seal_code,'0') NOT IN (SELECT flv3.lookup_code
                                                       FROM fnd_lookup_values_vl flv3
                                                      WHERE flv3.lookup_type = 'PPG - STATUS EMBARQUE'
                                                        AND flv3.tag = 'WORK')
                 )
               )

        ORDER BY wdd.delivery_id;



     CURSOR c_docs (c_delivery_id  In Number)  IS
        SELECT mp.organization_id
             , mp.attribute7             Cod_Estabelecimento
             , cffe.document_number      CNPJ_Estabelecimento
             , wnd.delivery_id
             , wdd.seal_code
             , wnd.name   delivery_name
             , wdd.delivery_detail_id
             , wdd.move_order_line_id
             , wdd.source_line_id
             , wdd.source_header_number
             , wdd.source_header_id
             , NVL(DECODE(hcasa.global_attribute2,'1',hcasa.global_attribute3||hcasa.global_attribute5
                                                     ,SUBSTR(hcasa.global_attribute3,2)||hcasa.global_attribute4||hcasa.global_attribute5)
                        ,'00000000000000')  CNPJ_CPF
             , oola.global_attribute1   CFO
             , jbao.cfo_description
             , wdd.volume_uom_code
             , NVL(wnd.number_of_lpn,0)   volume
             , wnd.gross_weight
             , wnd.net_weight
             , DECODE(wnd.freight_terms_code,NULL,NULL,DECODE(SUBSTR(wnd.freight_terms_code,1,3),'CIF',1,'FOB',2,NULL)) tipo_frete
             , hp.party_name
             , hl.address1||DECODE(hl.address2,Null,Null,',')||
               hl.address2||DECODE(hl.address3,Null,Null,',')||
               hl.address3    endereco
             , hl.address4    bairro
             , hl.city
             , hl.state
             , hl.postal_code
             , hcasa.global_attribute6  IE
             , hcasa.cust_acct_site_id
             , DECODE(hcasa.global_attribute2,'1','F','J')  Tipo_Empresa
             , msib.segment1          item_code
             , msib.inventory_item_id
             , msi.Attribute2                 Endereco_Doca
             , msi.secondary_inventory_name   Subinventory
             , wdd.requested_quantity
             , trl.line_id
             , NVL(mtlt.primary_quantity, trl.primary_quantity)   primary_quantity
             , trl.pick_slip_number
             , wdd.date_scheduled
             , DECODE(mtlt.lot_number, NULL,NULL, '3') Tipo_Logistico
             , mtlt.lot_number
             , oola.global_attribute5     classificacao_fiscal
             , oola.global_attribute10    situacao_tributaria
             , asu.vendor_name            Nome_Transportadora
             , asu.segment1               Codigo_Transportadora
             , DECODE(assa.global_attribute9,'1',assa.global_attribute10||assa.global_attribute12
                                                ,SUBSTR(assa.global_attribute10,2)||assa.global_attribute11||assa.global_attribute12)  CNPJ_Transportadora
             , assa.address_line1||DECODE(assa.address_line2,Null,Null,',')||
               assa.address_line2||DECODE(assa.address_line3,Null,Null,',')||
               assa.address_line3         Endereco_Transportadora
             , assa.address_line4         Bairro_Transportadora
             , assa.city                  Municipio_Transportadora
             , assa.state                 UF_Transportadora
             , assa.zip                   CEP_Transportadora
             , assa.global_attribute13    IE_Transportadora
             , DECODE(assa.global_attribute9,NULL,NULL,DECODE(assa.global_attribute9,'1','F','J'))   Tipo_Transportadora
             , msib.primary_uom_code           TipoUC
             , 1                               FatorTipoUC
             , ( select email_address
                   from apps.jtf_rs_salesreps
                 where salesrep_id = ( select salesrep_id
                                          from apps.oe_order_headers_all
                                       where header_id = wdd.source_header_id) ) email_address
          FROM apps.wsh_new_deliveries               wnd
             , apps.wsh_deliverables_v               wdd
             , apps.mtl_txn_request_lines            trl
             , apps.mtl_transaction_lots_temp        mtlt
             , apps.mtl_material_transactions_temp   mtt
             , apps.mtl_secondary_inventories        msi
             , apps.mtl_parameters                   mp
             , apps.hr_all_organization_units        haou
             , apps.cll_f189_fiscal_entities_all     cffe
             , apps.hz_cust_site_uses_all            hcsua
             , apps.hz_cust_acct_sites_all           hcasa
             , apps.hz_cust_accounts                 hca
             , apps.hz_party_sites                   hps
             , apps.hz_locations                     hl
             , apps.hz_parties                       hp
             , apps.oe_order_lines_all               oola
             , apps.jl_br_ap_operations              jbao
             , apps.mtl_system_items_b               msib
             , apps.wsh_carriers                     wc
             , apps.ap_suppliers                     asu
             , apps.ap_supplier_sites_all            assa
         WHERE wnd.delivery_id                 = NVL(c_delivery_id, wnd.delivery_id)
           AND wnd.delivery_id                 = wdd.delivery_id
           AND trl.txn_source_line_detail_id   = wdd.delivery_detail_id
           AND trl.line_status                IN (3,7)
           AND trl.quantity_delivered         IS NULL
           AND trl.line_id                     = mtt.move_order_line_id
           AND trl.txn_source_line_id          = mtt.trx_source_line_id
           AND mtt.transaction_temp_id         = mtlt.transaction_temp_id(+)
           AND mp.organization_id              = wdd.organization_id
           AND wdd.org_id                      = Fnd_Profile.Value('ORG_ID')
           AND haou.organization_id            = mp.organization_id
           AND cffe.location_id                = haou.location_id
           AND cffe.entity_type_lookup_code    = 'LOCATION'
           AND trl.from_subinventory_code      = msi.secondary_inventory_name(+)
           AND trl.organization_id             = msi.organization_id(+)
           AND NVL(wnd.attribute8,'0')         = '0'
           AND hcsua.site_use_id               = wdd.ship_to_site_use_id
           AND hcasa.cust_acct_site_id         = hcsua.cust_acct_site_id
           AND hca.cust_account_id             = hcasa.cust_account_id
           AND hp.party_id                     = hca.party_id
           AND hps.party_site_id               = hcasa.party_site_id
           AND hl.location_id                  = hps.location_id
           AND oola.line_id                    = wdd.source_line_id
           AND jbao.cfo_code(+)                = oola.global_attribute1
           AND msib.inventory_item_id          = wdd.inventory_item_id
           AND msib.organization_id            = wdd.organization_id
           AND wc.carrier_id(+)                = wdd.carrier_id
           AND asu.vendor_id(+)                = wc.supplier_id
           AND assa.vendor_site_id(+)          = wc.supplier_site_id
           AND wdd.released_status = 'S'
           AND mp.attribute7 <> '1'
           AND ( (
                  ---- para embarques planejados ---
                  wdd.shipment_priority_code in ( SELECT flv1.lookup_code
                                                    FROM fnd_lookup_values_vl flv1
                                                   WHERE flv1.lookup_type = 'SHIPMENT_PRIORITY'
                                                     AND NVL(flv1.attribute2 , 'N') = 'Y'
                                                     AND NVL(flv1.attribute3 , 'N') = 'Y'
                                                     AND NVL(flv1.attribute4 , 'N') = 'Y')
                  --AND wdd.seal_code IN ( SELECT flv4.lookup_code --Calori_001
                  /*AND nvl(wdd.seal_code, p_status) IN ( SELECT flv4.lookup_code --Calori_001
                                                         FROM fnd_lookup_values_vl  flv4
                                                        WHERE flv4.lookup_type = 'PPG - STATUS EMBARQUE'
                                                         AND flv4.tag = 'OUT' )*/
                  AND nvl(wdd.seal_code, '0') NOT IN ( 'SEPARANDO' )

                 ) OR
                 (
                  ---- para embarques manuais ---
                  wdd.shipment_priority_code IN ( SELECT flv2.lookup_code
                                                    FROM fnd_lookup_values_vl flv2
                                                   WHERE flv2.lookup_type = 'SHIPMENT_PRIORITY'
                                                     AND nvl(flv2.attribute2 , 'N') = 'N'
                                                     AND nvl(flv2.attribute3 , 'N') = 'Y'
                                                     AND nvl(flv2.attribute4 , 'N') = 'Y' )
                  AND NVL(wdd.seal_code,'0') NOT IN (SELECT flv3.lookup_code
                                                       FROM fnd_lookup_values_vl flv3
                                                      WHERE flv3.lookup_type = 'PPG - STATUS EMBARQUE'
                                                        AND flv3.tag = 'WORK')
                 )
               )

        ORDER BY wnd.delivery_id, wdd.source_header_id, wdd.source_line_id, wdd.delivery_detail_id;

    CURSOR c_email(p_line_id NUMBER) IS
    select distinct cliente.nome_cliente, cliente.cnpj, cliente.cidade, cliente.estado, Email_Cliente, ordem.*
       from
        (
          select
                hcsua.site_use_id,
                hp.party_name nome_cliente,
                substr(hcsua.location,1,instr(hcsua.location,'_',1)-1) cnpj,
                hl.city cidade,
                hl.state estado,
                case when fnd_profile.value('APPS_DATABASE_ID') <> 'lapoea' THEN fnd_profile.value('XXPPG_OM_EMAIL_CANCELAMENTO_PEDIDO') ELSE hzcp.email_address END Email_Cliente
            from
                apps.hz_parties hp,
                apps.hz_cust_accounts hca,
                apps.hz_cust_site_uses_all hcsua,
                apps.hz_cust_acct_sites_all hcasa,
                apps.hz_party_sites hps,
                apps.hz_locations hl,
                apps.hz_customer_profiles hcp,
                apps.hz_contact_points hzcp

           where hcsua.cust_acct_site_id = hcasa.cust_acct_site_id
             and hcasa.party_site_id = hps.party_site_id
             and hps.party_id = hp.party_id
             and hp.party_id = hca.party_id
             and hps.location_id = hl.location_id
             and hca.cust_account_id = hcp.cust_account_id
             and hcsua.site_use_code = 'SHIP_TO'
             --
             and hps.party_site_id = hzcp.owner_table_id(+)
             and nvl(hzcp.primary_flag(+),'Y') = 'Y'
             and nvl(hzcp.contact_point_type(+),'EMAIL') = 'EMAIL'
             and nvl(hzcp.owner_table_name(+),'HZ_PARTY_SITES') = 'HZ_PARTY_SITES'
        ) cliente
        ,
        ( select
              ool.ship_to_org_id,
              ool.line_id,
              ooh.order_number           Pedido_Oracle,
              ooh.cust_po_number         Pedido_Cliente,
              ooh.orig_sys_document_ref  Pedido_Dynamics,
              ooh.creation_date Data_Criacao_ordem,
              ool.ordered_item codigo_item,
              (select distinct description from apps.mtl_system_items_b where inventory_item_id = ool.ordered_item_id and organization_id = ool.ship_from_org_id) descricao, --#07 OSM 22/09/2015
              ool.line_number linha,
              ool.unit_selling_price preco_unitario,
              ool.ordered_quantity qtde_a_Faturar,
              ool.flow_status_code status_linha,
              (select salesrep_number from apps.jtf_rs_salesreps where salesrep_id = ooh.salesrep_id) cod_vendedor,
              (select source_name from apps.jtf_rs_salesreps a, apps.jtf_rs_resource_extns b
                where a.resource_id = b.resource_id and salesrep_id = ooh.salesrep_id) vendedor,
              (select name from apps.ra_terms_tl where term_id = ool.payment_term_id and language = 'PTB') Condicao_Pgto
              ,( select case when fnd_profile.value('APPS_DATABASE_ID') <> 'lapoea' THEN fnd_profile.value('XXPPG_OM_EMAIL_CANCELAMENTO_PEDIDO') ELSE email_address END
                   from apps.jtf_rs_salesreps
                 where salesrep_id = ooh.salesrep_id
                 ) email_address_rep
           from
             apps.oe_order_headers_all ooh,
             apps.oe_order_lines_all ool
           where ooh.header_id = ool.header_id
          ) ordem
    where ordem.ship_to_org_id = cliente.site_use_id
      and line_id = p_line_id
      ;


    l_debug                  Varchar2(1000);
    l_seq_integracao         Number;
    l_seq_documento          Number := 0;
    l_seq_detalhe            Number := 0;
    l_index_detalhe          Number := 0;
    l_return_status          Varchar2(1);
    l_msg_data               Varchar2(32000);
    l_delivery_id            wsh_new_deliveries.delivery_id%TYPE;
    l_delivery_id_ant        wsh_new_deliveries.delivery_id%TYPE := 0;
    l_delivery_name          wsh_new_deliveries.name%TYPE;
    l_saida                  Exception;
    l_saida_erro             Exception;
    l_saida_erro1            Exception;
    l_status                 fnd_profile_option_values.profile_option_value%TYPE;
    l_valor_total_embarque   NUMBER;
    l_fatminvendor1          NUMBER;
    l_fatminvendor2          NUMBER;
    l_result_window          NUMBER;
    l_qty_prev_fact          VARCHAR(1):='N';
    l_fat_min                NUMBER:=0;
    l_agrupamento            VARCHAR(1):='N';
    l_lib_fat_min            VARCHAR(1);
    l_vendor                 VARCHAR(1);
    l_enviar                 VARCHAR(1):='Y';
    l_janela                 VARCHAR(1):='N';
    l_desabilitar_janela        VARCHAR(1):='N';
    l_status_cancel          VARCHAR(1):='N';
    p_status                 VARCHAR(20);
    l_error_msg              CLOB;
    l_cancelamento           fnd_profile_option_values.profile_option_value%TYPE;
    l_grava_embarque_wmas    VARCHAR(1):='N';
    l_count                  NUMBER:=0;
    l_excarga                NUMBER:=0;
    l_monta_carga            NUMBER :=0;
    l_backorder_excarga      NUMBER :=0;
    l_new_delivery           NUMBER :=0;
    l_add_item_embarque      VARCHAR(1):='N';
    l_habilita_excarga       VARCHAR(1):='N';
    l_add_fmin               VARCHAR(1):='N';
    --
    p_to             VARCHAR2 (32767);
    p_from           VARCHAR2 (32767);
    p_message        CLOB;
    l_message        CLOB;
    p_errbuf         VARCHAR2(100);
    p_retcode        VARCHAR2(100);
    l_subject        VARCHAR2 (100);

    --
    TYPE g_cancel IS RECORD
    (
        v_delivery_detail_id      NUMBER,
        v_source_line_id          NUMBER,
        v_item_code               VARCHAR(100),
        v_qtde                    NUMBER,
        v_pedido                  NUMBER,
        v_email                   VARCHAR(150)
    );

    TYPE g_cancel_tab1 IS TABLE OF g_cancel
                                 INDEX BY BINARY_INTEGER;

    l_TabOfCancelDets   g_cancel_tab1;

    l_cancel    NUMBER;
    l_email     VARCHAR(200);
    l_envio_email VARCHAR(1);
    l_backorder   VARCHAR(1):='N';
    l_message_cab CLOB;

  BEGIN

    l_cancelamento := nvl(fnd_profile.value('XXPPG_OM_HABILITA_CANCELAMENTO_FATMIN'),'N');
    l_grava_embarque_wmas := nvl(fnd_profile.value('XXPPG_CONFIRMA_ENVIO_EMBARQUE_WMAS'),'N');
    l_habilita_excarga := nvl(fnd_profile.value('XXPPG_OM_TRATAR_EXCESSO_CARGA'),'N');
    l_add_fmin := nvl(fnd_profile.value('XXPPG_OM_ADD_FATMIN_EMBARQUE'),'N');
    l_envio_email := nvl(fnd_profile.value('XXPPG_OM_ENVIAR_EMAIL_CANCELAMENTO_PEDIDO'),'N');
    l_desabilitar_janela := nvl(fnd_profile.value('XXPPG_OM_DESABILITAR_JANELA'),'N');

    fnd_file.put_line(fnd_file.output, '');
    fnd_file.put_line(fnd_file.output, '****************************************************************************** ');
    fnd_file.put_line(fnd_file.output, 'Disparando Integracao da Separacao de Materiais                                ');
    fnd_file.put_line(fnd_file.output, '****************************************************************************** ');

    fnd_file.put_line(fnd_file.output, '');
    fnd_file.put_line(fnd_file.output, '  Cancelamento Habilitado: '||l_cancelamento);
    fnd_file.put_line(fnd_file.output, '  Inserir os Embarque no WMAS: '||l_grava_embarque_wmas);
    fnd_file.put_line(fnd_file.output, '  Desabilitar verifica? de Janela: '||l_desabilitar_janela);
    fnd_file.put_line(fnd_file.output, '  Habilitar rotina para tratar Excesso de Carga: '||l_habilita_excarga);
    fnd_file.put_line(fnd_file.output, '  Habilitar rotina para adicionar items FMIN a Embarque: '||l_add_fmin);


    IF l_habilita_excarga = 'Y' THEN
        l_excarga := f_verify_excarga(0);
        fnd_file.put_line(fnd_file.output, '  Verifacao Excarga := '||l_excarga);
        l_backorder_excarga := f_backorder_excarga();
        fnd_file.put_line(fnd_file.output, '  Backorder Excarga Realizado : = '||l_backorder_excarga);
    END IF;

    fnd_file.put_line(fnd_file.output, '');

    FOR r_deliveries IN c_deliveries(p_delivery_id) LOOP

       BEGIN
         UPDATE APPS.WSH_DELIVERY_DETAILS
          SET SEAL_CODE = NULL
         WHERE DELIVERY_DETAIL_ID IN( SELECT DELIVERY_DETAIL_ID
                                       FROM APPS.WSH_DELIVERABLES_V
                                      WHERE DELIVERY_ID = R_DELIVERIES.DELIVERY_ID
                                     )
           AND SEAL_CODE IS NOT NULL AND SEAL_CODE <> 'FORCAENVIO' AND SEAL_CODE <> 'EXCARGA';
         COMMIT;
       EXCEPTION
         WHEN no_data_found THEN
           NULL;
         WHEN others THEN
           NULL;
       END;

        --
        Fnd_file.put_line(fnd_file.output,'');
        l_delivery_id          := r_deliveries.delivery_id;
        --
        l_qty_prev_fact := 0;
        l_agrupamento   := 0;
        l_valor_total_embarque := f_get_valor_embarque(l_delivery_id);
        l_vendor               := f_get_delivery_details(l_delivery_id,'VENDOR');
        l_lib_fat_min          := f_get_delivery_details(l_delivery_id,'LIB_FMIN');
        l_fat_min              := to_number(f_get_delivery_details(l_delivery_id,'FMIN'));
        l_fatminvendor1        := to_number(f_get_delivery_details(l_delivery_id,'VENDOR1FAT'));
        l_fatminvendor2        := to_number(f_get_delivery_details(l_delivery_id,'VENDOR2FAT'));
        l_qty_prev_fact        := f_get_delivery_details(l_delivery_id,'VENDORFAT_ANT');
        l_agrupamento          := f_get_delivery_details(l_delivery_id,'CONDPGTO');
        --
        Fnd_file.put_line(fnd_file.output,'');
        --
        IF l_habilita_excarga = 'Y' THEN
           l_monta_carga := f_monta_carga_embarques(r_deliveries.delivery_id);
        END IF;
        --
        Fnd_file.put_line(fnd_file.output,'');
        --
        l_enviar := 'Y';
        l_janela := 'N';
        p_status := NULL;
        l_count  := 0;
        l_new_delivery := 0;

        Fnd_file.put_line(fnd_file.output,'  Delivery:            '||l_delivery_id||chr(13)
                                        ||'  Valor Embarque:      '||l_valor_total_embarque ||chr(13)
                                        ||'  Cond Pagto a Vista:  '||l_lib_fat_min||chr(13)
                                        ||'  Vendor:              '||l_vendor||chr(13)
                                        ||'  Fat Minimo1 Vendor:  '||l_fatminvendor1||chr(13)
                                        ||'  Fat Minimo2 Vendor:  '||l_fatminvendor2||chr(13)
                                        ||'  Faturamento Minimo:  '||l_fat_min||chr(13)
                                        ||'  Fat Anterior Vendor: '||l_qty_prev_fact||chr(13)
                                        ||'  Verifica Agrupamento:'||l_agrupamento);

         IF l_agrupamento = 'Y' THEN
            l_enviar := 'N';
            p_status := 'DIV_AGRUPTO';
         END IF;


         IF l_vendor = 'Y' and l_enviar = 'Y' THEN

            IF   (l_qty_prev_fact = 'N' AND l_valor_total_embarque >= l_fatminvendor1)
                    OR (l_qty_prev_fact = 'Y' AND l_valor_total_embarque >= l_fatminvendor2) THEN
                      l_enviar := 'Y';
            ELSE
                      l_enviar := 'N';
                      p_status := 'VENDOR';
            END IF;

         END IF;

         IF l_vendor = 'N' and l_agrupamento = 'N' THEN

             IF l_enviar = 'Y' and l_valor_total_embarque >= l_fat_min THEN
                l_enviar := 'Y';
             ELSE
                l_enviar := 'N';
                p_status := 'FMIN';
             END IF;

         END IF;


         IF l_lib_fat_min = 'Y' and l_agrupamento = 'N' THEN
            l_enviar := 'Y';
         END IF;

         IF l_enviar = 'Y' and l_lib_fat_min = 'N' and l_agrupamento = 'N' THEN

            IF l_desabilitar_janela = 'N' THEN
                  l_result_window  := f_verify_window(l_delivery_id);
                  IF  l_result_window <> 0 THEN
                    l_enviar := 'Y';
                  ELSE
                    l_enviar := 'N';
                    p_status := 'JANELA';
                    l_janela := 'Y';
                 END IF;
            END IF;

         END IF;

      --END IF;

         Fnd_file.put_line(fnd_file.output,'  PPG Status: '||p_status);
         Fnd_file.put_line(fnd_file.output,'  Enviar: '||l_enviar);

        l_count := 0;
        l_cancel := 0;
        l_TabOfCancelDets.DELETE;

        FOR r_docs IN c_docs(l_delivery_id) LOOP

           BEGIN

              --Fnd_file.put_line(fnd_file.output,'  PPG Status: '||r_docs.seal_code);
              IF (l_enviar = 'Y') or (r_docs.seal_code = 'FORCAENVIO') THEN

                  BEGIN

                       l_count := l_count+1;
                       l_delivery_id := r_docs.delivery_id;
                       IF l_count = 1 THEN

                          g_integracao_tbl_type.delete;
                          g_integracao_hist_tbl_type.delete;
                          g_documento_tbl_type.delete;
                          g_documentodetalhe_tbl_type.delete;
                          g_movimentoestoque_tbl_type.delete;
                          g_produto_tbl_type.delete;
                          g_TipoUC_tbl_type.delete;
                          l_msg_data := Null;

                          -- Gravando Integracao
                          l_debug := 'Integracao';
                          g_integracao_tbl_type(1).TipoIntegracao                         := 203;
                          g_integracao_tbl_type(1).EstadoIntegracao                       := 1;
                          g_integracao_tbl_type(1).SequenciaRelacionada                   := r_docs.delivery_id;

                          -- Gravando Documento
                          l_debug                                                         := 'Documento';
                          l_seq_documento                                                 := 1;
                          l_seq_detalhe                                                   := 0;
                          l_index_detalhe                                                 := 0;
                          l_delivery_id_ant                                               := r_docs.delivery_id;
                          l_delivery_name                                                 := r_docs.delivery_name;
                          g_documento_tbl_type(l_seq_documento).SequenciaDocumento        := l_seq_documento;
                          l_debug                                                         := 'Documento - CodigoEstabelecimento';
                          g_documento_tbl_type(l_seq_documento).CodigoEstabelecimento     := r_docs.Cod_Estabelecimento;
                          l_debug                                                         := 'Documento - CodigoDepositante';
                          g_documento_tbl_type(l_seq_documento).CodigoDepositante         := r_docs.Cod_Estabelecimento;
                          l_debug                                                         := 'Documento - CNPJCPFDepositante';
                          g_documento_tbl_type(l_seq_documento).CNPJCPFDepositante        := SUBSTR(r_docs.CNPJ_Estabelecimento,1,20);
                          l_debug                                                         := 'Documento - TipoDocumento';
                          g_documento_tbl_type(l_seq_documento).TipoDocumento             := 'EMB';
                          l_debug                                                         := 'Documento - SerieDocumento';
                          g_documento_tbl_type(l_seq_documento).SerieDocumento            := '1';
                          l_debug                                                         := 'Documento - NumeroDocumento';
                          g_documento_tbl_type(l_seq_documento).NumeroDocumento           := r_docs.delivery_id;
                          l_debug                                                         := 'Documento - ModeloDocumento';
                          g_documento_tbl_type(l_seq_documento).ModeloDocumento           := 'EMB';
                          l_debug                                                         := 'Documento - CodigoEmpresa';
                          g_documento_tbl_type(l_seq_documento).CodigoEmpresa             := SUBSTR(r_docs.CNPJ_CPF,1,15);
                          l_debug                                                         := 'Documento - CodigoEntrega';
                          g_documento_tbl_type(l_seq_documento).CodigoEntrega             := SUBSTR(r_docs.CNPJ_CPF,1,15);
                          l_debug                                                         := 'Documento - NaturezaOperacao';
                          g_documento_tbl_type(l_seq_documento).NaturezaOperacao          := '0000';
                          l_debug                                                         := 'Documento - DescricaoNaturezaOperacao';
                          g_documento_tbl_type(l_seq_documento).DescricaoNaturezaOperacao := 'SEM VALOR FISCAL';
                          l_debug                                                         := 'Documento - CFOP';
                          g_documento_tbl_type(l_seq_documento).CFOP                      := '0000';
                          l_debug                                                         := 'Documento - DataEmissao';
                          g_documento_tbl_type(l_seq_documento).DataEmissao               := TRUNC(Sysdate);
                          l_debug                                                         := 'Documento - EspecieVolume';
                          g_documento_tbl_type(l_seq_documento).EspecieVolume             := SUBSTR(r_docs.volume_uom_code,1,40);
                          l_debug                                                         := 'Documento - QuantidadeVolume';
                          g_documento_tbl_type(l_seq_documento).QuantidadeVolume          := r_docs.volume;
                          l_debug                                                         := 'Documento - PesoBruto';
                          g_documento_tbl_type(l_seq_documento).PesoBruto                 := r_docs.gross_weight;
                          l_debug                                                         := 'Documento - PesoLiquido';
                          g_documento_tbl_type(l_seq_documento).PesoLiquido               := r_docs.net_weight;
                          l_debug                                                         := 'Documento - TipoFrete';
                          g_documento_tbl_type(l_seq_documento).TipoFrete                 := r_docs.tipo_frete;
                          l_debug                                                         := 'Documento - CNPJCPFEmpresa';
                          g_documento_tbl_type(l_seq_documento).CNPJCPFEmpresa            := SUBSTR(r_docs.CNPJ_CPF,1,20);
                          l_debug                                                         := 'Documento - NomeEmpresa';
                          g_documento_tbl_type(l_seq_documento).NomeEmpresa               := SUBSTR(r_docs.party_name,1,80);
                          l_debug                                                         := 'Documento - EnderecoEmpresa';
                          g_documento_tbl_type(l_seq_documento).EnderecoEmpresa           := SUBSTR(r_docs.endereco,1,90);
                          l_debug                                                         := 'Documento - BairroEmpresa';
                          g_documento_tbl_type(l_seq_documento).BairroEmpresa             := SUBSTR(r_docs.bairro,1,25);
                          l_debug                                                         := 'Documento - MunicipioEmpresa';
                          g_documento_tbl_type(l_seq_documento).MunicipioEmpresa          := SUBSTR(r_docs.city,1,25);
                          l_debug                                                         := 'Documento - UFEmpresa';
                          g_documento_tbl_type(l_seq_documento).UFEmpresa                 := SUBSTR(r_docs.state,1,2);
                          l_debug                                                         := 'Documento - CEPEmpresa';
                          g_documento_tbl_type(l_seq_documento).CEPEmpresa                := SUBSTR(r_docs.postal_code,1,9);
                          l_debug                                                         := 'Documento - InscricaoEmpresa';
                          g_documento_tbl_type(l_seq_documento).InscricaoEmpresa          := SUBSTR(r_docs.IE,1,20);
                          l_debug                                                         := 'Documento - TipoPessoaEmpresa';
                          g_documento_tbl_type(l_seq_documento).TipoPessoaEmpresa         := SUBSTR(r_docs.Tipo_Empresa,1,1);
                          l_debug                                                         := 'Documento - CNPJCPFTransportadora';
                          g_documento_tbl_type(l_seq_documento).CNPJCPFTransportadora     := SUBSTR(r_docs.CNPJ_Transportadora,1,20);
                          l_debug                                                         := 'Documento - CodigoTransportadora';
                          g_documento_tbl_type(l_seq_documento).CodigoTransportadora      := r_docs.Codigo_Transportadora;
                          l_debug                                                         := 'Documento - NomeTransportadora';
                          g_documento_tbl_type(l_seq_documento).NomeTransportadora        := SUBSTR(r_docs.Nome_Transportadora,1,80);
                          l_debug                                                         := 'Documento - EnderecoTransportadora';
                          g_documento_tbl_type(l_seq_documento).EnderecoTransportadora    := SUBSTR(r_docs.Endereco_Transportadora,1,90);
                          l_debug                                                         := 'Documento - BairroTransportadora';
                          g_documento_tbl_type(l_seq_documento).BairroTransportadora      := SUBSTR(r_docs.Bairro_Transportadora,1,25);
                          l_debug                                                         := 'Documento - MunicipioTransportadora';
                          g_documento_tbl_type(l_seq_documento).MunicipioTransportadora   := SUBSTR(r_docs.Municipio_Transportadora,1,25);
                          l_debug                                                         := 'Documento - UFTransportadora';
                          g_documento_tbl_type(l_seq_documento).UFTransportadora          := SUBSTR(r_docs.UF_Transportadora,1,2);
                          l_debug                                                         := 'Documento - CEPTransportadora';
                          g_documento_tbl_type(l_seq_documento).CEPTransportadora         := SUBSTR(r_docs.CEP_Transportadora,1,9);
                          l_debug                                                         := 'Documento - InscricaoTransportadora';
                          g_documento_tbl_type(l_seq_documento).InscricaoTransportadora   := SUBSTR(r_docs.IE_Transportadora,1,20);
                          l_debug                                                         := 'Documento - TipoPessoaTransportadora';
                          g_documento_tbl_type(l_seq_documento).TipoPessoaTransportadora  := SUBSTR(r_docs.Tipo_Transportadora,1,1);
                          l_debug                                                         := 'Documento - CNPJCPFEntrega';
                          g_documento_tbl_type(l_seq_documento).CNPJCPFEntrega            := SUBSTR(r_docs.CNPJ_CPF,1,20);
                          l_debug                                                         := 'Documento - NomeEntrega';
                          g_documento_tbl_type(l_seq_documento).NomeEntrega               := SUBSTR(r_docs.party_name,1,80);
                          l_debug                                                         := 'Documento - EnderecoEntrega';
                          g_documento_tbl_type(l_seq_documento).EnderecoEntrega           := SUBSTR(r_docs.endereco,1,90);
                          l_debug                                                         := 'Documento - BairroEntrega';
                          g_documento_tbl_type(l_seq_documento).BairroEntrega             := SUBSTR(r_docs.bairro,1,25);
                          l_debug                                                         := 'Documento - MunicipioEntrega';
                          g_documento_tbl_type(l_seq_documento).MunicipioEntrega          := SUBSTR(r_docs.city,1,25);
                          l_debug                                                         := 'Documento - UFEntrega';
                          g_documento_tbl_type(l_seq_documento).UFEntrega                 := SUBSTR(r_docs.state,1,2);
                          l_debug                                                         := 'Documento - CEPEntrega';
                          g_documento_tbl_type(l_seq_documento).CEPEntrega                := SUBSTR(r_docs.postal_code,1,9);
                          l_debug                                                         := 'Documento - InscricaoEntrega';
                          g_documento_tbl_type(l_seq_documento).InscricaoEntrega          := SUBSTR(r_docs.IE,1,20);
                          l_debug                                                         := 'Documento - Observacao';
                          g_documento_tbl_type(l_seq_documento).Observacao                := r_docs.source_header_number;
                          l_debug                                                         := 'Documento - Agrupador';
                          g_documento_tbl_type(l_seq_documento).Agrupador                 := TO_CHAR(r_docs.delivery_id)||'-1';
                          l_debug                                                         := 'Documento - DataMovimento';
                          g_documento_tbl_type(l_seq_documento).DataMovimento             := TRUNC(Sysdate);
                          l_debug                                                         := 'Documento - DataPrevisaoDocumento';
                          g_documento_tbl_type(l_seq_documento).DataPrevisaoMovimento     := TRUNC(Sysdate);
                          g_documento_tbl_type(l_seq_documento).Rota                      := Null;
                          g_documento_tbl_type(l_seq_documento).Subrota                   := Null;
                          g_documento_tbl_type(l_seq_documento).InibirFracionamento       := Null;

                       END IF;

                       IF r_docs.Endereco_Doca IS NULL THEN
                          l_msg_data := 'Subinventario '||r_docs.subinventory||' Administrado pelo WMAS.';
                          Raise l_saida;
                       END IF;

                       l_debug                                                                := 'Documento_Detalhe';
                       l_index_detalhe                                                        := l_index_detalhe + 1;
                       l_seq_detalhe                                                          := l_seq_detalhe + 1;
                       g_documentodetalhe_tbl_type(l_index_detalhe).SequenciaDocumento        := l_seq_documento;
                       g_documentodetalhe_tbl_type(l_index_detalhe).SequenciaDetalhe          := l_seq_detalhe;
                       l_debug                                                                := 'Documento_Detalhe - CodigoEmpresa';
                       g_documentodetalhe_tbl_type(l_index_detalhe).CodigoEmpresa             := SUBSTR(r_docs.CNPJ_CPF,1,15);
                       l_debug                                                                := 'Documento_Detalhe - CodigoProduto';
                       g_documentodetalhe_tbl_type(l_index_detalhe).CodigoProduto             := SUBSTR(r_docs.Item_Code,1,25);
                       l_debug                                                                := 'Documento_Detalhe - TipoUC';
                       g_documentodetalhe_tbl_type(l_index_detalhe).TipoUC                    := UPPER(SUBSTR(r_docs.TipoUC,1,5));
                       l_debug                                                                := 'Documento_Detalhe - FatorTipoUC';
                       g_documentodetalhe_tbl_type(l_index_detalhe).FatorTipoUC               := r_docs.FatorTipoUC;
                       l_debug                                                                := 'Documento_Detalhe - ClasseProduto';
                       g_documentodetalhe_tbl_type(l_index_detalhe).ClasseProduto             := r_docs.subinventory;
                       l_debug                                                                := 'Documento_Detalhe - QuantidadeMovimento';
                       g_documentodetalhe_tbl_type(l_index_detalhe).QuantidadeMovimento       := r_docs.primary_quantity;
                       l_debug                                                                := 'Documento_Detalhe - TipoLogistico';
                       g_documentodetalhe_tbl_type(l_index_detalhe).TipoLogistico             := SUBSTR(r_docs.Tipo_Logistico,1,10);
                       l_debug                                                                := 'Documento_Detalhe - DadoLogistico';
                       g_documentodetalhe_tbl_type(l_index_detalhe).DadoLogistico             := r_docs.Lot_Number;
                       l_debug                                                                := 'Documento_Detalhe - ClassificacaoFiscal';
                       g_documentodetalhe_tbl_type(l_index_detalhe).ClassificacaoFiscal       := SUBSTR(r_docs.classificacao_fiscal,1,10);
                       l_debug                                                                := 'Documento_Detalhe - SituacaoTributaria';
                       g_documentodetalhe_tbl_type(l_index_detalhe).SituacaoTributaria        := r_docs.situacao_tributaria;
                       l_debug                                                                := 'Documento_Detalhe - NaturezaOperacao';
                       g_documentodetalhe_tbl_type(l_index_detalhe).NaturezaOperacao          := '0000';
                       l_debug                                                                := 'Documento_Detalhe - DescricaoNaturezaOperacao';
                       g_documentodetalhe_tbl_type(l_index_detalhe).DescricaoNaturezaOperacao := 'SEM VALOR FISCAL';
                       l_debug                                                                := 'Documento_Detalhe - CFOP';
                       g_documentodetalhe_tbl_type(l_index_detalhe).CFOP                      := '0000';
                       l_debug                                                                := 'Documento_Detalhe - OrdemSeparacao';
                       g_documentodetalhe_tbl_type(l_index_detalhe).OrdemSeparacao            := TO_CHAR(r_docs.delivery_id);
                       l_debug                                                                := 'Documento_Detalhe - NumeroPedidoSeparacao';
                       g_documentodetalhe_tbl_type(l_index_detalhe).NumeroPedidoSeparacao     := TO_CHAR(r_docs.delivery_detail_id);
                       l_debug                                                                := 'Documento_Detalhe - DataPedidoSeparacao';
                       g_documentodetalhe_tbl_type(l_index_detalhe).DataPedidoSeparacao       := r_docs.date_scheduled;

                       IF l_grava_embarque_wmas = 'N' THEN

                          BEGIN
                             UPDATE wsh_delivery_details
                               SET seal_code = 'SEPARADO'
                             WHERE delivery_detail_id = r_docs.delivery_detail_id;
                          EXCEPTION
                            WHEN no_data_found THEN
                                 null;
                            WHEN others THEN
                                 null;
                          END;


                       ELSE

                          BEGIN
                           UPDATE wsh_delivery_details
                             SET seal_code = 'SEPARANDO'
                           WHERE delivery_detail_id = r_docs.delivery_detail_id;
                          EXCEPTION
                            WHEN no_data_found THEN
                                 null;
                            WHEN others THEN
                                 null;
                          END;


                       END IF;

                  EXCEPTION
                   WHEN l_saida THEN
                        Fnd_file.put_line(fnd_file.output,'  Embarque: '||r_docs.delivery_id||' - '||l_msg_data);
                   WHEN l_saida_erro1 THEN
                        Raise l_saida_erro;
                   WHEN others THEN
                        l_msg_data := 'Debug: '||l_debug||' - Delivery Id: '||l_delivery_id||' - '||SqlErrm;
                        Raise l_saida_erro;
                  END;

              ELSE

                   l_seq_documento := 0;
                   IF l_janela = 'Y' THEN

                      UPDATE wsh_delivery_details
                       SET seal_code = p_status
                      WHERE delivery_detail_id = r_docs.delivery_detail_id;

                      UPDATE wsh_new_deliveries
                       SET attribute8 = NULL
                      WHERE delivery_id = r_docs.delivery_id;

                      COMMIT;

                   ELSE

                      IF l_add_fmin = 'Y' THEN

                         --Verifica se existe um outro embarque para adicionar este material
                         l_new_delivery := f_add_fmin_to_delivery(r_docs.delivery_detail_id);

                      ELSE

                         l_new_delivery := 0;

                      END IF;

                      Fnd_file.put_line(fnd_file.output,'   Nova Delivery: '||l_new_delivery);
                      IF l_new_delivery = 0 or l_new_delivery = r_docs.delivery_id THEN

                              l_backorder := p_backorder_line(r_docs.move_order_line_id, l_error_msg,'Y');
                              IF l_backorder = 'S' THEN
                                 Fnd_file.put_line(fnd_file.output,'   Backorder realizado, Delivery: '||r_docs.delivery_id||' - Num Ordem: '||r_docs.source_header_number|| ' - Item: '||r_docs.item_code||' - Qtde: '||r_docs.primary_quantity);
                              ELSE
                                 Fnd_file.put_line(fnd_file.output,'   Backorder nao realizado, Delivery: '||r_docs.delivery_id||' - Num Ordem: '||r_docs.source_header_number|| ' - Item: '||r_docs.item_code||' - Qtde: '||r_docs.primary_quantity);
                              END IF;

                              UPDATE wsh_delivery_details
                               SET seal_code = p_status
                              WHERE delivery_detail_id = r_docs.delivery_detail_id;

                              UPDATE wsh_new_deliveries
                               SET attribute8 = NULL
                              WHERE delivery_id = r_docs.delivery_id;

                              IF l_cancelamento = 'Y' and l_backorder = 'S' THEN

                                 Fnd_file.put_line(fnd_file.output,'  Saldo da Ordem: '||f_get_valor_ordem(r_docs.delivery_detail_id));
                                 IF f_get_valor_ordem(r_docs.delivery_detail_id) < l_fat_min THEN
                                    l_status_cancel := f_cancel_sales_lines(r_docs.source_line_id);
                                    l_cancel := l_cancel+1;
                                    l_TabOfCancelDets(l_cancel).v_delivery_detail_id := r_docs.delivery_detail_id;
                                    l_TabOfCancelDets(l_cancel).v_source_line_id := r_docs.source_line_id;
                                    l_TabOfCancelDets(l_cancel).v_item_code := r_docs.item_code;
                                    l_TabOfCancelDets(l_cancel).v_qtde := r_docs.requested_quantity;
                                    l_TabOfCancelDets(l_cancel).v_pedido := r_docs.source_header_number;
                                    l_TabOfCancelDets(l_cancel).v_email := r_docs.email_address;
                                 END IF;

                              END IF;

                              COMMIT;

                      ELSE

                           l_add_item_embarque := f_add_item_embarque(r_docs.delivery_detail_id,l_new_delivery);
                           IF l_add_item_embarque = 'Y' THEN
                              Fnd_file.put_line(fnd_file.output,'    - O Item: '||r_docs.item_code||' do Pedido: '||r_docs.source_header_number||' foi adiconado ao Embarque: '||l_new_delivery||'.');
                              BEGIN
                                UPDATE wsh_delivery_details
                                 SET seal_code = (select seal_code from wsh_deliverables_v where delivery_id = l_new_delivery and delivery_detail_id not in(r_docs.delivery_detail_id) and rownum =1)
                                WHERE delivery_detail_id = r_docs.delivery_detail_id;
                              EXCEPTION
                                WHEN others THEN
                                    null;
                              END;

                                COMMIT;

                           ELSE
                              Fnd_file.put_line(fnd_file.output,'    - Erro ao tentar adicionar O Item: '||r_docs.item_code||' do Pedido: '||r_docs.source_header_number||' ao Embarque: '||l_new_delivery||'.');
                           END IF;


                      END IF;

                   END IF;

              END IF;

           EXCEPTION
               WHEN l_saida THEN
                    Fnd_file.put_line(fnd_file.output,'  Embarque: '||r_docs.delivery_id||' - '||l_msg_data);
                    l_seq_documento := 0;
               WHEN l_saida_erro1 THEN
                    l_seq_documento := 0;
                    Raise l_saida_erro;
               WHEN others THEN
                    l_msg_data := 'Debug: '||l_debug||' - Delivery Id: '||l_delivery_id||' - '||SqlErrm;
                    l_seq_documento := 0;
                    Raise l_saida_erro;
           END;

           COMMIT;

        END LOOP;
        -- Cria Registro into WMAS
        IF l_count > 0 THEN


           l_count := 0;
           BEGIN
             SELECT nvl(count(*),0)
               INTO l_count
             FROM documento
             WHERE NUMERODOCUMENTO = to_char(r_deliveries.delivery_id)
               AND TIPOINTEGRACAO = '203'
               AND CODIGOESTABELECIMENTO = '23';
           EXCEPTION
             WHEN no_data_found THEN
               l_count := 0;
             WHEN others THEN
               l_count := 0;
           END;

           IF l_count = 0 THEN

               IF l_grava_embarque_wmas = 'Y' THEN
                   Xxppg_inv_wmas_pub_pkg.Create_wmas_records ( p_integracao_tbl              => g_integracao_tbl_type
                                                            , p_integracao_hist_tbl         => g_integracao_hist_tbl_type
                                                            , p_documento_tbl               => g_documento_tbl_type
                                                            , p_documento_detalhe_tbl       => g_documentodetalhe_tbl_type
                                                            , p_documento_detalhe_seq_tbl   => g_documentodetalheseq_tbl_type
                                                            , p_movimento_estoque_tbl       => g_movimentoestoque_tbl_type
                                                            , p_produto_tbl                 => g_produto_tbl_type
                                                            , p_TipoUC_tbl                  => g_TipoUC_tbl_type
                                                            , p_SequencialIntegracao        => l_seq_integracao
                                                            , p_return_status               => l_return_status
                                                            , p_msg_data                    => l_msg_data );




                    IF l_return_status = 'E' THEN

                        BEGIN
                           UPDATE wsh_delivery_details
                               SET seal_code = 'ERRO'
                           WHERE delivery_detail_id in(select delivery_detail_id
                                                         from wsh_deliverables_v
                                                        where delivery_id = l_delivery_id
                                                      );
                        EXCEPTION
                          WHEN no_data_found THEN
                               null;
                          WHEN others THEN
                               null;
                        END;

                        Fnd_file.put_line(fnd_file.output,'  PPG Status: '||'ERRO');

                        COMMIT;

                        Raise l_saida_Erro1;

                    ELSE

                        BEGIN
                           UPDATE wsh_new_deliveries
                               SET attribute8 = '203'
                           WHERE delivery_id = l_delivery_id;
                        EXCEPTION
                          WHEN no_data_found THEN
                               null;
                          WHEN others THEN
                               null;
                        END;
                         Fnd_file.put_line(fnd_file.output,'  PPG Status: '||'SEPARADO');

                         Fnd_file.put_line(fnd_file.output, '1 - Sequencial : '||l_seq_integracao||' - Numero Embarque: '||l_delivery_id );

                        COMMIT;

                    END IF;

               ELSE

                  Fnd_file.put_line(fnd_file.output, '1 - Simulacao : Numero Embarque: '||l_delivery_id );

               END IF;

           ELSE

              Fnd_file.put_line(fnd_file.output, 'Embarque ja existe no WMAS! Numero Embarque: '||l_delivery_id );

           END IF;

        END IF;
        --
        IF l_cancelamento = 'Y' THEN

           IF l_envio_email = 'Y' THEN

                   p_to:= null;

                   Fnd_file.put_line(fnd_file.output, 'Qtde Itens cancelados: '||l_TabOfCancelDets.count);
                   IF l_TabOfCancelDets.count > 0 THEN


                      p_to:= nvl(fnd_profile.value('XXPPG_OM_EMAIL_CANCELAMENTO_PEDIDO'),'workflowlapoea@ppg.com;');

                      Fnd_file.put_line(fnd_file.output, 'Pedido: '||l_TabOfCancelDets(1).v_pedido);

                      FOR i IN 1 .. l_TabOfCancelDets.count LOOP

                         FOR R_EMAIL IN C_EMAIL(l_TabOfCancelDets(i).v_source_line_id) LOOP

                             IF I = 1 THEN

                                IF nvl(fnd_profile.value('XXPPG_OM_ENVIAR_EMAIL_CANCEL_CLIENTE'),'N') = 'Y' THEN

                                   IF instr(p_to,r_email.email_cliente,1) = 0 THEN
                                      p_to  := p_to||r_email.email_cliente||';';
                                   END IF;

                                END IF;

                                IF nvl(fnd_profile.value('XXPPG_OM_ENVIAR_EMAIL_CANCEL_REPRESENTANTE'),'N') = 'Y' THEN

                                   IF instr(p_to,r_email.email_address_rep,1) = 0 THEN
                                      p_to      := p_to||l_TabOfCancelDets(i).v_email||';';
                                   END IF;

                                END IF;

                                l_message_cab := 'Cod.Repres ............:  '||r_email.cod_vendedor||chr(13)||
                                                 'Nome Repres: ..........:  '||r_email.vendedor||chr(13)||
                                                 'Pedido Cliente: .......:  '||r_email.pedido_cliente||chr(13)||
                                                 'Pedido Oracle:  .......:  '||r_email.pedido_oracle||chr(13)||
                                                 'Pedido Dynamics: ......:  '||r_email.pedido_dynamics||chr(13)||
                                                 'Data Pedido: ..........:  '||r_email.data_criacao_ordem||chr(13)||
                                                 'Cond Pagto: ...........:  '||r_email.condicao_pgto||chr(13)||
                                                  chr(13)||
                                                 'Nome Cliente: .........:  '||r_email.nome_cliente||chr(13)||
                                                 'CNPJ Cliente: .........:  '||r_email.cnpj||chr(13)||
                                                 'Cidade: ...............:  '||r_email.cidade||chr(13)||
                                                 'Estado: ...............:  '||r_email.estado||chr(13)||
                                                  chr(13);
                             END IF;

                             l_message := 'Item: '||l_TabOfCancelDets(i).v_item_code||'    '||
                                          'Desc: '||r_email.descricao||'    '||
                                          'Qtd.Saldo: '||l_TabOfCancelDets(i).v_Qtde||'    '||
                                          'Vlr.Unit: '||r_email.preco_unitario||'    '||
                                          'Vlr.Total: '||l_TabOfCancelDets(i).v_Qtde * r_email.preco_unitario||'    '||
                                          '     Cancelado por nao atingir o faturamento minimo!';

                             p_message := p_message ||chr(13)||l_message;

                         END LOOP;
                         --Fnd_file.put_line(fnd_file.output, 'Email: '||l_TabOfCancelDets(i).v_email);

                      END LOOP;

                      Fnd_file.put_line(fnd_file.output, 'Email: '||p_to);
                      IF p_to is not null THEN
                          p_from        := 'workflowlapoea@ppg.com';
                          l_subject     := case when fnd_profile.value('APPS_DATABASE_ID') <> 'lapoea' THEN UPPER(fnd_profile.value('APPS_DATABASE_ID'))||' - '  ELSE '' END||'Cancelamento de Saldo de Pedido !';

                          xxppg_send_mail ( errbuf               => p_errbuf,
                                            retcode              => p_retcode,
                                            from_name            => p_from,
                                            p_oracle_directory   => NULL,
                                            p_binary_file        => NULL,
                                            to_name              => p_to,
                                            p_subject            => l_subject,
                                            p_body               => l_message_cab||p_message
                                           );
                         Fnd_file.put_line(fnd_file.output, 'Email Enviado com sucesso!');
                      END IF;

                      l_message := NULL;
                      p_message := NULL;
                      l_subject := NULL;
                      p_to := NULL;


                   END IF;

           END IF;

        END IF;
        --
        Fnd_file.put_line(fnd_file.output,'');
        Fnd_file.put_line(fnd_file.output,'--------------------------------------------------------------------------');

    END LOOP;

    Fnd_file.put_line(fnd_file.output, 'FIM!' );

  EXCEPTION
     WHEN l_saida_erro THEN
          Rollback;
          p_msg_erro := 'Rotina Separacao Materiais - '||l_msg_data;
          Return;
     WHEN others THEN
          Rollback;
          p_msg_erro := 'Erro na rotina Separaca Materiais - Debug: '||l_debug||' - Delivery Id: '||l_delivery_id||' - '||SqlErrm;
          Return;
  END Separacao_Materiais_P_New;

 PROCEDURE Separacao_Materiais_P (p_msg_erro    OUT Varchar2
                                  ,p_delivery_id  IN Number) IS
     CURSOR c_docs IS
        SELECT mp.organization_id
             , mp.attribute7             Cod_Estabelecimento
             , cffe.document_number      CNPJ_Estabelecimento
             , wnd.delivery_id
             , wnd.name   delivery_name
             , wdd.delivery_detail_id
             , wdd.source_line_id
             , wdd.source_header_number
             , NVL(DECODE(hcasa.global_attribute2,'1',hcasa.global_attribute3||hcasa.global_attribute5
                                                     ,SUBSTR(hcasa.global_attribute3,2)||hcasa.global_attribute4||hcasa.global_attribute5)
                        ,'00000000000000')  CNPJ_CPF
             , oola.global_attribute1   CFO
             , jbao.cfo_description
             , wdd.volume_uom_code
             , NVL(wnd.number_of_lpn,0)   volume
             , wnd.gross_weight
             , wnd.net_weight
             , DECODE(wnd.freight_terms_code,NULL,NULL,DECODE(SUBSTR(wnd.freight_terms_code,1,3),'CIF',1,'FOB',2,NULL)) tipo_frete
             , hp.party_name
             , hl.address1||DECODE(hl.address2,Null,Null,',')||
               hl.address2||DECODE(hl.address3,Null,Null,',')||
               hl.address3    endereco
             , hl.address4    bairro
             , hl.city
             , hl.state
             , hl.postal_code
             , hcasa.global_attribute6  IE
             , hcasa.cust_acct_site_id
             , DECODE(hcasa.global_attribute2,'1','F','J')  Tipo_Empresa
             , msib.segment1          item_code
             , msib.inventory_item_id
             , msi.Attribute2                 Endereco_Doca
             , msi.secondary_inventory_name   Subinventory
             , wdd.requested_quantity
             , trl.line_id
             , NVL(mtlt.primary_quantity, trl.primary_quantity)   primary_quantity
             , trl.pick_slip_number
             , wdd.date_scheduled
             , DECODE(mtlt.lot_number, NULL,NULL, '3') Tipo_Logistico
             , mtlt.lot_number
             , oola.global_attribute5     classificacao_fiscal
             , oola.global_attribute10    situacao_tributaria
             , asu.vendor_name            Nome_Transportadora
             , asu.segment1               Codigo_Transportadora
             , DECODE(assa.global_attribute9,'1',assa.global_attribute10||assa.global_attribute12
                                                ,SUBSTR(assa.global_attribute10,2)||assa.global_attribute11||assa.global_attribute12)  CNPJ_Transportadora
             , assa.address_line1||DECODE(assa.address_line2,Null,Null,',')||
               assa.address_line2||DECODE(assa.address_line3,Null,Null,',')||
               assa.address_line3         Endereco_Transportadora
             , assa.address_line4         Bairro_Transportadora
             , assa.city                  Municipio_Transportadora
             , assa.state                 UF_Transportadora
             , assa.zip                   CEP_Transportadora
             , assa.global_attribute13    IE_Transportadora
             , DECODE(assa.global_attribute9,NULL,NULL,DECODE(assa.global_attribute9,'1','F','J'))   Tipo_Transportadora
             , msib.primary_uom_code           TipoUC
             , 1                               FatorTipoUC
          FROM org_access_v                     oav
             , wsh_new_deliveries               wnd
             , wsh_deliverables_v               wdd
             , mtl_txn_request_lines            trl
             , mtl_transaction_lots_temp        mtlt
             , mtl_material_transactions_temp   mtt
             , mtl_secondary_inventories        msi
             , mtl_parameters                   mp
             , hr_all_organization_units        haou
             , cll_f189_fiscal_entities_all     cffe
             , hz_cust_site_uses_all            hcsua
             , hz_cust_acct_sites_all           hcasa
             , hz_cust_accounts                 hca
             , hz_party_sites                   hps
             , hz_locations                     hl
             , hz_parties                       hp
             , oe_order_lines_all               oola
             , jl_br_ap_operations              jbao
             , mtl_system_items_b               msib
             , wsh_carriers                     wc
             , ap_suppliers                     asu
             , ap_supplier_sites_all            assa
         WHERE oav.organization_id             = wdd.organization_id
           AND oav.resp_application_id         = Fnd_Profile.Value('RESP_APPL_ID')
           AND oav.responsibility_id           = Fnd_Profile.Value('RESP_ID')
           AND wnd.delivery_id                 = NVL(p_delivery_id, wnd.delivery_id)
           AND wnd.delivery_id                 = wdd.delivery_id
           AND trl.txn_source_line_detail_id   = wdd.delivery_detail_id
           AND trl.line_status                IN (3,7)
           AND trl.quantity_delivered         IS NULL
           AND trl.line_id                     = mtt.move_order_line_id(+)
           AND trl.txn_source_line_id          = mtt.trx_source_line_id(+)
           AND mtt.transaction_temp_id         = mtlt.transaction_temp_id(+)
           AND mp.organization_id              = wdd.organization_id
           AND wdd.org_id                      = Fnd_Profile.Value('ORG_ID')
           AND haou.organization_id            = mp.organization_id
           AND cffe.location_id                = haou.location_id
           AND cffe.entity_type_lookup_code    = 'LOCATION'
           AND trl.from_subinventory_code      = msi.secondary_inventory_name(+)
           AND trl.organization_id             = msi.organization_id(+)
           AND NVL(wnd.attribute8,'0')         = '0'
           AND hcsua.site_use_id               = wdd.ship_to_site_use_id
           AND hcasa.cust_acct_site_id         = hcsua.cust_acct_site_id
           AND hca.cust_account_id             = hcasa.cust_account_id
           AND hp.party_id                     = hca.party_id
           AND hps.party_site_id               = hcasa.party_site_id
           AND hl.location_id                  = hps.location_id
           AND oola.line_id                    = wdd.source_line_id
           AND jbao.cfo_code(+)                = oola.global_attribute1
           AND msib.inventory_item_id          = wdd.inventory_item_id
           AND msib.organization_id            = wdd.organization_id
           AND wc.carrier_id(+)                = wdd.carrier_id
           AND asu.vendor_id(+)                = wc.supplier_id
           AND assa.vendor_site_id(+)          = wc.supplier_site_id
           AND ( (
                  ---- para embarques planejados ---
                  wdd.shipment_priority_code in ( SELECT flv1.lookup_code
                                                    FROM fnd_lookup_values_vl flv1
                                                   WHERE flv1.lookup_type = 'SHIPMENT_PRIORITY'
                                                     AND NVL(flv1.attribute2 , 'N') = 'Y'
                                                     AND NVL(flv1.attribute3 , 'N') = 'Y'
                                                     AND NVL(flv1.attribute4 , 'N') = 'Y')
                  AND wdd.seal_code IN ( SELECT flv4.lookup_code
                                           FROM fnd_lookup_values_vl  flv4
                                          WHERE flv4.lookup_type = 'PPG - STATUS EMBARQUE'
                                            AND flv4.tag = 'OUT' )
                 ) OR
                 (
                  ---- para embarques manuais ---
                  wdd.shipment_priority_code IN ( SELECT flv2.lookup_code
                                                    FROM fnd_lookup_values_vl flv2
                                                   WHERE flv2.lookup_type = 'SHIPMENT_PRIORITY'
                                                     AND nvl(flv2.attribute2 , 'N') = 'N'
                                                     AND nvl(flv2.attribute3 , 'N') = 'Y'
                                                     AND nvl(flv2.attribute4 , 'N') = 'Y' )
                  AND NVL(wdd.seal_code,'0') NOT IN (SELECT flv3.lookup_code
                                                       FROM fnd_lookup_values_vl flv3
                                                      WHERE flv3.lookup_type = 'PPG - STATUS EMBARQUE'
                                                        AND flv3.tag = 'WORK')
                 )
               )
        ORDER BY wnd.delivery_id, wdd.source_header_id, wdd.source_line_id, wdd.delivery_detail_id;

    l_debug                  Varchar2(1000);
    l_seq_integracao         Number;
    l_seq_documento          Number := 0;
    l_seq_detalhe            Number := 0;
    l_index_detalhe          Number := 0;
    l_return_status          Varchar2(1);
    l_msg_data               Varchar2(32000);
    l_delivery_id            wsh_new_deliveries.delivery_id%TYPE;
    l_delivery_id_ant        wsh_new_deliveries.delivery_id%TYPE := 0;
    l_delivery_name          wsh_new_deliveries.name%TYPE;
    l_saida                  Exception;
    l_saida_erro             Exception;
    l_saida_erro1            Exception;

  BEGIN

    fnd_file.put_line(fnd_file.output, '****************************************************************************** ');
    fnd_file.put_line(fnd_file.output, 'Disparando Integra? da Separa? de Materiais                                ');
    fnd_file.put_line(fnd_file.output, '****************************************************************************** ');

    FOR r_docs IN c_docs LOOP
        BEGIN
           l_delivery_id := r_docs.delivery_id;

           IF l_delivery_id_ant <> r_docs.delivery_id THEN

              IF l_delivery_id_ant <> 0 AND l_msg_data IS NULL THEN
                 -- Cria registros da delivery anterior
                 Xxppg_inv_wmas_pub_pkg.Create_wmas_records ( p_integracao_tbl              => g_integracao_tbl_type
                                                            , p_integracao_hist_tbl         => g_integracao_hist_tbl_type
                                                            , p_documento_tbl               => g_documento_tbl_type
                                                            , p_documento_detalhe_tbl       => g_documentodetalhe_tbl_type
                                                            , p_documento_detalhe_seq_tbl   => g_documentodetalheseq_tbl_type
                                                            , p_movimento_estoque_tbl       => g_movimentoestoque_tbl_type
                                                            , p_produto_tbl                 => g_produto_tbl_type
                                                            , p_TipoUC_tbl                  => g_TipoUC_tbl_type
                                                            , p_SequencialIntegracao        => l_seq_integracao
                                                            , p_return_status               => l_return_status
                                                            , p_msg_data                    => l_msg_data );

                 IF l_return_status = 'E' THEN
                    Raise l_saida_Erro1;
                 ELSE
                    Fnd_file.put_line(fnd_file.output, 'Sequencial : '||l_seq_integracao||' - N?mero Embarque: '||l_delivery_id_ant );
                    COMMIT;
                 END IF;

              END IF;

              g_integracao_tbl_type.delete;
              g_integracao_hist_tbl_type.delete;
              g_documento_tbl_type.delete;
              g_documentodetalhe_tbl_type.delete;
              g_movimentoestoque_tbl_type.delete;
              g_produto_tbl_type.delete;
              g_TipoUC_tbl_type.delete;
              l_msg_data := Null;

              -- Gravando Integracao
              l_debug := 'Integracao';
              g_integracao_tbl_type(1).TipoIntegracao                         := 203;
              g_integracao_tbl_type(1).EstadoIntegracao                       := 1;
              g_integracao_tbl_type(1).SequenciaRelacionada                   := r_docs.delivery_id;

              -- Gravando Documento
              l_debug                                                         := 'Documento';
              l_seq_documento                                                 := 1;
              l_seq_detalhe                                                   := 0;
              l_index_detalhe                                                 := 0;
              l_delivery_id_ant                                               := r_docs.delivery_id;
              l_delivery_name                                                 := r_docs.delivery_name;
              g_documento_tbl_type(l_seq_documento).SequenciaDocumento        := l_seq_documento;
              l_debug                                                         := 'Documento - CodigoEstabelecimento';
              g_documento_tbl_type(l_seq_documento).CodigoEstabelecimento     := r_docs.Cod_Estabelecimento;
              l_debug                                                         := 'Documento - CodigoDepositante';
              g_documento_tbl_type(l_seq_documento).CodigoDepositante         := r_docs.Cod_Estabelecimento;
              l_debug                                                         := 'Documento - CNPJCPFDepositante';
              g_documento_tbl_type(l_seq_documento).CNPJCPFDepositante        := SUBSTR(r_docs.CNPJ_Estabelecimento,1,20);
              l_debug                                                         := 'Documento - TipoDocumento';
              g_documento_tbl_type(l_seq_documento).TipoDocumento             := 'EMB';
              l_debug                                                         := 'Documento - SerieDocumento';
              g_documento_tbl_type(l_seq_documento).SerieDocumento            := '1';
              l_debug                                                         := 'Documento - NumeroDocumento';
              g_documento_tbl_type(l_seq_documento).NumeroDocumento           := r_docs.delivery_id;
              l_debug                                                         := 'Documento - ModeloDocumento';
              g_documento_tbl_type(l_seq_documento).ModeloDocumento           := 'EMB';
              l_debug                                                         := 'Documento - CodigoEmpresa';
              g_documento_tbl_type(l_seq_documento).CodigoEmpresa             := SUBSTR(r_docs.CNPJ_CPF,1,15);
              l_debug                                                         := 'Documento - CodigoEntrega';
              g_documento_tbl_type(l_seq_documento).CodigoEntrega             := SUBSTR(r_docs.CNPJ_CPF,1,15);
              l_debug                                                         := 'Documento - NaturezaOperacao';
              g_documento_tbl_type(l_seq_documento).NaturezaOperacao          := '0000';
              l_debug                                                         := 'Documento - DescricaoNaturezaOperacao';
              g_documento_tbl_type(l_seq_documento).DescricaoNaturezaOperacao := 'SEM VALOR FISCAL';
              l_debug                                                         := 'Documento - CFOP';
              g_documento_tbl_type(l_seq_documento).CFOP                      := '0000';
              l_debug                                                         := 'Documento - DataEmissao';
              g_documento_tbl_type(l_seq_documento).DataEmissao               := TRUNC(Sysdate);
              l_debug                                                         := 'Documento - EspecieVolume';
              g_documento_tbl_type(l_seq_documento).EspecieVolume             := SUBSTR(r_docs.volume_uom_code,1,40);
              l_debug                                                         := 'Documento - QuantidadeVolume';
              g_documento_tbl_type(l_seq_documento).QuantidadeVolume          := r_docs.volume;
              l_debug                                                         := 'Documento - PesoBruto';
              g_documento_tbl_type(l_seq_documento).PesoBruto                 := r_docs.gross_weight;
              l_debug                                                         := 'Documento - PesoLiquido';
              g_documento_tbl_type(l_seq_documento).PesoLiquido               := r_docs.net_weight;
              l_debug                                                         := 'Documento - TipoFrete';
              g_documento_tbl_type(l_seq_documento).TipoFrete                 := r_docs.tipo_frete;
              l_debug                                                         := 'Documento - CNPJCPFEmpresa';
              g_documento_tbl_type(l_seq_documento).CNPJCPFEmpresa            := SUBSTR(r_docs.CNPJ_CPF,1,20);
              l_debug                                                         := 'Documento - NomeEmpresa';
              g_documento_tbl_type(l_seq_documento).NomeEmpresa               := SUBSTR(r_docs.party_name,1,80);
              l_debug                                                         := 'Documento - EnderecoEmpresa';
              g_documento_tbl_type(l_seq_documento).EnderecoEmpresa           := SUBSTR(r_docs.endereco,1,90);
              l_debug                                                         := 'Documento - BairroEmpresa';
              g_documento_tbl_type(l_seq_documento).BairroEmpresa             := SUBSTR(r_docs.bairro,1,25);
              l_debug                                                         := 'Documento - MunicipioEmpresa';
              g_documento_tbl_type(l_seq_documento).MunicipioEmpresa          := SUBSTR(r_docs.city,1,25);
              l_debug                                                         := 'Documento - UFEmpresa';
              g_documento_tbl_type(l_seq_documento).UFEmpresa                 := SUBSTR(r_docs.state,1,2);
              l_debug                                                         := 'Documento - CEPEmpresa';
              g_documento_tbl_type(l_seq_documento).CEPEmpresa                := SUBSTR(r_docs.postal_code,1,9);
              l_debug                                                         := 'Documento - InscricaoEmpresa';
              g_documento_tbl_type(l_seq_documento).InscricaoEmpresa          := SUBSTR(r_docs.IE,1,20);
              l_debug                                                         := 'Documento - TipoPessoaEmpresa';
              g_documento_tbl_type(l_seq_documento).TipoPessoaEmpresa         := SUBSTR(r_docs.Tipo_Empresa,1,1);
              l_debug                                                         := 'Documento - CNPJCPFTransportadora';
              g_documento_tbl_type(l_seq_documento).CNPJCPFTransportadora     := SUBSTR(r_docs.CNPJ_Transportadora,1,20);
              l_debug                                                         := 'Documento - CodigoTransportadora';
              g_documento_tbl_type(l_seq_documento).CodigoTransportadora      := r_docs.Codigo_Transportadora;
              l_debug                                                         := 'Documento - NomeTransportadora';
              g_documento_tbl_type(l_seq_documento).NomeTransportadora        := SUBSTR(r_docs.Nome_Transportadora,1,80);
              l_debug                                                         := 'Documento - EnderecoTransportadora';
              g_documento_tbl_type(l_seq_documento).EnderecoTransportadora    := SUBSTR(r_docs.Endereco_Transportadora,1,90);
              l_debug                                                         := 'Documento - BairroTransportadora';
              g_documento_tbl_type(l_seq_documento).BairroTransportadora      := SUBSTR(r_docs.Bairro_Transportadora,1,25);
              l_debug                                                         := 'Documento - MunicipioTransportadora';
              g_documento_tbl_type(l_seq_documento).MunicipioTransportadora   := SUBSTR(r_docs.Municipio_Transportadora,1,25);
              l_debug                                                         := 'Documento - UFTransportadora';
              g_documento_tbl_type(l_seq_documento).UFTransportadora          := SUBSTR(r_docs.UF_Transportadora,1,2);
              l_debug                                                         := 'Documento - CEPTransportadora';
              g_documento_tbl_type(l_seq_documento).CEPTransportadora         := SUBSTR(r_docs.CEP_Transportadora,1,9);
              l_debug                                                         := 'Documento - InscricaoTransportadora';
              g_documento_tbl_type(l_seq_documento).InscricaoTransportadora   := SUBSTR(r_docs.IE_Transportadora,1,20);
              l_debug                                                         := 'Documento - TipoPessoaTransportadora';
              g_documento_tbl_type(l_seq_documento).TipoPessoaTransportadora  := SUBSTR(r_docs.Tipo_Transportadora,1,1);
              l_debug                                                         := 'Documento - CNPJCPFEntrega';
              g_documento_tbl_type(l_seq_documento).CNPJCPFEntrega            := SUBSTR(r_docs.CNPJ_CPF,1,20);
              l_debug                                                         := 'Documento - NomeEntrega';
              g_documento_tbl_type(l_seq_documento).NomeEntrega               := SUBSTR(r_docs.party_name,1,80);
              l_debug                                                         := 'Documento - EnderecoEntrega';
              g_documento_tbl_type(l_seq_documento).EnderecoEntrega           := SUBSTR(r_docs.endereco,1,90);
              l_debug                                                         := 'Documento - BairroEntrega';
              g_documento_tbl_type(l_seq_documento).BairroEntrega             := SUBSTR(r_docs.bairro,1,25);
              l_debug                                                         := 'Documento - MunicipioEntrega';
              g_documento_tbl_type(l_seq_documento).MunicipioEntrega          := SUBSTR(r_docs.city,1,25);
              l_debug                                                         := 'Documento - UFEntrega';
              g_documento_tbl_type(l_seq_documento).UFEntrega                 := SUBSTR(r_docs.state,1,2);
              l_debug                                                         := 'Documento - CEPEntrega';
              g_documento_tbl_type(l_seq_documento).CEPEntrega                := SUBSTR(r_docs.postal_code,1,9);
              l_debug                                                         := 'Documento - InscricaoEntrega';
              g_documento_tbl_type(l_seq_documento).InscricaoEntrega          := SUBSTR(r_docs.IE,1,20);
              l_debug                                                         := 'Documento - Observacao';
              g_documento_tbl_type(l_seq_documento).Observacao                := r_docs.source_header_number;
              l_debug                                                         := 'Documento - Agrupador';
              g_documento_tbl_type(l_seq_documento).Agrupador                 := TO_CHAR(r_docs.delivery_id)||'-1';
              l_debug                                                         := 'Documento - DataMovimento';
              g_documento_tbl_type(l_seq_documento).DataMovimento             := TRUNC(Sysdate);
              l_debug                                                         := 'Documento - DataPrevisaoDocumento';
              g_documento_tbl_type(l_seq_documento).DataPrevisaoMovimento     := TRUNC(Sysdate);
              g_documento_tbl_type(l_seq_documento).Rota                      := Null;
              g_documento_tbl_type(l_seq_documento).Subrota                   := Null;
              g_documento_tbl_type(l_seq_documento).InibirFracionamento       := Null;

           END IF;

           IF r_docs.Endereco_Doca IS NULL THEN
              l_msg_data := 'Subinvent?o '||r_docs.subinventory||' n??dministrado pelo WMAS.';
              Raise l_saida;
           END IF;

           l_debug                                                                := 'Documento_Detalhe';
           l_index_detalhe                                                        := l_index_detalhe + 1;
           l_seq_detalhe                                                          := l_seq_detalhe + 1;
           g_documentodetalhe_tbl_type(l_index_detalhe).SequenciaDocumento        := l_seq_documento;
           g_documentodetalhe_tbl_type(l_index_detalhe).SequenciaDetalhe          := l_seq_detalhe;
           l_debug                                                                := 'Documento_Detalhe - CodigoEmpresa';
           g_documentodetalhe_tbl_type(l_index_detalhe).CodigoEmpresa             := SUBSTR(r_docs.CNPJ_CPF,1,15);
           l_debug                                                                := 'Documento_Detalhe - CodigoProduto';
           g_documentodetalhe_tbl_type(l_index_detalhe).CodigoProduto             := SUBSTR(r_docs.Item_Code,1,25);
           l_debug                                                                := 'Documento_Detalhe - TipoUC';
           g_documentodetalhe_tbl_type(l_index_detalhe).TipoUC                    := UPPER(SUBSTR(r_docs.TipoUC,1,5));
           l_debug                                                                := 'Documento_Detalhe - FatorTipoUC';
           g_documentodetalhe_tbl_type(l_index_detalhe).FatorTipoUC               := r_docs.FatorTipoUC;
           l_debug                                                                := 'Documento_Detalhe - ClasseProduto';
           g_documentodetalhe_tbl_type(l_index_detalhe).ClasseProduto             := r_docs.subinventory;
           l_debug                                                                := 'Documento_Detalhe - QuantidadeMovimento';
           g_documentodetalhe_tbl_type(l_index_detalhe).QuantidadeMovimento       := r_docs.primary_quantity;
           l_debug                                                                := 'Documento_Detalhe - TipoLogistico';
           g_documentodetalhe_tbl_type(l_index_detalhe).TipoLogistico             := SUBSTR(r_docs.Tipo_Logistico,1,10);
           l_debug                                                                := 'Documento_Detalhe - DadoLogistico';
           g_documentodetalhe_tbl_type(l_index_detalhe).DadoLogistico             := r_docs.Lot_Number;
           l_debug                                                                := 'Documento_Detalhe - ClassificacaoFiscal';
           g_documentodetalhe_tbl_type(l_index_detalhe).ClassificacaoFiscal       := SUBSTR(r_docs.classificacao_fiscal,1,10);
           l_debug                                                                := 'Documento_Detalhe - SituacaoTributaria';
           g_documentodetalhe_tbl_type(l_index_detalhe).SituacaoTributaria        := r_docs.situacao_tributaria;
           l_debug                                                                := 'Documento_Detalhe - NaturezaOperacao';
           g_documentodetalhe_tbl_type(l_index_detalhe).NaturezaOperacao          := '0000';
           l_debug                                                                := 'Documento_Detalhe - DescricaoNaturezaOperacao';
           g_documentodetalhe_tbl_type(l_index_detalhe).DescricaoNaturezaOperacao := 'SEM VALOR FISCAL';
           l_debug                                                                := 'Documento_Detalhe - CFOP';
           g_documentodetalhe_tbl_type(l_index_detalhe).CFOP                      := '0000';
           l_debug                                                                := 'Documento_Detalhe - OrdemSeparacao';
           g_documentodetalhe_tbl_type(l_index_detalhe).OrdemSeparacao            := TO_CHAR(r_docs.delivery_id);
           l_debug                                                                := 'Documento_Detalhe - NumeroPedidoSeparacao';
           g_documentodetalhe_tbl_type(l_index_detalhe).NumeroPedidoSeparacao     := TO_CHAR(r_docs.delivery_detail_id);
           l_debug                                                                := 'Documento_Detalhe - DataPedidoSeparacao';
           g_documentodetalhe_tbl_type(l_index_detalhe).DataPedidoSeparacao       := r_docs.date_scheduled;

           UPDATE wsh_delivery_details
              SET seal_code = 'SEPARANDO'
            WHERE delivery_detail_id = r_docs.delivery_detail_id;

           UPDATE wsh_new_deliveries
              SET attribute8 = '203'
            WHERE delivery_id = r_docs.delivery_id;

        EXCEPTION
           WHEN l_saida THEN
                Fnd_file.put_line(fnd_file.output,'Embarque: '||r_docs.delivery_id||' - '||l_msg_data);
           WHEN l_saida_erro1 THEN
                Raise l_saida_erro;
           WHEN others THEN
                l_msg_data := 'Debug: '||l_debug||' - Delivery Id: '||l_delivery_id||' - '||SqlErrm;
                Raise l_saida_erro;
        END;
    END LOOP;

    -- Gera registros da ultima delivery processada
    IF l_seq_documento > 0 AND l_msg_data IS NULL THEN
       Xxppg_inv_wmas_pub_pkg.Create_wmas_records ( p_integracao_tbl              => g_integracao_tbl_type
                                                  , p_integracao_hist_tbl         => g_integracao_hist_tbl_type
                                                  , p_documento_tbl               => g_documento_tbl_type
                                                  , p_documento_detalhe_tbl       => g_documentodetalhe_tbl_type
                                                  , p_documento_detalhe_seq_tbl   => g_documentodetalheseq_tbl_type
                                                  , p_movimento_estoque_tbl       => g_movimentoestoque_tbl_type
                                                  , p_produto_tbl                 => g_produto_tbl_type
                                                  , p_TipoUC_tbl                  => g_TipoUC_tbl_type
                                                  , p_SequencialIntegracao        => l_seq_integracao
                                                  , p_return_status               => l_return_status
                                                  , p_msg_data                    => l_msg_data );

       IF l_return_status = 'E' THEN
          ROLLBACK;
          Raise l_saida_Erro;
       ELSE
          Fnd_file.put_line(fnd_file.output, 'Sequencial : '||l_seq_integracao||' - N?mero Embarque: '||l_delivery_id_ant );
          COMMIT;
       END IF;

    END IF;

  EXCEPTION
     WHEN l_saida_erro THEN
          Rollback;
          p_msg_erro := 'Rotina Separacao Materiais - '||l_msg_data;
          Return;
     WHEN others THEN
          Rollback;
          p_msg_erro := 'Erro na rotina Separacao Materiais - Debug: '||l_debug||' - Delivery Id: '||l_delivery_id||' - '||SqlErrm;
          Return;
  END Separacao_Materiais_P;

  --  +=====================================================================+
  --  | DESCRIPTION                                                         |
  --  |    Gap 81.5 - Integra? Confirma? de Embarque - Inbound          |
  --  |                                                                     |
  --  | HISTORY                                                             |
  --  |    11-Jun-2014     Renato Furlan    Cria? da rotina.              |
  --  |                                                                     |
  --  +=====================================================================+
  PROCEDURE Confirma_Entrega_P ( p_delivery_id   In Number
                               , p_msg_erro     Out Varchar2
                               , p_retcode      Out Number  ) IS
     CURSOR c_deliv (pc_org_id  In Number) IS
       SELECT wnd.delivery_id
            , wnd.name   delivery_name
            , wnd.organization_id
            , mp.organization_code
            , wmas.SequenciaIntegracao
         FROM wsh_new_deliveries            wnd
            , mtl_parameters                mp
            , org_organization_definitions  ood
            , ( SELECT int.SequenciaIntegracao
                     , doc.numerodocumento
                  FROM integracao          int
                     , documento           doc
                 WHERE int.TipoIntegracao       = 252
                   AND int.estadointegracao     = 1
                   AND doc.tipodocumento        = 'EMB'
                   AND doc.sequenciaintegracao  = int.sequenciaintegracao
                 UNION ALL
                 SELECT int.SequenciaIntegracao
                      , doc.numerodocumento
                  FROM integracao          int
                     , documento           doc
                 WHERE int.TipoIntegracao       = 252
                   AND int.estadointegracao     = 3
                   AND doc.tipodocumento        = 'EMB'
                   AND doc.sequenciaintegracao  = int.sequenciaintegracao
              ) wmas
        WHERE wnd.delivery_id     = NVL(p_delivery_id, wnd.delivery_id)
          AND wnd.status_code     = 'OP'
          AND wnd.attribute8      = '203'
          AND wnd.delivery_id     = TO_NUMBER(wmas.numerodocumento)
          AND mp.organization_id  = wnd.organization_id
          AND ood.organization_id = mp.organization_id
          AND ood.operating_unit  = pc_org_id;

     CURSOR c_lines (pc_delivery_id    In Number
                    ,pc_seqintegracao  In Number) IS
       SELECT wdd.delivery_detail_id
            , wdd.ship_method_code
            , wdd.org_id
            , wdd.organization_id
            , wdd.source_header_id
            , wdd.source_line_id
            , trl.primary_quantity
            , trl.quantity
            , trl.uom_code
            , trl.line_number
            , trl.from_locator_id
            , trl.to_account_id
            , trl.txn_source_line_id
            , trl.txn_source_id
            , wdd.inventory_item_id
            , NVL(mmtt.subinventory_code, wdd.subinventory) Subinventory
            , wdd.move_order_line_id
            , trh.move_order_type
            , trh.header_id  move_order_header_id
            , trh.request_number
            , trl.revision
            , mmtt.reservation_id
            , mmtt.transaction_temp_id
            , (trl.secondary_quantity / trl.primary_quantity)  fator_conv_sec
         FROM wsh_deliverables_v              wdd
            , mtl_txn_request_lines           trl
            , mtl_txn_request_headers         trh
            , mtl_material_transactions_temp  mmtt
        WHERE wdd.delivery_id                = pc_delivery_id
          AND trl.txn_source_line_detail_id  = wdd.delivery_detail_id
          AND trl.line_status               IN (3,7)
          AND trl.quantity_delivered        IS NULL
          AND trh.header_id                  = trl.header_id
          AND mmtt.move_order_line_id (+)    = trl.line_id
        ORDER BY wdd.delivery_detail_id, trl.line_id, mmtt.transaction_temp_id;

     CURSOR c_DocDet (pc_delivery_id          In Number
                     ,pc_delivery_detail_id   In Number
                     ,pc_seqintegracao        In Number
                     ,pc_transaction_temp_id  In Number) IS
       SELECT dd.DadoLogistico                Lot_Number
            , mtlt.primary_quantity
            , NVL(dd.QuantidadeMovimento,0)   QuantidadeMovimento
         FROM documentodetalhe             dd
            , mtl_transaction_lots_temp    mtlt
        WHERE dd.sequenciaintegracao      = pc_seqintegracao
          AND dd.OrdemSeparacao           = TO_CHAR(pc_delivery_id)
          AND dd.NumeroPedidoSeparacao    = TO_CHAR(pc_delivery_detail_id)
          AND mtlt.transaction_temp_id(+) = pc_transaction_temp_id
          AND mtlt.lot_number(+)          = dd.DadoLogistico
        ORDER BY dd.SequenciaDetalhe;

     l_msg_return               Varchar2(32000);
     l_delivery_id              wsh_new_deliveries.delivery_id%TYPE;
     l_sequenciaIntegracao      Number;
     l_subinventory_transf      mtl_secondary_inventories.secondary_inventory_name%TYPE;
     l_dif_qtde                 Number;
     l_qtde_atendida            Number;
     l_saida                    Exception;
     l_debug                    Number;

     l_line_index               Number := 0;
     l_hdr_rec                  inv_move_order_pub.trohdr_rec_type       := inv_move_order_pub.g_miss_trohdr_rec;
     l_line_tbl                 inv_move_order_pub.trolin_tbl_type       := inv_move_order_pub.g_miss_trolin_tbl;
     x_hdr_rec                  inv_move_order_pub.trohdr_rec_type       := inv_move_order_pub.g_miss_trohdr_rec;
     x_hdr_val_rec              inv_move_order_pub.trohdr_val_rec_type;
     x_line_tbl                 inv_move_order_pub.trolin_tbl_type;
     l_trolin_out_tbl           INV_Move_Order_PUB.Trolin_Tbl_Type;
     x_line_val_tbl             inv_move_order_pub.trolin_val_tbl_type;
     v_msg_index_out            NUMBER;

     ----------------- ALLOCATE MOVE ORDER API REQUIREMENTS -------------------------
     l_api_version              NUMBER       := 1.0;
     l_init_msg_list            VARCHAR2 (2) := fnd_api.g_true;
     l_return_values            VARCHAR2 (2) := fnd_api.g_false;
     l_commit                   VARCHAR2 (2) := fnd_api.g_false;
     x_return_status            VARCHAR2 (2);
     x_msg_count                NUMBER       := 0;
     x_msg_data                 VARCHAR2 (255);
     l_trolin_tbl               inv_move_order_pub.trolin_tbl_type;
     l_trolin_old_tbl           inv_move_order_pub.trolin_tbl_type;
     l_trolin_val_tbl           inv_move_order_pub.trolin_val_tbl_type;
     x_trolin_tbl               inv_move_order_pub.trolin_tbl_type;
     x_trolin_val_tbl           inv_move_order_pub.trolin_val_tbl_type;
     x_detailed_quantity        NUMBER ;
     x_number_of_rows           NUMBER ;
     x_transfer_to_location     NUMBER ;
     x_revision                 VARCHAR2(100);
     x_locator_id               NUMBER;
     x_lot_number               VARCHAR2(150);
     x_expiration_date          DATE;
     x_transaction_temp_id      NUMBER ;
     l_txn_lines                mtl_txn_request_lines%ROWTYPE;

     ----------------- TRANSACT MOVE ORDER API REQUIREMENTS -------------------------
     a_l_api_version               NUMBER       := 1.0;
     a_l_init_msg_list             VARCHAR2 (2) := fnd_api.g_true;
     a_l_commit                    VARCHAR2 (2) := fnd_api.g_false;
     a_x_return_status             VARCHAR2 (2);
     a_x_msg_count                 NUMBER := 0;
     a_x_msg_data                  VARCHAR2 (255);
     a_l_move_order_type           NUMBER := 3;
     a_l_transaction_mode          NUMBER := 1;
     a_l_trolin_tbl                inv_move_order_pub.trolin_tbl_type;
     a_l_mold_tbl                  inv_mo_line_detail_util.g_mmtt_tbl_type;
     a_x_mmtt_tbl                  inv_mo_line_detail_util.g_mmtt_tbl_type;
     a_x_trolin_tbl                inv_move_order_pub.trolin_tbl_type;
     a_l_transaction_date          DATE := SYSDATE;
     v_transaction_date            DATE;

     ----------------- RESERVATION DELETE API REQUIREMENTS -------------------------
     l_to_rsv_rec                  inv_reservation_global.mtl_reservation_rec_type;
     l_to_serial_number            inv_reservation_global.serial_number_tbl_type;

     l_return_status            Varchar2(10);
     l_msg_count                Number;
     l_msg_data                 Varchar2(32000);
     l_msg_details              Varchar2(32000);
     l_msg_summary              Varchar2(32000);
     l_org_id                   Number;

  BEGIN
    l_debug  := 1;
    l_org_id := Fnd_Profile.Value('ORG_ID');

    fnd_file.put_line(fnd_file.output, '****************************************************************************** ');
    fnd_file.put_line(fnd_file.output, 'Disparando Integra? da Confirma? de Embarque                               ');
    fnd_file.put_line(fnd_file.output, '****************************************************************************** ');

    FOR r_deliv in c_deliv(l_org_id) LOOP

        BEGIN
           l_debug               := 2;
           l_delivery_id         := r_deliv.delivery_id;
           l_sequenciaIntegracao := r_deliv.sequenciaintegracao;
           l_line_index          := 0;
           l_hdr_rec             := Null;
           l_line_tbl.delete;

           -- Recupera subinvent?o de transferencia conforme organiza?
           BEGIN
              SELECT flv.description
                INTO l_subinventory_transf
                FROM fnd_lookup_values_vl  flv
               WHERE flv.lookup_type         = 'PPG_WSH_INV_SUB_INVENT_DIFEREN'
                 AND flv.lookup_code         = r_deliv.organization_code
                 AND flv.view_application_id = 665;
           EXCEPTION
                WHEN no_data_found THEN
                     l_msg_return := 'Subinvent?o de transfer?ia n?configurado para a organiza? '||r_deliv.organization_code||' na lookup PPG_WSH_INV_SUB_INVENT_DIFEREN.';
                     Raise l_saida;
           END;

           -- Checa se o subinvent?o de transfer?ia est?adastrado na organiza?
           BEGIN
              SELECT msi.secondary_inventory_name
                INTO l_subinventory_transf
                FROM mtl_secondary_inventories  msi
               WHERE msi.secondary_inventory_name = l_subinventory_transf
                 AND msi.organization_id          = r_deliv.organization_id
                 AND (msi.disable_date IS NULL OR msi.disable_date > TRUNC(SYSDATE));
           EXCEPTION
               WHEN no_data_found THEN
                    l_msg_return := 'Subinvent?o de transfer?ia '||l_subinventory_transf||' n?configurado no INV para a organiza? '||r_deliv.organization_code;
                    Raise l_saida;
           END;

           l_debug := 3;

           Fnd_file.put_line(fnd_file.output, ' ');
           Fnd_file.put_line(fnd_file.output, 'N?mero Embarque: '||r_deliv.delivery_name );

           FOR r_lines in c_lines ( pc_delivery_id   => r_deliv.delivery_id
                                  , pc_seqintegracao => r_deliv.SequenciaIntegracao ) LOOP

               mo_global.set_policy_context ('S', r_lines.org_id);
               inv_globals.set_org_id (r_lines.organization_id);
               mo_global.init ('INV');
               l_qtde_atendida := 0;

               FOR r_docdet in c_docdet ( r_deliv.delivery_id, r_lines.delivery_detail_id, r_deliv.SequenciaIntegracao, r_lines.transaction_temp_id ) LOOP
                   l_dif_qtde      := 0;
                   l_qtde_atendida := l_qtde_atendida + r_docdet.QuantidadeMovimento;

                   -- Acertar Linhas de quantidades diferentes
                   IF NVL(r_docdet.primary_quantity, r_lines.primary_quantity) <> r_docdet.QuantidadeMovimento THEN
                      l_debug := 4;
                      l_dif_qtde := NVL(r_docdet.primary_quantity, r_lines.primary_quantity) - r_docdet.QuantidadeMovimento;

                      IF l_hdr_rec.organization_id IS NULL THEN
                         l_debug                                       := 5;
                         l_hdr_rec.header_id                           := fnd_api.g_miss_num;
                         l_hdr_rec.request_number                      := 'Entrega '||r_deliv.delivery_name;
                         l_hdr_rec.date_required                       := SYSDATE;
                         l_hdr_rec.header_status                       := inv_globals.g_to_status_preapproved;
                         l_hdr_rec.organization_id                     := r_deliv.organization_id;
                         l_hdr_rec.status_date                         := sysdate;
                         l_hdr_rec.transaction_type_id                 := inv_globals.g_type_transfer_order_subxfr;   --- g_type_transfer_order_issue;
                         l_hdr_rec.move_order_type                     := inv_globals.g_move_order_requisition;
                         l_hdr_rec.db_flag                             := fnd_api.g_true;
                         l_hdr_rec.operation                           := inv_globals.g_opr_create;
                         l_hdr_rec.description                         := 'Delivery '||r_deliv.delivery_name||' - Transfer?ia Subinvent?o devido Diferen?Qtdes com WMAS.';
                      END IF;

                      l_debug                                          := 6;
                      l_line_index                                     := l_line_index + 1;
                      l_line_tbl (l_line_index).date_required          := Sysdate;
                      l_line_tbl (l_line_index).inventory_item_id      := r_lines.inventory_item_id;
                      l_line_tbl (l_line_index).line_id                := fnd_api.g_miss_num;
                      l_line_tbl (l_line_index).line_number            := l_line_index;
                      l_line_tbl (l_line_index).line_status            := inv_globals.g_to_status_preapproved;
                      l_line_tbl (l_line_index).organization_id        := r_deliv.organization_id;
                      l_line_tbl (l_line_index).quantity               := l_dif_qtde;
                      l_line_tbl (l_line_index).status_date            := Sysdate;
                      l_line_tbl (l_line_index).uom_code               := r_lines.uom_code;
                      l_line_tbl (l_line_index).db_flag                := fnd_api.g_true;
                      l_line_tbl (l_line_index).operation              := inv_globals.g_opr_create;
                      l_line_tbl (l_line_index).from_subinventory_code := r_lines.subinventory;
                      l_line_tbl (l_line_index).lot_number             := r_DocDet.lot_number;
                      l_line_tbl (l_line_index).to_subinventory_code   := l_subinventory_transf;
                      --

                      --
                      -- Acerta a quantidade a ser alocada nas tabelas tempor?as
                      --
                      IF r_DocDet.lot_number IS NOT NULL THEN
                         UPDATE mtl_transaction_lots_temp
                            SET transaction_quantity = r_DocDet.QuantidadeMovimento
                              , primary_quantity     = r_DocDet.QuantidadeMovimento
                              , secondary_quantity   = ROUND( ( r_DocDet.QuantidadeMovimento * r_lines.fator_conv_sec ),6)
                          WHERE transaction_temp_id = r_lines.transaction_temp_id
                            AND lot_number          = r_DocDet.lot_number;
                      END IF;

                      UPDATE mtl_material_transactions_temp
                         SET transaction_quantity           = transaction_quantity           - l_dif_qtde
                           , primary_quantity               = primary_quantity               - l_dif_qtde
                           , secondary_transaction_quantity = secondary_transaction_quantity - ROUND( ( l_dif_qtde * r_lines.fator_conv_sec ),6 )
                       WHERE move_order_line_id = r_lines.move_order_line_id;
                      --
                   END IF;
                   --
               END LOOP;
               --
               BEGIN
                  SELECT *
                    INTO l_txn_lines
                    FROM mtl_txn_request_lines
                    WHERE line_id = r_lines.move_order_line_id;
               EXCEPTION
                  WHEN others THEN
                       Null;
               END;

               -- Allocate each line of the Move Order
               l_trolin_tbl(1).line_id                          := r_lines.move_order_line_id;
               l_trolin_tbl(1).header_id                        := r_lines.move_order_header_id;
               l_trolin_tbl(1).txn_source_line_id               := r_lines.txn_source_line_id;
               l_trolin_tbl(1).txn_source_id                    := r_lines.txn_source_id;
               l_trolin_tbl(1).quantity_detailed                := l_qtde_atendida;
               l_trolin_tbl(1).secondary_quantity_detailed      := ROUND( ( l_qtde_atendida * r_lines.fator_conv_sec ),6);
               l_trolin_tbl(1).operation                        := inv_globals.g_opr_update;

               l_trolin_old_tbl(1).line_id                      := r_lines.move_order_line_id;
               l_trolin_old_tbl(1).header_id                    := r_lines.move_order_header_id;
               l_trolin_old_tbl(1).line_number                  := l_txn_lines.line_number;
               l_trolin_old_tbl(1).organization_id              := l_txn_lines.organization_id;
               l_trolin_old_tbl(1).inventory_item_id            := l_txn_lines.inventory_item_id;
               l_trolin_old_tbl(1).revision                     := l_txn_lines.revision;
               l_trolin_old_tbl(1).from_subinventory_code       := l_txn_lines.from_subinventory_code;
               l_trolin_old_tbl(1).from_locator_id              := l_txn_lines.from_locator_id;
               l_trolin_old_tbl(1).to_subinventory_code         := l_txn_lines.to_subinventory_code;
               l_trolin_old_tbl(1).to_locator_id                := l_txn_lines.to_locator_id;
               l_trolin_old_tbl(1).to_account_id                := l_txn_lines.to_account_id;
               l_trolin_old_tbl(1).lot_number                   := l_txn_lines.lot_number;
               l_trolin_old_tbl(1).uom_code                     := l_txn_lines.uom_code;
               l_trolin_old_tbl(1).quantity                     := l_txn_lines.quantity;
               l_trolin_old_tbl(1).quantity_delivered           := l_txn_lines.quantity_delivered;
               l_trolin_old_tbl(1).quantity_detailed            := l_txn_lines.quantity_detailed;
               l_trolin_old_tbl(1).date_required                := l_txn_lines.date_required;
               l_trolin_old_tbl(1).reason_id                    := l_txn_lines.reason_id;
               l_trolin_old_tbl(1).reference                    := l_txn_lines.reference;
               l_trolin_old_tbl(1).reference_type_code          := l_txn_lines.reference_type_code;
               l_trolin_old_tbl(1).reference_id                 := l_txn_lines.reference_id;
               l_trolin_old_tbl(1).project_id                   := l_txn_lines.project_id;
               l_trolin_old_tbl(1).task_id                      := l_txn_lines.task_id;
               l_trolin_old_tbl(1).transaction_header_id        := l_txn_lines.transaction_header_id;
               l_trolin_old_tbl(1).line_status                  := l_txn_lines.line_status;
               l_trolin_old_tbl(1).status_date                  := l_txn_lines.status_date;
               l_trolin_old_tbl(1).last_update_date             := l_txn_lines.last_update_date;
               l_trolin_old_tbl(1).creation_date                := l_txn_lines.creation_date;
               l_trolin_old_tbl(1).txn_source_id                := l_txn_lines.txn_source_id;
               l_trolin_old_tbl(1).txn_source_line_id           := l_txn_lines.txn_source_line_id;
               l_trolin_old_tbl(1).txn_source_line_detail_id    := l_txn_lines.txn_source_line_detail_id;
               l_trolin_old_tbl(1).transaction_type_id          := l_txn_lines.transaction_type_id;
               l_trolin_old_tbl(1).transaction_source_type_id   := l_txn_lines.transaction_source_type_id;
               l_trolin_old_tbl(1).primary_quantity             := l_txn_lines.primary_quantity;
               l_trolin_old_tbl(1).to_organization_id           := l_txn_lines.to_organization_id;
               l_trolin_old_tbl(1).pick_slip_number             := l_txn_lines.pick_slip_number;
               l_trolin_old_tbl(1).pick_slip_date               := l_txn_lines.pick_slip_date;
               l_trolin_old_tbl(1).from_subinventory_id         := l_txn_lines.from_subinventory_id;
               l_trolin_old_tbl(1).to_subinventory_id           := l_txn_lines.to_subinventory_id;
               l_trolin_old_tbl(1).wms_process_flag             := l_txn_lines.wms_process_flag;
               l_trolin_old_tbl(1).required_quantity            := l_txn_lines.required_quantity;
               l_trolin_old_tbl(1).secondary_quantity           := l_txn_lines.secondary_quantity;
               l_trolin_old_tbl(1).secondary_quantity_delivered := l_txn_lines.secondary_quantity_delivered;
               l_trolin_old_tbl(1).secondary_quantity_detailed  := l_txn_lines.secondary_quantity_detailed;
               l_trolin_old_tbl(1).secondary_required_quantity  := l_txn_lines.secondary_required_quantity;

               l_debug := 7;
               Fnd_msg_pub.Delete_Msg(Null);
               INV_MOVE_ORDER_PUB.PROCESS_MOVE_ORDER_LINE ( p_api_version_number => 1.0
                                                          , p_init_msg_list      => fnd_api.g_true
                                                          , p_return_values      => fnd_api.g_false
                                                          , p_commit             => fnd_api.g_false
                                                          , x_return_status      => x_return_status
                                                          , x_msg_count          => x_msg_count
                                                          , x_msg_data           => x_msg_data
                                                          , p_trolin_tbl         => l_trolin_tbl
                                                          , p_trolin_old_tbl     => l_trolin_old_tbl
                                                          , x_trolin_tbl         => x_trolin_tbl
                                                          );

               IF x_return_status <> fnd_api.g_ret_sts_success THEN
                  IF x_msg_count > 0 THEN
                     l_msg_return := 'Proces Move Order Line - Linha '||r_lines.line_number;
                     FOR l_index IN 1..x_msg_count LOOP
                         l_msg_return := l_msg_return||' - '||FND_MSG_PUB.GET( P_MSG_INDEX => l_index
                                                                             , P_ENCODED   => 'F' );
                     END LOOP;
                  ELSE
                     l_msg_return := 'Process Move Order Line - Linha '||r_lines.line_number||' - '||x_msg_data;
                  END IF;
                  Raise l_saida;
               ELSE
                  l_debug                                       := 8;
                  a_l_trolin_tbl(1).line_id                     := r_lines.move_order_line_id;
                  a_l_trolin_tbl(1).quantity_detailed           := l_qtde_atendida;
                  a_l_trolin_tbl(1).header_id                   := r_lines.move_order_header_id;
                  a_l_trolin_tbl(1).txn_source_line_id          := r_lines.txn_source_line_id;
                  a_l_trolin_tbl(1).txn_source_id               := r_lines.txn_source_id;
                  a_l_trolin_tbl(1).secondary_quantity_detailed := ROUND( ( l_qtde_atendida * r_lines.fator_conv_sec ),6);
                  a_l_trolin_tbl(1).operation                   := inv_globals.g_opr_update;
                  v_transaction_date                            := Sysdate;

                  Fnd_msg_pub.Delete_Msg(Null);
                  inv_pick_wave_pick_confirm_pub.pick_confirm ( p_api_version_number => a_l_api_version
                                                              , p_init_msg_list      => a_l_init_msg_list
                                                              , p_commit             => a_l_commit
                                                              , x_return_status      => a_x_return_status
                                                              , x_msg_count          => a_x_msg_count
                                                              , x_msg_data           => a_x_msg_data
                                                              , p_move_order_type    => a_l_move_order_type
                                                              , p_transaction_mode   => a_l_transaction_mode
                                                              , p_trolin_tbl         => a_l_trolin_tbl
                                                              , p_mold_tbl           => a_l_mold_tbl
                                                              , x_mmtt_tbl           => a_x_mmtt_tbl
                                                              , x_trolin_tbl         => a_x_trolin_tbl
                                                              , p_transaction_date   => v_transaction_date
                                                              );

                  l_debug := 9;
                  IF a_x_return_status <> fnd_api.g_ret_sts_success THEN
                     IF a_x_msg_count > 0 THEN
                        l_msg_return := 'Pick Confirm Move Order - Linha '||r_lines.line_number;
                        FOR l_index IN 1..a_x_msg_count LOOP
                            l_msg_return := l_msg_return||' - '||FND_MSG_PUB.GET( P_MSG_INDEX => l_index
                                                                                , P_ENCODED   => 'F' );
                        END LOOP;
                     ELSE
                        l_msg_return := 'Pick Confirm Move Order - Linha '||r_lines.line_number||' - '||x_msg_data;
                     END IF;
                     Raise l_saida;
                  ELSE
                     l_debug := 10;
                     --
                     IF r_lines.primary_quantity <> l_qtde_atendida THEN
                        l_debug                     := 11;
                        l_to_rsv_rec.reservation_id := r_lines.reservation_id;

                        INV_RESERVATION_PUB.delete_reservation ( p_api_version_number       => a_l_api_version
                                                               , p_init_msg_lst             => a_l_init_msg_list
                                                               , x_return_status            => a_x_return_status
                                                               , x_msg_count                => a_x_msg_count
                                                               , x_msg_data                 => a_x_msg_data
                                                               , p_rsv_rec                  => l_to_rsv_rec
                                                               , p_serial_number            => l_to_serial_number );

                        IF a_x_return_status <> fnd_api.g_ret_sts_success THEN
                           IF a_x_msg_count > 0 THEN
                              l_msg_return := 'Delete Reservation - Linha: '||r_lines.line_number;
                              FOR l_index IN 1..a_x_msg_count LOOP
                                  l_msg_return := l_msg_return||' - '||FND_MSG_PUB.GET( P_MSG_INDEX => l_index
                                                                                      , P_ENCODED   => 'F' );
                              END LOOP;
                           ELSE
                              l_msg_return := 'Delete Reservation - Linha: '||r_lines.line_number||' - '||x_msg_data;
                           END IF;
                           Raise l_saida;
                        END IF;
                     END IF;
                     --
                     l_debug := 12;
                     --
                  END IF;
               END IF;
               --
           END LOOP;
           --
           l_debug := 13;

           -- Processar Move Order das diferen? de quantidade
           IF l_line_index > 0 THEN
              Fnd_msg_pub.Delete_Msg(Null);
              l_debug := 14;

              Inv_Move_Order_Pub.Process_Move_Order ( p_api_version_number => 1.0
                                                    , p_init_msg_list      => fnd_api.g_true
                                                    , p_return_values      => fnd_api.g_false
                                                    , p_commit             => fnd_api.g_false
                                                    , x_return_status      => l_return_status
                                                    , x_msg_count          => l_msg_count
                                                    , x_msg_data           => l_msg_data
                                                    , p_trohdr_rec         => l_hdr_rec
                                                    , p_trolin_tbl         => l_line_tbl
                                                    , x_trohdr_rec         => x_hdr_rec
                                                    , x_trohdr_val_rec     => x_hdr_val_rec
                                                    , x_trolin_tbl         => l_trolin_out_tbl
                                                    , x_trolin_val_tbl     => x_line_val_tbl );

              IF l_return_status = FND_API.G_RET_STS_ERROR OR
                 l_return_status = FND_API.G_RET_STS_UNEXP_ERROR THEN
                 l_debug := 15;
                 IF l_msg_count > 0 THEN
                    l_debug := 16;
                    l_msg_return := 'Delivery: '||r_deliv.delivery_name||' - Process_Move_Order: ';
                    FOR l_index IN 1..l_msg_count LOOP
                        l_msg_return := l_msg_return||' - '||FND_MSG_PUB.GET( P_MSG_INDEX => l_index
                                                                            , P_ENCODED   => 'F' );
                    END LOOP;
                 ELSE
                    l_debug := 17;
                    l_msg_return := l_msg_data;
                 END IF;
                 Raise l_saida;
              ELSE
                 IF x_hdr_rec.header_id IS NOT NULL THEN
                    Fnd_file.put_line(fnd_file.output, '  Move Order "'||x_hdr_rec.request_number||'" criada referente diferen?de quantidade de linhas.');
                    l_debug := 18;
                    FOR x_lines IN ( SELECT line_id, line_number, quantity
                                       FROM mtl_txn_request_lines
                                      WHERE header_id = x_hdr_rec.header_id ) LOOP
                        -- Allocate each line of the New Move Order
                        l_debug := 15;
                        Fnd_msg_pub.Delete_Msg(Null);
                        inv_replenish_detail_pub.line_details_pub ( p_line_id               => x_lines.line_id
                                                                  , x_number_of_rows        => x_number_of_rows
                                                                  , x_detailed_qty          => x_lines.quantity
                                                                  , x_return_status         => x_return_status
                                                                  , x_msg_count             => x_msg_count
                                                                  , x_msg_data              => x_msg_data
                                                                  , x_revision              => x_revision
                                                                  , x_locator_id            => x_locator_id
                                                                  , x_transfer_to_location  => x_transfer_to_location
                                                                  , x_lot_number            => x_lot_number
                                                                  , x_expiration_date       => x_expiration_date
                                                                  , x_transaction_temp_id   => x_transaction_temp_id
                                                                  , p_transaction_header_id => NULL
                                                                  , p_transaction_mode      => NULL
                                                                  , p_move_order_type       => inv_globals.g_move_order_requisition
                                                                  , p_serial_flag           => fnd_api.g_false
                                                                  , p_plan_tasks            => FALSE
                                                                  , p_auto_pick_confirm     => FALSE
                                                                  , p_commit                => FALSE
                                                                  );

                        IF x_return_status <> fnd_api.g_ret_sts_success THEN
                           IF x_msg_count > 0 THEN
                              l_msg_return := 'Allocate Line New Move Order - Linha '||x_lines.line_number;
                              FOR l_index IN 1..x_msg_count LOOP
                                  l_msg_return := l_msg_return||' - '||FND_MSG_PUB.GET( P_MSG_INDEX => l_index
                                                                                      , P_ENCODED   => 'F' );
                              END LOOP;
                           ELSE
                              l_msg_return := 'Allocate Line New Move Order - Linha '||x_lines.line_number||' - '||x_msg_data;
                           END IF;
                           Raise l_saida;
                        ELSE
                           Fnd_msg_pub.Delete_Msg(Null);
                           l_debug                    := 19;
                           a_l_trolin_tbl (1).line_id := x_lines.line_id;
                           v_transaction_date         := Sysdate;

                           Fnd_msg_pub.Delete_Msg(Null);
                           inv_pick_wave_pick_confirm_pub.pick_confirm ( p_api_version_number => a_l_api_version
                                                                       , p_init_msg_list      => a_l_init_msg_list
                                                                       , p_commit             => a_l_commit
                                                                       , x_return_status      => a_x_return_status
                                                                       , x_msg_count          => a_x_msg_count
                                                                       , x_msg_data           => a_x_msg_data
                                                                       , p_move_order_type    => a_l_move_order_type
                                                                       , p_transaction_mode   => a_l_transaction_mode
                                                                       , p_trolin_tbl         => a_l_trolin_tbl
                                                                       , p_mold_tbl           => a_l_mold_tbl
                                                                       , x_mmtt_tbl           => a_x_mmtt_tbl
                                                                       , x_trolin_tbl         => a_x_trolin_tbl
                                                                       , p_transaction_date   => v_transaction_date
                                                                       );

                           IF a_x_return_status <> fnd_api.g_ret_sts_success THEN
                              IF a_x_msg_count > 0 THEN
                                 l_msg_return := 'Pick Confirm New Move Order - Linha '||x_lines.line_number;
                                 FOR l_index IN 1..a_x_msg_count LOOP
                                     l_msg_return := l_msg_return||' - '||FND_MSG_PUB.GET( P_MSG_INDEX => l_index
                                                                                         , P_ENCODED   => 'F' );
                                 END LOOP;
                              ELSE
                                 l_msg_return := 'Pick Confirm New Move Order - Linha '||x_lines.line_number||' - '||x_msg_data;
                              END IF;
                              Raise l_saida;
                           END IF;
                        END IF;
                    END LOOP;
                 END IF;
              END IF;
           END IF;
           --
           l_debug := 20;
           --
           UPDATE wsh_new_deliveries
              SET attribute8 = '252'
            WHERE delivery_id = r_deliv.delivery_id;
           --
           UPDATE integracao
              SET estadointegracao = 2
            WHERE SequenciaIntegracao = r_deliv.SequenciaIntegracao;
           --
           -- Gravando Historico Integracao
           g_integracao_hist_tbl_type(1).sequenciaintegracao  := l_sequenciaIntegracao;
           g_integracao_hist_tbl_type(1).detalhehistorico     := 'Integrado.';
           --
           -- insere historico
           XXPPG_INV_WMAS_PUB_PKG.create_wmas_records( p_integracao_tbl            => g_integracao_tbl_type
                                                     , p_integracao_hist_tbl       => g_integracao_hist_tbl_type
                                                     , p_documento_tbl             => g_documento_tbl_type
                                                     , p_documento_detalhe_tbl     => g_documentodetalhe_tbl_type
                                                     , p_documento_detalhe_seq_tbl => g_documentodetalheseq_tbl_type
                                                     , p_movimento_estoque_tbl     => g_movimentoestoque_tbl_type
                                                     , p_produto_tbl               => g_produto_tbl_type
                                                     , p_TipoUC_tbl                => g_TipoUC_tbl_type
                                                     , p_SequencialIntegracao      => l_sequenciaIntegracao
                                                     , p_return_status             => l_return_status
                                                     , p_msg_data                  => l_msg_data);
           --
           COMMIT;
           --
           UPDATE wsh_delivery_details
              SET seal_code = 'SEPCONFIRM'
            WHERE delivery_detail_id IN ( SELECT wdv.delivery_detail_id
                                            FROM wsh_deliverables_v wdv
                                           WHERE wdv.delivery_id = r_deliv.delivery_id )
              AND picked_quantity IS NOT NULL;
           --
           COMMIT;
           --
        EXCEPTION
            WHEN l_saida THEN
                 --
                 l_debug := 21;
                 --
                 Fnd_file.put_line(fnd_file.output, 'Erro: '||l_msg_return);
                 ROLLBACK;
                 --
                 UPDATE integracao
                    SET estadointegracao = 3
                  WHERE sequenciaintegracao = l_sequenciaIntegracao;

                 -- Gravando Historico Integracao
                 g_integracao_hist_tbl_type(1).sequenciaintegracao  := l_sequenciaIntegracao;
                 g_integracao_hist_tbl_type(1).detalhehistorico     := SUBSTR(REPLACE(REPLACE(l_msg_return,chr(10),' '),chr(13),' '),1,180);
                 --
                 -- insere historico
                 XXPPG_INV_WMAS_PUB_PKG.create_wmas_records( p_integracao_tbl            => g_integracao_tbl_type
                                                           , p_integracao_hist_tbl       => g_integracao_hist_tbl_type
                                                           , p_documento_tbl             => g_documento_tbl_type
                                                           , p_documento_detalhe_tbl     => g_documentodetalhe_tbl_type
                                                           , p_documento_detalhe_seq_tbl => g_documentodetalheseq_tbl_type
                                                           , p_movimento_estoque_tbl     => g_movimentoestoque_tbl_type
                                                           , p_produto_tbl               => g_produto_tbl_type
                                                           , p_TipoUC_tbl                => g_TipoUC_tbl_type
                                                           , p_SequencialIntegracao      => l_sequenciaIntegracao
                                                           , p_return_status             => l_return_status
                                                           , p_msg_data                  => l_msg_data);
                 --
                 COMMIT;
                 --
                 p_retcode := 1;
                 --
        END;
    END LOOP;
  EXCEPTION
     WHEN others THEN
          p_retcode  := 1;
          p_msg_erro := 'Erro na rotina Confirma? de Embarque - Debug '||l_debug||' - Delivery Id: '||l_delivery_id||' - '||SqlErrm;
          Return;
  END Confirma_Entrega_P;

PROCEDURE Confirma_Entrega_P_New ( p_delivery_id   In Number
                               , p_msg_erro     Out Varchar2
                               , p_retcode      Out Number  ) IS


  CURSOR c_deliv (pc_org_id  In Number) IS
       SELECT wnd.delivery_id
            , wnd.name   delivery_name
            , wnd.organization_id
            , mp.organization_code
            , wmas.SequenciaIntegracao
         FROM wsh_new_deliveries            wnd
            , mtl_parameters                mp
            , org_organization_definitions  ood
            , ( SELECT int.SequenciaIntegracao
                     , doc.numerodocumento
                  FROM integracao          int
                     , documento           doc
                 WHERE int.TipoIntegracao       = 252
                   AND int.estadointegracao     = 1
                   AND doc.tipodocumento        = 'EMB'
                   AND doc.sequenciaintegracao  = int.sequenciaintegracao
                 UNION ALL
                 SELECT int.SequenciaIntegracao
                      , doc.numerodocumento
                  FROM integracao          int
                     , documento           doc
                 WHERE int.TipoIntegracao       = 252
                   AND int.estadointegracao     = 3
                   AND doc.tipodocumento        = 'EMB'
                   AND doc.sequenciaintegracao  = int.sequenciaintegracao
              ) wmas
        WHERE wnd.delivery_id     = NVL(p_delivery_id, wnd.delivery_id)
          AND wnd.status_code     = 'OP'
          AND wnd.attribute8      = '203'
          AND wnd.delivery_id     = TO_NUMBER(wmas.numerodocumento)
          AND mp.organization_id  = wnd.organization_id
          AND ood.organization_id = mp.organization_id
          AND ood.operating_unit  = pc_org_id;

     CURSOR c_lines (pc_delivery_id    In Number
                    ,pc_seqintegracao  In Number) IS
       SELECT wdd.delivery_detail_id
            , wdd.ship_method_code
            , wdd.org_id
            , wdd.organization_id
            , wdd.source_header_id
            , wdd.source_line_id
            , trl.primary_quantity
            , trl.quantity
            , trl.uom_code
            , trl.line_number
            , trl.from_locator_id
            , trl.to_account_id
            , trl.txn_source_line_id
            , trl.txn_source_id
            , wdd.inventory_item_id
            , NVL(mmtt.subinventory_code, wdd.subinventory) Subinventory
            , wdd.move_order_line_id
            , trh.move_order_type
            , trh.header_id  move_order_header_id
            , trh.request_number
            , trl.revision
            , mmtt.reservation_id
            , mmtt.transaction_temp_id
            , (trl.secondary_quantity / trl.primary_quantity)  fator_conv_sec
         FROM wsh_deliverables_v              wdd
            , mtl_txn_request_lines           trl
            , mtl_txn_request_headers         trh
            , mtl_material_transactions_temp  mmtt
        WHERE wdd.delivery_id                = pc_delivery_id
          AND trl.txn_source_line_detail_id  = wdd.delivery_detail_id
          AND trl.line_status               IN (3,7)
          AND trl.quantity_delivered        IS NULL
          AND trh.header_id                  = trl.header_id
          AND mmtt.move_order_line_id (+)    = trl.line_id
        ORDER BY wdd.delivery_detail_id, trl.line_id, mmtt.transaction_temp_id;

     CURSOR c_DocDet (pc_delivery_id          In Number
                     ,pc_delivery_detail_id   In Number
                     ,pc_seqintegracao        In Number
                     ,pc_transaction_temp_id  In Number) IS
       SELECT dd.DadoLogistico                Lot_Number
            , mtlt.primary_quantity
            , NVL(dd.QuantidadeMovimento,0)   QuantidadeMovimento
         FROM documentodetalhe             dd
            , mtl_transaction_lots_temp    mtlt
        WHERE dd.sequenciaintegracao      = pc_seqintegracao
          AND dd.OrdemSeparacao           = TO_CHAR(pc_delivery_id)
          AND dd.NumeroPedidoSeparacao    = TO_CHAR(pc_delivery_detail_id)
          AND mtlt.transaction_temp_id(+) = pc_transaction_temp_id
          AND mtlt.lot_number(+)          = dd.DadoLogistico
        ORDER BY dd.SequenciaDetalhe;

     l_msg_return               Varchar2(32000);
     l_delivery_id              wsh_new_deliveries.delivery_id%TYPE;
     l_sequenciaIntegracao      Number;
     l_subinventory_transf      mtl_secondary_inventories.secondary_inventory_name%TYPE;
     l_dif_qtde                 Number;
     l_qtde_atendida            Number;
     l_saida                    Exception;
     l_debug                    Number;

     l_line_index               Number := 0;
     l_hdr_rec                  inv_move_order_pub.trohdr_rec_type       := inv_move_order_pub.g_miss_trohdr_rec;
     l_line_tbl                 inv_move_order_pub.trolin_tbl_type       := inv_move_order_pub.g_miss_trolin_tbl;
     x_hdr_rec                  inv_move_order_pub.trohdr_rec_type       := inv_move_order_pub.g_miss_trohdr_rec;
     x_hdr_val_rec              inv_move_order_pub.trohdr_val_rec_type;
     x_line_tbl                 inv_move_order_pub.trolin_tbl_type;
     l_trolin_out_tbl           INV_Move_Order_PUB.Trolin_Tbl_Type;
     x_line_val_tbl             inv_move_order_pub.trolin_val_tbl_type;
     v_msg_index_out            NUMBER;

     ----------------- ALLOCATE MOVE ORDER API REQUIREMENTS -------------------------
     l_api_version              NUMBER       := 1.0;
     l_init_msg_list            VARCHAR2 (2) := fnd_api.g_true;
     l_return_values            VARCHAR2 (2) := fnd_api.g_false;
     l_commit                   VARCHAR2 (2) := fnd_api.g_false;
     x_return_status            VARCHAR2 (2);
     x_msg_count                NUMBER       := 0;
     x_msg_data                 VARCHAR2 (255);
     l_trolin_tbl               inv_move_order_pub.trolin_tbl_type;
     l_trolin_old_tbl           inv_move_order_pub.trolin_tbl_type;
     l_trolin_val_tbl           inv_move_order_pub.trolin_val_tbl_type;
     x_trolin_tbl               inv_move_order_pub.trolin_tbl_type;
     x_trolin_val_tbl           inv_move_order_pub.trolin_val_tbl_type;
     x_detailed_quantity        NUMBER ;
     x_number_of_rows           NUMBER ;
     x_transfer_to_location     NUMBER ;
     x_revision                 VARCHAR2(100);
     x_locator_id               NUMBER;
     x_lot_number               VARCHAR2(150);
     x_expiration_date          DATE;
     x_transaction_temp_id      NUMBER ;
     l_txn_lines                mtl_txn_request_lines%ROWTYPE;

     ----------------- TRANSACT MOVE ORDER API REQUIREMENTS -------------------------
     a_l_api_version               NUMBER       := 1.0;
     a_l_init_msg_list             VARCHAR2 (2) := fnd_api.g_true;
     a_l_commit                    VARCHAR2 (2) := fnd_api.g_false;
     a_x_return_status             VARCHAR2 (2);
     a_x_msg_count                 NUMBER := 0;
     a_x_msg_data                  VARCHAR2 (255);
     a_l_move_order_type           NUMBER := 3;
     a_l_transaction_mode          NUMBER := 1;
     a_l_trolin_tbl                inv_move_order_pub.trolin_tbl_type;
     a_l_mold_tbl                  inv_mo_line_detail_util.g_mmtt_tbl_type;
     a_x_mmtt_tbl                  inv_mo_line_detail_util.g_mmtt_tbl_type;
     a_x_trolin_tbl                inv_move_order_pub.trolin_tbl_type;
     a_l_transaction_date          DATE := SYSDATE;
     v_transaction_date            DATE;

     ----------------- RESERVATION DELETE API REQUIREMENTS -------------------------
     l_to_rsv_rec                  inv_reservation_global.mtl_reservation_rec_type;
     l_to_serial_number            inv_reservation_global.serial_number_tbl_type;

     l_return_status            Varchar2(10);
     l_msg_count                Number;
     l_msg_data                 Varchar2(32000);
     l_msg_details              Varchar2(32000);
     l_msg_summary              Varchar2(32000);
     l_org_id                   Number;
     l_entrou                   BOOLEAN;
     l_error_msg                CLOB;
     l_backorder                varchar(1):='N';

  BEGIN
    l_debug  := 1;
    l_org_id := Fnd_Profile.Value('ORG_ID');

    fnd_file.put_line(fnd_file.output, '****************************************************************************** ');
    fnd_file.put_line(fnd_file.output, 'Disparando Integracao da Confirmacao de Embarque                               ');
    fnd_file.put_line(fnd_file.output, '****************************************************************************** ');

    FOR r_deliv in c_deliv(l_org_id) LOOP

        BEGIN
           l_debug               := 2;
           l_delivery_id         := r_deliv.delivery_id;
           l_sequenciaIntegracao := r_deliv.sequenciaintegracao;
           l_line_index          := 0;
           l_hdr_rec             := Null;
           l_line_tbl.delete;

           -- Recupera subinvent?o de transferencia conforme organiza?
           BEGIN
              SELECT flv.description
                INTO l_subinventory_transf
                FROM fnd_lookup_values_vl  flv
               WHERE flv.lookup_type         = 'PPG_WSH_INV_SUB_INVENT_DIFEREN'
                 AND flv.lookup_code         = r_deliv.organization_code
                 AND flv.view_application_id = 665;
           EXCEPTION
                WHEN no_data_found THEN
                     l_msg_return := 'Subinventao de transferencia nao configurado para a organizacao '||r_deliv.organization_code||' na lookup PPG_WSH_INV_SUB_INVENT_DIFEREN.';
                     Raise l_saida;
           END;

           -- Checa se o subinventario de transfencia esta adastrado na organizacao
           BEGIN
              SELECT msi.secondary_inventory_name
                INTO l_subinventory_transf
                FROM mtl_secondary_inventories  msi
               WHERE msi.secondary_inventory_name = l_subinventory_transf
                 AND msi.organization_id          = r_deliv.organization_id
                 AND (msi.disable_date IS NULL OR msi.disable_date > TRUNC(SYSDATE));
           EXCEPTION
               WHEN no_data_found THEN
                    l_msg_return := 'Subinventao de transferencia '||l_subinventory_transf||' Nao configurado no INV para a organiza? '||r_deliv.organization_code;
                    Raise l_saida;
           END;

           l_debug := 3;

           Fnd_file.put_line(fnd_file.output, ' ');
           Fnd_file.put_line(fnd_file.output, 'Numero Embarque: '||r_deliv.delivery_name );

           FOR r_lines in c_lines ( pc_delivery_id   => r_deliv.delivery_id
                                  , pc_seqintegracao => r_deliv.SequenciaIntegracao ) LOOP

               mo_global.set_policy_context ('S', r_lines.org_id);
               inv_globals.set_org_id (r_lines.organization_id);
               mo_global.init ('INV');
               l_qtde_atendida := 0;
               l_entrou := FALSE;

               FOR r_docdet in c_docdet ( r_deliv.delivery_id, r_lines.delivery_detail_id, r_deliv.SequenciaIntegracao, r_lines.transaction_temp_id ) LOOP
                   l_dif_qtde      := 0;
                   l_qtde_atendida := l_qtde_atendida + r_docdet.QuantidadeMovimento;
                   l_entrou :=TRUE;
                   -- Acertar Linhas de quantidades diferentes
                   IF NVL(r_docdet.primary_quantity, r_lines.primary_quantity) <> r_docdet.QuantidadeMovimento THEN
                      l_debug := 4;
                      l_dif_qtde := NVL(r_docdet.primary_quantity, r_lines.primary_quantity) - r_docdet.QuantidadeMovimento;

                      IF l_hdr_rec.organization_id IS NULL THEN
                         l_debug                                       := 5;
                         l_hdr_rec.header_id                           := fnd_api.g_miss_num;
                         l_hdr_rec.request_number                      := 'Entrega '||r_deliv.delivery_name;
                         l_hdr_rec.date_required                       := SYSDATE;
                         l_hdr_rec.header_status                       := inv_globals.g_to_status_preapproved;
                         l_hdr_rec.organization_id                     := r_deliv.organization_id;
                         l_hdr_rec.status_date                         := sysdate;
                         l_hdr_rec.transaction_type_id                 := inv_globals.g_type_transfer_order_subxfr;   --- g_type_transfer_order_issue;
                         l_hdr_rec.move_order_type                     := inv_globals.g_move_order_requisition;
                         l_hdr_rec.db_flag                             := fnd_api.g_true;
                         l_hdr_rec.operation                           := inv_globals.g_opr_create;
                         l_hdr_rec.description                         := 'Delivery '||r_deliv.delivery_name||' - Transferencia Subinventario devido Diferencas Qtdes com WMAS.';
                      END IF;

                      l_debug                                          := 6;
                      l_line_index                                     := l_line_index + 1;
                      l_line_tbl (l_line_index).date_required          := Sysdate;
                      l_line_tbl (l_line_index).inventory_item_id      := r_lines.inventory_item_id;
                      l_line_tbl (l_line_index).line_id                := fnd_api.g_miss_num;
                      l_line_tbl (l_line_index).line_number            := l_line_index;
                      l_line_tbl (l_line_index).line_status            := inv_globals.g_to_status_preapproved;
                      l_line_tbl (l_line_index).organization_id        := r_deliv.organization_id;
                      l_line_tbl (l_line_index).quantity               := l_dif_qtde;
                      l_line_tbl (l_line_index).status_date            := Sysdate;
                      l_line_tbl (l_line_index).uom_code               := r_lines.uom_code;
                      l_line_tbl (l_line_index).db_flag                := fnd_api.g_true;
                      l_line_tbl (l_line_index).operation              := inv_globals.g_opr_create;
                      l_line_tbl (l_line_index).from_subinventory_code := r_lines.subinventory;
                      l_line_tbl (l_line_index).lot_number             := r_DocDet.lot_number;
                      l_line_tbl (l_line_index).to_subinventory_code   := l_subinventory_transf;
                      --

                      --
                      -- Acerta a quantidade a ser alocada nas tabelas tempor?as
                      --
                      IF r_DocDet.lot_number IS NOT NULL THEN
                         UPDATE mtl_transaction_lots_temp
                            SET transaction_quantity = r_DocDet.QuantidadeMovimento
                              , primary_quantity     = r_DocDet.QuantidadeMovimento
                              , secondary_quantity   = ROUND( ( r_DocDet.QuantidadeMovimento * r_lines.fator_conv_sec ),6)
                          WHERE transaction_temp_id = r_lines.transaction_temp_id
                            AND lot_number          = r_DocDet.lot_number;
                      END IF;

                      UPDATE mtl_material_transactions_temp
                         SET transaction_quantity           = transaction_quantity           - l_dif_qtde
                           , primary_quantity               = primary_quantity               - l_dif_qtde
                           , secondary_transaction_quantity = secondary_transaction_quantity - ROUND( ( l_dif_qtde * r_lines.fator_conv_sec ),6 )
                       WHERE move_order_line_id = r_lines.move_order_line_id;
                      --
                   END IF;
                   --
               END LOOP;
               --

             --IF l_entrou = TRUE THEN

                   BEGIN
                      SELECT *
                        INTO l_txn_lines
                        FROM mtl_txn_request_lines
                        WHERE line_id = r_lines.move_order_line_id;
                   EXCEPTION
                      WHEN others THEN
                           Null;
                   END;

                   -- Allocate each line of the Move Order
                   l_trolin_tbl(1).line_id                          := r_lines.move_order_line_id;
                   l_trolin_tbl(1).header_id                        := r_lines.move_order_header_id;
                   l_trolin_tbl(1).txn_source_line_id               := r_lines.txn_source_line_id;
                   l_trolin_tbl(1).txn_source_id                    := r_lines.txn_source_id;
                   l_trolin_tbl(1).quantity_detailed                := l_qtde_atendida;
                   l_trolin_tbl(1).secondary_quantity_detailed      := ROUND( ( l_qtde_atendida * r_lines.fator_conv_sec ),6);
                   l_trolin_tbl(1).operation                        := inv_globals.g_opr_update;

                   l_trolin_old_tbl(1).line_id                      := r_lines.move_order_line_id;
                   l_trolin_old_tbl(1).header_id                    := r_lines.move_order_header_id;
                   l_trolin_old_tbl(1).line_number                  := l_txn_lines.line_number;
                   l_trolin_old_tbl(1).organization_id              := l_txn_lines.organization_id;
                   l_trolin_old_tbl(1).inventory_item_id            := l_txn_lines.inventory_item_id;
                   l_trolin_old_tbl(1).revision                     := l_txn_lines.revision;
                   l_trolin_old_tbl(1).from_subinventory_code       := l_txn_lines.from_subinventory_code;
                   l_trolin_old_tbl(1).from_locator_id              := l_txn_lines.from_locator_id;
                   l_trolin_old_tbl(1).to_subinventory_code         := l_txn_lines.to_subinventory_code;
                   l_trolin_old_tbl(1).to_locator_id                := l_txn_lines.to_locator_id;
                   l_trolin_old_tbl(1).to_account_id                := l_txn_lines.to_account_id;
                   l_trolin_old_tbl(1).lot_number                   := l_txn_lines.lot_number;
                   l_trolin_old_tbl(1).uom_code                     := l_txn_lines.uom_code;
                   l_trolin_old_tbl(1).quantity                     := l_txn_lines.quantity;
                   l_trolin_old_tbl(1).quantity_delivered           := l_txn_lines.quantity_delivered;
                   l_trolin_old_tbl(1).quantity_detailed            := l_txn_lines.quantity_detailed;
                   l_trolin_old_tbl(1).date_required                := l_txn_lines.date_required;
                   l_trolin_old_tbl(1).reason_id                    := l_txn_lines.reason_id;
                   l_trolin_old_tbl(1).reference                    := l_txn_lines.reference;
                   l_trolin_old_tbl(1).reference_type_code          := l_txn_lines.reference_type_code;
                   l_trolin_old_tbl(1).reference_id                 := l_txn_lines.reference_id;
                   l_trolin_old_tbl(1).project_id                   := l_txn_lines.project_id;
                   l_trolin_old_tbl(1).task_id                      := l_txn_lines.task_id;
                   l_trolin_old_tbl(1).transaction_header_id        := l_txn_lines.transaction_header_id;
                   l_trolin_old_tbl(1).line_status                  := l_txn_lines.line_status;
                   l_trolin_old_tbl(1).status_date                  := l_txn_lines.status_date;
                   l_trolin_old_tbl(1).last_update_date             := l_txn_lines.last_update_date;
                   l_trolin_old_tbl(1).creation_date                := l_txn_lines.creation_date;
                   l_trolin_old_tbl(1).txn_source_id                := l_txn_lines.txn_source_id;
                   l_trolin_old_tbl(1).txn_source_line_id           := l_txn_lines.txn_source_line_id;
                   l_trolin_old_tbl(1).txn_source_line_detail_id    := l_txn_lines.txn_source_line_detail_id;
                   l_trolin_old_tbl(1).transaction_type_id          := l_txn_lines.transaction_type_id;
                   l_trolin_old_tbl(1).transaction_source_type_id   := l_txn_lines.transaction_source_type_id;
                   l_trolin_old_tbl(1).primary_quantity             := l_txn_lines.primary_quantity;
                   l_trolin_old_tbl(1).to_organization_id           := l_txn_lines.to_organization_id;
                   l_trolin_old_tbl(1).pick_slip_number             := l_txn_lines.pick_slip_number;
                   l_trolin_old_tbl(1).pick_slip_date               := l_txn_lines.pick_slip_date;
                   l_trolin_old_tbl(1).from_subinventory_id         := l_txn_lines.from_subinventory_id;
                   l_trolin_old_tbl(1).to_subinventory_id           := l_txn_lines.to_subinventory_id;
                   l_trolin_old_tbl(1).wms_process_flag             := l_txn_lines.wms_process_flag;
                   l_trolin_old_tbl(1).required_quantity            := l_txn_lines.required_quantity;
                   l_trolin_old_tbl(1).secondary_quantity           := l_txn_lines.secondary_quantity;
                   l_trolin_old_tbl(1).secondary_quantity_delivered := l_txn_lines.secondary_quantity_delivered;
                   l_trolin_old_tbl(1).secondary_quantity_detailed  := l_txn_lines.secondary_quantity_detailed;
                   l_trolin_old_tbl(1).secondary_required_quantity  := l_txn_lines.secondary_required_quantity;

                   l_debug := 7;
                   Fnd_msg_pub.Delete_Msg(Null);
                   INV_MOVE_ORDER_PUB.PROCESS_MOVE_ORDER_LINE ( p_api_version_number => 1.0
                                                              , p_init_msg_list      => fnd_api.g_true
                                                              , p_return_values      => fnd_api.g_false
                                                              , p_commit             => fnd_api.g_false
                                                              , x_return_status      => x_return_status
                                                              , x_msg_count          => x_msg_count
                                                              , x_msg_data           => x_msg_data
                                                              , p_trolin_tbl         => l_trolin_tbl
                                                              , p_trolin_old_tbl     => l_trolin_old_tbl
                                                              , x_trolin_tbl         => x_trolin_tbl
                                                              );

                   IF x_return_status <> fnd_api.g_ret_sts_success THEN
                      IF x_msg_count > 0 THEN
                         l_msg_return := 'Proces Move Order Line - Linha '||r_lines.line_number;
                         FOR l_index IN 1..x_msg_count LOOP
                             l_msg_return := l_msg_return||' - '||FND_MSG_PUB.GET( P_MSG_INDEX => l_index
                                                                                 , P_ENCODED   => 'F' );
                         END LOOP;
                      ELSE
                         l_msg_return := 'Process Move Order Line - Linha '||r_lines.line_number||' - '||x_msg_data;
                      END IF;
                      Raise l_saida;
                   ELSE
                      l_debug                                       := 8;
                      a_l_trolin_tbl(1).line_id                     := r_lines.move_order_line_id;
                      a_l_trolin_tbl(1).quantity_detailed           := l_qtde_atendida;
                      a_l_trolin_tbl(1).header_id                   := r_lines.move_order_header_id;
                      a_l_trolin_tbl(1).txn_source_line_id          := r_lines.txn_source_line_id;
                      a_l_trolin_tbl(1).txn_source_id               := r_lines.txn_source_id;
                      a_l_trolin_tbl(1).secondary_quantity_detailed := ROUND( ( l_qtde_atendida * r_lines.fator_conv_sec ),6);
                      a_l_trolin_tbl(1).operation                   := inv_globals.g_opr_update;
                      v_transaction_date                            := Sysdate;

                      Fnd_msg_pub.Delete_Msg(Null);
                      IF l_qtde_atendida <> 0 THEN
                          inv_pick_wave_pick_confirm_pub.pick_confirm ( p_api_version_number => a_l_api_version
                                                                      , p_init_msg_list      => a_l_init_msg_list
                                                                      , p_commit             => a_l_commit
                                                                      , x_return_status      => a_x_return_status
                                                                      , x_msg_count          => a_x_msg_count
                                                                      , x_msg_data           => a_x_msg_data
                                                                      , p_move_order_type    => a_l_move_order_type
                                                                      , p_transaction_mode   => a_l_transaction_mode
                                                                      , p_trolin_tbl         => a_l_trolin_tbl
                                                                      , p_mold_tbl           => a_l_mold_tbl
                                                                      , x_mmtt_tbl           => a_x_mmtt_tbl
                                                                      , x_trolin_tbl         => a_x_trolin_tbl
                                                                      , p_transaction_date   => v_transaction_date
                                                                      );
                          l_debug := 9;
                          IF a_x_return_status <> fnd_api.g_ret_sts_success THEN
                             IF a_x_msg_count > 0 THEN
                                l_msg_return := 'Pick Confirm Move Order - Linha '||r_lines.line_number;
                                FOR l_index IN 1..a_x_msg_count LOOP
                                    l_msg_return := l_msg_return||' - '||FND_MSG_PUB.GET( P_MSG_INDEX => l_index
                                                                                        , P_ENCODED   => 'F' );
                                END LOOP;
                             ELSE
                                l_msg_return := 'Pick Confirm Move Order - Linha '||r_lines.line_number||' - '||x_msg_data;
                             END IF;

                             BEGIN
                                UPDATE wsh_delivery_details
                                  SET seal_code = 'ERRO'
                                WHERE split_from_delivery_detail_id = r_lines.delivery_detail_id
                                  AND released_status = 'S';
                             EXCEPTION
                                WHEN no_data_found THEN
                                    null;
                                WHEN others THEN
                                    null;
                             END;

                             --Raise l_saida;
                          ELSE
                             l_debug := 10;

                             BEGIN
                                UPDATE wsh_delivery_details
                                  SET seal_code = 'SEPCONFIRM'
                                WHERE delivery_detail_id = r_lines.delivery_detail_id
                                  AND released_status = 'Y';
                             EXCEPTION
                                WHEN no_data_found THEN
                                    null;
                                WHEN others THEN
                                    null;
                             END;

                             BEGIN
                                UPDATE wsh_delivery_details
                                  SET seal_code = 'BACK'
                                WHERE split_from_delivery_detail_id = r_lines.delivery_detail_id
                                  AND released_status = 'B';
                             EXCEPTION
                                WHEN no_data_found THEN
                                    null;
                                WHEN others THEN
                                    null;
                             END;

                          END IF;

                      ELSE

                          l_backorder := p_backorder_line(r_lines.move_order_line_id, l_error_msg,'Y');
                          FND_FILE.put_line(FND_FILE.log,'Backorder realizado para Linha: '||r_lines.line_number||' - Detalhe: '||r_lines.delivery_detail_id||' Qtde: '||r_lines.Quantity);

                          BEGIN
                            update apps.wsh_delivery_details
                               set seal_code = 'BACK'
                             where delivery_detail_id = r_lines.delivery_detail_id;
                          EXCEPTION
                            WHEN no_data_found THEN
                              null;
                            WHEN others THEN
                              null;
                          END;

                      END IF;

                   END IF;
               --
           END LOOP;
           --
           l_debug := 13;

           -- Processar Move Order das diferenca de quantidade
           /*IF l_line_index > 0 THEN
              Fnd_msg_pub.Delete_Msg(Null);
              l_debug := 14;

              Inv_Move_Order_Pub.Process_Move_Order ( p_api_version_number => 1.0
                                                    , p_init_msg_list      => fnd_api.g_true
                                                    , p_return_values      => fnd_api.g_false
                                                    , p_commit             => fnd_api.g_false
                                                    , x_return_status      => l_return_status
                                                    , x_msg_count          => l_msg_count
                                                    , x_msg_data           => l_msg_data
                                                    , p_trohdr_rec         => l_hdr_rec
                                                    , p_trolin_tbl         => l_line_tbl
                                                    , x_trohdr_rec         => x_hdr_rec
                                                    , x_trohdr_val_rec     => x_hdr_val_rec
                                                    , x_trolin_tbl         => l_trolin_out_tbl
                                                    , x_trolin_val_tbl     => x_line_val_tbl );

              IF l_return_status = FND_API.G_RET_STS_ERROR OR
                 l_return_status = FND_API.G_RET_STS_UNEXP_ERROR THEN
                 l_debug := 15;
                 IF l_msg_count > 0 THEN
                    l_debug := 16;
                    l_msg_return := 'Delivery: '||r_deliv.delivery_name||' - Process_Move_Order: ';
                    FOR l_index IN 1..l_msg_count LOOP
                        l_msg_return := l_msg_return||' - '||FND_MSG_PUB.GET( P_MSG_INDEX => l_index
                                                                            , P_ENCODED   => 'F' );
                    END LOOP;
                 ELSE
                    l_debug := 17;
                    l_msg_return := l_msg_data;
                 END IF;
                 Raise l_saida;
              ELSE
                 IF x_hdr_rec.header_id IS NOT NULL THEN
                    Fnd_file.put_line(fnd_file.output, '  Move Order "'||x_hdr_rec.request_number||'" criada referente diferen?de quantidade de linhas.');
                    l_debug := 18;
                    FOR x_lines IN ( SELECT line_id, line_number, quantity
                                       FROM mtl_txn_request_lines
                                      WHERE header_id = x_hdr_rec.header_id ) LOOP
                        -- Allocate each line of the New Move Order
                        l_debug := 15;
                        Fnd_msg_pub.Delete_Msg(Null);
                        inv_replenish_detail_pub.line_details_pub ( p_line_id               => x_lines.line_id
                                                                  , x_number_of_rows        => x_number_of_rows
                                                                  , x_detailed_qty          => x_lines.quantity
                                                                  , x_return_status         => x_return_status
                                                                  , x_msg_count             => x_msg_count
                                                                  , x_msg_data              => x_msg_data
                                                                  , x_revision              => x_revision
                                                                  , x_locator_id            => x_locator_id
                                                                  , x_transfer_to_location  => x_transfer_to_location
                                                                  , x_lot_number            => x_lot_number
                                                                  , x_expiration_date       => x_expiration_date
                                                                  , x_transaction_temp_id   => x_transaction_temp_id
                                                                  , p_transaction_header_id => NULL
                                                                  , p_transaction_mode      => NULL
                                                                  , p_move_order_type       => inv_globals.g_move_order_requisition
                                                                  , p_serial_flag           => fnd_api.g_false
                                                                  , p_plan_tasks            => FALSE
                                                                  , p_auto_pick_confirm     => FALSE
                                                                  , p_commit                => FALSE
                                                                  );

                        IF x_return_status <> fnd_api.g_ret_sts_success THEN
                           IF x_msg_count > 0 THEN
                              l_msg_return := 'Allocate Line New Move Order - Linha '||x_lines.line_number;
                              FOR l_index IN 1..x_msg_count LOOP
                                  l_msg_return := l_msg_return||' - '||FND_MSG_PUB.GET( P_MSG_INDEX => l_index
                                                                                      , P_ENCODED   => 'F' );
                              END LOOP;
                           ELSE
                              l_msg_return := 'Allocate Line New Move Order - Linha '||x_lines.line_number||' - '||x_msg_data;
                           END IF;
                           Raise l_saida;
                        ELSE
                           Fnd_msg_pub.Delete_Msg(Null);
                           l_debug                    := 19;
                           a_l_trolin_tbl (1).line_id := x_lines.line_id;
                           v_transaction_date         := Sysdate;

                           Fnd_msg_pub.Delete_Msg(Null);
                           inv_pick_wave_pick_confirm_pub.pick_confirm ( p_api_version_number => a_l_api_version
                                                                       , p_init_msg_list      => a_l_init_msg_list
                                                                       , p_commit             => a_l_commit
                                                                       , x_return_status      => a_x_return_status
                                                                       , x_msg_count          => a_x_msg_count
                                                                       , x_msg_data           => a_x_msg_data
                                                                       , p_move_order_type    => a_l_move_order_type
                                                                       , p_transaction_mode   => a_l_transaction_mode
                                                                       , p_trolin_tbl         => a_l_trolin_tbl
                                                                       , p_mold_tbl           => a_l_mold_tbl
                                                                       , x_mmtt_tbl           => a_x_mmtt_tbl
                                                                       , x_trolin_tbl         => a_x_trolin_tbl
                                                                       , p_transaction_date   => v_transaction_date
                                                                       );

                           IF a_x_return_status <> fnd_api.g_ret_sts_success THEN
                              IF a_x_msg_count > 0 THEN
                                 l_msg_return := 'Pick Confirm New Move Order - Linha '||x_lines.line_number;
                                 FOR l_index IN 1..a_x_msg_count LOOP
                                     l_msg_return := l_msg_return||' - '||FND_MSG_PUB.GET( P_MSG_INDEX => l_index
                                                                                         , P_ENCODED   => 'F' );
                                 END LOOP;
                              ELSE
                                 l_msg_return := 'Pick Confirm New Move Order - Linha '||x_lines.line_number||' - '||x_msg_data;
                              END IF;
                              Raise l_saida;
                           END IF;
                        END IF;
                    END LOOP;
                 END IF;
              END IF;
           END IF;*/

           --
           l_debug := 20;
           --
           UPDATE wsh_new_deliveries
              SET attribute8 = '252'
            WHERE delivery_id = r_deliv.delivery_id;
           --
           UPDATE integracao
              SET estadointegracao = 2
            WHERE SequenciaIntegracao = r_deliv.SequenciaIntegracao;
           --
           -- Gravando Historico Integracao
           g_integracao_hist_tbl_type(1).sequenciaintegracao  := l_sequenciaIntegracao;
           g_integracao_hist_tbl_type(1).detalhehistorico     := 'Integrado.';
           --
           -- insere historico
           XXPPG_INV_WMAS_PUB_PKG.create_wmas_records( p_integracao_tbl            => g_integracao_tbl_type
                                                     , p_integracao_hist_tbl       => g_integracao_hist_tbl_type
                                                     , p_documento_tbl             => g_documento_tbl_type
                                                     , p_documento_detalhe_tbl     => g_documentodetalhe_tbl_type
                                                     , p_documento_detalhe_seq_tbl => g_documentodetalheseq_tbl_type
                                                     , p_movimento_estoque_tbl     => g_movimentoestoque_tbl_type
                                                     , p_produto_tbl               => g_produto_tbl_type
                                                     , p_TipoUC_tbl                => g_TipoUC_tbl_type
                                                     , p_SequencialIntegracao      => l_sequenciaIntegracao
                                                     , p_return_status             => l_return_status
                                                     , p_msg_data                  => l_msg_data);
           --
           COMMIT;
           --
           --UPDATE wsh_delivery_details
           --   SET seal_code = 'SEPCONFIRM'
           -- WHERE delivery_detail_id IN ( SELECT wdv.delivery_detail_id
           --                                 FROM wsh_deliverables_v wdv
           --                                WHERE wdv.delivery_id = r_deliv.delivery_id )
           --   AND released_status = 'Y'
           --   AND seal_code <> 'SEPCONFIRM';

           --
           --COMMIT;
           --
        EXCEPTION
            WHEN l_saida THEN
                 --
                 --l_debug := 21;
                 --
                 Fnd_file.put_line(fnd_file.output, 'Erro: '||l_msg_return);
                 ROLLBACK;
                 --
                 UPDATE integracao
                    SET estadointegracao = 3
                  WHERE sequenciaintegracao = l_sequenciaIntegracao;

                 -- Gravando Historico Integracao
                 g_integracao_hist_tbl_type(1).sequenciaintegracao  := l_sequenciaIntegracao;
                 g_integracao_hist_tbl_type(1).detalhehistorico     := SUBSTR(REPLACE(REPLACE(l_msg_return,chr(10),' '),chr(13),' '),1,180);
                 --
                 -- insere historico
                 XXPPG_INV_WMAS_PUB_PKG.create_wmas_records( p_integracao_tbl            => g_integracao_tbl_type
                                                           , p_integracao_hist_tbl       => g_integracao_hist_tbl_type
                                                           , p_documento_tbl             => g_documento_tbl_type
                                                           , p_documento_detalhe_tbl     => g_documentodetalhe_tbl_type
                                                           , p_documento_detalhe_seq_tbl => g_documentodetalheseq_tbl_type
                                                           , p_movimento_estoque_tbl     => g_movimentoestoque_tbl_type
                                                           , p_produto_tbl               => g_produto_tbl_type
                                                           , p_TipoUC_tbl                => g_TipoUC_tbl_type
                                                           , p_SequencialIntegracao      => l_sequenciaIntegracao
                                                           , p_return_status             => l_return_status
                                                           , p_msg_data                  => l_msg_data);
                 --
                 COMMIT;
                 --
                 p_retcode := 1;
                 --
        END;

    END LOOP;
  EXCEPTION
     WHEN others THEN
          p_retcode  := 1;
          p_msg_erro := 'Erro na rotina Confirma? de Embarque - Debug '||l_debug||' - Delivery Id: '||l_delivery_id||' - '||SqlErrm;
          Return;

  END Confirma_Entrega_P_New;

  --  +=====================================================================+
  --  | DESCRIPTION                                                         |
  --  |    Gap 82.11 - Integra? Solicita? de Materiais - Outbound       |
  --  |                                                                     |
  --  | HISTORY                                                             |
  --  |    18-Jun-2014     Sergio Joviano     Cria? da rotina.            |
  --  |    02-Dez-2014     Renato Furlan      Tratar NVL no subinv. destino |
  --  |                                       na cl?ula where.            |
  --  |                                                                     |
  --  +=====================================================================+
  PROCEDURE Solicitacao_Material_P (p_msg_erro OUT VARCHAR2)
  IS

  CURSOR c_doc (pc_org_id In Number) IS
      SELECT mp.attribute7                CODIGOESTABELECIMENTO
           , 'SM'                         TIPODOCUMENTO
           , 'WMS'                        SERIEDOCUMENTO
           , mtrh.request_number          NUMERODOCUMENTO
           , 'SM'                         MODELODOCUMENTO
           , mp.attribute7                CODIGOEMPRESA
           , mp.attribute7                CODIGODEPOSITANTE
           , '0000'                       NATUREZAOPERACAO
           , 'SEM VALOR FISCAL'           DESCRICAONATUREZAOPERACAO
           , TRUNC(mtrl.date_required)    DATAEMISSAO
           , TRUNC(mtrl.date_required)    DATAPREVISAOMOVIMENTO
           , msi.attribute2               ENDERECODOCA
           , mtrl.header_id               AGRUPADOR
           , mtrh.request_number          INFORMACAOADICIONAL1
           , NULL                         INFORMACAOADICIONAL2
           , NULL                         INFORMACAOADICIONAL3
           , 1                            INIBIRFRACIONAMENTO   --- 1 = SIM
           , mtrl.request_number
           , mtrl.date_required
           , haou.name                    ORG_NAME
           , msib.segment1                CODIGOPRODUTO
           , UPPER(msib.primary_uom_code) TIPOUC
           , 1                            FATORTIPOUC
           , mtrl.from_subinventory_code  CLASSEPRODUTO
           , abs(mtrl.quantity)           QUANTIDADEMOVIMENTO
           , 1                            VALORUNITARIO
           , mtrh.header_id
           , mtrl.line_id
           , mtrl.line_number
           , mtrl.from_subinventory_code
           , mtrl.to_subinventory_code
       FROM mtl_secondary_inventories    msi
          , mtl_parameters               mp
          , hr_all_organization_units    haou
          , org_organization_definitions ood
          , mtl_txn_request_lines_v      mtrl
          , mtl_txn_request_headers      mtrh
          , mtl_system_items_b           msib
      WHERE mtrl.from_subinventory_code  = msi.secondary_inventory_name
        AND mtrl.organization_id         = msi.organization_id
        AND msi.attribute2               IS NOT NULL
        AND NVL(mtrl.attribute15,'N')    = 'N'            -- ainda n?interfaceada
        AND mp.organization_id           = mtrl.organization_id
        AND haou.organization_id         = mp.organization_id
        AND haou.organization_id         = ood.organization_id
        AND mtrh.header_id               = mtrl.header_id
        AND msib.inventory_item_id       = mtrl.inventory_item_id
        AND msib.organization_id         = mtrl.organization_id
        AND mtrl.from_subinventory_code IS NOT NULL
        AND NVL(mtrl.to_subinventory_code,'x') <> 'REC'
        AND mtrh.header_status           = 3             --- Aprovada
        AND ood.operating_unit           = pc_org_id
      ORDER BY mtrl.header_id, mtrl.line_id;

    l_g_integracao_tbl_type           xxppg_inv_wmas_pub_pkg.g_integracao_tbl_type;
    l_integracao_hist_tbl_type        xxppg_inv_wmas_pub_pkg.g_integracao_hist_tbl_type;
    l_g_documento_tbl_type            xxppg_inv_wmas_pub_pkg.g_documento_tbl_type;
    l_g_documentodetalhe_tbl_type     xxppg_inv_wmas_pub_pkg.g_documentodetalhe_tbl_type;
    l_documentodetalheseq_tbl_type    xxppg_inv_wmas_pub_pkg.g_documentodetalheseq_tbl_type;
    l_movimentoestoque_tbl_type       xxppg_inv_wmas_pub_pkg.g_movimentoestoque_tbl_type;
    l_produto_tbl_type                xxppg_inv_wmas_pub_pkg.g_produto_tbl_type;
    l_TipoUC_tbl_type                 xxppg_inv_wmas_pub_pkg.g_TipoUC_tbl_type;

    l_org_id                    NUMBER := Fnd_Profile.Value('ORG_ID');
    l_seq_doc                   NUMBER := 0;
    l_seq_doc_det               NUMBER := 0;
    l_index_det                 NUMBER := 0;
    l_header_id_ant             NUMBER := 0;
    l_request_number            mtl_txn_request_headers.request_number%TYPE;
    l_SequencialIntegracao      NUMBER;
    l_return_status             VARCHAR2(32767);
    l_msg_data                  VARCHAR2(32767);
    l_debug                     VARCHAR2(1000);

    l_saida_erro                Exception;

    PROCEDURE do_log_p(p_msg IN VARCHAR2)
    IS
    BEGIN
      --
      DBMS_OUTPUT.PUT_LINE(p_msg);
      --htp.p(p_msg);
      FND_FILE.PUT_LINE(FND_FILE.OUTPUT, p_msg);
      --
    END do_log_p;

BEGIN

  do_log_p(p_msg => '****************************************************************************** ');
  do_log_p(p_msg => 'Solicita? de materiais ao WMS');
  do_log_p(p_msg => '****************************************************************************** ');
  do_log_p(p_msg => ' Nro. Ordem      Organizacao               Item            Quantidade      Subinv. Origem  Subinv. Destino Data');
  do_log_p(p_msg => ' --------------- ------------------------- --------------- --------------- --------------- --------------- ----------------------');

  FOR r_doc IN c_doc (pc_org_id => l_org_id) LOOP
    --
    l_request_number := r_doc.NumeroDocumento;
    --
    IF l_header_id_ant <> r_doc.header_id THEN

       -- Processa Documento Anterior
       IF l_header_id_ant <> 0 THEN
          XXPPG_INV_WMAS_PUB_PKG.Create_wmas_records ( p_integracao_tbl             => l_g_integracao_tbl_type
                                                     , p_integracao_hist_tbl        => l_integracao_hist_tbl_type
                                                     , p_documento_tbl              => l_g_documento_tbl_type
                                                     , p_documento_detalhe_tbl      => l_g_documentodetalhe_tbl_type
                                                     , p_documento_detalhe_seq_tbl  => l_documentodetalheseq_tbl_type
                                                     , p_movimento_estoque_tbl      => l_movimentoestoque_tbl_type
                                                     , p_produto_tbl                => l_produto_tbl_type
                                                     , p_TipoUC_tbl                 => l_TipoUC_tbl_type
                                                     , p_SequencialIntegracao       => l_SequencialIntegracao
                                                     , p_return_status              => l_return_status
                                                     , p_msg_data                   => l_msg_data);

          IF l_return_status = 'E' THEN
             do_log_p(p_msg => ' ');
             do_log_p(p_msg => 'Sequencial Integracao.: ');
             do_log_p(p_msg => 'Status................: ' || 'ERRO');
             do_log_p(p_msg => 'Mensagem..............: ' || l_msg_data);
             do_log_p(p_msg => ' ');
             do_log_p(p_msg => ' ');
             ROLLBACK;
             Raise l_saida_Erro;
          ELSE
             do_log_p(p_msg => ' ');
             do_log_p(p_msg => 'Sequencial Integracao.: ' || l_SequencialIntegracao);
             do_log_p(p_msg => 'Status................: ' || 'Integrado com Sucesso');
             do_log_p(p_msg => ' ');
             do_log_p(p_msg => ' ');
             COMMIT;
          END IF;
       END IF;

       l_g_integracao_tbl_type.delete;
       l_integracao_hist_tbl_type.delete;
       l_g_documento_tbl_type.delete;
       l_g_documentodetalhe_tbl_type.delete;
       l_documentodetalheseq_tbl_type.delete;
       l_movimentoestoque_tbl_type.delete;
       l_produto_tbl_type.delete;
       l_TipoUC_tbl_type.delete;

       -- Coletando dados para INTEGRACAO
       l_g_integracao_tbl_type(1).TipoIntegracao         := 203;
       l_g_integracao_tbl_type(1).EstadoIntegracao       := 1;
       l_g_integracao_tbl_type(1).SequenciaRelacionada   := 0;

       -- Coletando dados para DOCUMENTO
       l_debug                                                      := 'Documento';
       l_seq_doc                                                    := 1;
       l_seq_doc_det                                                := 0;
       l_index_det                                                  := 0;
       l_header_id_ant                                              := r_doc.header_id;
       l_g_documento_tbl_type(l_seq_doc).sequenciaDocumento         := l_seq_doc ;
       l_debug                                                      := 'Documento - CodigoEstabelecimento';
       l_g_documento_tbl_type(l_seq_doc).codigoEstabelecimento      := r_doc.codigoEstabelecimento ;
       l_debug                                                      := 'Documento - tipoDocumento';
       l_g_documento_tbl_type(l_seq_doc).tipoDocumento              := r_doc.tipoDocumento ;
       l_debug                                                      := 'Documento - serieDocumento';
       l_g_documento_tbl_type(l_seq_doc).serieDocumento             := r_doc.serieDocumento ;
       l_debug                                                      := 'Documento - numeroDocumento';
       l_g_documento_tbl_type(l_seq_doc).numeroDocumento            := r_doc.numeroDocumento ;
       l_debug                                                      := 'Documento - modeloDocumento ';
       l_g_documento_tbl_type(l_seq_doc).modeloDocumento            := r_doc.modeloDocumento ;
       l_debug                                                      := 'Documento - codigoEmpresa';
       l_g_documento_tbl_type(l_seq_doc).codigoEmpresa              := r_doc.codigoEmpresa ;
       l_debug                                                      := 'Documento - codigodepositante ';
       l_g_documento_tbl_type(l_seq_doc).codigodepositante          := r_doc.codigodepositante ;
       l_debug                                                      := 'Documento - naturezaOperacao ';
       l_g_documento_tbl_type(l_seq_doc).naturezaOperacao           := r_doc.naturezaOperacao ;
       l_debug                                                      := 'Documento - descricaoNaturezaOperacao';
       l_g_documento_tbl_type(l_seq_doc).descricaoNaturezaOperacao  := r_doc.descricaoNaturezaOperacao ;
       l_debug                                                      := 'Documento - dataEmissao ';
       l_g_documento_tbl_type(l_seq_doc).dataEmissao                := r_doc.dataEmissao ;
       l_debug                                                      := 'Documento - dataPrevisaoMovimento';
       l_g_documento_tbl_type(l_seq_doc).dataPrevisaoMovimento      := r_doc.dataPrevisaoMovimento ;
       l_debug                                                      := 'Documento - enderecoDoca ';
       l_g_documento_tbl_type(l_seq_doc).enderecoDoca               := r_doc.enderecoDoca ;
       l_debug                                                      := 'Documento - agrupador ';
       l_g_documento_tbl_type(l_seq_doc).agrupador                  := r_doc.agrupador ;
       l_debug                                                      := 'Documento - informacaoAdicional1 ';
       l_g_documento_tbl_type(l_seq_doc).informacaoAdicional1       := r_doc.informacaoAdicional1 ;
       l_debug                                                      := 'Documento - informacaoAdicional2';
       l_g_documento_tbl_type(l_seq_doc).informacaoAdicional2       := r_doc.informacaoAdicional2 ;
       l_g_documento_tbl_type(l_seq_doc).informacaoAdicional3       := r_doc.informacaoAdicional3 ;
       l_debug                                                      := 'Documento - inibirFracionamento';
       l_g_documento_tbl_type(l_seq_doc).inibirFracionamento        := r_doc.inibirFracionamento ;
       --
    END IF;

    -- Coletando dados para DOCUMENTODETALHE
    l_debug                                                               := 'DocumentoDetalhe';
    l_seq_doc_det                                                         := l_seq_doc_det + 1;
    l_index_det                                                           := l_index_det + 1;
    l_g_documentodetalhe_tbl_type(l_index_det).SequenciaDocumento         := l_seq_doc;
    l_g_documentodetalhe_tbl_type(l_index_det).SequenciaDetalhe           := l_seq_doc_det ;
    l_debug                                                               := 'DocumentoDetalhe - CodigoEmpresa';
    l_g_documentodetalhe_tbl_type(l_index_det).codigoEmpresa              := r_doc.codigoEmpresa ;
    l_debug                                                               := 'DocumentoDetalhe - codigoProduto';
    l_g_documentodetalhe_tbl_type(l_index_det).codigoProduto              := r_doc.codigoProduto ;
    l_debug                                                               := 'DocumentoDetalhe - tipoUC';
    l_g_documentodetalhe_tbl_type(l_index_det).tipoUC                     := r_doc.tipoUC ;
    l_debug                                                               := 'DocumentoDetalhe - fatorTipoUC';
    l_g_documentodetalhe_tbl_type(l_index_det).fatorTipoUC                := r_doc.fatorTipoUC ;
    l_debug                                                               := 'DocumentoDetalhe - classeProduto';
    l_g_documentodetalhe_tbl_type(l_index_det).classeProduto              := r_doc.classeProduto ;
    l_debug                                                               := 'DocumentoDetalhe - quantidadeMovimento';
    l_g_documentodetalhe_tbl_type(l_index_det).quantidadeMovimento        := r_doc.quantidadeMovimento ;
    l_debug                                                               := 'DocumentoDetalhe - valorUnitario';
    l_g_documentodetalhe_tbl_type(l_index_det).valorUnitario              := r_doc.valorUnitario ;
    l_debug                                                               := 'DocumentoDetalhe - informacaoAdicional1';
    l_g_documentodetalhe_tbl_type(l_index_det).informacaoAdicional1       := r_doc.informacaoAdicional1 ;
    l_debug                                                               := 'DocumentoDetalhe - OrdemSeparacao';
    l_g_documentodetalhe_tbl_type(l_index_det).OrdemSeparacao             := r_doc.request_number;
    l_debug                                                               := 'Documento_Detalhe - NumeroPedidoSeparacao';
    l_g_documentodetalhe_tbl_type(l_index_det).NumeroPedidoSeparacao      := TO_CHAR(r_doc.line_number);
    --
    do_log_p(p_msg => ' ' ||
                      rpad(r_doc.request_number, 15, ' ')         ||' '||
                      rpad(r_doc.org_name, 25, ' ')               ||' '||
                      rpad(r_doc.codigoproduto, 15, ' ')          ||' '||
                      rpad(r_doc.quantidadeMovimento, 15, ' ')    ||' '||
                      rpad(r_doc.from_subinventory_code, 15, ' ') ||' '||
                      rpad(r_doc.to_subinventory_code, 15, ' ')   ||' '||
                      rpad(to_char(r_doc.date_required, 'DD-MON-RRRR HH24:MI:SS'), 28, ' ')
                      );
    --
    UPDATE mtl_txn_request_lines
       SET attribute15 = 'Y'
     WHERE line_id = r_doc.line_id;
    --
  END LOOP;
  --

  -- Processando Ultimo documento
  IF l_seq_doc > 0 THEN
    XXPPG_INV_WMAS_PUB_PKG.Create_wmas_records ( p_integracao_tbl             => l_g_integracao_tbl_type
                                               , p_integracao_hist_tbl        => l_integracao_hist_tbl_type
                                               , p_documento_tbl              => l_g_documento_tbl_type
                                               , p_documento_detalhe_tbl      => l_g_documentodetalhe_tbl_type
                                               , p_documento_detalhe_seq_tbl  => l_documentodetalheseq_tbl_type
                                               , p_movimento_estoque_tbl      => l_movimentoestoque_tbl_type
                                               , p_produto_tbl                => l_produto_tbl_type
                                               , p_TipoUC_tbl                 => l_TipoUC_tbl_type
                                               , p_SequencialIntegracao       => l_SequencialIntegracao
                                               , p_return_status              => l_return_status
                                               , p_msg_data                   => l_msg_data);

    IF l_return_status = 'E' THEN
       do_log_p(p_msg => ' ');
       do_log_p(p_msg => 'Sequencial Integracao.: ');
       do_log_p(p_msg => 'Status................: ' || 'ERRO');
       do_log_p(p_msg => 'Mensagem..............: ' || l_msg_data);
       do_log_p(p_msg => ' ');
       do_log_p(p_msg => ' ');
       ROLLBACK;
       Raise l_saida_Erro;
    ELSE
       do_log_p(p_msg => ' ');
       do_log_p(p_msg => 'Sequencial Integracao.: ' || l_SequencialIntegracao);
       do_log_p(p_msg => 'Status................: ' || 'Integrado com Sucesso');
       do_log_p(p_msg => ' ');
       do_log_p(p_msg => ' ');
       COMMIT;
    END IF;

   END IF;

   do_log_p(p_msg => ' ');
   do_log_p(p_msg => '____ FIM __________________________________________________________________________________________________________________________________');
   do_log_p(p_msg => ' ');

  EXCEPTION
     WHEN l_saida_erro THEN
          p_msg_erro := 'Rotina Separa? Materiais - '||l_msg_data;
          Return;
     WHEN others THEN
          p_msg_erro := 'Erro na rotina Solicita? de Materiais - Debug: '||l_debug||' - Request Number: '||l_request_number||' - '||SqlErrm;
          Return;
  END Solicitacao_Material_P;

  --  +=====================================================================+
  --  | DESCRIPTION                                                         |
  --  |    Gap 82.9 - Envio de Ordens de Produ? para Separa?            |
  --  |                                                                     |
  --  | HISTORY                                                             |
  --  |    05-Set-2014     Sergio Joviano    Cria? da rotina.             |
  --  |    06-Nov-2014     Graciano Santos   #02-Ajuste conforme necessidade|
  --  |                                      para a integra? GAP 81.4     |
  --  |    05-Dez-2014     Renato Furlan     #03-RCR - Tratamento do campo  |
  --  |                                      INIBIRFRACIONAMENTO.           |
  --  |                                                                     |
  --  +=====================================================================+
  PROCEDURE Send_Ordem_Prod_Separacao_P ( p_msg_erro OUT VARCHAR2 )
  IS
    --
    l_subinv_wmas      VARCHAR2(45)  := FND_PROFILE.VALUE('XXPPG_SUBINV_WMAS') ;
    l_endereco_doca    VARCHAR2(140) ;
    l_inibirfrac       NUMBER;
    --
    CURSOR c_doc IS
     SELECT DISTINCT * FROM (
     SELECT mp.attribute7                           CODIGOESTABELECIMENTO
          , mp.attribute7                           CODIGODEPOSITANTE
          , haou.name                               ORG_NAME
          , hla.address_line_1||hla.address_line_2  ENDERECO
          , hla.region_1                            BAIRRO
          , hla.town_or_city                        CIDADE
          , hla.region_2                            ESTADO
          , hla.postal_code                         CEP
          , cffe.document_number                    CNPJCPFDEPOSITANTE
          , cffe.ie                                 INSCRICAOESTADUAL
          , '1'||NVL(SUBSTR(mc.segment2,1, 1), 'N')
                 ||gbh.attribute5                     TIPODOCUMENTO
          , gbh.batch_no                            NUMERODOCUMENTO
          , 'OF'                                    MODELODOCUMENTO
          , '0000'                                  NATUREZAOPERACAO
          , 'SEM VALOR FISCAL'                      DESCRICAONATUREZAOPERACAO
          , to_char(sysdate, 'DD/MM/RRRR')          DATAEMISSAO
          , to_char(sysdate, 'DD/MM/RRRR')          DATAPREVISAOMOVIMENTO
          , mp.attribute7                           CODIGOEMPRESA
          , msib.segment1                           CODIGOPRODUTO
          , UPPER(msib.primary_uom_code)            TIPOUC
          , 1                                       FATORTIPOUC
          , msi.secondary_inventory_name            CLASSEPRODUTO
          , xx.qtde                                 QUANTIDADEMOVIMENTO
          , 0                                       VALORUNITARIO
          , xx.repete                               INFORMACAOADICIONAL1
          , cffe.document_number                    CNPJ_ESTABELECIMENTO
          , mp.attribute7                           Cod_Estabelecimento
-- #01    , xx.atividade                            ATIVIDADE
          , LPAD(xx.atividade, 3, '0')              ATIVIDADE
          , xx.item                                 ITEM
          , xx.qtde                                 QTDE
          , NVL(xx.repete,1)                        REPETE
          , gbh.batch_no
          , gr.recipe_no
          , frh.routing_id
          , gr.recipe_id
          , NVL(xx.repete, '1')                    "Repeticoes de etapa"
          , SUBSTR(NVL(mc.segment2, 'N'), 1, 1)    tipoProduto
          , haou.location_id
          , gbh.batch_id
          , gmd.material_detail_id
          , msi.attribute2                         ENDERECODOCA
          , mp.organization_id
          , frh.routing_class
       FROM org_organization_definitions ood
          , hr_all_organization_units    haou
          , mtl_item_categories          mic
          , mtl_categories_b             mc
          , mtl_category_sets_vl         mcs
          , mtl_system_items_b           msib
          , mtl_parameters               mp
          , cll_f189_fiscal_entities_all cffe
          , hr_locations_all             hla
          , gme_material_details         gmd -- detalhes da OP
          , gme_batch_header             gbh -- cabe?ho da OP
          , fm_form_mst_vl               fmmv
          , gmd_recipes                  gr
          , gmd_recipe_validity_rules    grvr
          , fm_rout_hdr                  frh
          , fm_rout_dtl                  frd
          , gmf_organization_definitions god
          , mtl_secondary_inventories    msi
          , ( -- INI Ajuste solicitado por Dalmir Bohn
            SELECT frd.routingstep_no    etapa
                 , frd.routingstep_no    atividade
                 , msi.segment1          item
                 , md.wip_plan_qty       qtde--md.plan_qty    qtde md.plan_qty       qtde
                 , grs.attribute1        repete
                 , gbh.batch_id
                 , msi.inventory_item_id id_item
                 , md.material_detail_id
             FROM  mtl_system_items_b               msi
                 , gme_material_details             md
                 , gme_batch_header                 gbh
                 , gmd_recipe_validity_rules        grv
                 , gme_batch_step_activities        gba
                 , gme_batch_steps                  gbs
                 , gmd_recipes                      grr
                 , gmd_operation_activities         goa
                 , gme_batch_step_items             grs
                 , gmd_operations_b                 gob
               --, gmd_recipe_step_materials        grsm
                 , fm_rout_dtl                      frd
               --, fm_rout_hdr                      frh
                 , fm_matl_dtl                      fmd
             WHERE 1=1
               AND msi.inventory_item_id            = md.inventory_item_id
               AND msi.organization_id              = md.organization_id
               AND  md.batch_id                     = gbh.batch_id
               AND grv.recipe_validity_rule_id (+)  = gbh.recipe_validity_rule_id
               AND gbh.batch_id                     = gba.batch_id
               AND gbs.batch_id                     = gba.batch_id
               AND gbs.batchstep_id                 = gba.batchstep_id
               AND grr.recipe_id                    = grv.recipe_id
               AND grr.formula_id                   = gbh.formula_id
               AND grr.routing_id                   = gbh.routing_id
               AND gbs.oprn_id                      = goa.oprn_id
               AND gba.oprn_line_id                 = goa.oprn_line_id
               AND md.material_detail_id            = grs.material_detail_id
               AND gbh.batch_id                     = grs.batch_id
               AND gbs.batchstep_id                 = grs.batchstep_id
               AND gob.oprn_id                      = gbs.oprn_id
             --AND grsm.recipe_id                   = grv.recipe_id
             --AND grsm.routingstep_id              = gbs.routingstep_id
               AND frd.routing_id                   = grr.routing_id
               AND frd.routingstep_id               = gbs.routingstep_id
               AND frd.oprn_id                      = gbs.oprn_id
             --AND frh.routing_id                   = frd.routing_id
             --AND fmd.formula_id                   = gbh.formula_id
             --AND fmd.formulaline_id               = grsm.formulaline_id (+)
             --AND fmd.inventory_item_id            = msi.inventory_item_id
             --AND fmd.organization_id              = msi.organization_id
               AND md.formulaline_id                = fmd.formulaline_id (+)
               AND md.line_type                     = -1
               AND gbh.batch_status                 = 2
             ORDER BY frd.routingstep_no
          ) xx
          /*, (
            SELECT frd.routingstep_no    etapa
-- #01           , goa.activity          atividade
                 , frd.routingstep_no    atividade  -- #01
                 , msi.segment1          item
                 , md.plan_qty           qtde
                 , grs.attribute1        repete
                 , gbh.batch_id
                 , msi.inventory_item_id id_item
                 , md.material_detail_id
              FROM fm_rout_hdr               frh
                 , fm_rout_dtl               frd
                 , gmd_operations_b          gob
                 , gmd_operation_activities  goa
                 , gmd_recipes               grr
                 , gme_batch_header          gbh
                 , gmd_recipe_step_materials grs
                 , gmd_recipe_validity_rules grv
                 , gme_material_details      md
                 , fm_matl_dtl               fmd
                 , mtl_system_items          msi
             WHERE frh.routing_id              = frd.routing_id
               AND gob.oprn_id                 = frd.oprn_id
               AND goa.oprn_id                 = gob.oprn_id
               AND grr.recipe_id               = grs.recipe_id
               AND frh.routing_id              = grr.routing_id
               AND grs.routingstep_id          = frd.routingstep_id
               AND gbh.routing_id              = frh.routing_id
               AND grv.recipe_validity_rule_id = gbh.recipe_validity_rule_id
               AND grr.recipe_id               = grv.recipe_id
               AND fmd.formula_id              = grr.formula_id
               AND grs.formulaline_id          = fmd.formulaline_id
               AND msi.inventory_item_id       = fmd.inventory_item_id
               AND msi.organization_id         = fmd.organization_id
               AND md.batch_id                 = gbh.batch_id
               AND md.formulaline_id           = fmd.formulaline_id
               AND md.line_type                = -1
               AND gbh.batch_status            = 2
             ORDER BY frd.routingstep_no       ) xx*/  -- FIM Ajuste solicitado por Dalmir Bohn
      WHERE ood.operating_unit              = FND_PROFILE.value('ORG_ID')
        AND haou.organization_id            = ood.organization_id
        AND mp.organization_id              = haou.organization_id
        AND haou.organization_id            = gbh.organization_id
        AND cffe.location_id                = haou.location_id
        AND cffe.entity_type_lookup_code    = 'LOCATION'
        AND hla.location_id                 = haou.location_id
        AND msib.inventory_item_id          = gmd.inventory_item_id
        AND msib.organization_id            = gmd.organization_id
        AND mc.segment1                     = 'WMAS'
        AND mcs.category_set_name           = 'FAMILIA ARMAZENAGEM'
        AND mic.category_set_id             = mcs.category_set_id
        AND mic.category_id                 = mc.category_id
        AND Msib.Organization_Id            = Mic.Organization_Id
        AND xx.id_item                      = Mic.Inventory_Item_Id
        AND msi.secondary_inventory_name(+) = gmd.subinventory
        AND msi.organization_id         (+) = gmd.organization_id
        AND gmd.line_type                   = -1
        AND gmd.batch_id                    = gbh.batch_id
        AND gmd.material_detail_id          = xx.material_detail_id
        AND gbh.recipe_validity_rule_id     = grvr.recipe_validity_rule_id (+)
        AND gr.recipe_id                (+) = grvr.recipe_id
        AND gr.formula_id                   = fmmv.formula_id              (+)
        AND gr.routing_id                   = frh.routing_id               (+)
        AND gbh.organization_id             = god.organization_id
        AND frd.routing_id              (+) = frh.routing_id
        AND NVL(gmd.attribute15, 'N')       = 'N'
        AND xx.batch_id                     = gmd.batch_id
        AND gbh.batch_status                = 2
        AND frh.routing_class              IN ( SELECT lookup_code
                                                  FROM fnd_lookup_values
                                                 WHERE lookup_type = 'XPPG_BR_OPM_IFACE_WMAS' )
      ORDER BY gmd.batch_id ASC)
      ORDER BY batch_id ASC ;
      --
      l_integracao_tbl_type            xxppg_inv_wmas_pub_pkg.g_integracao_tbl_type;
      l_documento_tbl_type             xxppg_inv_wmas_pub_pkg.g_documento_tbl_type;
      l_documentodetalhe_tbl_type      xxppg_inv_wmas_pub_pkg.g_documentodetalhe_tbl_type;
      l_integracao_hist_tbl_type       xxppg_inv_wmas_pub_pkg.g_integracao_hist_tbl_type;
      l_documentodetalheseq_tbl_type   xxppg_inv_wmas_pub_pkg.g_documentodetalheseq_tbl_type;
      l_movimentoestoque_tbl_type      xxppg_inv_wmas_pub_pkg.g_movimentoestoque_tbl_type;
      l_produto_tbl_type               xxppg_inv_wmas_pub_pkg.g_produto_tbl_type;
      l_TipoUC_tbl_type                xxppg_inv_wmas_pub_pkg.g_TipoUC_tbl_type;
      --
      l_sequencialintegracao           documento.sequenciadocumento%TYPE;
      l_seq_doc                        NUMBER := 0;
      l_seq_int                        NUMBER := 0;
      l_seq_doc_det                    NUMBER := 0;
      l_index_det                      NUMBER := 0;
      l_msg_data                       VARCHAR2(32000);
      l_msg_erro                       VARCHAR2(3200);
      l_return_status                  VARCHAR2(100);
      l_saida                          EXCEPTION;
      l_saida_erro                     EXCEPTION;
      --
      l_val_div                        NUMBER;
      l_operacao                       VARCHAR2(32000);
      l_ingred                         VARCHAR2(32000);
      l_quant                          NUMBER;
      --
      l_batch_id_ant                   NUMBER;
      --
      l_debug                          NUMBER := 1;

      PROCEDURE do_log_p(p_msg IN VARCHAR2)
      IS
      BEGIN
        --
        --DBMS_OUTPUT.PUT_LINE(p_msg);
        --htp.p(p_msg);
        FND_FILE.PUT_LINE(FND_FILE.OUTPUT, p_msg);
        --
      END do_log_p;

      PROCEDURE do_debug_p ( p_msg IN VARCHAR2)
      IS
      BEGIN
        --
        --DBMS_OUTPUT.PUT_LINE(p_msg);
        --htp.p(p_msg);
        IF l_debug > 0
        THEN
          --
          FND_FILE.PUT_LINE(FND_FILE.LOG, p_msg);
          --
        END IF;
        --
      END do_debug_p;

   BEGIN
      --
      do_log_p ( p_msg => '******************************************************************************************************' ) ;
      do_log_p ( p_msg => 'Envio de ordens de produ? para Separa?' ) ;
      do_log_p ( p_msg => '******************************************************************************************************' ) ;
      do_log_p ( p_msg => ' Nro. Ordem      Organiza?               Ingrediente     Opera?        Quantidade       Repeti? ' ) ;
      do_log_p ( p_msg => ' --------------- ------------------------- --------------- --------------- ---------------- ----------' ) ;
      --
      FOR r_doc IN c_doc LOOP
         --
         BEGIN
            --
            SELECT DISTINCT
                   msi.attribute2
              INTO l_endereco_doca
              FROM mtl_secondary_inventories    msi
             WHERE msi.secondary_inventory_name = l_subinv_wmas
               AND msi.organization_id          = r_doc.organization_id ;
            --
         EXCEPTION
            WHEN OTHERS THEN
                  l_endereco_doca := NULL ;
         END ;
         --

         --
         -- #03 - Selecionar atributo para indicar campo INIBIRFRACIONAMENTO
         --
         BEGIN
           SELECT DECODE(NVL(flv.attribute1,'N'),'S',0,1)
             INTO l_inibirfrac
             FROM fnd_lookup_values_vl  flv
            WHERE flv.lookup_type = 'XPPG_BR_OPM_IFACE_WMAS'
              AND flv.lookup_code = r_doc.routing_class;
         EXCEPTION
            WHEN others THEN
                 l_inibirfrac := 1;
         END;
         --
         FOR r_repeat IN 1..r_doc.repete LOOP
             --
             INSERT INTO xxppg_inv_send_op_tmp
                   ( codigoEstabelecimento                             -- 01
                   , codigodepositante                                 -- 02
                   , CNPJCPFDepositante                                -- 03
                   , tipoDocumento                                     -- 04
                   , serieDocumento                                    -- 05
                   , numeroDocumento                                   -- 06
                   , modeloDocumento                                   -- 07
                   , naturezaOperacao                                  -- 08
                   , descricaoNaturezaOperacao                         -- 09
                   , dataEmissao                                       -- 10
                   , dataPrevisaoMovimento                             -- 11
                   , codigoEmpresa                                     -- 12
                   , nomeEmpresa                                       -- 13
                   , CnpjCpfEmpresa                                    -- 14
                   , enderecoEmpresa                                   -- 15
                   , bairroEmpresa                                     -- 16
                   , municipioEmpresa                                  -- 17
                   , ufEmpresa                                         -- 18
                   , CepEmpresa                                        -- 19
                   , inscricaoEmpresa                                  -- 20
                   , codigoProduto                                     -- 21
                   , tipoUC                                            -- 22
                   , fatorTipoUC                                       -- 23
                   , classeProduto                                     -- 24
                   , tipoProduto                                       -- 25
                   , quantidadeMovimento                               -- 26
                   , valorUnitario                                     -- 27
                   , informacaoAdicional1                              -- 28
                   , batch_id                                          -- 29
                   , material_detail_id                                -- 30
                   , enderecoDoca                                      -- 31
                   , InibirFracionamento                               -- 32   --#03
                   ) VALUES
                   ( r_doc.codigoEstabelecimento                       -- 01
                   , SUBSTR(r_doc.codigodepositante, 0, 45)            -- 02
                   , SUBSTR(r_doc.CNPJCPFDepositante, 0, 60)           -- 03
                   , SUBSTR(r_doc.tipoDocumento, 0, 15)                -- 04
                   , r_doc.atividade||LPAD(r_repeat, 2, '0')           -- 05
                   , SUBSTR(r_doc.numeroDocumento, 0, 30)              -- 06
                   , SUBSTR(r_doc.modeloDocumento, 0, 30)              -- 07
                   , SUBSTR(r_doc.naturezaOperacao, 0, 45)             -- 08
                   , SUBSTR(r_doc.descricaoNaturezaOperacao, 0, 120)   -- 09
                   , TO_CHAR(SYSDATE, 'DD-MON-RRRR')                   -- 10
                   , TO_CHAR(SYSDATE, 'DD-MON-RRRR')                   -- 11
                   , SUBSTR(r_doc.codigoEmpresa, 0, 45)                -- 12
                   , SUBSTR(r_doc.org_name, 0, 240)                    -- 13
                   , SUBSTR(r_doc.cnpjcpfdepositante, 0, 60)           -- 14
                   , SUBSTR(r_doc.endereco, 0, 270)                    -- 15
                   , SUBSTR(r_doc.bairro, 0, 75)                       -- 16
                   , SUBSTR(r_doc.cidade, 0, 75)                       -- 17
                   , SUBSTR(r_doc.estado, 0, 6)                        -- 18
                   , SUBSTR(r_doc.Cep, 0, 27)                          -- 19
                   , SUBSTR(r_doc.inscricaoestadual, 0, 60)            -- 20
                   , SUBSTR(r_doc.codigoProduto, 0, 75)                -- 21
                   , SUBSTR(r_doc.tipoUC, 0, 15)                       -- 22
                   , r_doc.fatorTipoUC                                 -- 23
                   , l_subinv_wmas                                     -- 24
                   , r_doc.tipoProduto                                 -- 25
                   , r_doc.qtde/r_doc.repete                           -- 26
                   , r_doc.valorUnitario                               -- 27
                   , SUBSTR(r_doc.informacaoAdicional1, 0, 75)         -- 28
                   , r_doc.batch_id                                    -- 29
                   , r_doc.material_detail_id                          -- 30
                   , l_endereco_doca                                   -- 31
                   , l_inibirfrac                                      -- 32   --#03
                   ) ;
             --
             do_log_p  ( p_msg => ' ' ||
                         RPAD(r_doc.numeroDocumento                  , 15, ' ')   ||' '||
                         RPAD(r_doc.org_name                         , 25, ' ')   ||' '||
                         RPAD(r_doc.item                             , 15, ' ')   ||' '||
                         RPAD(r_doc.atividade||LPAD(r_repeat, 2, '0'), 15, ' ')   ||' '||
                         lpad(r_doc.qtde/r_doc.repete                , 15, ' ')   ||' '||
                         lpad(r_repeat                               , 10, ' ')
                         ) ;
             --
         END LOOP ;
         --
      END LOOP ;
      --
      do_log_p ( p_msg => '' ) ;
      do_log_p ( p_msg => '******************************************************************************************************' ) ;
      --
      -- Integra com WMAS
      --
      FOR r_ordens IN ( SELECT batch_id
                             , serieDocumento
                             , tipoProduto
                          FROM xxppg_inv_send_op_tmp
                         GROUP BY batch_id
                                , serieDocumento
                                , tipoProduto ) LOOP
           --
           l_integracao_tbl_type.DELETE ;
           l_documento_tbl_type.DELETE ;
           l_documentodetalhe_tbl_type.DELETE ;
           l_integracao_hist_tbl_type.DELETE ;
           l_documentodetalheseq_tbl_type.DELETE ;
           l_movimentoestoque_tbl_type.DELETE ;
           l_produto_tbl_type.DELETE ;
           l_TipoUC_tbl_type.DELETE ;
           --
           l_seq_doc   := 1 ;
           l_index_det := NULL ;
           --
           FOR r_detalhes IN ( SELECT *
                                 FROM xxppg_inv_send_op_tmp
                                WHERE batch_id       = r_ordens.batch_id
                                  AND serieDocumento = r_ordens.serieDocumento
                                  AND tipoProduto    = r_ordens.tipoProduto ) LOOP
                --
                IF l_index_det IS NULL THEN
                   --
                   l_integracao_tbl_type (l_seq_doc).TipoIntegracao             := 203 ;
                   l_integracao_tbl_type (l_seq_doc).EstadoIntegracao           := 1 ;
                   l_integracao_tbl_type (l_seq_doc).SequenciaRelacionada       := 0 ;
                   --
                   do_debug_p ( p_msg => ' ------------------------------------------------- ' ) ;
                   do_debug_p ( p_msg => ' Inserindo documento - '||r_detalhes.numeroDocumento ) ;
                   l_documento_tbl_type (l_seq_doc).sequenciaDocumento         := 1 ;
                   l_documento_tbl_type (l_seq_doc).tipoIntegracao             := 203 ;
                   l_documento_tbl_type (l_seq_doc).codigoEstabelecimento      := r_detalhes.codigoEstabelecimento ;
                   do_debug_p ( p_msg => ' debug 1' ) ;
                   l_documento_tbl_type (l_seq_doc).codigodepositante          := r_detalhes.codigodepositante ;
                   do_debug_p ( p_msg => ' debug 2' ) ;
                   l_documento_tbl_type (l_seq_doc).CNPJCPFDepositante         := r_detalhes.CNPJCPFDepositante ;
                   do_debug_p ( p_msg => ' debug 3' ) ;
                   l_documento_tbl_type (l_seq_doc).tipoDocumento              := r_detalhes.tipoDocumento ;
                   do_debug_p ( p_msg => ' debug 4' ) ;
                   l_documento_tbl_type (l_seq_doc).serieDocumento             := r_detalhes.serieDocumento ;
                   do_debug_p ( p_msg => ' debug 5' ) ;
                   l_documento_tbl_type (l_seq_doc).numeroDocumento            := r_detalhes.numeroDocumento ;
                   do_debug_p ( p_msg => ' debug 6' ) ;
                   l_documento_tbl_type (l_seq_doc).modeloDocumento            := r_detalhes.modeloDocumento ;
                   do_debug_p ( p_msg => ' debug 7' ) ;
                   l_documento_tbl_type (l_seq_doc).naturezaOperacao           := r_detalhes.naturezaOperacao ;
                   do_debug_p ( p_msg => ' debug 8' ) ;
                   l_documento_tbl_type (l_seq_doc).descricaoNaturezaOperacao  := r_detalhes.descricaoNaturezaOperacao ;
                   do_debug_p ( p_msg => ' debug 9' ) ;
                   l_documento_tbl_type (l_seq_doc).dataEmissao                := r_detalhes.dataEmissao ;
                   do_debug_p ( p_msg => ' debug 10' ) ;
                   l_documento_tbl_type (l_seq_doc).dataPrevisaoMovimento      := r_detalhes.dataPrevisaoMovimento ;
                   do_debug_p ( p_msg => ' debug 11' ) ;
                   l_documento_tbl_type (l_seq_doc).codigoEmpresa              := r_detalhes.codigoEmpresa ;
                   do_debug_p ( p_msg => ' debug 12' ) ;
                   l_documento_tbl_type (l_seq_doc).nomeEmpresa                := r_detalhes.nomeEmpresa ;
                   do_debug_p ( p_msg => ' debug 13' ) ;
                   l_documento_tbl_type (l_seq_doc).CnpjCpfEmpresa             := r_detalhes.cnpjCpfEmpresa ;
                   do_debug_p ( p_msg => ' debug 14' ) ;
                   l_documento_tbl_type (l_seq_doc).enderecoEmpresa            := r_detalhes.enderecoEmpresa ;
                   do_debug_p ( p_msg => ' debug 15' ) ;
                   l_documento_tbl_type (l_seq_doc).bairroEmpresa              := r_detalhes.bairroEmpresa ;
                   do_debug_p ( p_msg => ' debug 16' ) ;
                   l_documento_tbl_type (l_seq_doc).municipioEmpresa           := r_detalhes.municipioEmpresa ;
                   do_debug_p ( p_msg => ' debug 17' ) ;
                   l_documento_tbl_type (l_seq_doc).ufEmpresa                  := r_detalhes.ufEmpresa ;
                   do_debug_p ( p_msg => ' debug 18' ) ;
                   l_documento_tbl_type (l_seq_doc).CepEmpresa                 := r_detalhes.cepEmpresa ;
                   do_debug_p ( p_msg => ' debug 19' ) ;
                   l_documento_tbl_type (l_seq_doc).inscricaoEmpresa           := r_detalhes.inscricaoEmpresa ;
                   do_debug_p ( p_msg => ' debug 20' ) ;
                   l_documento_tbl_type (l_seq_doc).TipoPessoaEmpresa          := 'J' ;
                   do_debug_p ( p_msg => ' debug 21' ) ;
                   l_documento_tbl_type (l_seq_doc).Agrupador                  := r_detalhes.numeroDocumento||SUBSTR(r_detalhes.tipoDocumento, 2, 1) ;
                   do_debug_p ( p_msg => ' debug 21a' ) ;
                   l_documento_tbl_type (l_seq_doc).enderecoDoca               := r_detalhes.enderecoDoca ;
                   do_debug_p ( p_msg => ' debug 21b' ) ;
                   l_documento_tbl_type (l_seq_doc).inibirfracionamento        := r_detalhes.inibirFracionamento ;     -- #03
                   --
                END IF ;
                --
                l_index_det := NVL(l_index_det, 0) + 1 ;
                --
                l_documentodetalhe_tbl_type(l_index_det).SequenciaDocumento     := l_seq_doc ;
                l_documentodetalhe_tbl_type(l_index_det).SequenciaDetalhe       := l_index_det ;
                l_documentodetalhe_tbl_type(l_index_det).codigoEmpresa          := r_detalhes.codigoEmpresa ;
                do_debug_p ( p_msg => ' debug 22' ) ;
                l_documentodetalhe_tbl_type(l_index_det).codigoProduto          := r_detalhes.codigoProduto ;
                do_debug_p ( p_msg => ' debug 23' ) ;
                l_documentodetalhe_tbl_type(l_index_det).tipoUC                 := r_detalhes.tipoUC ;
                do_debug_p ( p_msg => ' debug 24' ) ;
                l_documentodetalhe_tbl_type(l_index_det).fatorTipoUC            := r_detalhes.fatorTipoUC ;
                do_debug_p ( p_msg => ' debug 25' ) ;
                l_documentodetalhe_tbl_type(l_index_det).classeProduto          := r_detalhes.classeProduto ;
                do_debug_p ( p_msg => ' debug 26' ) ;
                l_documentodetalhe_tbl_type(l_index_det).quantidadeMovimento    := r_detalhes.quantidadeMovimento ;
                do_debug_p ( p_msg => ' debug 27' ) ;
                l_documentodetalhe_tbl_type(l_index_det).valorUnitario          := r_detalhes.valorUnitario ;
                do_debug_p ( p_msg => ' debug 28' ) ;
                l_documentodetalhe_tbl_type(l_index_det).dadoLogistico          := NULL ;
                do_debug_p(p_msg => ' debug 29') ;
                l_documentodetalhe_tbl_type(l_index_det).informacaoAdicional1   := r_detalhes.informacaoAdicional1 ;
                do_debug_p ( p_msg => ' debug 30' ) ;
                l_documentodetalhe_tbl_type(l_index_det).OrdemSeparacao         := r_detalhes.material_detail_id ; --#02 - Ajustado conforme solicita? integra? GAP 81.4 -- NULL ;
                do_debug_p ( p_msg => ' debug 31' ) ;
                l_documentodetalhe_tbl_type(l_index_det).NumeroPedidoSeparacao  := NULL ;
                --
                UPDATE gme_material_details
                   SET attribute15 = 'Y'
                 WHERE material_detail_id = r_detalhes.material_detail_id ;
                --
           END LOOP ;
           --
           -- Insere Dados nas tabelas WMAS
           --
           BEGIN
              --
              l_msg_data      := NULL ;
              l_return_status := NULL ;
              --
              xxppg_inv_wmas_pub_pkg.create_wmas_records ( p_integracao_tbl              => l_integracao_tbl_type
                                                         , p_integracao_hist_tbl         => l_integracao_hist_tbl_type
                                                         , p_documento_tbl               => l_documento_tbl_type
                                                         , p_documento_detalhe_tbl       => l_documentodetalhe_tbl_type
                                                         , p_documento_detalhe_seq_tbl   => l_documentodetalheseq_tbl_type
                                                         , p_movimento_estoque_tbl       => l_movimentoestoque_tbl_type
                                                         , p_produto_tbl                 => l_produto_tbl_type
                                                         , p_TipoUC_tbl                  => l_TipoUC_tbl_type
                                                         , p_SequencialIntegracao        => l_sequencialintegracao
                                                         , p_return_status               => l_return_status
                                                         , p_msg_data                    => l_msg_data ) ;
              --
              IF l_return_status = 'E' THEN
                  --
                  l_msg_erro := l_msg_data ;
                  RAISE l_saida ;
                  --
              END IF ;
              --
           EXCEPTION
              WHEN l_saida THEN
                    p_msg_erro := SUBSTR('Rotina Envio Ordens de Produ? - '||l_msg_erro, 0, 4000) ;
                    RAISE l_saida_erro ;
              WHEN OTHERS THEN
                    p_msg_erro := SUBSTR('Erro no EXCEPTION GERAL da rotina XPPG_INV_SEND_ORD_PROD_SEP_P: ' ||sqlerrm , 0, 4000) ;
                    RAISE l_saida_erro ;
           END ;
           --
           UPDATE gme_batch_header
              SET attribute5 = NVL(attribute5, 0) + 1
            WHERE batch_id   = r_ordens.batch_id ;
           --
      END LOOP ;
      --
      COMMIT ;
      --
  EXCEPTION
     WHEN l_saida_erro THEN
           ROLLBACK ;
     --
  END Send_Ordem_Prod_Separacao_P ;

  --  +=====================================================================+
  --  | DESCRIPTION                                                         |
  --  |    Cria? de rotina para gera? da tabela tempor?a de transa?s|
  --  |    geradas a partir de uma Move Order.                              |
  --  |                                                                     |
  --  | HISTORY                                                             |
  --  |    27-Nov-2014     Renato Furlan     Cria? da rotina.             |
  --  |                                                                     |
  --  +=====================================================================+
  PROCEDURE Insert_Transactions_Temp_P ( p_move_order_line_Id    In Number
                                       , p_quantity              In Number
                                       , p_transaction_temp_id  Out Number
                                       , p_msg_erro             Out Varchar2 ) IS

     CURSOR c_lines IS
       SELECT mtrl.inventory_item_id
            , mtrl.organization_id
            , mtrl.created_by
            , mtrl.last_update_login
            , mtrl.from_subinventory_code
            , mtrl.from_locator_id
            , mtrl.quantity
            , mtrl.primary_quantity
            , mtrl.secondary_quantity
            , mtrl.secondary_uom_code
            ,(mtrl.secondary_quantity / mtrl.primary_quantity) fator_conv_sec
            , mtrl.uom_code
            , mtrl.transaction_type_id
            , mtt.transaction_action_id
            , mtrl.transaction_source_type_id
            , mtrl.header_id
            , mtrl.line_id
            , mtrl.to_subinventory_code
            , NVL(mtrl.to_organization_id, mtrl.organization_id)  to_organization_id
            , msib.primary_uom_code
            , msib.description  item_description
            , msib.lot_control_code
            , msib.serial_number_control_code
            , msib.picking_rule_id
            , msib.location_control_code
            , msib.revision_qty_control_code
            , msib.shelf_life_code
            , msib.shelf_life_days
            , msib.inventory_asset_flag
            , msib.allowed_units_lookup_code
            , msib.restrict_subinventories_code
            , msib.restrict_locators_code
        FROM mtl_txn_request_lines  mtrl
           , mtl_transaction_types  mtt
           , mtl_system_items_b     msib
       WHERE mtrl.line_id            = p_move_order_line_id
         AND mtt.transaction_type_id = mtrl.transaction_type_id
         AND msib.inventory_item_id  = mtrl.inventory_item_id
         AND msib.organization_id    = mtrl.organization_id;

    l_new_temp_id      Number;
    l_acct_period_id   Number;
    l_saida            Exception;

  BEGIN
    FOR r_lines in c_lines LOOP

        BEGIN
          SELECT mtl_material_transactions_s.NEXTVAL INTO l_new_temp_id FROM dual;
        EXCEPTION
           WHEN others THEN
                p_msg_erro := 'Erro ao recuperar sequ?ia mtl_material_transactions_s - '||SqlErrm;
                Raise l_saida;
        END;

        BEGIN
           INV_INV_LOVS.tdatechk(p_org_id           => r_lines.organization_id,
                                 p_transaction_date => sysdate,
                                 x_period_id        => l_acct_period_id);
        EXCEPTION
           WHEN others THEN
                p_msg_erro := 'Erro inesperado ao recuperar per?o - '||SqlErrm;
                Raise l_saida;
        END;

        IF (l_acct_period_id = -1 or l_acct_period_id = 0) THEN
            FND_MESSAGE.SET_NAME('INV', 'INV_NO_OPEN_PERIOD');
            p_msg_erro := 'Erro ao recuperar per?o: '||fnd_message.get;
            RAISE l_saida;
        END IF;

        BEGIN
          INSERT INTO MTL_MATERIAL_TRANSACTIONS_TEMP
              ( transaction_header_id                , transaction_temp_id                 , last_update_date                    --01
              , last_updated_by                      , creation_date                       , created_by                          --02
              , last_update_login                    , inventory_item_id                   , organization_id                     --03
              , subinventory_code                    , locator_id                          , transaction_quantity                --04
              , primary_quantity                     , transaction_uom                     , transaction_type_id                 --05
              , transaction_action_id                , transaction_source_type_id          , transaction_source_id               --06
              , transaction_date                     , acct_period_id                      , trx_source_line_id                  --07
              , transfer_subinventory                , transfer_organization               , demand_source_line                  --08
              , item_primary_uom_code                , item_lot_control_code               , item_serial_control_code            --09
              , posting_flag                         , process_flag                        , pick_rule_id                        --10
              , move_order_line_id                   , transaction_status                  , wms_task_type                       --11
              , wms_task_status                      , move_order_header_id                , fulfillment_base                    --12
              , transaction_mode                     , lock_flag                           , item_description                    --13
              , item_location_control_code           , item_revision_qty_control_code      , item_shelf_life_code                --14
              , item_shelf_life_days                 , item_inventory_asset_flag           , allowed_units_lookup_code           --15
              , item_restrict_subinv_code            , item_restrict_locators_code         , final_completion_flag               --16
              , secondary_uom_code                   , secondary_transaction_quantity                                            --17
              )
           VALUES
              ( Null                                 , l_new_temp_id                       , Sysdate                             --01
              , r_lines.created_by                   , Sysdate                             , r_lines.created_by                  --02
              , r_lines.last_update_login            , r_lines.inventory_item_id           , r_lines.organization_id             --03
              , r_lines.from_subinventory_code       , r_lines.from_locator_id             , p_quantity                          --04
              , p_quantity                           , r_lines.uom_code                    , r_lines.transaction_type_id         --05
              , r_lines.transaction_action_id        , r_lines.transaction_source_type_id  , r_lines.header_id                   --06
              , Sysdate                              , l_acct_period_id                    , r_lines.line_id                     --07
              , r_lines.to_subinventory_code         , r_lines.to_organization_id          , r_lines.line_id                     --08
              , r_lines.primary_uom_code             , r_lines.lot_control_code            , r_lines.serial_number_control_code  --09
              , 'Y'                                  , 'Y'                                 , Null                                --10
              , r_lines.line_id                      , 2                                   , 5                                   --11
              , 1                                    , r_lines.header_id                   , Null                                --12
              , 1                                    , 'N'                                 , r_lines.item_description            --13
              , r_lines.location_control_code        , r_lines.revision_qty_control_code   , r_lines.shelf_life_code             --14
              , r_lines.shelf_life_days              , r_lines.inventory_asset_flag        , r_lines.allowed_units_lookup_code   --15
              , r_lines.restrict_subinventories_code , r_lines.restrict_locators_code      , 'N'                                 --16
              , r_lines.secondary_uom_code           , ROUND(p_quantity *                                                        --17
                                                       r_lines.fator_conv_sec,6)
              );
        EXCEPTION
           WHEN others THEN
                p_msg_erro := 'Erro ao gerar Mtl_Material_Transactions_Temp - '||SqlErrm;
                Raise l_saida;
        END;
        p_transaction_temp_id := l_new_temp_id;
    END LOOP;
  EXCEPTION
     WHEN l_saida THEN
          Return;
     WHEN others THEN
          p_msg_erro := 'Erro inesperado - Insert_Transactions_Temp_P - '||SqlErrm;
          Return;
  END Insert_Transactions_Temp_P;

END XXPPG_INV_IFACE_WMAS_API_PKG;
/