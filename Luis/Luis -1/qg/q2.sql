Select organization_code     Org
      ,item_segments         Item
      ,a.description         Descrição
      ,a.category_name       Categoria
      ,a.buyer_name          Comprador
      ,a.planner_code        Planejador
      ,a.quantity_rate       Qtd_Taxa
      ,a.ORDER_NUMBER        Nr_da_Ordem
      ,b.meaning             Tipo_Ordem
      ,a.action              Ação
      ,a.alternate_bom_designator   BOM_Alter
      ,a.schedule_group_name        Grupo_Progr
      ,a.ORIGINAL_QUANTITY          Qtd_Con_L
      ,a.demand_class               Classe_Deman
      ,a.schedule_ship_date         Data_Ent_Program
      ,a.OLD_ORDER_QUANTITY         Qtd_Ord_Orig
      ,( SELECT sum (consumed_qty)
           FROM apps.msc_forecast_updates k
          where k.inventory_item_id  = a.inventory_item_id
            and k.organization_id  = a.organization_id
            and a.schedule_designator_id  = k.designator_id
            and a.plan_id  = k.plan_id
            and  k.forecast_demand_id  =  a.transaction_id
            group by  k.inventory_item_id
                    , k.designator_id
                    , k.plan_id
                    , k.forecast_demand_id )  Prev_Consum
      , a.NEW_DUE_DATE                     Data_Vencim_Sug
      , a.NEW_START_DATE                   Data_Inic_Sug
      , trunc (a.old_due_date)             Data_Vencim_Ant
      , a.PROMISE_DATE                     Data_Cheg_Promet
      , a.FIRM_DATE                        Nova_Data
      , a.FIRM_QUANTITY                    Nova_Qtde
      , a.DEMAND_PRIORITY                  Prior_Ordem
 from  apps.msc_orders_v     a
      ,apps.mfg_lookups      b
 where 1 = 1
   and a.order_type         = b.lookup_code
   and b.lookup_type        = ('MSC_DEMAND_ORIGINATION')
   and a.category_set_id    = 1004
   and a.source_table       = 'MSC_DEMANDS'
   and a.compile_designator = 'MRP0515SUM'
   --plan_id  =  21
   and a.organization_code  = 'PPG:SUM'
