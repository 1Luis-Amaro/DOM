     -- Number of records updated = 2893
     -- Update PO Headers
         UPDATE   po_headers_all
            SET   cancel_flag          = NULL,
                  closed_code          = NULL
          WHERE po_header_id in (select segment1
                                   from apps.mtl_system_items_interface msi);


      -- Number of records updated = 6233
      -- Update PO lines
         UPDATE   po_lines_all
            SET   closed_code = 'OPEN',
                  CLOSED_DATE = NULL,
                  CLOSED_BY = NULL,
                  CANCEL_FLAG = NULL,
                  CANCEL_DATE = NULL,
                  CANCELLED_BY = NULL,
                  LAST_UPDATE_DATE = SYSDATE
          WHERE   po_line_id in (select inventory_item_id
                                   from apps.mtl_system_items_interface msi)  AND
                  CLOSED_CODE = 'FINALLY CLOSED';
    
     -- Number of records updated = 6382
     -- Update PO Shipments
         UPDATE   PO_LINE_LOCATIONS_ALL
            SET   closed_code = 'OPEN',
                  CANCEL_FLAG = NULL,
                  CANCELLED_BY = NULL,
                  CANCEL_DATE = NULL,
                  CLOSED_DATE = NULL,
                  LAST_UPDATE_DATE = SYSDATE
          WHERE   po_line_id in (select inventory_item_id
                                   from apps.mtl_system_items_interface msi) AND
                  CLOSED_CODE = 'FINALLY CLOSED';

     -- Number of records deleted = 2892
     DELETE   po_action_history
      WHERE   object_id in (select segment1
                              from apps.mtl_system_items_interface msi) AND
              object_type_code = 'PO'
        AND   object_sub_type_code = 'STANDARD'
        AND   ACTION_CODE = 'FINALLY CLOSE';

     
     -- Number of records updated = 7539
     -- create Supply if missing
        insert into mtl_supply( supply_type_code,
                                supply_source_id,
                                last_updated_by,
                                last_update_date,
                                last_update_login,
                                created_by,
                                creation_date,
                                po_header_id,
                                po_line_id,
                                po_line_location_id,
                                po_distribution_id,
                                item_id,
                                item_revision,
                                quantity,
                                unit_of_measure,
                                receipt_date,
                                need_by_date,
                                destination_type_code,
                                location_id,
                                to_organization_id,
                                to_subinventory,
                                change_flag)
                         select 'PO',
                                pd.po_distribution_id,
                                pd.last_updated_by,
                                pd.last_update_date,
                                pd.last_update_login,
                                pd.created_by,
                                pd.creation_date,
                                pd.po_header_id,
                                pd.po_line_id,
                                pd.line_location_id,
                                pd.po_distribution_id,
                                pl.item_id,
                                pl.item_revision,
                                pd.quantity_ordered - nvl(pd.quantity_delivered, 0) - nvl(pd.quantity_cancelled,0),
                                pl.unit_meas_lookup_code,
                                nvl(pll.promised_date, pll.need_by_date),
                                pll.need_by_date,
                                pd.destination_type_code,
                                pd.deliver_to_location_id,
                                pd.destination_organization_id,
                                pd.destination_subinventory,
                                'Y'
                           from po_distributions_all pd,
                                po_line_locations_all pll,
                                po_lines_all pl
                          where pl.po_line_id in (select inventory_item_id
                                               from apps.mtl_system_items_interface msi)
                            and pll.line_location_id = pd.line_location_id
                            and pl.po_line_id = pd.po_line_id
                            and nvl(pll.closed_code, 'OPEN')
                                not in ('FINALLY CLOSED' , 'CLOSED', 'CLOSED FOR RECEIVING')
                            and nvl(pll.cancel_flag, 'N') = 'N'
                            and not exists
                               (select 'Supply Exists'
                                  from mtl_supply ms1
                                 where ms1.supply_type_code = 'PO'
                               and ms1.supply_source_id = pd.po_distribution_id);
