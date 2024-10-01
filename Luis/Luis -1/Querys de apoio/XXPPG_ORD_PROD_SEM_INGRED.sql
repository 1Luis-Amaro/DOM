SELECT gbh.organization_code  Organizacao
      ,gbh.batch_no           Ordem
      ,iim.segment1           Item
      ,DECODE(gbh.batch_status,-1,'CANCELADO',1,'PENDENTE',2,'WIP',3,'CONCLUIDO',4,'FECHADO')  Status
      ,gbh.actual_start_date        Dt_Inicio
      ,SUM(NVL(gme2.actual_qty,0))  Qtde_Ingrediente
FROM  apps.mtl_system_items         iim
    , apps.gme_batch_header_vw     gbh
    , apps.gme_material_details  gme1
    , apps.gme_material_details  gme2
WHERE gme1.inventory_item_id      = iim.inventory_item_id
AND   gme1.actual_qty   <> 0
AND   gme1.line_type    = 1
AND   gbh.batch_id      = gme1.batch_id
AND   gme2.batch_id     = gbh.batch_id
AND   gme2.line_type    = -1
AND   gbh.batch_status  > 1
--AND ((TO_CHAR(gbh.actual_start_date,'MM/YYYY')  = '&Periodo')
--  OR (TO_CHAR(gbh.actual_cmplt_date,'MM/YYYY')  = '&Periodo')
--  OR (TO_CHAR(gbh.batch_close_date,'MM/YYYY')   = '&Periodo'))
GROUP BY gbh.plant_code ,gbh.batch_no ,gbh.actual_start_date, iim.segment1,gbh.batch_status
HAVING ( SUM (NVL(gme2.actual_qty,0)) = 0 )
