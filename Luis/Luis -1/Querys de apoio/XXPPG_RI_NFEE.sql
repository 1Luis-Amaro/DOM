SELECT count(*)                 qtd  
              ,ood.organization_code    filial
              ,cfit.invoice_type_code   tipo_nf 
              ,fu.user_name
              ,fu.description
              ,cfi.creation_date 
          FROM apps.cll_f189_invoices               cfi
              ,apps.cll_f189_invoices_interface     cfii 
              ,apps.cll_f189_entry_operations       cfeo 
              ,apps.org_organization_definitions    ood
              ,apps.cll_f189_invoice_types          cfit
              ,apps.fnd_user                        fu
         WHERE 1=1
           AND cfi.organization_id  = ood.organization_id
           AND cfi.organization_id  = cfii.organization_id
           AND cfi.location_id      = cfii.location_id
           AND cfi.entity_id        = cfii.entity_id
           AND cfi.invoice_num      = cfii.invoice_num
           AND cfi.series           = cfii.series
           AND cfi.operation_id     = cfeo.operation_id
           AND cfi.organization_id  = cfeo.organization_id
           AND cfi.location_id      = cfeo.location_id
           AND cfit.organization_id = cfi.organization_id
           AND cfit.invoice_type_id = cfi.invoice_type_id
           AND cfi.created_by       = fu.user_id
           AND cfeo.status          = 'COMPLETE' 
           AND cfii.source          = 'NFEE'
           AND cfii.process_flag    = 6
           --AND TRUNC(cfi.creation_date)   >= TO_DATE('01/09/2016', 'DD/MM/YYYY')
         GROUP BY ood.organization_code
                 ,cfit.invoice_type_code
                 ,fu.user_name
                 ,fu.description
                 ,cfi.creation_date
order by 2,3,4