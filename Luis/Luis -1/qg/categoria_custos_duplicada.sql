DELETE FROM apps.mtl_item_categories mic
WHERE  mic.category_set_id = 1100000061
AND    mic.organization_id <> 87
AND    NOT EXISTS
 (SELECT 1
				FROM   apps.mtl_item_categories_v mic2
							,apps.mtl_categories_b_kfv  mc
				WHERE  mic2.inventory_item_id = mic.inventory_item_id
				AND    mic.category_id = mc.category_id
				AND    mic2.category_id = mc.category_id
				AND    mic2.category_set_name IN ('Categoria de Custo')
				AND    mic2.organization_id = 87
				AND    mic2.segment1 = mc.segment1
				AND    mic2.segment2 = mc.segment2
				AND    mic2.segment3 = mc.segment3);

select segment1 from apps.mtl_system_items_b where inventory_item_id in (2006821,
2023777,
2047786)

select * FROM apps.mtl_item_categories mic
WHERE  mic.category_set_id = 1100000061
AND    mic.organization_id <> 87
AND    NOT EXISTS
 (SELECT 1
				FROM   apps.mtl_item_categories_v mic2
							,apps.mtl_categories_b_kfv  mc
				WHERE  mic2.inventory_item_id = mic.inventory_item_id
				AND    mic.category_id = mc.category_id
				AND    mic2.category_id = mc.category_id
				AND    mic2.category_set_name IN ('Categoria de Custo')
				AND    mic2.organization_id = 87
				AND    mic2.segment1 = mc.segment1
				AND    mic2.segment2 = mc.segment2
				AND    mic2.segment3 = mc.segment3);
