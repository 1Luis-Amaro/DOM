select * from apps.mtl_transaction_types;

select mp.organization_code                              "Estabelecimento",
       msi.segment1                                      "Item",
       mmt.subinventory_code                             "Subinventario",
       mtt.transaction_type_name                         "Tipo Transacao",
       mmt.primary_quantity                              "Quantidade",
       mmt.transfer_subinventory                         "Subinventario Transferencia",
       to_char(trunc(mmt.transaction_date),'dd/mm/yyyy') "Data Transacao"
  from apps.mtl_material_transactions mmt,
       apps.mtl_transaction_types     mtt,
       apps.mtl_system_items_b        msi,
       apps.mtl_parameters            mp
 where mtt.transaction_type_id = mmt.transaction_type_id and
       msi.organization_id     = mmt.organization_id     and
       msi.inventory_item_id   = mmt.inventory_item_id   and
       mp.organization_id      = mmt.organization_id     and
       mp.organization_id      = 86                      and
       trunc(mmt.transaction_date) >= trunc(to_date('2021/08/15','yyyy/mm/dd'))            and
       trunc(mmt.transaction_date) <= trunc(to_date('2021/12/31','yyyy/mm/dd'));
