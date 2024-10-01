SELECT DISTINCT PHA.SEGMENT1,
                PHA.REVISION_NUM,
                ap.vendor_name,
                assa.vendor_site_code,
                msib.segment1,
                pla.item_description,
                papf.full_name,
                papf.email_address
                
  FROM apps.po_headers_all pha,
       apps.po_lines_all pla,
       apps.mtl_system_items_b msib,
       apps.po_line_locations_all plla,
       apps.ap_suppliers ap,
       apps.ap_supplier_sites_all assa, 
       apps.per_all_people_f papf,
       apps.po_action_history pah,
       apps.mtl_parameters mp
 WHERE     pha.po_header_id = pla.po_header_id
       AND pla.item_id = msib.inventory_item_id
       AND pla.po_line_id = plla.po_line_id
       AND PHA.authorization_status = 'APPROVED'
       AND NVL (pha.cancel_flag, 'N') = 'N'
       AND NVL (PHA.closed_code, 'OPEN') = 'OPEN'
       AND NVL (pLa.cancel_flag, 'N') = 'N'
       AND NVL (PLA.closed_code, 'OPEN') = 'OPEN'
       AND NVL (msib.attribute7, 'N') = 'Y'
       AND mp.organization_id = plla.ship_to_organization_id
       and mp.master_organization_id = msib.organization_id
       AND pha.vendor_id = ap.vendor_id
       AND pha.vendor_site_id = assa.vendor_site_id
       AND (country <> 'BR' OR state = 'EX')
       and pah.object_type_code = 'PO'
       AND PAH.OBJECT_SUB_TYPE_CODE = 'STANDARD'
       AND PAH.ACTION_CODE = 'SUBMIT'
       AND PAH.OBJECT_ID = PHA.PO_HEADER_ID
       AND PAH.ACTION_CODE = 'SUBMIT'
       AND PAH.EMPLOYEE_ID = PAPF.PERSON_ID
       AND PHA.REVISION_NUM = OBJECT_REVISION_NUM
       AND PLA.ATTRIBUTE7 IS NULL
