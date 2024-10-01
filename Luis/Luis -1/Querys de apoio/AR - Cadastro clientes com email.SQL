/* Formatted on 29/7/2015 16:52:28 (QP5 v5.267.14150.38573) */
  SELECT DISTINCT
         cas.org_id AS "id_organization",
         C.NAME AS "NOME ORGANIZACAO",
         P.PARTY_ID AS "ID CLIENTE",
         PS.PARTY_SITE_ID AS "ID SITE DO CLIENTE",
         p.party_name AS "NOME DO CLIENTE",
         PS.PARTY_SITE_NAME AS "SITE NAME",
         PS.PARTY_SITE_NUMBER AS "PARTY_SITE_NUMBER",
            LOC.ADDRESS1
         || ' NRO. '
         || LOC.ADDRESS2
         || ' - COMPLEMENTO - '
         || LOC.ADDRESS3
            AS "Endereço",
         LOC.CITY AS "CIDADE",
         LOC.STATE AS "ESTADO",
         LOC.Postal_CODE AS "CEP"                                           --
                                 ,
         '' AS "Grupo de Pagamento",
         '' AS "Aplica Imposto",
         DECODE (cas.GLOBAL_ATTRIBUTE2,  '1', 'CPF',  '2', 'CNPJ',  'OUTROS')
            AS "1-CPF, 2-CNPJ, 3-OUTROS",
            cas.GLOBAL_ATTRIBUTE3
         || '/'
         || cas.GLOBAL_ATTRIBUTE4
         || '-'
         || cas.GLOBAL_ATTRIBUTE5
            AS "DOCUMENTO",
         cas.GLOBAL_ATTRIBUTE6 AS "Inscricao Estadual",
         cas.GLOBAL_ATTRIBUTE7 AS "Inscricao Municipal",
         '' AS "Tipo de Contribuiente",
         cp.email_format AS "Email Format",
         cp.email_address AS "E-MAIL",
         cp.phone_area_code AS "telefone area",
         cp.phone_number AS "telefone numero",
         '' AS "fax area",
         '' AS "fax numero",
         ca.cust_account_id customer_id,
         csu.site_use_id,
         --
         p.attribute3 ramo_atividade,
         ca.sales_channel_code,
         (SELECT salesrep_number
            FROM apps.jtf_rs_salesreps
           WHERE salesrep_id = csu.primary_salesrep_id)
            num_vendedor,
         (SELECT resource_name
            FROM apps.JTF_RS_DEFRESOURCES_V a, apps.jtf_rs_salesreps b
           WHERE     b.salesrep_id = csu.primary_salesrep_id
                 AND b.resource_id = a.resource_id)
            nome_vendedor
    FROM apps.hz_parties p,
         apps.hz_party_sites ps,
         apps.hz_contact_points cp,
         apps.hz_cust_acct_sites_all cas,
         apps.hz_cust_accounts ca,
         apps.hz_cust_site_uses_all csu,
         apps.HR_ALL_ORGANIZATION_UNITS C,
         apps.hz_locations loc
   WHERE     p.party_id = ca.party_id(+)
         AND p.party_id = ps.party_id(+)
         AND ps.party_site_id = cas.party_site_id(+)
         AND ps.party_site_id = cp.owner_table_id(+)
         AND cp.owner_table_name(+) = 'HZ_PARTY_SITES'
         AND cp.contact_point_type(+) = 'EMAIL'
         --  AND cp.primary_flag = 'Y'
         AND cas.org_id = C.ORGANIZATION_ID
         AND PS.LOCATION_ID = LOC.LOCATION_ID
         AND cas.cust_acct_site_id = csu.cust_acct_site_id
         --
         --  and p.party_name like 'MR 7%'
         AND csu.site_use_code = 'SHIP_TO'
ORDER BY cas.org_id,
         p.party_name,
         P.PARTY_ID,
         PS.PARTY_SITE_ID
