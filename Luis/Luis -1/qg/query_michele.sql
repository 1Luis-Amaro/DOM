SELECT
  to_char((hra.location_id)) AS site_id,
  hra.location_code AS site_code,
  hra.description AS site_name,
  to_char((hra.inventory_organization_id)) AS plant_id,
  mp.organization_code AS plant_code,
  'LOC' AS site_type,
  hou.NAME AS plant_name,
  CASE
    WHEN (
      hra.region_1 != 'null'
      AND hra.region_2 = 'null'
      AND hra.region_3 != 'null'
    ) THEN hra.region_1 || ',' || hra.region_3 --Concat (hra.region_1, ",", hra.region_3)
        
    ELSE --Concat (
      (
        CASE
          WHEN hra.region_1 = 'null'
          OR hra.region_1 IS NULL THEN ''
          ELSE hra.region_1
        END
      ) ||(
    
        CASE
          WHEN hra.region_1 != 'null'
          AND hra.region_2 != 'null' THEN ','
          ELSE ''
        END
      ) || (
    
        CASE
          WHEN hra.region_2 = 'null'
          OR hra.region_2 IS NULL THEN ''
          ELSE hra.region_2
        END
      ) || (
    
        CASE
          WHEN hra.region_2 != 'null'
          AND hra.region_3 != 'null' THEN ','
          ELSE ''
        END
      ) || (
    
        CASE
          WHEN hra.region_3 = 'null'
          OR hra.region_3 IS NULL THEN ''
          ELSE hra.region_3
        END
      )
    
  END AS region,
  CASE
    WHEN (
      hra.address_line_1 != 'null'
      AND hra.address_line_2 = 'null'
      AND hra.address_line_3 != 'null'    
    ) THEN hra.address_line_1 || ',' || hra.address_line_3 --Concat (hra.address_line_1, ",", hra.address_line_3)
    
    ELSE --Concat (
      (
        CASE
          WHEN hra.address_line_1 = 'null'
          OR hra.address_line_1 IS NULL THEN ''
        
          ELSE hra.address_line_1
        END
      )||(
    
        CASE
          WHEN hra.address_line_1 != 'null'
          AND hra.address_line_2 != 'null' THEN ','
         
          ELSE ''
        END
      )||(
    
        CASE
          WHEN hra.address_line_2 = 'null'
          OR hra.address_line_2 IS NULL THEN ''
        
          ELSE hra.address_line_2
        END
      )||(
    
        CASE
          WHEN hra.address_line_2 != 'null'
          AND hra.address_line_3 != 'null' THEN ','
         
          ELSE ''
        END
      )||(
    
        CASE
          WHEN hra.address_line_3 = 'null'
          OR hra.address_line_3 IS NULL THEN ''
        
          ELSE hra.address_line_3
        END
      )
    
  END AS street_address,
  hra.town_or_city AS city,
  hra.country AS country,
  hra.postal_code AS postal_code,
  hra.region_2 AS state,
  CASE
    WHEN Nvl(hra.inactive_date, sysdate) = sysdate THEN 'y'
       
    ELSE 'n'
  END AS active_flag,
  hra.ship_to_site_flag AS ship_to_site_flag,
  hra.bill_to_site_flag AS bill_to_site_flag,
      
  to_char((hra.location_id)) || '|' || '{sourceID}' AS site_skey,
    
  to_char((hra.location_id)) || '|' || '${sourceID})' AS site_skey_bigint,
  NULL AS company_code,
  NULL AS purchasing_organization,
  NULL AS source_location,
  hra.creation_date AS creation_date,
  hra.last_update_date AS last_update_date,
  hra.created_by AS created_by_id
  --From_unixtime(Unix_timestamp()) AS load_timestamp,
  --'$batchrunID' AS batchrun_date,
  --'${sourceID}' AS source_system_id
FROM
  APPS.hr_locations_all hra 
  LEFT JOIN APPS.hr_all_organization_units_tl hou ON hou.organization_id = hra.inventory_organization_id 
  AND hou.language = 'US'
  LEFT JOIN APPS.mtl_parameters mp ON hra.inventory_organization_id = mp.organization_id ;

select inactive_date, hra.* from APPS.hr_locations_all hra;

SELECT
  to_char((hra.location_id)) AS site_id,
  hra.location_code AS site_code,
  hra.description AS site_name,
  to_char((hra.inventory_organization_id)) AS plant_id,
  mp.organization_code AS plant_code,
  'LOC' AS site_type,
  hou.NAME AS plant_name,
  CASE
    WHEN (
      hra.region_1 != 'null'
      AND hra.region_2 = 'null'
      AND hra.region_3 != 'null'
    ) THEN hra.region_1 || ',' || hra.region_3 --Concat (hra.region_1, ",", hra.region_3)
        
    ELSE --Concat (
      (
        CASE
          WHEN hra.region_1 = 'null'
          OR hra.region_1 IS NULL THEN ''
          ELSE hra.region_1
        END
      ) ||(
    
        CASE
          WHEN hra.region_1 != 'null'
          AND hra.region_2 != 'null' THEN ','
          ELSE ''
        END
      ) || (
    
        CASE
          WHEN hra.region_2 = 'null'
          OR hra.region_2 IS NULL THEN ''
          ELSE hra.region_2
        END
      ) || (
    
        CASE
          WHEN hra.region_2 != 'null'
          AND hra.region_3 != 'null' THEN ','
          ELSE ''
        END
      ) || (
    
        CASE
          WHEN hra.region_3 = 'null'
          OR hra.region_3 IS NULL THEN ''
          ELSE hra.region_3
        END
      )
    
  END AS region,
  CASE
    WHEN (
      hra.address_line_1 != 'null'
      AND hra.address_line_2 = 'null'
      AND hra.address_line_3 != 'null'    
    ) THEN hra.address_line_1 || ',' || hra.address_line_3 --Concat (hra.address_line_1, ",", hra.address_line_3)
    
    ELSE --Concat (
      (
        CASE
          WHEN hra.address_line_1 = 'null'
          OR hra.address_line_1 IS NULL THEN ''
        
          ELSE hra.address_line_1
        END
      )||(
    
        CASE
          WHEN hra.address_line_1 != 'null'
          AND hra.address_line_2 != 'null' THEN ','
         
          ELSE ''
        END
      )||(
    
        CASE
          WHEN hra.address_line_2 = 'null'
          OR hra.address_line_2 IS NULL THEN ''
        
          ELSE hra.address_line_2
        END
      )||(
    
        CASE
          WHEN hra.address_line_2 != 'null'
          AND hra.address_line_3 != 'null' THEN ','
         
          ELSE ''
        END
      )||(
    
        CASE
          WHEN hra.address_line_3 = 'null'
          OR hra.address_line_3 IS NULL THEN ''
        
          ELSE hra.address_line_3
        END
      )
    
  END AS street_address,
  hra.town_or_city AS city,
  hra.country AS country,
  hra.postal_code AS postal_code,
  hra.region_2 AS state,
  CASE
    WHEN Nvl(hra.inactive_date, sysdate) = sysdate THEN 'y'
       
    ELSE 'n'
  END AS active_flag,
  hra.ship_to_site_flag AS ship_to_site_flag,
  hra.bill_to_site_flag AS bill_to_site_flag,
      
  to_char((hra.location_id)) || '|' || '{sourceID}' AS site_skey,
    
  to_char((hra.location_id)) || '|' || '${sourceID})' AS site_skey_bigint,
  NULL AS company_code,
  NULL AS purchasing_organization,
  NULL AS source_location,
  hra.creation_date AS creation_date,
  hra.last_update_date AS last_update_date,
  hra.created_by AS created_by_id
  --From_unixtime(Unix_timestamp()) AS load_timestamp,
  --'$batchrunID' AS batchrun_date,
  --'${sourceID}' AS source_system_id
  FROM APPS.hr_locations_all hra,
       APPS.hr_all_organization_units_tl hou,
       APPS.mtl_parameters mp,
       APPS.mtl_parameters mp2
 WHERE hou.organization_id(+)        = hra.inventory_organization_id AND
       hou.language(+)               = 'US'                          AND
       hra.inventory_organization_id = mp2.organization_id            AND
       mp2.attribute6                = mp.organization_id AND hra.location_id = 142;   

select * from APPS.mtl_parameters mp where attribute6 is not null;
select * from APPS.mtl_parameters mp where organization_id = 101;



select * 
  from (   
select to_char(mp.organization_id) || '|' || '106' AS site_id,
       '' AS site_code,
       '' AS site_name,
       to_char((mp.organization_id)) AS plant_id,
       mp.organization_code AS plant_code,
       'LOC' AS site_type,
       mp.organization_code AS plant_name
  FROM APPS.hr_locations_all hra,
       APPS.hr_all_organization_units_tl hou,
       APPS.mtl_parameters mp,
       APPS.mtl_parameters mp2,
       apps.FND_LOOKUP_VALUES_VL flv
WHERE hou.organization_id(+)           = hra.inventory_organization_id  AND
      hou.language(+)                  = 'US'                           AND
      ((hra.inventory_organization_id  = mp2.organization_id          AND
        mp2.attribute6                 = mp.organization_id           AND
        mp2.ATTRIBUTE6 is not null) or
       (hra.inventory_organization_id  = mp2.organization_id          AND
        mp2.attribute7                 = mp.attribute7))              AND
      mp.organization_code             = flv.lookup_code                AND
      lookup_type                      = 'XPPGBR_ORGANIZACAO_TERCEIROS' AND
      enabled_flag                     = 'Y'                            AND
      end_date_active                 IS NULL  
union all       
select to_char((hra.location_id)) || '|' || '106' AS site_id,
       hra.location_code AS site_code,
       hra.description AS site_name,
       to_char((hra.inventory_organization_id)) AS plant_id,
       mp.organization_code AS plant_code,
       'LOC' AS site_type,
       hou.NAME AS plant_name
  FROM APPS.hr_locations_all hra,
       APPS.hr_all_organization_units_tl hou,
       APPS.mtl_parameters mp
WHERE hou.organization_id(+)        = hra.inventory_organization_id AND
       hou.language(+)               = 'US'                          AND
       hra.inventory_organization_id = mp.organization_id)
   order by 1, 5;