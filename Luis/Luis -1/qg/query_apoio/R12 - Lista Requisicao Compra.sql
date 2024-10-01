SELECT (prha.segment1) requisicao,
       prha.creation_date,
      (SELECT organization_code
         FROM apps.mtl_parameters
        WHERE organization_id = prla.destination_organization_id ) ORG,
       papfp.full_name Preparador,
       papfr.full_name Solicitante,
      (SELECT aprovador 
        FROM(SELECT sequence_num,
                    action_date,
                    action_code_dsp,
                    employee_name aprovador,
                    object_id          
               FROM apps.po_action_history_v
              WHERE object_type_code = 'REQUISITION' 
              ORDER BY object_id, sequence_num DESC)
       WHERE ROWNUM = 1 
         AND object_id = prha.requisition_header_id) aprovador,
       prha.authorization_status status_Requisicao,
       prla.line_num,
       msib.segment1 item,
       msib.description descricao_item,
       prda.req_line_quantity qtde_solicitada,
       prla.unit_price preco_unitario_req,      
       prda.req_line_quantity * prla.unit_price valor_previsto,
       po.po pedido_compra,
       po.status status_pedido,
       po.moeda moeda_pedido,
       po.rate  taxa_conversao,
       po.total*po.rate valor_brl_realizado_pc,
       po.qtde_recebida,
       po.qtde_faturada,
       po.valor_recebido*po.rate valor_brl_recebido,
       po.valor_faturado*po.rate valor_brl_faturado,
       prla.destination_type_code,       
       gcck.concatenated_segments ,
       prla.note_to_agent,
       prla.note_to_receiver,
       prla.suggested_vendor_name, 
       prla.suggested_vendor_location, 
       prla.suggested_vendor_contact
  FROM apps.po_requisition_headers_All prha,
       apps.po_requisition_lines_all prla,
       apps.po_req_distributions_all prda,
       apps.per_all_people_f papfp,
       apps.per_all_people_f papfr,
       apps.gl_code_combinations_kfv gcck,
       apps.mtl_system_items_b msib,
      (SELECT ph.segment1 po, prh.segment1 req,trunc(ph.creation_date) rate_date, ph.agent_id suggested_buyer_id
             ,round(SUM((pd.quantity_ordered - Nvl(pd.quantity_cancelled, 0))*pll.price_override),2) total
             ,round(SUM(pd.quantity_delivered),2)  qtde_recebida
             ,round(SUM(pd.quantity_billed),2)    qtde_faturada
             ,round(SUM(pd.quantity_delivered*pll.price_override),2)  valor_recebido
             ,round(SUM(pd.quantity_billed*pll.price_override),2)    valor_faturado
             , ph.currency_code moeda, NVL(ph.rate,1) rate, ph.authorization_status status, prd.distribution_id
        FROM po.po_headers_all ph, po.po_lines_all pl, po.po_line_locations_all pll
        ,    po.po_distributions_all pd, po.po_req_distributions_all prd
        ,    po.po_requisition_lines_all prl, po.po_requisition_headers_all prh
        WHERE   ph.po_header_id = pl.po_header_id AND pl.po_line_id = pll.po_line_id
        AND     pll.line_location_id = pd.line_location_id AND ph.type_lookup_code = 'STANDARD'
        AND     pd.req_distribution_id = prd.distribution_id(+)
        AND     prd.requisition_line_id = prl.requisition_line_id(+)
        AND     prl.requisition_header_id = prh.requisition_header_id(+)
        GROUP BY ph.segment1, prh.segment1, trunc(ph.creation_date) , prd.distribution_id,ph.authorization_status,ph.type_lookup_code, ph.po_header_id, ph.ame_approval_id, ph.agent_id, ph.currency_code, NVL(ph.rate,1)) po
  WHERE prha.requisition_header_id = prla.requisition_header_id
    AND prla.requisition_line_id = prda.requisition_line_id
    AND prha.preparer_id = papfp.person_id
    AND prla.to_person_id = papfr.person_id
    AND prda.code_combination_id = gcck.code_combination_id
    AND prla.item_id = msib.inventory_item_id
    AND prla.destination_organization_id = msib.organization_id
    AND prla.destination_organization_id IN( 86,81)
    AND prha.type_lookup_code = 'PURCHASE'
    AND trunc(papfp.EFFECTIVE_END_DATE) > trunc(sysdate)-1
    AND trunc(papfr.EFFECTIVE_END_DATE) > trunc(sysdate)-1
    --
    AND prda.distribution_id = po.distribution_id(+)
    -- 
    AND prha.creation_date BETWEEN '01-JAN-2017' AND '31-DEC-2017'
   ORDER BY 1, 5;

