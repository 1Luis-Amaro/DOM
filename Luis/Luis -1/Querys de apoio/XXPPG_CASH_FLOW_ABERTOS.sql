SELECT (pvsa.global_attribute10
  ||pvsa.global_attribute11
  ||pvsa.global_attribute12)                          AS codigo_fornecedor,
  pv.vendor_name                                      AS razao_social,
  pv.attribute1                                       AS grupo,
  aia.invoice_num                                     AS nr_nf,
  aia.invoice_currency_code                           AS moeda,
  aia.invoice_date                                    AS emissao,
  apsa.due_date                                       AS vencimento,
  aia.creation_date                                   AS criacao,
  aia.invoice_amount                                  AS valor_nf,
  apsa.amount_remaining                               AS saldo_nf,
  aia.exchange_rate                                   AS taxa_cambio_impl,
  (aia.invoice_amount    * nvl(aia.exchange_rate, 1)) AS valor_nf_brl,
  (apsa.amount_remaining * nvl(aia.exchange_rate,1))  AS saldo_nf_brl
FROM apps.ap_payment_schedules_all apsa ,
  apps.po_vendors pv ,
  apps.po_vendor_sites_all pvsa ,
  apps.ap_invoices_all aia ,
  apps.ap_system_parameters_all aspa
WHERE 1=1
AND aia.org_id             = 82
AND pv.vendor_id           = aia.vendor_id
AND apsa.invoice_id        = aia.invoice_id
AND apsa.org_id            = aspa.org_id
AND pv.vendor_id           = pvsa.vendor_id
AND aia.vendor_site_id     = pvsa.vendor_site_id
AND aia.invoice_amount    != 0
AND apsa.amount_remaining != 0