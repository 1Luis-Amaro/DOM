SELECT RCTA.CUSTOMER_TRX_ID                
      ,RCTA.LAST_UPDATE_DATE               
      ,RCTA.LAST_UPDATED_BY                
      ,TRUNC(RCTA.CREATION_DATE) CREATION_DATE                   
      ,RCTA.CREATED_BY                     
      ,RCTA.LAST_UPDATE_LOGIN              
      ,RCTA.TRX_NUMBER                     
      ,RCTA.CUST_TRX_TYPE_ID               
      ,RCTA.TRX_DATE                       
      ,RCTA.SET_OF_BOOKS_ID                
      ,RCTA.BILL_TO_CONTACT_ID             
      ,RCTA.BATCH_ID                       
       ,RCTA.BATCH_SOURCE_ID                
       ,RCTA.REASON_CODE                    
       ,RCTA.SOLD_TO_CUSTOMER_ID            
       ,RCTA.SOLD_TO_CONTACT_ID             
       ,RCTA.SOLD_TO_SITE_USE_ID            
       ,RCTA.BILL_TO_CUSTOMER_ID            
       ,RCTA.BILL_TO_SITE_USE_ID            
       ,RCTA.SHIP_TO_CUSTOMER_ID            
       ,RCTA.SHIP_TO_CONTACT_ID             
       ,RCTA.SHIP_TO_SITE_USE_ID            
       ,RCTA.SHIPMENT_ID                    
       ,RCTA.REMIT_TO_ADDRESS_ID            
       ,RCTA.TERM_ID                        
       ,RCTA.TERM_DUE_DATE                  
       ,RCTA.PREVIOUS_CUSTOMER_TRX_ID       
       ,RCTA.PRIMARY_SALESREP_ID            
       ,RCTA.PRINTING_ORIGINAL_DATE         
       ,RCTA.PRINTING_LAST_PRINTED          
       ,RCTA.PRINTING_OPTION                
       ,RCTA.PRINTING_COUNT                 
       ,RCTA.PRINTING_PENDING               
       ,RCTA.PURCHASE_ORDER                 
       ,RCTA.PURCHASE_ORDER_REVISION        
       ,RCTA.PURCHASE_ORDER_DATE            
       ,RCTA.CUSTOMER_REFERENCE             
       ,RCTA.CUSTOMER_REFERENCE_DATE        
       ,RCTA.COMMENTS                       
       ,RCTA.INTERNAL_NOTES                 
       ,RCTA.EXCHANGE_RATE_TYPE             
       ,RCTA.EXCHANGE_DATE                  
       ,RCTA.EXCHANGE_RATE                  
       ,RCTA.TERRITORY_ID                   
       ,RCTA.INVOICE_CURRENCY_CODE          
       ,RCTA.INITIAL_CUSTOMER_TRX_ID        
       ,RCTA.AGREEMENT_ID                   
       ,RCTA.END_DATE_COMMITMENT            
       ,RCTA.START_DATE_COMMITMENT          
       ,RCTA.LAST_PRINTED_SEQUENCE_NUM      
       ,RCTA.ATTRIBUTE_CATEGORY             
       ,RCTA.ATTRIBUTE1                     
       ,RCTA.ATTRIBUTE2                     
       ,RCTA.ATTRIBUTE3                     
       ,RCTA.ATTRIBUTE4                     
       ,RCTA.ATTRIBUTE5                     
       ,RCTA.ATTRIBUTE6                     
       ,RCTA.ATTRIBUTE7                     
       ,RCTA.ATTRIBUTE8                     
       ,RCTA.ATTRIBUTE9                     
       ,RCTA.ATTRIBUTE10                    
       ,RCTA.ORIG_SYSTEM_BATCH_NAME         
       ,RCTA.POST_REQUEST_ID                
       ,RCTA.REQUEST_ID                     
       ,RCTA.PROGRAM_APPLICATION_ID         
       ,RCTA.PROGRAM_ID                     
       ,RCTA.PROGRAM_UPDATE_DATE            
       ,RCTA.FINANCE_CHARGES                
       ,RCTA.COMPLETE_FLAG                  
       ,RCTA.POSTING_CONTROL_ID             
       ,RCTA.BILL_TO_ADDRESS_ID             
       ,RCTA.RA_POST_LOOP_NUMBER            
       ,RCTA.SHIP_TO_ADDRESS_ID             
       ,RCTA.CREDIT_METHOD_FOR_RULES        
       ,RCTA.CREDIT_METHOD_FOR_INSTALLMENTS 
       ,RCTA.RECEIPT_METHOD_ID              
       ,RCTA.ATTRIBUTE11                    
       ,RCTA.ATTRIBUTE12                    
       ,RCTA.ATTRIBUTE13                    
       ,RCTA.ATTRIBUTE14                    
       ,RCTA.ATTRIBUTE15                    
       ,RCTA.RELATED_CUSTOMER_TRX_ID        
       ,RCTA.INVOICING_RULE_ID              
       ,RCTA.SHIP_VIA                       
       ,RCTA.SHIP_DATE_ACTUAL               
       ,RCTA.WAYBILL_NUMBER                 
       ,RCTA.FOB_POINT                      
       ,RCTA.CUSTOMER_BANK_ACCOUNT_ID       
       ,RCTA.INTERFACE_HEADER_ATTRIBUTE1    
       ,RCTA.INTERFACE_HEADER_ATTRIBUTE2    
       ,RCTA.INTERFACE_HEADER_ATTRIBUTE3    
       ,RCTA.INTERFACE_HEADER_ATTRIBUTE4    
       ,RCTA.INTERFACE_HEADER_ATTRIBUTE5    
       ,RCTA.INTERFACE_HEADER_ATTRIBUTE6    
       ,RCTA.INTERFACE_HEADER_ATTRIBUTE7    
       ,RCTA.INTERFACE_HEADER_ATTRIBUTE8    
       ,RCTA.INTERFACE_HEADER_CONTEXT       
       ,RCTA.DEFAULT_USSGL_TRX_CODE_CONTEXT 
       ,RCTA.INTERFACE_HEADER_ATTRIBUTE10   
       ,RCTA.INTERFACE_HEADER_ATTRIBUTE11   
       ,RCTA.INTERFACE_HEADER_ATTRIBUTE12   
       ,RCTA.INTERFACE_HEADER_ATTRIBUTE13   
       ,RCTA.INTERFACE_HEADER_ATTRIBUTE14   
       ,RCTA.INTERFACE_HEADER_ATTRIBUTE15   
       ,RCTA.INTERFACE_HEADER_ATTRIBUTE9    
       ,RCTA.DEFAULT_USSGL_TRANSACTION_CODE 
       ,RCTA.RECURRED_FROM_TRX_NUMBER       
       ,RCTA.STATUS_TRX                     
       ,RCTA.DOC_SEQUENCE_ID                
       ,RCTA.DOC_SEQUENCE_VALUE             
       ,RCTA.PAYING_CUSTOMER_ID             
       ,RCTA.PAYING_SITE_USE_ID             
       ,RCTA.RELATED_BATCH_SOURCE_ID        
       ,RCTA.DEFAULT_TAX_EXEMPT_FLAG        
       ,RCTA.CREATED_FROM                   
       ,RCTA.ORG_ID                         
       ,RCTA.WH_UPDATE_DATE                 
       ,RCTA.GLOBAL_ATTRIBUTE1              
       ,RCTA.GLOBAL_ATTRIBUTE2              
       ,RCTA.GLOBAL_ATTRIBUTE3              
       ,RCTA.GLOBAL_ATTRIBUTE4              
       ,RCTA.GLOBAL_ATTRIBUTE5              
       ,RCTA.GLOBAL_ATTRIBUTE6              
       ,RCTA.GLOBAL_ATTRIBUTE7              
       ,RCTA.GLOBAL_ATTRIBUTE8              
       ,RCTA.GLOBAL_ATTRIBUTE9              
       ,RCTA.GLOBAL_ATTRIBUTE10             
       ,RCTA.GLOBAL_ATTRIBUTE11             
       ,RCTA.GLOBAL_ATTRIBUTE12             
       ,RCTA.GLOBAL_ATTRIBUTE13             
       ,RCTA.GLOBAL_ATTRIBUTE14             
       ,RCTA.GLOBAL_ATTRIBUTE15             
       ,RCTA.GLOBAL_ATTRIBUTE16             
       ,RCTA.GLOBAL_ATTRIBUTE17             
       ,RCTA.GLOBAL_ATTRIBUTE18             
       ,RCTA.GLOBAL_ATTRIBUTE19             
       ,RCTA.GLOBAL_ATTRIBUTE20             
       ,RCTA.GLOBAL_ATTRIBUTE21             
       ,RCTA.GLOBAL_ATTRIBUTE22             
       ,RCTA.GLOBAL_ATTRIBUTE23             
       ,RCTA.GLOBAL_ATTRIBUTE24             
       ,RCTA.GLOBAL_ATTRIBUTE25             
       ,RCTA.GLOBAL_ATTRIBUTE26             
       ,RCTA.GLOBAL_ATTRIBUTE27             
       ,RCTA.GLOBAL_ATTRIBUTE28             
       ,RCTA.GLOBAL_ATTRIBUTE29             
       ,RCTA.GLOBAL_ATTRIBUTE30             
       ,RCTA.GLOBAL_ATTRIBUTE_CATEGORY      
       ,RCTA.EDI_PROCESSED_FLAG             
       ,RCTA.EDI_PROCESSED_STATUS           
       ,RCTA.MRC_EXCHANGE_RATE_TYPE         
       ,RCTA.MRC_EXCHANGE_DATE              
       ,RCTA.MRC_EXCHANGE_RATE              
       ,RCTA.PAYMENT_SERVER_ORDER_NUM       
       ,RCTA.APPROVAL_CODE                  
       ,RCTA.ADDRESS_VERIFICATION_CODE      
       ,RCTA.OLD_TRX_NUMBER                 
       ,RCTA.BR_AMOUNT                      
       ,RCTA.BR_UNPAID_FLAG                 
       ,RCTA.BR_ON_HOLD_FLAG                
       ,RCTA.DRAWEE_ID                      
       ,RCTA.DRAWEE_CONTACT_ID              
       ,RCTA.DRAWEE_SITE_USE_ID             
       ,RCTA.REMITTANCE_BANK_ACCOUNT_ID     
       ,RCTA.OVERRIDE_REMIT_ACCOUNT_FLAG    
       ,RCTA.DRAWEE_BANK_ACCOUNT_ID         
       ,RCTA.SPECIAL_INSTRUCTIONS           
       ,RCTA.REMITTANCE_BATCH_ID            
       ,RCTA.PREPAYMENT_FLAG                
       ,RCTA.CT_REFERENCE                   
       ,RCTA.CONTRACT_ID                    
       ,RCTA.BILL_TEMPLATE_ID               
       ,RCTA.REVERSED_CASH_RECEIPT_ID       
       ,RCTA.CC_ERROR_CODE                  
       ,RCTA.CC_ERROR_TEXT                  
       ,RCTA.CC_ERROR_FLAG                  
       ,RCTA.UPGRADE_METHOD                 
       ,RCTA.LEGAL_ENTITY_ID                
       ,RCTA.REMIT_BANK_ACCT_USE_ID         
       ,RCTA.PAYMENT_TRXN_EXTENSION_ID      
       ,RCTA.AX_ACCOUNTED_FLAG              
       ,RCTA.APPLICATION_ID                 
       ,RCTA.PAYMENT_ATTRIBUTES             
       ,RCTA.BILLING_DATE                   
       ,RCTA.INTEREST_HEADER_ID             
       ,RCTA.LATE_CHARGES_ASSESSED          
       ,RCTA.TRAILER_NUMBER             
       ,RCTLA.CUSTOMER_TRX_LINE_ID                                            
       ,RCTLA.LINE_NUMBER                                                                   
       ,RCTLA.INVENTORY_ITEM_ID              
       ,RCTLA.DESCRIPTION                        
       ,RCTLA.PREVIOUS_CUSTOMER_TRX_LINE_ID  
       ,RCTLA.QUANTITY_ORDERED               
       ,RCTLA.QUANTITY_CREDITED              
       ,RCTLA.QUANTITY_INVOICED              
       ,RCTLA.UNIT_STANDARD_PRICE            
       ,RCTLA.UNIT_SELLING_PRICE             
       ,RCTLA.SALES_ORDER                    
       ,RCTLA.SALES_ORDER_REVISION           
       ,RCTLA.SALES_ORDER_LINE               
       ,RCTLA.SALES_ORDER_DATE               
       ,RCTLA.ACCOUNTING_RULE_ID             
       ,RCTLA.ACCOUNTING_RULE_DURATION       
       ,RCTLA.LINE_TYPE                                  
       ,RCTLA.ATTRIBUTE1    RCTLA_ATTRIBUTE1                  
       ,RCTLA.ATTRIBUTE2    RCTLA_ATTRIBUTE2                  
       ,RCTLA.ATTRIBUTE3    RCTLA_ATTRIBUTE3                  
       ,RCTLA.ATTRIBUTE4    RCTLA_ATTRIBUTE4                  
       ,RCTLA.ATTRIBUTE5    RCTLA_ATTRIBUTE5                  
       ,RCTLA.ATTRIBUTE6    RCTLA_ATTRIBUTE6                  
       ,RCTLA.ATTRIBUTE7    RCTLA_ATTRIBUTE7                  
       ,RCTLA.ATTRIBUTE8    RCTLA_ATTRIBUTE8                  
       ,RCTLA.ATTRIBUTE9    RCTLA_ATTRIBUTE9                  
       ,RCTLA.ATTRIBUTE10   RCTLA_ATTRIBUTE10                                                         
       ,RCTLA.RULE_START_DATE                
       ,RCTLA.INITIAL_CUSTOMER_TRX_LINE_ID   
       ,RCTLA.INTERFACE_LINE_CONTEXT         
       ,RCTLA.INTERFACE_LINE_ATTRIBUTE1      
       ,RCTLA.INTERFACE_LINE_ATTRIBUTE2      
       ,RCTLA.INTERFACE_LINE_ATTRIBUTE3      
       ,RCTLA.INTERFACE_LINE_ATTRIBUTE4      
       ,RCTLA.INTERFACE_LINE_ATTRIBUTE5      
       ,RCTLA.INTERFACE_LINE_ATTRIBUTE6      
       ,RCTLA.INTERFACE_LINE_ATTRIBUTE7      
       ,RCTLA.INTERFACE_LINE_ATTRIBUTE8      
       ,RCTLA.SALES_ORDER_SOURCE             
       ,RCTLA.TAXABLE_FLAG                   
       ,RCTLA.EXTENDED_AMOUNT                
       ,RCTLA.REVENUE_AMOUNT                 
       ,RCTLA.AUTORULE_COMPLETE_FLAG         
       ,RCTLA.LINK_TO_CUST_TRX_LINE_ID       
       ,RCTLA.ATTRIBUTE11    RCTLA_ATTRIBUTE11                
       ,RCTLA.ATTRIBUTE12    RCTLA_ATTRIBUTE12                
       ,RCTLA.ATTRIBUTE13    RCTLA_ATTRIBUTE13                
       ,RCTLA.ATTRIBUTE14    RCTLA_ATTRIBUTE14                
       ,RCTLA.ATTRIBUTE15    RCTLA_ATTRIBUTE15                
       ,RCTLA.TAX_PRECEDENCE                 
       ,RCTLA.TAX_RATE                       
       ,RCTLA.ITEM_EXCEPTION_RATE_ID         
       ,RCTLA.TAX_EXEMPTION_ID               
       ,RCTLA.MEMO_LINE_ID                   
       ,RCTLA.AUTORULE_DURATION_PROCESSED    
       ,RCTLA.UOM_CODE                              
       ,RCTLA.INTERFACE_LINE_ATTRIBUTE10     
       ,RCTLA.INTERFACE_LINE_ATTRIBUTE11     
       ,RCTLA.INTERFACE_LINE_ATTRIBUTE12     
       ,RCTLA.INTERFACE_LINE_ATTRIBUTE13     
       ,RCTLA.INTERFACE_LINE_ATTRIBUTE14     
       ,RCTLA.INTERFACE_LINE_ATTRIBUTE15     
       ,RCTLA.INTERFACE_LINE_ATTRIBUTE9      
       ,RCTLA.VAT_TAX_ID                     
       ,RCTLA.AUTOTAX                        
       ,RCTLA.LAST_PERIOD_TO_CREDIT          
       ,RCTLA.ITEM_CONTEXT                   
       ,RCTLA.TAX_EXEMPT_FLAG                
       ,RCTLA.TAX_EXEMPT_NUMBER              
       ,RCTLA.TAX_EXEMPT_REASON_CODE         
       ,RCTLA.TAX_VENDOR_RETURN_CODE         
       ,RCTLA.SALES_TAX_ID                   
       ,RCTLA.LOCATION_SEGMENT_ID            
       ,RCTLA.MOVEMENT_ID                                                                    
       ,RCTLA.GLOBAL_ATTRIBUTE1  RCTLA_GLOBAL_ATTRIBUTE1             
       ,RCTLA.GLOBAL_ATTRIBUTE2  RCTLA_GLOBAL_ATTRIBUTE2             
       ,RCTLA.GLOBAL_ATTRIBUTE3  RCTLA_GLOBAL_ATTRIBUTE3             
       ,RCTLA.GLOBAL_ATTRIBUTE4  RCTLA_GLOBAL_ATTRIBUTE4             
       ,RCTLA.GLOBAL_ATTRIBUTE5  RCTLA_GLOBAL_ATTRIBUTE5             
       ,RCTLA.GLOBAL_ATTRIBUTE6  RCTLA_GLOBAL_ATTRIBUTE6             
       ,RCTLA.GLOBAL_ATTRIBUTE7  RCTLA_GLOBAL_ATTRIBUTE7             
       ,RCTLA.GLOBAL_ATTRIBUTE8  RCTLA_GLOBAL_ATTRIBUTE8             
       ,RCTLA.GLOBAL_ATTRIBUTE9  RCTLA_GLOBAL_ATTRIBUTE9             
       ,RCTLA.GLOBAL_ATTRIBUTE10 RCTLA_GLOBAL_ATTRIBUTE10            
       ,RCTLA.GLOBAL_ATTRIBUTE11 RCTLA_GLOBAL_ATTRIBUTE11            
       ,RCTLA.GLOBAL_ATTRIBUTE12 RCTLA_GLOBAL_ATTRIBUTE12            
       ,RCTLA.GLOBAL_ATTRIBUTE13 RCTLA_GLOBAL_ATTRIBUTE13            
       ,RCTLA.GLOBAL_ATTRIBUTE14 RCTLA_GLOBAL_ATTRIBUTE14            
       ,RCTLA.GLOBAL_ATTRIBUTE15 RCTLA_GLOBAL_ATTRIBUTE15            
       ,RCTLA.GLOBAL_ATTRIBUTE16 RCTLA_GLOBAL_ATTRIBUTE16            
       ,RCTLA.GLOBAL_ATTRIBUTE17 RCTLA_GLOBAL_ATTRIBUTE17            
       ,RCTLA.GLOBAL_ATTRIBUTE18 RCTLA_GLOBAL_ATTRIBUTE18            
       ,RCTLA.GLOBAL_ATTRIBUTE19 RCTLA_GLOBAL_ATTRIBUTE19            
       ,RCTLA.GLOBAL_ATTRIBUTE20 RCTLA_GLOBAL_ATTRIBUTE20            
       ,RCTLA.GROSS_UNIT_SELLING_PRICE       
       ,RCTLA.GROSS_EXTENDED_AMOUNT          
       ,RCTLA.AMOUNT_INCLUDES_TAX_FLAG       
       ,RCTLA.TAXABLE_AMOUNT                 
       ,RCTLA.WAREHOUSE_ID                   
       ,RCTLA.TRANSLATED_DESCRIPTION         
       ,RCTLA.EXTENDED_ACCTD_AMOUNT          
       ,RCTLA.BR_REF_CUSTOMER_TRX_ID         
       ,RCTLA.BR_REF_PAYMENT_SCHEDULE_ID     
       ,RCTLA.BR_ADJUSTMENT_ID               
       ,RCTLA.MRC_EXTENDED_ACCTD_AMOUNT      
       ,RCTLA.PAYMENT_SET_ID                 
       ,RCTLA.CONTRACT_LINE_ID               
       ,RCTLA.SOURCE_DATA_KEY1               
       ,RCTLA.SOURCE_DATA_KEY2               
       ,RCTLA.SOURCE_DATA_KEY3               
       ,RCTLA.SOURCE_DATA_KEY4               
       ,RCTLA.SOURCE_DATA_KEY5               
       ,RCTLA.INVOICED_LINE_ACCTG_LEVEL      
       ,RCTLA.OVERRIDE_AUTO_ACCOUNTING_FLAG                                               
       ,RCTLA.HISTORICAL_FLAG                
       ,RCTLA.TAX_LINE_ID                    
       ,RCTLA.LINE_RECOVERABLE               
       ,RCTLA.TAX_RECOVERABLE                
       ,RCTLA.TAX_CLASSIFICATION_CODE        
       ,RCTLA.AMOUNT_DUE_REMAINING           
       ,RCTLA.ACCTD_AMOUNT_DUE_REMAINING     
       ,RCTLA.AMOUNT_DUE_ORIGINAL            
       ,RCTLA.ACCTD_AMOUNT_DUE_ORIGINAL      
       ,RCTLA.CHRG_AMOUNT_REMAINING          
       ,RCTLA.CHRG_ACCTD_AMOUNT_REMAINING    
       ,RCTLA.FRT_ADJ_REMAINING              
       ,RCTLA.FRT_ADJ_ACCTD_REMAINING        
       ,RCTLA.FRT_ED_AMOUNT                  
       ,RCTLA.FRT_ED_ACCTD_AMOUNT            
       ,RCTLA.FRT_UNED_AMOUNT                
       ,RCTLA.FRT_UNED_ACCTD_AMOUNT          
       ,RCTLA.DEFERRAL_EXCLUSION_FLAG        
       ,RCTLA.RULE_END_DATE                               
       ,RCTLA.INTEREST_LINE_ID               
       ,(SELECT NVL(ZLV.TAX_AMT,0)
           FROM ZX_LINES_V ZLV
          WHERE TRX_LINE_ID = RCTLA.CUSTOMER_TRX_LINE_ID
            AND TRX_ID = RCTLA.CUSTOMER_TRX_ID
            AND UPPER(TAX_RATE_CODE)  LIKE '%ICMS%C%'
            AND ROWNUM = 1) VR_ICMS
       ,(SELECT NVL(ZLV.TAX_AMT,0)
           FROM ZX_LINES_V ZLV
          WHERE TRX_LINE_ID = RCTLA.CUSTOMER_TRX_LINE_ID
            AND TRX_ID = RCTLA.CUSTOMER_TRX_ID
            AND UPPER(TAX_RATE_CODE)  LIKE '%PIS%C%'
            AND ROWNUM = 1) VR_PIS
       ,(SELECT NVL(ZLV.TAX_AMT,0)
           FROM ZX_LINES_V ZLV
          WHERE TRX_LINE_ID = RCTLA.CUSTOMER_TRX_LINE_ID
            AND TRX_ID = RCTLA.CUSTOMER_TRX_ID
            AND UPPER(TAX_RATE_CODE)  LIKE '%COFINS%C%' 
            AND ROWNUM = 1) VR_COFINS
       ,ACUS.CUSTOMER_NAME CLIENTE       
       ,MSIB.ORGANIZATION_ID 
       ,MSIB.SEGMENT1 ITEM         
     FROM RA_CUSTOMER_TRX_ALL       RCTA,
          MTL_SYSTEM_ITEMS_B        MSIB,
          AR_CUSTOMERS              ACUS,
          RA_CUSTOMER_TRX_LINES_ALL RCTLA,
          AR_PAYMENT_SCHEDULES_ALL  APSA,
          RA_CUST_TRX_TYPES_ALL     RCTTA,
          HZ_CUST_ACCT_SITES_ALL      HCASA          
    WHERE RCTLA.SHIP_TO_CUSTOMER_ID = ACUS.CUSTOMER_ID(+)
      AND HCASA.CUST_ACCOUNT_ID = ACUS.CUSTOMER_ID
      AND RCTLA.INVENTORY_ITEM_ID = MSIB.INVENTORY_ITEM_ID
      AND RCTLA.CUSTOMER_TRX_ID = RCTA.CUSTOMER_TRX_ID
      AND APSA.CUSTOMER_TRX_ID(+) = RCTA.CUSTOMER_TRX_ID
      AND RCTA.CUST_TRX_TYPE_ID = RCTTA.CUST_TRX_TYPE_ID