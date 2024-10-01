select distinct cfheo.sequence_num "NUM SEQUENCIA",
       cfheo.operation_id "NUM RI",
       CFI.INVOICE_NUM "NUM NF",
       ood.organization_code FILIAL,
       FU.USER_NAME "CRIADO POR",
       cfheo.pre_status "PRE-ETAPA",
       cfheo.post_status "ETAPA PROCESSO",
       cfheo.creation_date "DATA CRIACAO",
       cfeo.STATUS "STATUS RI",
       AP.vendor_name FORNECEDOR,
       CFFEA.document_number CNPJ
  from apps.cll_f189_hist_entry_operations cfheo,
       apps.cll_f189_entry_operations cfeo,
       apps.org_organization_definitions ood,
       APPS.CLL_F189_INVOICES CFI,
       APPS.cll_f189_fiscal_entities_all CFFEA,
       APPS.ap_supplier_sites_all ASSA,
       apps.FND_USER FU,
       APPS.ap_suppliers AP
 where cfheo.organization_id = ood.organization_id
   and cfeo.operation_id = cfheo.operation_id
   and cfeo.organization_id = cfheo.organization_id
   AND CFI.operation_id = CFEO.operation_id 
   AND CFI.organization_id = CFEO.organization_id
   AND CFI.entity_id = CFFEA.entity_id
   AND ASSA.vendor_site_id = CFFEA.vendor_site_id
   AND AP.vendor_id = ASSA.vendor_id
-- and cfheo.operation_id = :operation_id
--   and ood.organization_code = :organization_code
--   and cfeo.receive_date between to_date(:start_date,'DD-MON-YYYY') and to_date(:end_date,'DD-MON-YYYY')
   AND CFEO.CREATED_BY = FU.USER_ID
-- and cfheo.pre_status <> cfheo.post_status
   and cfeo.status = 'COMPLETE'
order by cfheo.operation_id,cfheo.sequence_num,ood.organization_code,cfheo.pre_status,cfheo.post_status,cfheo.creation_date asc