/* Formatted on 26/02/2015 09:26:05 (QP5 v5.227.12220.39724) */
  SELECT ood.organization_code,
         cfeo.operation_id,
         cfeo.receive_date,
         cfeo.gl_date,
         cfeo.status,
         cfit.invoice_type_code,
         cfit.description,
   --      cfeo.last_updated_by,
         u.USER_NAME Usuario,
         u.description Nome
    FROM cll.cll_f189_entry_operations cfeo,
         apps.org_organization_definitions ood, 
         cll.cll_f189_invoices cfi,
         cll.cll_f189_invoice_types cfit,
         APPS.FND_USER  u
   WHERE cfeo.organization_id = ood.organization_id AND
         CFEO.STATUS <> 'COMPLETE'                  and
         CFEO.OPERATION_ID   = cfi.operation_id     and
         cfi.organization_id = cfeo.organization_id and
         CFI.INVOICE_TYPE_ID = cfit.invoice_type_id and
         u.USER_ID           = cfeo.last_updated_by
ORDER BY 1, 2