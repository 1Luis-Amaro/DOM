SELECT DISTINCT
  PRH.SEGMENT1                      NUMERO_REQ,
  TRANSLATE(TRANSLATE(TRANSLATE(SUBSTR(PRH.DESCRIPTION,1,180),'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890—¡…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’ƒÀœ÷‹«Ò·ÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ı‰ÎÔˆ¸Áñ|∫™≤∞.-!"''`#$%().:[/]{}®+???ø;ß&¥*<>'
                                                             ,'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890NAEIOUAEIOUAEIOUAOAEIOUCnaeiouaeiouaeiouaoaeiouc-!'),CHR(10),' '),CHR(13),' ') "Descricao",
  PRH.AUTHORIZATION_STATUS          STATUS_APROVACAO,
  PRH.TYPE_LOOKUP_CODE              TIPO_REQ,
  FU.USER_NAME                      REQUISITANTE,
  PPF.FULL_NAME                     NOME,
 (SELECT mp.organization_code from apps.mtl_parameters mp where mp.organization_id = PRL.DESTINATION_ORGANIZATION_ID) ORG_DESTINO,
  PRH.CREATION_DATE,
  (SELECT mp.organization_code from apps.mtl_parameters mp where mp.organization_id = prl.destination_organization_id) ORG_DESTINO_LINHA,
  PRL.LINE_NUM,
  PRL.UNIT_PRICE,
  PRL.QUANTITY,
  MSI.SEGMENT1  CODIGO_ITEM,
  PRD.REQ_LINE_QUANTITY,
  PRL.DESTINATION_TYPE_CODE,
  PRH.APPROVED_DATE,
  MP.ORGANIZATION_CODE,
  TRANSLATE(TRANSLATE(TRANSLATE(SUBSTR(PRL.ITEM_DESCRIPTION,1,180),'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890—¡…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’ƒÀœ÷‹«Ò·ÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ı‰ÎÔˆ¸Áñ|∫™≤∞.-!"''`#$%().:[/]{}®+???ø;ß&¥*<>'
                                                                  ,'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890NAEIOUAEIOUAEIOUAOAEIOUCnaeiouaeiouaeiouaoaeiouc-!'),CHR(10),' '),CHR(13),' ') "Descricao",
  PRL.UNIT_MEAS_LOOKUP_CODE,
  PPFF.FULL_NAME COMPRADOR_SUGERIDO,
  PRL.NEED_BY_DATE,
  CASE WHEN po.segment1     IS NOT NULL THEN 'PO - ' || po.segment1     || '/' || po.line_num
       WHEN oh.order_number IS NOT NULL THEN 'SO - ' || oh.order_number || '/' || ol.line_number
       ELSE '' 
  END  Ordem,
  PHA.SEGMENT1 NUMERO_CONTRATO,
  PRL.BLANKET_PO_LINE_NUM,
  PRL.SUGGESTED_VENDOR_NAME,
  (SELECT mp.organization_code from apps.mtl_parameters mp where mp.organization_id = PRL.SOURCE_ORGANIZATION_ID) ORG_ORIGEM,
  PRL.SOURCE_SUBINVENTORY,
  DESTINATION_SUBINVENTORY,
  PRL.TRANSACTION_REASON_CODE,
  GCC.SEGMENT1||'.'||GCC.SEGMENT2||'.'||GCC.SEGMENT3||'.'||GCC.SEGMENT4||'.'||GCC.SEGMENT5||'.'||GCC.SEGMENT6 CONTA_CONTABIL
  FROM apps.po_requisition_headers_all  prh,
       apps.po_requisition_lines_all    prl,
       apps.po_req_distributions_all    prd,
       apps.fnd_user                    fu,
       apps.per_people_f                ppf,
       apps.hr_organization_units_v     hou,
       apps.po_headers_all              pha,
       apps.gl_code_combinations_v      gcc,
       apps.per_people_f                ppff,
       apps.mtl_system_items_b          msi,
       apps.mtl_parameters              mp,
       apps.oe_order_headers_all oh,
       apps.oe_order_lines_all ol,
       (SELECT ph.segment1,
               pl.line_num,
               pd.req_distribution_id
          FROM po.po_headers_all ph,
               po.po_lines_all pl,
               po.po_line_locations_all pll,
               po.po_distributions_all pd
         WHERE ph.po_header_id      = pl.po_header_id     AND
               pl.po_line_id        = pll.po_line_id      AND
               pll.line_location_id = pd.line_location_id AND
               ph.type_lookup_code  = 'STANDARD') PO
  WHERE prh.requisition_header_id       = prl.requisition_header_id
    AND prl.requisition_line_id         = prd.requisition_line_id
    AND prh.preparer_id                 = ppf.person_id(+)
    AND PPF.PERSON_ID                   = FU.EMPLOYEE_ID(+)
    AND prl.destination_organization_id = hou.organization_id
    AND prl.blanket_po_header_id        = pha.po_header_id(+)
    AND prd.code_combination_id         = gcc.code_combination_id(+)
    AND Nvl(prl.suggested_buyer_id,0)   = ppff.person_id(+)
    AND Nvl(prl.item_id,0)              = msi.inventory_item_id(+)
    AND prl.destination_organization_id = mp.organization_id(+)
    AND nvl(prl.cancel_flag,'N')            <> 'Y'
    AND PRH.CREATION_DATE            >= SYSDATE - 200
    and po.req_distribution_id(+)     = prd.distribution_id
    AND ol.header_id(+)               = oh.header_id
    AND ol.source_document_line_id(+) = prl.requisition_line_id
    AND oh.orig_sys_document_ref(+)   = prh.segment1;
    
    
select distinct PRH.TYPE_LOOKUP_CODE from  apps.po_requisition_headers_all  prh;   
---------------------------------------                          

SELECT DISTINCT
  PRH.SEGMENT1                      NUMERO_REQ,
  TRANSLATE(TRANSLATE(TRANSLATE(SUBSTR(PRH.DESCRIPTION,1,180),'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890—¡…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’ƒÀœ÷‹«Ò·ÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ı‰ÎÔˆ¸Áñ∫™≤∞.-!"''`#$%().:[/]{}®+???ø;ß&¥*<>'
                                                             ,'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890NAEIOUAEIOUAEIOUAOAEIOUCnaeiouaeiouaeiouaoaeiouc-'),CHR(10),' '),CHR(13),' ') "Descricao",
  ascII(substr(PRH.DESCRIPTION,30,1)),
  substr(PRH.DESCRIPTION,30,1),  
  PRH.AUTHORIZATION_STATUS          STATUS_APROVACAO
  FROM apps.po_requisition_headers_all  prh,
       apps.po_requisition_lines_all    prl,
       apps.po_req_distributions_all    prd,
       apps.fnd_user                    fu,
       apps.per_people_f                ppf,
       apps.hr_organization_units_v     hou,
       apps.po_headers_all              pha,
       apps.gl_code_combinations_v      gcc,
       apps.per_people_f                ppff,
       apps.mtl_system_items_b          msi,
       apps.mtl_parameters              mp
  WHERE prh.requisition_header_id       = prl.requisition_header_id
    AND prl.requisition_line_id         = prd.requisition_line_id
    AND prh.preparer_id                 = ppf.person_id(+)
    AND PPF.PERSON_ID                   = FU.EMPLOYEE_ID(+)
  --AND prl.category_id = mcsv.category_id
    AND prl.destination_organization_id = hou.organization_id
    AND prl.blanket_po_header_id        = pha.po_header_id(+)
    AND prd.code_combination_id         = gcc.code_combination_id(+)
    AND Nvl(prl.suggested_buyer_id,0)   = ppff.person_id(+)
    AND Nvl(prl.item_id,0)              = msi.inventory_item_id(+)
    AND prl.destination_organization_id = mp.organization_id(+)
    AND nvl(prl.cancel_flag,'N') <> 'Y'
    and nvl(PRH.TRANSFERRED_TO_OE_FLAG,'N') <> 'Y'
    and prh.segment1 = '85504'
    --AND PRH.AUTHORIZATION_STATUS <> 'RETURNED'
    AND not exists(SELECT ph.segment1
                     FROM po.po_headers_all ph,
                          po.po_lines_all pl,
                          po.po_line_locations_all pll,
                          po.po_distributions_all pd
                    WHERE ph.po_header_id           = pl.po_header_id AND
                          pl.po_line_id             = pll.po_line_id AND
                          pll.line_location_id      = pd.line_location_id AND
                          ph.type_lookup_code       = 'STANDARD' AND
                          pd.req_distribution_id    = prd.distribution_id)
;

SELECT * from po.po_lines_all pl;

select * from apps.oe_order_lines_all ol;