select msit.language, msit.description, msi.description from apps.mtl_system_items_b msi, apps.mtl_system_items_tl msit
        where msi.segment1 = 'FBR525.20' and
              msi.organization_id    = 92                    and
              msit.inventory_item_id = msi.inventory_item_id and
              msit.organization_id   = msi.organization_id;