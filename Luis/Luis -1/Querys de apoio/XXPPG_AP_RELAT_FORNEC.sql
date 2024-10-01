SELECT PV.VENDOR_ID                      
,PV.LAST_UPDATE_DATE               
,PV.LAST_UPDATED_BY 
,(select FU.description
from apps.FND_USER FU
where PV.LAST_UPDATED_BY = FU.USER_ID) UPDATED_NAME               
,PV.VENDOR_NAME                    
,PV.VENDOR_NAME_ALT                
,PV.SEGMENT1                       
,PV.SUMMARY_FLAG                   
,PV.ENABLED_FLAG                   
,PV.SEGMENT2                       
,PV.SEGMENT3                       
,PV.SEGMENT4                       
,PV.SEGMENT5                       
,PV.LAST_UPDATE_LOGIN              
,TRUNC(PV.CREATION_DATE) CREATION_DATE                  
,PV.CREATED_BY
,(select FU.description
from apps.FND_USER FU
where PV.CREATED_BY = FU.USER_ID) CREATED_NAME                    
,PV.EMPLOYEE_ID                    
,PV.VENDOR_TYPE_LOOKUP_CODE        
,PV.CUSTOMER_NUM                   
,PV.ONE_TIME_FLAG                  
,PV.PARENT_VENDOR_ID               
,PV.MIN_ORDER_AMOUNT               
,PV.TERMS_ID                       
,PV.SET_OF_BOOKS_ID                
,PV.ALWAYS_TAKE_DISC_FLAG          
,PV.PAY_DATE_BASIS_LOOKUP_CODE     
,PV.PAY_GROUP_LOOKUP_CODE          
,PV.PAYMENT_PRIORITY               
,PV.INVOICE_CURRENCY_CODE          
,PV.PAYMENT_CURRENCY_CODE          
,PV.INVOICE_AMOUNT_LIMIT           
,PV.HOLD_ALL_PAYMENTS_FLAG         
,PV.HOLD_FUTURE_PAYMENTS_FLAG      
,PV.HOLD_REASON                    
,PV.NUM_1099                       
,PV.INDIVIDUAL_1099                
,PV.TYPE_1099                      
,PV.WITHHOLDING_STATUS_LOOKUP_CODE 
,PV.WITHHOLDING_START_DATE         
,PV.ORGANIZATION_TYPE_LOOKUP_CODE  
,PV.START_DATE_ACTIVE              
,PV.END_DATE_ACTIVE                
,PV.MINORITY_GROUP_LOOKUP_CODE     
,PV.WOMEN_OWNED_FLAG               
,PV.SMALL_BUSINESS_FLAG            
,PV.STANDARD_INDUSTRY_CLASS        
,PV.HOLD_FLAG                      
,PV.PURCHASING_HOLD_REASON         
,PV.HOLD_BY                        
,PV.HOLD_DATE                      
,PV.TERMS_DATE_BASIS               
,PV.INSPECTION_REQUIRED_FLAG       
,PV.RECEIPT_REQUIRED_FLAG          
,PV.QTY_RCV_TOLERANCE              
,PV.QTY_RCV_EXCEPTION_CODE         
,PV.ENFORCE_SHIP_TO_LOCATION_CODE  
,PV.DAYS_EARLY_RECEIPT_ALLOWED     
,PV.DAYS_LATE_RECEIPT_ALLOWED      
,PV.RECEIPT_DAYS_EXCEPTION_CODE    
,PV.RECEIVING_ROUTING_ID           
,PV.ALLOW_SUBSTITUTE_RECEIPTS_FLAG 
,PV.ALLOW_UNORDERED_RECEIPTS_FLAG  
,PV.HOLD_UNMATCHED_INVOICES_FLAG   
,PV.TAX_VERIFICATION_DATE          
,PV.NAME_CONTROL                   
,PV.STATE_REPORTABLE_FLAG          
,PV.FEDERAL_REPORTABLE_FLAG        
,PV.ATTRIBUTE_CATEGORY             
,PV.ATTRIBUTE1                     
,PV.ATTRIBUTE2                     
,PV.ATTRIBUTE3                     
,PV.ATTRIBUTE4                     
,PV.ATTRIBUTE5                     
,PV.ATTRIBUTE6                     
,PV.ATTRIBUTE7                     
,PV.ATTRIBUTE8                     
,PV.ATTRIBUTE9                     
,PV.ATTRIBUTE10                    
,PV.ATTRIBUTE11                    
,PV.ATTRIBUTE12                    
,PV.ATTRIBUTE13                    
,PV.ATTRIBUTE14                    
,PV.ATTRIBUTE15                    
,PV.REQUEST_ID                     
,PV.PROGRAM_APPLICATION_ID         
,PV.PROGRAM_ID                     
,PV.PROGRAM_UPDATE_DATE            
,PV.VAT_REGISTRATION_NUM           
,PV.AUTO_CALCULATE_INTEREST_FLAG   
,PV.VALIDATION_NUMBER              
,PV.EXCLUDE_FREIGHT_FROM_DISCOUNT  
,PV.TAX_REPORTING_NAME             
,PV.CHECK_DIGITS                   
,PV.ALLOW_AWT_FLAG                 
,PV.AWT_GROUP_ID                   
,PV.GLOBAL_ATTRIBUTE1              
,PV.GLOBAL_ATTRIBUTE2              
,PV.GLOBAL_ATTRIBUTE3              
,PV.GLOBAL_ATTRIBUTE4              
,PV.GLOBAL_ATTRIBUTE5              
,PV.GLOBAL_ATTRIBUTE6              
,PV.GLOBAL_ATTRIBUTE7              
,PV.GLOBAL_ATTRIBUTE8              
,PV.GLOBAL_ATTRIBUTE9              
,PV.GLOBAL_ATTRIBUTE10             
,PV.GLOBAL_ATTRIBUTE11             
,PV.GLOBAL_ATTRIBUTE12             
,PV.GLOBAL_ATTRIBUTE13             
,PV.GLOBAL_ATTRIBUTE14             
,PV.GLOBAL_ATTRIBUTE15             
,PV.GLOBAL_ATTRIBUTE16             
,PV.GLOBAL_ATTRIBUTE17             
,PV.GLOBAL_ATTRIBUTE18             
,PV.GLOBAL_ATTRIBUTE19             
,PV.GLOBAL_ATTRIBUTE20             
,PV.GLOBAL_ATTRIBUTE_CATEGORY      
,PV.BANK_CHARGE_BEARER             
,PV.MATCH_OPTION                   
,PV.CREATE_DEBIT_MEMO_FLAG         
,PV.PARTY_ID                       
,PV.PARENT_PARTY_ID                
,PV.NI_NUMBER                      
,PV.PARTY_NUMBER                   
,PV.PAY_AWT_GROUP_ID     
,PVSA.ADDRESS_STYLE                    SITES_ADDRESS_STYLE                 
,PVSA.LANGUAGE                         SITES_LANGUAGE                      
,PVSA.PROVINCE                         SITES_PROVINCE                      
,PVSA.COUNTRY                          SITES_COUNTRY                       
,PVSA.AREA_CODE                        SITES_AREA_CODE                     
,PVSA.PHONE                            SITES_PHONE                         
,PVSA.CUSTOMER_NUM                     SITES_CUSTOMER_NUM                  
,PVSA.SHIP_TO_LOCATION_ID              SITES_SHIP_TO_LOCATION_ID           
,PVSA.BILL_TO_LOCATION_ID              SITES_BILL_TO_LOCATION_ID           
,PVSA.SHIP_VIA_LOOKUP_CODE             SITES_SHIP_VIA_LOOKUP_CODE          
,PVSA.FREIGHT_TERMS_LOOKUP_CODE        SITES_FRET_TERM_LOOK_COD     
,PVSA.FOB_LOOKUP_CODE                  SITES_FOB_LOOKUP_CODE               
,PVSA.INACTIVE_DATE                    SITES_INACTIVE_DATE                 
,PVSA.FAX                              SITES_FAX                           
,PVSA.FAX_AREA_CODE                    SITES_FAX_AREA_CODE                 
,PVSA.TELEX                            SITES_TELEX                         
,PVSA.TERMS_DATE_BASIS                 SITES_TERMS_DATE_BASIS              
,PVSA.DISTRIBUTION_SET_ID              SITES_DISTRIBUTION_SET_ID           
,PVSA.ACCTS_PAY_CODE_COMBINATION_ID    SITES_ACCTS_PAY_CODE_COMB_ID 
,PVSA.PREPAY_CODE_COMBINATION_ID       SITES_PREPAY_CODE_COMB_ID    
,PVSA.PAY_GROUP_LOOKUP_CODE            SITES_PAY_GROUP_LOOKUP_CODE         
,PVSA.PAYMENT_PRIORITY                 SITES_PAYMENT_PRIORITY              
,PVSA.TERMS_ID                         SITES_TERMS_ID                      
,PVSA.INVOICE_AMOUNT_LIMIT             SITES_INVOICE_AMOUNT_LIMIT          
,PVSA.PAY_DATE_BASIS_LOOKUP_CODE       SITES_PAY_DATE_BASIS_LOOK_CODE    
,PVSA.ALWAYS_TAKE_DISC_FLAG            SITES_ALWAYS_TAKE_DISC_FLAG         
,PVSA.INVOICE_CURRENCY_CODE            SITES_INVOICE_CURRENCY_CODE         
,PVSA.PAYMENT_CURRENCY_CODE            SITES_PAYMENT_CURRENCY_CODE         
,PVSA.COUNTY                           SITES_COUNTY                        
,PVSA.VENDOR_SITE_ID                   SITES_VENDOR_SITE_ID                
,PVSA.LAST_UPDATE_DATE                 SITES_LAST_UPDATE_DATE              
,PVSA.LAST_UPDATED_BY                  SITES_LAST_UPDATED_BY
,(select FU.description
from apps.FND_USER FU
where PVSA.LAST_UPDATED_BY = FU.USER_ID) SITES_UPDATED_NAME               
,PVSA.VENDOR_ID                        SITES_VENDOR_ID                     
,PVSA.VENDOR_SITE_CODE                 SITES_VENDOR_SITE_CODE              
,PVSA.VENDOR_SITE_CODE_ALT             SITES_VENDOR_SITE_CODE_ALT          
,PVSA.LAST_UPDATE_LOGIN                SITES_LAST_UPDATE_LOGIN             
,PVSA.CREATION_DATE                    SITES_CREATION_DATE                 
,PVSA.CREATED_BY                       SITES_CREATED_BY
,(select FU.description
from apps.FND_USER FU
where PVSA.CREATED_BY = FU.USER_ID) SITES_CREATED_NAME                    
,PVSA.PURCHASING_SITE_FLAG             SITES_PURCHASING_SITE_FLAG          
,PVSA.RFQ_ONLY_SITE_FLAG               SITES_RFQ_ONLY_SITE_FLAG            
,PVSA.PAY_SITE_FLAG                    SITES_PAY_SITE_FLAG                 
,PVSA.ATTENTION_AR_FLAG                SITES_ATTENTION_AR_FLAG             
,PVSA.ADDRESS_LINE1                    SITES_ADDRESS_LINE1                 
,PVSA.ADDRESS_LINE2                    SITES_ADDRESS_LINE2                 
,PVSA.ADDRESS_LINE3                    SITES_ADDRESS_LINE3                 
,PVSA.ADDRESS_LINES_ALT                SITES_ADDRESS_LINES_ALT             
,PVSA.CITY                             SITES_CITY                          
,PVSA.STATE                            SITES_STATE                         
,PVSA.ZIP                              SITES_ZIP                           
,PVSA.HOLD_ALL_PAYMENTS_FLAG           SITES_HOLD_ALL_PAYMENTS_FLAG        
,PVSA.HOLD_FUTURE_PAYMENTS_FLAG        SITES_HOLD_FUTURE_PAYMEN_FLAG     
,PVSA.HOLD_REASON                      SITES_HOLD_REASON                   
,PVSA.HOLD_UNMATCHED_INVOICES_FLAG     SITES_HOLD_UNMATCH_INV_FLAG  
,PVSA.TAX_REPORTING_SITE_FLAG          SITES_TAX_REPORT_SITE_FLAG       
,PVSA.ATTRIBUTE_CATEGORY               SITES_ATTRIBUTE_CATEGORY            
,PVSA.ATTRIBUTE1                       SITES_ATTRIBUTE1                    
,PVSA.ATTRIBUTE2                       SITES_ATTRIBUTE2                    
,PVSA.ATTRIBUTE3                       SITES_ATTRIBUTE3                    
,PVSA.ATTRIBUTE4                       SITES_ATTRIBUTE4                    
,PVSA.ATTRIBUTE5                       SITES_ATTRIBUTE5                    
,PVSA.ATTRIBUTE6                       SITES_ATTRIBUTE6                    
,PVSA.ATTRIBUTE7                       SITES_ATTRIBUTE7                    
,PVSA.ATTRIBUTE8                       SITES_ATTRIBUTE8                    
,PVSA.ATTRIBUTE9                       SITES_ATTRIBUTE9                    
,PVSA.ATTRIBUTE10                      SITES_ATTRIBUTE10                   
,PVSA.ATTRIBUTE11                      SITES_ATTRIBUTE11                   
,PVSA.ATTRIBUTE12                      SITES_ATTRIBUTE12                   
,PVSA.ATTRIBUTE13                      SITES_ATTRIBUTE13                   
,PVSA.ATTRIBUTE14                      SITES_ATTRIBUTE14                   
,PVSA.ATTRIBUTE15                      SITES_ATTRIBUTE15                   
,PVSA.REQUEST_ID                       SITES_REQUEST_ID                    
,PVSA.PROGRAM_APPLICATION_ID           SITES_PROGRAM_APPLICATION_ID        
,PVSA.PROGRAM_ID                       SITES_PROGRAM_ID                    
,PVSA.PROGRAM_UPDATE_DATE              SITES_PROGRAM_UPDATE_DATE           
,PVSA.VALIDATION_NUMBER                SITES_VALIDATION_NUMBER             
,PVSA.EXCLUDE_FREIGHT_FROM_DISCOUNT    SITES_EXCL_FREIGHT_DISCOUNT 
,PVSA.BANK_CHARGE_BEARER               SITES_BANK_CHARGE_BEARER            
,PVSA.ORG_ID                           SITES_ORG_ID                        
,PVSA.CHECK_DIGITS                     SITES_CHECK_DIGITS                  
,PVSA.ADDRESS_LINE4                    SITES_ADDRESS_LINE4                 
,PVSA.ALLOW_AWT_FLAG                   SITES_ALLOW_AWT_FLAG                
,PVSA.AWT_GROUP_ID                     SITES_AWT_GROUP_ID                  
,PVSA.PAY_AWT_GROUP_ID                 SITES_PAY_AWT_GROUP_ID              
,PVSA.DEFAULT_PAY_SITE_ID              SITES_DEFAULT_PAY_SITE_ID           
,PVSA.PAY_ON_CODE                      SITES_PAY_ON_CODE                   
,PVSA.PAY_ON_RECEIPT_SUMMARY_CODE      SITES_PAY_ON_RET_SUM_CODE   
,PVSA.GLOBAL_ATTRIBUTE_CATEGORY        SITES_GLOBAL_ATTRIBUTE_CAT     
,PVSA.GLOBAL_ATTRIBUTE1                SITES_GLOBAL_ATTRIBUTE1             
,PVSA.GLOBAL_ATTRIBUTE2                SITES_GLOBAL_ATTRIBUTE2             
,PVSA.GLOBAL_ATTRIBUTE3                SITES_GLOBAL_ATTRIBUTE3             
,PVSA.GLOBAL_ATTRIBUTE4                SITES_GLOBAL_ATTRIBUTE4             
,PVSA.GLOBAL_ATTRIBUTE5                SITES_GLOBAL_ATTRIBUTE5             
,PVSA.GLOBAL_ATTRIBUTE6                SITES_GLOBAL_ATTRIBUTE6             
,PVSA.GLOBAL_ATTRIBUTE7                SITES_GLOBAL_ATTRIBUTE7             
,PVSA.GLOBAL_ATTRIBUTE8                SITES_GLOBAL_ATTRIBUTE8             
,PVSA.GLOBAL_ATTRIBUTE9                SITES_GLOBAL_ATTRIBUTE9             
,PVSA.GLOBAL_ATTRIBUTE10               SITES_GLOBAL_ATTRIBUTE10            
,PVSA.GLOBAL_ATTRIBUTE11               SITES_GLOBAL_ATTRIBUTE11            
,PVSA.GLOBAL_ATTRIBUTE12               SITES_GLOBAL_ATTRIBUTE12            
,PVSA.GLOBAL_ATTRIBUTE13               SITES_GLOBAL_ATTRIBUTE13            
,PVSA.GLOBAL_ATTRIBUTE14               SITES_GLOBAL_ATTRIBUTE14            
,PVSA.GLOBAL_ATTRIBUTE15               SITES_GLOBAL_ATTRIBUTE15            
,PVSA.GLOBAL_ATTRIBUTE16               SITES_GLOBAL_ATTRIBUTE16            
,PVSA.GLOBAL_ATTRIBUTE17               SITES_GLOBAL_ATTRIBUTE17            
,PVSA.GLOBAL_ATTRIBUTE18               SITES_GLOBAL_ATTRIBUTE18            
,PVSA.GLOBAL_ATTRIBUTE19               SITES_GLOBAL_ATTRIBUTE19            
,PVSA.GLOBAL_ATTRIBUTE20               SITES_GLOBAL_ATTRIBUTE20            
,PVSA.TP_HEADER_ID                     SITES_TP_HEADER_ID                  
,PVSA.ECE_TP_LOCATION_CODE             SITES_ECE_TP_LOCATION_CODE          
,PVSA.PCARD_SITE_FLAG                  SITES_PCARD_SITE_FLAG               
,PVSA.MATCH_OPTION                     SITES_MATCH_OPTION                  
,PVSA.COUNTRY_OF_ORIGIN_CODE           SITES_COUNTRY_OF_ORIGIN_CODE        
,PVSA.FUTURE_DATED_PAYMENT_CCID        SITES_FUTURE_DATE_PAY_CCID     
,PVSA.CREATE_DEBIT_MEMO_FLAG           SITES_CREATE_DEBIT_MEMO_FLAG        
,PVSA.SUPPLIER_NOTIF_METHOD            SITES_SUPPLIER_NOTIF_METHOD         
,PVSA.EMAIL_ADDRESS                    SITES_EMAIL_ADDRESS                 
,PVSA.PRIMARY_PAY_SITE_FLAG            SITES_PRIMARY_PAY_SITE_FLAG         
,PVSA.SHIPPING_CONTROL                 SITES_SHIPPING_CONTROL              
,PVSA.SELLING_COMPANY_IDENTIFIER       SITES_SELLING_COMPANY_IDENT   
,PVSA.GAPLESS_INV_NUM_FLAG             SITES_GAPLESS_INV_NUM_FLAG          
,PVSA.DUNS_NUMBER                      SITES_DUNS_NUMBER                   
,PVSA.LOCATION_ID                      SITES_LOCATION_ID                   
,PVSA.PARTY_SITE_ID                    SITES_PARTY_SITE_ID                 
,PVSA.TOLERANCE_ID                     SITES_TOLERANCE_ID                  
,PVSA.SERVICES_TOLERANCE_ID            SITES_SERVICES_TOLERANCE_ID         
,PVSA.RETAINAGE_RATE                   SITES_RETAINAGE_RATE                
,PVSA.EDI_ID_NUMBER                    SITES_EDI_ID_NUMBER                 
,PVSA.VAT_REGISTRATION_NUM             SITES_VAT_REGISTRATION_NUM          
,PVSA.LANGUAGE_CODE                    SITES_LANGUAGE_CODE                 
,PVSA.PAYMENT_METHOD_LOOKUP_CODE       SITES_PAY_METHOD_LOOK_CODE    
,PVSA.BANK_ACCOUNT_NAME                SITES_BANK_ACCOUNT_NAME             
,PVSA.BANK_ACCOUNT_NUM                 SITES_BANK_ACCOUNT_NUM              
,PVSA.BANK_NUM                         SITES_BANK_NUM                      
,PVSA.BANK_ACCOUNT_TYPE                SITES_BANK_ACCOUNT_TYPE             
,PVSA.CURRENT_CATALOG_NUM              SITES_CURRENT_CATALOG_NUM           
,PVSA.VAT_CODE                         SITES_VAT_CODE                      
,PVSA.AP_TAX_ROUNDING_RULE             SITES_AP_TAX_ROUNDING_RULE          
,PVSA.AUTO_TAX_CALC_FLAG               SITES_AUTO_TAX_CALC_FLAG            
,PVSA.AUTO_TAX_CALC_OVERRIDE           SITES_AUTO_TAX_CALC_OVERRIDE        
,PVSA.AMOUNT_INCLUDES_TAX_FLAG         SITES_AMOUNT_INCLUD_TAX_FLAG      
,PVSA.OFFSET_VAT_CODE                  SITES_OFFSET_VAT_CODE               
,PVSA.BANK_NUMBER                      SITES_BANK_NUMBER                   
,PVSA.BANK_BRANCH_TYPE                 SITES_BANK_BRANCH_TYPE              
,PVSA.OFFSET_TAX_FLAG                  SITES_OFFSET_TAX_FLAG               
,PVSA.REMITTANCE_EMAIL                 SITES_REMITTANCE_EMAIL              
,PVSA.EDI_TRANSACTION_HANDLING         SITES_EDI_TRANSACTION_HANDLING      
,PVSA.EDI_PAYMENT_METHOD               SITES_EDI_PAYMENT_METHOD            
,PVSA.EDI_PAYMENT_FORMAT               SITES_EDI_PAYMENT_FORMAT            
,PVSA.EDI_REMITTANCE_METHOD            SITES_EDI_REMIT_METHOD         
,PVSA.EDI_REMITTANCE_INSTRUCTION       SITES_EDI_REMIT_INSTRUCTION   
,PVSA.EXCLUSIVE_PAYMENT_FLAG           SITES_EXCLUSIVE_PAY_FLAG        
,PVSA.CAGE_CODE                        SITES_CAGE_CODE                     
,PVSA.LEGAL_BUSINESS_NAME              SITES_LEGAL_BUSINESS_NAME           
,PVSA.DOING_BUS_AS_NAME                SITES_DOING_BUS_AS_NAME             
,PVSA.DIVISION_NAME                    SITES_DIVISION_NAME                 
,PVSA.SMALL_BUSINESS_CODE              SITES_SMALL_BUSINESS_CODE           
,PVSA.CCR_COMMENTS                     SITES_CCR_COMMENTS                  
,PVSA.DEBARMENT_START_DATE             SITES_DEBARMENT_START_DATE          
,PVSA.DEBARMENT_END_DATE               SITES_DEBARMENT_END_DATE            
FROM PO_VENDORS PV
    ,PO_VENDOR_SITES_ALL PVSA
WHERE PV.VENDOR_ID = PVSA.VENDOR_ID	