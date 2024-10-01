SELECT DISTINCT FULL_NAME, PERSON_ID FROM apps.per_people_f PPF WHERE FULL_NAME LIKE 'Marcio%,';  WHERE PPF.PERSON_ID = MSI.BUYER_ID AND ROWNUM = 1

SELECT UN_NUMBER_ID,UN_NUMBER FROM apps.po_un_numbers pun;
SELECT * FROM apps.po_hazard_classes phc9 WHERE hazard_class in ('NA','3','3 / 8','5.1','4.1','9','6.1','8','0','5.1(6.1,8)','141');
SELECT * FROM apps.po_hazard_classes phc9 WHERE hazard_class like '%1%4%1%';
SELECT * from apps.gl_code_combinations_kfv where CONCATENATED_SEGMENTS = '3545-51003-5344-54409000-576920-0000-0000';
SELECT * from apps.gl_code_combinations_kfv where CONCATENATED_SEGMENTS = '3545-51004-5344-54409000-576920-0000-0000';

select * from MTL_INTERFACE_ERRORS order by 4 desc;

SELECT * from MTL_ITEM_CATEGORIES_INTERFACE;

select * from MTL_CROSS_REFERENCES_INTERFACE;

select * from MTL_SYSTEM_ITEMS_INTERFACE WHERE INVENTORY_ITEM_ID IS NULL;

SELECT PLANNING_MAKE_BUY_CODE FROM mtl_system_items_b where segment1 = 'SRC-75' and organization_id = 92;
select * from MTL_ITEM_TEMPLATES_ALL_V ORDER BY 3; where template_name like '%PIN';

select segment1, description from mtl_system_items_b
where organization_id = 182 and SHELF_LIFE_DAYS <> 1
