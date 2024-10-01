select msi.segment1,
       CATEGORY_CONCAT_SEGS
  from apps.mtl_item_categories_v mit,
       apps.mtl_system_items_b    msi
 where category_set_name = 'SEMI ELABORADO' and
       msi.organization_id = 87 and
       msi.inventory_item_id = mit.inventory_item_id and
       msi.organization_id   = mit.organization_id;
       
       
SELECT DISTINCT ACCT_SITE_ID, ORG_ID, NF, STATUS
  FROM apps.XXPPG_INV_CTRL_SALDO_NF_TERC_V
 --WHERE SALDO_TERC > 0)
 WHERE acct_site_id <> 0 --= :$FLEX$.CUST_ACCT_SITE_ID     
   AND org_id = 86 --:$FLEX$.ORGANIZATION_ID
   AND status = 'OP' and nf = 271158; --'288993';
       
select entity_id, invoice_id, cfi.*
  from apps.CLL_F189_INVOICES cfi
 where cfi.invoice_id = 740087; --740127;   
 
select attribute2
  from apps.CLL_F189_INVOICE_LINES
 where invoice_id = 740087; --740127;
 
SELECT nvl(cfea.cust_acct_site_id, cfea.vendor_site_id)
        --INTO   l_cust_acct_site_id
        FROM   apps.cll_f189_invoices            cfi
              ,apps.cll_f189_fiscal_entities_all cfea
              ,apps.po_vendor_sites_all          pvs
              ,apps.hz_cust_acct_sites_all       hcasa
        WHERE  cfea.vendor_site_id = pvs.vendor_site_id(+)
        AND    cfea.cust_acct_site_id = hcasa.cust_acct_site_id(+)
        AND    cfea.entity_id = 1039 --18410 --cfi.entity_id
        AND    cfi.invoice_id = 740087; --p_invoice_id; 
 
select * from apps.cll_f189_fiscal_entities_all cfea
 where cfea.entity_id in (13413,1039);

SELECT 'Y' 
  FROM apps.cll_f189_invoices ri
     , apps.cll_f189_invoice_types rit
     , apps.fnd_lookup_values flv
 WHERE ri.invoice_type_id  = rit.invoice_type_id  
   AND ri.organization_id  = rit.organization_id
   AND ri.invoice_id       = :REC_INVOICE_LINES.INVOICE_ID              
   AND flv.language        = 'PTB'
   AND flv.lookup_type     = 'XXPPG_RI_OPERACOES_TERCEIRO'
   AND flv.lookup_code     = NVL(rit.attribute1,'X');
   
   AND :REC_INVOICE_LINES.ATTRIBUTE1 IS NULL ;

 xxppg_inv_controle_terceiro_pk.get_entity_id(:rec_invoices.invoice_id,'RI';
 
SELECT 'Y'
         FROM apps.cll_f189_invoices ri
            , apps.cll_f189_invoice_types rit
            , apps.fnd_lookup_values flv
       WHERE ri.invoice_type_id  = rit.invoice_type_id  
         AND ri.organization_id  = rit.organization_id
         AND ri.invoice_id       = :REC_INVOICE_LINES.INVOICE_ID              
         AND flv.language        = 'PTB'
         AND flv.lookup_type     = 'XXPPG_RI_OPERACOES_TERCEIRO'
         AND flv.lookup_code     = NVL(rit.attribute1,'X') 
         AND :REC_INVOICE_LINES.ATTRIBUTE1 IS NOT NULL
         AND NVL(:REC_INVOICE_LINES.DSP_ITEM_ID,'0') <> NVL((SELECT CODIGO_ITEM FROM XXPPG_INV_CONTROLE_TERCEIRO_V WHERE ID = :REC_INVOICE_LINES.ATTRIBUTE1 ),'0');