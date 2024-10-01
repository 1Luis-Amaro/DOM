select distinct trunc(creation_date) "Date",
       count(creation_date) over(PARTITION BY trunc(creation_date)) "registros" 
  from apps.gme_batch_header
 where creation_date >= trunc(sysdate - 38)
  order by trunc(creation_date);
  
select distinct trunc(cfi.creation_date) "Date",
       count(cfi.creation_date) over(PARTITION BY trunc(cfi.creation_date)) "registros" 
  from apps.cll_f189_invoices      cfi,
       apps.cll_f189_invoice_lines cfil
 where cfi.creation_date >= trunc(sysdate - 38) and
       cfil.invoice_id       = cfi.invoice_id   and
       cfil.organization_id  = cfi.organization_id
  order by trunc(cfi.creation_date);  