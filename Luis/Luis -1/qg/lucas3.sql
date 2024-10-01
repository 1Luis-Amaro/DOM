240663806
select shipment_costed, organization_id, opm_costed_flag, t.* FROM APPS.mtl_material_transactions t
WHERE OPM_COSTED_FLAG = 'D' and
      organization_id = 92 and
      program_id = 48093 and
      subinventory_code = 'DHL' and
      transaction_type_id = 33 and
    --(trunc(transaction_date)    = to_date('08/06/2017','dd/mm/rrrr') or  
      transaction_id in (244570015, 240663806)