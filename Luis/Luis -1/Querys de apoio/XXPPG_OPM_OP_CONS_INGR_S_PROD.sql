SELECT gbh.organization_code               "Planta"
      ,BATCH_NO                     "Op"
      ,IIM.segment1                  "Item"
      ,DECODE(GBH.BATCH_STATUS,-1,'CANCELADO',1,'PENDENTE',2,'WIP',3,'CONCLUIDO',4,'FECHADO') "Status"
      ,GBH.ACTUAL_START_DATE        "Dt.Inicio"
      ,SUM (NVL(GME1.ACTUAL_QTY,0)) "Qtde Produto"
      ,SUM (NVL(GME2.ACTUAL_QTY,0)) "Qtde Ingrediente"
     
FROM apps.mtl_system_items            IIM
   , apps.gme_batch_header_vw       GBH
   , apps.GME_MATERIAL_DETAILS   GME1
   , apps.GME_MATERIAL_DETAILS    GME2
WHERE GME1.inventory_item_id      = IIM.inventory_item_id
AND   GME1.LINE_TYPE    = 1
AND   GBH.BATCH_ID      = GME1.BATCH_ID
AND   GME2.BATCH_ID     = GBH.BATCH_ID
AND   GME2.LINE_TYPE    = -1
AND   GME2.ACTUAL_QTY   != 0
AND   GBH.BATCH_STATUS  > 1
--AND ((TO_CHAR(GBH.ACTUAL_START_DATE,'MM/YYYY')  = '&Periodo')
--  OR (TO_CHAR(GBH.ACTUAL_CMPLT_DATE,'MM/YYYY')  = '&Periodo')
--  OR (TO_CHAR(GBH.BATCH_CLOSE_DATE,'MM/YYYY')   = '&Periodo'))
GROUP BY PLANT_CODE ,GBH.ACTUAL_START_DATE, BATCH_NO ,IIM.segment1,GBH.BATCH_STATUS
HAVING SUM (NVL(GME1.ACTUAL_QTY,0)) = 0