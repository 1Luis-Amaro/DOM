SELECT DISTINCT 'person_id:'||app_person_id FROM (
WITH po AS (
SELECT suggested_buyer_id,p_supply, 
       CASE WHEN currency_code = 'USD' THEN 
            round(total,2) 
       ELSE  
            round( (total*rate)/NVL(APPS.XXPPG_HR_UTIL_PKG.CONVERSION_RATE_NEW(TO_DATE(rate_date)),1),2)
       END tot_po 
      ,total
      ,NVL(APPS.XXPPG_HR_UTIL_PKG.CONVERSION_RATE_NEW(TO_DATE(rate_date)),1) rate
      ,NVL((SELECT CASE WHEN b.currency_code = 'USD' THEN 
                    round(b.total,2) 
               ELSE  
                    round( (b.total*b.rate)/NVL(APPS.XXPPG_HR_UTIL_PKG.CONVERSION_RATE_NEW(TO_DATE(b.rate_date)),1),2)
               END tot_po 
          FROM( SELECT trunc(pha.creation_date) rate_date
                      ,round(SUM((plla.quantity - Nvl(plla.quantity_cancelled, 0))*plla.price_override),2) total
                      ,pha.currency_code, NVL(pha.rate,1) rate                      
                 FROM po.po_headers_archive_all pha, po.po_lines_archive_all pla, po.po_line_locations_archive_all plla
                WHERE pha.po_header_id = pla.po_header_id 
                  AND pla.po_line_id = plla.po_line_id
                  AND pha.type_lookup_code = 'STANDARD'
                  AND pha.po_header_id = oc.po_header_id
                  AND pha.revision_num = pla.revision_num
                  AND pha.revision_num = plla.revision_num  
                  AND pha.revision_num = oc.revision_num-1   
                GROUP BY trunc(pha.creation_date) 
                       , pha.revision_num
                       , pha.type_lookup_code
                       , pha.po_header_id
                       , pha.ame_approval_id
                       , pha.currency_code
                       , NVL(pha.rate,1)
              ) b ),0) Valor_Anterior
  FROM(SELECT trunc(ph.creation_date) rate_date, nvl(prl.suggested_buyer_id, ph.agent_id) suggested_buyer_id
             ,round(SUM((pd.quantity_ordered - Nvl(pd.quantity_cancelled, 0))*pll.price_override),2) total
             ,ph.currency_code, NVL(ph.rate,1) rate, ph.revision_num,ph.po_header_id
             ,CASE WHEN prh.interface_source_code = 'MSC' THEN 'Y' ELSE NULL END p_supply
        FROM  po.po_headers_all ph, po.po_lines_all pl, po.po_line_locations_all pll
        ,     po.po_distributions_all pd, po.po_req_distributions_all prd
        ,     po.po_requisition_lines_all prl, po.po_requisition_headers_all prh
        WHERE ph.po_header_id = pl.po_header_id AND pl.po_line_id = pll.po_line_id
          AND pll.line_location_id = pd.line_location_id AND ph.type_lookup_code = 'STANDARD'
          AND pd.req_distribution_id = prd.distribution_id(+)
          AND prd.requisition_line_id = prl.requisition_line_id(+)
          AND prl.requisition_header_id = prh.requisition_header_id(+)          
          AND ph.ame_approval_id = :transactionId        
       GROUP BY trunc(ph.creation_date) , ph.type_lookup_code, ph.po_header_id, ph.revision_num,ph.ame_approval_id, nvl(prl.suggested_buyer_id, ph.agent_id),ph.agent_id, ph.currency_code, NVL(ph.rate,1),CASE WHEN prh.interface_source_code = 'MSC' THEN 'Y' ELSE NULL END
      ) oc
   )
SELECT DISTINCT apps.XXPPG_HR_UTIL_PKG.GET_APPROVER_NEW(po.suggested_buyer_id, po.tot_po,'ass_attribute13',po.p_supply) app_person_id, tot_po, valor_anterior
FROM po where (tot_po - valor_anterior)>0)

--transactionId  - Informação da tabela po_headers_all ph


update po.po_requisition_lines_all
   set suggested_buyer_id = 818
 where requisition_header_id = 772701;
 
select suggested_buyer_id from po.po_requisition_lines_all
   --SET suggested_buyer_id = 818
 WHERE requisition_header_id = 772701;
-- Lines updated: 1
 


SELECT * from PER_PEOPLE_V7 where person_id = 473--61;

SELECT * from PER_PEOPLE_V7 where last_name like '%BOZI%';--61;

473

818