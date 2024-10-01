SELECT * from mtl_system_items_b msi where
      msi.organization_id <> 87 and
      msi.item_type       = 'ACA' and
      msi.inventory_item_id not in (select load_item_id FROM WSH_CONTAINER_ITEMS mci WHERE
                                       mci.master_organization_id = organization_id and
                                       mci.load_item_id = msi.inventory_item_id);
                                       
                                       
                                       
select * from MTL_PARAMETERS;                                       