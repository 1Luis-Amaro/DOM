           select segment1,
                  primary_uom_code,
                  inv_convert.inv_um_convert(msi.inventory_item_id, msi.primary_uom_code,'l')
                  from apps.mtl_system_items_b msi
                 where msi.item_type       = 'MP' and
                       msi.organization_id = 92   and
                       msi.inventory_item_status_code = 'Active' and
                       inv_convert.inv_um_convert(msi.inventory_item_id, msi.primary_uom_code,'l') < 0;