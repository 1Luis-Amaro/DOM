
SELECT *
  FROM apps.cll_f189_entry_operations reo,
       apps.cll_f189_invoices         ri,
       apps.cll_f189_invoice_types    rit,
       APPS.CLL_F189_INVOICE_PARENTS  cfip,
       APPS.CLL_F189_INVOICES         ri_m,
       APPS.CLL_F189_INVOICE_LINES    ri_mln
 WHERE 1 = 1 
   AND ri.organization_id  = reo.organization_id
   AND ri.operation_id     = reo.operation_id
   AND rit.invoice_type_id = ri.invoice_type_id
   AND invoice_type_code  LIKE 'E_FRETE_IMPORT'
   AND reo.creation_date  >= SYSDATE - 30 
   --
   AND cfip.invoice_id     = ri.invoice_id
   AND ri_m.invoice_id     = cfip.INVOICE_PARENT_ID 
   and ri_mln.invoice_id   = ri_m.invoice_id
   order by 3;
  -- AND rfea.entity_id(+) = ri.entity_id
  -- AND pvsa.vendor_site_id(+) = rfea.vendor_site_id
  -- AND pv.vendor_id(+) = pvsa.vendor_id
  -- AND ril.invoice_id(+) = ri.invoice_id
  -- AND msi.inventory_item_id(+) = ril.item_id
  -- AND msi.organization_id(+) = ril.organization_id
  -- AND hl.location_id(+) = reo.location_id
  -- AND rcv.entity_id(+) = ri.entity_id
  -- AND cff.operation_id(+) = reo.operation_id
  -- AND cff.organization_id(+) = reo.organization_id
  -- AND rfea.cust_acct_site_id = hcas.cust_acct_site_id(+)
  -- AND hcas.party_site_id = hps.party_site_id(+)
  -- AND hps.location_id = hzl.location_id(+)
  -- AND rfea.vendor_site_id = pvsa.vendor_site_id(+)
  -- AND ool.line_id(+) = ril.rma_interface_id;

rit.invoice_type_code;

invoice_type_code LIKE 'E_FRETE_IMPORT';


SELECT rip.attribute3                           Processo,
       mp.organization_code                     Org,
       trunc(reo.receive_date)                  Data_entrada_NF,
       trunc(ri.invoice_date)                   Data_Emissao_NF,
       ri.operation_id                          RI,
       ri.invoice_num                           Nota_fiscal, 
       invoice_type_code                        Tipo_NF,
       NVL (asu.vendor_name, cfc.customer_name) Fornecedor,
       msi.segment1                             Produto,
       cfil.icms_amount                         vlr_icms,
       cfil.icms_amount_recover                 vlr_icms_recuperado,
       cfil.ipi_amount                          vlr_ipi,
       cfil.ipi_amount_recover                  vlr_ipi_recuperado,
       0                                        pis_importacao,
       cfil.pis_amount_recover                  lr_pis_recuperado,
       0                                        cofins_importacao,
       cfil.cofins_amount_recover               vlr_cofins_recuperado,
       cfil.importation_tax_amount              imposto_importacao,
       cfil.freight_internacional               frete_internacional,
       cfil.import_other_val_not_icms           outros_base_icms,
       0                                        ii ,
       cfil.FOB_AMOUNT                          valor_fob,
       cfil.NET_AMOUNT                          vlr_total,
       0                                        vlr_custo_frete,
       cfil.uom                                 unidade_medida,
       0                                        qtde,
       0                                        qtd_devol,
       pha.segment1                             PO,
       pha.org_id                               org_id_po,
       'po'                                     Tipo_doc,
       msi.primary_uom_code                     unidade_medida_SVC,
       0                                        Conversao,
       0                                        qtd_svc,                                                                   
       0                                        valor_unitario,
       cfil.TOTAL_AMOUNT                        valor_total,            
       'SIM'                                    recebimento_fisico,
       0                                        svc,
    TRANSLATE(TRANSLATE(SUBSTR(msi.description,1,180),'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890—¡…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’ƒÀœ÷‹«Ò·ÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚„ı‰ÎÔˆ¸Áñ∫™≤∞.-!"''`#$%().:[/]{}®+???ø;ß&¥*<>'
                                                    ,'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz01234567890NAEIOUAEIOUAEIOUAOAEIOUCnaeiouaeiouaeiouaoaeiouc-'),CHR(10),' ') description,
       (SELECT mc.segment1 || '.' || mc.segment2 || '.' || mc.segment3
          FROM apps.MTL_ITEM_CATEGORIES mic,
               apps.MTL_CATEGORIES mc
         WHERE mc.category_id        = mic.category_id
           AND mic.category_set_id   = 1
           AND mic.organization_id   = msi.organization_id
           AND mic.inventory_item_id = msi.inventory_item_id) categoria_item
  FROM apps.cll_f189_entry_operations     reo,
       apps.cll_f189_invoices             ri,
       APPS.CLL_F189_INVOICE_LINES        cfil,
       apps.cll_f189_invoice_types        rit,
       APPS.CLL_F189_INVOICE_PARENTS      cfip,
       apps.CLL_F189_INVOICE_LINE_PARENTS cfilnp,
       APPS.CLL_F189_INVOICE_LINES        cfilp,
       apps.cll_f189_invoices             rip,
       apps.mtl_system_items_b            msi,
       apps.mtl_parameters                mp,
       apps.cll_f189_fiscal_entities_all  cffe,
       apps.ap_supplier_sites_all         assa,
       apps.ap_suppliers                  asu,
       apps.cll_f189_customers_v          cfc,
       apps.po_headers_all                pha,
       apps.po_line_locations_all         plla
WHERE 1 = 1 
   AND cffe.entity_id(+)        = ri.entity_id
   AND assa.vendor_site_id(+)   = cffe.vendor_site_id    
   AND asu.vendor_id(+)         = assa.vendor_id
   AND cfc.entity_id(+)         = ri.entity_id
   AND mp.organization_id       = ri.organization_id
   AND ri.organization_id       = reo.organization_id
   AND ri.operation_id          = reo.operation_id
   AND rit.invoice_type_id      = ri.invoice_type_id
   AND invoice_type_code      LIKE 'E_FRETE_IMPORT' 
   AND ri.organization_id       = 92           -- Change to use concurrent parameter
   AND reo.creation_date       >= SYSDATE - 180 -- Change to use concurrent parameter
   AND reo.creation_date       <= SYSDATE      -- Change to use concurrent parameter
   --AND ri.operation_id          = 370038 -- Used to select just on freight invoice for testing 
   AND plla.line_location_id(+) = cfilp.line_location_id
   AND pha.po_header_id         = plla.po_header_id
   AND cfip.invoice_id          = ri.invoice_id
   AND cfilnp.parent_id         = cfip.parent_id
   AND cfil.invoice_line_id     = cfilnp.invoice_line_id --cfilnp.INVOICE_PARENT_LINE_ID
   AND cfilp.invoice_line_id    = cfilnp.INVOICE_PARENT_LINE_ID
   AND rip.invoice_id           = cfilp.invoice_id   
   AND msi.inventory_item_id    = cfilp.item_id 
   AND msi.organization_id      = ri.organization_id order by 3,1;
   
select * from APPS.CLL_F189_INVOICE_PARENTs  cfip;   

select * from apps.CLL_F189_INVOICE_LINE_PARENTS where parent_id = 48414;

select * from apps.rcv_transactions              rt;
select * from apps.cll_f189_invoices ri where ri.operation_id       = 9086 ;

select * from apps.cll_f189_entry_operations ;