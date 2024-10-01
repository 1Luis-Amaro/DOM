Select msi.segment1,
       APPS.INV_CONVERT.inv_um_convert (msi.INVENTORY_ITEM_ID,  	--Inventory Item Id
                                        2,                      --Precision
                                        1, 	                  --Quantity
                                        'l',                   --From UOM siempre es kg
                                        'kg',                		-- To UOM --SIEMPRE SE CONVIERTE A lt
                                        NULL,               		--From UOM Name
                                        NULL                    --To UOM Name
                         )DENSITY --a lt
      from apps.mtl_system_items_b msi
    where msi.inventory_item_id in (4825,
343532,
4831,
4826
) and
organization_id = 92;