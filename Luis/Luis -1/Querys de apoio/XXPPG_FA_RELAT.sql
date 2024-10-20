SELECT FB.BOOK_TYPE_CODE
,FB.ASSET_ID                                      
,FB.DATE_PLACED_IN_SERVICE        
,TRUNC(FB.DATE_EFFECTIVE) DATE_EFFECTIVE               
,FB.DEPRN_START_DATE              
,FB.DEPRN_METHOD_CODE             
,FB.LIFE_IN_MONTHS                
,FB.RATE_ADJUSTMENT_FACTOR        
,FB.ADJUSTED_COST                 
,FB.COST                          
,FB.ORIGINAL_COST                 
,FB.SALVAGE_VALUE                 
,FB.PRORATE_CONVENTION_CODE       
,FB.PRORATE_DATE                  
,FB.COST_CHANGE_FLAG              
,FB.ADJUSTMENT_REQUIRED_STATUS    
,FB.CAPITALIZE_FLAG               
,FB.RETIREMENT_PENDING_FLAG       
,FB.DEPRECIATE_FLAG                              
,FB.DATE_INEFFECTIVE              
,FB.TRANSACTION_HEADER_ID_IN      
,FB.TRANSACTION_HEADER_ID_OUT     
,FB.ITC_AMOUNT_ID                 
,FB.ITC_AMOUNT                    
,FB.RETIREMENT_ID                 
,FB.TAX_REQUEST_ID                
,FB.ITC_BASIS                     
,FB.BASIC_RATE                    
,FB.ADJUSTED_RATE                 
,FB.BONUS_RULE                    
,FB.CEILING_NAME                  
,FB.RECOVERABLE_COST                          
,FB.ADJUSTED_CAPACITY             
,FB.FULLY_RSVD_REVALS_COUNTER     
,FB.IDLED_FLAG                    
,FB.PERIOD_COUNTER_CAPITALIZED    
,FB.PERIOD_COUNTER_FULLY_RESERVED 
,FB.PERIOD_COUNTER_FULLY_RETIRED  
,FB.PRODUCTION_CAPACITY           
,FB.REVAL_AMORTIZATION_BASIS      
,FB.REVAL_CEILING                 
,FB.UNIT_OF_MEASURE               
,FB.UNREVALUED_COST               
,FB.ANNUAL_DEPRN_ROUNDING_FLAG    
,FB.PERCENT_SALVAGE_VALUE         
,FB.ALLOWED_DEPRN_LIMIT           
,FB.ALLOWED_DEPRN_LIMIT_AMOUNT    
,FB.PERIOD_COUNTER_LIFE_COMPLETE  
,FB.ADJUSTED_RECOVERABLE_COST     
,FB.ANNUAL_ROUNDING_FLAG          
,FB.GLOBAL_ATTRIBUTE1             
,FB.GLOBAL_ATTRIBUTE2             
,FB.GLOBAL_ATTRIBUTE3             
,FB.GLOBAL_ATTRIBUTE4             
,FB.GLOBAL_ATTRIBUTE5             
,FB.GLOBAL_ATTRIBUTE6             
,FB.GLOBAL_ATTRIBUTE7             
,FB.GLOBAL_ATTRIBUTE8             
,FB.GLOBAL_ATTRIBUTE9             
,FB.GLOBAL_ATTRIBUTE10            
,FB.GLOBAL_ATTRIBUTE11            
,FB.GLOBAL_ATTRIBUTE12            
,FB.GLOBAL_ATTRIBUTE13            
,FB.GLOBAL_ATTRIBUTE14            
,FB.GLOBAL_ATTRIBUTE15            
,FB.GLOBAL_ATTRIBUTE16            
,FB.GLOBAL_ATTRIBUTE17            
,FB.GLOBAL_ATTRIBUTE18            
,FB.GLOBAL_ATTRIBUTE19            
,FB.GLOBAL_ATTRIBUTE20            
,FB.EOFY_ADJ_COST                 
,FB.EOFY_FORMULA_FACTOR           
,FB.SHORT_FISCAL_YEAR_FLAG        
,FB.CONVERSION_DATE               
,FB.ORIGINAL_DEPRN_START_DATE     
,FB.REMAINING_LIFE1               
,FB.REMAINING_LIFE2               
,FB.OLD_ADJUSTED_COST             
,FB.FORMULA_FACTOR                
,FB.GROUP_ASSET_ID                
,FB.SALVAGE_TYPE                  
,FB.DEPRN_LIMIT_TYPE              
,FB.REDUCTION_RATE                
,FB.REDUCE_ADDITION_FLAG          
,FB.REDUCE_ADJUSTMENT_FLAG        
,FB.REDUCE_RETIREMENT_FLAG        
,FB.RECOGNIZE_GAIN_LOSS           
,FB.RECAPTURE_RESERVE_FLAG        
,FB.LIMIT_PROCEEDS_FLAG           
,FB.TERMINAL_GAIN_LOSS            
,FB.TRACKING_METHOD               
,FB.EXCLUDE_FULLY_RSV_FLAG        
,FB.EXCESS_ALLOCATION_OPTION      
,FB.DEPRECIATION_OPTION           
,FB.MEMBER_ROLLUP_FLAG            
,FB.ALLOCATE_TO_FULLY_RSV_FLAG    
,FB.ALLOCATE_TO_FULLY_RET_FLAG    
,FB.TERMINAL_GAIN_LOSS_AMOUNT     
,FB.CIP_COST                      
,FB.YTD_PROCEEDS                  
,FB.LTD_PROCEEDS                  
,FB.LTD_COST_OF_REMOVAL           
,FB.EOFY_RESERVE                  
,FB.PRIOR_EOFY_RESERVE            
,FB.EOP_ADJ_COST                  
,FB.EOP_FORMULA_FACTOR            
,FB.EXCLUDE_PROCEEDS_FROM_BASIS   
,FB.RETIREMENT_DEPRN_OPTION       
,FB.TERMINAL_GAIN_LOSS_FLAG       
,FB.SUPER_GROUP_ID                
,FB.OVER_DEPRECIATE_OPTION        
,FB.DISABLED_FLAG                 
,FB.OLD_ADJUSTED_CAPACITY         
,FB.DRY_HOLE_FLAG                 
,FB.CASH_GENERATING_UNIT_ID       
,FB.CONTRACT_ID                   
,FB.EXTENDED_DEPRN_FLAG           
,FB.EXTENDED_DEPRECIATION_PERIOD  
,FB.PERIOD_COUNTER_FULLY_EXTENDED 
,FB.RATE_IN_USE                   
,FB.NBV_AT_SWITCH                 
,FB.PRIOR_DEPRN_LIMIT_TYPE        
,FB.PRIOR_DEPRN_LIMIT_AMOUNT      
,FB.PRIOR_DEPRN_LIMIT             
,FB.PRIOR_DEPRN_METHOD            
,FB.PRIOR_LIFE_IN_MONTHS          
,FB.PRIOR_BASIC_RATE              
,FB.PRIOR_ADJUSTED_RATE   
,FA.ASSET_NUMBER                      
,FA.ASSET_KEY_CCID            
,FA.CURRENT_UNITS             
,FA.ASSET_TYPE                
,FA.TAG_NUMBER                
,FA.ASSET_CATEGORY_ID         
,FA.PARENT_ASSET_ID           
,FA.MANUFACTURER_NAME         
,FA.SERIAL_NUMBER             
,FA.MODEL_NUMBER              
,FA.PROPERTY_TYPE_CODE        
,FA.PROPERTY_1245_1250_CODE   
,FA.IN_USE_FLAG               
,FA.OWNED_LEASED              
,FA.NEW_USED                  
,FA.UNIT_ADJUSTMENT_FLAG      
,FA.ADD_COST_JE_FLAG          
,FA.ATTRIBUTE1                
,FA.ATTRIBUTE2                
,FA.ATTRIBUTE3                
,FA.ATTRIBUTE4                
,FA.ATTRIBUTE5                
,FA.ATTRIBUTE6                
,FA.ATTRIBUTE7                
,FA.ATTRIBUTE8                
,FA.ATTRIBUTE9                
,FA.ATTRIBUTE10               
,FA.ATTRIBUTE11               
,FA.ATTRIBUTE12               
,FA.ATTRIBUTE13               
,FA.ATTRIBUTE14               
,FA.ATTRIBUTE15               
,FA.ATTRIBUTE16               
,FA.ATTRIBUTE17               
,FA.ATTRIBUTE18               
,FA.ATTRIBUTE19               
,FA.ATTRIBUTE20               
,FA.ATTRIBUTE21               
,FA.ATTRIBUTE22               
,FA.ATTRIBUTE23               
,FA.ATTRIBUTE24               
,FA.ATTRIBUTE25               
,FA.ATTRIBUTE26               
,FA.ATTRIBUTE27               
,FA.ATTRIBUTE28               
,FA.ATTRIBUTE29               
,FA.ATTRIBUTE30               
,FA.ATTRIBUTE_CATEGORY_CODE   
,FA.CONTEXT                   
,FA.LEASE_ID                  
,FA.INVENTORIAL               
,FA.LAST_UPDATE_DATE          
,FA.LAST_UPDATED_BY           
,FA.CREATED_BY                
,FA.CREATION_DATE             
,FA.LAST_UPDATE_LOGIN         
,FA.GLOBAL_ATTRIBUTE1      FA_GLOBAL_ATTRIBUTE1    
,FA.GLOBAL_ATTRIBUTE2      FA_GLOBAL_ATTRIBUTE2    
,FA.GLOBAL_ATTRIBUTE3      FA_GLOBAL_ATTRIBUTE3    
,FA.GLOBAL_ATTRIBUTE4      FA_GLOBAL_ATTRIBUTE4    
,FA.GLOBAL_ATTRIBUTE5      FA_GLOBAL_ATTRIBUTE5    
,FA.GLOBAL_ATTRIBUTE6      FA_GLOBAL_ATTRIBUTE6    
,FA.GLOBAL_ATTRIBUTE7      FA_GLOBAL_ATTRIBUTE7    
,FA.GLOBAL_ATTRIBUTE8      FA_GLOBAL_ATTRIBUTE8    
,FA.GLOBAL_ATTRIBUTE9      FA_GLOBAL_ATTRIBUTE9    
,FA.GLOBAL_ATTRIBUTE10     FA_GLOBAL_ATTRIBUTE10   
,FA.GLOBAL_ATTRIBUTE11     FA_GLOBAL_ATTRIBUTE11   
,FA.GLOBAL_ATTRIBUTE12     FA_GLOBAL_ATTRIBUTE12   
,FA.GLOBAL_ATTRIBUTE13     FA_GLOBAL_ATTRIBUTE13   
,FA.GLOBAL_ATTRIBUTE14     FA_GLOBAL_ATTRIBUTE14   
,FA.GLOBAL_ATTRIBUTE15     FA_GLOBAL_ATTRIBUTE15   
,FA.GLOBAL_ATTRIBUTE16     FA_GLOBAL_ATTRIBUTE16   
,FA.GLOBAL_ATTRIBUTE17     FA_GLOBAL_ATTRIBUTE17   
,FA.GLOBAL_ATTRIBUTE18     FA_GLOBAL_ATTRIBUTE18   
,FA.GLOBAL_ATTRIBUTE19     FA_GLOBAL_ATTRIBUTE19   
,FA.GLOBAL_ATTRIBUTE20     FA_GLOBAL_ATTRIBUTE20   
,FA.COMMITMENT                
,FA.INVESTMENT_LAW     
,FT.LANGUAGE          
,FT.SOURCE_LANG
,FT.DESCRIPTION
FROM APPS.FA_BOOKS           FB,
     APPS.FA_ADDITIONS_B     FA,
     APPS.FA_ADDITIONS_TL    FT
WHERE FB.ASSET_ID = FA.ASSET_ID
 AND FB.ASSET_ID = FT.ASSET_ID