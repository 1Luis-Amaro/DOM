select un_number, un_number_id from apps.po_un_numbers pun where un_number_id = 211 OR un_number_id = 312;

select hazard_class, hazard_class_id from apps.po_hazard_classes phc;

select inventory_item_id,
       segment1,
       un_number_id,
       hazard_class_id
  from apps.mtl_system_items_b 
 WHERE organization_id = 87 and SEGMENT1 = 'KAQ-7237'; --un_number_id = 211;
211



select msi.inventory_item_id,
       msi.segment1,
       pun.un_number_id,
       pun.un_number,
       msi.hazard_class_id
  from apps.mtl_system_items_b msi,
       apps.po_un_numbers      pun
 WHERE msi.organization_id = 87 and
       msi.un_number_id = pun.un_number_id and
       pun.un_number in ('1230',
'1277',
'1296',
'1436',
'1463',
'1500',
'1604',
'1790',
'1790',
'1811',
'1992',
'2014',
'2031',
'2051',
'2054',
'2076',
'2218',
'2310',
'2478',
'2478',
'2619',
'2686',
'2733',
'2733',
'2734',
'2734',
'2789',
'2789',
'2903',
'2920',
'2922',
'2924',
'2927',
'2929',
'3080',
'3093',
'3286',
'3469',
'3470');
