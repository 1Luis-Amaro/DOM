select oh.subinventory_code, itm.segment1, oh.lot_number, oh.transaction_quantity from apps.mtl_onhand_quantities oh, apps.mtl_system_items_b itm
     where oh.organization_id = 92 and
           itm.inventory_item_id = oh.inventory_item_id;
           
SELECT LV.LOOKUP_CODE, LV.MEANING, lv.description
FROM apps.fnd_lookup_values_vl lv
WHERE LV.LOOKUP_TYPE = 'XPPGBR_SUBINVENTORY_DHL'
and view_application_id = 3;
           
           