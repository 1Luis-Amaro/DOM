select mp.organization_code org,
       sample_no               "Amostra",
       gsb.spec_name           "Especificacao",
       gsb.spec_vers           "Espec Vers",
       msi.segment1            "Item",
       msi.item_type           "Tipo Item",
       gbh.batch_no            "Ordem Prod",
       fm.formula_no           "Formula",
       fm.formula_vers         "Form Vers",
       frh.routing_no          "Roteiro",
       pha.segment1            "Ordem Compra",
       pv.vendor_name          "Fornecedor",
       gs.lot_number           "Lote",
       gs.supplier_lot_no      "Lote Fornecedor",
       gs.sample_qty           "Qtd Amostra",
       gs.remaining_qty        "Qtd Remanescente",
       gs.creation_date        "Data Criacao",
       gs.date_received        "Data Recebido",
       DECODE (gs.source,'S','Compra','W','Producao','I','Inventario','C','Cliente') origem,
       DECODE(gssd.disposition, '0PL', 'Planejado',
                                '0RT', 'Reter',
                                '1P',  'Pendente',
                                '4A',  'Aceitar',
                                '3C',  'Concluir',
                                '4RJ', 'Rejeitar',
                                '6RJ', 'Rejeitar',
                                '4CN', 'Cancelar',
                                '7CN', 'Cancelar',
                                '2I',  'Em Andamento',
                                '5AV', 'Aceitar com Variacao')     "Disposicao",
       gssd.last_update_date   "Data Disposicao",
       fu.description          "Usuario",
       gs.source_subinventory  "Subinventario",
       qc.plan_name            "Plano Skip Lote",
       qsc.PROCESS_CODE        "Skip Lote",
       (case nvl(to_char(qsp.frequency_denom),'a') 
           when 'a' then ' ' 
           else  qsp.frequency_num || '/' ||
                 qsp.frequency_denom end) "Frequencia Atual",
       qsp.current_round       "Rodada Atual"
  from apps.gmd_samples                   gs,
       apps.mtl_parameters                mp,
       apps.mtl_system_items_b            msi,
       apps.gme_batch_header              gbh,
       apps.fm_rout_hdr                   frh,
       apps.fm_form_mst                   fm,
       apps.po_headers_all                pha,
       apps.ap_suppliers                  pv,
       apps.gmd_sample_spec_disp          gssd,
       apps.gmd_event_spec_disp           ges,
       apps.gmd_specifications_b          gsb,
       apps.fnd_user                      fu,
       apps.qa_sl_sp_rcv_criteria_v       qss,
       apps.qa_sl_criteria_association_v  qsc,
       apps.qa_plan_collection_triggers_v qc,
       apps.qa_skiplot_rcv_criteria_v     qsr,
       apps.qa_skiplot_plan_state_v       qsp
      -- (select distinct
      --         qc.plan_id,
      --         qc.plan_name,
      --         qc.collection_trigger_description,
      --         qc.low_value
      --    from apps.qa_plan_collection_triggers_v qc) qc 
 where mp.organization_id(+)                = gs.organization_id      and
       msi.organization_id(+)               = mp.organization_id      and
       msi.inventory_item_id(+)             = gs.inventory_item_id    and
       gbh.batch_id(+)                      = gs.batch_id             and
       fm.formula_id(+)                     = gbh.formula_id          and
       frh.routing_id(+)                    = gs.routing_id           and
       pha.po_header_id(+)                  = gs.po_header_id         and
       pv.vendor_id(+)                      = pha.vendor_id           and 
       gssd.sample_id                       = gs.sample_id            and
       ges.event_spec_disp_id(+)            = gssd.event_spec_disp_id and
       gsb.spec_id(+)                       = ges.spec_id             and
       fu.user_id                           = gssd.last_updated_by    and
       qss.item_id(+)                       = msi.inventory_item_id   and
       qss.vendor_id(+)                     = pha.vendor_id           and
       qss.organization_id(+)               = gs.organization_id      and
       qsc.criteria_id(+)                   = qss.criteria_id         and
       qsc.sl_effective_to                  IS NULL                   and
       qc.plan_id(+)                        = qsp.plan_id             and
       qc.collection_trigger_description(+) = 'Item'                  and
       qc.low_value(+)                      = msi.segment1            and
       qsr.item_id(+)                       = msi.inventory_item_id   and
       qsr.vendor_id(+)                     = pha.vendor_id           and
       qsr.effective_to                     IS NULL                   and 
       qsr.organization_id(+)               = gs.organization_id      and
       qsp.process_id(+)                    = qsr.process_id          and
       qsp.criteria_id(+)                   = qsr.criteria_id         and mp.organization_code = 'AMB' and
--       gs.creation_date                    >= sysdate - 376 and  
--       gs.creation_date                    <=  sysdate - 12 --and sample_no = '43512' -- and gs.sample_disposition <> '1P'
       gssd.last_update_date               >= sysdate - 376 and  
       gssd.last_update_date               <=  sysdate - 12 --and sample_no = '43512' -- and gs.sample_disposition <> '1P'
       --and msi.segment1 = 'KPV-607'
       order by gs.CREATION_DATE ;
       
       

select sysdate -  11 from dual;
select * from apps.qa_plan_collection_triggers_v qc;
select * from apps.fm_form_mst fm;
select * from apps.po_headers_all       pha;
select * from apps.ap_suppliers               pv;
select * from apps.gmd_samples          gs;
select * from apps.gmd_sample_spec_disp gssd;
select * from apps.GMD_EVENT_SPEC_DISP where event_spec_disp_id = 251133;
select * from apps.GMD_SPECIFICATIONS_B where spec_id = 25680;

'KH-45-2646'

--- SKIP LOT ----
SELECT * FROM APPS.QA_SKIPLOT_RCV_CRITERIA_V WHERE ITEM = 'SSM-96' and nvl(EFFECTIVE_TO,sysdate+1) > sysdate;
SELECT * FROM APPS.QA_SKIPLOT_RCV_CRITERIA_VAL_V WHERE VENDOR_ID = 8482 AND ITEM_ID = 11938;
SELECT * FROM APPS.QA_SKIPLOT_PROCESSES_V WHERE PROCESS_ID IN (100,109);
SELECT * FROM APPS.QA_SKIPLOT_PROCESS_PLANS_V WHERE PROCESS_ID IN (100,109);
SELECT * FROM APPS.QA_SKIPLOT_PLAN_STATE_V WHERE PROCESS_ID IN (100) AND CRITERIA_ID = 3090;
SELECT * FROM APPS.QA_SKIPLOT_STATE_HISTORY_V;
SELECT * FROM APPS.QA_SKIPLOT_RCV_RESULTS_V;


apps.cll_f189_customers_v       rcv
apps.ap_suppliers               pv,
apps.ap_supplier_sites_all      pvsa,
apps.cll_f189_fiscal_entities_all rfea,


'0PL' = 'Planejado'
'0RT' = 'Reter'
'1P' = 'Pendente'
'4A' = 'Aceitar'
'3C' = 'Concluir'
'4RJ' = 'Rejeitar'
'6RJ' = 'Rejeitar'
'4CN' = 'Cancelar'
'7CN' = 'Cancelar'
'2I'  = 'Em Andamento'
'5AV' = 'Aceitar com Variacao'

select * from apps.fm_rout_hdr;

select * from apps.GMD_SAMPLING_EVENTS where sampling_event_id = 228253; --= 228240;
select * from apps.GMD_SAMPLES where sample_id = 243383;
select * from apps.GMD_SAMPLES_LAB where sample_id = 243383;
select * from apps.GMD_SAMPLE_SPEC_DISP where sample_id =  243383;
select distinct source from apps.gmd_samples        gs;

