ALTER session set current_schema=apps;
BEGIN Fnd_Client_Info.SET_ORG_CONTEXT ( TO_CHAR(82) ); mo_global.set_policy_context ( 'S', 82 ) ;END;
/
SELECT territory_code, territory_short_name FROM apps.fnd_territories_vl;
SELECT NAME, organization_id FROM apps.hr_operating_units;
SELECT meaning, lookup_code FROM   apps.so_lookups WHERE  enabled_flag = 'Y' AND    trunc(SYSDATE) BETWEEN trunc(nvl(start_date_active, SYSDATE)) AND trunc(nvl(end_date_active, SYSDATE)) AND    lookup_type = 'SALES_CHANNEL' ORDER  BY meaning;
SELECT flex_value "Profile Class"
       ,description
       ,enabled_flag
       ,start_date_active
       ,end_date_active
FROM   (SELECT ffvs.flex_value_set_name
      ,ffvv.flex_value
      ,ffvv.description
      ,ffvv.enabled_flag
      ,ffvv.start_date_active
      ,ffvv.end_date_active
FROM   apps.fnd_flex_values_vl ffvv, apps.fnd_flex_value_sets ffvs
WHERE  (('' IS NULL) OR
       (structured_hierarchy_level IN
       (SELECT hierarchy_id
          FROM   apps.fnd_flex_hierarchies_vl h, apps.fnd_flex_value_sets ffvs
          WHERE  h.flex_value_set_id = ffvs.flex_value_set_id
          AND    h.hierarchy_name LIKE '')))
AND    ffvv.flex_value_set_id = ffvs.flex_value_set_id
ORDER  BY ffvs.flex_value_set_name, ffvv.flex_value)
WHERE  flex_value_set_name = 'PPG_BR_AR_PERFIL_PORTE_CLIENTE';
SELECT lookup_code "Customer Group", meaning "Description" FROM apps.fnd_lookup_values WHERE lookup_type  = 'PPG_BR_AR_GRP_CLIENTE' AND    language = userenv('LANG') ORDER BY 1;
SELECT flex_value "Activity Branch"
       ,description
       ,enabled_flag
       ,start_date_active
       ,end_date_active
FROM   (SELECT ffvs.flex_value_set_name
      ,ffvv.flex_value
      ,ffvv.description
      ,ffvv.enabled_flag
      ,ffvv.start_date_active
      ,ffvv.end_date_active
FROM   apps.fnd_flex_values_vl ffvv, apps.fnd_flex_value_sets ffvs
WHERE  (('' IS NULL) OR
       (structured_hierarchy_level IN
       (SELECT hierarchy_id
          FROM   apps.fnd_flex_hierarchies_vl h, apps.fnd_flex_value_sets ffvs
          WHERE  h.flex_value_set_id = ffvs.flex_value_set_id
          AND    h.hierarchy_name LIKE '')))
AND    ffvv.flex_value_set_id = ffvs.flex_value_set_id
ORDER  BY ffvs.flex_value_set_name, ffvv.flex_value
)
WHERE  flex_value_set_name = 'PPG_BR_AR_RAMO_ATIV';
SELECT flex_value "Sub Branch of Activity"
       ,description
       ,enabled_flag
       ,start_date_active
       ,end_date_active
FROM   (SELECT ffvs.flex_value_set_name
      ,ffvv.flex_value
      ,ffvv.description
      ,ffvv.enabled_flag
      ,ffvv.start_date_active
      ,ffvv.end_date_active
FROM   apps.fnd_flex_values_vl ffvv, apps.fnd_flex_value_sets ffvs
WHERE  (('' IS NULL) OR
       (structured_hierarchy_level IN
       (SELECT hierarchy_id
          FROM   apps.fnd_flex_hierarchies_vl h, apps.fnd_flex_value_sets ffvs
          WHERE  h.flex_value_set_id = ffvs.flex_value_set_id
          AND    h.hierarchy_name LIKE '')))
AND    ffvv.flex_value_set_id = ffvs.flex_value_set_id
ORDER  BY ffvs.flex_value_set_name, ffvv.flex_value
)
WHERE  flex_value_set_name = 'PPG_BR_AR_SUB_RAMO_ATIV';
SELECT NAME "Salesperson", salesrep_number "Salesrep NUMBER" FROM   apps.ra_salesreps WHERE  SYSDATE BETWEEN nvl(start_date_active, SYSDATE) AND nvl(end_date_active, SYSDATE) AND    nvl(status, 'A') = 'A';
SELECT organization_code "Deposit" ,organization_name "Deposit Description" FROM   apps.org_organization_definitions WHERE  trunc(SYSDATE) <= nvl(trunc(disable_date), trunc(SYSDATE)) ORDER  BY organization_name;
SELECT o.lookup_code "Cod Ship Method" ,o.meaning     "Desc.Ship Method" FROM   apps.oe_ship_methods_v o WHERE  o.enabled_flag = 'Y' AND    trunc(SYSDATE) BETWEEN trunc(o.start_date_active) AND nvl(trunc(end_date_active), trunc(SYSDATE)) ORDER  BY o.meaning;
SELECT lookup_code "Ship Priority Code" ,meaning "Ship Priority Desc" FROM   apps.fnd_lookup_values_vl WHERE  lookup_type = 'SHIPMENT_PRIORITY' AND    enabled_flag = 'Y' ORDER  BY 1;
SELECT territory_code, territory_short_name FROM   apps.fnd_territories_vl;
SELECT geography_name "city"
FROM   (SELECT geography_name
                  ,geography_name flex_display
                  ,geography_type
                  ,geography_use
                  ,country_code
                  ,end_date
FROM  apps.hz_geographies
 )
WHERE  geography_type = 'CITY'
AND    country_code = 'BR'
AND    geography_use = 'MASTER_REF'
AND    nvl(end_date, SYSDATE) >= SYSDATE;
SELECT geography_name state
FROM   (SELECT geography_name
                  ,geography_name flex_display
                  ,geography_type
                  ,geography_use
                  ,country_code
                  ,end_date
FROM   apps.hz_geographies
)
WHERE  geography_type = 'STATE'
AND    country_code = 'BR'
AND    geography_use = 'MASTER_REF'
AND    nvl(end_date, SYSDATE) >= SYSDATE;
SELECT lookup_code flex_value, lookup_code flex_display FROM   apps.fnd_lookup_values_vl WHERE  (lookup_type = 'PPG_BR_AR_GEOGR_REGION' AND enabled_flag = 'Y') AND    enabled_flag = 'Y';
SELECT tax_attr_class_code "Taxpayer Class"  FROM   apps.jl_zz_ar_tx_attcls_val_v WHERE  (tax_attr_class_type = 'CONTRIBUTOR_CLASS')AND    'Y' = 'Y';
SELECT gcc.concatenated_segments "Receivable"
FROM   apps.gl_code_combinations_kfv gcc
WHERE  enabled_flag = 'Y'
AND    nvl(end_date_active, SYSDATE) >= SYSDATE;
SELECT gcc.concatenated_segments "Revenue"
FROM   apps.gl_code_combinations_kfv gcc
WHERE  enabled_flag = 'Y'
AND    nvl(end_date_active, SYSDATE) >= SYSDATE;
SELECT gcc.concatenated_segments "Tax"
FROM   apps.gl_code_combinations_kfv gcc
WHERE  enabled_flag = 'Y'
AND    nvl(end_date_active, SYSDATE) >= SYSDATE;
SELECT *
FROM   (SELECT name FROM apps.ar_collectors);
SELECT currency_code, NAME, description
FROM   apps.fnd_currencies_vl
WHERE  currency_flag = 'Y'
AND    nvl(end_date_active, SYSDATE) >= SYSDATE;
SELECT lookup_code "Credit Rating Code" ,meaning "Credit Rating Desc" FROM   apps.fnd_lookup_values_vl WHERE  lookup_type = 'CREDIT_RATING' AND    enabled_flag = 'Y' ORDER  BY 1;
SELECT lookup_code "Credit Classification Code" ,meaning "Credit Classification Desc" FROM   apps.fnd_lookup_values_vl WHERE  lookup_type = 'AR_CMGT_CREDIT_CLASSIFICATION' AND    enabled_flag = 'Y' ORDER  BY 1;
SELECT lookup_code "Review Cycle Code" , meaning "Review Cycle Desc" FROM   apps.fnd_lookup_values_vl WHERE  lookup_type = 'PERIODIC_REVIEW_CYCLE' AND    enabled_flag = 'Y' ORDER  BY 1;
SELECT lookup_code "Account Status" , meaning "Account Status Desc" FROM   apps.fnd_lookup_values_vl WHERE  lookup_type = 'ACCOUNT_STATUS' AND    enabled_flag = 'Y' ORDER  BY 1;
SELECT lookup_code "Risk Code" FROM   apps.fnd_lookup_values_vl WHERE  lookup_type = 'RISK_CODE' AND    enabled_flag = 'Y' ORDER  BY 1;
SELECT *
FROM   (SELECT NAME
FROM   apps.ar_receipt_methods a
WHERE  nvl(end_date, SYSDATE) >= SYSDATE);
SELECT t.name "Payment Terms", t.description "Payment Terms Desc" FROM   apps.RA_TERMS_VL t WHERE  trunc(SYSDATE) BETWEEN start_date_active AND nvl(end_date_active, trunc(SYSDATE)) ORDER  BY NAME;
SELECT *
FROM   (SELECT NAME
FROM   apps.ar_receipt_methods a
WHERE  nvl(end_date, SYSDATE) >= SYSDATE);
SELECT territory_code, territory_short_name FROM   apps.fnd_territories_vl;
SELECT geography_name city
FROM   (SELECT geography_name
                  ,geography_name flex_display
                  ,geography_type
                  ,geography_use
                  ,country_code
                  ,end_date
FROM   apps.hz_geographies)
WHERE  geography_type = 'CITY'
AND    country_code = 'BR'
AND    geography_use = 'MASTER_REF'
AND    nvl(end_date, SYSDATE) >= SYSDATE;
SELECT geography_name state
FROM   (SELECT geography_name
                  ,geography_name flex_display
                  ,geography_type
                  ,geography_use
                  ,country_code
                  ,end_date
FROM   apps.hz_geographies
)
WHERE  geography_type = 'STATE'
AND    country_code = 'BR'
AND    geography_use = 'MASTER_REF'
AND    nvl(end_date, SYSDATE) >= SYSDATE;
SELECT flex_value "Product Line"
,description
,enabled_flag
,start_date_active
,end_date_active
FROM   (SELECT apps.ffvs.flex_value_set_name
      ,ffvv.flex_value
      ,ffvv.description
      ,ffvv.enabled_flag
      ,ffvv.start_date_active
      ,ffvv.end_date_active
FROM   apps.fnd_flex_values_vl ffvv, apps.fnd_flex_value_sets ffvs
WHERE  (('' IS NULL) OR
       (structured_hierarchy_level IN
       (SELECT hierarchy_id
          FROM   apps.fnd_flex_hierarchies_vl h, apps.fnd_flex_value_sets ffvs
          WHERE  h.flex_value_set_id = ffvs.flex_value_set_id
          AND    h.hierarchy_name LIKE '')))
AND    ffvv.flex_value_set_id = ffvs.flex_value_set_id
ORDER  BY ffvs.flex_value_set_name, ffvv.flex_value
)
WHERE  flex_value_set_name = 'XXGL_PRODUCT_LINE';
SELECT l.lookup_code "Sales Territory", l.meaning "Sales Territory DESC" FROM   apps.fnd_lookup_values_vl l WHERE  lookup_type = 'PPG_BR_AR_GEOGR_REGION' AND    l.enabled_flag = 'Y' AND    trunc(SYSDATE) BETWEEN nvl(start_date_active, trunc(SYSDATE)) AND nvl(end_date_active, trunc(SYSDATE))  ORDER BY l.lookup_code;
SELECT NAME "Salesperson", salesrep_number "Salesrep NUMBER" FROM   apps.ra_salesreps WHERE  SYSDATE BETWEEN nvl(start_date_active, SYSDATE) AND nvl(end_date_active, SYSDATE) AND    nvl(status, 'A') = 'A';
SELECT ot.name "Order Type", ot.description "Description" FROM   apps.oe_order_types_v ot WHERE  SYSDATE BETWEEN nvl(ot.start_date_active, SYSDATE) AND nvl(ot.end_date_active, SYSDATE) ORDER  BY ot.name;
SELECT  pl.name "Price List" FROM   apps.qp_list_headers_vl PL WHERE  SYSDATE BETWEEN nvl(pl.start_date_active, SYSDATE) AND nvl(pl.end_date_active, SYSDATE) AND    pl.list_type_code IN ('PRL') ORDER  BY pl.name;
SELECT l.lookup_code "Freight Terms", l.meaning "Freight Terms Desc" FROM   apps.so_lookups l WHERE  l.lookup_type = 'FREIGHT_TERMS' AND    l.enabled_flag = 'Y' AND    trunc(SYSDATE) BETWEEN nvl(start_date_active, trunc(SYSDATE)) AND nvl(end_date_active, trunc(SYSDATE)) ORDER  BY l.meaning;
SELECT l.lookup_code "Free On Board (FOB) Point", l.meaning "Free On Board (FOB) Point Desc" FROM   apps.ar_lookups l WHERE  l.lookup_type = 'FOB' AND    trunc(SYSDATE) BETWEEN start_date_active AND nvl(l.end_date_active, trunc(SYSDATE)) ORDER  BY l.meaning;
SELECT organization_code  ,organization_name FROM   apps.org_organization_definitions WHERE  trunc(SYSDATE) <= nvl(trunc(disable_date), trunc(SYSDATE)) ORDER  BY organization_name;
SELECT o.lookup_code "Cod Ship Method" ,o.meaning     "Desc.Ship Method" FROM   apps.oe_ship_methods_v o WHERE  o.enabled_flag = 'Y' AND    trunc(SYSDATE) BETWEEN trunc(o.start_date_active) AND nvl(trunc(end_date_active), trunc(SYSDATE)) ORDER  BY o.meaning;
SELECT l.lookup_code "Demand CLASS CODE", l.meaning "Demand CLASS DESC" FROM   apps.fnd_common_lookups l WHERE  lookup_type = 'DEMAND_CLASS' AND    l.enabled_flag = 'Y' AND    trunc(SYSDATE) BETWEEN nvl(start_date_active, trunc(SYSDATE)) AND nvl(end_date_active, trunc(SYSDATE))  ORDER BY l.lookup_code;
