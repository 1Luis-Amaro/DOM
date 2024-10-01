SELECT /*+ parallel */
        xep.NAME pessoa_juridica
      , gl.name livro
      , god.organization_code org     
      , gxeh.valuation_cost_type tipo_custo
      --, god.organization_name
      --
      , gxeh.entity_code entidade
      , gxeh.event_class_code cod_classe
      , gxeh.event_type_code cod_tipo
      , xec.name Classe_evento --event_class_name
      , xet.name Tipo_evento   --event_type_name
      --
     , xah.period_name Periodo
      --      
     , gxel.journal_line_type Tipo_linha
         --
     , decode(sign(gxel.entered_amount), 1, gxel.entered_amount,0,0,0)       Ent_Debito
     , -decode(sign(gxel.entered_amount),-1, ABS(gxel.entered_amount),0,0,0)  Ent_Credito
     --
     , (decode(sign(gxel.entered_amount), 1, gxel.entered_amount,0,0,0))+(
      -decode(sign(gxel.entered_amount),-1, ABS(gxel.entered_amount),0,0,0))  Ent_Liquido
     --
     , decode(sign(gxel.accounted_amount), 1, gxel.accounted_amount,0,0,0)       Cont_Debito
     , -decode(sign(gxel.accounted_amount),-1, ABS(gxel.accounted_amount),0,0,0)  Cont_Credito
     --
     , (decode(sign(gxel.accounted_amount), 1, gxel.accounted_amount,0,0,0)) +      
      (-decode(sign(gxel.accounted_amount),-1, ABS(gxel.accounted_amount),0,0,0))  Cont_Liquido
     --, decode(sign(gxel.trans_amount), 1, gxel.trans_amount,0,0,0)       Debito --base_dr_amount
     --, -decode(sign(gxel.trans_amount),-1, ABS(gxel.trans_amount),0,0,0)  Credito --base_cr_amount
     , gcc.concatenated_segments Conta --account_number
     , xal.description Descricao  
     --, xal.ae_line_num
     , xe.process_status_code status
     , (SELECT meaning FROM apps.fnd_lookup_values WHERE lookup_type = 'XLA_EVENT_PROCESS_STATUS' AND lookup_code = xe.process_status_code AND language = userenv('lang')) Desc_status --process_status_desc
--
--     , translate(xae.encoded_msg, CHR(10), ' ') Msg_erro
       , (SELECT translate(encoded_msg,CHR(10),' ')
            FROM apps.xla_accounting_errors xae
           WHERE xae.event_id = xah.event_id
             AND xae.ledger_id = xah.ledger_id
             AND xae.ae_line_num = xal.ae_line_num
             AND xae.application_id = 555
             AND ROWNUM = 1)        Msg_Erro
     -- Informações Adicionais --
     , (SELECT msi.concatenated_segments ||' | '||msi.description
          FROM apps.mtl_system_items_kfv msi 
         WHERE msi.organization_id   = gxeh.organization_id 
           AND msi.inventory_item_id = gxeh.inventory_item_id) item_number
     --
     , (SELECT mc.concatenated_segments
          FROM apps.mtl_item_categories_v mic
             , apps.mtl_categories_kfv mc
             , apps.mtl_category_sets_v mcs
         WHERE mcs.structure_id      = mic.structure_id
           AND mic.organization_id   = gxeh.organization_id
           AND mic.inventory_item_id = gxeh.inventory_item_id
           AND mc.category_id        = mic.category_id
           AND mic.category_set_id = (SELECT category_set_id FROM apps.mtl_default_category_sets WHERE functional_area_id = 19) -- custo
       ) Cat_Custo -- cost_category
     --
     , (SELECT mc.concatenated_segments
          FROM apps.mtl_item_categories_v mic
             , apps.mtl_categories_kfv mc
             , apps.mtl_category_sets_v mcs
         WHERE mcs.structure_id      = mic.structure_id
           AND mic.organization_id   = gxeh.organization_id
           AND mic.inventory_item_id = gxeh.inventory_item_id
           AND mc.category_id        = mic.category_id
           AND mic.category_set_id = (SELECT category_set_id FROM apps.mtl_default_category_sets WHERE functional_area_id = 1) -- inv
       ) Cat_INV
     --
    , (SELECT cost_cmpntcls_code 
         FROM apps.cm_cmpt_mst ccm 
        WHERE ccm.cost_cmpntcls_id = gxel.cost_cmpntcls_id) Classe_Componente --cost_cmpntcls_code 
    --
     , xe.transaction_date Data_transacao
     , gxeh.transaction_quantity Qtde_Transacao
    --        
    , (SELECT transaction_type_name
         FROM apps.mtl_transaction_types mtt
        WHERE mtt.transaction_type_id = gxeh.transaction_type_id) Tipo_Transacao --transaction_type_name
     --   
    , apps.xxppg_opm_custom_sources_pkg.get_source_document(gxeh.transaction_id,god.organization_code,gl.name) Origem
    --
   ,  CASE
         WHEN gxeh.entity_code = 'ORDERMANAGEMENT' THEN
             'SBU Grupo Cliente: '||apps.xxppg_opm_custom_sources_pkg.Get_SBU_CUSTOMER_GROUP(gxeh.transaction_id)
             ||' | Canal de Vendas: '||apps.xxppg_opm_custom_sources_pkg.Get_OM_SALES_CHANNEL(gxeh.transaction_id)
             ||' | Grupo de Cliente: '||apps.xxppg_opm_custom_sources_pkg.Get_OM_CUSTOMER_GROUP(gxeh.transaction_id) 
             ||' | Tipo de Nota AR: '||apps.xxppg_opm_custom_sources_pkg.Get_AR_TRANSACTION_TYPE(gxeh.transaction_id)
             ||' | CC do Vendedor: '||apps.xxppg_opm_custom_sources_pkg.Get_OM_SALES_COST_CENTER(gxeh.transaction_id)
             ||' | PL do Vendedor: '||apps.xxppg_opm_custom_sources_pkg.Get_OM_SALES_PL(gxeh.transaction_id)
             ||' | Util. Fiscal Item: '||apps.xxppg_opm_custom_sources_pkg.get_item_fiscal_util(gxeh.transaction_id)
         WHEN gxeh.entity_code = 'PURCHASING' THEN
            'Tipo de Nota RI: '||apps.xxppg_opm_custom_sources_pkg.Get_RI_INVOICE_TYPE(gxeh.transaction_id)
            ||' | Util. Fiscal Item: '||apps.xxppg_opm_custom_sources_pkg.get_item_fiscal_util(gxeh.transaction_id)
         WHEN gxeh.event_class_code = 'ACTCOSTADJ' THEN
            'Motivo do Ajuste Custo: '||apps.xxppg_opm_custom_sources_pkg.get_cad_reason_code(gxeh.transaction_id)
            ||' | Util. Fiscal Item: '||apps.xxppg_opm_custom_sources_pkg.get_item_fiscal_util(gxeh.transaction_id)
         WHEN gxeh.event_class_code = 'MISC_TXN' THEN 
            'Motivo da Transacao: '||apps.xxppg_opm_custom_sources_pkg.get_txn_reason(gxeh.transaction_id)
            ||' | Tipo Transacao Terceiro: '||apps.xxppg_opm_custom_sources_pkg.Get_MTL_TRANS_DIV_TERC(gxeh.transaction_id)
            ||' | Util. Fiscal Item: '||apps.xxppg_opm_custom_sources_pkg.get_item_fiscal_util(gxeh.transaction_id)
         ELSE
           'Util. Fiscal Item: '||apps.xxppg_opm_custom_sources_pkg.get_item_fiscal_util(gxeh.transaction_id)
       END  informacoes_adicionais
    --
    , gxeh.transaction_id ID_Transacao   
    , gcc.segment1 || (SELECT ' - '||ffv.description
                          FROM apps.fnd_flex_values_vl  ffv
                             , apps.fnd_flex_value_sets ffvs
                         WHERE flex_value_set_name    = 'PPG_GL_LOCATION'
                           AND ffvs.flex_value_set_id = ffv.flex_value_set_id
                           AND ffv.flex_value         = gcc.segment1
                       )     LOCATION
     , gcc.segment2 || (SELECT ' - '||ffv.description
                          FROM apps.fnd_flex_values_vl  ffv
                             , apps.fnd_flex_value_sets ffvs
                         WHERE flex_value_set_name    = 'PPG_GL_MINOR'
                           AND ffvs.flex_value_set_id = ffv.flex_value_set_id
                           AND ffv.flex_value         = gcc.segment2
                       )     MINOR
     , gcc.segment3 || (SELECT ' - '||ffv.description
                          FROM apps.fnd_flex_values_vl  ffv
                             , apps.fnd_flex_value_sets ffvs
                         WHERE flex_value_set_name    = 'PPG_GL_PRIME'
                           AND ffvs.flex_value_set_id = ffv.flex_value_set_id
                           AND ffv.flex_value         = gcc.segment3
                       )     PRIME
     , gcc.segment4 || (SELECT ' - '||ffv.description
                          FROM apps.fnd_flex_values_vl  ffv
                             , apps.fnd_flex_value_sets ffvs
                         WHERE flex_value_set_name    = 'PPG_GL_SUBACCOUNT'
                           AND ffvs.flex_value_set_id = ffv.flex_value_set_id
                           AND ffv.flex_value         = gcc.segment4
                       )     SUBACCOUNT
     , gcc.segment5 || (SELECT ' - '||ffv.description
                          FROM apps.fnd_flex_values_vl  ffv
                             , apps.fnd_flex_value_sets ffvs
                         WHERE flex_value_set_name    = 'PPG_GL_COST_CENTER'
                           AND ffvs.flex_value_set_id = ffv.flex_value_set_id
                           AND ffv.flex_value         = gcc.segment5
                       )     COST_CENTER
     , gcc.segment6 || (SELECT ' - '||ffv.description
                          FROM apps.fnd_flex_values_vl  ffv
                             , apps.fnd_flex_value_sets ffvs
                         WHERE flex_value_set_name    = 'PPG_GL_PRODUCT_LINE'
                           AND ffvs.flex_value_set_id = ffv.flex_value_set_id
                           AND ffv.flex_value         = gcc.segment6
                       )     PRODUCT_LINE
     , gcc.segment7 || (SELECT ' - '||ffv.description
                          FROM apps.fnd_flex_values_vl  ffv
                             , apps.fnd_flex_value_sets ffvs
                         WHERE flex_value_set_name    = 'PPG_GL_INTER_LOC'
                           AND ffvs.flex_value_set_id = ffv.flex_value_set_id
                           AND ffv.flex_value         = gcc.segment7
                       )     INTERLOC 
--    , gxeh.organization_id
--    , gxeh.inventory_item_id
--    , gxeh.source_document_id
--    , gxeh.source_line_id
--    , decode(transaction_type_id, 10008, appselect.get_ar_status_trx_from_cogs(gxeh.transaction_id)) trx_status
--    , xal.creation_date
--    ,gxel.creation_date        
    /*(SELECT gbh.batch_no 
        FROM apps.gme_batch_header gbh
        WHERE gbh.batch_id = gxeh.source_document_id--gxeh.transaction_id
          AND gxeh.organization_id = gbh.organization_id) batch_no*/
 FROM apps.xla_events xe
    , apps.xla_ae_headers xah
    , apps.xla_ae_lines xal
    , apps.gmf_xla_extract_headers gxeh
    , apps.gmf_xla_extract_lines gxel
    , apps.gl_code_combinations_kfv gcc
    , apps.xle_entity_profiles xep
    , apps.gmf_organization_definitions god
    /*, ( SELECT DISTINCT event_id, encoded_msg, ae_header_id, ae_line_num
          FROM apps.xla_accounting_errors xae
         WHERE application_id = 555
           AND rowid IN ( SELECT ROWID
                           FROM (SELECT ROWID, event_id
                                   FROM apps.xla_accounting_errors
                                  WHERE application_id = 555
                                  ORDER BY ae_header_id, ae_line_num
                                )
                          WHERE ROWNUM = 1
                            AND event_id = xae.event_id
                       )
      ) xae*/
    , apps.xla_distribution_links xdl
    , apps.xla_event_classes_vl xec
    , apps.xla_event_types_vl xet
    
    ,apps.gl_ledgers gl

WHERE xe.application_id         = 555
  AND xah.application_id        = 555
  AND xal.application_id        = 555
  AND xdl.application_id        = 555
  AND xec.application_id        = 555
  AND xet.application_id        = 555

  --AND xe.process_status_code IN ('I', 'U')

  --AND gxeh.transaction_date BETWEEN to_date('01/09/2014', 'dd/MM/yyyy') AND to_date('30/09/2014', 'dd/MM/yyyy')
 --AND gxeh.valuation_cost_type = 'STD'
-- AND xep.name = 'PPG'
--AND god.organization_code = 'GVT'
--aND gxeh.transaction_id = 398061
  
-- AND gcc.segment3 IN ( '1143102') --, '9111101')
  
  AND xah.ledger_id             = gxeh.ledger_id
  AND xah.event_id              = gxeh.event_id
  AND xah.event_id              = xe.event_id
  AND xal.ae_header_id          = xah.ae_header_id
  AND gxeh.event_id             = xe.event_id
  
 --1 AND xae.event_id (+)          = xdl.event_id
-- AND xae.ae_line_num (+)       = xdl.ae_line_num
  AND xal.code_combination_id   = gcc.code_combination_id (+)
  AND xah.event_type_code       = gxeh.event_type_code
  AND xep.legal_entity_id       = gxeh.legal_entity_id
  AND xep.legal_entity_id       = god.legal_entity_id
  AND god.legal_entity_id       = gxeh.legal_entity_id
  AND god.organization_id       = gxeh.organization_id
  --AND god.ledger_id             = gxeh.ledger_id
  AND god.operating_unit_id     = gxeh.operating_unit
  AND gxel.header_id            = gxeh.header_id
  AND gxel.event_id             = gxeh.event_id

  AND xdl.ae_header_id                 = xal.ae_header_id
  AND xdl.ae_line_num                  = xal.ae_line_num
  AND xdl.event_id                     = gxeh.event_id
  AND xdl.source_distribution_type     = gxeh.entity_code
  AND xdl.source_distribution_id_num_1 = gxel.line_id

  AND xec.event_class_code = gxeh.event_class_code
  AND xec.entity_code      = gxeh.entity_code

  AND xet.entity_code      = gxeh.entity_code
  AND xet.event_class_code = gxeh.event_class_code
  AND xet.event_type_code  = gxeh.event_type_code
  
  AND gxeh.ledger_id = gl.ledger_id
;
