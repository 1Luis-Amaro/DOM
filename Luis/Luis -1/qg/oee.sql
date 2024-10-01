
select relatorio.*,
       ((L_Availability / 100) * (L_Performance / 100) * (L_Quality / 100)) *100 L_OEE
from (
select oee.*,
       (((to_date('30/11/2023','dd/mm/yyyy') - to_date('01/11/2023','dd/mm/yyyy') ) * 24 * 60 * 60 ) - l_time_out) l_time_available,
       (((l_time_processed /60) / 60) * oee.CAPACITY_HOUR) L_Tota_Capacity,
       (L_Time_processed / (((to_date('30/11/2023','dd/mm/yyyy') - to_date('01/11/2023','dd/mm/yyyy') ) * 24 * 60 * 60 ) - l_time_out)) * 100 L_Availability,
       ( L_Total_Produced / nvl((((l_time_processed /60) / 60) * oee.CAPACITY_HOUR),1) ) *100 L_Performance,
       ( (L_Total_Produced - L_TOTAL_NOK ) / nvl(L_Total_Produced,1) )* 100 L_Quality
  from
(select temp.*,
       /*(SELECT SUM(turno)
                   FROM (
                SELECT    bomcd.calendar_date
                        , bomsd.shift_date
                        , bomsd.shift_num
                        , bomst.from_time
                        , bomst.to_time
                        , CASE WHEN bomst.from_time > bomst.to_time THEN 
                            86400-bomst.from_time+bomst.to_time
                            ELSE abs(bomst.from_time - bomst.to_time) 
                         END turno
                FROM apps.bom_calendar_dates bomcd
                , apps.bom_shift_dates bomsd
                , apps.bom_shift_times bomst
                WHERE 1=1
                AND bomcd.calendar_code = x.calendar -- parametro
                AND bomcd.calendar_code = bomsd.calendar_code
                AND bomcd.calendar_code = bomst.calendar_code
                AND bomsd.shift_num     = bomst.shift_num
                AND bomcd.calendar_date = bomsd.shift_date
-- suggestion for tiket 10798971
                AND trunc(bomcd.calendar_date) >= to_date('01/11/2023','dd/mm/yyyy') 
                AND trunc(bomcd.calendar_date) <= to_date('30/11/2023','dd/mm/yyyy')
-- suggestion for tiket 10798971
                AND bomcd.seq_num is not null
                AND NOT EXISTS (  SELECT 1
                                    FROM apps.BOM_CALENDAR_EXCEPTIONS bomce1
                                    WHERE 1=1
                                     AND bomce1.EXCEPTION_DATE = bomcd.calendar_date
                                     AND bomce1.CALENDAR_CODE = bomcd.calendar_code
                                        )
                )
                ) l_time_available,*/
      (SELECT SUM((xrb.END_DATE - xrb.START_DATE) * (60 * 60 * 24))  segundo
                  FROM apps.gme_batch_header          gbh,
                       apps.mtl_system_items_b        msi,
                       apps.mtl_parameters            mp,
                       apps.mtl_item_categories_v     mic,
                       apps.xxppg_resource_batch_step xrb,
                       apps.gme_material_details      gmd,
                       apps.fnd_lookup_values_vl      flv,
                        (
                            SELECT lookup_code resource_code , tag routing_class, attribute2 calendar
                            FROM apps.fnd_lookup_values
                            WHERE lookup_type        ='XXPPG_RESOURCE'
                            AND LANGUAGE             = USERENV ('LANG')
                            AND NVL(enabled_flag,'N')='Y'
                            AND (END_DATE_ACTIVE    >= SYSDATE
                            OR END_DATE_ACTIVE      IS NULL)
                        ) x1
                 WHERE 1=1
                    AND gbh.batch_id           = xrb.batch_id            
                    AND gbh.organization_id    = mp.organization_id      
                    AND gmd.batch_id           = gbh.batch_id            
                    AND gmd.line_type          = 1                       
                    AND msi.inventory_item_id  = gmd.inventory_item_id   
                    AND msi.organization_id    = gmd.organization_id     
                    AND flv.lookup_type        = 'XXPPG_RESOURCE_STATUS' 
                    AND upper(flv.lookup_code) = upper(xrb.status)              
                    AND xrb.resource_code      = x1.resource_code
                    AND flv.attribute4         = 'S'                     
                    AND mic.inventory_item_id  = msi.inventory_item_id   
                    AND mic.organization_id    = 87                    
                    AND mic.category_set_id    = 1 -- Inventory Category --
                --
                    and gbh.organization_id   = temp.organization_id --92
                    and xrb.RESOURCE_CODE     = temp.RESOURCES 
                    and x1.routing_class      = NVL('',x1.routing_class)
-- suggestion for tiket 10798971
                    and trunc(gbh.actual_cmplt_date) BETWEEN to_date('01/11/2023','dd/mm/yyyy') AND to_date('30/11/2023','dd/mm/yyyy')) l_time_processed,
             (SELECT SUM((xrb.END_DATE - xrb.START_DATE) * (60 * 60 * 24))  segundo
                  FROM apps.gme_batch_header          gbh,
                       apps.mtl_system_items_b        msi,
                       apps.mtl_parameters            mp,
                       apps.mtl_item_categories_v     mic,
                       apps.xxppg_resource_batch_step xrb,
                       apps.gme_material_details      gmd,
                       apps.fnd_lookup_values_vl      flv,
                        (
                            SELECT lookup_code resource_code , tag routing_class, attribute2 calendar
                            FROM apps.fnd_lookup_values
                            WHERE lookup_type        ='XXPPG_RESOURCE'
                            AND LANGUAGE             = USERENV ('LANG')
                            AND NVL(enabled_flag,'N')='Y'
                            AND (END_DATE_ACTIVE    >= SYSDATE
                            OR END_DATE_ACTIVE      IS NULL)
                        ) x1
                 WHERE 1=1
                    AND gbh.batch_id           = xrb.batch_id            
                    AND gbh.organization_id    = mp.organization_id      
                    AND gmd.batch_id           = gbh.batch_id            
                    AND gmd.line_type          = 1                       
                    AND msi.inventory_item_id  = gmd.inventory_item_id   
                    AND msi.organization_id    = gmd.organization_id     
                    AND flv.lookup_type        = 'XXPPG_RESOURCE_STATUS' 
                    AND upper(flv.lookup_code) = 'FORA DE TURNO'              
                    AND xrb.resource_code      = x1.resource_code
-- suggestion for tiket 10798971
                    AND upper(xrb.status)      = upper(flv.lookup_code)
-- suggestion for tiket 10798971
                    AND mic.inventory_item_id  = msi.inventory_item_id   
                    AND mic.organization_id    = 87                    
                    AND mic.category_set_id    = 1 -- Inventory Category --
                --
                    and gbh.organization_id   = temp.organization_id --92
                    and xrb.RESOURCE_CODE     = temp.RESOURCES 
                    and x1.routing_class      = NVL('',x1.routing_class)
-- suggestion for tiket 10798971
                    and trunc(gbh.actual_cmplt_date) >= to_date('01/11/2023','dd/mm/yyyy')
                    and trunc(gbh.actual_cmplt_date) <= to_date('30/11/2023','dd/mm/yyyy')) l_time_out,
      (SELECT SUM(gmd.actual_qty)   
                  FROM apps.gme_batch_header          gbh,
                       apps.mtl_system_items_b        msi,
                       apps.mtl_parameters            mp,
                       apps.mtl_item_categories_v     mic,
                       apps.gme_material_details      gmd,
                       apps.fnd_lookup_values_vl      flv,
                        (
                            SELECT lookup_code resource_code , tag routing_class, attribute2 calendar
                            FROM apps.fnd_lookup_values
                            WHERE lookup_type        ='XXPPG_RESOURCE'
                            AND LANGUAGE             = USERENV ('LANG')
                            AND NVL(enabled_flag,'N')='Y'
                            AND (END_DATE_ACTIVE    >= SYSDATE
                            OR END_DATE_ACTIVE      IS NULL)
                        ) x1
                 WHERE 1=1
                    AND gbh.organization_id    = mp.organization_id      
                    AND gmd.batch_id           = gbh.batch_id            
                    AND gmd.line_type          = 1                       
                    AND msi.inventory_item_id  = gmd.inventory_item_id   
                    AND msi.organization_id    = gmd.organization_id     
                    AND flv.lookup_type        = 'XXPPG_RESOURCE_STATUS' 
                    AND upper(flv.lookup_code) = 'FORA DE TURNO'              
                    AND temp.RESOURCES         = x1.resource_code
                    AND mic.inventory_item_id  = msi.inventory_item_id   
                    AND mic.organization_id    = 87                    
                    AND mic.category_set_id    = 1 -- Inventory Category --
                --
                    and gbh.organization_id   = 92
                    and x1.routing_class      = NVL('PO',x1.routing_class)
                    and trunc(gbh.actual_cmplt_date) >= to_date('01/11/2023','dd/mm/yyyy')
                    and trunc(gbh.actual_cmplt_date) <= to_date('30/11/2023','dd/mm/yyyy')
                    and exists (select batch_id
                                  from apps.xxppg_resource_batch_step xrb 
                                 where xrb.batch_id = gbh.batch_id 
                                   and xrb.RESOURCE_CODE     = temp.RESOURCES)) L_Total_Produced,
      (SELECT SUM(to_number(NVL(gbh.attribute14,0))) L_TOTAL_NOK
                  FROM apps.gme_batch_header          gbh,
                       apps.mtl_system_items_b        msi,
                       apps.mtl_parameters            mp,
                       apps.mtl_item_categories_v     mic,
                       apps.gme_material_details      gmd,
                       apps.fnd_lookup_values_vl      flv,
                        (
                            SELECT lookup_code resource_code , tag routing_class, attribute2 calendar
                            FROM apps.fnd_lookup_values
                            WHERE lookup_type        ='XXPPG_RESOURCE'
                            AND LANGUAGE             = USERENV ('LANG')
                            AND NVL(enabled_flag,'N')='Y'
                            AND (END_DATE_ACTIVE    >= SYSDATE
                            OR END_DATE_ACTIVE      IS NULL)
                        ) x1
                 WHERE 1=1
                    AND gbh.organization_id    = mp.organization_id      
                    AND gmd.batch_id           = gbh.batch_id            
                    AND gmd.line_type          = 1                       
                    AND msi.inventory_item_id  = gmd.inventory_item_id   
                    AND msi.organization_id    = gmd.organization_id     
                    AND flv.lookup_type        = 'XXPPG_RESOURCE_STATUS' 
                    AND upper(flv.lookup_code) = 'FORA DE TURNO'              
                    AND temp.RESOURCES            = x1.resource_code
                    AND mic.inventory_item_id  = msi.inventory_item_id   
                    AND mic.organization_id    = 87                    
                    AND mic.category_set_id    = 1 -- Inventory Category --
                --
                    and gbh.organization_id   = temp.organization_id --92
                    and x1.routing_class      = NVL('',x1.routing_class)
                    and trunc(gbh.actual_cmplt_date) >= to_date('01/11/2023','dd/mm/yyyy')
                    and trunc(gbh.actual_cmplt_date) <= to_date('30/11/2023','dd/mm/yyyy')
                    and exists (select batch_id
                                  from apps.xxppg_resource_batch_step xrb 
                                 where xrb.batch_id = gbh.batch_id 
                                   and xrb.RESOURCE_CODE     = temp.RESOURCES)) L_TOTAL_NOK
  from
    (select mp.organization_code                  INV_ORGANIZATION
        , gbh.organization_id
        , xrb.resource_code                      RESOURCES
        ,(NVL(x.capacity_hour,0))                CAPACITY_HOUR
        , NVL(x.capacity_hour,0)                 CAPACITY_HOUR_SEG
        , x.calendar                             calendar
        , SUM(gmd.actual_qty)                    Total_Produced    
        , SUM(to_number(NVL(gbh.attribute14,0))) TOTAL_NOK
    from apps.gme_batch_header gbh,
         apps.mtl_system_items_b msi,
         apps.mtl_parameters mp,
         apps.mtl_item_categories_v mic,
         apps.xxppg_resource_batch_step xrb,
         apps.gme_material_details gmd,
          (
                SELECT lookup_code resource_code , tag routing_class, attribute2 calendar, attribute3 capacity_hour
                FROM apps.fnd_lookup_values
                WHERE lookup_type        ='XXPPG_RESOURCE'
                AND LANGUAGE             = USERENV ('LANG')
                AND NVL(enabled_flag,'N')='Y'
                AND NVL(END_DATE_ACTIVE,SYSDATE +1)    >= SYSDATE
           ) x
    where 1=1
        and gbh.batch_id = xrb.batch_id 
        and gbh.organization_id = mp.organization_id 
        and gmd.batch_id = gbh.batch_id 
        and gmd.line_type = 1 
        and msi.inventory_item_id = gmd.inventory_item_id 
        and msi.organization_id = gmd.organization_id 
        and mic.inventory_item_id = msi.inventory_item_id 
        and mic.organization_id = 87 
        and mic.category_set_id = 1 
        and xrb.resource_code = x.resource_code
    --
        and gbh.organization_id   = 92--
       -- and xrb.RESOURCE_CODE     = NVL(P_RESOURCE,xrb.RESOURCE_CODE) --'IND'   -- 
        and x.routing_class       = NVL('',x.routing_class)--'PO'-- 

    -- suggestion for tiket 10798971
        and trunc(gbh.actual_cmplt_date) BETWEEN to_date('01/11/2023','dd/mm/yyyy') AND to_date('30/11/2023','dd/mm/yyyy')
    -- suggestion for tiket 10798971

    group by mp.organization_code
        , xrb.resource_code
        , x.calendar    
        , NVL(x.capacity_hour,0)
        , gbh.organization_id
    order by mp.organization_code) temp) oee) relatorio;