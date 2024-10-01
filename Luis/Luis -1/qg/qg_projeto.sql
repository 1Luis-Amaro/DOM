select * from CM_CMPT_DTL_VW where inventory_item_id = 1915000;

select inventory_item_id from mtl_system_items_b where segment1 = '4001031.1450';
select segment1
  from mtl_system_items_b msi
 where msi.organization_id = 182 and
       msi.inventory_item_id not in (SELECT cst.inventory_item_id
                                      FROM CM_CMPT_DTL_VW cst
                                      WHERE cst.delete_mark       = '0'
                                        AND cst.organization_id   = msi.organization_id
                                        AND cst.inventory_item_id = msi.inventory_item_id
                                        AND cst.cost_type_id      = '1005') -- 1000 (STD)   1005 (PMAC)