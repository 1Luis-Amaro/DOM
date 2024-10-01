 select segment1,
        status,
        ult_compra,
        abs(qty_compra) "Compra 4M",
        ult_prod,
        abs(qty_prod) "Prod 4M",
        ult_venda,
        abs(qty_venda) "Venda 4M",
        ult_cons_v,
        abs(qty_cons_v) "Consumo 4M"
   from (select segment1,
                inventory_item_status_code status,
                ------------- COMPRA -----------------------
                (SELECT MAX(mtl1.transaction_date)
                   FROM apps.mtl_material_transactions mtl1
                  WHERE mtl1.transaction_type_id = 18
                    AND mtl1.inventory_item_id   = itm.inventory_item_id) ult_compra,
                    
                (SELECT sum(mtl1.transaction_quantity)
                   FROM apps.mtl_material_transactions mtl1
                  WHERE mtl1.transaction_type_id = 18
                    AND mtl1.inventory_item_id   = itm.inventory_item_id
                    AND mtl1.transaction_date <= sysdate + 1
                    AND mtl1.transaction_date >= sysdate - 120) qty_compra
                ,
                 ---------------------- Producao -----------------------
                (SELECT MAX(mtl1.transaction_date)
                   FROM apps.mtl_material_transactions mtl1
                  WHERE mtl1.transaction_type_id = 44
                    AND mtl1.inventory_item_id   = itm.inventory_item_id) ult_prod,
                    
                (SELECT sum(mtl1.transaction_quantity)
                   FROM apps.mtl_material_transactions mtl1
                  WHERE mtl1.transaction_type_id = 44
                    AND mtl1.inventory_item_id   = itm.inventory_item_id
                    AND mtl1.transaction_date <= sysdate + 1
                    AND mtl1.transaction_date >= sysdate - 120) qty_prod
                ,
                 
                 
                 -------------------- Venda ---------------------------
                 
                (SELECT MAX(mmt.transaction_date)
                   FROM inv.mtl_material_transactions mmt
                  WHERE mmt.inventory_item_id   = itm.inventory_item_id
                    AND mmt.transaction_type_id = 33) ult_venda
                ,
                 
                (SELECT sum(mmt.transaction_quantity)
                   FROM inv.mtl_material_transactions mmt
                  WHERE mmt.inventory_item_id   = itm.inventory_item_id
                    AND mmt.transaction_type_id = 33
                    AND mmt.transaction_date <= sysdate + 1
                    AND mmt.transaction_date >= sysdate - 120) qty_venda,
                    
                 ------------ Consumo para Venda -----------------------
                (SELECT MAX(mtl1.transaction_date)
                   FROM apps.mtl_material_transactions mtl1
                  WHERE mtl1.transaction_type_id IN (35)
                    AND mtl1.inventory_item_id = itm.inventory_item_id) ult_cons_v
                ,
                
                (SELECT sum(mtl1.transaction_quantity)
                   FROM apps.mtl_material_transactions mtl1
                  WHERE mtl1.transaction_type_id IN (35)
                    AND mtl1.inventory_item_id = itm.inventory_item_id
                    AND mtl1.transaction_date <= sysdate + 1
                    AND mtl1.transaction_date >= sysdate - 120) qty_cons_v,
                
                 ------------------ Saldo Estoque --------------------
                (select sum(transaction_quantity)
                   from apps.MTL_ONHAND_QUANTITIES_DETAIL moq
                  WHERE moq.inventory_item_id = itm.inventory_item_id) qty                                                    
          from apps.mtl_system_items_b itm
         where itm.organization_id = 87)
    where status = 'Active' or
          qty   <> 0        or
          (status <> 'Active' and
           ult_venda is not null and
           ult_cons_v  is not null);
               
                                        
select * from apps.MTL_ONHAND_QUANTITIES_DETAIL moq     ;

select * from inv.mtl_material_transactions mmt;       