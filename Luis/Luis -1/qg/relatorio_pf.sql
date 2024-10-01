select 'EM'                          ||    -- Fixo (Empresa / Mapa)
       '10152012000101'              ||    -- CNPJ Estabelecimento
       UPPER(TO_CHAR(SYSDATE,'mon')) ||    -- Mes
       TO_CHAR(SYSDATE,'yyyy')       ||    -- Ano
       '1'                           ||      -- Comercialização Nacional
       '1'                           ||      -- Comercialização Internacional
       '1'                           ||      -- Producao
       '0'                           ||      -- Transformacao
       '0'                           ||      -- Consumo
       '0'                           ||      -- Fabricacao
       '0'                           ||      -- Transporte
       '0'  "IND"                         -- Armazenamento
        FROM dual;
       

select * from apps.mtl_parameters;