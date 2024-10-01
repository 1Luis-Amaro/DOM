SELECT msib.inventory_item_id
     , custo.segment1 cat_custo_seg1
     , custo.segment2 cat_custo_seg2
     , custo.segment3 cat_custo_seg3
     , inventario.segment1 cat_inv_seg1
     , inventario.segment2 cat_inv_seg2
     , inventario.segment3 cat_inv_seg3
     , msib.organization_id
     , (SELECT name
          FROM apps.hr_all_organization_units
         WHERE organization_id = msib.organization_id
           AND ROWNUM = 1)
         org_name
     , msib.last_update_date
     , msib.last_updated_by
     , TRUNC (msib.creation_date) creation_date
     , msib.created_by
     , msib.last_update_login
     , msib.summary_flag
     , msib.enabled_flag
     , msib.start_date_active
     , msib.end_date_active
     , msib.description
     , msib.buyer_id
     , msib.accounting_rule_id
     , msib.invoicing_rule_id
     , ''''||msib.segment1 Item
     , msib.segment1||' | '||msib.description Item_Desc
     , msib.segment2
     , msib.segment3
     , msib.segment4
     , msib.segment5
     , msib.segment6
     , msib.segment7
     , msib.segment8
     , msib.segment9
     , msib.segment10
     , msib.segment11
     , msib.segment12
     , msib.segment13
     , msib.segment14
     , msib.segment15
     , msib.segment16
     , msib.segment17
     , msib.segment18
     , msib.segment19
     , msib.segment20
     , msib.attribute_category
     , msib.attribute1
     , msib.attribute2
     , msib.attribute3
     , msib.attribute4
     , msib.attribute5
     , msib.attribute6
     , msib.attribute7
     , msib.attribute8
     , msib.attribute9
     , msib.attribute10
     , msib.attribute11
     , msib.attribute12
     , msib.attribute13
     , msib.attribute14
     , msib.attribute15
     , msib.purchasing_item_flag
     , msib.shippable_item_flag
     , msib.customer_order_flag
     , msib.internal_order_flag
     , msib.service_item_flag
     , msib.inventory_item_flag
     , msib.eng_item_flag
     , msib.inventory_asset_flag
     , msib.purchasing_enabled_flag
     , msib.customer_order_enabled_flag
     , msib.internal_order_enabled_flag
     , msib.so_transactions_flag
     , msib.mtl_transactions_enabled_flag
     , msib.stock_enabled_flag
     , msib.bom_enabled_flag
     , msib.build_in_wip_flag
     , msib.revision_qty_control_code
     , msib.item_catalog_group_id
     , msib.catalog_status_flag
     , msib.returnable_flag
     , msib.default_shipping_org
     , msib.collateral_flag
     , msib.taxable_flag
     , msib.qty_rcv_exception_code
     , msib.allow_item_desc_update_flag
     , msib.inspection_required_flag
     , msib.receipt_required_flag
     , msib.market_price
     , msib.hazard_class_id
     , msib.rfq_required_flag
     , msib.qty_rcv_tolerance
     , msib.list_price_per_unit
     , msib.un_number_id
     , msib.price_tolerance_percent
     , msib.asset_category_id
     , msib.rounding_factor
     , msib.unit_of_issue
     , msib.enforce_ship_to_location_code
     , msib.allow_substitute_receipts_flag
     , msib.allow_unordered_receipts_flag
     , msib.allow_express_delivery_flag
     , msib.days_early_receipt_allowed
     , msib.days_late_receipt_allowed
     , msib.receipt_days_exception_code
     , msib.receiving_routing_id
     , msib.invoice_close_tolerance
     , msib.receive_close_tolerance
     , msib.auto_lot_alpha_prefix
     , msib.start_auto_lot_number
     , msib.lot_control_code
     , msib.shelf_life_code
     , msib.shelf_life_days
     , msib.serial_number_control_code
     , msib.start_auto_serial_number
     , msib.auto_serial_alpha_prefix
     , msib.source_type
     , msib.source_organization_id
     , msib.source_subinventory
     , msib.expense_account
     , msib.encumbrance_account
     , msib.restrict_subinventories_code
     , msib.unit_weight
     , msib.weight_uom_code
     , msib.volume_uom_code
     , msib.unit_volume
     , msib.restrict_locators_code
     , msib.location_control_code
     , msib.shrinkage_rate
     , msib.acceptable_early_days
     , msib.planning_time_fence_code
     , msib.demand_time_fence_code
     , msib.lead_time_lot_size
     , msib.std_lot_size
     , msib.cum_manufacturing_lead_time
     , msib.overrun_percentage
     , msib.mrp_calculate_atp_flag
     , msib.acceptable_rate_increase
     , msib.acceptable_rate_decrease
     , msib.cumulative_total_lead_time
     , msib.planning_time_fence_days
     , msib.demand_time_fence_days
     , msib.end_assembly_pegging_flag
     , msib.repetitive_planning_flag
     , msib.planning_exception_set
     , msib.bom_item_type
     , msib.pick_components_flag
     , msib.replenish_to_order_flag
     , msib.base_item_id
     , msib.atp_components_flag
     , msib.atp_flag
     , msib.fixed_lead_time
     , msib.variable_lead_time
     , msib.wip_supply_locator_id
     , msib.wip_supply_type
     , msib.wip_supply_subinventory
     , msib.primary_uom_code
     , msib.primary_unit_of_measure
     , msib.allowed_units_lookup_code
     , msib.cost_of_sales_account
     , msib.sales_account
     , msib.default_include_in_rollup_flag
     , msib.inventory_item_status_code
     , msib.inventory_planning_code
     , msib.planner_code
     , msib.planning_make_buy_code
     , msib.fixed_lot_multiplier
     , msib.rounding_control_type
     , msib.carrying_cost
     , msib.postprocessing_lead_time
     , msib.preprocessing_lead_time
     , msib.full_lead_time
     , msib.order_cost
     , msib.mrp_safety_stock_percent
     , msib.mrp_safety_stock_code
     , msib.min_minmax_quantity
     , msib.max_minmax_quantity
     , msib.minimum_order_quantity
     , msib.fixed_order_quantity
     , msib.fixed_days_supply
     , msib.maximum_order_quantity
     , msib.atp_rule_id
     , msib.picking_rule_id
     , msib.reservable_type
     , msib.positive_measurement_error
     , msib.negative_measurement_error
     , msib.engineering_ecn_code
     , msib.engineering_item_id
     , msib.engineering_date
     , msib.service_starting_delay
     , msib.vendor_warranty_flag
     , msib.serviceable_component_flag
     , msib.serviceable_product_flag
     , msib.base_warranty_service_id
     , msib.payment_terms_id
     , msib.preventive_maintenance_flag
     , msib.primary_specialist_id
     , msib.secondary_specialist_id
     , msib.serviceable_item_class_id
     , msib.time_billable_flag
     , msib.material_billable_flag
     , msib.expense_billable_flag
     , msib.prorate_service_flag
     , msib.coverage_schedule_id
     , msib.service_duration_period_code
     , msib.service_duration
     , msib.warranty_vendor_id
     , msib.max_warranty_amount
     , msib.response_time_period_code
     , msib.response_time_value
     , msib.new_revision_code
     , msib.invoiceable_item_flag
     , msib.tax_code
     , msib.invoice_enabled_flag
     , msib.must_use_approved_vendor_flag
     , msib.request_id
     , msib.program_application_id
     , msib.program_id
     , msib.program_update_date
     , msib.outside_operation_flag
     , msib.outside_operation_uom_type
     , msib.safety_stock_bucket_days
     , msib.auto_reduce_mps
     , msib.costing_enabled_flag
     , msib.auto_created_config_flag
     , msib.cycle_count_enabled_flag
     , msib.item_type
     , msib.model_config_clause_name
     , msib.ship_model_complete_flag
     , msib.mrp_planning_code
     , msib.return_inspection_requirement
     , msib.ato_forecast_control
     , msib.release_time_fence_code
     , msib.release_time_fence_days
     , msib.container_item_flag
     , msib.vehicle_item_flag
     , msib.maximum_load_weight
     , msib.minimum_fill_percent
     , msib.container_type_code
     , msib.internal_volume
     , msib.wh_update_date
     , msib.product_family_item_id
     , msib.global_attribute_category
     , msib.global_attribute1
     , msib.global_attribute2
     , msib.global_attribute3
     , msib.global_attribute4
     , msib.global_attribute5
     , msib.global_attribute6
     , msib.global_attribute7
     , msib.global_attribute8
     , msib.global_attribute9
     , msib.global_attribute10
     , msib.purchasing_tax_code
     , msib.overcompletion_tolerance_type
     , msib.overcompletion_tolerance_value
     , msib.effectivity_control
     , msib.check_shortages_flag
     , msib.over_shipment_tolerance
     , msib.under_shipment_tolerance
     , msib.over_return_tolerance
     , msib.under_return_tolerance
     , msib.equipment_type
     , msib.recovered_part_disp_code
     , msib.defect_tracking_on_flag
     , msib.usage_item_flag
     , msib.event_flag
     , msib.electronic_flag
     , msib.downloadable_flag
     , msib.vol_discount_exempt_flag
     , msib.coupon_exempt_flag
     , msib.comms_nl_trackable_flag
     , msib.asset_creation_code
     , msib.comms_activation_reqd_flag
     , msib.orderable_on_web_flag
     , msib.back_orderable_flag
     , msib.web_status
     , msib.indivisible_flag
     , msib.dimension_uom_code
     , msib.unit_length
     , msib.unit_width
     , msib.unit_height
     , msib.bulk_picked_flag
     , msib.lot_status_enabled
     , msib.default_lot_status_id
     , msib.serial_status_enabled
     , msib.default_serial_status_id
     , msib.lot_split_enabled
     , msib.lot_merge_enabled
     , msib.inventory_carry_penalty
     , msib.operation_slack_penalty
     , msib.financing_allowed_flag
     , msib.eam_item_type
     , msib.eam_activity_type_code
     , msib.eam_activity_cause_code
     , msib.eam_act_notification_flag
     , msib.eam_act_shutdown_status
     , msib.dual_uom_control
     , msib.secondary_uom_code
     , msib.dual_uom_deviation_high
     , msib.dual_uom_deviation_low
     , msib.contract_item_type_code
     , msib.subscription_depend_flag
     , msib.serv_req_enabled_code
     , msib.serv_billing_enabled_flag
     , msib.serv_importance_level
     , msib.planned_inv_point_flag
     , msib.lot_translate_enabled
     , msib.default_so_source_type
     , msib.create_supply_flag
     , msib.substitution_window_code
     , msib.substitution_window_days
     , msib.ib_item_instance_class
     , msib.config_model_type
     , msib.lot_substitution_enabled
     , msib.minimum_license_quantity
     , msib.eam_activity_source_code
     , msib.lifecycle_id
     , msib.current_phase_id
     , msib.object_version_number
     , msib.tracking_quantity_ind
     , msib.ont_pricing_qty_source
     , msib.secondary_default_ind
     , msib.option_specific_sourced
     , msib.approval_status
     , msib.vmi_minimum_units
     , msib.vmi_minimum_days
     , msib.vmi_maximum_units
     , msib.vmi_maximum_days
     , msib.vmi_fixed_order_quantity
     , msib.so_authorization_flag
     , msib.consigned_flag
     , msib.asn_autoexpire_flag
     , msib.vmi_forecast_type
     , msib.forecast_horizon
     , msib.exclude_from_budget_flag
     , msib.days_tgt_inv_supply
     , msib.days_tgt_inv_window
     , msib.days_max_inv_supply
     , msib.days_max_inv_window
     , msib.drp_planned_flag
     , msib.critical_component_flag
     , msib.continous_transfer
     , msib.convergence
     , msib.divergence
     , msib.config_orgs
     , msib.config_match
     , msib.attribute16
     , msib.attribute17
     , msib.attribute18
     , msib.attribute19
     , msib.attribute20
     , msib.attribute21
     , msib.attribute22
     , msib.attribute23
     , msib.attribute24
     , msib.attribute25
     , msib.attribute26
     , msib.attribute27
     , msib.attribute28
     , msib.attribute29
     , msib.attribute30
     , msib.cas_number
     , msib.child_lot_flag
     , msib.child_lot_prefix
     , msib.child_lot_starting_number
     , msib.child_lot_validation_flag
     , msib.copy_lot_attribute_flag
     , msib.default_grade
     , msib.expiration_action_code
     , msib.expiration_action_interval
     , msib.grade_control_flag
     , msib.hazardous_material_flag
     , msib.hold_days
     , msib.lot_divisible_flag
     , msib.maturity_days
     , msib.parent_child_generation_flag
     , msib.process_costing_enabled_flag
     , msib.process_execution_enabled_flag
     , msib.process_quality_enabled_flag
     , msib.process_supply_locator_id
     , msib.process_supply_subinventory
     , msib.process_yield_locator_id
     , msib.process_yield_subinventory
     , msib.recipe_enabled_flag
     , msib.retest_interval
     , msib.charge_periodicity_code
     , msib.repair_leadtime
     , msib.repair_yield
     , msib.preposition_point
     , msib.repair_program
     , msib.subcontracting_component
     , msib.outsourced_assembly
     , msib.ego_master_items_dff_ctx
     , msib.gdsn_outbound_enabled_flag
     , msib.trade_item_descriptor
     , msib.style_item_id
     , msib.style_item_flag
     , msib.last_submitted_nir_id
     , msib.default_material_status_id
     , msib.global_attribute11
     , msib.global_attribute12
     , msib.global_attribute13
     , msib.global_attribute14
     , msib.global_attribute15
     , msib.global_attribute16
     , msib.global_attribute17
     , msib.global_attribute18
     , msib.global_attribute19
     , msib.global_attribute20
  FROM apps.mtl_system_items_b msib
    -- , apps.mtl_categories_b mcbi
    -- , apps.mtl_category_sets mcsi
    -- , apps.mtl_item_categories mici
    -- , apps.mtl_categories_b mcbc
    -- , apps.mtl_category_sets mcsc
    -- , apps.mtl_item_categories micc
     ,(SELECT MIC.INVENTORY_ITEM_ID,
              MIC.ORGANIZATION_ID,
              MIC.CATEGORY_SET_NAME,
              MC.segment1,
              MC.segment2,
              MC.segment3,
              MIC.CATEGORY_CONCAT_SEGS CATEGORIA
         FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
        WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
          AND MIC.CATEGORY_SET_NAME IN ('Categoria de Custo')) CUSTO
          --
     ,(SELECT MIC.INVENTORY_ITEM_ID,
              MIC.ORGANIZATION_ID,
              MIC.CATEGORY_SET_NAME,
              MC.segment1,
              MC.segment2,
              MC.segment3,
              MIC.CATEGORY_CONCAT_SEGS CATEGORIA
         FROM APPS.MTL_ITEM_CATEGORIES_V MIC,
              APPS.MTL_CATEGORIES_V MC
        WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
          AND MIC.CATEGORY_SET_NAME IN ('Inventory')) INVENTARIO
 WHERE msib.organization_id   = custo.organization_id(+) 
   AND msib.inventory_item_id = custo.inventory_item_id(+) 
   AND msib.organization_id   = inventario.organization_id(+) 
   AND msib.inventory_item_id = inventario.inventory_item_id(+); 
 
 
 
 
 mcbi.structure_id = mcsi.structure_id
   AND mcsi.category_set_id = (SELECT category_set_id
                                 FROM apps.mtl_default_category_sets
                                WHERE functional_area_id = 1)
   AND mici.category_set_id           = mcsi.category_set_id
   AND mici.inventory_item_id         = msib.inventory_item_id
   AND mici.organization_id           = msib.organization_id
   AND mici.category_id               = mcbi.category_id
   AND mcbc.structure_id              = mcsc.structure_id(+)
   AND UPPER (mcsc.category_set_name) = UPPER ('Categoria de Custo')
   AND micc.category_set_id           = mcsc.category_set_id(+)
   AND micc.inventory_item_id(+)      = msib.inventory_item_id
   AND micc.organization_id(+)        = msib.organization_id
   AND micc.category_id               = mcbc.category_id
   and msib.segment1 like 'WO5481%';