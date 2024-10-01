SELECT DISTINCT
       --hp.party_number          "Cod Cliente", --"ID do Registro",
       --HP.party_name            "Razao Social",
       --HPS1.party_site_number   "Numero do Local",
       --HPS1.party_site_name     "Nome Local",
       --hl.city                  "Cidade",
       --TRIM(HCP1.email_address) "E-Mail",
       hp.attribute2            "Negocio"
       --HCAS1.global_attribute3 || '/' || HCAS1.global_attribute4 || '-' || HCAS1.global_attribute5 "CNPJ"
       --hl.country,
       --ft.territory_short_name
       --HCSU1.*
      FROM APPS.HZ_CONTACT_POINTS      HCP1
          ,APPS.HZ_PARTIES             HP
         , APPS.HZ_PARTY_SITES         HPS1
         , APPS.HZ_CUST_SITE_USES_ALL  HCSU1
         , APPS.HZ_CUST_ACCT_SITES_ALL HCAS1
         , APPS.hz_locations           HL
         , APPS.FND_TERRITORIES_VL     FT
     WHERE HCP1.OWNER_TABLE_NAME(+)      = 'HZ_PARTY_SITES'
       AND HCP1.CONTACT_POINT_TYPE(+)    = 'EMAIL'
       AND HCP1.CONTACT_POINT_PURPOSE(+) = 'MAIL LAUDO'
       AND HCP1.STATUS(+)                = 'A'
       AND HCP1.email_address(+)  NOT LIKE '%PPG%'
       AND HCP1.email_address(+)  NOT LIKE '%ppg%'
       AND HCP1.OWNER_TABLE_ID(+)        = HPS1.PARTY_SITE_ID
       AND HCSU1.CUST_ACCT_SITE_ID       = HCAS1.CUST_ACCT_SITE_ID
       AND HCAS1.PARTY_SITE_ID           = HPS1.PARTY_SITE_ID
       AND HPS1.PARTY_ID                 = hp.party_id
       AND hp.status                     = 'A'
       AND hps1.status                   = 'A'   
       AND HCSU1.site_use_code           = 'SHIP_TO'
       AND HP.CREATED_BY_MODULE         <> 'HR API'    
       AND hl.location_id                = HPS1.location_id
       AND ft.territory_code             = hl.country
--       AND HP.party_name like '%TOYOTA%'
--       AND contact_point_id = 277555


select * from  APPS.HZ_CUST_ACCT_SITES_ALL; 

