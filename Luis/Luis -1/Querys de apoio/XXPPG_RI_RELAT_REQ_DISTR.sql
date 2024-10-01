SELECT DISTINCT TO_NUMBER (prha.segment1) requisicao,
                  papfp.full_name Preparador,
                  NVL (papfp.attribute1, 'Nao') permite_alteracao_conta,
                  papfr.full_name Solicitante,
                  msib.segment1 item,
                  prla.destination_type_code,
                  gcck.concatenated_segments
    FROM apps.po_requisition_headers_All prha,
         apps.PO_REQUISITION_LINES_ALL prla,
         apps.po_req_distributions_all prda,
         apps.per_all_people_f papfp,
         apps.per_all_people_f papfr,
         apps.gl_code_combinations_kfv gcck,
         apps.mtl_system_items_b msib
   WHERE     prha.requisition_header_id = prla.requisition_header_id
         AND prla.requisition_line_id = prda.requisition_line_id
         AND prha.preparer_id = papfp.person_id
         AND prla.to_person_id = papfr.person_id
         AND prda.code_combination_id = gcck.code_combination_id
         AND prla.item_id = msib.inventory_item_id
ORDER BY 1, 2
