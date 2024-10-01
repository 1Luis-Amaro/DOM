-- Supply Query --- 

select '|' || '|' || to_char(ms.transaction_id) || '|' || to_char(ms.plan_id) || '|' || to_char(ms.inventory_item_id) || '|' || to_char(ms.organization_id) || '|' || to_char(to_date(mp.plan_completion_date)) /*|| to_char(snapshot_date)*/ as mrp_skey
      ,'|' || '|' || to_char(ms.transaction_id) || '|' || to_char(ms.plan_id) || '|' || to_char(ms.inventory_item_id) || '|' || to_char(ms.organization_id) || '|' || to_char(to_date(mp.plan_completion_date)) /*|| to_char(snapshot_date)*/ as mrp_skey_bigint
      ,to_char(ms.new_schedule_date,'yyyyMMdd') as calendar_skey
      ,'|' || to_char(msi.sr_inventory_item_id) || '|' || to_char(msi.organization_id) as item_skey
      ,'|' || to_char(msi.sr_inventory_item_id) || '|' || to_char(msi.organization_id) as item_skey_bigint
      ,'|' || to_char(ms.organization_id) as plant_skey
      ,'|' || to_char(ms.organization_id) as plant_skey_bigint
      ,'|' || to_char(ms.source_organization_id) as source_site_skey
      ,'|' || to_char(ms.source_organization_id) as source_site_skey_bigint
      ,'|' || to_char(mtp.sr_tp_id) || '|' || to_char(mtps.sr_tp_site_id) as supplier_skey
      ,'|' || to_char(mtp.sr_tp_id) || '|' || to_char(mtps.sr_tp_site_id) as supplier_skey_bigint
      ,'' as customer_skey
      ,'' as customer_skey_bigint
      ,'' as order_skey
      ,'' as order_skey_bigint
      ,'|' || to_char(ms.po_line_id) as po_skey
      ,'|' || to_char(ms.po_line_id) as po_skey_bigint
      ,to_char(msi.sr_inventory_item_id) as inventory_item_id
      ,to_char(ms.organization_id) as plant_id
      ,upper(msi.uom_code) as base_unit_measure
      ,cast(ms.new_order_quantity as decimal(20,3)) as planned_ind_reqmts
      ,to_char(ms.new_schedule_date) as trans_date
      ,ml.meaning as mrp_elements
      ,ml.meaning as actual_order_type
      ,ms.order_number as actual_order_number
      ,mp.compile_designator as plan_version
      ,phla.revision_num as transaction_revision_number
      ,'' as mrp_element_receiver
      -- ,string(null) as available_to_promise_rule
      ,to_char(mp.plan_start_date) as plan_start_date
      ,to_char(mp.plan_completion_date) as plan_completion_date
      ,to_char(new_schedule_date) as suggested_due_date
      ,to_char(old_schedule_date) as original_due_date
     -- ,case ms.order_type     when 8 then coalesce(mis.partner_number,mis.organization_code)
     --                         when 14 then mpo.organization_code
     --                         else coalesce(src_mpo.organization_code,mtp.partner_number) --order_type = 1,12
     --  end as mrp_element_issuer
      ,case when ms.order_type = 3 then mrr.line_no
            else to_char(ms.purch_line_num)
       end as transaction_ref_line_number
      ,'Supply' as mrp_type 
      ,msi.item_name
      ,mpo.organization_code
from apps.msc_supplies ms
inner join (
            select row_number() over (order by creation_date desc) as rank,plan_id,compile_designator,plan_start_date,plan_completion_date
            from apps.msc_plans
            where compile_designator like '%SUM%'
) mp  on ms.plan_id = mp.plan_id
      and mp.rank = 1 --and ms.inventory_item_id in (511746)
left join apps.msc_system_items msi
      on ms.plan_id = msi.plan_id
      and ms.sr_instance_id = msi.sr_instance_id
      and ms.organization_id = msi.organization_id
      and ms.inventory_item_id = msi.inventory_item_id
left join apps.mfg_lookups ml
      on ms.order_type = ml.lookup_code
      and ml.lookup_type='MRP_ORDER_TYPE'
left join (
            select pha.revision_num, pla.po_line_id
            from apps.po_headers_all pha
            join apps.po_lines_all pla
            on pha.po_header_id = pla.po_header_id
)phla on phla.po_line_id = ms.po_line_id
left join apps.msc_trading_partners mtp
      on coalesce(ms.supplier_id,ms.source_supplier_id) = mtp.partner_id
left join apps.msc_trading_partner_sites mtps
      on partner_site_id = ms.supplier_site_id
--left join msc_item_sourcing mis
--      on mis.inventory_item_id = ms.inventory_item_id
--      and mis.organization_id = ms.organization_id
--      and mis.plan_id = ms.plan_id
left join (select distinct organization_code,organization_id from apps.msc_plan_organizations) mpo
      on mpo.organization_id = ms.organization_id
left join (select distinct organization_code,organization_id from apps.msc_plan_organizations) src_mpo
      on src_mpo.organization_id = ms.source_organization_id
left join (
            select distinct mrr1.supply_id, gmd.line_no
            from apps.msc_resource_requirements mrr1
            left join (
                  select gmd1.batch_id, to_char(to_number(max(gmd1.line_no))) as line_no
                  from apps.gme_material_details gmd1
                  group by batch_id
            )gmd  on gmd.batch_id = (mrr1.wip_entity_id/2-.5)
            where mrr1.plan_id = -1
)mrr  on mrr.supply_id = ms.transaction_id;
where ms.order_type in (1,8,12,14); --and category_set_id = 1


select * from apps.xxppg_sspl_v;