------- Nome do Arquivo ----------------
SELECT 'M2017JUN98765432000199.txt',
       'M' ||
       to_char(sysdate,'yyyy') ||
       flv.tag ||
       (select cffea.DOCUMENT_NUMBER
         from mtl_parameters                    mp,
              apps.hr_locations_all             hla,
              apps.cll_f189_fiscal_entities_all cffea
        where mp.organization_id            = 92                 AND
              hla.inventory_organization_id = mp.organization_id AND
              hla.location_id               = cffea.location_id  AND
              cffea.entity_type_lookup_code = 'LOCATION') ||
       '.txt' file_name
   FROM apps.fnd_lookup_values_vl flv
 WHERE flv.lookup_type = 'XXPPG_1079_PF_MES' and
       flv.lookup_code = to_char(sysdate,'mm');

------- Seção cabeçalho do arquivo -----
SELECT 'EM' ||
       (select cffea.DOCUMENT_NUMBER
         from mtl_parameters                    mp,
              apps.hr_locations_all             hla,
              apps.cll_f189_fiscal_entities_all cffea
        where mp.organization_id            = 92                 AND
              hla.inventory_organization_id = mp.organization_id AND
              hla.location_id               = cffea.location_id  AND
              cffea.entity_type_lookup_code = 'LOCATION') ||
       flv.tag ||
       to_char(sysdate,'yyyy') ||
       '11001000'                   "Identificação da Empresa/Mapa (EM)"
  FROM apps.fnd_lookup_values_vl flv
 WHERE flv.lookup_type = 'XXPPG_1079_PF_MES' and
       flv.lookup_code = to_char(sysdate,'mm');
/*
1 - Comercialização Nacional 24, 1 Numérico 1 ou 0 (1 se "sim" ou 0 se "não")
1 - Comercialização Internacional 25, 1 Numérico 1 ou 0 (1 se "sim" ou 0 se "não")
1 - Produção 26, 1 Numérico 1 ou 0 
0 - Transformação 27, 1 Numérico 1 ou 0
1 - Consumo 28, 1 Numérico 1 ou 0
0 - Fabricação 29, 1 Numérico 1 ou 0
0 - Transporte 30, 1 Numérico 1 ou 0
0 - Armazenamento 31, 1 Numérico 1 ou 0
*/
 ------- Seção Demonstrativo Geral (DG) ---------
 
 select 'DG'
   from dual;

------- Seção Demonstrativo Geral (DG) -- Produto ---------
select 'PR',
       FISCAL_CLASSIFICATION.categoria NCM,
       upper(substr(msi.description,1,1)) ||
       lower(substr(msi.description,2,length(msi.description))) "Nome Comercial do Produto",
       msib.attribute3 Concentracao,
       1 densidade
  from apps.xxppg_mtl_system_items_b msib,
       apps.mtl_system_items_b       msi,
       (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('FISCAL_CLASSIFICATION')) FISCAL_CLASSIFICATION
 where msib.attribute6 = 'CONTROLADO' AND
       fiscal_classification.organization_id   = msib.organization_id and
       fiscal_classification.inventory_item_id = msib.inventory_item_id and
       msi.organization_id                     = msib.organization_id and
       msi.inventory_item_id                   = msib.inventory_item_id and
       msib.attribute3 not like '%*%' and
       msib.attribute5 = 'ITEM PRODUZIDO';
 
------- Seção Demonstrativo Geral (DG) -- Produto Composto ---------      
select 'PC',
       FISCAL_CLASSIFICATION.categoria NCM,
       upper(substr(msi.description,1,1)) ||
       lower(substr(msi.description,2,length(msi.description))) "Nome Comercial do Produto",
       1 densidade
  from apps.xxppg_mtl_system_items_b msib,
       apps.mtl_system_items_b       msi,
       (SELECT MIC.INVENTORY_ITEM_ID,
               MIC.ORGANIZATION_ID,
               MIC.CATEGORY_SET_NAME,
               MIC.CATEGORY_CONCAT_SEGS CATEGORIA
          FROM APPS.MTL_ITEM_CATEGORIES_V MIC, APPS.MTL_CATEGORIES_V MC
         WHERE MC.CATEGORY_ID = MIC.CATEGORY_ID
           AND MIC.CATEGORY_SET_NAME IN ('FISCAL_CLASSIFICATION')) FISCAL_CLASSIFICATION
 where msib.attribute6 = 'CONTROLADO' AND
       fiscal_classification.organization_id   = msib.organization_id and
       fiscal_classification.inventory_item_id = msib.inventory_item_id and
       msi.organization_id                     = msib.organization_id and
       msi.inventory_item_id                   = msib.inventory_item_id and
       msib.attribute3  like '%*%' and
       msib.attribute5 = 'ITEM PRODUZIDO';       
 
select * from apps.xxppg_mtl_system_items_b;


-------
declare
    i number;
    l_rep_item_percent_contr varchar(20);
    l_sep_percent_contr varchar(20);
l_sep_percent_contr_t

 begin
 FOR i IN 1..LENGTH (l_rep_item_percent_contr)-LENGTH(REPLACE(l_rep_item_percent_contr,'|',''))+1 LOOP
               l_sep_percent_contr   :=  regexp_substr(l_rep_item_percent_contr,'[^|]+',1,i);
               l_sep_percent_contr   :=  xxppg_1079_control_pf_pkg.F_SUM_PERCENT_RAGE_PF (l_sep_percent_contr,NULL);
               l_sep_percent_contr_t :=  l_sep_percent_contr_t + l_sep_percent_contr;
            END LOOP;
end;            
 
-------

-------

-------
-------

-------
select lookup_code
 FROM apps.fnd_lookup_values_vl flv
 WHERE flv.lookup_type = 'XXPPG_1079_PF_SUBSTANCIA' ;
