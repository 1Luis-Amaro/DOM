SELECT distinct msi.segment1,
       msi.minimum_license_quantity    "Multiplo Venda",
       nvl(msie.unit_weight,0)         "Peso Container",
       nvl(msi.unit_weight,0)          "Peso Liquido",
       msie.segment1,
       msie.unit_weight                "Peso Container",
       case 
          when nvl(wci.max_load_quantity,0) > 0 then
               ROUND((nvl(msie.unit_weight,0) / nvl(wci.max_load_quantity,1)) + nvl(msi.unit_weight,0),3)
          else ROUND(nvl(msie.unit_weight,0) + nvl(msi.unit_weight,0),3)
       end "Peso Bruto"
--       
       FROM apps.mtl_system_items_b        msi,
            inv.mtl_system_items_b         msie,
            wsh.wsh_container_items        wci
 where wci.load_item_id  (+)          = msi.inventory_item_id           AND
       wci.preferred_flag (+)         = 'Y'                             AND
       msie.organization_id (+)       = wci.master_organization_id      AND
       msie.inventory_item_id (+)     = wci.container_item_id           AND
       wci.master_organization_id (+) = 92  /* 92 = Sumare */           AND
       MSI.inventory_item_status_code <> 'Obsoleto'                     and
       MSI.inventory_item_status_code <> 'Inactive'                     and
       msi.segment1 like '%.01' AND
       msi.item_type like 'ACA%';