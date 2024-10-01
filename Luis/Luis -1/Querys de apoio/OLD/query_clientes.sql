SELECT  --HZ_PARTIES  
HP.PARTY_ID
,HP.PARTY_NUMBER   "NUMERO CLIENTE"                                 
,HP.PARTY_NAME     "NOME CLIENTE"             
,HP.PARTY_TYPE                  
,HP.VALIDATED_FLAG              
,HP.LAST_UPDATED_BY             
,TRUNC(HP.CREATION_DATE)     "DATA CRIACAO"          
,HP.LAST_UPDATE_LOGIN           
,HP.REQUEST_ID                  
,HP.PROGRAM_APPLICATION_ID      
,HP.CREATED_BY                  
,HP.LAST_UPDATE_DATE            
,HP.PROGRAM_ID                  
,HP.PROGRAM_UPDATE_DATE         
,HP.WH_UPDATE_DATE              
,HP.ATTRIBUTE_CATEGORY          
,HP.ATTRIBUTE1                  
,HP.ATTRIBUTE2                  
,HP.ATTRIBUTE3                  
,HP.ATTRIBUTE4                  
,HP.ATTRIBUTE5                  
,HP.ATTRIBUTE6                  
,HP.ATTRIBUTE7                  
,HP.ATTRIBUTE8                  
,HP.ATTRIBUTE9                  
,HP.ATTRIBUTE10                 
,HP.ATTRIBUTE11                 
,HP.ATTRIBUTE12                 
,HP.ATTRIBUTE13                 
,HP.ATTRIBUTE14                 
,HP.ATTRIBUTE15                 
,HP.ATTRIBUTE16                 
,HP.ATTRIBUTE17                 
,HP.ATTRIBUTE18                 
,HP.ATTRIBUTE19                 
,HP.ATTRIBUTE20                 
,HP.ATTRIBUTE21                 
,HP.ATTRIBUTE22                 
,HP.ATTRIBUTE23                 
,HP.ATTRIBUTE24                 
,HP.GLOBAL_ATTRIBUTE_CATEGORY   
,HP.GLOBAL_ATTRIBUTE1           
,HP.GLOBAL_ATTRIBUTE2           
,HP.GLOBAL_ATTRIBUTE4           
,HP.GLOBAL_ATTRIBUTE3           
,HP.GLOBAL_ATTRIBUTE5           
,HP.GLOBAL_ATTRIBUTE6           
,HP.GLOBAL_ATTRIBUTE7           
,HP.GLOBAL_ATTRIBUTE8           
,HP.GLOBAL_ATTRIBUTE9           
,HP.GLOBAL_ATTRIBUTE10          
,HP.GLOBAL_ATTRIBUTE11          
,HP.GLOBAL_ATTRIBUTE12          
,HP.GLOBAL_ATTRIBUTE13          
,HP.GLOBAL_ATTRIBUTE14          
,HP.GLOBAL_ATTRIBUTE15          
,HP.GLOBAL_ATTRIBUTE16          
,HP.GLOBAL_ATTRIBUTE17          
,HP.GLOBAL_ATTRIBUTE18          
,HP.GLOBAL_ATTRIBUTE19          
,HP.GLOBAL_ATTRIBUTE20          
,HP.ORIG_SYSTEM_REFERENCE       
,HP.SIC_CODE                    
,HP.HQ_BRANCH_IND               
,HP.CUSTOMER_KEY                
,HP.TAX_REFERENCE               
,HP.JGZZ_FISCAL_CODE            
,HP.DUNS_NUMBER                 
,HP.TAX_NAME                    
,HP.PERSON_PRE_NAME_ADJUNCT     
,HP.PERSON_FIRST_NAME           
,HP.PERSON_MIDDLE_NAME          
,HP.PERSON_LAST_NAME            
,HP.PERSON_NAME_SUFFIX          
,HP.PERSON_TITLE                
,HP.PERSON_ACADEMIC_TITLE       
,HP.PERSON_PREVIOUS_LAST_NAME   
,HP.KNOWN_AS                    
,HP.PERSON_IDEN_TYPE            
,HP.PERSON_IDENTIFIER           
,HP.GROUP_TYPE                  
,HP.COUNTRY                     
,HP.ADDRESS1                    
,HP.ADDRESS2                    
,HP.ADDRESS3                    
,HP.ADDRESS4                    
,HP.CITY                     
,HP.POSTAL_CODE                 
,HP.STATE                       
,HP.PROVINCE                    
,HP.STATUS                      
,HP.COUNTY                      
,HP.SIC_CODE_TYPE               
,HP.TOTAL_NUM_OF_ORDERS         
,HP.TOTAL_ORDERED_AMOUNT        
,HP.LAST_ORDERED_DATE           
,HP.URL                         
,HP.EMAIL_ADDRESS               
,HP.DO_NOT_MAIL_FLAG            
,HP.ANALYSIS_FY                 
,HP.FISCAL_YEAREND_MONTH        
,HP.EMPLOYEES_TOTAL             
,HP.CURR_FY_POTENTIAL_REVENUE   
,HP.NEXT_FY_POTENTIAL_REVENUE   
,HP.YEAR_ESTABLISHED            
,HP.GSA_INDICATOR_FLAG          
,HP.MISSION_STATEMENT           
,HP.ORGANIZATION_NAME_PHONETIC  
,HP.PERSON_FIRST_NAME_PHONETIC  
,HP.PERSON_LAST_NAME_PHONETIC   
,HP.LANGUAGE_NAME               
,HP.CATEGORY_CODE               
,HP.REFERENCE_USE_FLAG          
,HP.THIRD_PARTY_FLAG            
,HP.COMPETITOR_FLAG             
,HP.SALUTATION                  
,HP.KNOWN_AS2                   
,HP.KNOWN_AS3                   
,HP.KNOWN_AS4                   
,HP.KNOWN_AS5                   
,HP.DUNS_NUMBER_C               
,HP.OBJECT_VERSION_NUMBER       
,HP.CREATED_BY_MODULE           
,HP.APPLICATION_ID              
,HP.PRIMARY_PHONE_CONTACT_PT_ID 
,HP.PRIMARY_PHONE_PURPOSE       
,HP.PRIMARY_PHONE_LINE_TYPE     
,HP.PRIMARY_PHONE_COUNTRY_CODE  
,HP.PRIMARY_PHONE_AREA_CODE     
,HP.PRIMARY_PHONE_NUMBER        
,HP.PRIMARY_PHONE_EXTENSION     
,HP.CERTIFICATION_LEVEL         
,HP.CERT_REASON_CODE            
,HP.PREFERRED_CONTACT_METHOD    
,HP.HOME_COUNTRY                
,HP.PERSON_BO_VERSION           
,HP.ORG_BO_VERSION              
,HP.PERSON_CUST_BO_VERSION      
,HP.ORG_CUST_BO_VERSION         
--HZ_CUST_ACCOUNTS
,HCA.CUST_ACCOUNT_ID                  HCA_CUST_ACCOUNT_ID                
,HCA.PARTY_ID                         HCA_PARTY_ID                       
,HCA.LAST_UPDATE_DATE                 HCA_LAST_UPDATE_DATE               
,HCA.ACCOUNT_NUMBER                   HCA_ACCOUNT_NUMBER                 
,HCA.LAST_UPDATED_BY                  HCA_LAST_UPDATED_BY                
,HCA.CREATION_DATE                    HCA_CREATION_DATE                  
,HCA.CREATED_BY                       HCA_CREATED_BY                     
,HCA.LAST_UPDATE_LOGIN                HCA_LAST_UPDATE_LOGIN              
,HCA.REQUEST_ID                       HCA_REQUEST_ID                     
,HCA.PROGRAM_APPLICATION_ID           HCA_PROGRAM_APPLICATION_ID         
,HCA.PROGRAM_ID                       HCA_PROGRAM_ID                     
,HCA.PROGRAM_UPDATE_DATE              HCA_PROGRAM_UPDATE_DATE            
,HCA.WH_UPDATE_DATE                   HCA_WH_UPDATE_DATE                 
,HCA.ATTRIBUTE_CATEGORY               HCA_ATTRIBUTE_CATEGORY             
,HCA.ATTRIBUTE1                       HCA_ATTRIBUTE1                     
,HCA.ATTRIBUTE2                       HCA_ATTRIBUTE2                     
,HCA.ATTRIBUTE3                       HCA_ATTRIBUTE3                     
,HCA.ATTRIBUTE4                       HCA_ATTRIBUTE4                     
,HCA.ATTRIBUTE5                       HCA_ATTRIBUTE5                     
,HCA.ATTRIBUTE6                       HCA_ATTRIBUTE6                     
,HCA.ATTRIBUTE7                       HCA_ATTRIBUTE7                     
,HCA.ATTRIBUTE8                       HCA_ATTRIBUTE8                     
,HCA.ATTRIBUTE9                       HCA_ATTRIBUTE9                     
,HCA.ATTRIBUTE10                      HCA_ATTRIBUTE10                    
,HCA.ATTRIBUTE11                      HCA_ATTRIBUTE11                    
,HCA.ATTRIBUTE12                      HCA_ATTRIBUTE12                    
,HCA.ATTRIBUTE13                      HCA_ATTRIBUTE13                    
,HCA.ATTRIBUTE14                      HCA_ATTRIBUTE14                    
,HCA.ATTRIBUTE15                      HCA_ATTRIBUTE15                    
,HCA.ATTRIBUTE16                      HCA_ATTRIBUTE16                    
,HCA.ATTRIBUTE17                      HCA_ATTRIBUTE17                    
,HCA.ATTRIBUTE18                      HCA_ATTRIBUTE18                    
,HCA.ATTRIBUTE19                      HCA_ATTRIBUTE19                    
,HCA.ATTRIBUTE20                      HCA_ATTRIBUTE20                      
,HCA.GLOBAL_ATTRIBUTE1                HCA_GLOBAL_ATTRIBUTE1              
,HCA.GLOBAL_ATTRIBUTE2                HCA_GLOBAL_ATTRIBUTE2              
,HCA.GLOBAL_ATTRIBUTE3                HCA_GLOBAL_ATTRIBUTE3              
,HCA.GLOBAL_ATTRIBUTE4                HCA_GLOBAL_ATTRIBUTE4              
,HCA.GLOBAL_ATTRIBUTE5                HCA_GLOBAL_ATTRIBUTE5              
,HCA.GLOBAL_ATTRIBUTE6                HCA_GLOBAL_ATTRIBUTE6              
,HCA.GLOBAL_ATTRIBUTE7                HCA_GLOBAL_ATTRIBUTE7              
,HCA.GLOBAL_ATTRIBUTE8                HCA_GLOBAL_ATTRIBUTE8              
,HCA.GLOBAL_ATTRIBUTE9                HCA_GLOBAL_ATTRIBUTE9              
,HCA.GLOBAL_ATTRIBUTE10               HCA_GLOBAL_ATTRIBUTE10             
,HCA.GLOBAL_ATTRIBUTE11               HCA_GLOBAL_ATTRIBUTE11             
,HCA.GLOBAL_ATTRIBUTE12               HCA_GLOBAL_ATTRIBUTE12             
,HCA.GLOBAL_ATTRIBUTE13               HCA_GLOBAL_ATTRIBUTE13             
,HCA.GLOBAL_ATTRIBUTE14               HCA_GLOBAL_ATTRIBUTE14             
,HCA.GLOBAL_ATTRIBUTE15               HCA_GLOBAL_ATTRIBUTE15             
,HCA.GLOBAL_ATTRIBUTE16               HCA_GLOBAL_ATTRIBUTE16             
,HCA.GLOBAL_ATTRIBUTE17               HCA_GLOBAL_ATTRIBUTE17             
,HCA.GLOBAL_ATTRIBUTE18               HCA_GLOBAL_ATTRIBUTE18             
,HCA.GLOBAL_ATTRIBUTE19               HCA_GLOBAL_ATTRIBUTE19             
,HCA.GLOBAL_ATTRIBUTE20               HCA_GLOBAL_ATTRIBUTE20             
,HCA.ORIG_SYSTEM_REFERENCE            HCA_ORIG_SYSTEM_REFERENCE          
,HCA.STATUS                           HCA_STATUS                         
,HCA.CUSTOMER_TYPE                    HCA_CUSTOMER_TYPE                  
,HCA.CUSTOMER_CLASS_CODE              HCA_CUSTOMER_CLASS_CODE            
,HCA.PRIMARY_SALESREP_ID              HCA_PRIMARY_SALESREP_ID            
,HCA.SALES_CHANNEL_CODE               HCA_SALES_CHANNEL_CODE             
,HCA.ORDER_TYPE_ID                    HCA_ORDER_TYPE_ID                  
,HCA.PRICE_LIST_ID                    HCA_PRICE_LIST_ID                  
,HCA.SUBCATEGORY_CODE                 HCA_SUBCATEGORY_CODE               
,HCA.TAX_CODE                         HCA_TAX_CODE                       
,HCA.FOB_POINT                        HCA_FOB_POINT                      
,HCA.FREIGHT_TERM                     HCA_FREIGHT_TERM                   
,HCA.SHIP_PARTIAL                     HCA_SHIP_PARTIAL                   
,HCA.SHIP_VIA                         HCA_SHIP_VIA                       
,HCA.WAREHOUSE_ID                     HCA_WAREHOUSE_ID                   
,HCA.PAYMENT_TERM_ID                  HCA_PAYMENT_TERM_ID                
,HCA.TAX_HEADER_LEVEL_FLAG            HCA_TAX_HEADER_LEVEL_FLAG          
,HCA.TAX_ROUNDING_RULE                HCA_TAX_ROUNDING_RULE              
,HCA.COTERMINATE_DAY_MONTH            HCA_COTERMINATE_DAY_MONTH          
,HCA.PRIMARY_SPECIALIST_ID            HCA_PRIMARY_SPECIALIST_ID          
,HCA.SECONDARY_SPECIALIST_ID          HCA_SECONDARY_SPECIALIST_ID        
,HCA.ACCOUNT_LIABLE_FLAG              HCA_ACCOUNT_LIABLE_FLAG            
,HCA.RESTRICTION_LIMIT_AMOUNT         HCA_RESTRICTION_LIMIT_AMOUNT       
,HCA.CURRENT_BALANCE                  HCA_CURRENT_BALANCE                
,HCA.PASSWORD_TEXT                    HCA_PASSWORD_TEXT                  
,HCA.HIGH_PRIORITY_INDICATOR          HCA_HIGH_PRIORITY_INDICATOR        
,HCA.ACCOUNT_ESTABLISHED_DATE         HCA_ACCOUNT_ESTABLISHED_DATE       
,HCA.ACCOUNT_TERMINATION_DATE         HCA_ACCOUNT_TERMINATION_DATE       
,HCA.ACCOUNT_ACTIVATION_DATE          HCA_ACCOUNT_ACTIVATION_DATE        
,HCA.CREDIT_CLASSIFICATION_CODE       HCA_CREDIT_CLASSIFICATION_CODE     
,HCA.DEPARTMENT                       HCA_DEPARTMENT                     
,HCA.MAJOR_ACCOUNT_NUMBER             HCA_MAJOR_ACCOUNT_NUMBER           
,HCA.HOTWATCH_SERVICE_FLAG            HCA_HOTWATCH_SERVICE_FLAG          
,HCA.HOTWATCH_SVC_BAL_IND             HCA_HOTWATCH_SVC_BAL_IND           
,HCA.HELD_BILL_EXPIRATION_DATE        HCA_HELD_BILL_EXPIRATION_DATE      
,HCA.HOLD_BILL_FLAG                   HCA_HOLD_BILL_FLAG                 
,HCA.HIGH_PRIORITY_REMARKS            HCA_HIGH_PRIORITY_REMARKS          
,HCA.PO_EFFECTIVE_DATE                HCA_PO_EFFECTIVE_DATE              
,HCA.PO_EXPIRATION_DATE               HCA_PO_EXPIRATION_DATE             
,HCA.REALTIME_RATE_FLAG               HCA_REALTIME_RATE_FLAG             
,HCA.SINGLE_USER_FLAG                 HCA_SINGLE_USER_FLAG               
,HCA.WATCH_ACCOUNT_FLAG               HCA_WATCH_ACCOUNT_FLAG             
,HCA.WATCH_BALANCE_INDICATOR          HCA_WATCH_BALANCE_INDICATOR        
,HCA.GEO_CODE                         HCA_GEO_CODE                       
,HCA.ACCT_LIFE_CYCLE_STATUS           HCA_ACCT_LIFE_CYCLE_STATUS         
,HCA.ACCOUNT_NAME                     HCA_ACCOUNT_NAME                   
,HCA.DEPOSIT_REFUND_METHOD            HCA_DEPOSIT_REFUND_METHOD          
,HCA.DORMANT_ACCOUNT_FLAG             HCA_DORMANT_ACCOUNT_FLAG           
,HCA.NPA_NUMBER                       HCA_NPA_NUMBER                     
,HCA.PIN_NUMBER                       HCA_PIN_NUMBER                     
,HCA.SUSPENSION_DATE                  HCA_SUSPENSION_DATE                
,HCA.WRITE_OFF_PAYMENT_AMOUNT         HCA_WRITE_OFF_PAYMENT_AMOUNT       
,HCA.WRITE_OFF_AMOUNT                 HCA_WRITE_OFF_AMOUNT               
,HCA.SOURCE_CODE                      HCA_SOURCE_CODE                    
,HCA.COMPETITOR_TYPE                  HCA_COMPETITOR_TYPE                
,HCA.COMMENTS                         HCA_COMMENTS                       
,HCA.DATES_NEGATIVE_TOLERANCE         HCA_DATES_NEGATIVE_TOLERANCE       
,HCA.DATES_POSITIVE_TOLERANCE         HCA_DATES_POSITIVE_TOLERANCE       
,HCA.DATE_TYPE_PREFERENCE             HCA_DATE_TYPE_PREFERENCE           
,HCA.OVER_SHIPMENT_TOLERANCE          HCA_OVER_SHIPMENT_TOLERANCE        
,HCA.UNDER_SHIPMENT_TOLERANCE         HCA_UNDER_SHIPMENT_TOLERANCE       
,HCA.OVER_RETURN_TOLERANCE            HCA_OVER_RETURN_TOLERANCE          
,HCA.UNDER_RETURN_TOLERANCE           HCA_UNDER_RETURN_TOLERANCE         
,HCA.ITEM_CROSS_REF_PREF              HCA_ITEM_CROSS_REF_PREF            
,HCA.SCHED_DATE_PUSH_FLAG             HCA_SCHED_DATE_PUSH_FLAG           
,HCA.INVOICE_QUANTITY_RULE            HCA_INVOICE_QUANTITY_RULE          
,HCA.PRICING_EVENT                    HCA_PRICING_EVENT                  
,HCA.ACCOUNT_REPLICATION_KEY          HCA_ACCOUNT_REPLICATION_KEY        
,HCA.STATUS_UPDATE_DATE               HCA_STATUS_UPDATE_DATE             
,HCA.AUTOPAY_FLAG                     HCA_AUTOPAY_FLAG                   
,HCA.NOTIFY_FLAG                      HCA_NOTIFY_FLAG                    
,HCA.LAST_BATCH_ID                    HCA_LAST_BATCH_ID                  
,HCA.ORG_ID                           HCA_ORG_ID                         
,HCA.OBJECT_VERSION_NUMBER            HCA_OBJECT_VERSION_NUMBER          
,HCA.CREATED_BY_MODULE                HCA_CREATED_BY_MODULE              
,HCA.APPLICATION_ID                   HCA_APPLICATION_ID                 
,HCA.SELLING_PARTY_ID                 HCA_SELLING_PARTY_ID   
--HZ_PARTY_SITES  
,HPS.PARTY_SITE_ID                    HPS_PARTY_SITE_ID                         
,HPS.PARTY_ID                         HPS_PARTY_ID                  
,HPS.LOCATION_ID                      HPS_LOCATION_ID               
,HPS.LAST_UPDATE_DATE                 HPS_LAST_UPDATE_DATE          
,HPS.PARTY_SITE_NUMBER                HPS_PARTY_SITE_NUMBER         
,HPS.LAST_UPDATED_BY                  HPS_LAST_UPDATED_BY           
,HPS.CREATION_DATE                    HPS_CREATION_DATE             
,HPS.CREATED_BY                       HPS_CREATED_BY                
,HPS.LAST_UPDATE_LOGIN                HPS_LAST_UPDATE_LOGIN         
,HPS.REQUEST_ID                       HPS_REQUEST_ID                
,HPS.PROGRAM_APPLICATION_ID           HPS_PROGRAM_APPL_ID    
,HPS.PROGRAM_ID                       HPS_PROGRAM_ID                
,HPS.PROGRAM_UPDATE_DATE              HPS_PROGRAM_UPDATE_DATE       
,HPS.WH_UPDATE_DATE                   HPS_WH_UPDATE_DATE            
,HPS.ATTRIBUTE_CATEGORY               HPS_ATTRIBUTE_CATEG       
,HPS.ATTRIBUTE1                       HPS_ATTRIBUTE1                
,HPS.ATTRIBUTE2                       HPS_ATTRIBUTE2                
,HPS.ATTRIBUTE3                       HPS_ATTRIBUTE3                
,HPS.ATTRIBUTE4                       HPS_ATTRIBUTE4                
,HPS.ATTRIBUTE5                       HPS_ATTRIBUTE5                
,HPS.ATTRIBUTE6                       HPS_ATTRIBUTE6                
,HPS.ATTRIBUTE7                       HPS_ATTRIBUTE7                
,HPS.ATTRIBUTE8                       HPS_ATTRIBUTE8                
,HPS.ATTRIBUTE9                       HPS_ATTRIBUTE9                
,HPS.ATTRIBUTE10                      HPS_ATTRIBUTE10               
,HPS.ATTRIBUTE11                      HPS_ATTRIBUTE11               
,HPS.ATTRIBUTE12                      HPS_ATTRIBUTE12               
,HPS.ATTRIBUTE13                      HPS_ATTRIBUTE13               
,HPS.ATTRIBUTE14                      HPS_ATTRIBUTE14               
,HPS.ATTRIBUTE15                      HPS_ATTRIBUTE15               
,HPS.ATTRIBUTE16                      HPS_ATTRIBUTE16               
,HPS.ATTRIBUTE17                      HPS_ATTRIBUTE17               
,HPS.ATTRIBUTE18                      HPS_ATTRIBUTE18               
,HPS.ATTRIBUTE19                      HPS_ATTRIBUTE19               
,HPS.ATTRIBUTE20                      HPS_ATTRIBUTE20               
,HPS.GLOBAL_ATTRIBUTE_CATEGORY        HPS_GLOBAL_ATTR_CATEG 
,HPS.GLOBAL_ATTRIBUTE1                HPS_GLOBAL_ATTRIBUTE1         
,HPS.GLOBAL_ATTRIBUTE2                HPS_GLOBAL_ATTRIBUTE2         
,HPS.GLOBAL_ATTRIBUTE3                HPS_GLOBAL_ATTRIBUTE3         
,HPS.GLOBAL_ATTRIBUTE4                HPS_GLOBAL_ATTRIBUTE4         
,HPS.GLOBAL_ATTRIBUTE5                HPS_GLOBAL_ATTRIBUTE5         
,HPS.GLOBAL_ATTRIBUTE6                HPS_GLOBAL_ATTRIBUTE6         
,HPS.GLOBAL_ATTRIBUTE7                HPS_GLOBAL_ATTRIBUTE7         
,HPS.GLOBAL_ATTRIBUTE8                HPS_GLOBAL_ATTRIBUTE8         
,HPS.GLOBAL_ATTRIBUTE9                HPS_GLOBAL_ATTRIBUTE9         
,HPS.GLOBAL_ATTRIBUTE10               HPS_GLOBAL_ATTRIBUTE10        
,HPS.GLOBAL_ATTRIBUTE11               HPS_GLOBAL_ATTRIBUTE11        
,HPS.GLOBAL_ATTRIBUTE12               HPS_GLOBAL_ATTRIBUTE12        
,HPS.GLOBAL_ATTRIBUTE13               HPS_GLOBAL_ATTRIBUTE13        
,HPS.GLOBAL_ATTRIBUTE14               HPS_GLOBAL_ATTRIBUTE14        
,HPS.GLOBAL_ATTRIBUTE15               HPS_GLOBAL_ATTRIBUTE15        
,HPS.GLOBAL_ATTRIBUTE16               HPS_GLOBAL_ATTRIBUTE16        
,HPS.GLOBAL_ATTRIBUTE17               HPS_GLOBAL_ATTRIBUTE17        
,HPS.GLOBAL_ATTRIBUTE18               HPS_GLOBAL_ATTRIBUTE18        
,HPS.GLOBAL_ATTRIBUTE19               HPS_GLOBAL_ATTRIBUTE19        
,HPS.GLOBAL_ATTRIBUTE20               HPS_GLOBAL_ATTRIBUTE20        
,HPS.ORIG_SYSTEM_REFERENCE            HPS_ORIG_SYSTEM_REFER     
,HPS.START_DATE_ACTIVE                HPS_START_DATE_ACTIVE         
,HPS.END_DATE_ACTIVE                  HPS_END_DATE_ACTIVE           
,HPS.REGION                           HPS_REGION                    
,HPS.MAILSTOP                         HPS_MAILSTOP                  
,HPS.CUSTOMER_KEY_OSM                 HPS_CUSTOMER_KEY_OSM          
,HPS.PHONE_KEY_OSM                    HPS_PHONE_KEY_OSM             
,HPS.CONTACT_KEY_OSM                  HPS_CONTACT_KEY_OSM           
,HPS.IDENTIFYING_ADDRESS_FLAG         HPS_IDENT_ADDR_FLAG  
,HPS.LANGUAGE                         HPS_LANGUAGE                  
,HPS.STATUS                           HPS_STATUS                    
,HPS.PARTY_SITE_NAME                  HPS_PARTY_SITE_NAME           
,HPS.ADDRESSEE                        HPS_ADDRESSEE                 
,HPS.OBJECT_VERSION_NUMBER            HPS_OBJECT_VERSION_NUMBER     
,HPS.CREATED_BY_MODULE                HPS_CREATED_BY_MODULE         
,HPS.APPLICATION_ID                   HPS_APPLICATION_ID            
,HPS.ACTUAL_CONTENT_SOURCE            HPS_ACTUAL_CONTT_SOURCE     
,HPS.GLOBAL_LOCATION_NUMBER           HPS_GLOBAL_LOCAT_NUMBER    
,HPS.DUNS_NUMBER_C                    HPS_DUNS_NUMBER_C             
--HZ_LOCATIONS                        
,HL.LOCATION_ID                       HL_LOCATION_ID                   
,HL.LAST_UPDATE_DATE                  HL_LAST_UPDATE_DATE              
,HL.LAST_UPDATED_BY                   HL_LAST_UPDATED_BY               
,HL.CREATION_DATE                     HL_CREATION_DATE                 
,HL.CREATED_BY                        HL_CREATED_BY                    
,HL.LAST_UPDATE_LOGIN                 HL_LAST_UPDATE_LOGIN             
,HL.REQUEST_ID                        HL_REQUEST_ID                   
,HL.PROGRAM_APPLICATION_ID            HL_PROGRAM_APPLICATION_ID       
,HL.PROGRAM_ID                        HL_PROGRAM_ID                   
,HL.PROGRAM_UPDATE_DATE               HL_PROGRAM_UPDATE_DATE          
,HL.WH_UPDATE_DATE                    HL_WH_UPDATE_DATE               
,HL.ATTRIBUTE_CATEGORY                HL_ATTRIBUTE_CATEGORY           
,HL.ATTRIBUTE1                        HL_ATTRIBUTE1                   
,HL.ATTRIBUTE2                        HL_ATTRIBUTE2                   
,HL.ATTRIBUTE3                        HL_ATTRIBUTE3                   
,HL.ATTRIBUTE4                        HL_ATTRIBUTE4                   
,HL.ATTRIBUTE5                        HL_ATTRIBUTE5                   
,HL.ATTRIBUTE6                        HL_ATTRIBUTE6                   
,HL.ATTRIBUTE7                        HL_ATTRIBUTE7                   
,HL.ATTRIBUTE8                        HL_ATTRIBUTE8                   
,HL.ATTRIBUTE9                        HL_ATTRIBUTE9                   
,HL.ATTRIBUTE10                       HL_ATTRIBUTE10                  
,HL.ATTRIBUTE11                       HL_ATTRIBUTE11                  
,HL.ATTRIBUTE12                       HL_ATTRIBUTE12                  
,HL.ATTRIBUTE13                       HL_ATTRIBUTE13                  
,HL.ATTRIBUTE14                       HL_ATTRIBUTE14                  
,HL.ATTRIBUTE15                       HL_ATTRIBUTE15                  
,HL.ATTRIBUTE16                       HL_ATTRIBUTE16                  
,HL.ATTRIBUTE17                       HL_ATTRIBUTE17                  
,HL.ATTRIBUTE18                       HL_ATTRIBUTE18                  
,HL.ATTRIBUTE19                       HL_ATTRIBUTE19                  
,HL.ATTRIBUTE20                       HL_ATTRIBUTE20                  
,HL.GLOBAL_ATTRIBUTE_CATEGORY         HL_GLOBAL_ATTR_CATEG    
,HL.GLOBAL_ATTRIBUTE1                 HL_GLOBAL_ATTRIBUTE1            
,HL.GLOBAL_ATTRIBUTE2                 HL_GLOBAL_ATTRIBUTE2            
,HL.GLOBAL_ATTRIBUTE3                 HL_GLOBAL_ATTRIBUTE3            
,HL.GLOBAL_ATTRIBUTE4                 HL_GLOBAL_ATTRIBUTE4            
,HL.GLOBAL_ATTRIBUTE5                 HL_GLOBAL_ATTRIBUTE5            
,HL.GLOBAL_ATTRIBUTE6                 HL_GLOBAL_ATTRIBUTE6            
,HL.GLOBAL_ATTRIBUTE7                 HL_GLOBAL_ATTRIBUTE7            
,HL.GLOBAL_ATTRIBUTE8                 HL_GLOBAL_ATTRIBUTE8            
,HL.GLOBAL_ATTRIBUTE9                 HL_GLOBAL_ATTRIBUTE9            
,HL.GLOBAL_ATTRIBUTE10                HL_GLOBAL_ATTRIBUTE10           
,HL.GLOBAL_ATTRIBUTE11                HL_GLOBAL_ATTRIBUTE11           
,HL.GLOBAL_ATTRIBUTE12                HL_GLOBAL_ATTRIBUTE12           
,HL.GLOBAL_ATTRIBUTE13                HL_GLOBAL_ATTRIBUTE13           
,HL.GLOBAL_ATTRIBUTE14                HL_GLOBAL_ATTRIBUTE14           
,HL.GLOBAL_ATTRIBUTE15                HL_GLOBAL_ATTRIBUTE15           
,HL.GLOBAL_ATTRIBUTE16                HL_GLOBAL_ATTRIBUTE16           
,HL.GLOBAL_ATTRIBUTE17                HL_GLOBAL_ATTRIBUTE17           
,HL.GLOBAL_ATTRIBUTE18                HL_GLOBAL_ATTRIBUTE18           
,HL.GLOBAL_ATTRIBUTE19                HL_GLOBAL_ATTRIBUTE19           
,HL.GLOBAL_ATTRIBUTE20                HL_GLOBAL_ATTRIBUTE20           
,HL.ORIG_SYSTEM_REFERENCE             HL_ORIG_SYSTEM_REFER
,HL.COUNTRY                           HL_COUNTRY                      
,HL.ADDRESS1                          HL_ADDRESS1                     
,HL.ADDRESS2                          HL_ADDRESS2                     
,HL.ADDRESS3                          HL_ADDRESS3                     
,HL.ADDRESS4                          HL_ADDRESS4                     
,HL.CITY                              HL_CITY                         
,HL.POSTAL_CODE                       HL_POSTAL_CODE                  
,HL.STATE                             HL_STATE                        
,HL.PROVINCE                          HL_PROVINCE                     
,HL.COUNTY                            HL_COUNTY                       
,HL.ADDRESS_KEY                       HL_ADDRESS_KEY                  
,HL.ADDRESS_STYLE                     HL_ADDRESS_STYLE                
,HL.VALIDATED_FLAG                    HL_VALIDATED_FLAG               
,HL.ADDRESS_LINES_PHONETIC            HL_ADDR_LIN_PHON       
,HL.APARTMENT_FLAG                    HL_APARTMENT_FLAG               
,HL.PO_BOX_NUMBER                     HL_PO_BOX_NUMBER                
,HL.HOUSE_NUMBER                      HL_HOUSE_NUMBER                 
,HL.STREET_SUFFIX                     HL_STREET_SUFFIX                
,HL.APARTMENT_NUMBER                  HL_APARTMENT_NUMBER             
,HL.SECONDARY_SUFFIX_ELEMENT          HL_SECONDARY_SUF_ELEM
,HL.STREET                            HL_STREET                       
,HL.RURAL_ROUTE_TYPE                  HL_RURAL_ROUTE_TYPE             
,HL.RURAL_ROUTE_NUMBER                HL_RURAL_ROUTE_NUMBER           
,HL.STREET_NUMBER                     HL_STREET_NUMBER                
,HL.BUILDING                          HL_BUILDING                     
,HL.FLOOR                             HL_FLOOR                        
,HL.SUITE                             HL_SUITE                        
,HL.ROOM                              HL_ROOM                         
,HL.POSTAL_PLUS4_CODE                 HL_POSTAL_PLUS4_CODE            
,HL.TIME_ZONE                         HL_TIME_ZONE                    
,HL.OVERSEAS_ADDRESS_FLAG             HL_OVERSEAS_ADDRESS_FLAG        
,HL.POST_OFFICE                       HL_POST_OFFICE                  
,HL.POSITION                          HL_POSITION                     
,HL.DELIVERY_POINT_CODE               HL_DELIVERY_POINT_CODE          
,HL.LOCATION_DIRECTIONS               HL_LOCATION_DIRECTIONS          
,HL.ADDRESS_EFFECTIVE_DATE            HL_ADDRESS_EFFEC_DATE       
,HL.ADDRESS_EXPIRATION_DATE           HL_ADDRESS_EXP_DATE      
,HL.ADDRESS_ERROR_CODE                HL_ADDRESS_ERROR_CODE           
,HL.CLLI_CODE                         HL_CLLI_CODE                    
,HL.DODAAC                            HL_DODAAC                       
,HL.TRAILING_DIRECTORY_CODE           HL_TRAILING_DIR_CODE      
,HL.LANGUAGE                          HL_LANGUAGE                     
,HL.LIFE_CYCLE_STATUS                 HL_LIFE_CYCLE_STATUS            
,HL.SHORT_DESCRIPTION                 HL_SHORT_DESCRIPTION            
,HL.DESCRIPTION                       HL_DESCRIPTION                  
,HL.CONTENT_SOURCE_TYPE               HL_CONTENT_SOURCE_TYPE          
,HL.LOC_HIERARCHY_ID                  HL_LOC_HIERARCHY_ID             
,HL.SALES_TAX_GEOCODE                 HL_SALES_TAX_GEOCODE            
,HL.SALES_TAX_INSIDE_CITY_LIMITS      HL_SALES_TAX_INS_CITY_LIM 
,HL.FA_LOCATION_ID                    HL_FA_LOCATION_ID               
--,HL.GEOMETRY                        HL_L.GEOMETRY                    
,HL.OBJECT_VERSION_NUMBER             HL_OBJECT_VERSION_NUMBER        
,HL.CREATED_BY_MODULE                 HL_CREATED_BY_MODULE            
,HL.APPLICATION_ID                    HL_APPLICATION_ID               
,HL.TIMEZONE_ID                       HL_TIMEZONE_ID                  
,HL.GEOMETRY_STATUS_CODE              HL_GEOMETRY_STATUS_CODE         
,HL.ACTUAL_CONTENT_SOURCE             HL_ACTUAL_CONTENT_SOURCE        
,HL.VALIDATION_STATUS_CODE            HL_VALIDATION_STATUS_CODE       
,HL.DATE_VALIDATED                    HL_DATE_VALIDATED               
,HL.DO_NOT_VALIDATE_FLAG              HL_DO_NOT_VALIDATE_FLAG         
,HL.GEOMETRY_SOURCE                   HL_GEOMETRY_SOURCE              
FROM APPS.HZ_CUST_ACCOUNTS   HCA
    ,APPS.HZ_PARTIES             HP
    ,APPS.HZ_PARTY_SITES         HPS
    ,APPS.HZ_LOCATIONS           HL
WHERE HP.PARTY_ID = HCA.PARTY_ID
 AND HP.PARTY_ID = HPS.PARTY_ID
 AND HL.LOCATION_ID = HPS.LOCATION_ID