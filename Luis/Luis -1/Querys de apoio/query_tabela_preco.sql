SELECT   QPLH.LIMIT_EXISTS_FLAG    
        ,QPLH.MOBILE_DOWNLOAD      
        ,QPLH.CURRENCY_HEADER_ID   
        ,QPLH.ATTRIBUTE1  
        ,QPLH.ATTRIBUTE2  
        ,QPLH.ATTRIBUTE3  
        ,QPLH.ATTRIBUTE4  
        ,QPLH.ATTRIBUTE5  
        ,QPLH.ATTRIBUTE6  
        ,QPLH.ATTRIBUTE7  
        ,QPLH.ATTRIBUTE8  
        ,QPLH.ATTRIBUTE9  
        ,QPLH.ATTRIBUTE10 
        ,QPLH.ATTRIBUTE11 
        ,QPLH.ATTRIBUTE12 
        ,QPLH.ATTRIBUTE13 
        ,QPLH.ATTRIBUTE14 
        ,QPLH.ATTRIBUTE15 
       ,QPLH.SHIP_METHOD_CODE 
       ,QPLH.TERMS_ID 
       ,QPLH.LIST_SOURCE_CODE 
       ,QPTL.NAME
       ,QPLH.LIST_HEADER_ID
       ,QPLH.LIST_TYPE_CODE
       ,QPLH.CURRENCY_CODE
       ,QPLH.ACTIVE_FLAG
       ,TRUNC(QPLH.START_DATE_ACTIVE) START_DATE_ACTIVE
       ,TRUNC(QPLH.END_DATE_ACTIVE) END_DATE_ACTIVE
       ,INV.ORGANIZATION_ID
       ,INV.SEGMENT1
       ,INV.DESCRIPTION
       ,QLL.LIST_LINE_ID
       ,QLL.PRODUCT_ATTRIBUTE_CONTEXT
       ,QLL.PRODUCT_ATTR_VALUE
       ,QLL.PRODUCT_ID
       ,QLL.PRODUCT_ATTR_VAL_DISP
       ,QLL.PRODUCT_UOM_CODE       
       ,QLL.LIST_LINE_TYPE_CODE
       ,QLL.AUTOMATIC_FLAG
       ,QLL.ARITHMETIC_OPERATOR
       ,QLL.OPERAND
       ,QLL.PRODUCT_PRECEDENCE     
       ,QLL.MODIFIER_LEVEL_CODE          
       ,QLL.PRICE_BY_FORMULA_ID          
       ,QLL.LIST_PRICE                   
       ,QLL.LIST_PRICE_UOM_CODE          
       ,QLL.PRIMARY_UOM_FLAG             
       ,QLL.INVENTORY_ITEM_ID                                
       ,QLL.RELATED_ITEM_ID              
       ,QLL.RELATIONSHIP_TYPE_ID         
       ,QLL.SUBSTITUTION_CONTEXT         
       ,QLL.SUBSTITUTION_ATTRIBUTE       
       ,QLL.SUBSTITUTION_VALUE           
       ,QLL.REVISION                     
       ,TRUNC(QLL.REVISION_DATE) REVISION_DATE                 
       ,QLL.REVISION_REASON_CODE         
       ,QLL.PRICE_BREAK_TYPE_CODE        
       ,QLL.PERCENT_PRICE                
       ,QLL.NUMBER_EFFECTIVE_PERIODS     
       ,QLL.EFFECTIVE_PERIOD_UOM         
       ,QLL.OVERRIDE_FLAG                
       ,QLL.PRINT_ON_INVOICE_FLAG        
       ,QLL.REBATE_TRANSACTION_TYPE_CODE 
       ,QLL.BASE_QTY                     
       ,QLL.BASE_UOM_CODE                
       ,QLL.ACCRUAL_QTY                  
       ,QLL.ACCRUAL_UOM_CODE             
       ,QLL.ESTIM_ACCRUAL_RATE           
       ,QLL.COMMENTS                     
       ,QLLI.GENERATE_USING_FORMULA_ID    
       ,QLLI.REPRICE_FLAG                 
       ,QLLI.LIST_LINE_NO                 
       ,QLLI.ESTIM_GL_VALUE               
       ,QLLI.BENEFIT_PRICE_LIST_LINE_ID   
       ,QLLI.EXPIRATION_PERIOD_START_DATE 
       ,QLLI.NUMBER_EXPIRATION_PERIODS    
       ,QLLI.EXPIRATION_PERIOD_UOM        
       ,QLLI.EXPIRATION_DATE              
       ,QLL.ACCRUAL_FLAG                 
       ,QLL.PRICING_PHASE_ID             
       ,QLLI.PRICING_GROUP_SEQUENCE       
       ,QLLI.INCOMPATIBILITY_GRP_CODE     
       ,QLLI.PRORATION_TYPE_CODE          
       ,QLLI.ACCRUAL_CONVERSION_RATE      
       ,QLLI.BENEFIT_QTY                  
       ,QLLI.BENEFIT_UOM_CODE             
       ,QLLI.RECURRING_FLAG               
       ,QLLI.BENEFIT_LIMIT                
       ,QLLI.CHARGE_TYPE_CODE             
       ,QLLI.CHARGE_SUBTYPE_CODE          
       ,QLLI.CONTEXT                      
       ,QLLI.ATTRIBUTE1   LINE_ATTRIBUTE1                 
       ,QLLI.ATTRIBUTE2   LINE_ATTRIBUTE2                 
       ,QLLI.ATTRIBUTE3   LINE_ATTRIBUTE3                 
       ,QLLI.ATTRIBUTE4   LINE_ATTRIBUTE4                 
       ,QLLI.ATTRIBUTE5   LINE_ATTRIBUTE5                 
       ,QLLI.ATTRIBUTE6   LINE_ATTRIBUTE6                 
       ,QLLI.ATTRIBUTE7   LINE_ATTRIBUTE7                 
       ,QLLI.ATTRIBUTE8   LINE_ATTRIBUTE8                 
       ,QLLI.ATTRIBUTE9   LINE_ATTRIBUTE9                 
       ,QLLI.ATTRIBUTE10  LINE_ATTRIBUTE10                
       ,QLLI.ATTRIBUTE11  LINE_ATTRIBUTE11                
       ,QLLI.ATTRIBUTE12  LINE_ATTRIBUTE12                
       ,QLLI.ATTRIBUTE13  LINE_ATTRIBUTE13                
       ,QLLI.ATTRIBUTE14  LINE_ATTRIBUTE14                
       ,QLLI.ATTRIBUTE15  LINE_ATTRIBUTE15                
       ,QLLI.INCLUDE_ON_RETURNS_FLAG      
       ,QLLI.QUALIFICATION_IND                      
       ,QLLI.GROUP_COUNT                  
       ,QLLI.NET_AMOUNT_FLAG              
       ,QLLI.RECURRING_VALUE              
       ,QLLI.ACCUM_CONTEXT                
       ,QLLI.ACCUM_ATTRIBUTE              
       ,QLLI.ACCUM_ATTR_RUN_SRC_FLAG      
       ,QLLI.CUSTOMER_ITEM_ID             
       ,QLLI.BREAK_UOM_CODE               
       ,QLLI.BREAK_UOM_CONTEXT            
       ,QLLI.BREAK_UOM_ATTRIBUTE          
       ,QLLI.PATTERN_ID                   
       ,QLLI.PRICING_ATTRIBUTE_COUNT      
       ,QLLI.HASH_KEY                     
       ,QLLI.CACHE_KEY                    
       ,QLLI.ORIG_SYS_LINE_REF            
       ,QLLI.ORIG_SYS_HEADER_REF          
       ,QLLI.CONTINUOUS_PRICE_BREAK_FLAG  
       ,QLLI.EQ_FLAG                                       
       ,QLLI.NULL_OTHER_OPRT_COUNT        
       ,QLLI.PTE_CODE                     
       ,QLLI.SOURCE_SYSTEM_CODE                                  
  FROM QP_LIST_HEADERS_B QPLH
      ,QP_LIST_HEADERS_TL QPTL
      ,QP_LIST_LINES_V QLL
      ,QP_LIST_LINES QLLI
      ,MTL_SYSTEM_ITEMS_B INV
 WHERE QPLH.LIST_HEADER_ID = QPTL.LIST_HEADER_ID
   AND INV.INVENTORY_ITEM_ID = QLL.PRODUCT_ID (+)
   AND QLL.LIST_HEADER_ID = QPTL.LIST_HEADER_ID   
   AND QLL.LIST_HEADER_ID = QLLI.LIST_HEADER_ID
   AND QLL.LIST_LINE_ID = QLLI.LIST_LINE_ID