SELECT mp.organization_code,
       msi.segment1,
       ms.attribute1 EAN13_ANTIGO,
       ms.attribute2 GTIN,
       ms.attribute3 DUN14_ANTIGO,
       ms.attribute4 DUN14
  FROM XXPPG.MTL_SYSTEM_ITEMS_B_EXT ms,
       apps.mtl_system_items_b msi,
       apps.mtl_parameters     mp
 where ms.inventory_item_id = msi.inventory_item_id and
       ms.organization_id   = msi.organization_id   and
       mp.organization_id   = msi.organization_id;

SELECT segment1 from mtl_system_items_b where inventory_item_id = 1024464;

select inventory_item_id from mtl_system_items_b where segment1 = 'PCT1G-0110'

select inventory_item_id from mtl_system_items_b where segment1 = 'D800.11'

select * from po_vendor_contacts;

select * from apps.ap_suppliers where vendor_name like 'BASF%'; IN ('KANSAI PAINT CO LTD','PPG COATINGS EUROPE BV');