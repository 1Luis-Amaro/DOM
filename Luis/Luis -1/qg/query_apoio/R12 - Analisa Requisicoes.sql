select * from apps.gme_batch_header
 where batch_no = 75704 and 
       organization_id = 92;
       
       
SELECT DISTINCT
  PPF.FULL_NAME,
  PRD.DISTRIBUTION_ID,
  PRL.DESTINATION_ORGANIZATION_ID,
  PRL.CREATION_DATE,
  PRL.ATTRIBUTE1,
  prl.destination_organization_id,
  prl.SOURCE_ORGANIZATION_ID,
  PRL.ITEM_ID,
  PRL.CANCEL_FLAG,
  PRL.CANCEL_DATE,
  PRL.CANCEL_REASON,
  PRL.ITEM_REVISION,
  PRH.ATTRIBUTE10 ORCAMENTO,
  PRH.REQUISITION_HEADER_ID,
  PRL.REQUISITION_LINE_ID,
  PRH.SEGMENT1 NUMERO_REQ,
  PRL.LINE_NUM,
  PRL.ITEM_REVISION,
  PRL.UNIT_PRICE,
  PRL.QUANTITY,
  PRL.QUANTITY_DELIVERED,
  MSI.SEGMENT1  CODIGO_ITEM,
  PRD.REQ_LINE_QUANTITY,
  SECONDARY_UNIT_OF_MEASURE,
  SECONDARY_QUANTITY,
  PRL.QUANTITY,PRL.UNIT_PRICE,PRL.BASE_UNIT_PRICE,
  FU.USER_NAME MATRICULA_REQUISITANTE,
  PPF.FULL_NAME NOME_REQUISITANTE,
  PRH.AUTHORIZATION_STATUS,
  PRH.TYPE_LOOKUP_CODE,
  PRL.DESTINATION_TYPE_CODE,
  PRH.TRANSFERRED_TO_OE_FLAG,
  PRH.ATTRIBUTE10 ORÇAMENTO,
  PRH.INTERFACE_SOURCE_CODE,
  PRH.APPS_SOURCE_CODE,
  PRH.WF_ITEM_KEY,
  PRH.APPROVED_DATE,
  PRL.REQUISITION_LINE_ID,
  PRL.CATEGORY_ID,   --2002.10722442002442002442002442002442002
  --mcsv.CATEGORY_CONCAT_SEGMENTS CATEGORIA,
  HOU.NAME ORGANIZACAO_DESTINO,
  MP.ORGANIZATION_CODE,
  PRL.ITEM_DESCRIPTION,
  PRL.UNIT_MEAS_LOOKUP_CODE,
  PRL.DELIVER_TO_LOCATION_ID,
  PRL.SOURCE_TYPE_CODE,
  --PRL.ITEM_ID,
  --PRL.SUGGESTED_BUYER_ID,
  PPFF.FULL_NAME COMPRADOR_SUGERIDO,
  PRL.NEED_BY_DATE,
  --PRL.BLANKET_PO_HEADER_ID,
  PHA.SEGMENT1 NUMERO_CONTRATO,
  PRL.BLANKET_PO_LINE_NUM,
  PRL.SUGGESTED_VENDOR_NAME,
  PRL.DESTINATION_TYPE_CODE,
  PRL.SOURCE_SUBINVENTORY,
  --PRL.DESTINATION_ORGANIZATION_ID,
  PRL.SOURCE_ORGANIZATION_ID ORGANIZACAO_ORIGEM,
  PRL.SOURCE_SUBINVENTORY,
  HOU.NAME ORGANIZACAO_DESTINO,
  DESTINATION_SUBINVENTORY,
  PRL.DESTINATION_CONTEXT,
  PRL.TRANSACTION_REASON_CODE,
  PRL.AUCTION_HEADER_ID,
  PRL.AUCTION_LINE_NUMBER,
  PRL.REQS_IN_POOL_FLAG,
  PRL.BID_NUMBER,
  PRL.BID_LINE_NUMBER,
  PRD.PROJECT_ID,
  PRD.TASK_ID,
  PRD.CODE_COMBINATION_ID,
--  PRD.*
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
    AND prl.destination_organization_id = prl.SOURCE_ORGANIZATION_ID
    AND PRH.TYPE_LOOKUP_CODE            = 'INTERNAL' 
    AND NVL(QUANTITY_DELIVERED,0)       > 0;
    --AND prh.segment1 ='54555'


--UPDATE APPS.PO_REQUISITION_LINES_ALL SET REQS_IN_POOL_FLAG = NULL WHERE REQUISITION_HEADER_ID = 963003;

/* select * from APPS.PO_REQUISITION_LINES_ALL where requisition_line_id = 3491833 FOR UPDATE

DELETE FROM APPS.PO_REQUISITION_LINES_ALL  WHERE requisition_header_id = 2935005;
DELETE FROM APPS.po_req_distributions_all  WHERE REQUISITION_LINE_ID = 1909535;
DELETE FROM apps.po_requisition_headers_all WHERE requisition_header_id = 2935005;*/
/*
select * from APPS.PO_REQUISITION_HEADERS_ALL where segment1 in('2167') and org_id in(170);
select * from APPS.PO_REQUISITION_LINES_ALL where requisition_header_id in(7192881);

SELECT * FROM APPS.PO_REQUISITION_LINES_ALL WHERE REQUISITION_HEADER_ID IN(4424104);
UPDATE APPS.PO_REQUISITION_LINES_ALL SET REQS_IN_POOL_FLAG = 'Y' WHERE REQUISITION_HEADER_ID IN(4424104);

UPDATE APPS.PO_REQ_DISTRIBUTIONS_ALL A SET REQ_LINE_QUANTITY = (SELECT QUANTITY FROM APPS.PO_REQUISITION_LINES_ALL WHERE REQUISITION_LINE_ID = A.REQUISITION_LINE_ID)
WHERE REQUISITION_LINE_ID IN(SELECT REQUISITION_LINE_ID FROM APPS.PO_REQUISITION_LINES_ALL WHERE REQUISITION_HEADER_ID IN(4424104));

UPDATE APPS.po_requisition_headers_all SET AUTHORIZATION_STATUS = 'APPROVED',APPROVED_DATE = SYSDATE WHERE SEGMENT1 IN('4') and ORG_ID = 229;

update apps.po_requisition_lines_all set item_revision = null where requisition_header_id = (select requisition_header_id from apps.po_requisition_headers_all where segment1 = '30' and org_id = 171)

*/

       
      