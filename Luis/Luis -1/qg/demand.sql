select '|' || '|' || to_char(md.demand_id) || '|' || to_char(md.plan_id) || '|' || to_char(md.inventory_item_id) || '|' || to_char(md.organization_id) || '|' || to_date(mp.plan_completion_date) as mrp_skey
      ,'|' || '|' || to_char(md.demand_id) || '|' || to_char(md.plan_id) || '|' || to_char(md.inventory_item_id) || '|' || to_char(md.organization_id) || '|' || to_date(mp.plan_completion_date) as mrp_skey_bigint
      ,to_char(md.old_demand_date,'yyyyMMdd') as calendar_skey
      ,'|' || '|' || to_char(msi.sr_inventory_item_id) || '|' || to_char(msi.organization_id) as item_skey
      ,'|' || '|' || to_char(msi.sr_inventory_item_id) || '|' || to_char(msi.organization_id) as item_skey_bigint
      ,'|' || '|' || to_char(md.organization_id) as plant_skey
      ,'|' || '|' || to_char(md.organization_id) as plant_skey_bigint
      ,'' as source_site_skey
      ,'' as source_site_skey_bigint
      ,'' as supplier_skey
      ,'' as supplier_skey_bigint
      ,'|' || '|' || to_char(mtp.sr_tp_id) as customer_skey
      ,'|' || '|' || to_char(mtp.sr_tp_id) as customer_skey_bigint
      ,'|' || '|' || to_char(md.sales_order_line_id) as order_skey
      ,'|' || to_char(md.sales_order_line_id) as order_skey_bigint
      ,'' as po_skey
      ,'' as po_skey_bigint
      ,to_char(msi.sr_inventory_item_id) as inventory_item_id
      ,to_char(md.organization_id) as plant_id
      ,upper(msi.uom_code) as base_unit_measure
      ,to_char(md.using_requirement_quantity) as planned_ind_reqmts
      ,to_char(md.old_demand_date) as trans_date
      ,ml.meaning as mrp_elements
      ,ml.meaning as actual_order_type
      ,md.order_number as actual_order_number
      ,mp.compile_designator as plan_version
      ,oohl.version_number as transaction_revision_number
      ,partner_number as mrp_element_receiver
      ,to_char(mp.plan_start_date) as plan_start_date
      ,to_char(mp.plan_completion_date) as plan_completion_date
      ,to_char(using_assembly_demand_date) as suggested_due_date
      ,to_char(old_demand_date) as original_due_date
      ,'' as mrp_element_issuer
      ,to_char(md.order_number) as transaction_ref_line_number
      ,'Demand' as mrp_type
      ,msi.item_name
      ,mp.organization_code
from apps.msc_demands md 
inner join (
            select row_number() over (order by creation_date desc) as rank,plan_id,compile_designator,plan_start_date,plan_completion_date
            from apps.msc_plans
            where compile_designator like '%SUM%'
) mp  on md.plan_id = mp.plan_id
      and mp.rank = 1
left join apps.msc_system_items msi
      on md.plan_id = msi.plan_id
      and md.sr_instance_id = msi.sr_instance_id
      and md.organization_id = msi.organization_id
      and md.inventory_item_id = msi.inventory_item_id
left join apps.mtl_parameters mp
      on mp.organization_id = msi.organization_id
left join apps.mfg_lookups ml
      on md.origination_type = ml.lookup_code
      and ml.lookup_type='MSC_DEMAND_ORIGINATION'
left join (
            select ool.line_id,ooh.version_number
            from apps.oe_order_lines_all ool
            join apps.oe_order_headers_all ooh
            on ooh.HEADER_ID = ool.header_id
)oohl on oohl.line_id = md.sales_order_line_id
left join apps.msc_trading_partners mtp
      on mtp.partner_id = md.customer_id
       order by 1