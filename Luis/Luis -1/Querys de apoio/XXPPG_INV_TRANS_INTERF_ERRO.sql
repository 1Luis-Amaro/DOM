select mp.organization_code org,
 msi.segment1 item,
 mtli.lot_number,
 mtt.transaction_type_name,
 mti.subinventory_code,
 mti.transfer_subinventory,
 mti.transaction_uom,
 mti.transaction_quantity,
 mtli.transaction_quantity lot_transaction_quantity,
 mti.process_flag,
 mti.lock_flag,
 mti.error_code,
 mti.error_explanation
from apps.mtl_transactions_interface mti,
       apps.mtl_transaction_lots_interface mtli,
       apps.mtl_parameters mp,
       apps.mtl_system_items_b msi,
       apps.mtl_transaction_types mtt
where mti.transaction_interface_id = mtli.transaction_interface_id (+)
    and mti.organization_id = mp.organization_id
    and mti.organization_id = msi.organization_id
    and mti.inventory_item_id = msi.inventory_item_id 
    and mti.transaction_type_id = mtt.transaction_type_id
    and mti.process_flag = 3