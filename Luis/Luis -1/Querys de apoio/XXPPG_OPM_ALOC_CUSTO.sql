SELECT  gbh.organization_code         "Planta"
       ,gbh.batch_no           "Ordem"
       ,gbh.ATTRIBUTE1         "Grupo"
       ,iim.segment1            "Item"
       ,iim.description         "Descrição"
       ,iim.primary_uom_code            "Um"
       ,gbh.ACTUAL_START_DATE  "Data Start OP"
       ,gmd.actual_qty         "Quant"
       ,DECODE(gbh.batch_status,-1,'Cancelada',1,'Pendente',2,'WIP',3,'Concluida',4,'Fechada') "Status"
       ,DECODE(gmd.line_type,-1,'Ingrediente',1,'Produto')  "Consumo"
       ,gmd.COST_ALLOC         "Custo"
FROM    apps.gme_batch_header_vw      gbh
       ,apps.mtl_system_items_b         iim
       ,apps.gme_material_details  gmd
WHERE   gmd.batch_id      = gbh.batch_id
  AND   iim.inventory_item_id       = gmd.inventory_item_id
  AND   gbh.batch_status  > -1
  AND   gmd.line_type     in (1)
 -- AND ((TO_CHAR(GBH.ACTUAL_START_DATE,'MM/YYYY') = '&Periodo' )
 --   OR (TO_CHAR(GBH.ACTUAL_CMPLT_DATE,'MM/YYYY') = '&Periodo' )
--    OR (TO_CHAR(GBH.BATCH_CLOSE_DATE,'MM/YYYY')  = '&Periodo' ))
  AND   gmd.cost_alloc    = 0
ORDER BY gbh.batch_no