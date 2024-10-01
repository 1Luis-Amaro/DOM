/*select B.ORGANIZATION_CODE SHIP_FROM
from apps.oe_order_headers_all a,
    apps.mtl_parameters b
where a.ship_from_org_id = B.ORGANIZATION_ID
AND A.SOLD_TO_ORG_ID = 
*/

SELECT ship_from_org.organization_code SHIP_FROM,
       h.sales_channel_code,
       h.cust_po_number,       
       h.order_number,
       h.ordered_date,
       ot.name ORDER_TYPE,
       pl.name PRICE_LIST,       
       term.name TERMS,       
       h.conversion_rate,
       h.conversion_rate_date,
       h.conversion_type_code,
       h.transactional_curr_code,
       ship_su.location SHIP_TO,
       ship_su.location SHIP_TO_LOCATION,
       CUST_ACCT.ACCOUNT_NUMBER CUSTOMER_NUMBER,
       PARTY.PARTY_NAME SOLD_TO,
       ship_loc.address1 SHIP_TO_ADDRESS1,
       ship_loc.address2 SHIP_TO_ADDRESS2,
       ship_loc.address3 SHIP_TO_ADDRESS3,
       ship_loc.address4 SHIP_TO_ADDRESS4,
       DECODE(ship_loc.city, NULL, NULL, ship_loc.city || ', ') ||
       DECODE(ship_loc.state,
              NULL,
              ship_loc.province || ', ',
              ship_loc.state || ', ') ||
       DECODE(ship_loc.postal_code,
              NULL,
              NULL,
              ship_loc.postal_code || ', ') ||
       DECODE(ship_loc.country, NULL, NULL, ship_loc.country) SHIP_TO_ADDRESS5,
       bill_su.location INVOICE_TO,
       bill_su.location INVOICE_TO_LOCATION,
       bill_loc.address1 INVOICE_TO_ADDRESS1,
       bill_loc.address2 INVOICE_TO_ADDRESS2,
       bill_loc.address3 INVOICE_TO_ADDRESS3,
       bill_loc.address4 INVOICE_TO_ADDRESS4,
       DECODE(bill_loc.city, NULL, NULL, bill_loc.city || ', ') ||
       DECODE(bill_loc.state,
              NULL,
              bill_loc.province || ', ',
              bill_loc.state || ', ') ||
       DECODE(bill_loc.postal_code,
              NULL,
              NULL,
              bill_loc.postal_code || ', ') ||
       DECODE(bill_loc.country, NULL, NULL, bill_loc.country) INVOICE_TO_ADDRESS5,
       ship_loc.state,
       OL.LINE_NUMBER || '.' || OL.SHIPMENT_NUMBER LINE_NUMBER,
       OL.ORDERED_ITEM,
       OL.SCHEDULE_SHIP_DATE,
       OL.ORDERED_QUANTITY,
       OL.ORDER_QUANTITY_UOM --,OL.GLOBAL_ATTRIBUTE5 NCM
/*
h.ROWID ROW_ID,
          h.header_id,
          h.org_id,
          h.order_type_id,
          h.version_number,
          h.order_source_id,
          h.source_document_type_id,
          h.orig_sys_document_ref,
          h.source_document_id,
          h.request_date,
          h.pricing_date,
          h.shipment_priority_code,
          h.demand_class_code,
          h.price_list_id,
          h.tax_exempt_flag,
          h.tax_exempt_number,
          h.tax_exempt_reason_code,
          h.conversion_rate,
          h.conversion_rate_date,
          h.conversion_type_code,
          h.partial_shipments_allowed,
          h.ship_tolerance_above,
          h.ship_tolerance_below,
          h.transactional_curr_code,
          h.agreement_id,
          h.tax_point_code,
          h.cust_po_number,
          h.invoicing_rule_id,
          h.accounting_rule_id,
          h.accounting_rule_duration,
          h.payment_term_id,
          h.shipping_method_code,
          h.fob_point_code,
          h.freight_terms_code,
          h.sold_to_org_id,
          h.sold_to_phone_id,
          h.ship_from_org_id,
          h.ship_to_org_id,
          h.invoice_to_org_id,
          h.deliver_to_org_id,
          h.sold_to_contact_id,
          h.ship_to_contact_id,
          h.invoice_to_contact_id,
          h.deliver_to_contact_id,
          h.creation_date,
          h.created_by,
          h.last_update_date,
          h.last_updated_by,
          h.last_update_login,
          h.expiration_date,
          h.request_id,
          h.program_application_id,
          h.program_id,
          h.program_update_date,
          h.context,
          h.attribute1,
          h.attribute2,
          h.attribute3,
          h.attribute4,
          h.attribute5,
          h.attribute6,
          h.attribute7,
          h.attribute8,
          h.attribute9,
          h.attribute10,
          h.attribute11,
          h.attribute12,
          h.attribute13,
          h.attribute14,
          h.attribute15,
          h.attribute16,
          h.attribute17,
          h.attribute18,
          h.attribute19,
          h.attribute20,
          h.global_attribute_category,
          h.global_attribute1,
          h.global_attribute2,
          h.global_attribute3,
          h.global_attribute4,
          h.global_attribute5,
          h.global_attribute6,
          h.global_attribute7,
          h.global_attribute8,
          h.global_attribute9,
          h.global_attribute10,
          h.global_attribute11,
          h.global_attribute12,
          h.global_attribute13,
          h.global_attribute14,
          h.global_attribute15,
          h.global_attribute16,
          h.global_attribute17,
          h.global_attribute18,
          h.global_attribute19,
          h.global_attribute20,
          h.TP_CONTEXT,
          h.TP_ATTRIBUTE1,
          h.TP_ATTRIBUTE2,
          h.TP_ATTRIBUTE3,
          h.TP_ATTRIBUTE4,
          h.TP_ATTRIBUTE5,
          h.TP_ATTRIBUTE6,
          h.TP_ATTRIBUTE7,
          h.TP_ATTRIBUTE8,
          h.TP_ATTRIBUTE9,
          h.TP_ATTRIBUTE10,
          h.TP_ATTRIBUTE11,
          h.TP_ATTRIBUTE12,
          h.TP_ATTRIBUTE13,
          h.TP_ATTRIBUTE14,
          h.TP_ATTRIBUTE15,
          h.freight_carrier_code,
          CUST_ACCT.ACCOUNT_NUMBER CUSTOMER_NUMBER,
          fndcur.precision CURRENCY_PRECISION,
          NULL ORDER_SOURCE,

          NULL SOURCE_DOCUMENT_TYPE,
          NULL AGREEMENT,
          pl.name PRICE_LIST,
          NULL CONVERSION_TYPE,
          accrule.name ACCOUNTING_RULE,
          invrule.name INVOICING_RULE,
          term.name TERMS,
          NULL SHIP_FROM_LOCATION,
          NULL SHIP_FROM_ADDRESS1,
          NULL SHIP_FROM_ADDRESS2,
          NULL SHIP_FROM_ADDRESS3,
          NULL SHIP_FROM_ADDRESS4,
          ship_su.location SHIP_TO,
          ship_su.location SHIP_TO_LOCATION,
          NULL DELIVER_TO,
          NULL DELIVER_TO_LOCATION,
          NULL DELIVER_TO_ADDRESS1,
          NULL DELIVER_TO_ADDRESS2,
          NULL DELIVER_TO_ADDRESS3,
          NULL DELIVER_TO_ADDRESS4,
          bill_su.location INVOICE_TO,
          bill_su.location INVOICE_TO_LOCATION,
          bill_loc.address1 INVOICE_TO_ADDRESS1,
          bill_loc.address2 INVOICE_TO_ADDRESS2,
          bill_loc.address3 INVOICE_TO_ADDRESS3,
          bill_loc.address4 INVOICE_TO_ADDRESS4,
             DECODE (bill_loc.city, NULL, NULL, bill_loc.city || ', ')
          || DECODE (bill_loc.state,
                     NULL, bill_loc.province || ', ',
                     bill_loc.state || ', ')
          || DECODE (bill_loc.postal_code,
                     NULL, NULL,
                     bill_loc.postal_code || ', ')
          || DECODE (bill_loc.country, NULL, NULL, bill_loc.country)
             INVOICE_TO_ADDRESS5,
             sold_party.PERSON_LAST_NAME
          || DECODE (sold_party.PERSON_FIRST_NAME,
                     NULL, NULL,
                     ', ' || sold_party.PERSON_FIRST_NAME)
             SOLD_TO_CONTACT,
             ship_party.PERSON_LAST_NAME
          || DECODE (ship_party.PERSON_FIRST_NAME,
                     NULL, NULL,
                     ', ' || ship_party.PERSON_FIRST_NAME)
             SHIP_TO_CONTACT,
             invoice_party.PERSON_LAST_NAME
          || DECODE (invoice_party.PERSON_FIRST_NAME,
                     NULL, NULL,
                     ', ' || invoice_party.PERSON_FIRST_NAME)
             INVOICE_TO_CONTACT,
          NULL DELIVER_TO_CONTACT,
          h.salesrep_id,
          h.return_reason_code,
          NULL return_reason,
          h.order_date_type_code,
          h.earliest_schedule_limit,
          h.latest_schedule_limit,
          h.PAYMENT_TYPE_CODE,
          h.PAYMENT_AMOUNT,
          h.CHECK_NUMBER,
          h.CREDIT_CARD_CODE,
          h.CREDIT_CARD_HOLDER_NAME,
          h.CREDIT_CARD_NUMBER,
          h.CREDIT_CARD_EXPIRATION_DATE,
          h.CREDIT_CARD_APPROVAL_CODE,
          h.CREDIT_CARD_APPROVAL_DATE,
          h.FIRST_ACK_CODE,
          h.FIRST_ACK_DATE,
          h.LAST_ACK_CODE,
          h.LAST_ACK_DATE,
          h.booked_flag,
          h.booked_date,
          h.cancelled_flag,
          h.open_flag,
          h.sold_from_org_id,
          h.shipping_instructions,
          h.packing_instructions,
          h.order_category_code,
          h.flow_status_code,
          NULL FREIGHT_CARRIER,
          DECODE (h.CUSTOMER_PREFERENCE_SET_CODE,
                  'ARRIVAL', 'Arrival',
                  'SHIP', 'Ship'),

          h.upgraded_flag,
          h.lock_control,
          party.email_address,
          NVL (party.gsa_indicator_flag, 'N') gsa_indicator,
          h.blanket_number,
          h.default_fulfillment_set,
          h.line_set_name,
          h.fulfillment_set_name,
          h.quote_date,
          h.quote_number,
          h.sales_document_name,
          h.transaction_phase_code,
          h.user_status_code,
          h.draft_submitted_flag,
          h.source_document_version_number,
          h.sold_to_site_use_id,
          h.SUPPLIER_SIGNATURE,
          h.SUPPLIER_SIGNATURE_DATE,
          h.CUSTOMER_SIGNATURE,
          h.CUSTOMER_SIGNATURE_DATE,
          h.minisite_id,
          h.end_customer_id,
          h.end_customer_contact_id,
          h.end_customer_site_use_id,
          NULL end_customer_name,
          NULL end_customer_number,
          NULL end_customer_contact,
          NULL end_customer_location,
          NULL end_customer_address1,
          NULL end_customer_address2,
          NULL end_customer_address3,
          NULL end_customer_address4,
          NULL end_customer_address5,
          h.ib_owner,
          h.ib_current_location,
          h.ib_installed_at_location,
          h.ORDER_FIRMED_DATE
*/

  FROM apps.mtl_parameters          ship_from_org,
       apps.hz_cust_site_uses_all   ship_su,
       apps.hz_party_sites          ship_ps,
       apps.hz_locations            ship_loc,
       apps.hz_cust_acct_sites_all  ship_cas,
       apps.hz_cust_site_uses_all   bill_su,
       apps.hz_party_sites          bill_ps,
       apps.hz_locations            bill_loc,
       apps.hz_cust_acct_sites_all  bill_cas,
       apps.hz_parties              party,
       apps.hz_cust_accounts_all    cust_acct,
       apps.ra_terms_tl             term,
       apps.oe_order_headers_all    h,
       apps.hz_cust_account_roles   sold_roles,
       apps.hz_parties              sold_party,
       apps.hz_cust_accounts_all    sold_acct,
       apps.hz_relationships        sold_rel,
       apps.hz_cust_account_roles   ship_roles,
       apps.hz_parties              ship_party,
       apps.hz_relationships        ship_rel,
       apps.hz_cust_accounts_all    ship_acct,
       apps.hz_cust_account_roles   invoice_roles,
       apps.hz_parties              invoice_party,
       apps.hz_relationships        invoice_rel,
       apps.hz_cust_accounts_all    invoice_acct,
       apps.fnd_currencies          fndcur,
       apps.oe_transaction_types_tl ot,
       apps.qp_list_headers_tl      pl,
       apps.ra_rules                invrule,
       apps.ra_rules                accrule
       
       --
      ,
       apps.oe_order_lines_all ol
--

 WHERE h.order_type_id = ot.transaction_type_id
   AND ot.language = USERENV('LANG')
   AND h.price_list_id = pl.list_header_id(+)
   AND pl.language(+) = USERENV('LANG')
   AND h.invoicing_rule_id = invrule.rule_id(+)
   AND h.accounting_rule_id = accrule.rule_id(+)
   AND h.payment_term_id = term.term_id(+)
   AND TERM.Language(+) = USERENV('LANG')
   AND h.transactional_curr_code = fndcur.currency_code
   AND h.sold_to_org_id = cust_acct.cust_account_id(+)
   AND CUST_ACCT.PARTY_ID = PARTY.PARTY_ID(+)
   AND h.ship_from_org_id = ship_from_org.organization_id(+)
   AND h.ship_to_org_id = ship_su.site_use_id(+)
   AND ship_su.cust_acct_site_id = ship_cas.cust_acct_site_id(+)
   AND ship_cas.party_site_id = ship_ps.party_site_id(+)
   AND ship_loc.location_id(+) = ship_ps.location_id
   AND h.invoice_to_org_id = bill_su.site_use_id(+)
   AND bill_su.cust_acct_site_id = bill_cas.cust_acct_site_id(+)
   AND bill_cas.party_site_id = bill_ps.party_site_id(+)
   AND bill_loc.location_id(+) = bill_ps.location_id
   AND h.sold_to_contact_id = sold_roles.cust_account_role_id(+)
   AND sold_roles.party_id = sold_rel.party_id(+)
   AND sold_roles.role_type(+) = 'CONTACT'
   AND sold_roles.cust_account_id = sold_acct.cust_account_id(+)
   AND NVL(sold_rel.object_id, -1) = NVL(sold_acct.party_id, -1)
   AND sold_rel.subject_id = sold_party.party_id(+)
   AND h.ship_to_contact_id = ship_roles.cust_account_role_id(+)
   AND ship_roles.party_id = ship_rel.party_id(+)
   AND ship_roles.role_type(+) = 'CONTACT'
   AND ship_roles.cust_account_id = ship_acct.cust_account_id(+)
   AND NVL(ship_rel.object_id, -1) = NVL(ship_acct.party_id, -1)
   AND ship_rel.subject_id = ship_party.party_id(+)
   AND h.invoice_to_contact_id = invoice_roles.cust_account_role_id(+)
   AND invoice_roles.party_id = invoice_rel.party_id(+)
   AND invoice_roles.role_type(+) = 'CONTACT'
   AND invoice_roles.cust_account_id = invoice_acct.cust_account_id(+)
   AND NVL(invoice_rel.object_id, -1) = NVL(invoice_acct.party_id, -1)
   AND invoice_rel.subject_id = invoice_party.party_id(+)
      --
   and h.flow_status_code = 'BOOKED'
      --          AND ship_loc.state IN ('RS','AM')
   and h.sales_channel_code in ('PKG', 'IND')
   and h.header_id = ol.header_id
   and ol.flow_status_code not in
       ('CLOSED', 'CANCELLED', 'AWAITING_RETURN')
   AND ot.name NOT IN ('RMA VENDA ST',
                       'RMA VENDA NAVIO ADM 6107',
                       'RMA CANCELAMENTO',
                       'RMA VENDA ST CNAE')
--and OL.ORDERED_ITEM in ('D747.11')
--        and OL.GLOBAL_ATTRIBUTE5 in ('32041700','32049000','32061119','32061130','32061990','32064990','32065029',
--      '32129010','32129090')
 ORDER BY ship_from_org.organization_code,
          h.sales_channel_code,
          h.order_number;