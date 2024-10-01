begin

update apps.mtl_transactions_interface mti 
 set process_flag = 1, mti.secondary_transaction_quantity = round(apps.INV_CONVERT.INV_UM_CONVERT(mti.inventory_item_id, mti.transaction_uom, mti.secondary_uom_code),4)*mti.transaction_quantity 
where mti.process_flag = 3
and transaction_type_id in(52,33,62,103);

update apps.mtl_transaction_lots_interface mti 
 set process_flag = 1, mti.secondary_transaction_quantity = round(apps.INV_CONVERT.INV_UM_CONVERT((select inventory_item_id from apps.mtl_transactions_interface where transaction_interface_id = mti.transaction_interface_id), (select transaction_uom from apps.mtl_transactions_interface where transaction_interface_id = mti.transaction_interface_id), (select secondary_uom_code from apps.mtl_transactions_interface where transaction_interface_id = mti.transaction_interface_id)),4)*mti.transaction_quantity 
where transaction_interface_id in(select transaction_interface_id from apps.mtl_transactions_interface where transaction_type_id in(52,33,62,103))
and (select transaction_uom from apps.mtl_transactions_interface where transaction_interface_id = mti.transaction_interface_id) is not null;


end;


begin

select * from apps.mtl_transactions_interface mti 
where mti.process_flag = 3
and transaction_type_id in(52,33,62);

select * from apps.mtl_transaction_lots_interface mti 
where transaction_interface_id in(select transaction_interface_id from apps.mtl_transactions_interface where transaction_type_id in(52,33,62))
and (select transaction_uom from apps.mtl_transactions_interface where transaction_interface_id = mti.transaction_interface_id) is not null;
end;


SELECT * from apps.mtl_transaction_lots_interface mti 
where transaction_interface_id not in(select transaction_interface_id from apps.mtl_transactions_interface);

delete apps.mtl_transaction_lots_interface mti 
where transaction_interface_id not in(select transaction_interface_id from apps.mtl_transactions_interface);

