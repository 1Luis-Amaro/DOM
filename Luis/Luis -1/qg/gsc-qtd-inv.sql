                    SELECT  NVL(SUM(DECODE(inv_convert.inv_um_convert(  moqd.inventory_item_id,NULL,moqd.organization_id,NULL,moqd.transaction_quantity,transaction_uom_code,'kg',NULL,NULL),-99999,0,inv_convert.inv_um_convert(  moqd.inventory_item_id,NULL,moqd.organization_id,NULL,moqd.transaction_quantity,transaction_uom_code,'kg',NULL,NULL))),0),
                            NVL(SUM(DECODE( inv_convert.inv_um_convert(  moqd.inventory_item_id,NULL,moqd.organization_id,NULL,moqd.transaction_quantity,transaction_uom_code,'l',NULL,NULL),-99999,0,inv_convert.inv_um_convert(  moqd.inventory_item_id,NULL,moqd.organization_id,NULL,moqd.transaction_quantity,transaction_uom_code,'l',NULL,NULL))),0),
                            NVL(SUM(DECODE(inv_convert.inv_um_convert(  moqd.inventory_item_id,NULL,moqd.organization_id,NULL,moqd.transaction_quantity,transaction_uom_code,'un',NULL,NULL),-99999,0,inv_convert.inv_um_convert(  moqd.inventory_item_id,NULL,moqd.organization_id,NULL,moqd.transaction_quantity,transaction_uom_code,'un',NULL,NULL))),0)
                    INTO    l_onhand_kg,
                            l_onhand_lit,
                            l_onhand_con
                    FROM    mtl_onhand_quantities_detail moqd ,---ic_loct_inv
                            mtl_system_items_b msi
                    WHERE   moqd.inventory_item_id = msi.inventory_item_id            ---WHERE     item_id = i.item_id
                    AND     moqd.organization_id   = msi.organization_id
                    AND     moqd.inventory_item_id = p_inventory_item_id
                    AND     moqd.organization_id   = p_organization_id
                    AND     moqd.subinventory_code = p_subinv
--                    AND     moqd.locator_id        = p_locator_id -- OSM 23/03/2015
                    AND     moqd.lot_number        = p_lot_no;
