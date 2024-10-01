select
    --'cross_bu',-- ||'|'||--"Tipo de Registro",
    hcasa.orig_system_reference "Codigo do Cliente",
    hp.party_name "Cliente",
    SALES_CHANNEL "Canal de Venda",
    (select organization_code from apps.mtl_parameters where organization_id = xocba.warehouse_id) "Cod Estabelecimento",
    (select distinct name from apps.qp_list_headers_all where list_header_id = xocba.price_list_id)"Cod Lista Preço",
    (select distinct name from apps.ra_terms_tl where term_id = xocba.payment_term_id) "Cond Pagamento",
    CUSTOMER_TYPE "Tipo de Cliente",
    ACTIVITY_BRANCH "Cod Ramo Atividade",
    ACTIVITY_SUBBRANCH "Cod Sub",
    CUSTOMER_CLASS "Categoria Cliente",
    (select distinct ship_method_code_meaning from apps.wsh_carrier_ship_methods_v a where ship_method_code = xocba.ship_method_code) "Cod Trasnportadora",
    (select b.name 
        from apps.oe_transaction_types_all a, 
             apps.oe_transaction_types_tl b
        where b.language = 'PTB'
          and a.transaction_type_id = b.transaction_type_id
          and a.transaction_type_code = 'ORDER'
          and a.transaction_type_id = xocba.order_type_id
     ) "Natureza Operacao",
    (select jrs.salesrep_number  
      from apps.jtf_rs_salesreps jrs, 
           apps.jtf_rs_resource_extns jrre
       where jrs.resource_id = jrre.resource_id
         and jrre.category <> 'OTHER'
         and jrs.salesrep_id = xocba.salesrep_id
      ) "Codigo Representante",
    (select jrre.source_name contato  
      from apps.jtf_rs_salesreps jrs, 
           apps.jtf_rs_resource_extns jrre
       where jrs.resource_id = jrre.resource_id
         and jrre.category <> 'OTHER'
         and jrs.salesrep_id = xocba.salesrep_id
      )"File"
from apps.xxppg_om_cross_bu_all xocba,
     apps.hz_parties hp,
     apps.hz_cust_acct_sites_all hcasa
where xocba.party_id = hp.party_id
  and xocba.cust_acct_site_id = hcasa.cust_acct_site_id
