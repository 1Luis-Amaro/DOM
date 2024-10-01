SELECT DISTINCT 'MTL' TIPO_CUSTO,DECODE(GBH.BATCH_STATUS,3,GBH.ACTUAL_CMPLT_DATE,4,BATCH_CLOSE_DATE,NULL) DATA_REPORT,(SELECT gbgb.group_name from apps.gme_batch_groups_b gbgb,apps.gme_batch_groups_association gbga where gbh.batch_id = gbga.batch_id
AND gbgb.GROUP_ID = gbga.GROUP_ID AND ROWNUM = 1) GRUPO, GBH.BATCH_NO  OP,MP.ORGANIZATION_CODE ORG,DECODE(GBH.BATCH_STATUS, -1, 'CANCELADA', 1, 'PENDENTE', 2, 'WIP', 3, 'CONCLUIDA', 4, 'FECHADA') STATUS
,GMD2.PLAN_QTY QTD_OF ,GMD2.ACTUAL_QTY QTD_PRODUZIDA,GRVR.STD_QTY LOTE_PADRAO,INV_CONVERT.INV_UM_CONVERT(gmd2.inventory_item_id, 2, gmd2.plan_qty, 'kg', 'l', null, null) QTD_PRODUZIDA_KG
,INV_CONVERT.INV_UM_CONVERT(gmd2.inventory_item_id, 2, gmd2.plan_qty, 'l', 'l', null, null)QTD_PRODUZIDA_LTS ,MSIB2.SEGMENT1 ITEM_PRODUZIDO,MSIB2.DESCRIPTION DESC_ITEM_PRODUZIDO  ,GRVR.PLANNED_PROCESS_LOSS PLANEJADO          
,MCBI2.SEGMENT1 TIPO_ITEM_PRODUZIDO ,MCBI2.SEGMENT2 SBU_ITEM_PRODUZIDO ,MCBI2.SEGMENT3 PL_ITEM_PRODUZIDO ,(SELECT FRH.ROUTING_CLASS FROM apps.FM_ROUT_HDR FRH WHERE GBH.ORGANIZATION_ID = FRH.OWNER_ORGANIZATION_ID (+) AND GBH.ROUTING_ID = FRH.ROUTING_ID (+) AND ROWNUM = 1) CELULA,MSI.SEGMENT1 COD_USADO,
MSI.DESCRIPTION DESC_USADO ,'' OPERACAO,'' RECURSO_PLAN,'' "KW/H" ,MCBI.SEGMENT1 TIPO_ITEM_USADO,MCBI.SEGMENT2 SBU_ITEM_USADO,MCBI.SEGMENT3 PL_ITEM_USADO      
,decode(gmd.scale_type,1,'Proporcional',0,'Fixo',2,'Nr Inteiro') TIPO_ESCALA ,DECODE(GMD.CONTRIBUTE_YIELD_IND, 'Y', 'S', 'N', 'N')CONTRIBUIR_APROVEITAMENTO,GMD.ACTUAL_QTY CONS_HORAS_REAIS    
,decode(gmd.scale_type,1,(GMD2.ACTUAL_QTY / DECODE(GMD2.PLAN_QTY,0,1,GMD2.PLAN_QTY)) * DECODE(GMD.PLAN_QTY,0,1,GMD.PLAN_QTY),GMD.ACTUAL_QTY) CONS_HORAS_PROPORCIONAL
,GMD.PLAN_QTY CONS_HORAS_PLANEJADA,STD_MTL_ITEM_ORDEM.STD_MTL_ITEM_ORDEM  ,STD_CC_ITEM_ORDEM.STD_CC_ITEM_ORDEM,PMAC_MTL_ITEM_ORDEM.PMAC_MTL_ITEM_ORDEM ,PMAC_CC_ITEM_ORDEM.PMAC_CC_ITEM_ORDEM,STD_MTL_ITEM_CONS.STD_MTL_ITEM_CONS,STD_CC_ITEM_CONS.STD_CC_ITEM_CONS 
,PMAC_MTL_ITEM_CONS.PMAC_MTL_ITEM_CONS,PMAC_CC_ITEM_CONS.PMAC_CC_ITEM_CONS,0 TX_RECURSO_STD,0 TX_RECURSO_STDTX,0 TX_RECURSO_PMAC,decode(MCBI.SEGMENT1,'MP',GMD.ACTUAL_QTY,0) QTD_MP_KGS
,decode(MCBI.SEGMENT1,'MP',decode(MCBI.SEGMENT1,'MP',GMD.ACTUAL_QTY,0) * (STD_MTL_ITEM_CONS.STD_MTL_ITEM_CONS),'EMP',decode(MCBI.SEGMENT1,'MP',GMD.ACTUAL_QTY,0) * (STD_MTL_ITEM_CONS.STD_MTL_ITEM_CONS) ,'INS',decode(MCBI.SEGMENT1,'MP',GMD.ACTUAL_QTY,0) * (STD_MTL_ITEM_CONS.STD_MTL_ITEM_CONS) 
,'MRO',decode(MCBI.SEGMENT1,'MP',GMD.ACTUAL_QTY,0) * (STD_MTL_ITEM_CONS.STD_MTL_ITEM_CONS),0) VALOR_ITENS_COMPRADOS,(GMD.ACTUAL_QTY * STD_MTL_ITEM_CONS.STD_MTL_ITEM_CONS) + (GMD.ACTUAL_QTY * NVL(STD_CC_ITEM_CONS.STD_CC_ITEM_CONS,0)) TOT_CONS_REAL_MTL
,(((GMD2.ACTUAL_QTY / DECODE(GMD2.PLAN_QTY,0,1,GMD2.PLAN_QTY))* DECODE(GMD.PLAN_QTY,0,1,GMD.PLAN_QTY)) * STD_MTL_ITEM_CONS.STD_MTL_ITEM_CONS)
+ ((GMD2.ACTUAL_QTY / DECODE(GMD2.PLAN_QTY,0,1,GMD2.PLAN_QTY)) * DECODE(GMD.PLAN_QTY,0,1,GMD.PLAN_QTY) * NVL(STD_CC_ITEM_CONS.STD_CC_ITEM_CONS,0))  TOT_CONS_PROP_MTL
,(GMD.PLAN_QTY *  STD_MTL_ITEM_CONS.STD_MTL_ITEM_CONS) + (GMD.PLAN_QTY * NVL(STD_CC_ITEM_CONS.STD_CC_ITEM_CONS,0)) TOT_CONS_PLAN_MTL,GMD.ACTUAL_QTY * NVL(STD_CC_ITEM_CONS.STD_CC_ITEM_CONS,0) TOT_CONS_REAL_CC ,(GMD2.ACTUAL_QTY / DECODE(GMD2.PLAN_QTY,0,1,GMD2.PLAN_QTY)) * DECODE(GMD.PLAN_QTY,0,1,GMD.PLAN_QTY) * NVL(STD_CC_ITEM_CONS.STD_CC_ITEM_CONS,0) TOT_CONS_PROP_CC
,GMD.PLAN_QTY * NVL(STD_CC_ITEM_CONS.STD_CC_ITEM_CONS,0)  TOT_CONS_PLAN_CC,GMD.ACTUAL_QTY * STD_MTL_ITEM_CONS.STD_MTL_ITEM_CONS TOT_CONS_REAL,(((GMD2.ACTUAL_QTY / DECODE(GMD2.PLAN_QTY,0,1,GMD2.PLAN_QTY))* DECODE(GMD.PLAN_QTY,0,1,GMD.PLAN_QTY)) * STD_MTL_ITEM_CONS.STD_MTL_ITEM_CONS)
+ ((GMD2.ACTUAL_QTY / DECODE(GMD2.PLAN_QTY,0,1,GMD2.PLAN_QTY)) * DECODE(GMD.PLAN_QTY,0,1,GMD.PLAN_QTY) * NVL(STD_CC_ITEM_CONS.STD_CC_ITEM_CONS,0)) + (GMD2.ACTUAL_QTY / DECODE(GMD2.PLAN_QTY,0,1,GMD2.PLAN_QTY)) * DECODE(GMD.PLAN_QTY,0,1,GMD.PLAN_QTY) * NVL(STD_CC_ITEM_CONS.STD_CC_ITEM_CONS,0) TOT_CONS_PROP
,(GMD.PLAN_QTY *  STD_MTL_ITEM_CONS.STD_MTL_ITEM_CONS) + (GMD.PLAN_QTY * NVL(STD_CC_ITEM_CONS.STD_CC_ITEM_CONS,0))+ GMD.PLAN_QTY * NVL(STD_CC_ITEM_CONS.STD_CC_ITEM_CONS,0) TOT_CONS_PLAN,0 TOT_CONS_REAL_RECURSO_STD,0 TOT_CONS_PROP_RECURSO_STD,0 TOT_CONS_PLAN_RECURSO_STD,0 TOT_CONS_REAL_RECURSO_STDTX,0 TOT_CONS_PROP_RECURSO_STDTX
,0 TOT_CONS_PLAN_RECURSO_STDTX,0 TOT_CONS_REAL_RECURSO_PMAC,0 TOT_CONS_PROP_RECURSO_PMAC,0 TOT_CONS_PLAN_RECURSO_PMAC,GMD2.ACTUAL_QTY * STD_MTL_ITEM_ORDEM.STD_MTL_ITEM_ORDEM TOT_STD_ITEM_OP,GMD2.ACTUAL_QTY * STD_CC_ITEM_ORDEM.STD_CC_ITEM_ORDEM TOT_CC_ITEM_OP
,(GMD2.ACTUAL_QTY * STD_MTL_ITEM_ORDEM.STD_MTL_ITEM_ORDEM) + (GMD2.ACTUAL_QTY * STD_CC_ITEM_ORDEM.STD_CC_ITEM_ORDEM) TOT_STD_OP,(PMAC_MTL_ITEM_ORDEM.PMAC_MTL_ITEM_ORDEM + PMAC_CC_ITEM_ORDEM.PMAC_CC_ITEM_ORDEM) * GMD2.ACTUAL_QTY TOT_PMAC_OP
,(PMAC_MTL_ITEM_CONS +PMAC_CC_ITEM_CONS)* GMD.ACTUAL_QTY TOT_PMAC_CONS FROM apps.MTL_SYSTEM_ITEMS_B MSIB2,apps.GME_MATERIAL_DETAILS GMD2,apps.MTL_CATEGORIES_B MCBI2,apps.MTL_CATEGORY_SETS MCSI2
,apps.MTL_ITEM_CATEGORIES MICI2,APPS.GME_BATCH_HEADER GBH,APPS.GMD_RECIPE_VALIDITY_RULES GRVR,APPS.GMD_RECIPES_B GR,APPS.MTL_PARAMETERS MP,APPS.MTL_TRANSACTION_REASONS MTR,APPS.GME_MATERIAL_DETAILS GMD
,APPS.MTL_SYSTEM_ITEMS_B MSI,apps.MTL_LOT_NUMBERS_ALL_V MLNA,apps.MTL_MATERIAL_TRANSACTIONS   MMT,apps.MTL_TRANSACTION_LOT_NUMBERS MTLN
,apps.MTL_CATEGORIES_B MCBI,apps.MTL_CATEGORY_SETS MCSI,apps.MTL_ITEM_CATEGORIES MICI,(select SUM(ccd.cmpnt_cost) STD_MTL_ITEM_ORDEM ,ccd.ORGANIZATION_ID ,GMD2.BATCH_ID,gps.calendar_code,gps.period_code
from apps.gmf_period_statuses gps ,apps.cm_cmpt_dtl ccd   ,apps.CM_CMPT_MST_B CCMB,apps.MTL_SYSTEM_ITEMS_B MSIB2,apps.GME_MATERIAL_DETAILS GMD2
where ccd.inventory_item_id  = MSIB2.INVENTORY_ITEM_ID AND ccd.organization_id = MSIB2.ORGANIZATION_ID and gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'STD' AND ROWNUM = 1)
and gps.period_id = ccd.period_id AND GMD2.INVENTORY_ITEM_ID  = MSIB2.INVENTORY_ITEM_ID AND GMD2.LINE_TYPE in (1) AND CCMB.COST_CMPNTCLS_ID = CCD.COST_CMPNTCLS_ID AND CCMB.USAGE_IND = 1
group by ccd.ORGANIZATION_ID ,GMD2.BATCH_ID,gps.calendar_code,gps.period_code) STD_MTL_ITEM_ORDEM,(select SUM(ccd.cmpnt_cost) PMAC_MTL_ITEM_ORDEM,ccd.ORGANIZATION_ID,GMD2.BATCH_ID,gps.calendar_code,gps.period_code,MSIB2.inventory_item_id from apps.gmf_period_statuses gps ,apps.cm_cmpt_dtl ccd   
,apps.CM_CMPT_MST_B CCMB,apps.MTL_SYSTEM_ITEMS_B MSIB2,apps.GME_MATERIAL_DETAILS GMD2 where ccd.inventory_item_id  = MSIB2.INVENTORY_ITEM_ID         
AND ccd.organization_id = MSIB2.ORGANIZATION_ID and gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'PMAC' AND ROWNUM = 1)
and gps.period_id = ccd.period_id AND GMD2.INVENTORY_ITEM_ID  = MSIB2.INVENTORY_ITEM_ID AND GMD2.LINE_TYPE in (1) AND CCMB.COST_CMPNTCLS_ID = CCD.COST_CMPNTCLS_ID AND CCMB.USAGE_IND = 1 group by ccd.ORGANIZATION_ID,GMD2.BATCH_ID,gps.calendar_code,gps.period_code,MSIB2.inventory_item_id) PMAC_MTL_ITEM_ORDEM
,(select SUM(ccd.cmpnt_cost) PMAC_CC_ITEM_ORDEM,ccd.ORGANIZATION_ID,GMD2.BATCH_ID,gps.calendar_code,gps.period_code,MSIB2.inventory_item_id from apps.gmf_period_statuses gps,apps.cm_cmpt_dtl ccd,apps.CM_CMPT_MST_B CCMB,apps.MTL_SYSTEM_ITEMS_B MSIB2,apps.GME_MATERIAL_DETAILS GMD2
where ccd.inventory_item_id  = MSIB2.INVENTORY_ITEM_ID AND ccd.organization_id = MSIB2.ORGANIZATION_ID and gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'PMAC' AND ROWNUM = 1) and gps.period_id = ccd.period_id      
AND GMD2.INVENTORY_ITEM_ID  = MSIB2.INVENTORY_ITEM_ID AND GMD2.LINE_TYPE in (1) AND CCMB.COST_CMPNTCLS_ID = CCD.COST_CMPNTCLS_ID AND CCMB.USAGE_IND = 1 group by ccd.ORGANIZATION_ID ,GMD2.BATCH_ID,gps.calendar_code,gps.period_code,MSIB2.inventory_item_id) PMAC_CC_ITEM_ORDEM   
,(select SUM(ccd.cmpnt_cost) STD_CC_ITEM_ORDEM,ccd.ORGANIZATION_ID,GMD2.BATCH_ID,gps.calendar_code,gps.period_code from apps.gmf_period_statuses gps,apps.cm_cmpt_dtl ccd,apps.CM_CMPT_MST_B CCMB,apps.MTL_SYSTEM_ITEMS_B MSIB2,apps.GME_MATERIAL_DETAILS GMD2
where ccd.inventory_item_id  = MSIB2.INVENTORY_ITEM_ID AND ccd.organization_id = MSIB2.ORGANIZATION_ID and gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'STD' AND ROWNUM = 1)
and gps.period_id = ccd.period_id AND GMD2.INVENTORY_ITEM_ID  = MSIB2.INVENTORY_ITEM_ID AND GMD2.LINE_TYPE in (1) AND CCMB.COST_CMPNTCLS_ID = CCD.COST_CMPNTCLS_ID
AND CCMB.USAGE_IND = 3 group by ccd.ORGANIZATION_ID ,GMD2.BATCH_ID,gps.calendar_code,gps.period_code) STD_CC_ITEM_ORDEM,(select SUM(ccd.cmpnt_cost) STD_MTL_ITEM_CONS,gps.calendar_code,gps.period_code,ccd.inventory_item_id,ccd.organization_id
from apps.gmf_period_statuses gps,apps.cm_cmpt_dtl ccd,apps.CM_CMPT_MST_B CCMB where gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'STD' AND ROWNUM = 1)
and gps.period_id = ccd.period_id AND CCMB.COST_CMPNTCLS_ID = CCD.COST_CMPNTCLS_ID AND CCMB.USAGE_IND = 1 group by gps.calendar_code ,gps.period_code,ccd.inventory_item_id,ccd.organization_id) STD_MTL_ITEM_CONS  
,(select SUM(ccd.cmpnt_cost) STD_CC_ITEM_CONS,gps.calendar_code,gps.period_code,ccd.inventory_item_id,ccd.organization_id from apps.gmf_period_statuses gps ,apps.cm_cmpt_dtl ccd ,apps.CM_CMPT_MST_B CCMB       
where gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'STD' AND ROWNUM = 1) and gps.period_id = ccd.period_id  (+)  AND CCMB.COST_CMPNTCLS_ID (+) = CCD.COST_CMPNTCLS_ID AND CCMB.USAGE_IND = 3
group by gps.calendar_code,gps.period_code,ccd.inventory_item_id,ccd.organization_id) STD_CC_ITEM_CONS ,(select SUM(ccd.cmpnt_cost) PMAC_MTL_ITEM_CONS,gps.calendar_code,gps.period_code,ccd.inventory_item_id,ccd.organization_id
from apps.gmf_period_statuses gps ,apps.cm_cmpt_dtl ccd ,apps.CM_CMPT_MST_B CCMB where gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'PMAC' AND ROWNUM = 1)
and gps.period_id = ccd.period_id AND CCMB.COST_CMPNTCLS_ID = CCD.COST_CMPNTCLS_ID AND CCMB.USAGE_IND = 1 group by gps.calendar_code,gps.period_code,ccd.inventory_item_id,ccd.organization_id) PMAC_MTL_ITEM_CONS  
,(select SUM(ccd.cmpnt_cost) PMAC_CC_ITEM_CONS ,gps.calendar_code,gps.period_code ,ccd.inventory_item_id ,ccd.organization_id from apps.gmf_period_statuses gps ,apps.cm_cmpt_dtl ccd ,apps.CM_CMPT_MST_B CCMB       
where gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'PMAC' AND ROWNUM = 1) and gps.period_id = ccd.period_id  (+)  
AND CCMB.COST_CMPNTCLS_ID (+) = CCD.COST_CMPNTCLS_ID AND CCMB.USAGE_IND = 1 group by gps.calendar_code,gps.period_code,ccd.inventory_item_id,ccd.organization_id) PMAC_CC_ITEM_CONS
--novo
,(SELECT CATEGORY_SET_ID CATEGORY_SET_ID FROM APPS.MTL_DEFAULT_CATEGORY_SETS WHERE FUNCTIONAL_AREA_ID = 1 AND ROWNUM = 1) CAT_INV
WHERE GBH.RECIPE_VALIDITY_RULE_ID = GRVR.RECIPE_VALIDITY_RULE_ID (+) AND GRVR.RECIPE_ID = GR.RECIPE_ID (+) AND MTR.REASON_ID (+) = GBH.TERMINATE_REASON_ID
AND GBH.ORGANIZATION_ID = MP.ORGANIZATION_ID (+) AND GBH.ORGANIZATION_ID = GR.OWNER_ORGANIZATION_ID AND GBH.ORGANIZATION_ID = GRVR.ORGANIZATION_ID (+) AND GBH.ORGANIZATION_ID = GMD.ORGANIZATION_ID (+)
AND GBH.ORGANIZATION_ID = MSI.ORGANIZATION_ID (+) AND GBH.BATCH_ID = GMD.BATCH_ID (+) AND GMD.INVENTORY_ITEM_ID  = MSI.INVENTORY_ITEM_ID AND MMT.TRANSACTION_SOURCE_ID (+) = GBH.BATCH_ID
AND MTLN.TRANSACTION_ID = MMT.TRANSACTION_ID AND MLNA.INVENTORY_ITEM_ID = MMT.INVENTORY_ITEM_ID AND MLNA.ORGANIZATION_ID = MMT.ORGANIZATION_ID AND MCBI.STRUCTURE_ID = MCSI.STRUCTURE_ID       
AND MCSI.CATEGORY_SET_ID = CAT_INV.CATEGORY_SET_ID AND MICI.CATEGORY_SET_ID = MCSI.CATEGORY_SET_ID AND MICI.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID AND MICI.ORGANIZATION_ID = MSI.ORGANIZATION_ID
AND MICI.CATEGORY_ID = MCBI.CATEGORY_ID AND GMD.LINE_TYPE in (-1) and GBH.ORGANIZATION_ID = STD_MTL_ITEM_ORDEM.ORGANIZATION_ID        
AND GBH.BATCH_ID = STD_MTL_ITEM_ORDEM.BATCH_ID (+) and STD_MTL_ITEM_ORDEM.calendar_code LIKE '%'||to_char(GBH.plan_start_date,'RRRR')||'%'
and STD_MTL_ITEM_ORDEM.period_code  = to_char(GBH.plan_start_date,'MM') and GBH.ORGANIZATION_ID = STD_CC_ITEM_ORDEM.ORGANIZATION_ID AND GBH.BATCH_ID = STD_CC_ITEM_ORDEM.BATCH_ID (+)   
and STD_CC_ITEM_ORDEM.calendar_code LIKE '%'||to_char(GBH.plan_start_date,'RRRR')||'%' and STD_CC_ITEM_ORDEM.period_code  = to_char(GBH.plan_start_date,'MM') 
and STD_MTL_ITEM_CONS.calendar_code LIKE '%'||to_char(GBH.plan_start_date,'RRRR')||'%' and STD_MTL_ITEM_CONS.period_code = to_char(GBH.plan_start_date,'MM')
and STD_MTL_ITEM_CONS.inventory_item_id = msi.inventory_item_id and STD_MTL_ITEM_CONS.organization_id = msi.organization_id
and STD_CC_ITEM_CONS.inventory_item_id (+) = msi.inventory_item_id and STD_CC_ITEM_CONS.organization_id (+) = msi.organization_id
AND GRVR.RECIPE_VALIDITY_RULE_ID = DECODE((SELECT COUNT(*) FROM apps.GMD_RECIPE_VALIDITY_RULES WHERE  RECIPE_ID = GRVR.RECIPE_ID AND PREFERENCE = 1),1,(SELECT RECIPE_VALIDITY_RULE_ID
 FROM apps.GMD_RECIPE_VALIDITY_RULES WHERE RECIPE_ID = GRVR.RECIPE_ID AND PREFERENCE = 1),(SELECT RECIPE_VALIDITY_RULE_ID FROM apps.GMD_RECIPE_VALIDITY_RULES
WHERE RECIPE_ID = GRVR.RECIPE_ID AND PREFERENCE = 1 AND CREATION_DATE = (SELECT MIN(CREATION_DATE) FROM apps.GMD_RECIPE_VALIDITY_RULES 
WHERE RECIPE_ID = GRVR.RECIPE_ID AND PREFERENCE = 1))) and GBH.ORGANIZATION_ID = MSIB2.ORGANIZATION_ID AND GMD2.INVENTORY_ITEM_ID  = MSIB2.INVENTORY_ITEM_ID
AND GMD2.LINE_TYPE in (1) AND GBH.ORGANIZATION_ID = GMD2.ORGANIZATION_ID (+) AND GBH.BATCH_ID = GMD2.BATCH_ID (+) AND MCBI2.STRUCTURE_ID = MCSI2.STRUCTURE_ID           
AND MCSI2.CATEGORY_SET_ID = CAT_INV.CATEGORY_SET_ID AND MICI2.CATEGORY_SET_ID = MCSI2.CATEGORY_SET_ID AND MICI2.INVENTORY_ITEM_ID = MSIB2.INVENTORY_ITEM_ID AND MICI2.ORGANIZATION_ID = MSIB2.ORGANIZATION_ID
AND MICI2.CATEGORY_ID = MCBI2.CATEGORY_ID and PMAC_MTL_ITEM_ORDEM.calendar_code LIKE '%'||to_char(GBH.plan_start_date,'RRRR')||'%' and PMAC_MTL_ITEM_ORDEM.period_code = to_char(GBH.plan_start_date,'MM')
--and PMAC_MTL_ITEM_ORDEM.inventory_item_id (+) = msi.inventory_item_id         
and PMAC_MTL_ITEM_ORDEM.organization_id (+) = GBH.ORGANIZATION_ID AND GBH.BATCH_ID = PMAC_MTL_ITEM_ORDEM.BATCH_ID (+) and PMAC_CC_ITEM_ORDEM.calendar_code LIKE '%'||to_char(GBH.plan_start_date,'RRRR')||'%' and PMAC_CC_ITEM_ORDEM.period_code = to_char(GBH.plan_start_date,'MM')
--and PMAC_CC_ITEM_ORDEM.inventory_item_id (+) = msi.inventory_item_id         
and PMAC_CC_ITEM_ORDEM.organization_id (+) = GBH.ORGANIZATION_ID AND GBH.BATCH_ID = PMAC_CC_ITEM_ORDEM.BATCH_ID (+) and PMAC_MTL_ITEM_CONS.calendar_code LIKE '%'||to_char(GBH.plan_start_date,'RRRR')||'%' 
and PMAC_MTL_ITEM_CONS.period_code = to_char(GBH.plan_start_date,'MM') and PMAC_MTL_ITEM_CONS.inventory_item_id (+) = msi.inventory_item_id and PMAC_MTL_ITEM_CONS.organization_id (+) = msi.organization_id and PMAC_CC_ITEM_CONS.calendar_code LIKE '%'||to_char(GBH.plan_start_date,'RRRR')||'%' and PMAC_CC_ITEM_CONS.period_code = to_char(GBH.plan_start_date,'MM')
and PMAC_CC_ITEM_CONS.inventory_item_id (+) = msi.inventory_item_id and PMAC_CC_ITEM_CONS.organization_id (+) = msi.organization_id
UNION
SELECT DISTINCT 'REC' TIPO_CUSTO,DECODE(GBH.BATCH_STATUS,3,GBH.ACTUAL_CMPLT_DATE,4,BATCH_CLOSE_DATE,NULL) DATA_REPORT,(SELECT gbgb.group_name from apps.gme_batch_groups_b gbgb,apps.gme_batch_groups_association gbga where gbh.batch_id = gbga.batch_id
AND gbgb.GROUP_ID = gbga.GROUP_ID AND ROWNUM = 1) GRUPO,GBH.BATCH_NO  OP,MP.ORGANIZATION_CODE ORG,DECODE(GBH.BATCH_STATUS, -1, 'CANCELADA', 1, 'PENDENTE', 2, 'WIP', 3, 'CONCLUIDA', 4, 'FECHADA') STATUS
,GMD2.PLAN_QTY QTD_OF,GMD2.ACTUAL_QTY QTD_PRODUZIDA,GRVR.STD_QTY LOTE_PADRAO,INV_CONVERT.INV_UM_CONVERT(gmd2.inventory_item_id, 2, gmd2.plan_qty, 'kg', 'l', null, null) QTD_PRODUZIDA_KG
,INV_CONVERT.INV_UM_CONVERT(gmd2.inventory_item_id, 2, gmd2.plan_qty, 'l', 'l', null, null) QTD_PRODUZIDA_LTS,MSIB2.SEGMENT1 ITEM_PRODUZIDO,MSIB2.DESCRIPTION DESC_ITEM_PRODUZIDO ,GRVR.PLANNED_PROCESS_LOSS PLANEJADO,MCBI2.SEGMENT1 TIPO_ITEM_PRODUZIDO               
,MCBI2.SEGMENT2 SBU_ITEM_PRODUZIDO,MCBI2.SEGMENT3 PL_ITEM_PRODUZIDO,(SELECT FRH.ROUTING_CLASS FROM apps.FM_ROUT_HDR FRH WHERE GBH.ORGANIZATION_ID = FRH.OWNER_ORGANIZATION_ID (+) AND GBH.ROUTING_ID = FRH.ROUTING_ID (+) AND ROWNUM = 1) CELULA           
,gbsr.resources COD_USADO,(SELECT RESOURCE_DESC FROM apps.CR_RSRC_MST WHERE RESOURCES = gbsr.resources AND ROWNUM = 1) DESC_USADO,gov.OPRN_NO||' - '||gov.OPRN_DESC OPERACAO  ,(select gbsr3.resources from  apps.gme_batch_steps gbs3, apps.gmd_operations_vl gov3
, apps.gme_batch_step_activities gbsa3, apps.gme_batch_step_resources gbsr3, apps.cr_rsrc_mst crm3, apps.cm_cmpt_mst cmm3,apps.gmp_resource_parameters grp3
,apps.gmp_process_parameters gpp3 where gbh.batch_id = gbsa3.batch_id AND gbsr3.batchstep_activity_id = gbsa3.batchstep_activity_id
AND gbs3.batchstep_id = gbsa3.batchstep_id AND gbs3.oprn_id = gov3.oprn_id AND gbsr3.resources = crm3.resources AND crm3.cost_cmpntcls_id = cmm3.cost_cmpntcls_id
AND cmm3.usage_ind = 3 AND cmm3.product_cost_ind = 0--1 and gbsr3.PRIM_RSRC_IND = 1 AND gbsa3.batchstep_id = gbsa.batchstep_id     
and gpp3.parameter_id (+) = grp3.parameter_id and gpp3.parameter_id (+) = 7 and grp3.resources(+)  = gbsr3.resources AND ROWNUM = 1) RECURSO_PLAN     
,(select grp3.target_value from  apps.gme_batch_steps gbs3, apps.gmd_operations_vl gov3, apps.gme_batch_step_activities gbsa3
, apps.gme_batch_step_resources gbsr3, apps.cr_rsrc_mst crm3, apps.cm_cmpt_mst cmm3  ,apps.gmp_resource_parameters grp3,apps.gmp_process_parameters gpp3      
where gbh.batch_id = gbsa3.batch_id AND gbsr3.batchstep_activity_id = gbsa3.batchstep_activity_id AND gbs3.batchstep_id = gbsa3.batchstep_id AND gbs3.oprn_id = gov3.oprn_id AND gbsr3.resources = crm3.resources AND crm3.cost_cmpntcls_id = cmm3.cost_cmpntcls_id
AND cmm3.usage_ind = 3 AND cmm3.product_cost_ind = 0--1 and gbsr3.PRIM_RSRC_IND = 1 AND gbsa3.batchstep_id = gbsa.batchstep_id     
and gpp3.parameter_id (+) = grp3.parameter_id and gpp3.parameter_id (+) = 7 and grp3.resources(+)  = gbsr3.resources AND ROWNUM = 1) "KW/H",'' TIPO_ITEM_USADO
,'' SBU_ITEM_USADO,'' PL_ITEM_USADO ,decode(gbsr.scale_type,1,'Proporcional',0,'Fixo',2,'Por encargo') TIPO_ESCALA,'' CONTRIBUIR_APROVEITAMENTO
,(gbsr.actual_rsrc_count * gbsr.actual_rsrc_usage) CONS_HORAS_REAIS ,decode(gbsr.scale_type,1,(GMD2.ACTUAL_QTY / GMD2.PLAN_QTY) * (gbsr.actual_rsrc_count * gbsr.actual_rsrc_usage),(gbsr.actual_rsrc_count * gbsr.actual_rsrc_usage)) CONS_HORAS_PROPORCIONAL
,(gbsr.actual_rsrc_count * gbsr.actual_rsrc_usage) CONS_HORAS_PLANEJADA,STD_MTL_ITEM_ORDEM.STD_MTL_ITEM_ORDEM,STD_CC_ITEM_ORDEM.STD_CC_ITEM_ORDEM   
,PMAC_MTL_ITEM_ORDEM.PMAC_MTL_ITEM_ORDEM,PMAC_CC_ITEM_ORDEM.PMAC_CC_ITEM_ORDEM,0,0,0,0--PMAC_MTL_ITEM_CONS.PMAC_MTL_ITEM_CONS,PMAC_CC_ITEM_CONS.PMAC_CC_ITEM_CONS
,TX_RECURSO_STD.TX_RECURSO_STD,TX_RECURSO_STDTX.TX_RECURSO_STDTX,TX_RECURSO_PMAC.TX_RECURSO_PMAC,0,0 VALOR_ITENS_COMPRADOS ,0,0,0,0,0,0,0,0,0
,(gbsr.actual_rsrc_count * gbsr.actual_rsrc_usage) * TX_RECURSO_STD.TX_RECURSO_STD TOT_CONS_REAL_RECURSO_STD ,((GMD2.ACTUAL_QTY / GMD2.PLAN_QTY) * (gbsr.actual_rsrc_count * gbsr.actual_rsrc_usage)) * TX_RECURSO_STD.TX_RECURSO_STD TOT_CONS_PROP_RECURSO_STD
,(gbsr.actual_rsrc_count * gbsr.actual_rsrc_usage) * TX_RECURSO_STD.TX_RECURSO_STD TOT_CONS_PLAN_RECURSO_STD,(gbsr.actual_rsrc_count * gbsr.actual_rsrc_usage) * TX_RECURSO_STDTX.TX_RECURSO_STDTX TOT_CONS_REAL_RECURSO_STDTX
,((GMD2.ACTUAL_QTY / GMD2.PLAN_QTY) * (gbsr.actual_rsrc_count * gbsr.actual_rsrc_usage)) * TX_RECURSO_STDTX.TX_RECURSO_STDTX TOT_CONS_PROP_RECURSO_STDTX
,(gbsr.actual_rsrc_count * gbsr.actual_rsrc_usage) * TX_RECURSO_STDTX TOT_CONS_PLAN_RECURSO_STDTX,(gbsr.actual_rsrc_count * gbsr.actual_rsrc_usage) * TX_RECURSO_PMAC.TX_RECURSO_PMAC TOT_CONS_REAL_RECURSO_PMAC
,((GMD2.ACTUAL_QTY / GMD2.PLAN_QTY) * (gbsr.actual_rsrc_count * gbsr.actual_rsrc_usage)) * TX_RECURSO_PMAC.TX_RECURSO_PMAC TOT_CONS_PROP_RECURSO_PMAC
,(gbsr.actual_rsrc_count * gbsr.actual_rsrc_usage) * TX_RECURSO_PMAC.TX_RECURSO_PMAC TOT_CONS_PLAN_RECURSO_PMAC,GMD2.ACTUAL_QTY * STD_MTL_ITEM_ORDEM.STD_MTL_ITEM_ORDEM TOT_STD_ITEM_OP,GMD2.ACTUAL_QTY * STD_CC_ITEM_ORDEM.STD_CC_ITEM_ORDEM TOT_CC_ITEM_OP
,(GMD2.ACTUAL_QTY * STD_MTL_ITEM_ORDEM.STD_MTL_ITEM_ORDEM) + (GMD2.ACTUAL_QTY * STD_CC_ITEM_ORDEM.STD_CC_ITEM_ORDEM) TOT_STD_OP
,(PMAC_MTL_ITEM_ORDEM.PMAC_MTL_ITEM_ORDEM + PMAC_CC_ITEM_ORDEM.PMAC_CC_ITEM_ORDEM) * GMD2.ACTUAL_QTY TOT_PMAC_OP,0--(PMAC_MTL_ITEM_CONS +PMAC_CC_ITEM_CONS)* GMD.ACTUAL_QTY TOT_PMAC_CONS
FROM apps.MTL_SYSTEM_ITEMS_B MSIB2,apps.GME_MATERIAL_DETAILS GMD2,apps.MTL_CATEGORIES_B MCBI2,apps.MTL_CATEGORY_SETS MCSI2
,apps.MTL_ITEM_CATEGORIES MICI2,APPS.GME_BATCH_HEADER GBH,APPS.GMD_RECIPE_VALIDITY_RULES GRVR,APPS.GMD_RECIPES_B GR,APPS.MTL_PARAMETERS MP
,APPS.MTL_TRANSACTION_REASONS MTR,APPS.GME_MATERIAL_DETAILS GMD,APPS.MTL_SYSTEM_ITEMS_B MSI,apps.MTL_LOT_NUMBERS_ALL_V MLNA
,apps.MTL_MATERIAL_TRANSACTIONS   MMT,apps.MTL_TRANSACTION_LOT_NUMBERS MTLN,apps.MTL_CATEGORIES_B MCBI,apps.MTL_CATEGORY_SETS MCSI,apps.MTL_ITEM_CATEGORIES MICI
,(select SUM(ccd.cmpnt_cost) STD_MTL_ITEM_ORDEM,ccd.ORGANIZATION_ID,GMD2.BATCH_ID,gps.calendar_code,gps.period_code from apps.gmf_period_statuses gps ,apps.cm_cmpt_dtl ccd ,apps.CM_CMPT_MST_B CCMB,apps.MTL_SYSTEM_ITEMS_B MSIB2,apps.GME_MATERIAL_DETAILS GMD2
where ccd.inventory_item_id  = MSIB2.INVENTORY_ITEM_ID AND ccd.organization_id = MSIB2.ORGANIZATION_ID and gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'STD' AND ROWNUM = 1)
and gps.period_id = ccd.period_id AND GMD2.INVENTORY_ITEM_ID  = MSIB2.INVENTORY_ITEM_ID AND GMD2.LINE_TYPE in (1) AND CCMB.COST_CMPNTCLS_ID = CCD.COST_CMPNTCLS_ID
AND CCMB.USAGE_IND = 1 group by ccd.ORGANIZATION_ID ,GMD2.BATCH_ID,gps.calendar_code,gps.period_code) STD_MTL_ITEM_ORDEM,(select SUM(ccd.cmpnt_cost) STD_CC_ITEM_ORDEM,ccd.ORGANIZATION_ID ,GMD2.BATCH_ID,gps.calendar_code,gps.period_code
from apps.gmf_period_statuses gps ,apps.cm_cmpt_dtl ccd ,apps.CM_CMPT_MST_B CCMB,apps.MTL_SYSTEM_ITEMS_B MSIB2,apps.GME_MATERIAL_DETAILS GMD2 where ccd.inventory_item_id  = MSIB2.INVENTORY_ITEM_ID AND ccd.organization_id = MSIB2.ORGANIZATION_ID
and gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'STD' AND ROWNUM = 1) and gps.period_id = ccd.period_id AND GMD2.INVENTORY_ITEM_ID  = MSIB2.INVENTORY_ITEM_ID     
AND GMD2.LINE_TYPE in (1) AND CCMB.COST_CMPNTCLS_ID = CCD.COST_CMPNTCLS_ID AND CCMB.USAGE_IND = 3 group by ccd.ORGANIZATION_ID ,GMD2.BATCH_ID,gps.calendar_code,gps.period_code) STD_CC_ITEM_ORDEM      
,(select SUM(ccd.cmpnt_cost) STD_MTL_ITEM_CONS,gps.calendar_code,gps.period_code,ccd.inventory_item_id,ccd.organization_id
from apps.gmf_period_statuses gps ,apps.cm_cmpt_dtl ccd,apps.CM_CMPT_MST_B CCMB where gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'STD' AND ROWNUM = 1)
and gps.period_id = ccd.period_id AND CCMB.COST_CMPNTCLS_ID = CCD.COST_CMPNTCLS_ID AND CCMB.USAGE_IND = 1 group by gps.calendar_code,gps.period_code,ccd.inventory_item_id,ccd.organization_id) STD_MTL_ITEM_CONS  
,(select SUM(ccd.cmpnt_cost) PMAC_MTL_ITEM_ORDEM,ccd.ORGANIZATION_ID,GMD2.BATCH_ID,gps.calendar_code,gps.period_code,MSIB2.inventory_item_id from apps.gmf_period_statuses gps ,apps.cm_cmpt_dtl ccd   ,apps.CM_CMPT_MST_B CCMB,apps.MTL_SYSTEM_ITEMS_B MSIB2,apps.GME_MATERIAL_DETAILS GMD2
where ccd.inventory_item_id  = MSIB2.INVENTORY_ITEM_ID AND ccd.organization_id = MSIB2.ORGANIZATION_ID
and gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'PMAC' AND ROWNUM = 1) and gps.period_id = ccd.period_id AND GMD2.INVENTORY_ITEM_ID  = MSIB2.INVENTORY_ITEM_ID     
AND GMD2.LINE_TYPE in (1) AND CCMB.COST_CMPNTCLS_ID = CCD.COST_CMPNTCLS_ID AND CCMB.USAGE_IND = 1 group by ccd.ORGANIZATION_ID ,GMD2.BATCH_ID,gps.calendar_code,gps.period_code,MSIB2.inventory_item_id
) PMAC_MTL_ITEM_ORDEM ,(select SUM(ccd.cmpnt_cost) PMAC_CC_ITEM_ORDEM ,ccd.ORGANIZATION_ID,GMD2.BATCH_ID ,gps.calendar_code ,gps.period_code,MSIB2.inventory_item_id from apps.gmf_period_statuses gps 
,apps.cm_cmpt_dtl ccd ,apps.CM_CMPT_MST_B CCMB ,apps.MTL_SYSTEM_ITEMS_B MSIB2 ,apps.GME_MATERIAL_DETAILS GMD2 where ccd.inventory_item_id  = MSIB2.INVENTORY_ITEM_ID AND ccd.organization_id = MSIB2.ORGANIZATION_ID
and gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'PMAC' AND ROWNUM = 1) and gps.period_id = ccd.period_id AND GMD2.INVENTORY_ITEM_ID  = MSIB2.INVENTORY_ITEM_ID  AND GMD2.LINE_TYPE in (1) AND CCMB.COST_CMPNTCLS_ID = CCD.COST_CMPNTCLS_ID
AND CCMB.USAGE_IND = 1 group by ccd.ORGANIZATION_ID ,GMD2.BATCH_ID ,gps.calendar_code ,gps.period_code ,MSIB2.inventory_item_id) PMAC_CC_ITEM_ORDEM      
,(select SUM(ccd.cmpnt_cost) PMAC_MTL_ITEM_CONS ,gps.calendar_code,gps.period_code,ccd.inventory_item_id,ccd.organization_id
from apps.gmf_period_statuses gps ,apps.cm_cmpt_dtl ccd,apps.CM_CMPT_MST_B CCMB       
where gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'PMAC' AND ROWNUM = 1)
and gps.period_id = ccd.period_id AND CCMB.COST_CMPNTCLS_ID = CCD.COST_CMPNTCLS_ID AND CCMB.USAGE_IND = 1
group by gps.calendar_code,gps.period_code,ccd.inventory_item_id,ccd.organization_id) PMAC_MTL_ITEM_CONS  
,(select SUM(ccd.cmpnt_cost) PMAC_CC_ITEM_CONS,gps.calendar_code,gps.period_code,ccd.inventory_item_id,ccd.organization_id
from apps.gmf_period_statuses gps ,apps.cm_cmpt_dtl ccd ,apps.CM_CMPT_MST_B CCMB where gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'PMAC' AND ROWNUM = 1)
and gps.period_id = ccd.period_id  (+) AND CCMB.COST_CMPNTCLS_ID (+) = CCD.COST_CMPNTCLS_ID AND CCMB.USAGE_IND = 1
group by gps.calendar_code,gps.period_code,ccd.inventory_item_id,ccd.organization_id) PMAC_CC_ITEM_CONS
,(select SUM(ccd.cmpnt_cost) STD_CC_ITEM_CONS ,gps.calendar_code,gps.period_code,ccd.inventory_item_id,ccd.organization_id
from apps.gmf_period_statuses gps ,apps.cm_cmpt_dtl ccd ,apps.CM_CMPT_MST_B CCMB where gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'STD' AND ROWNUM = 1) and gps.period_id = ccd.period_id  (+) AND CCMB.COST_CMPNTCLS_ID (+) = CCD.COST_CMPNTCLS_ID
AND CCMB.USAGE_IND = 3 group by gps.calendar_code ,gps.period_code,ccd.inventory_item_id,ccd.organization_id) STD_CC_ITEM_CONS , apps.gme_batch_steps gbs , apps.gmd_operations_vl gov, apps.gme_batch_step_activities gbsa
, apps.gme_batch_step_resources gbsr , apps.cr_rsrc_mst crm, apps.cm_cmpt_mst cmm ,(select crd.nominal_cost TX_RECURSO_STD ,gps.calendar_code ,gps.period_code ,crd.resources ,crd.organization_id from apps.gmf_period_statuses gps 
,apps.CM_RSRC_DTL crd  where gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'STD' AND ROWNUM = 1) and gps.COST_TYPE_ID = crd.COST_TYPE_ID and gps.period_id = crd.period_id  (+)  
) TX_RECURSO_STD ,(select crd.nominal_cost TX_RECURSO_STDTX ,gps.calendar_code ,gps.period_code ,crd.resources ,crd.organization_id from apps.gmf_period_statuses gps 
,apps.CM_RSRC_DTL crd where gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'STD_TX' AND ROWNUM = 1) and gps.COST_TYPE_ID = crd.COST_TYPE_ID and gps.period_id = crd.period_id  (+) ) TX_RECURSO_STDTX
,(select crd.nominal_cost TX_RECURSO_PMAC ,gps.calendar_code ,gps.period_code,crd.resources,crd.organization_id from apps.gmf_period_statuses gps 
,apps.CM_RSRC_DTL crd where gps.COST_TYPE_ID = (SELECT COST_TYPE_ID FROM apps.CM_MTHD_MST WHERE COST_MTHD_CODE = 'PMAC' AND ROWNUM = 1) and gps.COST_TYPE_ID = crd.COST_TYPE_ID and gps.period_id = crd.period_id  (+)) TX_RECURSO_PMAC
,(SELECT CATEGORY_SET_ID CATEGORY_SET_ID FROM APPS.MTL_DEFAULT_CATEGORY_SETS WHERE FUNCTIONAL_AREA_ID = 1 AND ROWNUM = 1) CAT_INV WHERE GBH.RECIPE_VALIDITY_RULE_ID = GRVR.RECIPE_VALIDITY_RULE_ID (+) AND GRVR.RECIPE_ID = GR.RECIPE_ID (+)
AND MTR.REASON_ID (+) = GBH.TERMINATE_REASON_ID AND GBH.ORGANIZATION_ID = MP.ORGANIZATION_ID (+) AND GBH.ORGANIZATION_ID = GR.OWNER_ORGANIZATION_ID AND GBH.ORGANIZATION_ID = GRVR.ORGANIZATION_ID (+) AND GBH.ORGANIZATION_ID = GMD.ORGANIZATION_ID (+)
AND GBH.ORGANIZATION_ID = MSI.ORGANIZATION_ID (+) AND GBH.BATCH_ID = GMD.BATCH_ID (+) AND GMD.INVENTORY_ITEM_ID  = MSI.INVENTORY_ITEM_ID AND MMT.TRANSACTION_SOURCE_ID (+) = GBH.BATCH_ID
AND MTLN.TRANSACTION_ID = MMT.TRANSACTION_ID AND MLNA.INVENTORY_ITEM_ID = MMT.INVENTORY_ITEM_ID AND MLNA.ORGANIZATION_ID = MMT.ORGANIZATION_ID AND MCBI.STRUCTURE_ID = MCSI.STRUCTURE_ID       
AND MCSI.CATEGORY_SET_ID = CAT_INV.CATEGORY_SET_ID AND MICI.CATEGORY_SET_ID = MCSI.CATEGORY_SET_ID AND MICI.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID AND MICI.ORGANIZATION_ID = MSI.ORGANIZATION_ID AND MICI.CATEGORY_ID = MCBI.CATEGORY_ID      
AND GMD.LINE_TYPE in (-1) and GBH.ORGANIZATION_ID = STD_MTL_ITEM_ORDEM.ORGANIZATION_ID AND GBH.BATCH_ID = STD_MTL_ITEM_ORDEM.BATCH_ID (+) and STD_MTL_ITEM_ORDEM.calendar_code LIKE '%'||to_char(GBH.plan_start_date,'RRRR')||'%'
and STD_MTL_ITEM_ORDEM.period_code  = to_char(GBH.plan_start_date,'MM') and GBH.ORGANIZATION_ID = STD_CC_ITEM_ORDEM.ORGANIZATION_ID           
AND GBH.BATCH_ID = STD_CC_ITEM_ORDEM.BATCH_ID (+) and STD_CC_ITEM_ORDEM.calendar_code LIKE '%'||to_char(GBH.plan_start_date,'RRRR')||'%' and STD_CC_ITEM_ORDEM.period_code  = to_char(GBH.plan_start_date,'MM') and STD_MTL_ITEM_CONS.calendar_code LIKE '%'||to_char(GBH.plan_start_date,'RRRR')||'%' 
and STD_MTL_ITEM_CONS.period_code = to_char(GBH.plan_start_date,'MM') and STD_MTL_ITEM_CONS.inventory_item_id = msi.inventory_item_id and STD_MTL_ITEM_CONS.organization_id = msi.organization_id and STD_CC_ITEM_CONS.inventory_item_id (+) = msi.inventory_item_id and STD_CC_ITEM_CONS.organization_id (+) = msi.organization_id AND gbh.batch_id = gbsa.batch_id
AND gbsr.batchstep_activity_id = gbsa.batchstep_activity_id AND gbs.batchstep_id = gbsa.batchstep_id AND gbs.oprn_id = gov.oprn_id AND gbsr.resources = crm.resources AND crm.cost_cmpntcls_id = cmm.cost_cmpntcls_id
AND cmm.usage_ind = 3 AND cmm.product_cost_ind = 1 and TX_RECURSO_STD.calendar_code LIKE '%'||to_char(GBH.plan_start_date,'RRRR')||'%' and TX_RECURSO_STD.period_code = to_char(GBH.plan_start_date,'MM') and TX_RECURSO_STD.resources (+) = gbsr.resources and TX_RECURSO_STD.organization_id = msi.organization_id and TX_RECURSO_STDTX.resources = gbsr.resources              
and TX_RECURSO_STDTX.organization_id (+) = msi.organization_id and TX_RECURSO_PMAC.resources = gbsr.resources and TX_RECURSO_PMAC.organization_id (+) = msi.organization_id
AND GRVR.RECIPE_VALIDITY_RULE_ID = DECODE((SELECT COUNT(*)  FROM apps.GMD_RECIPE_VALIDITY_RULES WHERE  RECIPE_ID = GRVR.RECIPE_ID AND PREFERENCE = 1),1,(SELECT RECIPE_VALIDITY_RULE_ID
FROM apps.GMD_RECIPE_VALIDITY_RULES WHERE RECIPE_ID = GRVR.RECIPE_ID AND PREFERENCE = 1),(SELECT RECIPE_VALIDITY_RULE_ID
FROM apps.GMD_RECIPE_VALIDITY_RULES WHERE RECIPE_ID = GRVR.RECIPE_ID AND PREFERENCE = 1 AND CREATION_DATE = (SELECT MIN(CREATION_DATE) FROM apps.GMD_RECIPE_VALIDITY_RULES WHERE RECIPE_ID = GRVR.RECIPE_ID 
AND PREFERENCE = 1))) AND  GBH.ORGANIZATION_ID = MSIB2.ORGANIZATION_ID AND GMD2.INVENTORY_ITEM_ID  = MSIB2.INVENTORY_ITEM_ID AND GMD2.LINE_TYPE in (1)     
AND GBH.ORGANIZATION_ID = GMD2.ORGANIZATION_ID (+) AND GBH.BATCH_ID = GMD2.BATCH_ID (+) AND MCBI2.STRUCTURE_ID = MCSI2.STRUCTURE_ID AND MCSI2.CATEGORY_SET_ID = CAT_INV.CATEGORY_SET_ID
AND MICI2.CATEGORY_SET_ID = MCSI2.CATEGORY_SET_ID AND MICI2.INVENTORY_ITEM_ID = MSIB2.INVENTORY_ITEM_ID AND MICI2.ORGANIZATION_ID = MSIB2.ORGANIZATION_ID AND MICI2.CATEGORY_ID = MCBI2.CATEGORY_ID     
and PMAC_MTL_ITEM_ORDEM.calendar_code LIKE '%'||to_char(GBH.plan_start_date,'RRRR')||'%' and PMAC_MTL_ITEM_ORDEM.period_code = to_char(GBH.plan_start_date,'MM')
and PMAC_MTL_ITEM_ORDEM.organization_id (+) = GBH.ORGANIZATION_ID AND GBH.BATCH_ID = PMAC_MTL_ITEM_ORDEM.BATCH_ID (+)  
and PMAC_CC_ITEM_ORDEM.calendar_code LIKE '%'||to_char(GBH.plan_start_date,'RRRR')||'%' and PMAC_CC_ITEM_ORDEM.period_code = to_char(GBH.plan_start_date,'MM')
and PMAC_CC_ITEM_ORDEM.organization_id (+) = GBH.ORGANIZATION_ID AND GBH.BATCH_ID = PMAC_CC_ITEM_ORDEM.BATCH_ID (+)
and PMAC_MTL_ITEM_CONS.calendar_code LIKE '%'||to_char(GBH.plan_start_date,'RRRR')||'%' and PMAC_MTL_ITEM_CONS.period_code = to_char(GBH.plan_start_date,'MM')
and PMAC_MTL_ITEM_CONS.inventory_item_id (+) = msi.inventory_item_id and PMAC_MTL_ITEM_CONS.organization_id (+) = msi.organization_id
and PMAC_CC_ITEM_CONS.calendar_code LIKE '%'||to_char(GBH.plan_start_date,'RRRR')||'%' and PMAC_CC_ITEM_CONS.period_code = to_char(GBH.plan_start_date,'MM')
and PMAC_CC_ITEM_CONS.inventory_item_id (+) = msi.inventory_item_id and PMAC_CC_ITEM_CONS.organization_id (+) = msi.organization_id