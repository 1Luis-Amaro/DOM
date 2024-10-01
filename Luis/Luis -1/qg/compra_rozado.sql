select mp.organization_code,
       item,
       CATEGORY_CONCAT_SEGS,
       periodo,
       sum(qtd),
       (select sum(CMPNT_COST) 
         from apps.cm_cmpt_dtl ccd,
              apps.mtl_system_items_b msip
        where ccd.inventory_item_id = msip.inventory_item_id
          AND msip.inventory_item_id= tab.inventory_item_id
          AND msip.organization_id  = tab.organization_id
          AND ccd.organization_id   = tab.organization_id
          AND cost_type_id          = '1005'
          AND COST_ANALYSIS_CODE    = 'MT'
          AND period_id         = (SELECT MAX(cstt.period_id)
                                     FROM apps.CM_CMPT_DTL cstt, apps.gmf_period_statuses gps
                                    WHERE gps.cost_type_id       = cstt.cost_type_id
                                      AND cstt.period_id         = gps.period_id
                                      AND cstt.delete_mark       = '0'
                                      AND cstt.organization_id   = tab.organization_id
                                      AND cstt.inventory_item_id = tab.inventory_item_id
                                      AND cstt.cost_type_id      = '1005'
                                      AND cmpnt_cost       <> 0)) Custo_item
  from (SELECT psi.organization_id,
               psi.item_name item,
               psi.sr_inventory_item_id inventory_item_id,
               CATEGORY_CONCAT_SEGS,
               TO_CHAR (mo1.new_due_date, 'YYYYMM') periodo,
               mo1.quantity_rate qtd
          FROM apps.msc_orders_v mo1,
               msc.msc_category_set_id_lid mcl,
               msc.msc_plans msp,
               msc.msc_system_items psi,
               apps.mtl_item_categories_v micv 
         WHERE     mo1.category_set_id       = mcl.category_set_id
               AND mcl.sr_category_set_id    = micv.category_set_id
               AND mo1.source_table          = 'MSC_SUPPLIES'
               AND TO_CHAR (mo1.new_due_date, 'YYYYMM') >= TO_CHAR (ADD_MONTHS (SYSDATE, 0), 'RRRRMM') -- alterado para "<=" de old para new
               AND mo1.order_type IN (1,5,8)                   -- Purchase Order, Planned order, PO in receiving
               AND mo1.inventory_item_id     = psi.inventory_item_id
               AND mo1.organization_id       = msp.organization_id
               AND mo1.plan_id               = msp.plan_id 
               AND msp.COMPILE_DESIGNATOR like '%0921%' --Período do Plano
               AND psi.plan_id               = msp.plan_id
               AND psi.organization_id       = msp.organization_id
               AND msp.organization_id       = micv.organization_id
               AND psi.sr_inventory_item_id  = micv.inventory_item_id
               AND micv.category_set_id      = 1) tab,
         apps.mtl_parameters mp
       where mp.organization_id = tab.organization_id
         group by mp.organization_code, item, periodo, tab.inventory_item_id, tab.organization_id, CATEGORY_CONCAT_SEGS
         order by 1,2;
       
       
select * from apps.MSC_DESIGNATORS ;
select * from msc.msc_plans msp where COMPILE_DESIGNATOR like '%0621%';
select * from msc.msc_system_items psi;
select * from apps.mtl_item_categories_v micv; 
select DISTINCT ORDER_TYPE, ORDER_TYPE_TEXT from apps.msc_orders_v mo1 WHERE mo1.source_table = 'MSC_SUPPLIES' AND TO_CHAR (mo1.new_due_date, 'YYYYMM') <= TO_CHAR (ADD_MONTHS (SYSDATE, 0), 'RRRRMM') ORDER BY 1;       